Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:52856
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S970039AbXHMMTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 08:19:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Aurelien Jarno <aurelien@aurel32.net>
Subject: Re: [PATCH][SSB] Add GPIO support to Chip Common and PCI core drivers
Date: Mon, 13 Aug 2007 14:18:23 +0200
Cc: linux-wireless@vger.kernel.org
References: <20070812235135.GB4966@hall.aurel32.net>
In-Reply-To: <20070812235135.GB4966@hall.aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200708131418.24145.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 13 August 2007 01:51:35 Aurelien Jarno wrote:
> The patch below adds a functions to Chip Common and PCI core drivers to
> access the GPIO lines.
> 
> Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
> 
> --- a/drivers/ssb/driver_chipcommon.c
> +++ b/drivers/ssb/driver_chipcommon.c
> @@ -39,6 +39,14 @@
>  	ssb_write32(cc->dev, offset, value);
>  }
>  
> +static inline void chipco_write32_masked(struct ssb_chipcommon *cc, u16 offset,
> +					 u32 mask, u32 value)
> +{
> +	value &= mask;
> +	value |= chipco_read32(cc, offset) & ~mask;
> +	chipco_write32(cc, offset, value);
> +}
> +
>  void ssb_chipco_set_clockmode(struct ssb_chipcommon *cc,
>  			      enum ssb_clkmode mode)
>  {
> @@ -344,6 +352,21 @@
>  	chipco_write32(cc, SSB_CHIPCO_WATCHDOG, ticks);
>  }
>  
> +u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask)
> +{
> +	return chipco_read32(cc, SSB_CHIPCO_GPIOIN) & mask;
> +}
> +
> +void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value)
> +{
> +	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUT, mask, value);
> +}
> +
> +void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value)
> +{
> +	return chipco_write32_masked(cc, SSB_CHIPCO_GPIOOUTEN, mask, value);
> +}
> +
>  #ifdef CONFIG_SSB_SERIAL
>  int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
>  			   struct ssb_serial_port *ports)
> --- a/drivers/ssb/driver_extif.c
> +++ b/drivers/ssb/driver_extif.c
> @@ -27,6 +27,14 @@
>  	ssb_write32(extif->dev, offset, value);
>  }
>  
> +static inline void extif_write32_masked(struct ssb_extif *extif, u16 offset,
> +					u32 mask, u32 value)
> +{
> +	value &= mask;
> +	value |= extif_read32(extif, offset) & ~mask;
> +	extif_write32(extif, offset, value);
> +}
> +
>  #ifdef CONFIG_SSB_SERIAL
>  static bool serial_exists(u8 *regs)
>  {
> @@ -102,3 +110,20 @@
>  	*m = extif_read32(extif, SSB_EXTIF_CLOCK_SB);
>  }
>  
> +u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask)
> +{
> +	return extif_read32(extif, SSB_EXTIF_GPIO_IN) & mask;
> +}
> +
> +void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value)
> +{
> +	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUT(0),
> +				   mask, value);
> +}
> +
> +void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value)
> +{
> +	return extif_write32_masked(extif, SSB_EXTIF_GPIO_OUTEN(0),
> +				   mask, value);
> +}
> +
> --- a/include/linux/ssb/ssb_driver_chipcommon.h
> +++ b/include/linux/ssb/ssb_driver_chipcommon.h
> @@ -382,6 +382,12 @@
>  extern void ssb_chipco_watchdog_timer_set(struct ssb_chipcommon *cc,
>  					  u32 ticks);
>  
> +u32 ssb_chipco_gpio_in(struct ssb_chipcommon *cc, u32 mask);
> +
> +void ssb_chipco_gpio_out(struct ssb_chipcommon *cc, u32 mask, u32 value);
> +
> +void ssb_chipco_gpio_outen(struct ssb_chipcommon *cc, u32 mask, u32 value);
> +
>  #ifdef CONFIG_SSB_SERIAL
>  extern int ssb_chipco_serial_init(struct ssb_chipcommon *cc,
>  				  struct ssb_serial_port *ports);
> --- a/include/linux/ssb/ssb_driver_extif.h
> +++ b/include/linux/ssb/ssb_driver_extif.h
> @@ -171,6 +171,12 @@
>  extern void ssb_extif_timing_init(struct ssb_extif *extif,
>  				  unsigned long ns);
>  
> +u32 ssb_extif_gpio_in(struct ssb_extif *extif, u32 mask);
> +
> +void ssb_extif_gpio_out(struct ssb_extif *extif, u32 mask, u32 value);
> +
> +void ssb_extif_gpio_outen(struct ssb_extif *extif, u32 mask, u32 value);
> +
>  #ifdef CONFIG_SSB_SERIAL
>  extern int ssb_extif_serial_init(struct ssb_extif *extif,
>  				 struct ssb_serial_port *ports);
> 

Queued, thanks!

-- 
Greetings Michael.
