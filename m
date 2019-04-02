Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF89EC4360F
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D49F20857
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 09:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554198492;
	bh=VCQ7pWOyscL7OqXGkFZWdFL97BFq7DCTIFqXCb82TlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VQNoB4TZ6CnoG1BG5LnYFBKNUsJxCUUNs8XSg3jIArGYmXBU1j8254f2Hum8cDh8G
	 QOJH2zXdFVK6aoI/+zS28lDXJNmQaWhwE+QUEdWLxQeOMOIuqLUpQ7Waw1yLfzv36f
	 SVDZ23wxF9sLkLQ/WsRxZytt521D+LnM4LD7Km24=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729105AbfDBJsL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 05:48:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729004AbfDBJsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 05:48:11 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44D1C20857;
        Tue,  2 Apr 2019 09:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554198490;
        bh=VCQ7pWOyscL7OqXGkFZWdFL97BFq7DCTIFqXCb82TlA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRY9hIT16qeEmxr2PcEIc1wnskUOTcDctXi6AIbrLx5Y92W33v1mOWqHnCahbObI/
         d78kBunWK8nFI3uI4BBs7cduSju4uP4w0Y+gx23SUNXHWmdeRhGGSZd6K2ZJMsU0wb
         zcHqMnbXXHYvJz0Y+HCThOCIAvbHLNICIMjD1F1g=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2 1/4] mt76: set txwi_size according to the driver value
Date:   Tue,  2 Apr 2019 11:47:56 +0200
Message-Id: <e7867751e5cd2a8bd9eac05d679e32f93f21cd92.1554194917.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554194917.git.lorenzo@kernel.org>
References: <cover.1554194917.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dynamically allocate txwi since new chipsets will use longer txwi
descriptors

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c          |  8 +++++---
 drivers/net/wireless/mediatek/mt76/mt76.h         | 10 +++++++---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c  |  4 +++-
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c |  1 -
 drivers/net/wireless/mediatek/mt76/tx.c           | 12 +++++++-----
 5 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 7b8a998103d7..e0286fae8e79 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -290,12 +290,14 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	struct mt76_txwi_cache *t;
 	struct sk_buff *iter;
 	dma_addr_t addr;
+	u8 *txwi;
 
 	t = mt76_get_txwi(dev);
 	if (!t) {
 		ieee80211_free_txskb(dev->hw, skb);
 		return -ENOMEM;
 	}
+	txwi = mt76_get_txwi_ptr(dev, t);
 
 	skb->prev = skb->next = NULL;
 	if (dev->drv->tx_aligned4_skbs)
@@ -325,11 +327,11 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	}
 	tx_info.nbuf = n;
 
-	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
+	dma_sync_single_for_cpu(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				DMA_TO_DEVICE);
-	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
+	ret = dev->drv->tx_prepare_skb(dev, txwi, skb, qid, wcid, sta,
 				       &tx_info);
-	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
+	dma_sync_single_for_device(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				   DMA_TO_DEVICE);
 	if (ret < 0)
 		goto unmap;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b432da3f55c7..277f6b754693 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -228,12 +228,10 @@ struct mt76_txq {
 };
 
 struct mt76_txwi_cache {
-	u32 txwi[8];
-	dma_addr_t dma_addr;
 	struct list_head list;
+	dma_addr_t dma_addr;
 };
 
-
 struct mt76_rx_tid {
 	struct rcu_head rcu_head;
 
@@ -613,6 +611,12 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
 int mt76_eeprom_init(struct mt76_dev *dev, int len);
 void mt76_eeprom_override(struct mt76_dev *dev);
 
+static inline u8 *
+mt76_get_txwi_ptr(struct mt76_dev *dev, struct mt76_txwi_cache *t)
+{
+	return (u8 *)t - dev->drv->txwi_size;
+}
+
 /* increment with wrap-around */
 static inline int mt76_incr(int val, int size)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 1eb669ccd5a7..ffedb8e5d227 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -760,6 +760,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
+	u8 *txwi_ptr;
 
 	if (!e->txwi) {
 		dev_kfree_skb_any(e->skb);
@@ -768,7 +769,8 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 
 	mt76x02_mac_poll_tx_status(dev, false);
 
-	txwi = (struct mt76x02_txwi *) &e->txwi->txwi;
+	txwi_ptr = mt76_get_txwi_ptr(mdev, e->txwi);
+	txwi = (struct mt76x02_txwi *)txwi_ptr;
 	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
 
 	mt76_tx_complete_skb(mdev, e->skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 3116aa935ee4..518dea4b9425 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -174,7 +174,6 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 	struct mt76_queue *q;
 	void *status_fifo;
 
-	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
 	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
 
 	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x02_tx_status));
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 2c82db0b5834..08587d262469 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -21,15 +21,17 @@ mt76_alloc_txwi(struct mt76_dev *dev)
 {
 	struct mt76_txwi_cache *t;
 	dma_addr_t addr;
+	u8 *txwi;
 	int size;
 
-	size = (sizeof(*t) + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES - 1);
-	t = devm_kzalloc(dev->dev, size, GFP_ATOMIC);
-	if (!t)
+	size = L1_CACHE_ALIGN(dev->drv->txwi_size + sizeof(*t));
+	txwi = devm_kzalloc(dev->dev, size, GFP_ATOMIC);
+	if (!txwi)
 		return NULL;
 
-	addr = dma_map_single(dev->dev, &t->txwi, sizeof(t->txwi),
+	addr = dma_map_single(dev->dev, txwi, dev->drv->txwi_size,
 			      DMA_TO_DEVICE);
+	t = (struct mt76_txwi_cache *)(txwi + dev->drv->txwi_size);
 	t->dma_addr = addr;
 
 	return t;
@@ -78,7 +80,7 @@ void mt76_tx_free(struct mt76_dev *dev)
 	struct mt76_txwi_cache *t;
 
 	while ((t = __mt76_get_txwi(dev)) != NULL)
-		dma_unmap_single(dev->dev, t->dma_addr, sizeof(t->txwi),
+		dma_unmap_single(dev->dev, t->dma_addr, dev->drv->txwi_size,
 				 DMA_TO_DEVICE);
 }
 
-- 
2.20.1

