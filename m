Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53148 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2CCUSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 15:18:13 -0500
Received: by wgbdr13 with SMTP id dr13so2455646wgb.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Mar 2012 12:18:12 -0800 (PST)
MIME-Version: 1.0
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: implement SW Tx watchdog
Date: Sat,  3 Mar 2012 22:18:00 +0200
Message-Id: <1330805880-26659-1-git-send-email-arik@wizery.com> (sfid-20120303_211825_978886_8871A2AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Track freed FW blocks during Tx. If no blocks were freed during a
predefined timeout, initiate a HW recovery. This helps in situations
when the FW watchdog fails.

Don't trigger recovery during activities that can temporarily stop
Tx. This includes:
- scanning
- buffering packets for sleeping stations (AP role)
- ROC on any role

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |    8 +++
 drivers/net/wireless/wl12xx/conf.h   |    3 +
 drivers/net/wireless/wl12xx/main.c   |  110 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/scan.c   |    6 ++
 drivers/net/wireless/wl12xx/tx.c     |    4 +
 drivers/net/wireless/wl12xx/tx.h     |    1 +
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +
 7 files changed, 135 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index ae1f3d7..b0f377d 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1818,6 +1818,14 @@ int wl12xx_croc(struct wl1271 *wl, u8 role_id)
 		goto out;
 
 	__clear_bit(role_id, wl->roc_map);
+
+	/*
+	 * Rearm the tx watchdog when removing the last ROC. This prevents
+	 * recoveries due to just finished ROCs - when Tx hasn't yet had
+	 * a chance to get out.
+	 */
+	if (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) >= WL12XX_MAX_ROLES)
+		wl12xx_rearm_tx_watchdog_locked(wl);
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index cc50faa..3e581e1 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -690,6 +690,9 @@ struct conf_tx_settings {
 	 */
 	u8 tmpl_short_retry_limit;
 	u8 tmpl_long_retry_limit;
+
+	/* Time in ms for Tx watchdog timer to expire */
+	u32 tx_watchdog_timeout;
 };
 
 enum {
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 418b2b8..a9b9fce 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -217,6 +217,7 @@ static struct conf_drv_settings default_conf = {
 		.basic_rate_5                = CONF_HW_BIT_RATE_6MBPS,
 		.tmpl_short_retry_limit      = 10,
 		.tmpl_long_retry_limit       = 10,
+		.tx_watchdog_timeout         = 5000,
 	},
 	.conn = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
@@ -623,6 +624,80 @@ static void wl1271_rx_streaming_timer(unsigned long data)
 	ieee80211_queue_work(wl->hw, &wlvif->rx_streaming_disable_work);
 }
 
