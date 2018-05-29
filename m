Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49208 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751910AbeE2HQE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 03:16:04 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCHv2] wlcore: sdio: Fix flakey SDIO runtime PM handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180517182950.60807-1-tony@atomide.com>
References: <20180517182950.60807-1-tony@atomide.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-Id: <20180529071603.4DFD260541@smtp.codeaurora.org> (sfid-20180529_091638_090443_710C8B38)
Date: Tue, 29 May 2018 07:16:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> wrote:

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
> 
> Note that while wlcore checks the return value for wl1271_power_on(),
> the return value is ignored for wl1271_power_off(). Let's fix them
> both though to avoid further confusion in the future.
> 
> Fixes: 60f36637bbbd ("wlcore: sdio: allow pm to handle sdio power")
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Patch applied to wireless-drivers-next.git, thanks.

728a9dc61f13 wlcore: sdio: Fix flakey SDIO runtime PM handling

-- 
https://patchwork.kernel.org/patch/10407569/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
