Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lelnx194.ext.ti.com ([198.47.27.80]:10811 "EHLO
        lelnx194.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965759AbeE2TXK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 15:23:10 -0400
Subject: Re: [RFT 6/6] wlcore: Use generic runtime pm calls for wowlan elp
 configuration
To: Tony Lindgren <tony@atomide.com>, Kalle Valo <kvalo@codeaurora.org>
CC: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        <linux-wireless@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Eyal Reizer <eyalreizer@gmail.com>
References: <20180529180605.73622-1-tony@atomide.com>
 <20180529180605.73622-7-tony@atomide.com>
From: Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <75fb865b-dc84-2e7d-d879-581e65dc343d@ti.com> (sfid-20180529_212515_920621_E6CDEB9D)
Date: Tue, 29 May 2018 14:23:05 -0500
MIME-Version: 1.0
In-Reply-To: <20180529180605.73622-7-tony@atomide.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/29/2018 01:06 PM, Tony Lindgren wrote:
> From: Eyal Reizer <eyalreizer@gmail.com>
> 
> With runtime PM enabled, we can now use generic calls to
> pm_generic_runtime_suspend and pm_generic_runtime_resume for enabling elp
> during suspend when wowlan is enabled and waking the chip from elp
> on resume.

Sry, but not sure you can :(

These functions are not used by drivers directly because system suspend
are not synchronized with PM runtime, so if you call pm_generic_runtime_suspend()
and, at the same time, there is pm_runtime_get_() in progress --> race ...

The pm_runtime_force_() APIs have to be used, or 
PM runtime drivers functions can be called directly, but only if it possible to be
sure no other PM runtime calls active which is usually true at suspend_noirq stage. 

> 
> Remove the custom API that was used to ensure that the command
> that is used to allow ELP during suspend is completed before the system
> suspend.
> 
> Signed-off-by: Eyal Reizer <eyalr@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>   drivers/net/wireless/ti/wlcore/main.c | 51 +++++++--------------------
>   1 file changed, 13 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -998,24 +998,6 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
>   	return wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
>   }
>   
> -static int wlcore_fw_sleep(struct wl1271 *wl)

[...]

-- 
regards,
-grygorii
