Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39177 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754165AbeD3OND (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 10:13:03 -0400
Received: by mail-wr0-f194.google.com with SMTP id q3-v6so8191383wrj.6
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2018 07:13:03 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [RFC 09/18] mt76: introduce tx_queue_skb function pointer in mt76_bus_ops
Date: Mon, 30 Apr 2018 16:12:24 +0200
Message-Id: <a367e1a6a7da80b8cd3725c9a691cf941a341cdb.1525096206.git.lorenzo.bianconi@redhat.com> (sfid-20180430_161307_362642_30371C3A)
In-Reply-To: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
References: <cover.1525096206.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add tx_queue_skb function pointer in mt76_bus_ops since mt76x2u based
devices do not map mt76x2_txwi on dma buffers and it is not possible
to reuse mt76_tx_queue_skb() routine to enqueue tx frames to hw buffers

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 1 +
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/tx.c   | 9 +++++----
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 528132c3d1cd..cebd419ae83a 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -432,6 +432,7 @@ static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
 	.alloc = mt76_dma_alloc_queue,
 	.add_buf = mt76_dma_add_buf,
+	.tx_queue_skb = mt76_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
 	.rx_reset = mt76_dma_rx_reset,
 	.kick = mt76_dma_kick_queue,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f4144c3e70d3..9fc11cc4f029 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -30,6 +30,7 @@
 #define MT_RX_BUF_SIZE      2048
 
 struct mt76_dev;
+struct mt76_wcid;
 
 struct mt76_bus_ops {
 	u32 (*rr)(struct mt76_dev *dev, u32 offset);
@@ -110,6 +111,10 @@ struct mt76_queue_ops {
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
 		       struct sk_buff *skb, void *txwi);
 
+	int (*tx_queue_skb)(struct mt76_dev *dev, struct mt76_queue *q,
+			    struct sk_buff *skb, struct mt76_wcid *wcid,
+			    struct ieee80211_sta *sta);
+
 	void *(*dequeue)(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 			 int *len, u32 *info, bool *more);
 
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 7ecd2d7c5db4..fa6e5854925e 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -185,7 +185,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	q = &dev->q_tx[qid];
 
 	spin_lock_bh(&q->lock);
-	mt76_tx_queue_skb(dev, q, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
 	if (q->queued > q->ndesc - 8)
@@ -241,7 +241,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		info->flags |= IEEE80211_TX_STATUS_EOSP;
 
 	mt76_skb_set_moredata(skb, !last);
-	mt76_tx_queue_skb(dev, hwq, skb, wcid, sta);
+	dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, sta);
 }
 
 void
@@ -321,7 +321,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	if (ampdu)
 		mt76_check_agg_ssn(mtxq, skb);
 
-	idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+	idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
 
 	if (idx < 0)
 		return idx;
@@ -356,7 +356,8 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (cur_ampdu)
 			mt76_check_agg_ssn(mtxq, skb);
 
-		idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+		idx = dev->queue_ops->tx_queue_skb(dev, hwq, skb, wcid,
+						   txq->sta);
 		if (idx < 0)
 			return idx;
 
-- 
2.14.3
