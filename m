Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:37174 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbbLRG1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Dec 2015 01:27:47 -0500
Received: by mail-ig0-f169.google.com with SMTP id to18so28255998igc.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Dec 2015 22:27:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
References: <1439504505-20314-1-git-send-email-hauke@hauke-m.de>
Date: Fri, 18 Dec 2015 07:27:46 +0100
Message-ID: <CACna6rzqGrfduyMPJkq29AJ2SFs8ngPgQau3rCWRtbZ3-nxfVA@mail.gmail.com> (sfid-20151218_072751_179105_EFAD0F23)
Subject: Re: [PATCH v3] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm afraid it wasn't tested on BCM47XX (MIPS) :(

On 14 August 2015 at 00:21, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> @@ -218,9 +187,8 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>         chip->set               = bcma_gpio_set_value;
>         chip->direction_input   = bcma_gpio_direction_input;
>         chip->direction_output  = bcma_gpio_direction_output;
> -#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
> -       chip->to_irq            = bcma_gpio_to_irq;
> -#endif
> +       chip->owner             = THIS_MODULE;
> +       chip->dev               = bcma_bus_get_host_dev(bus);

This assigns &bus->host_pdev->dev which is NULL.


> @@ -248,13 +216,13 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>         else
>                 chip->base              = -1;
>
> -       err = bcma_gpio_irq_domain_init(cc);
> +       err = gpiochip_add(chip);
>         if (err)
>                 return err;
>
> -       err = gpiochip_add(chip);
> +       err = bcma_gpio_irq_init(cc);

This results in:
[    0.157054] missing gpiochip .dev parent pointer
(coming from gpiochip_irqchip_add) and
[    0.157287] bcma: bus0: Error registering GPIO driver: -22
