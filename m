Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:44265 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:10:54 -0500
Message-ID: <4D45B7B6.4090102@davizone.at>
Date: Sun, 30 Jan 2011 20:10:46 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 01/18] wl1251: fix queue stopping/waking for TX path
References: <4D45A589.9040905@davizone.at>
In-Reply-To: <4D45A589.9040905@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The queue stopping/waking functionality was broken in a way that could
cause the TX to stall if the right circumstances are met.

The problem was caused by tx_work, which is scheduled on each TX operation.
If the firmware buffer is full, tx_work does nothing. In combinition with
stopped queues or non-continues transfers, tx_work is never scheduled again.
Moreover the low watermark introduced by
9df86e2e702c6d5547aced7f241addd2d698bb11 never takes effect because of some
old code.

Solve this by scheduling tx_work every time tx_queue is non-empty and
firmware buffer is freed on tx_complete.

This also solves a possible but unlikely case: If less frames than the high
watermark are queued, but more than firmware buffer can hold. This results
in queues staying awake but the only scheduled tx_work doesn't transfer all
frames, so the remaining frames are stuck in the queue until more frames
get queued and tx_work is scheduled again.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/tx.c |   48 +++++++++----------------------------
 1 files changed, 12 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/wl1251/tx.c b/drivers/net/wireless/wl1251/tx.c
index 554b4f9..10112de 100644
--- a/drivers/net/wireless/wl1251/tx.c
+++ b/drivers/net/wireless/wl1251/tx.c
@@ -368,7 +368,7 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 {
 	struct ieee80211_tx_info *info;
 	struct sk_buff *skb;
-	int hdrlen, ret;
+	int hdrlen;
 	u8 *frame;
 
 	skb = wl->tx_frames[result->id];
@@ -407,40 +407,12 @@ static void wl1251_tx_packet_cb(struct wl1251 *wl,
 	ieee80211_tx_status(wl->hw, skb);
 
 	wl->tx_frames[result->id] = NULL;
-
-	if (wl->tx_queue_stopped) {
-		wl1251_debug(DEBUG_TX, "cb: queue was stopped");
-
-		skb = skb_dequeue(&wl->tx_queue);
-
-		/* The skb can be NULL because tx_work might have been
-		   scheduled before the queue was stopped making the
-		   queue empty */
-
-		if (skb) {
-			ret = wl1251_tx_frame(wl, skb);
-			if (ret == -EBUSY) {
-				/* firmware buffer is still full */
-				wl1251_debug(DEBUG_TX, "cb: fw buffer "
-					     "still full");
-				skb_queue_head(&wl->tx_queue, skb);
-				return;
-			} else if (ret < 0) {
-				dev_kfree_skb(skb);
-				return;
-			}
-		}
-
-		wl1251_debug(DEBUG_TX, "cb: waking queues");
-		ieee80211_wake_queues(wl->hw);
-		wl->tx_queue_stopped = false;
-	}
 }
 
 /* Called upon reception of a TX complete interrupt */
 void wl1251_tx_complete(struct wl1251 *wl)
 {
-	int i, result_index, num_complete = 0;
+	int i, result_index, num_complete = 0, queue_len;
 	struct tx_result result[FW_TX_CMPLT_BLOCK_SIZE], *result_ptr;
 	unsigned long flags;
 
@@ -471,18 +443,22 @@ void wl1251_tx_complete(struct wl1251 *wl)
 		}
 	}
 
-	if (wl->tx_queue_stopped
-	    &&
-	    skb_queue_len(&wl->tx_queue) <= WL1251_TX_QUEUE_LOW_WATERMARK){
+	queue_len = skb_queue_len(&wl->tx_queue);
 
-		/* firmware buffer has space, restart queues */
+	if ((num_complete > 0) && (queue_len > 0)) {
+		/* firmware buffer has space, reschedule tx_work */
+		wl1251_debug(DEBUG_TX, "tx_complete: reschedule tx_work");
+		ieee80211_queue_work(wl->hw, &wl->tx_work);
+	}
+
+	if (wl->tx_queue_stopped &&
+	    queue_len <= WL1251_TX_QUEUE_LOW_WATERMARK) {
+		/* tx_queue has space, restart queues */
 		wl1251_debug(DEBUG_TX, "tx_complete: waking queues");
 		spin_lock_irqsave(&wl->wl_lock, flags);
 		ieee80211_wake_queues(wl->hw);
 		wl->tx_queue_stopped = false;
 		spin_unlock_irqrestore(&wl->wl_lock, flags);
-		ieee80211_queue_work(wl->hw, &wl->tx_work);
-
 	}
 
 	/* Every completed frame needs to be acknowledged */
-- 
1.7.0.4



