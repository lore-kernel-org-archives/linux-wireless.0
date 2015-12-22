Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35604 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbbLVJBE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 04:01:04 -0500
Received: by mail-ob0-f169.google.com with SMTP id 18so140707824obc.2
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2015 01:01:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567449F4.9010400@hauke-m.de>
References: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
	<CACna6rzqGrfduyMPJkq29AJ2SFs8ngPgQau3rCWRtbZ3-nxfVA@mail.gmail.com>
	<567449F4.9010400@hauke-m.de>
Date: Tue, 22 Dec 2015 10:01:03 +0100
Message-ID: <CACRpkdY2mHou_Qx5Jn0Y6m-8FwgCjKKpioH=ADS=ARAdWgAtNQ@mail.gmail.com> (sfid-20151222_100109_046162_57D7C1B8)
Subject: Re: [PATCH v3] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
From: Linus Walleij <linus.walleij@linaro.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 18, 2015 at 7:01 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 12/18/2015 07:27 AM, Rafał Miłecki wrote:
>> I'm afraid it wasn't tested on BCM47XX (MIPS) :(
>
> Yes, you are probably right.
>
>> On 14 August 2015 at 00:21, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> @@ -218,9 +187,8 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>>         chip->set               = bcma_gpio_set_value;
>>>         chip->direction_input   = bcma_gpio_direction_input;
>>>         chip->direction_output  = bcma_gpio_direction_output;
>>> -#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
>>> -       chip->to_irq            = bcma_gpio_to_irq;
>>> -#endif
>>> +       chip->owner             = THIS_MODULE;
>>> +       chip->dev               = bcma_bus_get_host_dev(bus);
>>
>> This assigns &bus->host_pdev->dev which is NULL.
>
> hmm, how do we fix this, as long as bcma does not have a device on mips
> this is a problem. Should we create a new device for mips?

Yes I think MIPS should just create a host device. That
makes things simple and nice. Is it complex to do so?

Yours,
Linus Walleij
