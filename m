Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39590 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2LJQke (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2012 11:40:34 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, b43-dev@lists.infradead.org
Subject: [PATCH] b43: fix tx path skb leaks
Date: Mon, 10 Dec 2012 17:40:21 +0100
Message-Id: <1355157621-25099-1-git-send-email-nbd@openwrt.org> (sfid-20121210_174038_549713_F35D3B07)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_free_txskb() needs to be used instead of dev_kfree_skb_any for
tx packets passed to the driver from mac80211

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
---
 drivers/net/wireless/b43/dma.c  |  7 +++++--
 drivers/net/wireless/b43/main.c | 12 ++++++++----
 drivers/net/wireless/b43/pio.c  |  4 ++--
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/dma.c b/drivers/net/wireless/b43/dma.c
index 777cd74..38bc5a7 100644
--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -409,7 +409,10 @@ static inline
 				struct b43_dmadesc_meta *meta)
 {
 	if (meta->skb) {
-		dev_kfree_skb_any(meta->skb);
+		if (ring->tx)
+			ieee80211_free_txskb(ring->dev->wl->hw, meta->skb);
+		else
+			dev_kfree_skb_any(meta->skb);
 		meta->skb = NULL;
 	}
 }
@@ -1454,7 +1457,7 @@ int b43_dma_tx(struct b43_wldev *dev, struct sk_buff *skb)
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index ddd6a4f..16ab280 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3397,7 +3397,7 @@ static void b43_tx_work(struct work_struct *work)
 				break;
 			}
 			if (unlikely(err))
-				dev_kfree_skb(skb); /* Drop it */
+				ieee80211_free_txskb(wl->hw, skb);
 			err = 0;
 		}
 
@@ -3419,7 +3419,7 @@ static void b43_op_tx(struct ieee80211_hw *hw,
 
 	if (unlikely(skb->len < 2 + 2 + 6)) {
 		/* Too short, this can't be a valid frame. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(hw, skb);
 		return;
 	}
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
@@ -4229,8 +4229,12 @@ redo:
 
 	/* Drain all TX queues. */
 	for (queue_num = 0; queue_num < B43_QOS_QUEUE_NUM; queue_num++) {
-		while (skb_queue_len(&wl->tx_queue[queue_num]))
-			dev_kfree_skb(skb_dequeue(&wl->tx_queue[queue_num]));
+		while (skb_queue_len(&wl->tx_queue[queue_num])) {
+			struct sk_buff *skb;
+
+			skb = skb_dequeue(&wl->tx_queue[queue_num]);
+			ieee80211_free_txskb(wl->hw, skb);
+		}
 	}
 
 	b43_mac_suspend(dev);
diff --git a/drivers/net/wireless/b43/pio.c b/drivers/net/wireless/b43/pio.c
index 3533ab8..a73ff8c 100644
--- a/drivers/net/wireless/b43/pio.c
+++ b/drivers/net/wireless/b43/pio.c
@@ -196,7 +196,7 @@ static void b43_pio_cancel_tx_packets(struct b43_pio_txqueue *q)
 	for (i = 0; i < ARRAY_SIZE(q->packets); i++) {
 		pack = &(q->packets[i]);
 		if (pack->skb) {
-			dev_kfree_skb_any(pack->skb);
+			ieee80211_free_txskb(q->dev->wl->hw, pack->skb);
 			pack->skb = NULL;
 		}
 	}
@@ -552,7 +552,7 @@ int b43_pio_tx(struct b43_wldev *dev, struct sk_buff *skb)
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */
-		dev_kfree_skb_any(skb);
+		ieee80211_free_txskb(dev->wl->hw, skb);
 		err = 0;
 		goto out;
 	}
-- 
1.7.12.2

