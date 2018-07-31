Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38814 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729643AbeGaJsn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 05:48:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id v14-v6so15622975wro.5
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 01:09:33 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2 09/19] mt76: rename mt76_tx_queue_skb in mt76_dma_tx_queue_skb
Date: Tue, 31 Jul 2018 10:09:10 +0200
Message-Id: <5ef0ce00c3f94aab387e7ae0fd1a2a1f37902783.1533023328.git.lorenzo.bianconi@redhat.com> (sfid-20180731_100956_807483_51DC4304)
In-Reply-To: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
References: <cover.1533023328.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move mt76_dma_tx_queue_skb routine in dma.c.
Remove static qualifier from mt76_get_txwi definition

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 74 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  7 +-
 .../net/wireless/mediatek/mt76/mt76x2_tx.c    |  3 +-
 drivers/net/wireless/mediatek/mt76/tx.c       | 84 ++-----------------
 4 files changed, 85 insertions(+), 83 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 872b1c53e246..6293f21856da 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -239,6 +239,80 @@ mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	iowrite32(q->head, &q->regs->cpu_idx);
 }
 
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+			  struct sk_buff *skb, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta)
+{
+	struct mt76_queue_entry e;
+	struct mt76_txwi_cache *t;
+	struct mt76_queue_buf buf[32];
+	struct sk_buff *iter;
+	dma_addr_t addr;
+	int len;
+	u32 tx_info = 0;
+	int n, ret;
+
+	t = mt76_get_txwi(dev);
+	if (!t) {
+		ieee80211_free_txskb(dev->hw, skb);
+		return -ENOMEM;
+	}
+
+	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
+				DMA_TO_DEVICE);
+	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, q, wcid, sta,
+				       &tx_info);
+	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
+				   DMA_TO_DEVICE);
+	if (ret < 0)
+		goto free;
+
+	len = skb->len - skb->data_len;
+	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev->dev, addr)) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	n = 0;
+	buf[n].addr = t->dma_addr;
+	buf[n++].len = dev->drv->txwi_size;
+	buf[n].addr = addr;
+	buf[n++].len = len;
+
+	skb_walk_frags(skb, iter) {
+		if (n == ARRAY_SIZE(buf))
+			goto unmap;
+
+		addr = dma_map_single(dev->dev, iter->data, iter->len,
+				      DMA_TO_DEVICE);
+		if (dma_mapping_error(dev->dev, addr))
+			goto unmap;
+
+		buf[n].addr = addr;
+		buf[n++].len = iter->len;
+	}
+
+	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
+		goto unmap;
+
+	return dev->queue_ops->add_buf(dev, q, buf, n, tx_info, skb, t);
+
+unmap:
+	ret = -ENOMEM;
+	for (n--; n > 0; n--)
+		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
+				 DMA_TO_DEVICE);
+
+free:
+	e.skb = skb;
+	e.txwi = t;
+	dev->drv->tx_complete_skb(dev, q, &e, true);
+	mt76_put_txwi(dev, t);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76_dma_tx_queue_skb);
+
 static int
 mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q, bool napi)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index eb0fd602b9cb..4d6660b9e451 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -421,9 +421,9 @@ wcid_to_sta(struct mt76_wcid *wcid)
 	return container_of(ptr, struct ieee80211_sta, drv_priv);
 }
 
-int mt76_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
-		      struct sk_buff *skb, struct mt76_wcid *wcid,
-		      struct ieee80211_sta *sta);
+int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+			  struct sk_buff *skb, struct mt76_wcid *wcid,
+			  struct ieee80211_sta *sta);
 
 void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
 void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
@@ -454,6 +454,7 @@ void mt76_wcid_key_setup(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 /* internal */
 void mt76_tx_free(struct mt76_dev *dev);
+struct mt76_txwi_cache *mt76_get_txwi(struct mt76_dev *dev);
 void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
 void mt76_rx_complete(struct mt76_dev *dev, struct sk_buff_head *frames,
 		      struct napi_struct *napi);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
index 241a1513ec55..84a3448ca163 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_tx.c
@@ -289,7 +289,8 @@ void mt76x2_pre_tbtt_tasklet(unsigned long arg)
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt76x2_vif *mvif = (struct mt76x2_vif *) vif->drv_priv;
 
-		mt76_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid, NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
+				      NULL);
 	}
 	spin_unlock_bh(&q->lock);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index e96956710fb2..f86501ecf31a 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -51,7 +51,7 @@ __mt76_get_txwi(struct mt76_dev *dev)
 	return t;
 }
 
