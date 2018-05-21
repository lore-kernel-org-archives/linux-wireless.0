Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:43934 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752594AbeEUWcg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 18:32:36 -0400
Date: Mon, 21 May 2018 15:32:32 -0700
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] wlcore: sdio: Warn about runtime PM suspend errors
Message-ID: <20180521223232.GC98604@atomide.com> (sfid-20180522_003243_462432_322247C2)
References: <20180517185029.71716-1-tony@atomide.com>
 <20180517185029.71716-6-tony@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180517185029.71716-6-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [180517 18:53]:
> We may get -EBUSY from runtime PM and that most likely means some
> earlier wlcore command did not complete yet and further calls may
> fail. Let's add a warning to make it easier to track down and fix
> such issues in wlcore code.

Related to the warnings produced with this patch, the following additional
patch seems to fix the timeout errors that happen at some point after
forcing recovery a few times.

Regards,

Tony

8< -------------------------
>From tony Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Wed, 16 May 2018 14:14:47 -0700
Subject: [PATCH] wclore: Fix timout errors after recovery

After enabling runtime PM, if we force hardware reset multiple times with:

# echo 1 > /sys/kernel/debug/ieee80211/phy0/wlcore/start_recovery

We will after few tries get the following error:

wlcore: ERROR timeout waiting for the hardware to complete initialization

And then wlcore is unable to reconnect until after the wlcore related modules
are reloaded.

Let's fix this by moving pm_runtime_put() earlier before we restart the hardware.
And let's use the sync version to make sure we're done before we restart.

Note that we still will get -EBUSY warning from wl12xx_sdio_set_power() but let's
fix that separately once we know exactly why we get the warning.

Reported-by: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -977,6 +977,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	}
 
 	wlcore_op_stop_locked(wl);
+	pm_runtime_put_sync(wl->dev);
 
 	ieee80211_restart_hw(wl->hw);
 
@@ -986,8 +987,6 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 */
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
 
-	pm_runtime_put(wl->dev);
-
 out_unlock:
 	wl->watchdog_recovery = false;
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
-- 
2.17.0
