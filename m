Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39879 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab0CWU6a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 16:58:30 -0400
Received: by bwz1 with SMTP id 1so2269822bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Mar 2010 13:58:28 -0700 (PDT)
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
From: Calvin Walton <calvin.walton@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
In-Reply-To: <4BA8CF6C.2050701@lwfinger.net>
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>
	 <201003222325.35994.mb@bu3sch.de> <4BA80118.1070801@lwfinger.net>
	 <201003230952.56207.mb@bu3sch.de>  <4BA8CF6C.2050701@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Mar 2010 16:58:22 -0400
Message-ID: <1269377903.21181.8.camel@nayuki>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 09:25 -0500, Larry Finger wrote:
> Will someone please write me udev rule(s) that do the following:
> 
> 1. Detect a MAC address of FF:FF:FF:FF:FF:FF
> 2. If this is the first time for this bus address, then generate a random MAC
> address with the bus address encoded in it.
> 3. Preserve the address for future reloads
> 4. Load the saved address into the device.
> 5. Do the above with only standard external commands - no new programs
> 
> My skills with udev are not up to the task.

I will warn you that the following is rather untested, as I don't have
any of the affected hardware (or any b43 devices at all, actually), but
something along these lines should work. There's no syntax errors, at
least :)

--- /lib/udev/rules.d/65-persistent-b43-mac-generator.rules

ACTION!="add" GOTO="persistent_b43_mac_generator_end"

SUBSYSTEM=="net", DRIVERS=="b43", ATTR{address}=="ff:ff:ff:ff:ff:ff", IMPORT{program}="write_persistent_b43_mac"

SUBSYSTEM=="net", ENV{MACADDRESS_NEW}=="?*", RUN+="ifconfig $env{INTERFACE} hw ether $env{MACADDRESS_NEW}"

LABEL="persistent_b43_mac_generator_end"

--- /lib/udev/write_persistent_b43_mac (chmod +x)

#!/bin/bash

# This mac address generation function could be replaced with something better
MACADDRESS=$(dd if=/dev/urandom bs=1 count=6 2>/dev/null | od -tx1 | head -1 | cut -d' ' -f2- | awk '{ print $1":"$2":"$3":"$4":"$5":"$6 }')

RULES_FILE='/etc/udev/rules.d/60-persistent-b43-mac.rules'

. /lib64/udev/rule_generator.functions

lock_rules_file

choose_rules_file

echo "DEVPATH==\"$DEVPATH\", DRIVERS==\"b43\", ATTR{address}==\"ff:ff:ff:ff:ff:ff\", RUN+=\"ifconfig $INTERFACE hw ether $MACADDRESS\"" >> $RULES_FILE

echo "MACADDRESS_NEW=$MACADDRESS"

unlock_rules_file

---

A new file "/etc/udev/rules.d/60-persistent-b43-mac.rules" will be
created, which will contain the the saved mac address and bypass the
generating script on future boots.

This should probably be run by the udev maintainers, but is a start,
anyways.

-- 
Calvin Walton <calvin.walton@gmail.com>

