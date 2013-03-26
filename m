Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62370 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3CZRBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 13:01:16 -0400
Received: by mail-oa0-f46.google.com with SMTP id k1so7828439oag.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 10:01:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5151B106.6020800@dpets.co.uk>
References: <51514F1B.1080207@dpets.co.uk>
	<5151639F.4010700@broadcom.com>
	<51516BC2.5010004@dpets.co.uk>
	<515173A4.7030607@broadcom.com>
	<515179C5.50406@dpets.co.uk>
	<51517E28.5000303@broadcom.com>
	<515182C6.5030305@dpets.co.uk>
	<51518682.7060503@broadcom.com>
	<515189C6.7070003@dpets.co.uk>
	<51518E14.3050500@broadcom.com>
	<5151B106.6020800@dpets.co.uk>
Date: Tue, 26 Mar 2013 18:01:16 +0100
Message-ID: <CACna6rwnOCETmripr6i-=MvPTywXUpPrd-WxPtNA1=5jz6oMUA@mail.gmail.com> (sfid-20130326_180123_068128_EAFF8B97)
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: John Talbut <jt@dpets.co.uk>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013/3/26 John Talbut <jt@dpets.co.uk>:
> On 26/03/13 12:01, Arend van Spriel wrote:
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
>>
>> Regards,
>> Arend
>
> I have just noticed that with a previous version of the kernel which I
> had compiled with
> # CONFIG_BCMA is not set
>
> there are references to brcmsmac in the kernel log.  It complains about
> failing to find the firmware, though.

In earlier kernels brcmsmac was re-implementing "bcma" on it's own. It
was changed, so now brcmsmac operates just on the bcma 80211 core. You
need both: bcma and brcmsmac loaded.

-- 
Rafał
