Return-Path: <SRS0=yoP0=R3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBF5AC43381
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 989B7222D6
	for <linux-wireless@archiver.kernel.org>; Sun, 24 Mar 2019 13:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553434331;
	bh=nObjBQ8CXix7SDsV2hgnJjdTrwsjckr+K6srg0i4ewo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=lUm/YezUq5vXXMDyfCdTf2kki614uuetGXF4V6s50/kdGbvWtIQVlOE4Yuu4UK82t
	 wdek8Nr8NToUhdm4t2smau1MjyNHNKDbcasibU5iGA1TNB0e5XzMiT/l/5wnt75Jes
	 5tKS1hYVh+2k7ZD4r+RGi41S6/zAX3qFzaUdnK4U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfCXNcE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 24 Mar 2019 09:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727211AbfCXNcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 24 Mar 2019 09:32:04 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1874222D6;
        Sun, 24 Mar 2019 13:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553434323;
        bh=nObjBQ8CXix7SDsV2hgnJjdTrwsjckr+K6srg0i4ewo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0M5nIzQhkcNKttjgsnfWv/EL1Zsx6F9azn/GPoSJShGeSLgv1YQTyrA2i2K6jg6h
         Wshs3YsZbLC6T32WPergNSrSN6HlfPg+R7WR6JCOIEHw+HvA2fUyO9/wO19V0desoW
         UeJ9Ntd7aX4XuqUAGvzqGRcSgmx+UnNtYVpuXCp8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] mt76: dma: introduce skb and flags fields in mt76_txwi_cache
Date:   Sun, 24 Mar 2019 14:31:10 +0100
Message-Id: <25c5d7a82ba3b17edc5fce67ca1341c92dff751c.1553425942.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1553425942.git.lorenzo@kernel.org>
References: <cover.1553425942.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce skb and flags fields in mt76_txwi_cache since new chipsets
will release mt76_txwi_cache/skbs at tx completion instead of dma one.
This is a preliminary patch to add mt7615 support

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 3 ++-
 drivers/net/wireless/mediatek/mt76/mt76.h | 5 +++++
 drivers/net/wireless/mediatek/mt76/tx.c   | 2 ++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index f4c2dd5366bc..8302ebd89338 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -174,7 +174,8 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 			dev->drv->tx_complete_skb(dev, qid, &entry);
 
 		if (entry.txwi) {
-			mt76_put_txwi(dev, entry.txwi);
+			if (!(entry.txwi->flags & MT_TXWI_NO_FREE))
+				mt76_put_txwi(dev, entry.txwi);
 			wake = !flush;
 		}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 0d7ae7c5ceba..f024ccfcf139 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -231,9 +231,13 @@ struct mt76_txq {
 	bool aggr;
 };
 
+#define MT_TXWI_NO_FREE			BIT(0)
 struct mt76_txwi_cache {
 	struct list_head list;
 	dma_addr_t dma_addr;
+
+	struct sk_buff *skb;
+	u32 flags;
 };
 
 struct mt76_rx_tid {
@@ -289,6 +293,7 @@ struct mt76_hw_cap {
 
 struct mt76_driver_ops {
 	bool tx_aligned4_skbs;
+	u32 txwi_flags;
 	u16 txwi_size;
 
 	void (*update_survey)(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 880f3ad0b254..f00782f05c62 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -32,6 +32,7 @@ mt76_alloc_txwi(struct mt76_dev *dev)
 	addr = dma_map_single(dev->dev, txwi, dev->drv->txwi_size,
 			      DMA_TO_DEVICE);
 	t = (struct mt76_txwi_cache *)(txwi + dev->drv->txwi_size);
+	t->flags = dev->drv->txwi_flags;
 	t->dma_addr = addr;
 
 	return t;
@@ -74,6 +75,7 @@ mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t)
 	list_add(&t->list, &dev->txwi_cache);
 	spin_unlock_bh(&dev->lock);
 }
+EXPORT_SYMBOL_GPL(mt76_put_txwi);
 
 void mt76_tx_free(struct mt76_dev *dev)
 {
-- 
2.20.1

