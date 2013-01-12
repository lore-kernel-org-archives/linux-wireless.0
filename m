Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54805 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab3ALOw0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2013 09:52:26 -0500
Message-ID: <50F178A1.7090205@hauke-m.de> (sfid-20130112_155229_837745_DD7D31CB)
Date: Sat, 12 Jan 2013 15:52:17 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] bcma: fix bcm4716/bcm4748 i2s irqflag
References: <BLU0-SMTP2344277AA51EC3C2665B8DCAC280@phx.gbl>
In-Reply-To: <BLU0-SMTP2344277AA51EC3C2665B8DCAC280@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/12/2013 07:07 AM, Nathan Hintz wrote:
> The default irqflag assignment for the I2S core on some Broadcom
> 4716/4748 devices is invalid and needs to be corrected (from the
> Broadcom SDK).
> 
> Signed-off-by: Nathan Hintz <nlhintz@hotmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/driver_mips.c            |   28 ++++++++++++++++++++++++++++
>  include/linux/bcma/bcma_driver_mips.h |    1 +
>  2 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
> index a808404..9fe86ee 100644
> --- a/drivers/bcma/driver_mips.c
> +++ b/drivers/bcma/driver_mips.c
> @@ -256,6 +256,32 @@ void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
>  	mcore->early_setup_done = true;
>  }
>  
> +static void bcma_fix_i2s_irqflag(struct bcma_bus *bus)
> +{
> +	struct bcma_device *cpu, *pcie, *i2s;
> +
> +	/* Fixup the interrupts in 4716/4748 for i2s core (2010 Broadcom SDK)
> +	 * (IRQ flags > 7 are ignored when setting the interrupt masks)
> +	 */
> +	if (bus->chipinfo.id != BCMA_CHIP_ID_BCM4716 &&
> +	    bus->chipinfo.id != BCMA_CHIP_ID_BCM4748)
> +		return;
> +
> +	cpu = bcma_find_core(bus, BCMA_CORE_MIPS_74K);
> +	pcie = bcma_find_core(bus, BCMA_CORE_PCIE);
> +	i2s = bcma_find_core(bus, BCMA_CORE_I2S);
> +	if (cpu && pcie && i2s &&
> +	    bcma_aread32(cpu, BCMA_MIPS_OOBSELINA74) == 0x08060504 &&
> +	    bcma_aread32(pcie, BCMA_MIPS_OOBSELINA74) == 0x08060504 &&
> +	    bcma_aread32(i2s, BCMA_MIPS_OOBSELOUTA30) == 0x88) {
> +		bcma_awrite32(cpu, BCMA_MIPS_OOBSELINA74, 0x07060504);
> +		bcma_awrite32(pcie, BCMA_MIPS_OOBSELINA74, 0x07060504);
> +		bcma_awrite32(i2s, BCMA_MIPS_OOBSELOUTA30, 0x87);
> +		bcma_debug(bus,
> +			   "Moved i2s interrupt to oob line 7 instead of 8\n");
> +	}
> +}
> +
>  void bcma_core_mips_init(struct bcma_drv_mips *mcore)
>  {
>  	struct bcma_bus *bus;
> @@ -269,6 +295,8 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
>  
>  	bcma_core_mips_early_init(mcore);
>  
> +	bcma_fix_i2s_irqflag(bus);
> +
>  	switch (bus->chipinfo.id) {
>  	case BCMA_CHIP_ID_BCM4716:
>  	case BCMA_CHIP_ID_BCM4748:
> diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
> index 73c7f4b..0d1ea29 100644
> --- a/include/linux/bcma/bcma_driver_mips.h
> +++ b/include/linux/bcma/bcma_driver_mips.h
> @@ -28,6 +28,7 @@
>  #define BCMA_MIPS_MIPS74K_GPIOEN	0x0048
>  #define BCMA_MIPS_MIPS74K_CLKCTLST	0x01E0
>  
> +#define BCMA_MIPS_OOBSELINA74		0x004
>  #define BCMA_MIPS_OOBSELOUTA30		0x100
>  
>  struct bcma_device;
> 