+/* wl->mutex must be taken */
+void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl)
+{
+	/* if the watchdog is not armed, don't do anything */
+	if (wl->tx_allocated_blocks == 0)
+		return;
+
+	cancel_delayed_work(&wl->tx_watchdog_work);
+	ieee80211_queue_delayed_work(wl->hw, &wl->tx_watchdog_work,
+		msecs_to_jiffies(wl->conf.tx.tx_watchdog_timeout));
+}
+
+static void wl12xx_tx_watchdog_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, tx_watchdog_work);
+
+	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
+	/* Tx went out in the meantime - everything is ok */
+	if (unlikely(wl->tx_allocated_blocks == 0))
+		goto out;
+
+	/*
+	 * if a ROC is in progress, we might not have any Tx for a long
+	 * time (e.g. pending Tx on the non-ROC channels)
+	 */
+	if (find_first_bit(wl->roc_map, WL12XX_MAX_ROLES) < WL12XX_MAX_ROLES) {
+		wl1271_debug(DEBUG_TX, "No Tx (in FW) for %d ms due to ROC",
+			     wl->conf.tx.tx_watchdog_timeout);
+		wl12xx_rearm_tx_watchdog_locked(wl);
+		goto out;
+	}
+
+	/*
+	 * if a scan is in progress, we might not have any Tx for a long
+	 * time
+	 */
+	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
+		wl1271_debug(DEBUG_TX, "No Tx (in FW) for %d ms due to scan",
+			     wl->conf.tx.tx_watchdog_timeout);
+		wl12xx_rearm_tx_watchdog_locked(wl);
+		goto out;
+	}
+
+	/*
+	* AP might cache a frame for a long time for a sleeping station,
+	* so rearm the timer if there's an AP interface with stations. If
+	* Tx is genuinely stuck we will most hopefully discover it when all
+	* stations are removed due to inactivity.
+	*/
+	if (wl->active_sta_count) {
+		wl1271_debug(DEBUG_TX, "No Tx (in FW) for %d ms. AP has "
+			     " %d stations",
+			      wl->conf.tx.tx_watchdog_timeout,
+			      wl->active_sta_count);
+		wl12xx_rearm_tx_watchdog_locked(wl);
+		goto out;
+	}
+
+	wl1271_error("Tx stuck (in FW) for %d ms. Starting recovery",
+		     wl->conf.tx.tx_watchdog_timeout);
+	wl12xx_queue_recovery_work(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wl1271_conf_init(struct wl1271 *wl)
 {
 
@@ -815,6 +890,18 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 
 	wl->tx_allocated_blocks -= freed_blocks;
 
+	/*
+	 * If the FW freed some blocks:
+	 * If we still have allocated blocks - re-arm the timer, Tx is
+	 * not stuck. Otherwise, cancel the timer (no Tx currently).
+	 */
+	if (freed_blocks) {
+		if (wl->tx_allocated_blocks)
+			wl12xx_rearm_tx_watchdog_locked(wl);
+		else
+			cancel_delayed_work(&wl->tx_watchdog_work);
+	}
+
 	avail = le32_to_cpu(status->tx_total) - wl->tx_allocated_blocks;
 
 	/*
@@ -1487,6 +1574,7 @@ int wl1271_plt_stop(struct wl1271 *wl)
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
 	cancel_delayed_work_sync(&wl->elp_work);
+	cancel_delayed_work_sync(&wl->tx_watchdog_work);
 
 	mutex_lock(&wl->mutex);
 	wl1271_power_off(wl);
@@ -1865,6 +1953,7 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->elp_work);
+	cancel_delayed_work_sync(&wl->tx_watchdog_work);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
 	wl12xx_tx_reset(wl, true);
@@ -2298,6 +2387,12 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE &&
 	    wl->scan_vif == vif) {
+		/*
+		 * Rearm the tx watchdog just before idling scan. This
+		 * prevents just-finished scans from triggering the watchdog
+		 */
+		wl12xx_rearm_tx_watchdog_locked(wl);
+
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan_vif = NULL;
@@ -3223,6 +3318,13 @@ static void wl1271_op_cancel_hw_scan(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out_sleep;
 	}
+
+	/*
+	 * Rearm the tx watchdog just before idling scan. This
+	 * prevents just-finished scans from triggering the watchdog
+	 */
+	wl12xx_rearm_tx_watchdog_locked(wl);
+
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan_vif = NULL;
@@ -4234,6 +4336,13 @@ void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid)
 	__clear_bit(hlid, (unsigned long *)&wl->ap_fw_ps_map);
 	wl12xx_free_link(wl, wlvif, &hlid);
 	wl->active_sta_count--;
+
+	/*
+	 * rearm the tx watchdog when the last STA is freed - give the FW a
+	 * chance to return STA-buffered packets before complaining.
+	 */
+	if (wl->active_sta_count == 0)
+		wl12xx_rearm_tx_watchdog_locked(wl);
 }
 
 static int wl1271_op_sta_add(struct ieee80211_hw *hw,
@@ -5271,6 +5380,7 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
 	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
+	INIT_DELAYED_WORK(&wl->tx_watchdog_work, wl12xx_tx_watchdog_work);
 
 	wl->freezable_wq = create_freezable_workqueue("wl12xx_wq");
 	if (!wl->freezable_wq) {
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index e43a6b2..fcba055 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -55,6 +55,12 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	vif = wl->scan_vif;
 	wlvif = wl12xx_vif_to_data(vif);
 
+	/*
+	 * Rearm the tx watchdog just before idling scan. This
+	 * prevents just-finished scans from triggering the watchdog
+	 */
+	wl12xx_rearm_tx_watchdog_locked(wl);
+
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 8f78fdd..43ae491 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -226,6 +226,10 @@ static int wl1271_tx_allocate(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		wl->tx_blocks_available -= total_blocks;
 		wl->tx_allocated_blocks += total_blocks;
 
+		/* If the FW was empty before, arm the Tx watchdog */
+		if (wl->tx_allocated_blocks == total_blocks)
+			wl12xx_rearm_tx_watchdog_locked(wl);
+
 		ac = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
 		wl->tx_allocated_pkts[ac]++;
 
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index e3977b5..5cf8c32 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -227,5 +227,6 @@ void wl12xx_rearm_rx_streaming(struct wl1271 *wl, unsigned long *active_hlids);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
+void wl12xx_rearm_tx_watchdog_locked(struct wl1271 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9035241..7f58454 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -495,6 +495,9 @@ struct wl1271 {
 
 	/* last wlvif we transmitted from */
 	struct wl12xx_vif *last_wlvif;
+
+	/* work to fire when Tx is stuck */
+	struct delayed_work tx_watchdog_work;
 };
 
 struct wl1271_station {
-- 
1.7.5.4

