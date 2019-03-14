Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D20CC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ABB02184E
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 13:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552571683;
	bh=XVKPC8HwNxly32qtUpXMsqH6JhMs6hwViqyrySRIegQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=P+LpWAHILL9OIs8e4hKx2PGMwYfqyccvzrjiM1q8ZNtkuHJT8thBNjxxKqAQiVV1s
	 x+U8HZANFhVZ6U0GL+xrIQBfAEX593P4ZS6LDeu1T2rryNqpvN3fZ1ZiTS7bT6Q/Yl
	 ASNqiXjxeL9Z6EYXfV6jDZlKvlxa15/dZ0L6dWe0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727540AbfCNNym (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:41136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbfCNNym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 09:54:42 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B7B72184E;
        Thu, 14 Mar 2019 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552571681;
        bh=XVKPC8HwNxly32qtUpXMsqH6JhMs6hwViqyrySRIegQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z/dMESoXLR7tUTC7iRl9NCuXseZNFVL+HzPUgnlD2xjyQ1BFmp4W9s5AnXCaCA2HU
         8T41UEUFYDO22TVqsZmYeE1BYGuqVbVjBZB4O7oGkpw3sCF3XNgTJN+gRoqY+uyPQT
         Aqmko2DBh6mQNECcvECaB1/CHIhMq1vYq5v+7vy4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 3/4] mt76: move skb dma mapping before running tx_prepare_skb
Date:   Thu, 14 Mar 2019 14:54:11 +0100
Message-Id: <fefd6fea0c16c8ae67f00765943b4a2f5127858d.1552570806.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552570806.git.lorenzo@kernel.org>
References: <cover.1552570806.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move skb dma mapping before configuring txwi since new chipsets (mt7615)
will need skb dma addresses in order to properly configure txwi

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 33 +++++++++++-------------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 33725b839983..a3edaca05fa8 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -287,11 +287,10 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct mt76_queue_buf buf[32];
+	int len, n = 0, ret = -ENOMEM;
 	struct sk_buff *iter;
 	dma_addr_t addr;
-	int len;
 	u32 tx_info = 0;
-	int n, ret;
 
 	t = mt76_get_txwi(dev);
 	if (!t) {
@@ -303,23 +302,11 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (dev->drv->tx_aligned4_skbs)
 		mt76_insert_hdr_pad(skb);
 
-	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
-				DMA_TO_DEVICE);
-	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
-				       &tx_info);
-	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
-				   DMA_TO_DEVICE);
-	if (ret < 0)
-		goto free;
-
-	len = skb->len - skb->data_len;
+	len = skb_headlen(skb);
 	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->dev, addr)) {
-		ret = -ENOMEM;
+	if (dma_mapping_error(dev->dev, addr))
 		goto free;
-	}
 
-	n = 0;
 	buf[n].addr = t->dma_addr;
 	buf[n++].len = dev->drv->txwi_size;
 	buf[n].addr = addr;
@@ -338,13 +325,23 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		buf[n++].len = iter->len;
 	}
 
-	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
+	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
+				DMA_TO_DEVICE);
+	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
+				       &tx_info);
+	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
+				   DMA_TO_DEVICE);
+	if (ret < 0)
 		goto unmap;
 
+	if (q->queued + (n + 1) / 2 >= q->ndesc - 1) {
+		ret = -ENOMEM;
+		goto unmap;
+	}
+
 	return mt76_dma_add_buf(dev, q, buf, n, tx_info, skb, t);
 
 unmap:
-	ret = -ENOMEM;
 	for (n--; n > 0; n--)
 		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
 				 DMA_TO_DEVICE);
-- 
2.20.1

