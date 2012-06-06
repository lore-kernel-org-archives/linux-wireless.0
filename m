Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53700 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab2FFMWL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 08:22:11 -0400
Received: by eeit10 with SMTP id t10so2297832eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jun 2012 05:22:07 -0700 (PDT)
From: Florian Fainelli <florian@openwrt.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, zajec5@gmail.com,
	b43-dev@lists.infradead.org, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 6/8] bcma: handle SoCs in pmu initialization
Date: Wed, 06 Jun 2012 14:19:53 +0200
Message-ID: <2716026.rMfCBzMpF9@flexo> (sfid-20120606_142214_865011_F1C58855)
In-Reply-To: <1338933307-13446-7-git-send-email-hauke@hauke-m.de>
References: <1338933307-13446-1-git-send-email-hauke@hauke-m.de> <1338933307-13446-7-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Tuesday 05 June 2012 23:55:05 Hauke Mehrtens wrote:
> The SoCs do not need any special handling in bcma_pmu_pll_init(),
> bcma_pmu_resources_init(), bcma_pmu_swreg_init() and
> bcma_pmu_workarounds. This patches suppresses some warnings in the log.

This does not look like it scales very good, how about you turn the pr_err() 
into a pr_debug() so that developpers porting bcma on a new chip need to turn 
on the appropriate debug knobs to get the message?

> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/bcma/driver_chipcommon_pmu.c |   32 
++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/bcma/driver_chipcommon_pmu.c 
b/drivers/bcma/driver_chipcommon_pmu.c
> index 2ebba9c..9bf2dff 100644
> --- a/drivers/bcma/driver_chipcommon_pmu.c
> +++ b/drivers/bcma/driver_chipcommon_pmu.c
> @@ -63,6 +63,14 @@ static void bcma_pmu_pll_init(struct bcma_drv_cc *cc)
>  	case BCMA_CHIP_ID_BCM4331:
>  	case BCMA_CHIP_ID_BCM43224:
>  	case BCMA_CHIP_ID_BCM43225:
> +	case BCMA_CHIP_ID_BCM4716:
> +	case BCMA_CHIP_ID_BCM4748:
> +	case BCMA_CHIP_ID_BCM47162:
> +	case BCMA_CHIP_ID_BCM4749:
> +	case BCMA_CHIP_ID_BCM5357:
> +	case BCMA_CHIP_ID_BCM5356:
> +	case BCMA_CHIP_ID_BCM53572:
> +	case BCMA_CHIP_ID_BCM4706:
>  		break;
>  	default:
>  		pr_err("PLL init unknown for device 0x%04X\n",
> @@ -83,6 +91,14 @@ static void bcma_pmu_resources_init(struct bcma_drv_cc 
*cc)
>  	case BCMA_CHIP_ID_BCM4331:
>  	case BCMA_CHIP_ID_BCM43224:
>  	case BCMA_CHIP_ID_BCM43225:
> +	case BCMA_CHIP_ID_BCM4716:
> +	case BCMA_CHIP_ID_BCM4748:
> +	case BCMA_CHIP_ID_BCM47162:
> +	case BCMA_CHIP_ID_BCM4749:
> +	case BCMA_CHIP_ID_BCM5357:
> +	case BCMA_CHIP_ID_BCM5356:
> +	case BCMA_CHIP_ID_BCM53572:
> +	case BCMA_CHIP_ID_BCM4706:
>  		break;
>  	default:
>  		pr_err("PMU resource config unknown for device 0x%04X\n",
> @@ -105,6 +121,14 @@ static void bcma_pmu_swreg_init(struct bcma_drv_cc *cc)
>  	case BCMA_CHIP_ID_BCM4331:
>  	case BCMA_CHIP_ID_BCM43224:
>  	case BCMA_CHIP_ID_BCM43225:
> +	case BCMA_CHIP_ID_BCM4716:
> +	case BCMA_CHIP_ID_BCM4748:
> +	case BCMA_CHIP_ID_BCM47162:
> +	case BCMA_CHIP_ID_BCM4749:
> +	case BCMA_CHIP_ID_BCM5357:
> +	case BCMA_CHIP_ID_BCM5356:
> +	case BCMA_CHIP_ID_BCM53572:
> +	case BCMA_CHIP_ID_BCM4706:
>  		break;
>  	default:
>  		pr_err("PMU switch/regulators init unknown for device "
> @@ -168,6 +192,14 @@ static void bcma_pmu_workarounds(struct bcma_drv_cc 
*cc)
>  		}
>  		break;
>  	case BCMA_CHIP_ID_BCM43225:
> +	case BCMA_CHIP_ID_BCM4716:
> +	case BCMA_CHIP_ID_BCM4748:
> +	case BCMA_CHIP_ID_BCM47162:
> +	case BCMA_CHIP_ID_BCM4749:
> +	case BCMA_CHIP_ID_BCM5357:
> +	case BCMA_CHIP_ID_BCM5356:
> +	case BCMA_CHIP_ID_BCM53572:
> +	case BCMA_CHIP_ID_BCM4706:
>  		break;
>  	default:
>  		pr_err("Workarounds unknown for device 0x%04X\n",
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Florian
