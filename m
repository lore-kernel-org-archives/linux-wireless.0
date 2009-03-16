Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:41412 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbZCPO6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 10:58:07 -0400
Received: by ewy25 with SMTP id 25so3498623ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 07:58:03 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: =?iso-8859-1?q?Ant=F3nio_Marques?= <froz@icix.org>
Subject: Re: rt2x00 mesh support
Date: Mon, 16 Mar 2009 15:58:00 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903151445.01344.IvDoorn@gmail.com> <F3209A42-65EA-4F71-8443-67E2F8CAFA3F@icix.org>
In-Reply-To: <F3209A42-65EA-4F71-8443-67E2F8CAFA3F@icix.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5jmvJTR1bTrDRqy"
Message-Id: <200903161558.01070.IvDoorn@gmail.com> (sfid-20090316_155811_934660_87A45CBE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_5jmvJTR1bTrDRqy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 16 March 2009, Ant=F3nio Marques wrote:
> On Mar 15, 2009, at 13:45 , Ivo van Doorn wrote:
> > On Sunday 15 March 2009, Antonio Marques wrote:
> >> Upon further investigation, beaconing does not work after configuring
> >> an interface in mesh point mode but running 'iwlist mesh scan'
> >> triggers something in the driver that enables beaconing.
> >> After executing this command beacons are generated and correctly
> >> received at other nodes.
> >
> > Thats odd, but very interesting :)
> > Could you enable debugfs and CONFIG_RT2X00_LIB_DEBUGFS and
> > use the script from http://kernel.org/pub/linux/kernel/people/ivd/tools=
/rt2x00_regdump.sh
> > to create a register dump before running 'iwlist mesh scan' and =20
> > afterwards.
> > (So basically when beaconing is broken and when it is working).
> >
> > Thanks,
> >
> > Ivo
>=20
>=20
> As requested, I have attached the output of the script run before and =20
> after
> running 'iwlist mesh scan'. Unfortunately there seems to be no change in
> the output. I have also included the queue statistics as these do =20
> change from
> one state to the next. Any further pointers to help debug this? I'll =20
> gladly test
> any patches that try to address this issue.

The dumps aren't correct, I had forgotten to update the script on the websi=
te
after some API for the rt2x00 debugfs interface changes recently.
Attached is the correct patch.

Ivo

--Boundary-00=_5jmvJTR1bTrDRqy
Content-Type: application/x-shellscript;
  name="rt2x00_regdump.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt2x00_regdump.sh"

#!/bin/bash

#
# Copyright (C) 2008 Ivo van Doorn <IvDoorn@gmail.com>
#
# This script can be used to dump the contents of the rt2x00
# registers which are found in debugfs.
#

#
# regexp matches for mac80211 interfaces and the rt2x00 drivers
#
MAC80211_REGEXP='phy*'
RT2X00_REGEXP='rt[0-9]*'

#
# Find where debugfs is mounted, when it isn't we might as well
# bail out immediately.
#
DEBUG_ROOT=`grep debugfs /proc/mounts | cut -d' ' -f2 | head -n 1`
if [ -z ${DEBUG_ROOT} ]; then
	echo "debugfs not mounted!"
	exit 1
fi

#
# When no argument is given, we are looping over all mac80211 interfaces
# which contain a valid rt2x00 entry (a folder which matches RT2X00_REGEXP).
# If an argument is given, we check if it is a directory, if that is the case,
# we try to use that as root for the register dump. Otherwise we check the
# argument against MAC80211_REGEXP and RT2X00_REGEXP to limit the number
# of interfaces to check. When the argument matches MAC80211_REGEXP we only
# need to loop that interface, while when it matches RT2X00_REGEXP we must
# loop over all interfaces for that driver.
#
if [ -z ${1} ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${MAC80211_REGEXP}/${RT2X00_REGEXP}/
elif [ -d ${1} ]; then
	DEBUG_ROOT_RT2X00=${1}/
elif [ `expr "${1}" : "${RT2X00_REGEXP}"` -gt 0 ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${MAC80211_REGEXP}/${1}/
elif [ `expr "${1}" : "${MAC80211_REGEXP}"` -gt 0 ]; then
	DEBUG_ROOT_RT2X00=${DEBUG_ROOT}/ieee80211/${1}/${RT2X00_REGEXP}/
else
	echo "Unknown argument: ${1}"
fi

function doPrint()
{
	REGISTER_DIR=${1}/register
	CHIPSET_FILE=${1}/chipset
	DRIVER_FILE=${1}/driver
	FLAGS_FILE=${1}/dev_flags

	echo -n "kernel: "
	uname -r
	cat ${DRIVER_FILE}
	echo -n "dev_flags: "
	cat ${FLAGS_FILE}
	cat ${CHIPSET_FILE}

	#
	# All register statistics is formatted as:
	# name	base	words	wordsize
	#
	while read line
	do
		IFS=":"
		DATA=( $line )

		echo -e "\n${DATA[0]}"
		for (( x=0; x<${DATA[1]}; x=x+1 )); do
			echo $x > "${REGISTER_DIR}/${DATA[0]}_offset"
			echo -n $x :
			cat "${REGISTER_DIR}/${DATA[0]}_value"
		done
	done < <(awk --posix '/^[a-zA-Z]+(\t[0-9]+){3}$/ { print $1":"$3 }' ${CHIPSET_FILE})

	echo -e "\n"
}

for entry in `ls -d1 ${DEBUG_ROOT_RT2X00}`; do
	doPrint ${entry}
done

--Boundary-00=_5jmvJTR1bTrDRqy--
