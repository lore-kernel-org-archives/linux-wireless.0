Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53098 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2HPW2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2012 18:28:36 -0400
Message-ID: <502D7405.1060700@hauke-m.de> (sfid-20120817_002842_015954_8BE20A77)
Date: Fri, 17 Aug 2012 00:28:21 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, john@phrozen.org
Subject: Re: [PATCH v2 3/3] MIPS: BCM47xx: rewrite GPIO handling and use gpiolib
References: <1345132801-8430-1-git-send-email-hauke@hauke-m.de> <1345132801-8430-4-git-send-email-hauke@hauke-m.de> <1791263.5FQJJv4xHF@bender>
In-Reply-To: <1791263.5FQJJv4xHF@bender>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2012 06:26 PM, Florian Fainelli wrote:
> Hello Hauke,
> 
> On Thursday 16 August 2012 18:00:01 Hauke Mehrtens wrote:
>> The original implementation implemented functions like gpio_request()
>> itself, but it missed some new functions added to the GPIO interface.
>> This caused compile problems for some drivers using some of the special
>> request methods which where not implemented. Now it uses gpiolib and
>> this implements all the request methods needed.
>>
>> The raw GPIO register access methods like bcm47xx_gpio_in() are
>> exported, because some special drivers for this target, not yet in
>> mainline, need them.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
> 
> [snip]
> 
>>  
>> -int gpio_request(unsigned gpio, const char *tag)
>> +static unsigned long bcm47xx_gpio_count;
>> +
>> +/* low level BCM47xx gpio api */
>> +u32 bcm47xx_gpio_in(u32 mask)
> 
> Are you using these low-level helpers beyond the scope of this file? I do not 
> see them being used anywhere else. You might just mark them as static inline.

They are not used in the code currently in mainline kernel, but there
are some drivers in OpenWrt for buttons and leds which are using them.
My plan is to rewrite the code currently used in OpenWrt and submit that
also to mainline. Should I make them static here and change that when I
add some driver for led and button support?

