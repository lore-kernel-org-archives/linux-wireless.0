Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48894 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0CWWCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Mar 2010 18:02:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Calvin Walton <calvin.walton@gmail.com>
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
Date: Tue, 23 Mar 2010 23:02:45 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <4BA8CF6C.2050701@lwfinger.net> <1269377903.21181.8.camel@nayuki>
In-Reply-To: <1269377903.21181.8.camel@nayuki>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201003232302.45875.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 23 March 2010 21:58:22 Calvin Walton wrote:
> On Tue, 2010-03-23 at 09:25 -0500, Larry Finger wrote:
> > Will someone please write me udev rule(s) that do the following:
> > 
> > 1. Detect a MAC address of FF:FF:FF:FF:FF:FF
> > 2. If this is the first time for this bus address, then generate a random MAC
> > address with the bus address encoded in it.
> > 3. Preserve the address for future reloads
> > 4. Load the saved address into the device.
> > 5. Do the above with only standard external commands - no new programs
> > 
> > My skills with udev are not up to the task.
> 
> I will warn you that the following is rather untested, as I don't have
> any of the affected hardware (or any b43 devices at all, actually), but
> something along these lines should work. There's no syntax errors, at
> least :)
> 
> --- /lib/udev/rules.d/65-persistent-b43-mac-generator.rules
> 
> ACTION!="add" GOTO="persistent_b43_mac_generator_end"
> 
> SUBSYSTEM=="net", DRIVERS=="b43", ATTR{address}=="ff:ff:ff:ff:ff:ff", IMPORT{program}="write_persistent_b43_mac"
> 
> SUBSYSTEM=="net", ENV{MACADDRESS_NEW}=="?*", RUN+="ifconfig $env{INTERFACE} hw ether $env{MACADDRESS_NEW}"
> 
> LABEL="persistent_b43_mac_generator_end"
> 
> --- /lib/udev/write_persistent_b43_mac (chmod +x)
> 
> #!/bin/bash
> 
> # This mac address generation function could be replaced with something better
> MACADDRESS=$(dd if=/dev/urandom bs=1 count=6 2>/dev/null | od -tx1 | head -1 | cut -d' ' -f2- | awk '{ print $1":"$2":"$3":"$4":"$5":"$6 }')
> 
> RULES_FILE='/etc/udev/rules.d/60-persistent-b43-mac.rules'
> 
> . /lib64/udev/rule_generator.functions
> 
> lock_rules_file
> 
> choose_rules_file
> 
> echo "DEVPATH==\"$DEVPATH\", DRIVERS==\"b43\", ATTR{address}==\"ff:ff:ff:ff:ff:ff\", RUN+=\"ifconfig $INTERFACE hw ether $MACADDRESS\"" >> $RULES_FILE
> 
> echo "MACADDRESS_NEW=$MACADDRESS"
> 
> unlock_rules_file
> 
> ---
> 
> A new file "/etc/udev/rules.d/60-persistent-b43-mac.rules" will be
> created, which will contain the the saved mac address and bypass the
> generating script on future boots.
> 
> This should probably be run by the udev maintainers, but is a start,
> anyways.
> 
> 

Thanks a lot for this proof of concept. This looks very nice.

-- 
Greetings, Michael.
