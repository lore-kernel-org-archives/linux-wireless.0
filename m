Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19212 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2AXLay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:30:54 -0500
Message-ID: <4F1E9667.1040504@qca.qualcomm.com> (sfid-20120124_123058_678797_8E775D5F)
Date: Tue, 24 Jan 2012 13:30:47 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH v2 1/8] ath6kl: Re-architect suspend mode handling in
 ath6kl_sdio_suspend
References: <1327066544-23779-1-git-send-email-rmani@qca.qualcomm.com> <1327066544-23779-2-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1327066544-23779-2-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/20/2012 03:35 PM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Using this patch, the user can bypass existing auto
> suspend mode selection logic and force ath6kl to enter
> into the suspend mode what he/she wants.
> 
> If the user doesn't choose any suspend mode while doing
> insmod of the driver, auto suspend mode selection logic
> will kick in and choose suspend mode based on the host
> SDIO controller capability.
> 
> Generic module parameter is required to specify suspend
> mode including Deep Sleep and WOW while doing insmod.
> Renaming existing mod param variable suspend_cutpower
> would be sufficient to meet this requirement.
> 
> New module parameter suspend_mode can take any one of
> the below suspend state,
>    1. cut power
>    2. deep sleep
>    3. wow
> 
> Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>

Few comments:

> --- a/drivers/net/wireless/ath/ath6kl/core.c
> +++ b/drivers/net/wireless/ath/ath6kl/core.c
> @@ -25,12 +25,12 @@
>  #include "cfg80211.h"
>  
>  unsigned int debug_mask;
> -static bool suspend_cutpower;
> +static unsigned char suspend_mode;

IMHO uint is better, just like below.

>  static unsigned int uart_debug;
>  static unsigned int ath6kl_p2p;
>  
>  module_param(debug_mask, uint, 0644);
> -module_param(suspend_cutpower, bool, 0444);
> +module_param(suspend_mode, byte, 0644);
>  module_param(uart_debug, uint, 0644);
>  module_param(ath6kl_p2p, uint, 0644);

> --- a/drivers/net/wireless/ath/ath6kl/sdio.c
> +++ b/drivers/net/wireless/ath/ath6kl/sdio.c
> @@ -779,7 +779,7 @@ out:
>  	return ret;
>  }
>  
> -static int ath6kl_sdio_suspend(struct ath6kl *ar, struct cfg80211_wowlan *wow)
> +static int ath6kl_set_sdio_pm_keep_pwr_wake_irq(struct ath6kl *ar)

The function name doesn't need to be this long, ath6kl_sdio_pm_caps(),
or something like that, is enough. And I'm not really sure if this
function makes sense, it complicates the error handling.

> +	if (ar->suspend_mode == WLAN_POWER_STATE_WOW ||
> +	    (!ar->suspend_mode && wow)) {
> +
> +		ret = ath6kl_set_sdio_pm_keep_pwr_wake_irq(ar);
> +		if (ret)
> +			goto cut_pwr;

This changes functionality so that if MMC_PM_WAKE_SDIO_IRQ is not
supported we will fallback to cutpower, earlier we would go to deep
sleep mode. I guess that's ok, but it still is a functionality change.

Kalle
