Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:35227 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbbDOOdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2015 10:33:02 -0400
Received: by ykec202 with SMTP id c202so1282118yke.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2015 07:33:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
References: <1429103273-89272-1-git-send-email-nbd@openwrt.org>
Date: Wed, 15 Apr 2015 16:33:01 +0200
Message-ID: <CACna6ryFjs+YHKUx2WTe5j5xctzD1Aru2qwP=F63TRpMd+FbZQ@mail.gmail.com> (sfid-20150415_163307_283628_0FB8D89E)
Subject: Re: [PATCH 1/2] bcma: use absolute base for SoC GPIO pins
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 April 2015 at 15:07, Felix Fietkau <nbd@openwrt.org> wrote:
> @@ -235,16 +235,17 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>         }
>
>         /*
> -        * On MIPS we register GPIO devices (LEDs, buttons) using absolute GPIO
> -        * pin numbers. We don't have Device Tree there and we can't really use
> -        * relative (per chip) numbers.
> -        * So let's use predictable base for BCM47XX and "random" for all other.
> +        * Register SoC GPIO devices with absolute GPIO pin base.
> +        * On MIPS, we don't have Device Tree and we can't use relative (per chip)
> +        * GPIO numbers.
> +        * On some ARM devices, user space may want to access some system GPIO
> +        * pins directly, which is easier to do with a predictable GPIO base.
>          */
> -#if IS_BUILTIN(CONFIG_BCM47XX)
> -       chip->base              = bus->num * BCMA_GPIO_MAX_PINS;
> -#else
> -       chip->base              = -1;
> -#endif
> +       if (IS_BUILTIN(CONFIG_BCM47XX) ||
> +           cc->core->bus->hosttype == BCMA_HOSTTYPE_SOC)
> +               chip->base              = bus->num * BCMA_GPIO_MAX_PINS;
> +       else
> +               chip->base              = -1;

Is there any chance you will need predictable GPIO numbers of extra
bcma buses on ARM? Like accessing GPIO of PCIe card from user space?
Then you could prefer IS_BUILTIN(CONFIG_ARCH_BCM_5301X)

Anyway, I'm OK with this patch.

-- 
Rafał
