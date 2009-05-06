Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc2-s25.blu0.hotmail.com ([65.55.111.100]:28551 "EHLO
	blu0-omc2-s25.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750996AbZEFQpd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 12:45:33 -0400
Message-ID: <BLU0-SMTP609AAD39FAACE615C91C30C2660@phx.gbl>
Date: Wed, 06 May 2009 11:45:31 -0500
From: Brett Ussher <breusshe@hotmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Problem with compat-wireless for 2009-05-06
Content-Type: multipart/mixed;
 boundary="------------060903030302000303030104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060903030302000303030104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Downloaded and tried to install compat-wireless-2009-05-06.tar.bz2.  
Downloaded fine.  Make went fine, make install had an issue.  When it 
would run "athenable ath5k" portion of the make install, it would go 
into a loop trying to mv a .ko file.  I made a change to the modlib.sh 
file that seems to have fixed the issue.  The problem was that the path 
modlib.sh was generating the following output:

/lib/modules/2.6.27-11-generic/updates/drivers/net/wireless/ath/ath5k/ath5k.ko
Disabling ath5k ...mv: cannot stat 
`/lib/modules/2.6.27-11-generic//lib/modules/2.6.27-11-generic/updates/drivers/net/wireless/ath/ath5k/ath5k.ko': 
No such file or directory
[ERROR]    Module is still being detected:

Notice the double use of the "/lib/modules/2.6.27-11-generic/" path in 
the second line of the output.  I have commented out line 41 of 
modlib.sh and added line 42:

#        mv -f /lib/modules/$VER/$CHECK 
/lib/modules/$VER/${CHECK}${IGNORE_SUFFIX}
        mv -f $CHECK ${CHECK}${IGNORE_SUFFIX}

This change seems to have fix athenable.  I think the reason for the 
repeated path output is that $CHECK uses "modprobe -l" which gives a 
full path output for the driver file it finds, thus, "/lib/modules/$VER" 
is not required in line 41.

While looking at this problem, I found another in the iwl-enable 
script.  Actually, two.  The USAGE statement uses $IWL, not $IWL_NEW at 
line 20.  Also, at line 38 (39 in attached copy) $MODULE is doing a 
string match with "iwl4954", not "iwl4965".  I've commented out these 
two lines and made corrects on the line below them (lines 21 and 40 in 
attached copy).

I also discovered that the module_enable function in modlib.sh didn't 
work right.  Since I'm using compat-wireless, the drivers are being 
installed to the "update" folder, not "kernel" in the 
"/lib/modules/`uname -r`" folder.  However, somebody at the end of the 
enable_module function put in a break with a comment above it stating, 
"Lets only do this for the first module found".  Well, that means the 
module in the "kernel" folder is enabled, but not the one in the the 
"update" folder.  That means the module will not load (incompatible 
versions).  I have commented out this break statement on line 86 (in 
attached copy of modlib.sh).  It works fine now.

Hope these changes help.

-- 
Brett D. Ussher


--------------060903030302000303030104
Content-Type: text/plain;
 name="iwl-enable"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwl-enable"

#!/bin/bash
#
# Copyright 2007	Luis R. Rodriguez <lrodriguez@atheros.com>
#
# Makes sure either iwlagn (new) or iwl4965 (old)
# is enabled to be used. This allows us to choose any driver without 
# blacklisting each other.

. /usr/lib/compat-wireless/modlib.sh

if [[ $UID -ne 0 ]]; then
	echo "Run with root privileges"
	exit
fi

IWL_NEW="iwlagn"
IWL_OLD="iwl4965"

# Appended to module file at the end when we want to ignore one
#USAGE="Usage: $0 [ $IWL | $IWL_OLD ]"
USAGE="Usage: $0 [ $IWL_NEW | $IWL_OLD ]"
function enable_iwlagn {
	module_disable $IWL_OLD
	for i in $IWL_NEW; do
		module_enable $i
	done
}

# Default behavior: disables the old iwl4965 driver and enables iwlagn
if [ $# -eq 0 ]; then
	enable_iwlagn
	exit
elif [ $# -ne 1 ]; then
	echo "$USAGE"
	exit
fi

MODULE=$1
#if [ "$MODULE" == "iwl4954" ]; then
if [ "$MODULE" == "iwl4965" ]; then
	module_disable $IWL_NEW
	module_enable $IWL_OLD
elif [ "$MODULE" == "iwlagn" ]; then
	enable_iwlagn
else
	echo "$USAGE"
	exit
fi

--------------060903030302000303030104
Content-Type: application/x-sh;
 name="modlib.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="modlib.sh"

#!/bin/bash
#
# Copyright 2007	Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
#
# You can use these to enable/disable modules without blacklisting them

# Make sure our imporant paths are included
PATH=$PATH:/usr/sbin:/sbin

# Appended to module file at the end when we want to ignore one
IGNORE_SUFFIX=".ignore"
VER=`uname -r`

# If 'module' is found, its renamed to 'module.ignore'
function module_disable {
	# Basic check to see if this is a module available for loading
	MODULE_CHECK=`modprobe -l $1`
	if [ -z $MODULE_CHECK ]; then
		echo "Module $1 not detected -- this is fine"
		return
	fi
	MODULE=$1
	MODULE_KO=${MODULE}.ko
	# In case there are more than one of these modules. This can 
	# happen, for example if your distribution provides one and you have
	# compiled one in yourself later.
	MODULE_COUNT=`find /lib/modules/$VER/ -name $MODULE_KO | wc -l`
	ALL_MODULES=`find /lib/modules/$VER/ -name $MODULE_KO`
	COUNT=1
	CHECK=`modprobe -l $MODULE`
	while  [ ! -z $CHECK ]; do
		if [[ $MODULE_COUNT -gt 1 ]]; then
			if [[ $COUNT -eq 1 ]]; then
				echo -en "$MODULE_COUNT $MODULE modules found "
				echo -e "we'll disable all of them"
			fi
			echo -en "Disabling $MODULE ($COUNT) ..."
		else
			echo -en "Disabling $MODULE ..."
		fi
#		mv -f /lib/modules/$VER/$CHECK /lib/modules/$VER/${CHECK}${IGNORE_SUFFIX}
		mv -f $CHECK ${CHECK}${IGNORE_SUFFIX}
		depmod -ae
		CHECK_AGAIN=`modprobe -l $MODULE`
		if [ "$CHECK" != "$CHECK_AGAIN" ]; then
			echo -e "\t[OK]\tModule disabled:"
			echo "$CHECK"
		else
			echo -e "[ERROR]\tModule is still being detected:"
			echo "$CHECK"
		fi
		let COUNT=$COUNT+1
		CHECK=$CHECK_AGAIN
	done
}

# If 'module.ignore' is found, rename it back to 'module'
function module_enable {
	MODULE=$1
	MODULE_KO=${MODULE}.ko
	IGNORED_MODULE=${MODULE_KO}${IGNORE_SUFFIX}
	# In case there are more than one of these modules. This can 
	# happen, for example if your distribution provides one and you have
	# compiled one in yourself later.
	ALL_MODULES=`find /lib/modules/$VER/ -name $IGNORED_MODULE`
	for i in $ALL_MODULES; do
		echo -en "Enabling $MODULE ..."
		DIR=`dirname $i`
		mv $i $DIR/$MODULE_KO
		depmod -ae
		CHECK=`modprobe -l $MODULE`
		if [ "$DIR/$MODULE_KO" != $CHECK ]; then
			if [ -z $CHECK ]; then
				echo -e "\t[ERROR]\tModule could not be enabled"
			else
				echo -en "\t[OK]\tModule renamed but another "
				echo "module file is being preferred"
				echo -e "Renamed module:\t\t$DIR/$MODULE_KO"
				echo -e "Preferred module:\t$CHECK"
			fi
		else
			echo -e "\t[OK]\tModule enabled: "
			echo "$DIR/$MODULE_KO"
		fi
		# Lets only do this for the first module found
#		break
	done
}


--------------060903030302000303030104--
