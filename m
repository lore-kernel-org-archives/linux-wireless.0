Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753083Ab1HNKSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:18:18 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:18:17 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 40/40] wl12xx: fix tx_queue_count spurious increment
Date: Sun, 14 Aug 2011 13:17:39 +0300
Message-Id: <1313317059-16567-41-git-send-email-eliad@wizery.com> (sfid-20110814_121822_818328_5FDE153A)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Only increment the queue count after actually queuing the skb. This
avoids a spurious increment is case of dropped packets.

Also move the Tx-watermark checking code after the packet is enqueued.
This makes the count more accurate - it includes the just-queued
packet.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 6c56bef..5001766 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1482,24 +1482,12 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		hlid = wl12xx_tx_get_hlid_ap(wl, skb);
 
 	spin_lock_irqsave(&wl->wl_lock, flags);
 
-	wl->tx_queue_count[q]++;
-
-	/*
-	 * The workqueue is slow to process the tx_queue and we need stop
-	 * the queue here, otherwise the queue will get too long.
-	 */
-	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
-		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
-		ieee80211_stop_queue(wl->hw, mapping);
-		set_bit(q, &wl->stopped_queues_map);
-	}
-
 	/* queue the packet */
 	if (wl->bss_type == BSS_TYPE_AP_BSS) {
 		if (!wl1271_is_active_sta(wl, hlid)) {
 			wl1271_debug(DEBUG_TX, "DROP skb hlid %d q %d",
 				     hlid, q);
 			dev_kfree_skb(skb);
@@ -1509,12 +1497,24 @@ static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		wl1271_debug(DEBUG_TX, "queue skb hlid %d q %d", hlid, q);
 		skb_queue_tail(&wl->links[hlid].tx_queue[q], skb);
 	} else {
 		skb_queue_tail(&wl->tx_queue[q], skb);
 	}
 
+	wl->tx_queue_count[q]++;
+
+	/*
+	 * The workqueue is slow to process the tx_queue and we need stop
+	 * the queue here, otherwise the queue will get too long.
+	 */
+	if (wl->tx_queue_count[q] >= WL1271_TX_QUEUE_HIGH_WATERMARK) {
+		wl1271_debug(DEBUG_TX, "op_tx: stopping queues for q %d", q);
+		ieee80211_stop_queue(wl->hw, mapping);
+		set_bit(q, &wl->stopped_queues_map);
+	}
+
 	/*
 	 * The chip specific setup must run before the first TX packet -
 	 * before that, the tx_work will not be initialized!
 	 */
 
 	if (!test_bit(WL1271_FLAG_FW_TX_BUSY, &wl->flags) &&
-- 
1.7.6.401.g6a319

