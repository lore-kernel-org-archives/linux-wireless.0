Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51718 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab1DJTZf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 15:25:35 -0400
Received: by wwa36 with SMTP id 36so5899331wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 12:25:34 -0700 (PDT)
Message-ID: <4DA2042A.3010301@gmail.com>
Date: Sun, 10 Apr 2011 21:25:30 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	ben@decadent.org.uk
Subject: Re: Firmware files for Ralink RT28x0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Hutchings wrote:

> Ralink provides multiple drivers per bus type for RT28xx and later
> chips.  For PCI devices they split between RT2860 and RT309x; for USB
> devices they split between RT2870 and RT307x (I think - the chip model
> numbers don't seem to be stated consistently).
> 
> In addition, the USB drivers have two separate images packed together
> and they can select different images based on the controller version:
> 
> #ifdef RTMP_MAC_USB
> 		if ((Version != 0x2860) && (Version != 0x2872) && (Version != 0x3070)) 
> 		{	// Use Firmware V2.
> 			//printk("KH:Use New Version,part2\n");
> 			pFirmwareImage = (PUCHAR)&FirmwareImage[FIRMWAREIMAGEV1_LENGTH];
> 			FileLength = FIRMWAREIMAGEV2_LENGTH;
> 		}
> 		else
> 		{
> 			//printk("KH:Use New Version,part1\n");
> 			pFirmwareImage = FirmwareImage;
> 			FileLength = FIRMWAREIMAGEV1_LENGTH;
> 		}
> #endif // RTMP_MAC_USB //
> 
> The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
> 2009-05-25 are all marked as version 17 (or 0.17), but *they all have
> different contents*.
> 
> I attempted to maintain the same version selection logic when converting
> the staging drivers to use the firmware loader, since I assumed there
> was a good reason for it.
> 

As you can see in the ralink web[1] RT28XX/RT30XX USB devices (RT2870/RT2770/RT3572/RT3070)
need _only_ the rt2870.bin fw-file.

And RT28XX/RT30XX PCI/mPCI/PCIe/CardBus devices
(RT2760/RT2790/RT2860/RT2890/RT3060/RT3062/RT3562/RT2860/RT2760/RT2890/RT2790/RT3090)
need _only_ the rt2860.bin fw-file.

> linux-firmware is supposed to have all firmware files referenced by any
> version of Linux

That's a good joke!
linux-firmware is *unmaintained* , a lot of firmwares are missing.
Even the intel ones(microcode.dat, ipw2{1,2}*), zd1211, etc...
Others are very old, really it's a mess.
Fedora puts _forty_ patches on top of linux-firmware.

[1] http://www.ralinktech.com/support.php?s=2
