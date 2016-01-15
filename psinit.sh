#! /bin/bash
PSVERSION="1.6.1.4"
ZIPFILE=prestashop_$PSVERSION.zip
ZIPURL=https://www.prestashop.com/download/old/$ZIPFILE
PSDIR="prestashop"
CONFFILE_DEFAULT="psinit"


if [ -z "$1" ];  then
    echo "No argument supplied, trying psinit"
    
    if [ -f $CONFFILE_DEFAULT ]; then
        CONFFILE=$CONFFILE_DEFAULT
    else
       echo "Specify config file"
       exit 1;
    fi
else
    $CONFFILE="$1"
fi

echo "Dowloading $ZIPFILE"
wget -N --no-check-certificate $ZIPURL

if [ $? -ne 0 ]; then
    echo "Cannot download $ZIPFILE"
    exit 1;
fi

if [ -f $ZIPFILE ]; then
   echo "Unziping file $ZIPFILE"
   unzip -o -q $ZIPFILE
else
   echo "Cannot unzip file $ZIPFILE"
   exit 1;
fi

if [ -d "$PSDIR" ]; then
    echo "Moving files from directory $PSDIR"
    mv -f -u $PSDIR/* .
else
    echo "Cannot find directory $PSDIR"
    exit 1;
fi

echo "Installing"
cat $CONFFILE | xargs  php ./install/index_cli.php


echo "Clearing"
rm -fr ./$PSDIR
rm -fr ./install
rm -f $ZIPFILE

