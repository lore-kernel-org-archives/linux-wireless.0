Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:59237 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752123AbZBUOzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 09:55:46 -0500
To: Adam Baker <linux@baker-net.org.uk>
cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
In-reply-to: <200902202307.34035.linux@baker-net.org.uk>
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org> <200902192316.11628.linux@baker-net.org.uk> <20090220074716.9AB622C4090@tippex.mynet.homeunix.org> <200902202307.34035.linux@baker-net.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 21 Feb 2009 15:55:28 +0100
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20090221145528.5B11B2C4090@tippex.mynet.homeunix.org> (sfid-20090221_155551_553075_7FE867C3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


linux@baker-net.org.uk said:
> rmmod / modprobe not working isn't a good sign. After a modprobe there is a
> pretty comprehensive reconfigure. When you say you currently have to power
> cycle, have you also tried a reboot 

I'll make another go at rmmod/modprobe at the next event to make sure.


linux@baker-net.org.uk said:
> and have a look in there under ieee80211/phy0/rt2500pci for first. Probable
> the most useful thing there is the queue counters which should let you see if
>  the card is

> a) trying to transmit anything 
> b) receiving anything

Done that. I currently have:

chipset:rt chip: 0201
chipset:rf chip: 0003
chipset:revision:00000004
chipset:
chipset:csr length: 93
chipset:eeprom length: 256
chipset:bbp length: 64
chipset:rf length: 5
dev_flags:0x00000a2f
driver:driver: rt2500pci
driver:version: 2.2.3
driver:compiled: Feb 21 2009 15:31:04
Binary file queue/dump matches
queue/queue:qid count   limit   length  index   done    crypto
queue/queue:14  0       24      6612    12      0       0
queue/queue:0   22      24      0       22      22      0
queue/queue:1   707     24      0       11      11      0
queue/queue:16  0       1       0       0       0       0
queue/queue:17  0       8       0       0       0       0
register/bbp_offset:0
register/bbp_value:0x12
register/csr_offset:0
register/csr_value:0x00000004
register/eeprom_offset:0
register/eeprom_value:0x2560
register/rf_offset:0
register/rf_value:0x00000000

What should I look out for wrt the queue counters?

> Would be good to know if the legacy driver has the same issue - if it does
> that might point to a hardware fault. 

Is that still maintained and working with new kernels? I recall needing to 
have different a different config setup for with the legacy driver (other 
name, and whatnot), so it's been a while.

This is a "once is a week" bug, so it's hard to say for sure when it's working 
correctly. If you really want me to, I could try the legay one for a couple 
of weeks...

/Anders


