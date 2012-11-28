Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:61071 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab2K1JnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:25 -0500
Received: by mail-we0-f174.google.com with SMTP id d7so4384896wer.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:24 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 15/20] wlcore: don't take mutex before stopping queues
Date: Wed, 28 Nov 2012 11:42:44 +0200
Message-Id: <1354095769-8724-16-git-send-email-arik@wizery.com> (sfid-20121128_104352_319170_019BDA1B)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Protect all functions touching queue_stop_reasons by spin-lock, since
they are accessed by op_tx. Now there's no need to take the mutex
before caling wlcore_queue_xxx functions.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    9 +++------
 drivers/net/wireless/ti/wlcore/tx.c   |   21 ++++++++++++++++++++-
 drivers/net/wireless/ti/wlcore/tx.h   |    9 +++++++--
 3 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 9d7f059..3ffbba3 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1224,8 +1224,8 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	 */
 	if (hlid == WL12XX_INVALID_LINK_ID ||
 	    (!test_bit(hlid, wlvif->links_map)) ||
-	     (wlcore_is_queue_stopped(wl, wlvif, q) &&
-	      !wlcore_is_queue_stopped_by_reason(wl, wlvif, q,
+	     (wlcore_is_queue_stopped_locked(wl, wlvif, q) &&
+	      !wlcore_is_queue_stopped_by_reason_locked(wl, wlvif, q,
 			WLCORE_QUEUE_STOP_REASON_WATERMARK))) {
 		wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d", hlid, q);
 		ieee80211_free_txskb(hw, skb);
@@ -1244,7 +1244,7 @@ static void wl1271_op_tx(struct ieee80211_hw *hw,
 	 * the queue here, otherwise the queue will get too long.
 	 */
 	if (wlvif->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK &&
-	    !wlcore_is_queue_stopped_by_reason(wl, wlvif, q,
+	    !wlcore_is_queue_stopped_by_reason_locked(wl, wlvif, q,
 					WLCORE_QUEUE_STOP_REASON_WATERMARK)) {
 		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
 		wlcore_stop_queue_locked(wl, wlvif, q,
@@ -3258,10 +3258,7 @@ static int wlcore_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 		 * stop the queues and flush to ensure the next packets are
 		 * in sync with FW spare block accounting
 		 */
-		mutex_lock(&wl->mutex);
 		wlcore_stop_queues(wl, WLCORE_QUEUE_STOP_REASON_SPARE_BLK);
-		mutex_unlock(&wl->mutex);
-
 		wl1271_tx_flush(wl);
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/tx.c b/drivers/net/wireless/ti/wlcore/tx.c
index dbc1721..bbfa14a 100644
--- a/drivers/net/wireless/ti/wlcore/tx.c
+++ b/drivers/net/wireless/ti/wlcore/tx.c
@@ -1288,13 +1288,32 @@ bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif, u8 queue,
 				       enum wlcore_queue_stop_reason reason)
 {
+	unsigned long flags;
+	bool stopped;
+
+	spin_lock_irqsave(&wl->wl_lock, flags);
+	stopped = wlcore_is_queue_stopped_by_reason_locked(wl, wlvif, queue,
+							   reason);
+	spin_unlock_irqrestore(&wl->wl_lock, flags);
+
+	return stopped;
+}
+
+bool wlcore_is_queue_stopped_by_reason_locked(struct wl1271 *wl,
+				       struct wl12xx_vif *wlvif, u8 queue,
+				       enum wlcore_queue_stop_reason reason)
+{
 	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
+
+	WARN_ON_ONCE(!spin_is_locked(&wl->wl_lock));
 	return test_bit(reason, &wl->queue_stop_reasons[hwq]);
 }
 
-bool wlcore_is_queue_stopped(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+bool wlcore_is_queue_stopped_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			     u8 queue)
 {
 	int hwq = wlvif->hw_queue_base + wl1271_tx_get_mac80211_queue(queue);
+
+	WARN_ON_ONCE(!spin_is_locked(&wl->wl_lock));
 	return !!wl->queue_stop_reasons[hwq];
 }
diff --git a/drivers/net/wireless/ti/wlcore/tx.h b/drivers/net/wireless/ti/wlcore/tx.h
index 3d854e5..cb19c24 100644
--- a/drivers/net/wireless/ti/wlcore/tx.h
+++ b/drivers/net/wireless/ti/wlcore/tx.h
@@ -265,8 +265,13 @@ void wlcore_wake_queues(struct wl1271 *wl,
 bool wlcore_is_queue_stopped_by_reason(struct wl1271 *wl,
 				       struct wl12xx_vif *wlvif, u8 queue,
 				       enum wlcore_queue_stop_reason reason);
-bool wlcore_is_queue_stopped(struct wl1271 *wl, struct wl12xx_vif *wlvif,
-			     u8 queue);
+bool
+wlcore_is_queue_stopped_by_reason_locked(struct wl1271 *wl,
+					 struct wl12xx_vif *wlvif,
+					 u8 queue,
+					 enum wlcore_queue_stop_reason reason);
+bool wlcore_is_queue_stopped_locked(struct wl1271 *wl, struct wl12xx_vif *wlvif,
+				    u8 queue);
 
 /* from main.c */
 void wl1271_free_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif, u8 hlid);
-- 
1.7.9.5

