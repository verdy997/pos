#! /bin/bash
let volba=2
let kolo=1
let mv1=0
let vyber=0
let pcVyber=0
let pocetBodov=0
let pocetBodovPC=0
let vyh=0
let mv2=0

function koloHra() {


        if [[ $kolo = 1 ]]
        then
                mv2=0
        fi

        if [[ $pocetBodov -lt 5 ]] && [[ $pocetBodovPC -lt 5 ]]
        then
                echo "  "
                echo "-------------------------------------"
                echo "|..............KOLO-$kolo...............|"
                echo "-------------------------------------"
                echo "  "
                echo "STAV: $nick: $pocetBodov   PC: $pocetBodovPC"
                echo "  "

                mojVyber
                mv1=$?
                echo "zadal si volbu $mv1"
                if [[ $volba = 1 ]]
                then
                        loser
                        pcVyber=$?
                elif [[ $volba = 2 ]]
                then
                        random
                        pcVyber=$?
                elif [[ $volba = 3 ]]
                then
                        cheater
                        pcVyber=$?
                else
                        thinker
                        pcVyber=$?
                        mv2=$pcVyber
                fi
                echo "super si vybral $pcVyber"
                vyhodnotenie $mv1 $pcVyber
                vyh=$?
                if [[ $vyh = 1 ]]
                then
                        pocetBodov=$(( $pocetBodov + 1 ))
                elif [[ $vyh = 3 ]]
                then
                        pocetBodovPC=$(( $pocetBodovPC + 1 ))
                fi
                echo "Pocet bodov $nick: $pocetBodov vs pocet bodov PC: $pocetBodovPC"
                kolo=$(( $kolo + 1 ))
                koloHra
                return $vyber
        else
                koniec
        fi
}

function mojVyber() {
        echo "-------------------------------------"
        read -n1 -p "Zadaj tvoju volbu [1 -  Kamen, 2 - Papier, 3 - Noznice]: " vyber
        if [[ $vyber -ne 1 ]] && [[ $vyber -ne 2 ]] && [[ $vyber -ne 3 ]]
        then
                echo -e "\nZadal si neplatnu volbu!"
                mojVyber
        fi

        return $vyber
}

function loser() {
        let pom=0
        if [[ $vyber = 1 ]]
        then
                pom=3
                return $pom
        elif [[ $vyber = 2 ]]
        then
                pom=1
                return $pom
        else
                pom=2
                return $pom
        fi
}

function random() {
        return $(( 1 + $RANDOM%3 ))
}

function cheater() {
        let vyb=0
        let pom=$(( 1 + $RANDOM%10 ))
        if [[ pom -le 6 ]]
        then
                if [[ $vyber = 1 ]]
                then
                        vyb=2
                        return $vyb
                elif [[ $vyber = 2 ]]
                then
                        vyb=3
                        return $vyb
                else
                        vyb=1
                        return $vyb
                fi
        else
                vyb=$vyber
        fi
}


function thinker() {
        let pom=$(( 1 + $RANDOM%10 ))
        if [[ $mv2 = 0 ]]
        then
                return $(( 1 + $RANDOM%3 ))
        elif [[ $mv2 = 1 ]]
        then
                if [[ $pom -le 4 ]]
                then
                        return 1
                elif [[ $pom -gt 4 ]] && [[ $pom -le 6 ]]
                then
                        return 2
                else
                        return 3
                fi
        elif [[ $mv2 = 2 ]]
        then
                if [[ $pom -le 3 ]]
                then
                        return 1
                elif [[ $pom -gt 3 ]] && [[ $pom -le 4 ]]
                then
                        return 2
                else
                        return 3
                fi
        elif [[ $mv2 = 3 ]]
        then
                if [[ $pom -le 4 ]]
                then
                        return 1
                elif [[ $pom -gt 4 ]] && [[ $pom -le 8 ]]
                then
                        return 2
                else
                        return 3
                fi
        fi
}

function vyhodnotenie() {
        if [[ ${1} = ${2} ]]
        then
                echo "REMIZA!"
                return 2
        elif [[ ${1} = 1 ]]
        then
                if [[ ${2} = 2 ]]
                then
                        echo "PREHRA! Papier zbali kamen, BOD PRE PC!"
                        return 3
                elif [[ ${2} = 3 ]]
                then
                        echo "VYHRA! Kamen nici noznice, BOD PRE $nick"
                        return 1
                fi
        elif [[ ${1} = 2 ]]
        then
                if [[ ${2} = 1 ]]
                then
                        echo "VYHRA! Papier zbali kamen, BOD PRE $nick"
                        return 1
                elif [[ ${2} = 3 ]]
                then
                        echo "PREHRA! Noznice rozstrihaju papier, BOD PRE PC!"
                        return 3
                fi
        elif [[ ${1} = 3 ]]
        then
                if [[ ${2} = 1 ]]
                then
                        echo "PREHRA! Kamen nici noznice, BOD PRE PC!"
                        return 3
                elif [[ ${2} = 2 ]]
                then
                        echo "VYHRA! Noznice rozstrihaju papier, BOD PRE $nick"
                        return 1
                fi
        fi
}

function koniec() {
echo "---------------------------------"
echo "----------KONIEC HRY!------------"
echo "---------------------------------"
echo "VYSLEDOK: $nick: $pocetBodov "
echo "          PC: $pocetBodovPC "
if [[ $pocetBodov -gt $pocetBodovPC ]]
then
        echo "VYHRA!"
else
        echo "PREHRA!"
fi

znovu="A"
read -n1 -p "Chcete hrat znovu [A/n]: " znovu
echo "ZNOVU JE $znovu"
if [[ $znovu = "A" ]] || [[ $znovu = "a" ]]
then
        vynuluj
        vyberProtivnika
else
        exit
fi
}

function vynuluj() {

let kolo=1
let mv1=0
let vyber=0
let pcVyber=0
let pocetBodov=0
let pocetBodovPC=0
let vyh=0
let mv2=0

}

function vyberProtivnika() {
echo "        "
echo "        "
echo "        "
echo "-------------------------------------"
echo "Vyber si typ protivnika: "
echo "1. loser "
echo "2. random"
echo "3. cheater"
echo "4. thinker"
echo "-------------------------------------"
read -n1 -t15 -p "Zadaj svoju volbu [1/2/3/4]: " volba

if [[ $volba = 1 ]]
then
        echo -e "\nprotivnik je loser"
        koloHra
elif [[ $volba = 2 ]]
then
        echo -e "\nprotivnik je random"
        koloHra
elif [[ $volba = 3 ]]
then
        echo -e "\nprotivnik je cheater"
        koloHra
elif [[ $volba = 4 ]]
then
        echo -e "\nprotivnik je thinker"
        koloHra
else
        echo -e "\nNezdal si nic alebo neplatny znak! Protivnik bude typ Random"
        volba=2
        koloHra
fi
}

nick="player"

echo "-------------------------------------"
echo "|Vitaj v hre Kamen, Papier, Noznice!|"
echo "-------------------------------------"
read -p "Zadaj svoj nick: " nick

vyberProtivnika


