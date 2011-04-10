Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36829 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab1DJVaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 17:30:30 -0400
Received: by iyb14 with SMTP id 14so5042784iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Apr 2011 14:30:29 -0700 (PDT)
Message-ID: <4DA22172.8030600@lwfinger.net>
Date: Sun, 10 Apr 2011 16:30:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: Firmware files for Ralink RT28x0
References: <4DA2042A.3010301@gmail.com> <1302469406.5282.341.camel@localhost>
In-Reply-To: <1302469406.5282.341.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2011 04:03 PM, Ben Hutchings wrote:
> On Sun, 2011-04-10 at 21:25 +0200, Xose Vazquez Perez wrote:
>> Ben Hutchings wrote:
>>
>>> Ralink provides multiple drivers per bus type for RT28xx and later
>>> chips.  For PCI devices they split between RT2860 and RT309x; for USB
>>> devices they split between RT2870 and RT307x (I think - the chip model
>>> numbers don't seem to be stated consistently).
>>>
>>> In addition, the USB drivers have two separate images packed together
>>> and they can select different images based on the controller version:
>>>
>>> #ifdef RTMP_MAC_USB
>>> 		if ((Version != 0x2860)&&  (Version != 0x2872)&&  (Version != 0x3070))
>>> 		{	// Use Firmware V2.
>>> 			//printk("KH:Use New Version,part2\n");
>>> 			pFirmwareImage = (PUCHAR)&FirmwareImage[FIRMWAREIMAGEV1_LENGTH];
>>> 			FileLength = FIRMWAREIMAGEV2_LENGTH;
>>> 		}
>>> 		else
>>> 		{
>>> 			//printk("KH:Use New Version,part1\n");
>>> 			pFirmwareImage = FirmwareImage;
>>> 			FileLength = FIRMWAREIMAGEV1_LENGTH;
>>> 		}
>>> #endif // RTMP_MAC_USB //
>>>
>>> The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
>>> 2009-05-25 are all marked as version 17 (or 0.17), but *they all have
>>> different contents*.
>>>
>>> I attempted to maintain the same version selection logic when converting
>>> the staging drivers to use the firmware loader, since I assumed there
>>> was a good reason for it.
>>>
>>
>> As you can see in the ralink web[1] RT28XX/RT30XX USB devices (RT2870/RT2770/RT3572/RT3070)
>> need _only_ the rt2870.bin fw-file.
>>
>> And RT28XX/RT30XX PCI/mPCI/PCIe/CardBus devices
>> (RT2760/RT2790/RT2860/RT2890/RT3060/RT3062/RT3562/RT2860/RT2760/RT2890/RT2790/RT3090)
>> need _only_ the rt2860.bin fw-file.
>
> These files aren't used by the Ralink drivers.  So why should you
> believe the labels on them?
>
>>> linux-firmware is supposed to have all firmware files referenced by any
>>> version of Linux
>>
>> That's a good joke!
>> linux-firmware is *unmaintained* , a lot of firmwares are missing.
>
> linux-firmware is not *actively* maintained; it requires people to send
> submissions (repeatedly...).
>
>> Even the intel ones(microcode.dat, ipw2{1,2}*), zd1211, etc...
>
> I think there may be a problem with distribution of Intel Pro Wireless
> firmware because Intel requires users to accept a EULA.
>
>> Others are very old, really it's a mess.
>> Fedora puts _forty_ patches on top of linux-firmware.
>
> So help to make it better.

Agreed.

My experiences with linux-firmware are that they are justifiably particular 
about the license. My first attempt was with in-line firmware for the staging 
driver r8712u that had been distributed in a header file under GPL V2. That 
source compiled into a binary was not acceptible. After Realtek sent me their 
license that clearly gave the right to redistribute their firmware, my 
contribution was immediately accepted. I have since add 4 more Realtek firmware 
files under the same license. All were accepted without delay.

Larry