> 
>>  {
>>  	switch (bcm47xx_bus_type) {
>>  #ifdef CONFIG_BCM47XX_SSB
>>  	case BCM47XX_BUS_TYPE_SSB:
>> -		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
>> -		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
>> -			return -EINVAL;
>> -
>> -		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
>> -		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
>> -			return -EINVAL;
>> -
>> -		if (test_and_set_bit(gpio, gpio_in_use))
>> -			return -EBUSY;
>> -
>> -		return 0;
>> +		return ssb_gpio_in(&bcm47xx_bus.ssb, mask);
>>  #endif
>>  #ifdef CONFIG_BCM47XX_BCMA
>>  	case BCM47XX_BUS_TYPE_BCMA:
>> -		if (gpio >= BCM47XX_CHIPCO_GPIO_LINES)
>> -			return -EINVAL;
>> -
>> -		if (test_and_set_bit(gpio, gpio_in_use))
>> -			return -EBUSY;
>> +		return bcma_gpio_in(&bcm47xx_bus.bcma.bus, mask);
>> +#endif
>> +	}
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(bcm47xx_gpio_in);
>>  
>> -		return 0;
>> +u32 bcm47xx_gpio_out(u32 mask, u32 value)
>> +{
>> +	switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +	case BCM47XX_BUS_TYPE_SSB:
>> +		return ssb_gpio_out(&bcm47xx_bus.ssb, mask, value);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +	case BCM47XX_BUS_TYPE_BCMA:
>> +		return bcma_gpio_out(&bcm47xx_bus.bcma.bus, mask, value);
>>  #endif
>>  	}
>>  	return -EINVAL;
>>  }
>> -EXPORT_SYMBOL(gpio_request);
>> +EXPORT_SYMBOL(bcm47xx_gpio_out);
>>  
>> -void gpio_free(unsigned gpio)
>> +u32 bcm47xx_gpio_outen(u32 mask, u32 value)
>>  {
>>  	switch (bcm47xx_bus_type) {
>>  #ifdef CONFIG_BCM47XX_SSB
>>  	case BCM47XX_BUS_TYPE_SSB:
>> -		if (ssb_chipco_available(&bcm47xx_bus.ssb.chipco) &&
>> -		    ((unsigned)gpio >= BCM47XX_CHIPCO_GPIO_LINES))
>> -			return;
>> +		return ssb_gpio_outen(&bcm47xx_bus.ssb, mask, value);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +	case BCM47XX_BUS_TYPE_BCMA:
>> +		return bcma_gpio_outen(&bcm47xx_bus.bcma.bus, mask, value);
>> +#endif
>> +	}
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(bcm47xx_gpio_outen);
>>  
>> -		if (ssb_extif_available(&bcm47xx_bus.ssb.extif) &&
>> -		    ((unsigned)gpio >= BCM47XX_EXTIF_GPIO_LINES))
>> -			return;
>> +u32 bcm47xx_gpio_control(u32 mask, u32 value)
>> +{
>> +	switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +	case BCM47XX_BUS_TYPE_SSB:
>> +		return ssb_gpio_control(&bcm47xx_bus.ssb, mask, value);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +	case BCM47XX_BUS_TYPE_BCMA:
>> +		return bcma_gpio_control(&bcm47xx_bus.bcma.bus, mask, value);
>> +#endif
>> +	}
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(bcm47xx_gpio_control);
>>  
>> -		clear_bit(gpio, gpio_in_use);
>> -		return;
>> +u32 bcm47xx_gpio_intmask(u32 mask, u32 value)
>> +{
>> +	switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +	case BCM47XX_BUS_TYPE_SSB:
>> +		return ssb_gpio_intmask(&bcm47xx_bus.ssb, mask, value);
>>  #endif
>>  #ifdef CONFIG_BCM47XX_BCMA
>>  	case BCM47XX_BUS_TYPE_BCMA:
>> -		if (gpio >= BCM47XX_CHIPCO_GPIO_LINES)
>> -			return;
>> +		return bcma_gpio_intmask(&bcm47xx_bus.bcma.bus, mask, value);
>> +#endif
>> +	}
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(bcm47xx_gpio_intmask);
>>  
>> -		clear_bit(gpio, gpio_in_use);
>> -		return;
>> +u32 bcm47xx_gpio_polarity(u32 mask, u32 value)
>> +{
>> +	switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +	case BCM47XX_BUS_TYPE_SSB:
>> +		return ssb_gpio_polarity(&bcm47xx_bus.ssb, mask, value);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +	case BCM47XX_BUS_TYPE_BCMA:
>> +		return bcma_gpio_polarity(&bcm47xx_bus.bcma.bus, mask, value);
>>  #endif
>>  	}
>> +	return -EINVAL;
>> +}
>> +EXPORT_SYMBOL(bcm47xx_gpio_polarity);
>> +
>> +
>> +static int bcm47xx_gpio_get_value(struct gpio_chip *chip, unsigned gpio)
>> +{
>> +	return bcm47xx_gpio_in(1 << gpio);
>> +}
> 
> 
>> +
>> +static void bcm47xx_gpio_set_value(struct gpio_chip *chip,
>> +				   unsigned gpio, int value)
>> +{
>> +	bcm47xx_gpio_out(1 << gpio, value ? 1 << gpio : 0);
>> +}
>> +
>> +static int bcm47xx_gpio_direction_input(struct gpio_chip *chip,
>> +					unsigned gpio)
>> +{
>> +	bcm47xx_gpio_outen(1 << gpio, 0);
>> +	return 0;
>> +}
>> +
>> +static int bcm47xx_gpio_direction_output(struct gpio_chip *chip,
>> +					 unsigned gpio, int value)
>> +{
>> +	/* first set the gpio out value */
>> +	bcm47xx_gpio_out(1 << gpio, value ? 1 << gpio : 0);
>> +	/* then set the gpio mode */
>> +	bcm47xx_gpio_outen(1 << gpio, 1 << gpio);
>> +	return 0;
>>  }
> 
> Ok, so either mark the low-level helpers static inline, or just get rid of 
> them and make the gpiolib callbacks use the same code directly, I do not think 
> there is a need for such an indirection level.
> 
>> -EXPORT_SYMBOL(gpio_free);
>>  
>> -int gpio_to_irq(unsigned gpio)
>> +static int bcm47xx_gpio_to_irq(struct gpio_chip *chip, unsigned gpio)
>>  {
>>  	switch (bcm47xx_bus_type) {
>>  #ifdef CONFIG_BCM47XX_SSB
>> @@ -99,4 +166,53 @@ int gpio_to_irq(unsigned gpio)
>>  	}
>>  	return -EINVAL;
>>  }
>> -EXPORT_SYMBOL_GPL(gpio_to_irq);
>> +
>> +static struct gpio_chip bcm47xx_gpio_chip = {
>> +	.label			= "bcm47xx",
>> +	.get			= bcm47xx_gpio_get_value,
>> +	.set			= bcm47xx_gpio_set_value,
>> +	.direction_input	= bcm47xx_gpio_direction_input,
>> +	.direction_output	= bcm47xx_gpio_direction_output,
>> +	.to_irq			= bcm47xx_gpio_to_irq,
>> +	.base			= 0,
>> +};
>> +
>> +void __init bcm47xx_gpio_init(void)
>> +{
>> +	int err;
>> +
>> +	switch (bcm47xx_bus_type) {
>> +#ifdef CONFIG_BCM47XX_SSB
>> +	case BCM47XX_BUS_TYPE_SSB:
>> +		bcm47xx_gpio_count = ssb_gpio_count(&bcm47xx_bus.ssb);
>> +#endif
>> +#ifdef CONFIG_BCM47XX_BCMA
>> +	case BCM47XX_BUS_TYPE_BCMA:
>> +		bcm47xx_gpio_count = bcma_gpio_count(&bcm47xx_bus.bcma.bus);
>> +#endif
>> +	}
> 
> Is this exclusive? Cannot we have both SSB and BCMA on the same device?

We are just handling the GPIOs on the main SoC chip and that is either
SSB or BCMA not both. Sometimes there are additional bcma or ssb based
chips connected via PCI(e) or USB to the main SoC, but I have never seen
their GPIOs being used for anything else than the Wifi LED which is
already handled by b43 and do not know if it is possible at all.

A break is missing there. ;-)

