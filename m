Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57910 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab2GYMSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 08:18:36 -0400
Message-ID: <500FE411.3050703@hauke-m.de> (sfid-20120725_141840_705641_4EDBEE1A)
Date: Wed, 25 Jul 2012 14:18:25 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFT][PATCH 2/3] ssb: move flash info to ChipCommon driver
References: <1342975889-32687-1-git-send-email-zajec5@gmail.com> <1342975889-32687-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1342975889-32687-3-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moving the structure for parallel flash into chipCommon sturct is not
right, because there are some old SoCs out there without a ChipCommon
core, but with an extif core and they have parallel flash. Serial flash
is just available on SoCs with a ChipCommon core.

My original plan was to move the structures for parallel and serial
flash into a union, because I have never seen a SoC with both flash
types, but as this saves so little memory I would not do that any more.
What about putting the struct directly into the bus struct?

We still need an incicator if and which flash type was found on the
device or we register it directly from ssb and not in the platform code
under arch/mips/.

The last two points are also affecting bcma.

Hauke

On 07/22/2012 06:51 PM, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>  arch/mips/bcm47xx/nvram.c                 |    8 ++++----
>  arch/mips/bcm47xx/wgt634u.c               |   14 +++++++-------
>  drivers/ssb/driver_mipscore.c             |   12 ++++++------
>  include/linux/ssb/ssb_driver_chipcommon.h |   11 +++++++++++
>  include/linux/ssb/ssb_driver_mips.h       |    4 ----
>  5 files changed, 28 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/mips/bcm47xx/nvram.c b/arch/mips/bcm47xx/nvram.c
> index d43ceff..53822db 100644
> --- a/arch/mips/bcm47xx/nvram.c
> +++ b/arch/mips/bcm47xx/nvram.c
> @@ -27,7 +27,7 @@ static char nvram_buf[NVRAM_SPACE];
>  static void early_nvram_init(void)
>  {
>  #ifdef CONFIG_BCM47XX_SSB
> -	struct ssb_mipscore *mcore_ssb;
> +	struct ssb_chipcommon *ssb_cc;
>  #endif
>  #ifdef CONFIG_BCM47XX_BCMA
>  	struct bcma_drv_cc *bcma_cc;
> @@ -42,9 +42,9 @@ static void early_nvram_init(void)
>  	switch (bcm47xx_bus_type) {
>  #ifdef CONFIG_BCM47XX_SSB
>  	case BCM47XX_BUS_TYPE_SSB:
> -		mcore_ssb = &bcm47xx_bus.ssb.mipscore;
> -		base = mcore_ssb->flash_window;
> -		lim = mcore_ssb->flash_window_size;
> +		ssb_cc = &bcm47xx_bus.ssb.chipco;
> +		base = ssb_cc->pflash.window;
> +		lim = ssb_cc->pflash.window_size;
>  		break;
>  #endif
>  #ifdef CONFIG_BCM47XX_BCMA
> diff --git a/arch/mips/bcm47xx/wgt634u.c b/arch/mips/bcm47xx/wgt634u.c
> index e9f9ec8..616da92 100644
> --- a/arch/mips/bcm47xx/wgt634u.c
> +++ b/arch/mips/bcm47xx/wgt634u.c
> @@ -142,24 +142,24 @@ static int __init wgt634u_init(void)
>  	if (et0mac[0] == 0x00 &&
>  	    ((et0mac[1] == 0x09 && et0mac[2] == 0x5b) ||
>  	     (et0mac[1] == 0x0f && et0mac[2] == 0xb5))) {
> -		struct ssb_mipscore *mcore = &bcm47xx_bus.ssb.mipscore;
> +		struct ssb_chipcommon *cc = &bcm47xx_bus.ssb.chipco;
>  
>  		printk(KERN_INFO "WGT634U machine detected.\n");
>  
>  		if (!request_irq(gpio_to_irq(WGT634U_GPIO_RESET),
>  				 gpio_interrupt, IRQF_SHARED,
> -				 "WGT634U GPIO", &bcm47xx_bus.ssb.chipco)) {
> +				 "WGT634U GPIO", cc)) {
>  			gpio_direction_input(WGT634U_GPIO_RESET);
>  			gpio_intmask(WGT634U_GPIO_RESET, 1);
> -			ssb_chipco_irq_mask(&bcm47xx_bus.ssb.chipco,
> +			ssb_chipco_irq_mask(cc,
>  					    SSB_CHIPCO_IRQ_GPIO,
>  					    SSB_CHIPCO_IRQ_GPIO);
>  		}
>  
> -		wgt634u_flash_data.width = mcore->flash_buswidth;
> -		wgt634u_flash_resource.start = mcore->flash_window;
> -		wgt634u_flash_resource.end = mcore->flash_window
> -					   + mcore->flash_window_size
> +		wgt634u_flash_data.width = cc->pflash.buswidth;
> +		wgt634u_flash_resource.start = cc->pflash.window;
> +		wgt634u_flash_resource.end = cc->pflash.window
> +					   + cc->pflash.window_size
>  					   - 1;
>  		return platform_add_devices(wgt634u_devices,
>  					    ARRAY_SIZE(wgt634u_devices));
> diff --git a/drivers/ssb/driver_mipscore.c b/drivers/ssb/driver_mipscore.c
> index f8813f8..873bc0a 100644
> --- a/drivers/ssb/driver_mipscore.c
> +++ b/drivers/ssb/driver_mipscore.c
> @@ -190,16 +190,16 @@ static void ssb_mips_flash_detect(struct ssb_mipscore *mcore)
>  {
>  	struct ssb_bus *bus = mcore->dev->bus;
>  
> -	mcore->flash_buswidth = 2;
> +	bus->chipco.pflash.buswidth = 2;
>  	if (bus->chipco.dev) {
> -		mcore->flash_window = SSB_FLASH2;
> -		mcore->flash_window_size = SSB_FLASH2_SZ;
> +		bus->chipco.pflash.window = SSB_FLASH2;
> +		bus->chipco.pflash.window_size = SSB_FLASH2_SZ;
>  		if ((ssb_read32(bus->chipco.dev, SSB_CHIPCO_FLASH_CFG)
>  		               & SSB_CHIPCO_CFG_DS16) == 0)
> -			mcore->flash_buswidth = 1;
> +			bus->chipco.pflash.buswidth = 1;
>  	} else {
> -		mcore->flash_window = SSB_FLASH1;
> -		mcore->flash_window_size = SSB_FLASH1_SZ;
> +		bus->chipco.pflash.window = SSB_FLASH1;
> +		bus->chipco.pflash.window_size = SSB_FLASH1_SZ;
>  	}
>  }
>  
> diff --git a/include/linux/ssb/ssb_driver_chipcommon.h b/include/linux/ssb/ssb_driver_chipcommon.h
> index c2b02a5..ccb51d1 100644
> --- a/include/linux/ssb/ssb_driver_chipcommon.h
> +++ b/include/linux/ssb/ssb_driver_chipcommon.h
> @@ -584,6 +584,14 @@ struct ssb_chipcommon_pmu {
>  	u32 crystalfreq;	/* The active crystal frequency (in kHz) */
>  };
>  
> +#ifdef CONFIG_SSB_DRIVER_MIPS
> +struct ssb_pflash {
> +	u8 buswidth;
> +	u32 window;
> +	u32 window_size;
> +};
> +#endif /* CONFIG_SSB_DRIVER_MIPS */
> +
>  struct ssb_chipcommon {
>  	struct ssb_device *dev;
>  	u32 capabilities;
> @@ -591,6 +599,9 @@ struct ssb_chipcommon {
>  	/* Fast Powerup Delay constant */
>  	u16 fast_pwrup_delay;
>  	struct ssb_chipcommon_pmu pmu;
> +#ifdef CONFIG_SSB_DRIVER_MIPS
> +	struct ssb_pflash pflash;
> +#endif /* CONFIG_SSB_DRIVER_MIPS */
>  };
>  
>  static inline bool ssb_chipco_available(struct ssb_chipcommon *cc)
> diff --git a/include/linux/ssb/ssb_driver_mips.h b/include/linux/ssb/ssb_driver_mips.h
> index 5f44e97..7e707ff 100644
> --- a/include/linux/ssb/ssb_driver_mips.h
> +++ b/include/linux/ssb/ssb_driver_mips.h
> @@ -19,10 +19,6 @@ struct ssb_mipscore {
>  
>  	int nr_serial_ports;
>  	struct ssb_serial_port serial_ports[4];
> -
> -	u8 flash_buswidth;
> -	u32 flash_window;
> -	u32 flash_window_size;
>  };
>  
>  extern void ssb_mipscore_init(struct ssb_mipscore *mcore);
> 

