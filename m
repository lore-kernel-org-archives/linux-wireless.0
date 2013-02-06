Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from avasout08.plus.net ([212.159.14.20]:55399 "EHLO
	avasout08.plus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3BFXvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 18:51:41 -0500
From: Andrew Wasielewski <andrew@wasielewski.co.uk>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Date: Wed, 06 Feb 2013 23:51:38 +0000
Message-ID: <2167973.tjlmlbBDaE@localhost.localdomain> (sfid-20130207_005144_259725_4910A928)
In-Reply-To: <201301300106.52229.chunkeey@googlemail.com>
References: <1732818.7oJIpSJZSL@localhost.localdomain> <201301300106.52229.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for getting back Christian,

On Wednesday 30 January 2013 01:06:52 Christian Lamparter wrote:
> Hello,
> 
> On Wednesday, January 30, 2013 12:04:38 AM Andrew Wasielewski wrote:
> > I just had the following crash in p54common.
> Yeah, the driver has run out of memory (memory on the device). This
> is most likely caused when the firmware "ceased operations". Sadly, 
> the last available firmware from Conexant for the isl3886 is
> 	2.13.1.0.lm86.arm (and you probably are using it already :-/ )
Yes, that is my version... :-(
> What's even worse is that neither Conexant nor STE have not and won't 
> be providing any new images and the freemac project has stalled as well.
> The Islsm project had a firmware terminal which could be used to debug
> firmware stuff, but it is was never ported.
> 
> > The "failed to update LEDs" messages continued until I rebooted - couldn't find
> > a way to reload the stack. O/S is ClearOS Community release 6.3.0 (kernel 2.6.32-279.19.1.v6.i686).
> > Hardware is LinkSys WUSB54G running in AP mode using hostapd, firmware isl3886usb.
> Reloading the driver (modprobe -r p54usb && modprobe p54usb) or replugging the 
> device should have helped. Anyway, the clean "reset" procedure for these devices
> is known but to Conexant. If you have sysfs, you can reset a dead usb device
> by toggling (writing 0 and then 1 into) /sys/bus/usb/devices/x-y-z/authorized.
The "authorized" file doesn't exist in my sysfs
> If this helps, we can at least let the driver reset the device automatically
> once it bails out. What do you think?

modprobing p54usb works with the driver, but I still have to restart hostapd for it to pick up the now-working driver.  Good news is it hasn't happened again.  Unplugging is tricky as I have slightly hacked the WUSB54G to fit inside the case (an old Shuttle mini-PC) with a SMA-RP connector and a decent antenna.  In fact the main reason I went for the WUSB54G is because this conversion seemed quite easy.  I am open to any suggestions for USB devices with b/g/n(?) support that could be internally mounted in this way, + has AP mode support of course.
> 
> Regards,
> 	Chr

Thanks,
Andrew
