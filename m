Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:58480 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab2DZHfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 03:35:09 -0400
From: <Bartosz.Markowski@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <arik@wizery.com>, <coelho@ti.com>
Date: Thu, 26 Apr 2012 10:35:07 +0300
Subject: [PATCH] wlcore/wl12xx: implement better beacon loss handling
Message-ID: <538FB72AA9C7314998FCE2FB41335C5A208413C7C2@EXMB02.eu.tieto.com> (sfid-20120426_093525_280976_847DB1A2)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make use of REGAINED_BSS_EVENT and instead of reporting connection
loss immediately on each BEACON_LOSE event, try if not regained
in reasonable period of time.

Signed-off-by: bartosz.markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ti/wlcore/boot.c   |    1 +
 drivers/net/wireless/ti/wlcore/event.c  |   29 +++++++++++---------------
 drivers/net/wireless/ti/wlcore/main.c   |   34 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/wlcore.h |    3 ++
 4 files changed, 50 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 3a2207d..eda256f 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -413,6 +413,7 @@ int wlcore_boot_run_firmware(struct wl1271 *wl)
 
 	/* unmask required mbox events  */
 	wl->event_mask = BSS_LOSE_EVENT_ID |
+		REGAINED_BSS_EVENT_ID |
 		SCAN_COMPLETE_EVENT_ID |
 		ROLE_STOP_COMPLETE_EVENT_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 292632d..28e2a63 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -103,7 +103,6 @@ static int wl1271_event_process(struct wl1271 *wl)
 	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 	u32 vector;
-	bool beacon_loss = false;
 	bool disconnect_sta = false;
 	unsigned long sta_bitmap = 0;
 
@@ -141,20 +140,23 @@ static int wl1271_event_process(struct wl1271 *wl)
 					       mbox->soft_gemini_sense_info);
 
 	/*
-	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
-	 * filtering) is enabled. Without PSM, the stack will receive all
-	 * beacons and can detect beacon loss by itself.
-	 *
-	 * As there's possibility that the driver disables PSM before receiving
-	 * BSS_LOSE_EVENT, beacon loss has to be reported to the stack.
-	 *
+	 * We are HW_MONITOR device. On beacon loss - queue
+	 * connection loss work. Cancel it on REGAINED event.
 	 */
 	if (vector & BSS_LOSE_EVENT_ID) {
 		/* TODO: check for multi-role */
+		int delay = wl->conf.conn.synch_fail_thold *
+					wl->conf.conn.bss_lose_timeout;
 		wl1271_info("Beacon loss detected.");
+		cancel_delayed_work_sync(&wl->connection_loss_work);
+		ieee80211_queue_delayed_work(wl->hw, &wl->connection_loss_work,
+		      msecs_to_jiffies(delay));
+	}
 
-		/* indicate to the stack, that beacons have been lost */
-		beacon_loss = true;
+	if (vector & REGAINED_BSS_EVENT_ID) {
+		/* TODO: check for multi-role */
+		wl1271_info("Beacon regained.");
+		cancel_delayed_work_sync(&wl->connection_loss_work);
 	}
 
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
@@ -257,13 +259,6 @@ static int wl1271_event_process(struct wl1271 *wl)
 			rcu_read_unlock();
 		}
 	}
-
-	if (beacon_loss)
-		wl12xx_for_each_wlvif_sta(wl, wlvif) {
-			vif = wl12xx_wlvif_to_vif(wlvif);
-			ieee80211_connection_loss(vif);
-		}
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 2b0f987..b73ed36 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1120,6 +1120,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	cancel_work_sync(&wl->recovery_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 	cancel_delayed_work_sync(&wl->tx_watchdog_work);
+	cancel_delayed_work_sync(&wl->connection_loss_work);
 
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
@@ -1487,6 +1488,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 	cancel_delayed_work_sync(&wl->tx_watchdog_work);
+	cancel_delayed_work_sync(&wl->connection_loss_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl12xx_tx_reset(wl, true);
@@ -3439,6 +3441,9 @@ sta_not_found:
 			do_join = true;
 			set_assoc = true;
 
+			/* Cancel connection_loss_work */
+			cancel_delayed_work_sync(&wl->connection_loss_work);
+
 			/*
 			 * use basic rates from AP, and determine lowest rate
 			 * to use with control frames.
@@ -4549,6 +4554,34 @@ static struct bin_attribute fwlog_attr = {
 	.read = wl1271_sysfs_read_fwlog,
 };
 
+void wl1271_connection_loss_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+	struct ieee80211_vif *vif;
+	struct wl12xx_vif *wlvif;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, connection_loss_work);
+
+	wl1271_info("Connection loss work.");
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	/* Call mac80211 connection loss */
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		if (!test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags))
+			goto out;
+		vif = wl12xx_wlvif_to_vif(wlvif);
+		ieee80211_connection_loss(vif);
+	}
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wl12xx_derive_mac_addresses(struct wl1271 *wl,
 					u32 oui, u32 nic, int n)
 {
@@ -4804,6 +4837,7 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size)
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
 	INIT_DELAYED_WORK(&wl->tx_watchdog_work, wl12xx_tx_watchdog_work);
+	INIT_DELAYED_WORK(&wl->connection_loss_work, wl1271_connection_loss_work);
 
 	wl->freezable_wq = create_freezable_workqueue("wl12xx_wq");
 	if (!wl->freezable_wq) {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 39f9fad..4556d41 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -243,6 +243,9 @@ struct wl1271 {
 	struct wl1271_scan scan;
 	struct delayed_work scan_complete_work;
 
+	/* Connection loss work */
+	struct delayed_work connection_loss_work;
+
 	bool sched_scanning;
 
 	/* The current band */
--
