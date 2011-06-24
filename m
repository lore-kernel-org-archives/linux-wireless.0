Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54215 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab1FXKDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 06:03:49 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2727527wwe.1
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 03:03:48 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 3/3] wl12xx: implement Tx watermarks per AC
Date: Fri, 24 Jun 2011 13:03:37 +0300
Message-Id: <1308909817-25689-3-git-send-email-arik@wizery.com> (sfid-20110624_120354_416926_EFF7FFCD)
In-Reply-To: <1308909817-25689-1-git-send-email-arik@wizery.com>
References: <1308909817-25689-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each AC is stopped when its queue is filled up to the high watermark,
and restarted when its queue it lower than the low watermark. This
ensures congested ACs are not able to starve other ACs.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   13 +++++++------
 drivers/net/wireless/wl12xx/tx.c     |   20 +++++++++++++-------
 drivers/net/wireless/wl12xx/tx.h     |   16 ++++++++++++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 4 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index d3e1eb6..166287f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1371,10 +1371,11 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
 	unsigned long flags;
-	int q;
+	int q, mapping;
 	u8 hlid = 0;
 
-	q = wl1271_tx_get_queue(skb_get_queue_mapping(skb));
+	mapping = skb_get_queue_mapping(skb);
+	q = wl1271_tx_get_queue(mapping);
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		hlid = wl1271_tx_get_hlid(skb);
@@ -1387,10 +1388,10 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (wl->tx_queue_count >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
-		wl1271_debug(DEBUG_TX, "op_tx: stopping queues");
-		ieee80211_stop_queues(wl->hw);
-		set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+	if (skb_queue_len(&wl->tx_queue[q]) >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
+		ieee80211_stop_queue(wl->hw, mapping);
+		set_bit(q, &wl->stopped_queues_map);
 	}
 
 	/* queue the packet */
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index ce33590..ef54cee 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -444,14 +444,19 @@ u32 wl1271_tx_enabled_rates_get(struct wl1271 *wl, u32 rate_set)
 void wl1271_handle_tx_low_watermark(struct wl1271 *wl)
 {
 	unsigned long flags;
+	int i;
 
-	if (test_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags) &&
-	    wl->tx_queue_count <= WL1271_TX_QUEUE_LOW_WATERMARK) {
-		/* firmware buffer has space, restart queues */
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		ieee80211_wake_queues(wl->hw);
-		clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
+	for (i = 0; i < NUM_TX_QUEUES; i++) {
+		if (test_bit(i, &wl->stopped_queues_map) &&
+		    skb_queue_len(&wl->tx_queue[i]) <=
+						WL1271_TX_QUEUE_LOW_WATERMARK) {
+			/* firmware buffer has space, restart queues */
+			spin_lock_irqsave(&wl->wl_lock, flags);
+			ieee80211_wake_queue(wl->hw,
+					     wl1271_tx_get_mac80211_queue(i));
+			clear_bit(i, &wl->stopped_queues_map);
+			spin_unlock_irqrestore(&wl->wl_lock, flags);
+		}
 	}
 }
 
@@ -849,6 +854,7 @@ void wl1271_tx_reset(struct wl1271 *wl, bool reset_tx_queues)
 	}
 
 	wl->tx_queue_count = 0;
+	wl->stopped_queues_map = 0;
 
 	/*
 	 * Make sure the driver is at a consistent state, in case this
diff --git a/drivers/net/wireless/wl12xx/tx.h b/drivers/net/wireless/wl12xx/tx.h
index 832f925..f79d3c0 100644
--- a/drivers/net/wireless/wl12xx/tx.h
+++ b/drivers/net/wireless/wl12xx/tx.h
@@ -182,6 +182,22 @@ static inline int wl1271_tx_get_queue(int queue)
 	}
 }
 
+static inline int wl1271_tx_get_mac80211_queue(int queue)
+{
+	switch (queue) {
+	case CONF_TX_AC_VO:
+		return 0;
+	case CONF_TX_AC_VI:
+		return 1;
+	case CONF_TX_AC_BE:
+		return 2;
+	case CONF_TX_AC_BK:
+		return 3;
+	default:
+		return 2;
+	}
+}
+
 void wl1271_tx_work(struct work_struct *work);
 void wl1271_tx_work_locked(struct wl1271 *wl);
 void wl1271_tx_complete(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 89ba1fc..49aee9f 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -437,6 +437,7 @@ struct wl1271 {
 	/* Frames scheduled for transmission, not handled yet */
 	struct sk_buff_head tx_queue[NUM_TX_QUEUES];
 	int tx_queue_count;
+	long stopped_queues_map;
 
 	/* Frames received, not handled yet by mac80211 */
 	struct sk_buff_head deferred_rx_queue;
-- 
1.7.4.1

