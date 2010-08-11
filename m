Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:30714 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755692Ab0HKKG2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 06:06:28 -0400
Message-ID: <4C6275F3.6030108@nokia.com>
Date: Wed, 11 Aug 2010 13:05:39 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>,
	"Quadros Roger (Nokia-MS/Helsinki)" <roger.quadros@nokia.com>,
	Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v3 8/9] omap: hsmmc: split mmc23 power control
References: <1281478348-24833-1-git-send-email-ohad@wizery.com> <1281478348-24833-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1281478348-24833-9-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen wrote:
> Prepare for mmc3 regulator power control by splitting the power
> control functions of mmc2 and mmc3, and expecting mmc3 to have
> a single, dedicated, regulator support.

Why?  Can't the controller be connected to an eMMC with 2 power
supplies?  At a glance, it is not obvious why this patch is needed.

> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> ---
>  arch/arm/mach-omap2/hsmmc.c   |   10 ++++--
>  drivers/mmc/host/omap_hsmmc.c |   67 ++++++++++++++++++++++++++++++++++++----
>  2 files changed, 66 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
> index 1ef54b0..5d3d789 100644
> --- a/arch/arm/mach-omap2/hsmmc.c
> +++ b/arch/arm/mach-omap2/hsmmc.c
> @@ -174,7 +174,7 @@ static void omap4_hsmmc1_after_set_reg(struct device *dev, int slot,
>  	}
>  }
>  
> -static void hsmmc23_before_set_reg(struct device *dev, int slot,
> +static void hsmmc2_before_set_reg(struct device *dev, int slot,
>  				   int power_on, int vdd)
>  {
>  	struct omap_mmc_platform_data *mmc = dev->platform_data;
> @@ -325,14 +325,16 @@ void __init omap2_hsmmc_init(struct omap2_hsmmc_info *controllers)
>  				c->transceiver = 1;
>  			if (c->transceiver && c->wires > 4)
>  				c->wires = 4;
> -			/* FALLTHROUGH */
> -		case 3:
>  			if (mmc->slots[0].features & HSMMC_HAS_PBIAS) {
>  				/* off-chip level shifting, or none */
> -				mmc->slots[0].before_set_reg = hsmmc23_before_set_reg;
> +				mmc->slots[0].before_set_reg = hsmmc2_before_set_reg;
>  				mmc->slots[0].after_set_reg = NULL;
>  			}
>  			break;
> +		case 3:
> +			mmc->slots[0].before_set_reg = NULL;
> +			mmc->slots[0].after_set_reg = NULL;
> +			break;
>  		default:
>  			pr_err("MMC%d configuration not supported!\n", c->mmc);
>  			kfree(mmc);
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index d50e917..6f5cea0 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -258,7 +258,7 @@ static int omap_hsmmc_1_set_power(struct device *dev, int slot, int power_on,
>  	return ret;
>  }
>  
> -static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
> +static int omap_hsmmc_2_set_power(struct device *dev, int slot, int power_on,
>  				   int vdd)
>  {
>  	struct omap_hsmmc_host *host =
> @@ -309,6 +309,31 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
>  	return ret;
>  }
>  
> +static int omap_hsmmc_3_set_power(struct device *dev, int slot, int power_on,
> +				   int vdd)
> +{
> +	struct omap_hsmmc_host *host =
> +		platform_get_drvdata(to_platform_device(dev));
> +	int ret = 0;
> +
> +	if (power_on) {
> +		ret = mmc_regulator_set_ocr(host->vcc, vdd);
> +		/* Enable interface voltage rail, if needed */
> +		if (ret == 0 && host->vcc) {
> +			ret = regulator_enable(host->vcc);
> +			if (ret < 0)
> +				ret = mmc_regulator_set_ocr(host->vcc, 0);
> +		}
> +	} else {
> +		if (host->vcc)
> +			ret = regulator_disable(host->vcc);
> +		if (ret == 0)
> +			ret = mmc_regulator_set_ocr(host->vcc, 0);
> +	}
> +
> +	return ret;
> +}
> +
>  static int omap_hsmmc_1_set_sleep(struct device *dev, int slot, int sleep,
>  				  int vdd, int cardsleep)
>  {
> @@ -319,7 +344,7 @@ static int omap_hsmmc_1_set_sleep(struct device *dev, int slot, int sleep,
>  	return regulator_set_mode(host->vcc, mode);
>  }
>  
> -static int omap_hsmmc_23_set_sleep(struct device *dev, int slot, int sleep,
> +static int omap_hsmmc_2_set_sleep(struct device *dev, int slot, int sleep,
>  				   int vdd, int cardsleep)
>  {
>  	struct omap_hsmmc_host *host =
> @@ -358,6 +383,31 @@ static int omap_hsmmc_23_set_sleep(struct device *dev, int slot, int sleep,
>  		return regulator_enable(host->vcc_aux);
>  }
>  
> +static int omap_hsmmc_3_set_sleep(struct device *dev, int slot, int sleep,
> +				   int vdd, int cardsleep)
> +{
> +	struct omap_hsmmc_host *host =
> +		platform_get_drvdata(to_platform_device(dev));
> +	int err = 0;
> +
> +	/*
> +	 * If we don't see a Vcc regulator, assume it's a fixed
> +	 * voltage always-on regulator.
> +	 */
> +	if (!host->vcc)
> +		return 0;
> +
> +	if (cardsleep) {
> +		/* VCC can be turned off if card is asleep */
> +		if (sleep)
> +			err = mmc_regulator_set_ocr(host->vcc, 0);
> +		else
> +			err = mmc_regulator_set_ocr(host->vcc, vdd);
> +	}
> +
> +	return err;
> +}
> +
>  static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
>  {
>  	struct regulator *reg;
> @@ -370,10 +420,13 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
>  		mmc_slot(host).set_sleep = omap_hsmmc_1_set_sleep;
>  		break;
>  	case OMAP_MMC2_DEVID:
> -	case OMAP_MMC3_DEVID:
>  		/* Off-chip level shifting, or none */
> -		mmc_slot(host).set_power = omap_hsmmc_23_set_power;
> -		mmc_slot(host).set_sleep = omap_hsmmc_23_set_sleep;
> +		mmc_slot(host).set_power = omap_hsmmc_2_set_power;
> +		mmc_slot(host).set_sleep = omap_hsmmc_2_set_sleep;
> +		break;
> +	case OMAP_MMC3_DEVID:
> +		mmc_slot(host).set_power = omap_hsmmc_3_set_power;
> +		mmc_slot(host).set_sleep = omap_hsmmc_3_set_sleep;
>  		break;
>  	default:
>  		pr_err("MMC%d configuration not supported!\n", host->id);
> @@ -386,9 +439,9 @@ static int omap_hsmmc_reg_get(struct omap_hsmmc_host *host)
>  		/*
>  		* HACK: until fixed.c regulator is usable,
>  		* we don't require a main regulator
> -		* for MMC2 or MMC3
> +		* for MMC2
>  		*/
> -		if (host->id == OMAP_MMC1_DEVID) {
> +		if (host->id != OMAP_MMC2_DEVID) {
>  			ret = PTR_ERR(reg);
>  			goto err;
>  		}

