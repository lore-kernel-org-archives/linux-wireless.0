Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:55909
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752412AbZBSX0h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 18:26:37 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] No ProbeResp == dead interface?
Date: Thu, 19 Feb 2009 23:16:11 +0000
Cc: Anders Eriksson <aeriksson@fastmail.fm>,
	linux-wireless@vger.kernel.org
References: <20090218205849.5723293CD93@tippex.mynet.homeunix.org>
In-Reply-To: <20090218205849.5723293CD93@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200902192316.11628.linux@baker-net.org.uk> (sfid-20090220_002643_086457_3D819DFB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 18 February 2009, Anders Eriksson wrote:
> Every so often I get in syslog:
> wlan0: No ProbeResp from current AP 00:18:39:c0:5f:50 - assume out of range
>
> After that the interface carries no more traffic and the onlly way I've
> found to revive the card is to power cycle the machine.
> /etc/iniit.d/net.wlan restart does not work, and "ifconfig wlan0 up ;
> iwlist scan" shows no results. Is there another way to revive the card?

The first thing to try would be to see if rmmod rt61pci; modprobe rt61pci is 
enough to recover it. If it is actually a cardbus card then you could also 
try unplugging and replugging it.

Neither of those is an ideal solution though. Do you fancy the task of trying 
to diagnose the underlying fault which is likely to require at the very least 
making sure the driver is built with debugfs support enabled and may require 
adding a few printk statements into the kernel modules to reveal more details 
of the behaviour?

>
> I'm on 2.6.29-rc3, and the card is:
> 00:0a.0 Network controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
>         Subsystem: RaLink Device 2560
>         Flags: bus master, slow devsel, latency 64, IRQ 11
>         Memory at efffe000 (32-bit, non-prefetchable) [size=8K]
>         Capabilities: [40] Power Management version 2
>         Kernel driver in use: rt2500pci
>         Kernel modules: rt2500pci
>

