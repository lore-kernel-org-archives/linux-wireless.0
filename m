Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52896 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZJQT4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2009 15:56:44 -0400
Received: by fxm18 with SMTP id 18so3633004fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2009 12:56:48 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ar9170: atomic pending A-MPDU counter
Date: Sat, 17 Oct 2009 21:56:43 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200910172156.43459.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A ref-counting bug emerged after testing ar9170usb's HT
implementation on a bigger SMP/SMT system without the usual
_debugging_ overhead.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Just in case: all patches are for wireless-testing.
I don't think it's critical, since the A-MPDU can't
be enabled in vanilla anyway...
---
diff --git a/drivers/net/wireless/ath/ar9170/ar9170.h b/drivers/net/wireless/ath/ar9170/ar9170.h
index ec034af..9f94598 100644
--- a/drivers/net/wireless/ath/ar9170/ar9170.h
+++ b/drivers/net/wireless/ath/ar9170/ar9170.h
@@ -231,7 +231,7 @@ struct ar9170 {
 	struct sk_buff_head tx_status_ampdu;
 	spinlock_t tx_ampdu_list_lock;
 	struct list_head tx_ampdu_list;
-	unsigned int tx_ampdu_pending;
+	atomic_t tx_ampdu_pending;
 
 	/* rxstream mpdu merge */
 	struct ar9170_rxstream_mpdu_merge rx_mpdu;
diff --git a/drivers/net/wireless/ath/ar9170/main.c b/drivers/net/wireless/ath/ar9170/main.c
index de0ba2b..7e59b82 100644
--- a/drivers/net/wireless/ath/ar9170/main.c
+++ b/drivers/net/wireless/ath/ar9170/main.c
@@ -414,9 +414,9 @@ static void ar9170_tx_ampdu_callback(struct ar9170 *ar, struct sk_buff *skb)
 
 	skb_queue_tail(&ar->tx_status_ampdu, skb);
 	ar9170_tx_fake_ampdu_status(ar);
-	ar->tx_ampdu_pending--;
 
-	if (!list_empty(&ar->tx_ampdu_list) && !ar->tx_ampdu_pending)
+	if (atomic_dec_and_test(&ar->tx_ampdu_pending) &&
+	    !list_empty(&ar->tx_ampdu_list))
 		ar9170_tx_ampdu(ar);
 }
 
@@ -1248,6 +1248,7 @@ static int ar9170_op_start(struct ieee80211_hw *hw)
 	ar->global_ampdu_density = 6;
 	ar->global_ampdu_factor = 3;
 
+	atomic_set(&ar->tx_ampdu_pending, 0);
 	ar->bad_hw_nagger = jiffies;
 
 	err = ar->open(ar);
@@ -1773,7 +1774,7 @@ static void ar9170_tx(struct ar9170 *ar)
 					  msecs_to_jiffies(AR9170_TX_TIMEOUT);
 
 			if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
-				ar->tx_ampdu_pending++;
+				atomic_inc(&ar->tx_ampdu_pending);
 
 #ifdef AR9170_QUEUE_DEBUG
 			printk(KERN_DEBUG "%s: send frame q:%d =>\n",
@@ -1784,7 +1785,7 @@ static void ar9170_tx(struct ar9170 *ar)
 			err = ar->tx(ar, skb);
 			if (unlikely(err)) {
 				if (arinfo->flags == AR9170_TX_FLAG_BLOCK_ACK)
-					ar->tx_ampdu_pending--;
+					atomic_dec(&ar->tx_ampdu_pending);
 
 				frames_failed++;
 				dev_kfree_skb_any(skb);
@@ -1931,7 +1932,7 @@ int ar9170_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 		bool run = ar9170_tx_ampdu_queue(ar, skb);
 
-		if (run || !ar->tx_ampdu_pending)
+		if (run || !atomic_read(&ar->tx_ampdu_pending))
 			ar9170_tx_ampdu(ar);
 	} else {
 		unsigned int queue = skb_get_queue_mapping(skb);
