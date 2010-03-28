Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:56815 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754829Ab0C1ROU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 13:14:20 -0400
Message-ID: <4BAF8E62.4060902@free.fr>
Date: Sun, 28 Mar 2010 19:14:10 +0200
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= <nicolas.2p.debian@free.fr>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>	<1269377903.21181.8.camel@nayuki> <4BAA1EA3.9060803@lwfinger.net>	<201003242021.39502.mb@bu3sch.de> <4BAC2E36.8000900@lwfinger.net>
In-Reply-To: <4BAC2E36.8000900@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 03/24/2010 02:21 PM, Michael Buesch wrote:
>> On Wednesday 24 March 2010 15:16:03 Larry Finger wrote:
>>> I have modified ssb to supply a MAC address of 80:80:80:80:80:80, rather than
>> What about also setting the local-assignment bit for this temporary address?
>>
>>> The one remaining problem is that the interface has already been renamed before
>>> 60-persistent-b43-mac.rules is processed. In my case, the interface is wlan13,
>>> not wlan0. After I manually modified 60-..., then the new address is applied.
>>> I'm still working on this problem.
>> Well, udev scripts are processed in alphabetical order. Can't you simply run
>> the persistent mac rules before the persistent ifname rules?
> 
> I finally figured out the problem I was having. The address attribute was not
> being changed by the "ifconfig" call that changed the hardware address. The fix
> is to create a new environment when the hardware address and lock out the rule
> generation process when that value is detected. The new code for
> /lib/udev/rules.d/65-persistent-b43-mac-generator.rules is as follows (Note:
> These files are line-wrapped here.):
> 
> #=======================================
> #
> # Rules file to assign a unique, permanent address to BCM43XX devices without
> # an SPROM.
> #
> # Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
> # Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>
> 
> # skip this code if action is not add, i.e. change or remove
> 
> ACTION!="add", GOTO="persistent_b43_mac_generator_end"
> 
> # Use the value of the MAC_CHANGED environment variable to see if the address
> # has already been changed.
> 
> ENV{MAC_CHANGED}=="yes", GOTO="persistent_b43_mac_generator_end"
> 
> # Call script to get a random address - if this device previously encountered,
> # the address will already have been changed.
> 
> SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82",
> IMPORT{program}="write_persistent_b43_mac"
> 
> # Apply the new hardware address returned by the script
> 
> SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82", RUN+="/sbin/ifconfig
> $env{INTERFACE} hw ether $env{MACADDRESS_NEW}"

Why do you use ifconfig hw ether instead of ip link set address ?

> LABEL="persistent_b43_mac_generator_end"
> #=======================================
> 
> The code for /lib/udev/write_persistent_b43_mac is as follows:
> 
> #=======================================
> #!/bin/bash
> 
> # Script to Generate a random MAC address for a BCM43XX device without
> # an SPROM.
> #
> # Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
> # Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>
> 
> # Use /dev/urandom to generate the last 5 bytes of the address.
> # Make the first byte 2 to avoid generating a multicast address and to set
> #  the locally administered address bit.
> 
> MACADDRESS=$(/bin/dd if=/dev/urandom bs=1 count=5 2>/dev/null | /usr/bin/od -tx1
> | /usr/bin/head -1 | \
> /usr/bin/cut -d' ' -f2- | /usr/bin/awk '{ print "02:"$1":"$2":"$3":"$4":"$5 }')

A suggest the following :

- 6 bytes of randomness and force lower half of first byte to 2 if the value does not have bit #2 set.
- sed, instead of head|cut|awk

MACADDRESS=$(/bin/dd if=/dev/random bs=1 count=6 2>/dev/null | /usr/bin/od -tx1 |
   sed -ne '1{;s/0000000 //;s/^\(.\)[014589cd]/\12/;y/ /:/;p}'

> # Define the output rules file
> RULES_FILE='/etc/udev/rules.d/60-persistent-b43-mac.rules'
> 
> . /lib/udev/rule_generator.functions
> 
> # Prevent concurrent processes from modifying the file at the same time.
> lock_rules_file
> 
> # Check if the rules file is writeable.
> choose_rules_file
> 
> # The rule should apply for all wlan devices -s some other wireless driver might
> # be loaded first - change wlanNN to wlan*
> GEN_PATH=$(echo $DEVPATH | /usr/bin/sed s/wlan[0-9]*/wlan*/)

sed should be quoted here : /usr/bin/sed -e 's/wlan[0-9]*/wlan*/'
Else, it might be fun if you happen to have a file called s/wlan7/wlan15 in current directory.

> # Output new rule
> echo "SUBSYSTEM==\"net\", DEVPATH==\"$GEN_PATH\",
> ATTR{address}==\"82:82:82:82:82:82\", ENV{MAC_CHANGED}=\"yes\",
> RUN+=\"/sbin/ifconfig \$env{INTERFACE} hw ether $MACADDRESS\"" >> $RULES_FILE

If DEVPATH is "generic" (wlan*), how would you distinguish between two broadcom NIC present in the 
system, both without an SPROM ?

	Nicolas.

> 
> # Report the new address back to the caller who will set the address for this
> new interface
> echo "MACADDRESS_NEW=$MACADDRESS"
> 
> unlock_rules_file
> 
> exit 0
> #=======================================
> 
> Is there a location to put a tar file containing the script and rules files?
> 
> Larry
> _______________________________________________
> Bcm43xx-dev mailing list
> Bcm43xx-dev@lists.berlios.de
> https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> 