> 
>> +
>> +	bcm47xx_gpio_chip.ngpio = bcm47xx_gpio_count;
>> +
>> +	err = gpiochip_add(&bcm47xx_gpio_chip);
>> +	if (err)
>> +		panic("cannot add BCM47xx GPIO chip, error=%d", err);
>> +}
>> +
>> +int gpio_get_value(unsigned gpio)
>> +{
>> +	if (gpio < bcm47xx_gpio_count)
>> +		return bcm47xx_gpio_in(1 << gpio);
>> +
>> +	return __gpio_get_value(gpio);
>> +}
>> +EXPORT_SYMBOL(gpio_get_value);
>> +
>> +void gpio_set_value(unsigned gpio, int value)
>> +{
>> +	if (gpio < bcm47xx_gpio_count)
>> +		bcm47xx_gpio_out(1 << gpio, value ? 1 << gpio : 0);
>> +	else
>> +		__gpio_set_value(gpio, value);
>> +}
>> +EXPORT_SYMBOL(gpio_set_value);
> 
> Why do we need these stubs?
> 
>> diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
>> index 95bf4d7..2936532 100644
>> --- a/arch/mips/bcm47xx/setup.c
>> +++ b/arch/mips/bcm47xx/setup.c
>> @@ -220,6 +220,8 @@ void __init plat_mem_setup(void)
>>  	_machine_restart = bcm47xx_machine_restart;
>>  	_machine_halt = bcm47xx_machine_halt;
>>  	pm_power_off = bcm47xx_machine_halt;
>> +
>> +	bcm47xx_gpio_init();
>>  }
>>  
>>  static int __init bcm47xx_register_bus_complete(void)
>> diff --git a/arch/mips/bcm47xx/wgt634u.c b/arch/mips/bcm47xx/wgt634u.c
>> index e9f9ec8..fd1066e 100644
>> --- a/arch/mips/bcm47xx/wgt634u.c
>> +++ b/arch/mips/bcm47xx/wgt634u.c
>> @@ -133,6 +133,7 @@ static int __init wgt634u_init(void)
>>  	 * been allocated ranges 00:09:5b:xx:xx:xx and 00:0f:b5:xx:xx:xx.
>>  	 */
>>  	u8 *et0mac;
>> +	int err;
>>  
>>  	if (bcm47xx_bus_type != BCM47XX_BUS_TYPE_SSB)
>>  		return -ENODEV;
>> @@ -146,6 +147,12 @@ static int __init wgt634u_init(void)
>>  
>>  		printk(KERN_INFO "WGT634U machine detected.\n");
>>  
>> +		err = gpio_request(WGT634U_GPIO_RESET, "reset-buton");
>> +		if (err) {
>> +			printk(KERN_INFO "Can not register gpio for reset button\n");
>> +			return 0;
>> +		}
>> +
>>  		if (!request_irq(gpio_to_irq(WGT634U_GPIO_RESET),
>>  				 gpio_interrupt, IRQF_SHARED,
>>  				 "WGT634U GPIO", &bcm47xx_bus.ssb.chipco)) {
>> diff --git a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h 
> b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
>> index 26fdaf4..1bd5560 100644
>> --- a/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
>> +++ b/arch/mips/include/asm/mach-bcm47xx/bcm47xx.h
>> @@ -56,4 +56,6 @@ void bcm47xx_fill_bcma_boardinfo(struct bcma_boardinfo 
> *boardinfo,
>>  				 const char *prefix);
>>  #endif
>>  
>> +void bcm47xx_gpio_init(void);
>> +
>>  #endif /* __ASM_BCM47XX_H */
>> diff --git a/arch/mips/include/asm/mach-bcm47xx/gpio.h 
> b/arch/mips/include/asm/mach-bcm47xx/gpio.h
>> index 2ef17e8..27a5632 100644
>> --- a/arch/mips/include/asm/mach-bcm47xx/gpio.h
>> +++ b/arch/mips/include/asm/mach-bcm47xx/gpio.h
>> @@ -4,152 +4,42 @@
>>   * for more details.
>>   *
>>   * Copyright (C) 2007 Aurelien Jarno <aurelien@aurel32.net>
>> + * Copyright (C) 2012 Hauke Mehrtens <hauke@hauke-m.de>
>>   */
>>  
>>  #ifndef __BCM47XX_GPIO_H
>>  #define __BCM47XX_GPIO_H
>>  
>> -#include <linux/ssb/ssb_embedded.h>
>> -#include <linux/bcma/bcma.h>
>> -#include <asm/mach-bcm47xx/bcm47xx.h>
>> +#define ARCH_NR_GPIOS	64
>> +#include <asm-generic/gpio.h>
>>  
>> -#define BCM47XX_EXTIF_GPIO_LINES	5
>> -#define BCM47XX_CHIPCO_GPIO_LINES	16
>> +/* low level BCM47xx gpio api */
>> +u32 bcm47xx_gpio_in(u32 mask);
>> +u32 bcm47xx_gpio_out(u32 mask, u32 value);
>> +u32 bcm47xx_gpio_outen(u32 mask, u32 value);
>> +u32 bcm47xx_gpio_control(u32 mask, u32 value);
>> +u32 bcm47xx_gpio_intmask(u32 mask, u32 value);
>> +u32 bcm47xx_gpio_polarity(u32 mask, u32 value);
>>  
>> -extern int gpio_request(unsigned gpio, const char *label);
>> -extern void gpio_free(unsigned gpio);
>> -extern int gpio_to_irq(unsigned gpio);
>> +int gpio_get_value(unsigned gpio);
>> +void gpio_set_value(unsigned gpio, int value);
>>  
>> -static inline int gpio_get_value(unsigned gpio)
>> +static inline void gpio_intmask(unsigned gpio, int value)
>>  {
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		return ssb_gpio_in(&bcm47xx_bus.ssb, 1 << gpio);
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		return bcma_chipco_gpio_in(&bcm47xx_bus.bcma.bus.drv_cc,
>> -					   1 << gpio);
>> -#endif
>> -	}
>> -	return -EINVAL;
>> -}
>> -
>> -#define gpio_get_value_cansleep	gpio_get_value
>> -
>> -static inline void gpio_set_value(unsigned gpio, int value)
>> -{
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
>> -			     value ? 1 << gpio : 0);
>> -		return;
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
>> -				     value ? 1 << gpio : 0);
>> -		return;
>> -#endif
>> -	}
>> -}
>> -
>> -#define gpio_set_value_cansleep gpio_set_value
>> -
>> -static inline int gpio_cansleep(unsigned gpio)
>> -{
>> -	return 0;
>> -}
>> -
>> -static inline int gpio_is_valid(unsigned gpio)
>> -{
>> -	return gpio < (BCM47XX_EXTIF_GPIO_LINES + BCM47XX_CHIPCO_GPIO_LINES);
>> -}
>> -
>> -
>> -static inline int gpio_direction_input(unsigned gpio)
>> -{
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 0);
>> -		return 0;
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
>> -				       0);
>> -		return 0;
>> -#endif
>> -	}
>> -	return -EINVAL;
>> +	bcm47xx_gpio_intmask(1 << gpio, value ? 1 << gpio : 0);
>>  }
>>  
>> -static inline int gpio_direction_output(unsigned gpio, int value)
>> +static inline void gpio_polarity(unsigned gpio, int value)
>>  {
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		/* first set the gpio out value */
>> -		ssb_gpio_out(&bcm47xx_bus.ssb, 1 << gpio,
>> -			     value ? 1 << gpio : 0);
>> -		/* then set the gpio mode */
>> -		ssb_gpio_outen(&bcm47xx_bus.ssb, 1 << gpio, 1 << gpio);
>> -		return 0;
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		/* first set the gpio out value */
>> -		bcma_chipco_gpio_out(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
>> -				     value ? 1 << gpio : 0);
>> -		/* then set the gpio mode */
>> -		bcma_chipco_gpio_outen(&bcm47xx_bus.bcma.bus.drv_cc, 1 << gpio,
>> -				       1 << gpio);
>> -		return 0;
>> -#endif
>> -	}
>> -	return -EINVAL;
>> -}
>> -
>> -static inline int gpio_intmask(unsigned gpio, int value)
>> -{
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		ssb_gpio_intmask(&bcm47xx_bus.ssb, 1 << gpio,
>> -				 value ? 1 << gpio : 0);
>> -		return 0;
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		bcma_chipco_gpio_intmask(&bcm47xx_bus.bcma.bus.drv_cc,
>> -					 1 << gpio, value ? 1 << gpio : 0);
>> -		return 0;
>> -#endif
>> -	}
>> -	return -EINVAL;
>> +	bcm47xx_gpio_polarity(1 << gpio, value ? 1 << gpio : 0);
>>  }
>>  
>> -static inline int gpio_polarity(unsigned gpio, int value)
>> +static inline int irq_to_gpio(int gpio)
>>  {
>> -	switch (bcm47xx_bus_type) {
>> -#ifdef CONFIG_BCM47XX_SSB
>> -	case BCM47XX_BUS_TYPE_SSB:
>> -		ssb_gpio_polarity(&bcm47xx_bus.ssb, 1 << gpio,
>> -				  value ? 1 << gpio : 0);
>> -		return 0;
>> -#endif
>> -#ifdef CONFIG_BCM47XX_BCMA
>> -	case BCM47XX_BUS_TYPE_BCMA:
>> -		bcma_chipco_gpio_polarity(&bcm47xx_bus.bcma.bus.drv_cc,
>> -					  1 << gpio, value ? 1 << gpio : 0);
>> -		return 0;
>> -#endif
>> -	}
>>  	return -EINVAL;
>>  }
>>  
>> +#define gpio_cansleep	__gpio_cansleep
>> +#define gpio_to_irq __gpio_to_irq
>>  
>>  #endif /* __BCM47XX_GPIO_H */
>>

