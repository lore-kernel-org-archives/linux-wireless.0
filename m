Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:44194 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZK1XwD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Nov 2009 18:52:03 -0500
Received: by fxm5 with SMTP id 5so2616440fxm.28
        for <linux-wireless@vger.kernel.org>; Sat, 28 Nov 2009 15:52:08 -0800 (PST)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] ar9170: remove redundant frame flags
Cc: John W Linville <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sun, 29 Nov 2009 00:56:55 +0100
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200911290056.56081.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flags in question were once useful for debugging.
Time has passed and now they do nothing more than
duplicating txinfo->flags.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index 44c54b8..b99a8c2 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -248,13 +248,8 @@ struct ar9170_sta_info {
 	unsigned int ampdu_max_len;
 };
 
-#define AR9170_TX_FLAG_WAIT_FOR_ACK	BIT(0)
-#define AR9170_TX_FLAG_NO_ACK		BIT(1)
-#define AR9170_TX_FLAG_BLOCK_ACK	BIT(2)
-
 struct ar9170_tx_info {
 	unsigned long timeout;
-	unsigned int flags;
 };
 
 #define IS_STARTED(a)		(((struct ar9170 *)a)->state >= AR9170_STARTED)
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index 3cec2f1..d8ecf85 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -213,10 +213,10 @@ static void ar9170_print_txheader(struct ar9170 *ar, struct sk_buff *skb)
 	struct ar9170_tx_info *arinfo = (void *) txinfo->rate_driver_data;
 	struct ieee80211_hdr *hdr = (void *) txc->frame_data;
 
-	printk(KERN_DEBUG "%s: => FRAME [skb:%p, q:%d, DA:[%pM] flags:%x s:%d "
+	printk(KERN_DEBUG "%s: => FRAME [skb:%p, q:%d, DA:[%pM] s:%d "
 			  "mac_ctrl:%04x, phy_ctrl:%08x, timeout:[%d ms]]\n",
 	       wiphy_name(ar->hw->wiphy), skb, skb_get_queue_mapping(skb),
-	       ieee80211_get_DA(hdr), arinfo->flags, ar9170_get_seq_h(hdr),
+	       ieee80211_get_DA(hdr), ar9170_get_seq_h(hdr),
 	       le16_to_cpu(txc->mac_control), le32_to_cpu(txc->phy_control),
 	       jiffies_to_msecs(arinfo->timeout - jiffies));
 }
@@ -440,22 +440,17 @@ void ar9170_tx_callback(struct ar9170 *ar, struct sk_buff *skb)
 	}
 	spin_unlock_irqrestore(&ar->tx_stats_lock, flags);
 
-	if (arinfo->flags & AR9170_TX_FLAG_BLOCK_ACK) {
-		ar9170_tx_ampdu_callback(ar, skb);
-	} else if (arinfo->flags & AR9170_TX_FLAG_WAIT_FOR_ACK) {
-		arinfo->timeout = jiffies +
-				  msecs_to_jiffies(AR9170_TX_TIMEOUT);
-
-		skb_queue_tail(&ar->tx_status[queue], skb);
-	} else if (arinfo->flags & AR9170_TX_FLAG_NO_ACK) {
+	if (info->flags & IEEE80211_TX_CTL_NO_ACK) {
 		ar9170_tx_status(ar, skb, AR9170_TX_STATUS_FAILED);
 	} else {
-#ifdef AR9170_QUEUE_DEBUG
-		printk(KERN_DEBUG "%s: unsupported frame flags!\n",
-		       wiphy_name(ar->hw->wiphy));
-		ar9170_print_txheader(ar, skb);
-#endif /* AR9170_QUEUE_DEBUG */
-		dev_kfree_skb_any(skb);
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			ar9170_tx_ampdu_callback(ar, skb);
+		} else {
+			arinfo->timeout = jiffies +
+				  msecs_to_jiffies(AR9170_TX_TIMEOUT);
+
+			skb_queue_tail(&ar->tx_status[queue], skb);
+		}
 	}
 
 	if (!ar->tx_stats[queue].len &&
@@ -1407,17 +1402,6 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK) &&
 	     (is_valid_ether_addr(ieee80211_get_DA(hdr)))) {
-		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
-			if (unlikely(!info->control.sta))
-				goto err_out;
-
-			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
-			arinfo->flags = AR9170_TX_FLAG_BLOCK_ACK;
-
-			goto out;
-		}
-
-		txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
 		/*
 		 * WARNING:
 		 * Putting the QoS queue bits into an unexplored territory is
@@ -1431,12 +1415,17 @@ static int ar9170_tx_prepare(struct ar9170 *ar, struct sk_buff *skb)
 
 		txc->phy_control |=
 			cpu_to_le32(queue << AR9170_TX_PHY_QOS_SHIFT);
-		arinfo->flags = AR9170_TX_FLAG_WAIT_FOR_ACK;
-	} else {
-		arinfo->flags = AR9170_TX_FLAG_NO_ACK;
+
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+			if (unlikely(!info->control.sta))
+				goto err_out;
+
+			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_AGGR);
+		} else {
+			txc->mac_control |= cpu_to_le16(AR9170_TX_MAC_RATE_PROBE);
+		}
 	}
 
-out:
 	return 0;
 
 err_out:
@@ -1771,7 +1760,7 @@ static void ar9170_tx(struct ar9170 *ar)
 			arinfo->timeout = jiffies +
 					  msecs_to_jiffies(AR9170_TX_TIMEOUT);
 
-			if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
+			if (info->flags & IEEE80211_TX_CTL_AMPDU)
 				atomic_inc(&ar->tx_ampdu_pending);
 
 #ifdef AR9170_QUEUE_DEBUG
@@ -1782,7 +1771,7 @@ static void ar9170_tx(struct ar9170 *ar)
 
 			err = ar->tx(ar, skb);
 			if (unlikely(err)) {
-				if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
+				if (info->flags & IEEE80211_TX_CTL_AMPDU)
 					atomic_dec(&ar->tx_ampdu_pending);
 
 				frames_failed++;
