Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39390 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab3IVUi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Sep 2013 16:38:26 -0400
Received: by mail-bk0-f49.google.com with SMTP id r7so873792bkg.36
        for <linux-wireless@vger.kernel.org>; Sun, 22 Sep 2013 13:38:25 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: the_force@gmx.de
Cc: linux-wireless@vger.kernel.org
Subject: Re: p54usb raspberry pi no wlan0 device
Date: Sun, 22 Sep 2013 22:38:21 +0200
Message-ID: <1508948.9yCuDuyPXl@blech> (sfid-20130922_223859_924428_97D1C3F7)
In-Reply-To: <trinity-4366d417-bdc3-4e3b-a613-25b1af7a51a7-1379880343916@3capp-gmx-bs34>
References: <trinity-4366d417-bdc3-4e3b-a613-25b1af7a51a7-1379880343916@3capp-gmx-bs34>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Sunday, September 22, 2013 10:05:44 PM the_force@gmx.de wrote:
> i want to use an Corega WLUSB2GTST USB adapter on my Raspberry Pi linux device. 
> I used fwextract utility with the driver file (Windows 2000 driver, nobyteswap option).
> So i got these 2 files:
>  
> cgwlusb200.arm
> cgwlusb201.arm
I think I found the driver. It's a generic firmware, but it's really old (pre 2.7.0.0).
You should go to <http://wireless.kernel.org/en/users/Drivers/p54> and get the latest
one from there for your device (isl3887usb > 2.6.29).
  
> I have copied these files (i tried cgwlusb200.arm also cgwlusb201.arm) to the following location on my Raspberry Pi:
>  
> /lib/firmware/isl3887usb
This should be the right location and filename for the firmware.

> Sep 22 21:33:09 pinulldrei kernel: [1031466.202908] usb 1-1.2.1: New USB device found, idVendor=07aa, idProduct=0020
I can't find this device-id in the p54u_table. Did you add it manually?

> Sep 22 21:33:09 pinulldrei kernel: [1031466.202939] usb 1-1.2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Sep 22 21:34:37 pinulldrei kernel: [1031554.700433] cfg80211: Calling CRDA to update world regulatory domain
> Sep 22 21:34:37 pinulldrei kernel: [1031554.755865] usbcore: registered new interface driver p54usb

Is this output cropped? p54usb announces which firmware file it requests.
Furthermore, In your case you should have seen something like this in dmesg:
"wrong firmware, please get a firmware for "isl3887usb" and try again."

> Everything looks fine - but no wlan0 device will be created :-( The led on the stick
> will not turn on, so i think i have a driver problem.
>
> How can i debug / solve this problem?!?
Looks like the firmware on the device crashed. You should physically disconnect and 
reconnect the stick before trying again.
 
> Greetings from Germany,
Regards from Germany,

Christian
