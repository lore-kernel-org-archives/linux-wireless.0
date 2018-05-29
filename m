Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:45044 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965543AbeE2SGY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 14:06:24 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, Eyal Reizer <eyalreizer@gmail.com>
Subject: [RFT 6/6] wlcore: Use generic runtime pm calls for wowlan elp configuration
Date: Tue, 29 May 2018 11:06:05 -0700
Message-Id: <20180529180605.73622-7-tony@atomide.com> (sfid-20180529_200654_264624_B66E7BD3)
In-Reply-To: <20180529180605.73622-1-tony@atomide.com>
References: <20180529180605.73622-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Reizer <eyalreizer@gmail.com>

With runtime PM enabled, we can now use generic calls to
pm_generic_runtime_suspend and pm_generic_runtime_resume for enabling elp
during suspend when wowlan is enabled and waking the chip from elp
on resume.

Remove the custom API that was used to ensure that the command
that is used to allow ELP during suspend is completed before the system
suspend.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/main.c | 51 +++++++--------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -998,24 +998,6 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
 	return wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_WAKE_UP);
 }
 
-static int wlcore_fw_sleep(struct wl1271 *wl)
-{
-	int ret;
-
-	mutex_lock(&wl->mutex);
-	ret = wlcore_raw_write32(wl, HW_ACCESS_ELP_CTRL_REG, ELPCTRL_SLEEP);
-	if (ret < 0) {
-		wl12xx_queue_recovery_work(wl);
-		goto out;
-	}
-	set_bit(WL1271_FLAG_IN_ELP, &wl->flags);
-out:
-	mutex_unlock(&wl->mutex);
-	mdelay(WL1271_SUSPEND_SLEEP);
-
-	return 0;
-}
-
 static int wl1271_setup(struct wl1271 *wl)
 {
 	wl->raw_fw_status = kzalloc(wl->fw_status_len, GFP_KERNEL);
@@ -1738,6 +1720,7 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
+	unsigned long flags;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
@@ -1796,19 +1779,6 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
 	/* flush any remaining work */
 	wl1271_debug(DEBUG_MAC80211, "flushing remaining works");
 
-	/*
-	 * disable and re-enable interrupts in order to flush
-	 * the threaded_irq
-	 */
-	wlcore_disable_interrupts(wl);
-
-	/*
-	 * set suspended flag to avoid triggering a new threaded_irq
-	 * work. no need for spinlock as interrupts are disabled.
-	 */
-	set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
-
-	wlcore_enable_interrupts(wl);
 	flush_work(&wl->tx_work);
 
 	/*
@@ -1818,15 +1788,14 @@ static int __maybe_unused wl1271_op_suspend(struct ieee80211_hw *hw,
 	cancel_delayed_work(&wl->tx_watchdog_work);
 
 	/*
-	 * Use an immediate call for allowing the firmware to go into power
-	 * save during suspend.
-	 * Using a workque for this last write was only hapenning on resume
-	 * leaving the firmware with power save disabled during suspend,
-	 * while consuming full power during wowlan suspend.
+	 * set suspended flag to avoid triggering a new threaded_irq
+	 * work.
 	 */
-	wlcore_fw_sleep(wl);
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	set_bit(WL1271_FLAG_SUSPENDED, &wl->flags);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
-	return 0;
+	return pm_generic_runtime_suspend(wl->dev);
 }
 
 static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
@@ -1841,6 +1810,12 @@ static int __maybe_unused wl1271_op_resume(struct ieee80211_hw *hw)
 		     wl->wow_enabled);
 	WARN_ON(!wl->wow_enabled);
 
+	ret = pm_generic_runtime_resume(wl->dev);
+	if (ret < 0) {
+		wl1271_error("ELP wakeup failure!");
+		goto out_sleep;
+	}
+
 	/*
 	 * re-enable irq_work enqueuing, and call irq_work directly if
 	 * there is a pending work.
-- 
2.17.0
