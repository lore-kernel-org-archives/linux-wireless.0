Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:37857 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaIJOwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 10:52:34 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: Realtek GPIO chipset, for Baytrail?
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1410342645.4077.28.camel@hadess.net>
Date: Wed, 10 Sep 2014 07:53:10 -0700
Cc: Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-Id: <C88ED9F5-57D4-49E4-A47D-DDE439855EC5@holtmann.org> (sfid-20140910_165238_535304_8F59D77D)
References: <1410256608.4077.7.camel@hadess.net> <540F54B1.8040409@lwfinger.net> <1410292835.4077.21.camel@hadess.net> <540F61FE.2050404@lwfinger.net> <7234781D-5B78-404A-B945-D090938777C7@hadess.net> <D08A763F-AD50-449D-98C6-B82866F49480@holtmann.org> <54100FF7.5060904@broadcom.com> <1410342645.4077.28.camel@hadess.net>
To: Bastien Nocera <hadess@hadess.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bastien,

>>>>>>> What specific Baytrail tablet do you have?
>>>>>> 
>>>>>> The Onda v975w. It came with Windows 8.1 32-bit.
>>>>>> 
>>>>>> I guess that the device is probably a PCI one, but the enumeration is
>>>>>> done through ACPI instead of "normal" PCI.
>>>>> 
>>>>> In http://www.onda-tablet.com/onda-v975w-quad-core-win-8-tablet-9-7-inch-retina-screen-ram-2gb-wifi-32gb.html, someone is specifically looking for an RTL8723BS driver.
>>>> 
>>>> That's helpful.
>>>> 
>>>>> I will see if my contact at Realtek knows who has worked on drivers for this device, and if it would be possible to use rtl8723be if we were to supply an SDIO frontend.
>>>> 
>>>> I'm not sure why the device doesn't show up in the sysfs tree, but maybe it needs a driver bound to it to show up.
>>> 
>>> I just booted up my Baytrail based Minnowboard Max in ACPI enumeration and then the SDIO host controller is enumerated via ACPI. This is compared to PCI enumeration where the SDIO controller shows up in lspci.
>>> 
>>> So can you try to install sdhci-acpi and see if that starts showing SDIO devices. If the SDIO host controllers loads, then it start SDIO enumeration and you would see the cards.
>> 
>> You may need to look in /sys/bus/mmc/devices/ instead of sdio.
> 
> Indeed. That did the trick.
> 
> mmc0:0001 is the builtin storage, mmc1:0001:1 however is an unbound
> device with vendor 0x024c and device 0xb723 (modalias:
> sdio:c07v024CdB723). More interestingly class is 0x07, which udev
> interprets as "WLAN interface".

I started creating a hwdb/sdio.ids in systemd. However vendor 0x024c is not listed at the moment. If we figure out which one that is, then that should also be added to udev. After that it can annotate these devices properly.

Also if this is a single SDIO interface, then the Bluetooth part might be exposed as serial port. I have seen Realtek devices that run H:5 UART protocol.

Regards

Marcel

