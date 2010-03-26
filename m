Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51168 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZDrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 23:47:07 -0400
Received: by pwi5 with SMTP id 5so4807802pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 20:47:06 -0700 (PDT)
Message-ID: <4BAC2E36.8000900@lwfinger.net>
Date: Thu, 25 Mar 2010 22:47:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de,
	Calvin Walton <calvin.walton@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269377903.21181.8.camel@nayuki> <4BAA1EA3.9060803@lwfinger.net> <201003242021.39502.mb@bu3sch.de>
In-Reply-To: <201003242021.39502.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2010 02:21 PM, Michael Buesch wrote:
> On Wednesday 24 March 2010 15:16:03 Larry Finger wrote:
>> I have modified ssb to supply a MAC address of 80:80:80:80:80:80, rather than
> 
> What about also setting the local-assignment bit for this temporary address?
> 
>> The one remaining problem is that the interface has already been renamed before
>> 60-persistent-b43-mac.rules is processed. In my case, the interface is wlan13,
>> not wlan0. After I manually modified 60-..., then the new address is applied.
>> I'm still working on this problem.
> 
> Well, udev scripts are processed in alphabetical order. Can't you simply run
> the persistent mac rules before the persistent ifname rules?

I finally figured out the problem I was having. The address attribute was not
being changed by the "ifconfig" call that changed the hardware address. The fix
is to create a new environment when the hardware address and lock out the rule
generation process when that value is detected. The new code for
/lib/udev/rules.d/65-persistent-b43-mac-generator.rules is as follows (Note:
These files are line-wrapped here.):

#=======================================
#
# Rules file to assign a unique, permanent address to BCM43XX devices without
# an SPROM.
#
# Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
# Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>

# skip this code if action is not add, i.e. change or remove

ACTION!="add", GOTO="persistent_b43_mac_generator_end"

# Use the value of the MAC_CHANGED environment variable to see if the address
# has already been changed.

ENV{MAC_CHANGED}=="yes", GOTO="persistent_b43_mac_generator_end"

# Call script to get a random address - if this device previously encountered,
# the address will already have been changed.

SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82",
IMPORT{program}="write_persistent_b43_mac"

# Apply the new hardware address returned by the script

SUBSYSTEM=="net", ATTR{address}=="82:82:82:82:82:82", RUN+="/sbin/ifconfig
$env{INTERFACE} hw ether $env{MACADDRESS_NEW}"

LABEL="persistent_b43_mac_generator_end"
#=======================================

The code for /lib/udev/write_persistent_b43_mac is as follows:

#=======================================
#!/bin/bash

# Script to Generate a random MAC address for a BCM43XX device without
# an SPROM.
#
# Copyright (c) 2010 by Calvin Walton <calvin.walton@gmail.com>
# Copyright (c) 2010 by Larry Finger <Larry.Finger@lwfinger.net>

# Use /dev/urandom to generate the last 5 bytes of the address.
# Make the first byte 2 to avoid generating a multicast address and to set
#  the locally administered address bit.

MACADDRESS=$(/bin/dd if=/dev/urandom bs=1 count=5 2>/dev/null | /usr/bin/od -tx1
| /usr/bin/head -1 | \
/usr/bin/cut -d' ' -f2- | /usr/bin/awk '{ print "02:"$1":"$2":"$3":"$4":"$5 }')

# Define the output rules file
RULES_FILE='/etc/udev/rules.d/60-persistent-b43-mac.rules'

. /lib/udev/rule_generator.functions

# Prevent concurrent processes from modifying the file at the same time.
lock_rules_file

# Check if the rules file is writeable.
choose_rules_file

# The rule should apply for all wlan devices -s some other wireless driver might
# be loaded first - change wlanNN to wlan*
GEN_PATH=$(echo $DEVPATH | /usr/bin/sed s/wlan[0-9]*/wlan*/)

# Output new rule
echo "SUBSYSTEM==\"net\", DEVPATH==\"$GEN_PATH\",
ATTR{address}==\"82:82:82:82:82:82\", ENV{MAC_CHANGED}=\"yes\",
RUN+=\"/sbin/ifconfig \$env{INTERFACE} hw ether $MACADDRESS\"" >> $RULES_FILE

# Report the new address back to the caller who will set the address for this
new interface
echo "MACADDRESS_NEW=$MACADDRESS"

unlock_rules_file

exit 0
#=======================================

Is there a location to put a tar file containing the script and rules files?

Larry
