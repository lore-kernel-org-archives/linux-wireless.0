Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33381 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbbDOOgX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 10:36:23 -0400
Message-ID: <552E7761.2040902@openwrt.org> (sfid-20150415_163626_504442_E1B5891D)
Date: Wed, 15 Apr 2015 16:36:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/2] bcma: use absolute base for SoC GPIO pins
References: <1429103273-89272-1-git-send-email-nbd@openwrt.org> <CACna6ryFjs+YHKUx2WTe5j5xctzD1Aru2qwP=F63TRpMd+FbZQ@mail.gmail.com>
In-Reply-To: <CACna6ryFjs+YHKUx2WTe5j5xctzD1Aru2qwP=F63TRpMd+FbZQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-04-15 16:33, Rafał Miłecki wrote:
> On 15 April 2015 at 15:07, Felix Fietkau <nbd@openwrt.org> wrote:
>> @@ -235,16 +235,17 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>         }
>>
>>         /*
>> -        * On MIPS we register GPIO devices (LEDs, buttons) using absolute GPIO
>> -        * pin numbers. We don't have Device Tree there and we can't really use
>> -        * relative (per chip) numbers.
>> -        * So let's use predictable base for BCM47XX and "random" for all other.
>> +        * Register SoC GPIO devices with absolute GPIO pin base.
>> +        * On MIPS, we don't have Device Tree and we can't use relative (per chip)
>> +        * GPIO numbers.
>> +        * On some ARM devices, user space may want to access some system GPIO
>> +        * pins directly, which is easier to do with a predictable GPIO base.
>>          */
>> -#if IS_BUILTIN(CONFIG_BCM47XX)
>> -       chip->base              = bus->num * BCMA_GPIO_MAX_PINS;
>> -#else
>> -       chip->base              = -1;
>> -#endif
>> +       if (IS_BUILTIN(CONFIG_BCM47XX) ||
>> +           cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
>> +               chip->base              = bus->num * BCMA_GPIO_MAX_PINS;
>> +       else
>> +               chip->base              = -1;
> 
> Is there any chance you will need predictable GPIO numbers of extra
> bcma buses on ARM? Like accessing GPIO of PCIe card from user space?
> Then you could prefer IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
> 
> Anyway, I'm OK with this patch.
I don't think I need it, and I didn't want this change to produce
conflicts on multi-arch builds, so I limited it to the SoC bus only.

- Felix
