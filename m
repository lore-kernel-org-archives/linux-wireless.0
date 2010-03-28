Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:39539 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754900Ab0C1TEh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 15:04:37 -0400
Message-ID: <4BAFA83B.8050505@free.fr>
Date: Sun, 28 Mar 2010 21:04:27 +0200
From: =?ISO-8859-1?Q?Nicolas_de_Peslo=FCan?= <nicolas.2p.debian@free.fr>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Michael Buesch <mb@bu3sch.de>,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>	<1269377903.21181.8.camel@nayuki> <4BAA1EA3.9060803@lwfinger.net>	<201003242021.39502.mb@bu3sch.de> <4BAC2E36.8000900@lwfinger.net> <4BAF8E62.4060902@free.fr> <4BAF9F11.6050802@lwfinger.net>
In-Reply-To: <4BAF9F11.6050802@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> On 03/28/2010 12:14 PM, Nicolas de Pesloüan wrote:
>> Larry Finger wrote:
>>> On 03/24/2010 02:21 PM, Michael Buesch wrote:
>>>> On Wednesday 24 March 2010 15:16:03 Larry Finger wrote:
>>>>> I have modified ssb to supply a MAC address of 80:80:80:80:80:80,
>>>>> rather than
>>>> What about also setting the local-assignment bit for this temporary
>>>> address?
>>>>
>>>>> The one remaining problem is that the interface has already been
>>>>> renamed before
>>>>> 60-persistent-b43-mac.rules is processed. In my case, the interface
>>>>> is wlan13,
>>>>> not wlan0. After I manually modified 60-..., then the new address is
>>>>> applied.
>>>>> I'm still working on this problem.
>>>> Well, udev scripts are processed in alphabetical order. Can't you
>>>> simply run
>>>> the persistent mac rules before the persistent ifname rules?
>>> I finally figured out the problem I was having. The address attribute
>>> was not
>>> being changed by the "ifconfig" call that changed the hardware
>>> address. The fix
>>> is to create a new environment when the hardware address and lock out
>>> the rule
>>> generation process when that value is detected. The new code for
>>> /lib/udev/rules.d/65-persistent-b43-mac-generator.rules is as follows
>>> (Note:
>>> These files are line-wrapped here.):
>>>
>>> #=======================================
>>> #
>>> # Rules file to assign a unique, permanent address to BCM43XX devices
>>> without
>>> # an SPROM.
>>> #
>>> # Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
>>> # Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>
>>>
>>> # skip this code if action is not add, i.e. change or remove
>>>
>>> ACTION!="add", GOTO="persistent_b43_mac_generator_end"
>>>
>>> # Use the value of the MAC_CHANGED environment variable to see if the
>>> address
>>> # has already been changed.
>>>
>>> ENV{MAC_CHANGED}=="yes", GOTO="persistent_b43_mac_generator_end"
>>>
>>> # Call script to get a random address - if this device previously
>>> encountered,
>>> # the address will already have been changed.
>>>
>>> SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82",
>>> IMPORT{program}="write_persistent_b43_mac"
>>>
>>> # Apply the new hardware address returned by the script
>>>
>>> SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82",
>>> RUN+="/sbin/ifconfig
>>> $env{INTERFACE} hw ether $env{MACADDRESS_NEW}"
>> Why do you use ifconfig hw ether instead of ip link set address ?
>>
>>> LABEL="persistent_b43_mac_generator_end"
>>> #=======================================
>>>
>>> The code for /lib/udev/write_persistent_b43_mac is as follows:
>>>
>>> #=======================================
>>> #!/bin/bash
>>>
>>> # Script to Generate a random MAC address for a BCM43XX device without
>>> # an SPROM.
>>> #
>>> # Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
>>> # Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>
>>>
>>> # Use /dev/urandom to generate the last 5 bytes of the address.
>>> # Make the first byte 2 to avoid generating a multicast address and to
>>> set
>>> #  the locally administered address bit.
>>>
>>> MACADDRESS=$(/bin/dd if=/dev/urandom bs=1 count=5 2>/dev/null |
>>> /usr/bin/od -tx1
>>> | /usr/bin/head -1 | \
>>> /usr/bin/cut -d' ' -f2- | /usr/bin/awk '{ print
>>> "02:"$1":"$2":"$3":"$4":"$5 }')
>> A suggest the following :
>>
>> - 6 bytes of randomness and force lower half of first byte to 2 if the
>> value does not have bit #2 set.
>> - sed, instead of head|cut|awk
>>
>> MACADDRESS=$(/bin/dd if=/dev/random bs=1 count=6 2>/dev/null |
>> /usr/bin/od -tx1 |
>>   sed -ne '1{;s/0000000 //;s/^\(.\)[014589cd]/\12/;y/ /:/;p}'
> 
> It also needs to be even as an odd value would be a broadcast address. Using
> only sed instead of head|cut|awk does have merit and the randomness is increased
> by 6 bits. It will take me a while to understand the sed here. Regular
> expressions are not my thing.

Yes, you are right, so I need to change a few things, in order to keep the highest possible level of 
randomness while ensuring the lower half of first byte is 2, 6, a or e.

dd if=/dev/random bs=1 count=6 2>/dev/null |
od -tx1 |
sed -ne '1{;s/0000000 //;
s/^\(.\)[013]/\12/;s/^\(.\)[457]/\16/;
s/^\(.\)[89b]/\1a/;s/^\(.\)[cdf]/\1e/;
y/ /:/;p}'

