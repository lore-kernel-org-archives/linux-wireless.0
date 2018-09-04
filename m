Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:53746 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTHX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:23 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 08/22] mt76: unify AC to hw queue mapping
Date: Tue,  4 Sep 2018 16:41:01 +0200
Message-Id: <1536072075-6990-9-git-send-email-sgruszka@redhat.com> (sfid-20180904_164202_342376_772E4E87)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use the same AC to hardware queue mappings for all subdrivers.
Note: this change BK and BE mappings for USB drivers.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h       |  8 +-------
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c  |  4 ++--
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c | 10 ++--------
 drivers/net/wireless/mediatek/mt76/tx.c         | 16 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/usb.c        |  2 +-
 5 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index cb9b9852f32f..7a7d13b16508 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -519,13 +519,7 @@ static inline int mt76_decr(int val, int size)
 	return (val - 1) & (size - 1);
 }
 
-/* Hardware uses mirrored order of queues with Q3
- * having the highest priority
- */
-static inline u8 q2hwq(u8 q)
-{
-	return q ^ 0x3;
-}
+u8 mt76_ac_to_hwq(u8 ac);
 
 static inline struct ieee80211_txq *
 mtxq_to_txq(struct mt76_txq *mtxq)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
index 73ea6d3097f2..acf830bc9b4e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -25,7 +25,7 @@ static u8 skb2q(struct sk_buff *skb)
 		skb_set_queue_mapping(skb, qid);
 	}
 
-	return q2hwq(qid);
+	return mt76_ac_to_hwq(qid);
 }
 
 static void mt76x0_tx_skb_remove_dma_overhead(struct sk_buff *skb,
@@ -216,7 +216,7 @@ int mt76x0_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		    u16 queue, const struct ieee80211_tx_queue_params *params)
 {
 	struct mt76x0_dev *dev = hw->priv;
-	u8 cw_min = 5, cw_max = 10, hw_q = q2hwq(queue);
+	u8 cw_min = 5, cw_max = 10, hw_q = mt76_ac_to_hwq(queue);
 	u32 val;
 
 	/* TODO: should we do funny things with the parameters?
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 6720a6a1313f..1c8e5d7be425 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -102,12 +102,6 @@ mt76x2_tx_tasklet(unsigned long data)
 
 int mt76x2_dma_init(struct mt76x2_dev *dev)
 {
-	static const u8 wmm_queue_map[] = {
-		[IEEE80211_AC_BE] = 0,
-		[IEEE80211_AC_BK] = 1,
-		[IEEE80211_AC_VI] = 2,
-		[IEEE80211_AC_VO] = 3,
-	};
 	int ret;
 	int i;
 	struct mt76_txwi_cache __maybe_unused *t;
@@ -125,9 +119,9 @@ int mt76x2_dma_init(struct mt76x2_dev *dev)
 
 	mt76_wr(dev, MT_WPDMA_RST_IDX, ~0);
 
-	for (i = 0; i < ARRAY_SIZE(wmm_queue_map); i++) {
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		ret = mt76x2_init_tx_queue(dev, &dev->mt76.q_tx[i],
-					   wmm_queue_map[i], MT_TX_RING_SIZE);
+					   mt76_ac_to_hwq(i), MT_TX_RING_SIZE);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index af48d43bb7dc..cf79b8c67b52 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -442,3 +442,19 @@ void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
 	mtxq->hwq = &dev->q_tx[mt76_txq_get_qid(txq)];
 }
 EXPORT_SYMBOL_GPL(mt76_txq_init);
+
+u8 mt76_ac_to_hwq(u8 ac)
+{
+	static const u8 wmm_queue_map[] = {
+		[IEEE80211_AC_BE] = 0,
+		[IEEE80211_AC_BK] = 1,
+		[IEEE80211_AC_VI] = 2,
+		[IEEE80211_AC_VO] = 3,
+	};
+
+	if (WARN_ON(ac >= IEEE80211_NUM_ACS))
+		return 0;
+
+	return wmm_queue_map[ac];
+}
+EXPORT_SYMBOL_GPL(mt76_ac_to_hwq);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 7780b07543bb..333b2c8ca7a4 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -715,7 +715,7 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 		q = &dev->q_tx[i];
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->swq);
-		q->hw_idx = q2hwq(i);
+		q->hw_idx = mt76_ac_to_hwq(i);
 
 		q->entry = devm_kzalloc(dev->dev,
 					MT_NUM_TX_ENTRIES * sizeof(*q->entry),
-- 
2.7.5
