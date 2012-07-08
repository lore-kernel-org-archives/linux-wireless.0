Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:35890 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751245Ab2GHHXo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:44 -0400
Received: by lbok6 with SMTP id k6so4196052lbo.32
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:41 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 1/8] wlcore: Prevent processing of work items during op_stop
Date: Sun,  8 Jul 2012 10:23:24 +0300
Message-Id: <1341732211-25871-2-git-send-email-coelho@ti.com> (sfid-20120708_092347_881572_252E9A9E)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

The interrupt line is disabled in op_stop using disable_irq. Since
pending interrupts are synchronized, the mutex has to be released before
disabling the interrupt to avoid a deadlock with the interrupt handler.

In addition, the internal state of the driver is only set to 'off'
after the interrupt is disabled. Otherwise, if an interrupt fires after
the state is set but before the interrupt line is disabled, the
interrupt handler will not be able to acknowledge the interrupt
resulting in an interrupt storm.

The driver's operations might be called during recovery. If these
acquire the mutex after it was released by op_stop, but before the
driver's state is changed, they may queue new work items instead of just
failing. This is especially problematic in the case of scans, in which a
new scan may be scheduled after all scan requests were cancelled.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/io.c   |    6 ++++
 drivers/net/wireless/ti/wlcore/io.h   |    1 +
 drivers/net/wireless/ti/wlcore/main.c |   50 ++++++++++++++++-----------------
 3 files changed, 32 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 9976219..68e74ee 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -60,6 +60,12 @@ void wlcore_enable_interrupts(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wlcore_enable_interrupts);
 
+void wlcore_synchronize_interrupts(struct wl1271 *wl)
+{
+	synchronize_irq(wl->irq);
+}
+EXPORT_SYMBOL_GPL(wlcore_synchronize_interrupts);
+
 int wlcore_translate_addr(struct wl1271 *wl, int addr)
 {
 	struct wlcore_partition_set *part = &wl->curr_part;
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index fef80ad..458da55 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -47,6 +47,7 @@ struct wl1271;
 void wlcore_disable_interrupts(struct wl1271 *wl);
 void wlcore_disable_interrupts_nosync(struct wl1271 *wl);
 void wlcore_enable_interrupts(struct wl1271 *wl);
+void wlcore_synchronize_interrupts(struct wl1271 *wl);
 
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 6ac3323..5632194 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -62,7 +62,7 @@ static bool no_recovery;
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 struct ieee80211_vif *vif,
 					 bool reset_tx_queues);
-static void wl1271_op_stop(struct ieee80211_hw *hw);
+static void wlcore_op_stop_locked(struct wl1271 *wl);
 static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 
 static int wl12xx_set_authorized(struct wl1271 *wl,
@@ -956,9 +956,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 		vif = wl12xx_wlvif_to_vif(wlvif);
 		__wl1271_op_remove_interface(wl, vif, false);
 	}
-        wl->watchdog_recovery = false;
-	mutex_unlock(&wl->mutex);
-	wl1271_op_stop(wl->hw);
+
+	wlcore_op_stop_locked(wl);
 
 	ieee80211_restart_hw(wl->hw);
 
@@ -967,7 +966,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * to restart the HW.
 	 */
 	wlcore_wake_queues(wl, WLCORE_QUEUE_STOP_REASON_FW_RESTART);
-	return;
+
 out_unlock:
 	wl->watchdog_recovery = false;
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
@@ -1800,33 +1799,15 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static void wl1271_op_stop(struct ieee80211_hw *hw)
+static void wlcore_op_stop_locked(struct wl1271 *wl)
 {
-	struct wl1271 *wl = hw->priv;
 	int i;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
-
-	/*
-	 * Interrupts must be disabled before setting the state to OFF.
-	 * Otherwise, the interrupt handler might be called and exit without
-	 * reading the interrupt status.
-	 */
-	wlcore_disable_interrupts(wl);
-	mutex_lock(&wl->mutex);
 	if (wl->state == WL1271_STATE_OFF) {
 		if (test_and_clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS,
 					&wl->flags))
 			wlcore_enable_interrupts(wl);
 
-		mutex_unlock(&wl->mutex);
-
-		/*
-		 * This will not necessarily enable interrupts as interrupts
-		 * may have been disabled when op_stop was called. It will,
-		 * however, balance the above call to disable_interrupts().
-		 */
-		wlcore_enable_interrupts(wl);
 		return;
 	}
 
@@ -1835,8 +1816,16 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
+
+	/*
+	 * Use the nosync variant to disable interrupts, so the mutex could be
+	 * held while doing so without deadlocking.
+	 */
+	wlcore_disable_interrupts_nosync(wl);
+
 	mutex_unlock(&wl->mutex);
 
+	wlcore_synchronize_interrupts(wl);
 	wl1271_flush_deferred_work(wl);
 	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->netstack_work);
@@ -1903,6 +1892,17 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	wl->tx_res_if = NULL;
 	kfree(wl->target_mem_map);
 	wl->target_mem_map = NULL;
+}
+
+static void wlcore_op_stop(struct ieee80211_hw *hw)
+{
+	struct wl1271 *wl = hw->priv;
+
+	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+
+	mutex_lock(&wl->mutex);
+
+	wlcore_op_stop_locked(wl);
 
 	mutex_unlock(&wl->mutex);
 }
@@ -4806,7 +4806,7 @@ static struct ieee80211_supported_band wl1271_band_5ghz = {
 
 static const struct ieee80211_ops wl1271_ops = {
 	.start = wl1271_op_start,
-	.stop = wl1271_op_stop,
+	.stop = wlcore_op_stop,
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
 	.change_interface = wl12xx_op_change_interface,
-- 
1.7.10

