Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-2.mail.demon.net ([195.173.77.133]:45923 "EHLO
	anchor-post-2.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753229Ab3CZSnY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 14:43:24 -0400
Message-ID: <5151EC49.9030109@dpets.co.uk> (sfid-20130326_194328_353666_606CDFC1)
Date: Tue, 26 Mar 2013 18:43:21 +0000
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk> <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk> <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk> <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk> <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk> <51518E14.3050500@broadcom.com> <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com>
In-Reply-To: <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26/03/13 16:59, Rafał Miłecki wrote:
> 2013/3/26 Arend van Spriel<arend@broadcom.com>:
>> On 03/26/2013 12:43 PM, John Talbut wrote:
>>> On 26/03/13 11:29, Arend van Spriel wrote:
>>>> On 03/26/2013 12:13 PM, John Talbut wrote:
>>>>>
>>>>> On 26/03/13 10:53, Arend van Spriel wrote:
>>>>>> On 03/26/2013 11:34 AM, John Talbut wrote:
>>>>>>> Kernel log attached.
>>>>>>>
>>>>>>
>>>>>> Now this is weird. I do not see any BCMA log messages. Can you give
>>>>>> output of following command:
>>>>>>
>>>>>> $ lspci -n -s 1:0.0
>>>>>
>>>>> 01:00.0 0280: 14e4:4357 (rev 01)
>>>>
>>>> Ok, no problem there.
>>>>
>>>> digging further in sysfs. Can you execute the following commands:
>>>>
>>>> if it exists:
>>>> $ ls /sys/bus/bcma
>>>> $ ls /sys/bus/bcma/devices
>>>> $ ls /sys/bus/bcma/drivers
>>>>
>>>> if it exists also following:
>>>> $ ls -l /sys/bus/bcma/drivers/brcmsmac
>>>
>>> root@johnwtnc110:/usr/src/linux-source-3.8# ls /sys/bus/bcma
>>> devices  drivers  drivers_autoprobe  drivers_probe  uevent
>>> root@johnwtnc110:/usr/src/linux-source-3.8# ls /sys/bus/bcma/devices
>>
>> The fact that there are no devices detected under bcma is suspicious.
>> Adding bcma developer to the list. Maybe he knows about issues when
>> having bcma compiled in kernel image.
>
> Thanks Arend. Unfortunately I can't find archive of this thread, so I
> can see only quotations above.
>
> If there is /sys/bus/bcma/ directory, it means bcma had to be loaded
> (or just is built into the kernel). However if there are no "bcma"
> messages in the dmesg, it's probably because there isn't any device
> bcma (currently) handles.
>
> If you can it yourself: remove all 14e4:* devices and do "modprobe
> bcma". You will get /sys/bus/bcma/ without "bcma" messages in dmesg.
>
> 14e4:4357 is one of the devices handled by bcma, so there are two options:
> 1) It's some old kernel where we didn't have 14e4:4357 in bcma
> 2) There is another module that grabbed 14e4:4357 PCI device
>
> The first option can be verified with "modinfo bcma | grep alias" in
> case of bcma as a module. Not sure how to check that for bcma built
> in.
>
> The second option is even easier to verify, just use:
> lspci -d 14e4: -v
> and check for "Kernel driver in use: "
>
Thanks Rafał.

I have everything built into the kernel which is compiled using the 3.8 
kernel source from Debian, so not an old kernel.

ls /sys/bus/bcma
devices  drivers  drivers_autoprobe  drivers_probe  uevent

lspci -d 14e4: -v
01:00.0 Network controller: Broadcom Corporation BCM43225 802.11b/g/n 
(rev 01)
	Subsystem: Wistron NeWeb Corp. Device 04db
	Flags: bus master, fast devsel, latency 0, IRQ 11
	Memory at dfe00000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [40] Power Management version 3
	Capabilities: [58] Vendor Specific Information: Len=78 <?>
	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
	Capabilities: [d0] Express Endpoint, MSI 00
	Capabilities: [100] Advanced Error Reporting
	Capabilities: [13c] Virtual Channel
	Capabilities: [160] Device Serial Number 00-00-b1-ff-ff-29-00-1b
	Capabilities: [16c] Power Budgeting <?>

John

