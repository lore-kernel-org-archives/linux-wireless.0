Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48812 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725995AbeIDTH2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 15:07:28 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-mediatek@lists.infradead.org
Subject: [PATCH 09/22] mt76: remove q->hw_idx
Date: Tue,  4 Sep 2018 16:41:02 +0200
Message-Id: <1536072075-6990-10-git-send-email-sgruszka@redhat.com> (sfid-20180904_164210_846665_A772AB0D)
In-Reply-To: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
References: <1536072075-6990-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use q->hw_idx in very few places, remove it and provide hwq index
by diffrent way. This will allow ot unify conf_tx mac80211 callback.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2_common.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt76x2_dma.c    | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2u_core.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/usb.c           | 6 +++---
 5 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 7a7d13b16508..cef3e513b8f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -113,7 +113,6 @@ struct mt76_queue {
 	int buf_size;
 
 	u8 buf_offset;
-	u8 hw_idx;
 
 	dma_addr_t desc_dma;
 	struct sk_buff *rx_head;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
index 7f05aebf67ec..ead53faa1fb3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_common.c
@@ -34,7 +34,7 @@ int mt76x2_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u8 cw_min = 5, cw_max = 10, qid;
 	u32 val;
 
-	qid = dev->mt76.q_tx[queue].hw_idx;
+	qid = mt76_ac_to_hwq(queue);
 
 	if (params->cw_min)
 		cw_min = fls(params->cw_min);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
index 1c8e5d7be425..919dc3f36255 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_dma.c
@@ -55,7 +55,6 @@ mt76x2_init_tx_queue(struct mt76x2_dev *dev, struct mt76_queue *q,
 
 	q->regs = dev->mt76.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
 	q->ndesc = n_desc;
-	q->hw_idx = idx;
 
 	ret = mt76_queue_alloc(dev, q);
 	if (ret)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
index 500d7db338aa..d5dc4eb15818 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2u_core.c
@@ -84,6 +84,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	struct mt76x2_dev *dev = container_of(mdev, struct mt76x2_dev, mt76);
 	struct mt76x2_txwi *txwi;
 	int err, len = skb->len;
+	int *hwq_ptr = (int *) data;
 
 	err = mt76x2u_check_skb_rooms(skb);
 	if (err < 0)
@@ -94,7 +95,7 @@ int mt76x2u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	txwi = skb_push(skb, sizeof(struct mt76x2_txwi));
 	mt76x2_mac_write_txwi(dev, txwi, skb, wcid, sta, len);
 
-	return mt76x2u_set_txinfo(skb, wcid, q2ep(q->hw_idx));
+	return mt76x2u_set_txinfo(skb, wcid, q2ep(*hwq_ptr));
 }
 
 void mt76x2u_tx_complete_skb(struct mt76_dev *mdev, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 333b2c8ca7a4..5785e54c32d0 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -652,7 +652,8 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 ep = q2ep(q->hw_idx);
+	int hwq = mt76_ac_to_hwq(skb_get_queue_mapping(skb));
+	u8 ep = q2ep(hwq);
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	unsigned int pipe;
@@ -661,7 +662,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (q->queued == q->ndesc)
 		return -ENOSPC;
 
-	err = dev->drv->tx_prepare_skb(dev, NULL, skb, q, wcid, sta, NULL);
+	err = dev->drv->tx_prepare_skb(dev, &hwq, skb, q, wcid, sta, NULL);
 	if (err < 0)
 		return err;
 
@@ -715,7 +716,6 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 		q = &dev->q_tx[i];
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->swq);
-		q->hw_idx = mt76_ac_to_hwq(i);
 
 		q->entry = devm_kzalloc(dev->dev,
 					MT_NUM_TX_ENTRIES * sizeof(*q->entry),
-- 
2.7.5
