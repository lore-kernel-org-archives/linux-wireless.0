Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58776 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172Ab0FECvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jun 2010 22:51:25 -0400
Received: by vws5 with SMTP id 5so502374vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jun 2010 19:51:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201006050257.43071.chunkeey@googlemail.com>
References: <AANLkTillVZPnU2MDGmMcHQ3Yxj-LfJxPLlOUzSQ8S1Bm@mail.gmail.com>
	<201006050257.43071.chunkeey@googlemail.com>
Date: Fri, 4 Jun 2010 21:51:23 -0500
Message-ID: <AANLkTilrhSH4u-7MOjYILlQZoSqF5zc04JEbMI5IXgBs@mail.gmail.com>
Subject: Re: p54usb doesn't create wlan0 interface
From: Richard Tillmore <rtillmore@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 4, 2010 at 7:57 PM, Christian Lamparter wrote:
> On Saturday 05 June 2010 02:41:05 Richard wrote:
>> I have a Dell usb wireless card that I am trying to use under Linux.
>> A search of the FCC-ID M4Y-XG705A lead me to believe it has a Z-Com
>> XG-705A chipset.  Another search tells me that the p54usb driver
>> should work.  So I added
>>       {USB_DEVICE(0x413c, 0x5513)},   /* Dell Wireless */
>> to the /usr/src/linux/drivers/net/wireless/p54/p54usb.c file in the
>> correct spot.
> Please post the diff, so it can be integrated into -stable!

I will have my friend post the diff tomorrow as I don't know how to make a diff.

>> A quick recompile and the module was built.  I did a
>> modprobe p54usb and dmesg shows:
>
> have you put the newly-built module into the right directory?
> modprobe only takes modules from the kernel's module directory
> (which is normally /lib/modules/$KVER/kernel/...)
>
> you can verify that by calling modinfo p54usb and
> check if there's a line usb:v413Cp5513d*...

You are right I was booting with the wrong kernel.  The default was
2.6.34-rc5 not the 2.6.34 we compiled.

>> However iwconfig doesn't list a wlan0.
> please don't use "iwconfig". WEXT is obsolete, you can find a
> nl80211 replacement "iw" right here:
> http://wireless.kernel.org/en/users/Documentation/iw .
>
>> OK maybe I need firmware so another search leads me to
>> http://wireless.kernel.org/en/users/Drivers/p54 where I download
>> 2.13.24.0.lm87.arm (USB 2nd generation (ISL3887)), rename it to
>> isl3887usb and put it in /lib/firmware.  I rebooted and still no wlan0
>> listed in iwconfig.
> No need for a reboot, if the correct module is loaded the device
> should be recognized instantly... (or as soon as it is replugged.)

I have iw and it works.  I just have to figure out how to use it :)

Thanks
Greg
