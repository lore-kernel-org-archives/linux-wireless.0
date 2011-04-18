Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40220 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267Ab1DRLQa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 07:16:30 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3798215wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 04:16:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 09/10] wl12xx: fix race condition during recovery in AP mode
Date: Mon, 18 Apr 2011 14:15:28 +0300
Message-Id: <1303125329-27214-9-git-send-email-arik@wizery.com>
In-Reply-To: <1303125329-27214-1-git-send-email-arik@wizery.com>
References: <1303125329-27214-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When operating as AP, the TX queues are not stopped when we start
recovery. mac80211 is notified only after the fact. When there is
pending TX, it will be queued even after the FW is down. This leads to
situations where the TX queues are stopped (because of the TX-watermark
mechanism), and are never woken up when we return from recovery.

Fix this by explicitly stopping the TX queues when before initiating
recovery.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   21 ++++++++++++++++-----
 drivers/net/wireless/wl12xx/tx.c   |    8 +++++---
 drivers/net/wireless/wl12xx/tx.h   |    2 +-
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d2a8b83..d7cb84b 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -338,7 +338,8 @@ static struct conf_drv_settings default_conf = {
 	},
 };
 
-static void __wl1271_op_remove_interface(struct wl1271 *wl);
+static void __wl1271_op_remove_interface(struct wl1271 *wl,
+					 bool reset_tx_queues);
 static void wl1271_free_ap_keys(struct wl1271 *wl);
 
 
@@ -953,10 +954,19 @@ static void wl1271_recovery_work(struct work_struct *work)
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		ieee80211_connection_loss(wl->vif);
 
+	/* Prevent spurious TX during FW restart */
+	ieee80211_stop_queues(wl->hw);
+
 	/* reboot the chipset */
-	__wl1271_op_remove_interface(wl);
+	__wl1271_op_remove_interface(wl, false);
 	ieee80211_restart_hw(wl->hw);
 
+	/*
+	 * Its safe to enable TX now - the queues are stopped after a request
+	 * to restart the HW.
+	 */
+	ieee80211_wake_queues(wl->hw);
+
 out:
 	mutex_unlock(&wl->mutex);
 }
@@ -1456,7 +1466,8 @@ out:
 	return ret;
 }
 
-static void __wl1271_op_remove_interface(struct wl1271 *wl)
+static void __wl1271_op_remove_interface(struct wl1271 *wl,
+					 bool reset_tx_queues)
 {
 	int i;
 
@@ -1502,7 +1513,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	mutex_lock(&wl->mutex);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl1271_tx_reset(wl);
+	wl1271_tx_reset(wl, reset_tx_queues);
 	wl1271_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
@@ -1563,7 +1574,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	 */
 	if (wl->vif) {
 		WARN_ON(wl->vif != vif);
-		__wl1271_op_remove_interface(wl);
+		__wl1271_op_remove_interface(wl, true);
 	}
 
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 7a3339f..5c7f963 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -766,8 +766,8 @@ void wl1271_tx_reset_link_queues(struct wl1271 *wl, u8 hlid)
 	wl1271_handle_tx_low_watermark(wl);
 }
 
-/* caller must hold wl->mutex */
-void wl1271_tx_reset(struct wl1271 *wl)
+/* caller must hold wl->mutex and TX must be stopped */
+void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 {
 	int i;
 	struct sk_buff *skb;
@@ -803,8 +803,10 @@ void wl1271_tx_reset(struct wl1271 *wl)
 	/*
 	 * Make sure the driver is at a consistent state, in case this
 	 * function is called from a context other than interface removal.
+	 * This call will always wake the TX queues.
 	 */
-	wl1271_handle_tx_low_watermark(wl);
+	if (reset_tx_queues)
+		wl1271_handle_tx_low_watermark(wl);
 
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++) {
 		if (wl->tx_frames[i] == NULL)
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index fc7835c..832f925 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -185,7 +185,7 @@ static inline int wl1271_tx_get_queue(int queue)
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
-void wl1271_tx_reset(struct wl1271 *wl);
+void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues);
 void wl1271_tx_flush(struct wl1271 *wl);
 u8 wl1271_rate_to_idx(int rate, enum ieee80211_band band);
 u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set);
-- 
1.7.1

