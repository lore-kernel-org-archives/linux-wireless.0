Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:22567 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0BVGle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 01:41:34 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/22] wl1271: Fix queue stopping/waking for TX path
Date: Mon, 22 Feb 2010 08:38:33 +0200
Message-Id: <1266820722-20202-14-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue stopping/waking functionality was broken in a way that could
cause huge latencies in TX transfers and even cause the TX to stall in the
right circumstances. Correct these problems.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 ++-
 drivers/net/wireless/wl12xx/wl1271_main.c |   12 +++++-------
 drivers/net/wireless/wl12xx/wl1271_tx.c   |   28 +++++++++++++++-------------
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index cc974ea..7f03f89 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -491,7 +491,8 @@ int wl1271_plt_stop(struct wl1271 *wl);
 
 #define WL1271_DEFAULT_POWER_LEVEL 0
 
-#define WL1271_TX_QUEUE_MAX_LENGTH 20
+#define WL1271_TX_QUEUE_LOW_WATERMARK  10
+#define WL1271_TX_QUEUE_HIGH_WATERMARK 25
 
 /* WL1271 needs a 200ms sleep after power on, and a 20ms sleep before power
    on in case is has been shut down shortly before */
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 81fb02e..184264a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -791,15 +791,13 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	 * The workqueue is slow to process the tx_queue and we need stop
 	 * the queue here, otherwise the queue will get too long.
 	 */
-	if (skb_queue_len(&wl->tx_queue) >= WL1271_TX_QUEUE_MAX_LENGTH) {
-		ieee80211_stop_queues(wl->hw);
+	if (skb_queue_len(&wl->tx_queue) >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+		wl1271_debug(DEBUG_TX, "op_tx: stopping queues");
 
-		/*
-		 * FIXME: this is racy, the variable is not properly
-		 * protected. Maybe fix this by removing the stupid
-		 * variable altogether and checking the real queue state?
-		 */
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		ieee80211_stop_queues(wl->hw);
 		set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 
 	return NETDEV_TX_OK;
diff --git a/drivers/net/wireless/wl12xx/wl1271_tx.c b/drivers/net/wireless/wl12xx/wl1271_tx.c
index 2e057b0..7926471 100644
--- a/drivers/net/wireless/wl12xx/wl1271_tx.c
+++ b/drivers/net/wireless/wl12xx/wl1271_tx.c
@@ -278,22 +278,12 @@ void wl1271_tx_work(struct work_struct *work)
 
 		ret = wl1271_tx_frame(wl, skb);
 		if (ret == -EBUSY) {
-			/* firmware buffer is full, stop queues */
-			wl1271_debug(DEBUG_TX, "tx_work: fw buffer full, "
-				     "stop queues");
-			ieee80211_stop_queues(wl->hw);
-			set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+			/* firmware buffer is full, lets stop transmitting. */
 			skb_queue_head(&wl->tx_queue, skb);
 			goto out_ack;
 		} else if (ret < 0) {
 			dev_kfree_skb(skb);
 			goto out_ack;
-		} else if (test_and_clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED,
-					      &wl->flags)) {
-			/* firmware buffer has space, restart queues */
-			wl1271_debug(DEBUG_TX,
-				     "complete_packet: waking queues");
-			ieee80211_wake_queues(wl->hw);
 		}
 	}
 
@@ -380,8 +370,6 @@ void wl1271_tx_complete(struct wl1271 *wl)
 	u32 count, fw_counter;
 	u32 i;
 
-	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
-
 	/* read the tx results from the chipset */
 	wl1271_read(wl, le32_to_cpu(memmap->tx_result),
 		    wl->tx_res_if, sizeof(*wl->tx_res_if), false);
@@ -393,6 +381,7 @@ void wl1271_tx_complete(struct wl1271 *wl)
 				tx_result_host_counter), fw_counter);
 
 	count = fw_counter - wl->tx_results_count;
+	wl1271_debug(DEBUG_TX, "tx_complete received, packets: %d", count);
 
 	/* verify that the result buffer is not getting overrun */
 	if (unlikely(count > TX_HW_RESULT_QUEUE_LEN))
@@ -409,6 +398,19 @@ void wl1271_tx_complete(struct wl1271 *wl)
 
 		wl->tx_results_count++;
 	}
+
+	if (test_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags) &&
+	    skb_queue_len(&wl->tx_queue) <= WL1271_TX_QUEUE_LOW_WATERMARK) {
+		unsigned long flags;
+
+		/* firmware buffer has space, restart queues */
+		wl1271_debug(DEBUG_TX, "tx_complete: waking queues");
+		spin_lock_irqsave(&wl->wl_lock, flags);
+		ieee80211_wake_queues(wl->hw);
+		clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+		spin_unlock_irqrestore(&wl->wl_lock, flags);
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	}
 }
 
 /* caller must hold wl->mutex */
-- 
1.6.3.3

