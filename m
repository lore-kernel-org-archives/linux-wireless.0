Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45036 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965797AbeE2SGW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 14:06:22 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [RFT 5/6] wclore: Fix timout errors after recovery
Date: Tue, 29 May 2018 11:06:04 -0700
Message-Id: <20180529180605.73622-6-tony@atomide.com> (sfid-20180529_200651_656107_9872545E)
In-Reply-To: <20180529180605.73622-1-tony@atomide.com>
References: <20180529180605.73622-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
