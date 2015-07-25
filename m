Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:59995 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964780AbbGYUHt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2015 16:07:49 -0400
Message-ID: <55B3EC92.1070704@hauke-m.de> (sfid-20150725_220826_300690_A8E90CC5)
Date: Sat, 25 Jul 2015 22:07:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlYw==?= =?UTF-8?B?a2k=?=
	<zajec5@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] bcma: switch GPIO portions to use GPIOLIB_IRQCHIP
References: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1437512677-6153-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I found some compile problems in the code, but I haven't runtime tested
it, but will do that.

Hauke

On 07/21/2015 11:04 PM, Linus Walleij wrote:
> This switches the BCMA GPIO driver to use GPIOLIB_IRQCHIP to
> handle its interrupts instead of rolling its own copy of the
> irqdomain handling etc.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Hi BCMA people,
> 
> if we can figure this out it would be great if you can test this
> and merge it through whatever GIT tree handles BCMA patches.
> Alternatively I can merge it into the GPIO tree with your ACK.
> 
> This is not even compiled, I don't have the right cross compilers
> but the conversion is done like all other GPIOLIB_IRQCHIP conversions
> I've done, so it shouldn't be very far off. Maybe you can get it
> in shape in accordance with my idea if I screwed up? Thanks.
> ---
>  drivers/bcma/Kconfig                        |  2 +-
>  drivers/bcma/driver_gpio.c                  | 88 +++++++++--------------------
>  include/linux/bcma/bcma_driver_chipcommon.h |  1 -
>  3 files changed, 28 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
> index be5fffb6da24..023d448ed3fa 100644
> --- a/drivers/bcma/Kconfig
> +++ b/drivers/bcma/Kconfig
> @@ -92,7 +92,7 @@ config BCMA_DRIVER_GMAC_CMN
>  config BCMA_DRIVER_GPIO
>  	bool "BCMA GPIO driver"
>  	depends on BCMA && GPIOLIB
> -	select IRQ_DOMAIN if BCMA_HOST_SOC
> +	select GPIOLIB_IRQCHIP if BCMA_HOST_SOC
>  	help
>  	  Driver to provide access to the GPIO pins of the bcma bus.
>  
> diff --git a/drivers/bcma/driver_gpio.c b/drivers/bcma/driver_gpio.c
> index 5f6018e7cd4c..f436fb5b429c 100644
> --- a/drivers/bcma/driver_gpio.c
> +++ b/drivers/bcma/driver_gpio.c

> @@ -125,14 +117,14 @@ static irqreturn_t bcma_gpio_irq_handler(int irq, void *dev_id)
>  	if (!irqs)
>  		return IRQ_NONE;
>  
> -	for_each_set_bit(gpio, &irqs, cc->gpio.ngpio)
> -		generic_handle_irq(bcma_gpio_to_irq(&cc->gpio, gpio));
> +	for_each_set_bit(gpio, &irqs, gc->ngpio)
> +		generic_handle_irq(irq_find_mapping(gc->irq_domain, gpio));

use gc->irqdomain instead

>  	bcma_chipco_gpio_polarity(cc, irqs, val & irqs);
>  
>  	return IRQ_HANDLED;
>  }
>  
> -static int bcma_gpio_irq_domain_init(struct bcma_drv_cc *cc)
> +static int bcma_gpio_irq_init(struct bcma_drv_cc *cc)
>  {
>  	struct gpio_chip *chip = &cc->gpio;
>  	int gpio, hwirq, err;

gpio is unused now


> -err_req_irq:
> -	for (gpio = 0; gpio < chip->ngpio; gpio++) {
> -		int irq = irq_find_mapping(cc->irq_domain, gpio);
> -
> -		irq_dispose_mapping(irq);
> +	err =  gpiochip_irqchip_add(chip,
> +				    &bcma_gpio_irq_chip,
> +				    0,
> +				    handle_simple_irq,
> +				    IRQ_TYPE_NONE);
> +	if (err) {
> +		free_irq(hwirq);

use free_irq(hwirq, cc); instead



