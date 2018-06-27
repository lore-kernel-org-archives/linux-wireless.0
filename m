Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40048 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752937AbeF0Plw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Jun 2018 11:41:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [5/8] wclore: Fix timout errors after recovery
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180619094342.81831-6-tony@atomide.com>
References: <20180619094342.81831-6-tony@atomide.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Message-Id: <20180627154152.7434960791@smtp.codeaurora.org> (sfid-20180627_174157_377005_7DC80E5B)
Date: Wed, 27 Jun 2018 15:41:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> wrote:

> After enabling runtime PM, if we force hardware reset multiple times with:
> 
> # echo 1 > /sys/kernel/debug/ieee80211/phy0/wlcore/start_recovery
> 
> We will after few tries get the following error:
> 
> wlcore: ERROR timeout waiting for the hardware to complete initialization
> 
> And then wlcore is unable to reconnect until after the wlcore related modules
> are reloaded.
> 
> Let's fix this by moving pm_runtime_put() earlier before we restart the hardware.
> And let's use the sync version to make sure we're done before we restart.
> 
> Note that we still will get -EBUSY warning from wl12xx_sdio_set_power() but let's
> fix that separately once we know exactly why we get the warning.
> 
> Reported-by: Eyal Reizer <eyalr@ti.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

I'll do s/wclore/wlcore/ to the title.

-- 
https://patchwork.kernel.org/patch/10473897/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
