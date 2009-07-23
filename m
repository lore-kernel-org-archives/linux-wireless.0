Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21663 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753618AbZGWQcG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 12:32:06 -0400
Subject: Re: any controller working in AP mode ?
From: Pavel Roskin <proski@gnu.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Ram kumar <ramkumar.research@gmail.com>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <200907230846.17683.hs4233@mail.mn-solutions.de>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <1247843954.25608.62.camel@mj> <1248277682.8929.0.camel@mj>
	 <200907230846.17683.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 12:32:04 -0400
Message-Id: <1248366724.2661.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-23 at 08:46 +0200, Holger Schurig wrote: 
> > Web search for 1286:1fab doesn't find anything useful other
> > than recommendations to use ndiswrapper.
> 
> It might be some 802.11n (marketing speak "Top Dog") thingy ???

That's very unlikely.  ZEW2502 is advertised as 802.11b/g and it's dirt
cheap ($20).  Besides, its ID 1286:1fab suggests that it's probably a
predecessor of 1286:2001 that is supported by the kernel drivers.

In case it matters, its FCC ID is T58331GU2006M1.  Some sites say its
chipset is "Marvell 88W8338 + 88W8010", see e.g.
http://www.xpcgear.com/zew2502.html

I modified both libertas drivers to support that ID.  usb8xxx asks for
usb8388.bin.  After I installed that firmware, usb8xxx started panicking
with so many messages that the interesting part scrolls from the screen.
I could try to capture that with a serial console.  It's clearly not the
right way to react to bad hardware.

As for libertas_tf_usb, it does something strange.  It registers a phy
that only supports monitor mode.  No network device is registered.  I
can add it using iw.  If I try to bring the interface up, the driver
requests lbtf_usb.bin.  Whether that file is present of not, ifconfig
hangs, and all subsequent network commands on other terminals hang too.

Apparently, error handling in libertas drivers needs some improvement,
regardless of whether ZEW2502 is a potentially supported device.

The device is supported by ndiswrapper with the x86_64 WinXP driver.
Scanning works, but wpa_supplicant fails.  That's just to verify that
the device is functional.

-- 
Regards,
Pavel Roskin
