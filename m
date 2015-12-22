Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34162 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbbLVMzx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2015 07:55:53 -0500
Received: by mail-ob0-f171.google.com with SMTP id iw8so143390918obc.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2015 04:55:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56793D61.7090305@hauke-m.de>
References: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
	<CACna6rzqGrfduyMPJkq29AJ2SFs8ngPgQau3rCWRtbZ3-nxfVA@mail.gmail.com>
	<567449F4.9010400@hauke-m.de>
	<CACRpkdY2mHou_Qx5Jn0Y6m-8FwgCjKKpioH=ADS=ARAdWgAtNQ@mail.gmail.com>
	<56793D61.7090305@hauke-m.de>
Date: Tue, 22 Dec 2015 13:55:52 +0100
Message-ID: <CACRpkdZBPRVS=L6sQ2mSMQrY+5qe0LDexrwF+V4K=d7d1OwMOQ@mail.gmail.com> (sfid-20151222_135556_934942_57AE48D3)
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

On Tue, Dec 22, 2015 at 1:09 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 12/22/2015 10:01 AM, Linus Walleij wrote:
>> On Fri, Dec 18, 2015 at 7:01 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>> On 12/18/2015 07:27 AM, Rafał Miłecki wrote:
>>>> I'm afraid it wasn't tested on BCM47XX (MIPS) :(
>>>
>>> Yes, you are probably right.
>>>
>>>> On 14 August 2015 at 00:21, Hauke Mehrtens <hauke@hauke-m.de> wrote:
>>>>> @@ -218,9 +187,8 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>>>>>         chip->set               = bcma_gpio_set_value;
>>>>>         chip->direction_input   = bcma_gpio_direction_input;
>>>>>         chip->direction_output  = bcma_gpio_direction_output;
>>>>> -#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
>>>>> -       chip->to_irq            = bcma_gpio_to_irq;
>>>>> -#endif
>>>>> +       chip->owner             = THIS_MODULE;
>>>>> +       chip->dev               = bcma_bus_get_host_dev(bus);
>>>>
>>>> This assigns &bus->host_pdev->dev which is NULL.
>>>
>>> hmm, how do we fix this, as long as bcma does not have a device on mips
>>> this is a problem. Should we create a new device for mips?
>>
>> Yes I think MIPS should just create a host device. That
>> makes things simple and nice. Is it complex to do so?
>>
>> Yours,
>> Linus Walleij
>>
> Currently the documentation says this for the parent member on struct
> gpio_chip:
>
>  * @parent: optional parent device providing the GPIOs
>
> I assume the optional is wrong here.

For just gpiochip it is optional. But if you read on:

GPIO drivers providing IRQs
---------------------------
(...)
To use the helpers please keep the following in mind:

- Make sure to assign all relevant members of the struct gpio_chip so that
  the irqchip can initialize. E.g. .dev and .can_sleep shall be set up
  properly.
(...)

Well it's complex. But when adding the gpio character device I
am working with, I will introduce a struct device to the gpio_chip
(or similar sibling gpio_device) which we can then refer, so that
this actually will no longer be a requirement.

Yours,
Linus Walleij
