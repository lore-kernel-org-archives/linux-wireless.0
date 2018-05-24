Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35035 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935626AbeEXHTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 03:19:06 -0400
From: Eyal Reizer <eyalreizer@gmail.com>
To: kvalo@codeaurora.org, tony@atomide.com,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Eyal Reizer <eyalr@ti.com>
Subject: [PATCH] wlcore: use generic runtime pm calls for wowlan elp configuration
Date: Thu, 24 May 2018 10:18:57 +0300
Message-Id: <1527146337-17562-1-git-send-email-eyalr@ti.com> (sfid-20180524_091922_670389_6F2A275B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With runtime PM enabled, we can now use generic calls to
pm_generic_runtime_suspend and pm_generic_runtime_resume for enabling elp
during suspend when wowlan is enabled and waking the chip from elp
on resume.
remove the custom API that was used to ensure that the command
that is used to allow ELP during suspend is completed before the system
suspend.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
Dependent on the Runtime PM support for wlcore patch set that was submitted 
by Tony Lindgren <tony@atomide.com>

 drivers/net/wireless/ti/wlcore/main.c | 51 +++++++++--------------------------
 1 file changed, 13 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 4c297aa..6c8e4fa 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1001,24 +1001,6 @@ static int wlcore_fw_wakeup(struct wl1271 *wl)
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
@@ -1742,6 +1724,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 {
 	struct wl1271 *wl = hw->priv;
 	struct wl12xx_vif *wlvif;
+	unsigned long flags;
 	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 suspend wow=%d", !!wow);
@@ -1800,19 +1783,6 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
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
@@ -1822,15 +1792,14 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
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
 
 static int wl1271_op_resume(struct ieee80211_hw *hw)
@@ -1845,6 +1814,12 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
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
2.7.4
