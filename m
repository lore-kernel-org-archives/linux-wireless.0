Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42550 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750862AbeEPQRz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 May 2018 12:17:55 -0400
Date: Wed, 16 May 2018 09:17:52 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/2] wlcore: Make sure PM calls are paired
Message-ID: <20180516161751.GH98604@atomide.com> (sfid-20180516_181800_319872_CC2C9C27)
References: <20180515161315.1997-1-tony@atomide.com>
 <20180515161315.1997-2-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180515161315.1997-2-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180515 16:15]:
> The call to wl1271_ps_elp_wakeup() in wl12xx_queue_recovery_work() is
> unpaired. Let's remove it and add paired calls to wl1271_recovery_work()
> instead in preparation for changing things to use runtime PM.
> 
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> ---
>  drivers/net/wireless/ti/wlcore/main.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -796,7 +796,6 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
>  
>  		wl->state = WLCORE_STATE_RESTARTING;
>  		set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
> -		wl1271_ps_elp_wakeup(wl);
>  		wlcore_disable_interrupts_nosync(wl);
>  		ieee80211_queue_work(wl->hw, &wl->recovery_work);
>  	}

OK found it, we need to move wlcore_disable_interrupts_nosync(wl) to
wl1271_recovery_work() below also as otherwise wl1271_ps_elp_wakeup()
times out.

Regards,

Tony
