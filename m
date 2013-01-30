Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52672 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3A3AHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 19:07:07 -0500
Received: by mail-ee0-f46.google.com with SMTP id e49so520757eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 29 Jan 2013 16:07:06 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Andrew Wasielewski <andrew@wasielewski.co.uk>
Subject: Re: WARNING: at drivers/net/wireless/p54/main.c:443 p54_work+0x66/0x80 [p54common]() (Not tainted)
Date: Wed, 30 Jan 2013 01:06:52 +0100
Cc: linux-wireless@vger.kernel.org
References: <1732818.7oJIpSJZSL@localhost.localdomain>
In-Reply-To: <1732818.7oJIpSJZSL@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201301300106.52229.chunkeey@googlemail.com> (sfid-20130130_010712_244202_B2546627)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Wednesday, January 30, 2013 12:04:38 AM Andrew Wasielewski wrote:
> I just had the following crash in p54common.
Yeah, the driver has run out of memory (memory on the device). This
is most likely caused when the firmware "ceased operations". Sadly, 
the last available firmware from Conexant for the isl3886 is
	2.13.1.0.lm86.arm (and you probably are using it already :-/ )
What's even worse is that neither Conexant nor STE have not and won't 
be providing any new images and the freemac project has stalled as well.
The Islsm project had a firmware terminal which could be used to debug
firmware stuff, but it is was never ported.

> The "failed to update LEDs" messages continued until I rebooted - couldn't find
> a way to reload the stack. O/S is ClearOS Community release 6.3.0 (kernel 2.6.32-279.19.1.v6.i686).
> Hardware is LinkSys WUSB54G running in AP mode using hostapd, firmware isl3886usb.
Reloading the driver (modprobe -r p54usb && modprobe p54usb) or replugging the 
device should have helped. Anyway, the clean "reset" procedure for these devices
is known but to Conexant. If you have sysfs, you can reset a dead usb device
by toggling (writing 0 and then 1 into) /sys/bus/usb/devices/x-y-z/authorized.
If this helps, we can at least let the driver reset the device automatically
once it bails out. What do you think?

Regards,
	Chr
