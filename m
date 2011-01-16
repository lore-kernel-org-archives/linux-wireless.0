Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51176 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab1APFmV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Jan 2011 00:42:21 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so4401170wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Jan 2011 21:42:21 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/10] wl12xx: fix potential race condition with TX queue watermark
Date: Sun, 16 Jan 2011 07:42:05 +0200
Message-Id: <1295156534-4178-2-git-send-email-arik@wizery.com>
In-Reply-To: <1295156534-4178-1-git-send-email-arik@wizery.com>
References: <1295156534-4178-1-git-send-email-arik@wizery.com>
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
index 9076555..6163167 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -984,6 +984,17 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
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
@@ -998,19 +1009,6 @@ static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
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
index 2347f25..fdec4a3 100644
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

