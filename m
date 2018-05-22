Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43958 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751214AbeEVNcC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 09:32:02 -0400
Date: Tue, 22 May 2018 06:31:58 -0700
From: Tony Lindgren <tony@atomide.com>
To: "Reizer, Eyal" <eyalr@ti.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        KISHON VIJAY ABRAHAM <kishon@ti.com>,
        "Mishol, Guy" <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Hahn, Maital" <maitalm@ti.com>,
        "Altshul, Maxim" <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Loewy, Chen" <c-loewy@ti.com>
Subject: Re: [EXTERNAL] [PATCHv2 0/5] Runtime PM support for wlcore
Message-ID: <20180522133158.GE98604@atomide.com> (sfid-20180522_153206_116148_04D2E27E)
References: <20180517185029.71716-1-tony@atomide.com>
 <bff51dcc6fd441d9ab42db273219aaf4@ti.com>
 <20180521163830.GZ98604@atomide.com>
 <20180521224339.GD98604@atomide.com>
 <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <38ddca4c73bb4dbf835a84133035dbfb@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Reizer, Eyal <eyalr@ti.com> [180522 13:28]:
> Actually the below patch removing the call to wlcore_fw_sleep() avoids this error.
> The downside is that the wl8 firmware remains fully active during supend, so we
> Would need to find the root cause why the last call allowing the wilink8 firmware 
> To go into ELP mode during suspend is only completing on resume and not during
> Suspend enter.
> 
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index 4c297aa..8df1ae6 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -1789,7 +1789,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>                 goto out_sleep;
> 
>  out_sleep:
> -       pm_runtime_put_noidle(wl->dev);
>         mutex_unlock(&wl->mutex);
> 
>         if (ret < 0) {
> @@ -1821,15 +1820,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
>          */
>         cancel_delayed_work(&wl->tx_watchdog_work);
> 
> -       /*
> -        * Use an immediate call for allowing the firmware to go into power
> -        * save during suspend.
> -        * Using a workque for this last write was only hapenning on resume
> -        * leaving the firmware with power save disabled during suspend,
> -        * while consuming full power during wowlan suspend.
> -        */
> -       wlcore_fw_sleep(wl);
> -
> +       pm_runtime_put_noidle(wl->dev);
>         return 0;
>  }

OK try replacing the pm_runtime_put_noidle() above with just
pm_runtime_put_sync(). The reason why I put noidle there was the
wlcore_fw_sleep() call, with that gone put_sync should do the trick.

Regards,

Tony
