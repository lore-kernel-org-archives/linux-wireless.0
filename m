Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:42342 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752179AbeEOU1w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 16:27:52 -0400
Date: Tue, 15 May 2018 13:27:48 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] wlcore: sdio: Fix flakey SDIO runtime PM handling
Message-ID: <20180515202747.GD98604@atomide.com> (sfid-20180515_222755_803653_FEDDD18F)
References: <20180515154334.121621-1-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180515154334.121621-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180515 15:46]:
> We can have pm_runtime_get_sync() return 1, and we can have
> pm_runtime_put_sync() return -EBUSY. See rpm_suspend() and
> rpm_resume() for more information.
> 
> Fix the issue by returning 0 from wl12xx_sdio_power_on() on success.
> And use pm_runtime_put() instead of pm_runtime_put_sync() for
> wl12xx_sdio_power_off(), then the MMC subsystem will idle the bus
> when suitable.
> 
> Otherwise wlcore can sometimes get confused and may report bogus
> errors and WLAN connection can fail.
> @@ -180,7 +180,7 @@ static int wl12xx_sdio_power_off(struct wl12xx_sdio_glue *glue)
>  	sdio_release_host(func);
>  
>  	/* Let runtime PM know the card is powered off */
> -	return pm_runtime_put_sync(&card->dev);
> +	return pm_runtime_put(&card->dev);
>  }

Looks like we can still get -EBUSY here though. I think we
can just ignore the return value of pm_runtime_put() here.

Regards,

Tony
