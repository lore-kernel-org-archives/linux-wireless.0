Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54861 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932479Ab0FEA56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 20:57:58 -0400
Received: by fxm8 with SMTP id 8so1152001fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 17:57:57 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Richard Tillmore <rtillmore@gmail.com>
Subject: Re: p54usb doesn't create wlan0 interface
Date: Sat, 5 Jun 2010 02:57:42 +0200
Cc: linux-wireless@vger.kernel.org
References: <AANLkTillVZPnU2MDGmMcHQ3Yxj-LfJxPLlOUzSQ8S1Bm@mail.gmail.com>
In-Reply-To: <AANLkTillVZPnU2MDGmMcHQ3Yxj-LfJxPLlOUzSQ8S1Bm@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006050257.43071.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 05 June 2010 02:41:05 Richard Tillmore wrote:
> I have a Dell usb wireless card that I am trying to use under Linux.
> A search of the FCC-ID M4Y-XG705A lead me to believe it has a Z-Com
> XG-705A chipset.  Another search tells me that the p54usb driver
> should work.  So I added
> 	{USB_DEVICE(0x413c, 0x5513)},	/* Dell Wireless */
> to the /usr/src/linux/drivers/net/wireless/p54/p54usb.c file in the
> correct spot.
Please post the diff, so it can be integrated into -stable!

> A quick recompile and the module was built.  I did a
> modprobe p54usb and dmesg shows:

have you put the newly-built module into the right directory?
modprobe only takes modules from the kernel's module directory
(which is normally /lib/modules/$KVER/kernel/...)

you can verify that by calling modinfo p54usb and
check if there's a line usb:v413Cp5513d*...

> cfg80211: Calling CRDA to update world regulatory domain
> usbcore: registered new interface driver p54usb
> cfg80211: World regulatory domain updated:
>     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
>     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
>     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
>     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> 
> However iwconfig doesn't list a wlan0.
please don't use "iwconfig". WEXT is obsolete, you can find a
nl80211 replacement "iw" right here:
http://wireless.kernel.org/en/users/Documentation/iw .

> OK maybe I need firmware so another search leads me to
> http://wireless.kernel.org/en/users/Drivers/p54 where I download
> 2.13.24.0.lm87.arm (USB 2nd generation (ISL3887)), rename it to
> isl3887usb and put it in /lib/firmware.  I rebooted and still no wlan0
> listed in iwconfig.
No need for a reboot, if the correct module is loaded the device
should be recognized instantly... (or as soon as it is replugged.)

Regards,
	Chr
