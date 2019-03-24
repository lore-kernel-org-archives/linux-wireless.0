Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37AE2C43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6054222DA
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553434305;
	bh=2/qK0dg/NnaSRl3A6KMbxSPXU56MnUz6ujfpboQAAR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Tbw8TkfXCu0X3se1zdunNQdFrzmqk7s4knfy1KG3ZIHbxyH0v+T5/WtOrLKlwysti
	 7KXg/DuY48j31S1DrG6yT3fk1zFQGTLd1KK9HYb+YgLTsSpLGdBOI5ddQ1qzGBkVxl
	 0hoBMI4CRxneck2aVpCySYfCnBHE8qBSocTxIN70=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfCXNbm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 09:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:35602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbfCXNbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 09:31:42 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CDB222D6;
        Sun, 24 Mar 2019 13:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553434301;
        bh=2/qK0dg/NnaSRl3A6KMbxSPXU56MnUz6ujfpboQAAR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r7iHzVz+tooDOlgBNULFoG0eoO5oyaABwhvGpFhw9+FglFsjQ+YMlh7b0Vo4PcUfF
         Il2Dw9pwZKe852AFivwunmmEUDGSGxlYnlJTampL9MN+34Ij7gXDyvooy7NJJ+K02n
         YmTtjNeIZpMRhaAnjZi9DxhfC0MMP4iu3QpIP+8c=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: set txwi_size according to the driver value
Date:   Sun, 24 Mar 2019 14:31:08 +0100
Message-Id: <83b6c031ebecf8f235abfd2bb536e5ed91ee7299.1553425942.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553425942.git.lorenzo@kernel.org>
References: <cover.1553425942.git.lorenzo@kernel.org>
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
index 35010915697c..4ad2a457cd54 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -296,12 +296,14 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
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
@@ -331,11 +333,11 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
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
index 070353dcae4c..3391dd1cbb32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -231,12 +231,10 @@ struct mt76_txq {
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
 
@@ -618,6 +616,12 @@ void mt76_seq_puts_array(struct seq_file *file, const char *str,
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
index e887c5c809aa..ce0af06943fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -773,6 +773,7 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	struct mt76x02_txwi *txwi;
+	u8 *txwi_ptr;
 
 	if (!e->txwi) {
 		dev_kfree_skb_any(e->skb);
@@ -781,7 +782,8 @@ void mt76x02_tx_complete_skb(struct mt76_dev *mdev, enum mt76_txq_id qid,
 
 	mt76x02_mac_poll_tx_status(dev, false);
 
-	txwi = (struct mt76x02_txwi *) &e->txwi->txwi;
+	txwi_ptr = mt76_get_txwi_ptr(mdev, e->txwi);
+	txwi = (struct mt76x02_txwi *)txwi_ptr;
 	trace_mac_txdone_add(dev, txwi->wcid, txwi->pktid);
 
 	mt76_tx_complete_skb(mdev, e->skb);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 7e11ab0d7252..a7eadf947846 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -177,7 +177,6 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 	struct mt76_queue *q;
 	void *status_fifo;
 
-	BUILD_BUG_ON(sizeof(t->txwi) < sizeof(struct mt76x02_txwi));
 	BUILD_BUG_ON(sizeof(struct mt76x02_rxwi) > MT_RX_HEADROOM);
 
 	fifo_size = roundup_pow_of_two(32 * sizeof(struct mt76x02_tx_status));
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 60bbb6561d8f..880f3ad0b254 100644
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

