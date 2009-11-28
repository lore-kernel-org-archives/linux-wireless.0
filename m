Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:54491 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZK1XsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 18:48:17 -0500
Received: by fxm5 with SMTP id 5so2615334fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 15:48:23 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] ar9170: improve network latency
Cc: John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 29 Nov 2009 00:52:51 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911290052.51819.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9170 has the bad habit of choking when traffic builds up.
Tests have shown that this can partially be attributed to
a huge buildup of backlogged frames.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
low priority.
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index d95a7d4..44c54b8 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -152,6 +152,8 @@ struct ar9170_sta_tid {
 
 #define AR9170_NUM_TX_STATUS		128
 #define AR9170_NUM_TX_AGG_MAX		30
+#define AR9170_NUM_TX_LIMIT_HARD       AR9170_TXQ_DEPTH
+#define AR9170_NUM_TX_LIMIT_SOFT       (AR9170_TXQ_DEPTH - 10)
 
 struct ar9170 {
 	struct ieee80211_hw *hw;
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index cbf59b1..3cec2f1 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -430,7 +430,7 @@ void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 	spin_lock_irqsave(&ar->tx_stats_lock, flags);
 	ar->tx_stats[queue].len--;
 
-	if (skb_queue_empty(&ar->tx_pending[queue])) {
+	if (ar->tx_stats[queue].len < AR9170_NUM_TX_LIMIT_SOFT) {
 #ifdef AR9170_QUEUE_STOP_DEBUG
 		printk(KERN_DEBUG "%s: wake queue %d\n",
 		       wiphy_name(ar->hw->wiphy), queue);
@@ -1716,6 +1716,21 @@ static void ar9170_tx(struct ar9170 *ar)
 
 	for (i = 0; i < __AR9170_NUM_TXQ; i++) {
 		spin_lock_irqsave(&ar->tx_stats_lock, flags);
+		frames = min(ar->tx_stats[i].limit - ar->tx_stats[i].len,
+			     skb_queue_len(&ar->tx_pending[i]));
+
+		if (remaining_space < frames) {
+#ifdef AR9170_QUEUE_DEBUG
+			printk(KERN_DEBUG "%s: tx quota reached queue:%d, "
+			       "remaining slots:%d, needed:%d\n",
+			       wiphy_name(ar->hw->wiphy), i, remaining_space,
+			       frames);
+#endif /* AR9170_QUEUE_DEBUG */
+			frames = remaining_space;
+		}
+
+		ar->tx_stats[i].len += frames;
+		ar->tx_stats[i].count += frames;
 		if (ar->tx_stats[i].len >= ar->tx_stats[i].limit) {
 #ifdef AR9170_QUEUE_DEBUG
 			printk(KERN_DEBUG "%s: queue %d full\n",
@@ -1733,25 +1748,8 @@ static void ar9170_tx(struct ar9170 *ar)
 			__ar9170_dump_txstats(ar);
 #endif /* AR9170_QUEUE_STOP_DEBUG */
 			ieee80211_stop_queue(ar->hw, i);
-			spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
-			continue;
-		}
-
-		frames = min(ar->tx_stats[i].limit - ar->tx_stats[i].len,
-			     skb_queue_len(&ar->tx_pending[i]));
-
-		if (remaining_space < frames) {
-#ifdef AR9170_QUEUE_DEBUG
-			printk(KERN_DEBUG "%s: tx quota reached queue:%d, "
-			       "remaining slots:%d, needed:%d\n",
-			       wiphy_name(ar->hw->wiphy), i, remaining_space,
-			       frames);
-#endif /* AR9170_QUEUE_DEBUG */
-			frames = remaining_space;
 		}
 
-		ar->tx_stats[i].len += frames;
-		ar->tx_stats[i].count += frames;
 		spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 
 		if (!frames)
