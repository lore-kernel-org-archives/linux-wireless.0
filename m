Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:61064 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab0HKIaX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 04:30:23 -0400
Message-ID: <4C625FA5.8070705@nokia.com>
Date: Wed, 11 Aug 2010 11:30:29 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Tony Lindgren <tony@atomide.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Pandita Vikram <vikram.pandita@ti.com>,
	Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH v3 8/9] omap: hsmmc: split mmc23 power control
References: <1281478348-24833-1-git-send-email-ohad@wizery.com> <1281478348-24833-9-git-send-email-ohad@wizery.com>
In-Reply-To: <1281478348-24833-9-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ohad,

On 08/11/2010 01:12 AM, ext Ohad Ben-Cohen wrote:
> Prepare for mmc3 regulator power control by splitting the power
> control functions of mmc2 and mmc3, and expecting mmc3 to have
> a single, dedicated, regulator support.
>
> Signed-off-by: Ohad Ben-Cohen<ohad@wizery.com>
> ---
>   arch/arm/mach-omap2/hsmmc.c   |   10 ++++--
>   drivers/mmc/host/omap_hsmmc.c |   67 ++++++++++++++++++++++++++++++++++++----
>   2 files changed, 66 insertions(+), 11 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/hsmmc.c b/arch/arm/mach-omap2/hsmmc.c
> index 1ef54b0..5d3d789 100644
> --- a/arch/arm/mach-omap2/hsmmc.c
> +++ b/arch/arm/mach-omap2/hsmmc.c
> @@ -174,7 +174,7 @@ static void omap4_hsmmc1_after_set_reg(struct device *dev, int slot,
>   	}
>   }
>
> -static void hsmmc23_before_set_reg(struct device *dev, int slot,
> +static void hsmmc2_before_set_reg(struct device *dev, int slot,
>   				   int power_on, int vdd)
>   {
>   	struct omap_mmc_platform_data *mmc = dev->platform_data;
> @@ -325,14 +325,16 @@ void __init omap2_hsmmc_init(struct omap2_hsmmc_info *controllers)
>   				c->transceiver = 1;
>   			if (c->transceiver&&  c->wires>  4)
>   				c->wires = 4;
> -			/* FALLTHROUGH */
> -		case 3:
>   			if (mmc->slots[0].features&  HSMMC_HAS_PBIAS) {
>   				/* off-chip level shifting, or none */
> -				mmc->slots[0].before_set_reg = hsmmc23_before_set_reg;
> +				mmc->slots[0].before_set_reg = hsmmc2_before_set_reg;
>   				mmc->slots[0].after_set_reg = NULL;
>   			}
>   			break;
> +		case 3:
> +			mmc->slots[0].before_set_reg = NULL;
> +			mmc->slots[0].after_set_reg = NULL;
> +			break;
>   		default:
>   			pr_err("MMC%d configuration not supported!\n", c->mmc);
>   			kfree(mmc);
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index d50e917..6f5cea0 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -258,7 +258,7 @@ static int omap_hsmmc_1_set_power(struct device *dev, int slot, int power_on,
>   	return ret;
>   }
>
> -static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
> +static int omap_hsmmc_2_set_power(struct device *dev, int slot, int power_on,
>   				   int vdd)
>   {
>   	struct omap_hsmmc_host *host =
> @@ -309,6 +309,31 @@ static int omap_hsmmc_23_set_power(struct device *dev, int slot, int power_on,
>   	return ret;
>   }
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
Why is this needed? In this case interface voltage rail seems to be the same as 
card supply.

If you notice mmc_regulator_set_ocr code, it is doing the regulator enable, so 
don't need to enable it again below.

> +		if (ret == 0&&  host->vcc) {
> +			ret = regulator_enable(host->vcc);
> +			if (ret<  0)
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

All This can be replaced to the following to simply

if (power_on) {
	return mmc_regulator_set_ocr(host->vcc, vdd);
else
	return mmc_regulator_set_ocr(host->vcc, 0);

regards,
-roger
