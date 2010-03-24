Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f176.google.com ([209.85.223.176]:65009 "EHLO
	mail-iw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab0CXOQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 10:16:08 -0400
Received: by iwn6 with SMTP id 6so2684751iwn.4
        for <linux-wireless@vger.kernel.org>; Wed, 24 Mar 2010 07:16:07 -0700 (PDT)
Message-ID: <4BAA1EA3.9060803@lwfinger.net>
Date: Wed, 24 Mar 2010 09:16:03 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@gmail.com>
CC: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net>	 <201003222325.35994.mb@bu3sch.de> <4BA80118.1070801@lwfinger.net>	 <201003230952.56207.mb@bu3sch.de>  <4BA8CF6C.2050701@lwfinger.net> <1269377903.21181.8.camel@nayuki>
In-Reply-To: <1269377903.21181.8.camel@nayuki>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/23/2010 03:58 PM, Calvin Walton wrote:
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

Thanks for the really good start.

The above routines have a minor problem in that using a random value for the
first byte of the MAC address runs the risk of having the multicast bit set. By
fixing the first one to a multiple of 4, that problem is avoided.

A second minor problem is that the full path must be given for all standard
utilities, otherwise they are assumed to be in /lib/udev. Thus all references to
"ifconfig" were replaced by "/sbin/ifconfig". I hope all distros put ifconfig in
/sbin.

I have modified ssb to supply a MAC address of 80:80:80:80:80:80, rather than
FF:FF:FF:FF:FF:FF. This way the interface can come up even though the new udev
routines are not available. When b43 detects that address, it will log a message
describing why the udev routines are needed, and how to obtain them.

The one remaining problem is that the interface has already been renamed before
60-persistent-b43-mac.rules is processed. In my case, the interface is wlan13,
not wlan0. After I manually modified 60-..., then the new address is applied.
I'm still working on this problem.

Thanks again for the help.

Larry
