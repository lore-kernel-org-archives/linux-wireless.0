Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:50896 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbLRSB2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 13:01:28 -0500
Subject: Re: [PATCH v3] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
 <CACna6rzqGrfduyMPJkq29AJ2SFs8ngPgQau3rCWRtbZ3-nxfVA@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <567449F4.9010400@hauke-m.de> (sfid-20151218_190132_651997_7DFDB486)
Date: Fri, 18 Dec 2015 19:01:24 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rzqGrfduyMPJkq29AJ2SFs8ngPgQau3rCWRtbZ3-nxfVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/18/2015 07:27 AM, Rafał Miłecki wrote:
> I'm afraid it wasn't tested on BCM47XX (MIPS) :(

Yes, you are probably right.

> On 14 August 2015 at 00:21, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>> @@ -218,9 +187,8 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>         chip->set               = bcma_gpio_set_value;
>>         chip->direction_input   = bcma_gpio_direction_input;
>>         chip->direction_output  = bcma_gpio_direction_output;
>> -#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
>> -       chip->to_irq            = bcma_gpio_to_irq;
>> -#endif
>> +       chip->owner             = THIS_MODULE;
>> +       chip->dev               = bcma_bus_get_host_dev(bus);
> 
> This assigns &bus->host_pdev->dev which is NULL.

hmm, how do we fix this, as long as bcma does not have a device on mips
this is a problem. Should we create a new device for mips?

>> @@ -248,13 +216,13 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>         else
>>                 chip->base              = -1;
>>
>> -       err = bcma_gpio_irq_domain_init(cc);
>> +       err = gpiochip_add(chip);
>>         if (err)
>>                 return err;
>>
>> -       err = gpiochip_add(chip);
>> +       err = bcma_gpio_irq_init(cc);
> 
> This results in:
> [    0.157054] missing gpiochip .dev parent pointer
> (coming from gpiochip_irqchip_add) and
> [    0.157287] bcma: bus0: Error registering GPIO driver: -22