Translation to humain form :

# for the first line only,
# 	If second char is 0, 1 or 3, replace it with 2.
#	If second char is 4, 5 or 7, replace it with 6.
#	If second char is 8, 9 or b, replace it with a.
#	If second char is c, d or f, replace it with e.
#	Replace all spaces with ':'.
#	print
# Print nothing for other lines, thanks to -n option.

> 
>>> # Define the output rules file
>>> RULES_FILE='/etc/udev/rules.d/60-persistent-b43-mac.rules'
>>>
>>> . /lib/udev/rule_generator.functions
>>>
>>> # Prevent concurrent processes from modifying the file at the same time.
>>> lock_rules_file
>>>
>>> # Check if the rules file is writeable.
>>> choose_rules_file
>>>
>>> # The rule should apply for all wlan devices -s some other wireless
>>> driver might
>>> # be loaded first - change wlanNN to wlan*
>>> GEN_PATH=$(echo $DEVPATH | /usr/bin/sed s/wlan[0-9]*/wlan*/)
>> sed should be quoted here : /usr/bin/sed -e 's/wlan[0-9]*/wlan*/'
>> Else, it might be fun if you happen to have a file called s/wlan7/wlan15
>> in current directory.
> 
> OK - I see your point. As the current directory is /lib/udev, the presence of
> such a file is unlikely, but better to protect against the problem.
> 
>>> # Output new rule
>>> echo "SUBSYSTEM==\"net\", DEVPATH==\"$GEN_PATH\",
>>> ATTR{address}==\"82:82:82:82:82:82\", ENV{MAC_CHANGED}=\"yes\",
>>> RUN+=\"/sbin/ifconfig \$env{INTERFACE} hw ether $MACADDRESS\"" >>
>>> $RULES_FILE
>> If DEVPATH is "generic" (wlan*), how would you distinguish between two
>> broadcom NIC present in the system, both without an SPROM ?
> 
> That is covered by the /devices/pci0000:00/0000:00:0d.0/0000:04:00.0/... part of
> DEVPATH. A second device on the same bridge would have ...04:01.0... and a
> device on a different bridge would change some other part of the string. The
> change to wlan* handles the case where the BCM43XX device is discovered first
> with some configuration, and second when another device is plugged in at
> discovery time.

Ok, sounds good for me. Did you had the opportunity to test with two such devices ?
> 
> Larry
> 
