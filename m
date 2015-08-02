Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:39048 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbbHBS25 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2015 14:28:57 -0400
Message-ID: <55BE6167.7090101@hauke-m.de> (sfid-20150802_202900_319751_9FDD8A41)
Date: Sun, 02 Aug 2015 20:28:55 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: linus.walleij@linaro.org, kvalo@codeaurora.org
CC: zajec5@gmail.com, nbd@openwrt.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org> <1438538405-9133-1-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1438538405-9133-1-git-send-email-hauke@hauke-m.de>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2015 08:00 PM, Hauke Mehrtens wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
> handle its interrupts instead of rolling its own copy of the
> irqdomain handling etc.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
> 
> I fixed some bugs in the original patch, some of them are compile 
> errors and others caused some runtime problems. This patch worked on my 
> BCM4708 based device, I was able to receive an IRQ for a GPIO change 
> (button press).
> 
> I think this should go through the wireless tree.
> 
> @Linus could you please check if the changes I did are correct?
> 
>  drivers/bcma/Kconfig                        |   2 +-
>  drivers/bcma/driver_gpio.c                  | 105 ++++++++++++----------------
>  include/linux/bcma/bcma_driver_chipcommon.h |   1 -
>  3 files changed, 44 insertions(+), 64 deletions(-)
> 

.....

> @@ -218,9 +190,18 @@ int bcma_gpio_init(struct bcma_drv_cc *cc)
>  	chip->set		= bcma_gpio_set_value;
>  	chip->direction_input	= bcma_gpio_direction_input;
>  	chip->direction_output	= bcma_gpio_direction_output;
> -#if IS_BUILTIN(CONFIG_BCM47XX) || IS_BUILTIN(CONFIG_ARCH_BCM_5301X)
> -	chip->to_irq		= bcma_gpio_to_irq;
> -#endif
> +	chip->owner		= THIS_MODULE;
> +	switch (bus->hosttype) {
> +	case BCMA_HOSTTYPE_PCI:
> +		chip->dev	= &bus->host_pci->dev;
> +		break;
> +	case BCMA_HOSTTYPE_SOC:
> +		chip->dev	= &bus->host_pdev->dev;
> +		break;
> +	case BCMA_HOSTTYPE_SDIO:
> +		chip->dev	= &bus->host_sdio->dev;
> +		break;
> +	}

I will replace this part with a call to the newly introduced function
bcma_bus_get_host_dev() in a new version of this patch.

This function was introduced in "bcma: fix access to host_pdev for PCIe
devices"

.....