-static struct mt76_txwi_cache *
+struct mt76_txwi_cache *
 mt76_get_txwi(struct mt76_dev *dev)
 {
 	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
@@ -91,80 +91,6 @@ mt76_txq_get_qid(struct ieee80211_txq *txq)
 	return txq->ac;
 }
 
-int mt76_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
-		      struct sk_buff *skb, struct mt76_wcid *wcid,
-		      struct ieee80211_sta *sta)
-{
-	struct mt76_queue_entry e;
-	struct mt76_txwi_cache *t;
-	struct mt76_queue_buf buf[32];
-	struct sk_buff *iter;
-	dma_addr_t addr;
-	int len;
-	u32 tx_info = 0;
-	int n, ret;
-
-	t = mt76_get_txwi(dev);
-	if (!t) {
-		ieee80211_free_txskb(dev->hw, skb);
-		return -ENOMEM;
-	}
-
-	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
-				DMA_TO_DEVICE);
-	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, q, wcid, sta,
-				       &tx_info);
-	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
-				   DMA_TO_DEVICE);
-	if (ret < 0)
-		goto free;
-
-	len = skb->len - skb->data_len;
-	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->dev, addr)) {
-		ret = -ENOMEM;
-		goto free;
-	}
-
-	n = 0;
-	buf[n].addr = t->dma_addr;
-	buf[n++].len = dev->drv->txwi_size;
-	buf[n].addr = addr;
-	buf[n++].len = len;
-
-	skb_walk_frags(skb, iter) {
-		if (n == ARRAY_SIZE(buf))
-			goto unmap;
-
-		addr = dma_map_single(dev->dev, iter->data, iter->len,
-				      DMA_TO_DEVICE);
-		if (dma_mapping_error(dev->dev, addr))
-			goto unmap;
-
-		buf[n].addr = addr;
-		buf[n++].len = iter->len;
-	}
-
-	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
-		goto unmap;
-
-	return dev->queue_ops->add_buf(dev, q, buf, n, tx_info, skb, t);
-
-unmap:
-	ret = -ENOMEM;
-	for (n--; n > 0; n--)
-		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
-				 DMA_TO_DEVICE);
-
-free:
-	e.skb = skb;
-	e.txwi = t;
-	dev->drv->tx_complete_skb(dev, q, &e, true);
-	mt76_put_txwi(dev, t);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(mt76_tx_queue_skb);
-
 void
 mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	struct mt76_wcid *wcid, struct sk_buff *skb)
@@ -185,7 +111,7 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	q = &dev->q_tx[qid];
 
 	spin_lock_bh(&q->lock);
-	mt76_tx_queue_skb(dev, q, skb, wcid, sta);
+	mt76_dma_tx_queue_skb(dev, q, skb, wcid, sta);
 	dev->queue_ops->kick(dev, q);
 
 	if (q->queued > q->ndesc - 8)
@@ -241,7 +167,7 @@ mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
 		info->flags |= IEEE80211_TX_STATUS_EOSP;
 
 	mt76_skb_set_moredata(skb, !last);
-	mt76_tx_queue_skb(dev, hwq, skb, wcid, sta);
+	mt76_dma_tx_queue_skb(dev, hwq, skb, wcid, sta);
 }
 
 void
@@ -321,7 +247,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 	if (ampdu)
 		mt76_check_agg_ssn(mtxq, skb);
 
-	idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+	idx = mt76_dma_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
 
 	if (idx < 0)
 		return idx;
@@ -356,7 +282,7 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
 		if (cur_ampdu)
 			mt76_check_agg_ssn(mtxq, skb);
 
-		idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+		idx = mt76_dma_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
 		if (idx < 0)
 			return idx;
 
-- 
2.17.1
