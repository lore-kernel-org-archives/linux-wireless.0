Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41132 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3AJJLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2013 04:11:09 -0500
Received: by mail-wi0-f179.google.com with SMTP id o1so153279wic.12
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2013 01:11:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50E9E001.6060301@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
	<1357257085-11822-3-git-send-email-hauke@hauke-m.de>
	<CACna6rwincxUDM9ev9_CwH-MByS_5tGyd7hpR+wgR6D-rNzgww@mail.gmail.com>
	<50E9E001.6060301@hauke-m.de>
Date: Thu, 10 Jan 2013 10:03:16 +0100
Message-ID: <CACna6ryxd0gbX4Oe+YGEciZsgPeR5D-KShzSWTjPzR_1uJxuCg@mail.gmail.com> (sfid-20130110_101113_980703_FCF3C8D9)
Subject: Re: [PATCH 2/6] bcma: mips: explicit assign IRQ numbers
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nlhintz@hotmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Great, Ive used "Reply" instead of "Reply to all"... :/

2013/1/6 Hauke Mehrtens <hauke@hauke-m.de>:
> On 01/04/2013 08:43 AM, Rafał Miłecki wrote:
>> 2013/1/4 Hauke Mehrtens <hauke@hauke-m.de>:
>>> The assignment of the IRQs to the cores of the chips by iterating over
>>> the cores is complicated and causes problems with SoC like the BCM4706
>>> with two GMAC core where just one should get a dedicated IRQ number.
>>
>> Well, the only problem on BCM4706 is that second (broken/dangling)
>> GMAC core gets it's own IRQ. With such a "waste" of one IRQ line we
>> may end up using shared IRQ for some other core like PCIE/USB.
>> This issue can be simply workarounded (with 2 LOC) and sounds sane:
>> bug in HW, specific workaround in a driver. We already have similar
>> workarounds for other "dangling" cores.
>>
>> I don't know about any other issues with BCM4706 IRQs.
>>
>> Are there any other (more serious?) issues on different SoCs? Any
>> advantages of hardcoding IRQs (per chipset) rather than keeping this
>> simple algorithm? Do the IRQ lines differ? Is this somehow better to
>> use (just an example) IRQ 3 instead of IRQ 4 for GMAC core?
>
> Normally the boot loader (CFE) assigns IRQs to the cores on the bus. The
> old code mostly worked because CFE did it correct most of the time.
>
> On my bcm4718 the I2S core (id 0x834) does not get any IRQ from CFE, but
> at least Nathan (nlhintz) wants to assign an IRQ (shared) to this core.

So can we simply resolve this by
> default:
> bcma_core_mips_set_irq(core, mcore->assigned_irqs);
?


> It is also possible to extend the algorithm to solve all these things,
> but I think the new code is better to understand.
>
> I do not think that there will be any new SoC using bcma and a mips cpu,
> I haven't seen an announcement for such a SoC at the Broadcom web page,
> just arm based devices, so I assume this list is complete.

I just think we should leave some fallback for other devices... and
that probably means the algorithm. But if we decide to leave (a fixed)
algorithm there, why to use hadrcoded version at all?

-- 
Rafał
