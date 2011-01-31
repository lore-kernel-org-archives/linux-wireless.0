Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46371 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1AaLQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 06:16:39 -0500
Received: by mail-fx0-f46.google.com with SMTP id 20so5465134fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 03:16:38 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 01/10] wl12xx: fix potential race condition with TX queue watermark
Date: Mon, 31 Jan 2011 13:16:20 +0200
Message-Id: <1296472589-26401-2-git-send-email-arik@wizery.com>
In-Reply-To: <1296472589-26401-1-git-send-email-arik@wizery.com>
References: <1296472589-26401-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the conditions for the high/low TX queue watermarks when the
spin-lock is taken. This prevents race conditions as tx_queue_count and
the flag checked are only modified when the spin-lock is taken.

The following race was in mind:
- Queues are almost full and wl1271_op_tx() will stop the queues, but it
  doesn't get the spin-lock yet.
- (on another CPU) tx_work_locked() dequeues 15 skbs from this queue and
  tx_queue_count is updated to reflect this
- wl1271_op_tx() does not check tx_queue_count after taking the
  spin-lock and incorrectly stops the queue.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   24 +++++++++++-------------
 drivers/net/wireless/wl12xx/tx.c   |    2 +-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dfab21e..cf11bda 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -995,6 +995,17 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	}
 #endif
 	wl->tx_queue_count++;
+
+	/*
+	 * The workqueue is slow to process the tx_queue and we need stop
+	 * the queue here, otherwise the queue will get too long.
+	 */
+	if (wl->tx_queue_count >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+		wl1271_debug(DEBUG_TX, "op_tx: stopping queues");
+		ieee80211_stop_queues(wl->hw);
+		__set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+	}
+
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
 	/* queue the packet */
@@ -1009,19 +1020,6 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags))
 		ieee80211_queue_work(wl->hw, &wl->tx_work);
 
-	/*
-	 * The workqueue is slow to process the tx_queue and we need stop
-	 * the queue here, otherwise the queue will get too long.
-	 */
-	if (wl->tx_queue_count >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
-		wl1271_debug(DEBUG_TX, "op_tx: stopping queues");
-
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		ieee80211_stop_queues(wl->hw);
-		set_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-	}
-
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 3507c81..ce9a19b 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -288,7 +288,7 @@ static void handle_tx_low_watermark(struct wl1271 *wl)
 		/* firmware buffer has space, restart queues */
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		ieee80211_wake_queues(wl->hw);
-		clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
+		__clear_bit(WL1271_FLAG_TX_QUEUE_STOPPED, &wl->flags);
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
 	}
 }
-- 
1.7.1

