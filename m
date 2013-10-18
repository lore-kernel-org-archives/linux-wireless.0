Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59015 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954Ab3JRQRA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Oct 2013 12:17:00 -0400
Received: from [192.168.0.103] ([93.218.112.150]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0MSMP5-1V9Eie1TX1-00TT2h for
 <linux-wireless@vger.kernel.org>; Fri, 18 Oct 2013 18:16:59 +0200
Message-ID: <52615EFA.80902@rempel-privat.de> (sfid-20131018_181705_050323_149B0969)
Date: Fri, 18 Oct 2013 18:16:58 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: =?UTF-8?B?WWFubmlrIFbDtmxrZXI=?= <yannikv@yahoo.de>
CC: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ar5523 Gigaset USB Adapter 108 issue
References: <Pine.LNX.4.44L0.1310181041080.1164-100000@iolanthe.rowland.org> <52614E9B.6040400@rempel-privat.de> <526155ED.1090007@yahoo.de>
In-Reply-To: <526155ED.1090007@yahoo.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.10.2013 17:38, schrieb Yannik Völker:
> Am 18.10.2013 17:07, schrieb Oleksij Rempel:
>> Am 18.10.2013 16:49, schrieb Alan Stern:
>>> Yannik, you should always use Reply-To-All so that your messages
>>> get sent to the mailing list and not just to me.
>>>
>>> On Thu, 17 Oct 2013, Yannik Völker wrote:
>>>
>>>> Am 07.08.2013 19:34, schrieb Alan Stern:
>>>>> Please post two usbmon traces, one showing the failure on
>>>>> your current system and the other showing the adapter running
>>>>> correctly under a 32-bit kernel.  Instructions for usbmon are
>>>>> in the kernel source file Documentation/usb/usbmon.txt.
>>>> I never got it to work under a 32-bit kernel, i was just able
>>>> to utilize a windows32 driver using ndiswrapper.
>>>>
>>>> Now i got it to "work". I randomly found out that the ar5523
>>>> driver actually works when you load it after you unload
>>>> ndiswrapper so the following steps make it work: 1. modprobe
>>>> ndiswrapper 2. plug in device 3. connect to wlan using
>>>> ndiswrapper and disconnect again (might be optional) 4.
>>>> modprobe -r ndiswrapper 5. modprobe ar5523 6. connect to wlan 
>>>> log for that is attatched as wlanthennative2.log
> 
> 
>> It sounds like linux driver didn't recognised usb id and didn't
>> uploaded firmware, or there was no firmware to upload.
> there is firmware (/lib/firmware/ar5523.bin exists) but it does not
> even get touched (i renamed the file and the error did not change at all)

find first usbid of your adapter (it will be changed after firmware
upload). And try to force driver to use this id:
modprobe -v ar5523
echo 07d1 3a0d > /sys/bus/usb/drivers/ar5523/new_id

instead of "07d1 3a0d" use your id.

Besidy, what kernel version are you using? May be it is too old..

-- 
Regards,
Oleksij
