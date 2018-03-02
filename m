Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:56070 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424124AbeCBKnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 05:43:10 -0500
Received: by mail-wm0-f67.google.com with SMTP id q83so2264881wme.5
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2018 02:43:10 -0800 (PST)
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Jakub Kicinski <kubakici@wp.pl>, linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
 <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com>
 <20180228184820.GL14069@wotan.suse.de>
 <ba4c6079-ca45-2048-1e7d-3cb4e1a80cdb@gmail.com>
 <20180301002813.GQ14069@wotan.suse.de>
 <9088ab38-5a88-f479-1225-5988f9890aaa@gmail.com>
 <20180301172920.GV14069@wotan.suse.de>
 <877eb47d-5750-c3ef-0238-bbfc73476ed2@gmail.com>
 <20180301210139.GX14069@wotan.suse.de>
From: cantabile <cantabile.desu@gmail.com>
Message-ID: <a06f4131-cb0b-677e-b096-801f31b1089a@gmail.com> (sfid-20180302_114324_332980_953D2F5B)
Date: Fri, 2 Mar 2018 12:43:07 +0200
MIME-Version: 1.0
In-Reply-To: <20180301210139.GX14069@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/18 23:01, Luis R. Rodriguez wrote:
> On Thu, Mar 01, 2018 at 10:11:01PM +0200, cantabile wrote:
>> On 01/03/18 19:29, Luis R. Rodriguez wrote:
>>>
>>> Correct?
>>>
>>
>> The above log is from "20180227-firmware-cache" kernel plus your suggested
>> change that makes it always upload the firmware:
>>
>> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
>> b/drivers/net/wireless/mediatek/mt7601u/mcu.c
>> index 65a8004418ea..04cbffd225a1 100644
>> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
>> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
>> @@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev
>> *dev)
>>   					 MT_USB_DMA_CFG_TX_BULK_EN));
>>
>>   	if (firmware_running(dev))
>> -		return 0;
>> +		pr_info("Firmware already loaded but going to reload...");
>>
>>   	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
>>   	if (ret)
> 
> Huh, if you are using 20180227-firmware-cache, then your diff should instead
> be this no?
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> index b90456a4b4d7..04cbffd225a1 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
>   					 MT_USB_DMA_CFG_TX_BULK_EN));
>   
>   	if (firmware_running(dev))
> -		return request_firmware_cache(dev->dev, MT7601U_FIRMWARE);
> +		pr_info("Firmware already loaded but going to reload...");
>   
>   	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
>   	if (ret)
> 
> 

Right, yes. I just copied the diff from your email instead of git diff.

>> I recompiled the kernel with CONFIG_DEBUG_INFO=y, but the messages in
>> journalctl look pretty much the same as before. There are still question
>> marks in the call traces, there are no line numbers, and it still says
>> "verbose debug info unavailable". /proc/config.gz contains
>> CONFIG_DEBUG_INFO=y. What else do I need to do?
> 
> Hrm, odd.
> 
> CONFIG_FRAME_POINTER=y
> 
> Maybe.

That doesn't exist in /proc/config.gz, not even commented out. I used 
SymSearch in 'make nconfig', and it finds "FRAME_POINTER":

Symbol: FRAME_POINTER [=n]
Type  : bool
Prompt: Compile the kernel with frame pointers
Location:
-> Kernel hacking
    -> Compile-time checks and compiler options

But when I go to that location, there is no such prompt.

I don't know what's going on here.

> 
>>> But if the patches I posted help, I guess we already have a solution, The rest of
>>> these email exchanges are all just hypothetical exercises.
>>>
>>
>> Your patches definitely fix the problem I reported in my initial email.
> 
> Ah OK :)
> 
>    Luis
> 
