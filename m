Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1971 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab1HKQx2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 12:53:28 -0400
Message-ID: <4E4408F6.2040606@broadcom.com> (sfid-20110811_185331_842212_7A17A3E2)
Date: Thu, 11 Aug 2011 18:53:10 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] bcma: implement BCM4331 workaround for external PA
 lines
References: <1313055255-3088-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1313055255-3088-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/11/2011 11:34 AM, Rafał Miłecki wrote:
> We need to disable ext. PA lines for reading SPROM. It's disabled by
> default, but this patch allows using bcma after loading wl, which leaves
> workaround enabled.
>
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
>   drivers/bcma/driver_chipcommon_pmu.c        |   20 +++++++++++++++++++-
>   drivers/bcma/sprom.c                        |    6 ++++++
>   include/linux/bcma/bcma_driver_chipcommon.h |   18 ++++++++++++++++++
>   3 files changed, 43 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c b/drivers/bcma/driver_chipcommon_pmu.c
> index 5940c81..a3854ff 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -90,6 +90,24 @@ void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
>   	}
>   }
>
> +/* Disable to allow reading SPROM. Don't know the adventages of enabling it. */
> +void bcma_chipco_bcm4331_exp_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable)

Would 'ext_pa' iso 'exp_pa' be better here?

> +{
> +	struct bcma_bus *bus = cc->core->bus;
> +	u32 val;
> +
> +	val = bcma_cc_read32(cc, BCMA_CC_CHIPCTL);
> +	if (enable) {
> +		val |= BCMA_CHIPCTL_4331_EXTPA_EN;
> +		if (bus->chipinfo.pkg == 9 || bus->chipinfo.pkg == 11)
> +			val |= BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
> +	} else {
> +		val&= ~BCMA_CHIPCTL_4331_EXTPA_EN;
> +		val&= ~BCMA_CHIPCTL_4331_EXTPA_ON_GPIO2_5;
> +	}
> +	bcma_cc_write32(cc, BCMA_CC_CHIPCTL, val);
> +}
> +
>   void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
>   {
>   	struct bcma_bus *bus = cc->core->bus;
> @@ -99,7 +117,7 @@ void bcma_pmu_workarounds(struct bcma_drv_cc *cc)
>   		bcma_chipco_chipctl_maskset(cc, 0, ~0, 0x7);
>   		break;
>   	case 0x4331:
> -		pr_err("Enabling Ext PA lines not implemented\n");
> +		/* BCM4331 workaround is SPROM-related, we put it in sprom.c */
>   		break;
>   	case 43224:
>   		if (bus->chipinfo.rev == 0) {
> diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
> index 8b5b785..94c6b3f 100644
> --- a/drivers/bcma/sprom.c
> +++ b/drivers/bcma/sprom.c
> @@ -152,6 +152,9 @@ int bcma_sprom_get(struct bcma_bus *bus)
>   	if (!sprom)
>   		return -ENOMEM;
>
> +	if (bus->chipinfo.id == 0x4331)
> +		bcma_chipco_bcm4331_exp_pa_lines_ctl(&bus->drv_cc, false);
> +
dito here.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


