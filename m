Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCD22C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F32220657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 12:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552307755;
	bh=XSWTr19u5U8iGiZwuXk2fkCwpeqjXaEW5p+vIsS3vxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=WJYd0VV/VSf2uBKTea5DfxyOaGjV1hMCjBMXpv2tSadIQtOGwWLpAfomiOalMueHm
	 zHZg1giHyFSs2Rdo7ZzA+iIAyFQZ3aSvHNxS+8iD3lQawFbgqQ3dF2id2K0LQLkBwl
	 CNWrSGG12OMBqiGChcct/QZFWGQx+eMPq97d8HiM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfCKMfz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 08:35:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726826AbfCKMfy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 08:35:54 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40A052084F;
        Mon, 11 Mar 2019 12:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552307754;
        bh=XSWTr19u5U8iGiZwuXk2fkCwpeqjXaEW5p+vIsS3vxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sns+rnDbX1d3tvIhtLCLTpyX4Uc9ubuHROPKLCH0HxgUFm9rYKeXiW5Orpuy8I6ii
         3Z+o9eHyS8xL524cqMkt4UbofU8jBP1dHJWLdFPDtk6aGAmSlLoOhp/Eae9ata73Ht
         bl3PoWrTLVJefs3JrEIf6RPNVawCd6dwRImnN4LA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     ryder.lee@mediatek.com, roychl666@gmail.com,
        linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH 3/4] mt76: move skb dma mapping before running tx_prepare_skb
Date:   Mon, 11 Mar 2019 13:35:25 +0100
Message-Id: <34d158de1d7476e03ade43c2c974363f18e042f8.1552306908.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552306908.git.lorenzo@kernel.org>
References: <cover.1552306908.git.lorenzo@kernel.org>
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
 drivers/net/wireless/mediatek/mt76/dma.c | 29 ++++++++++--------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 14dd6585bab4..a29b2aa95a51 100644
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
@@ -341,10 +328,18 @@ mt76_dma_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
 		goto unmap;
 
+	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
+				DMA_TO_DEVICE);
+	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, qid, wcid, sta,
+				       &tx_info);
+	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
+				   DMA_TO_DEVICE);
+	if (ret < 0)
+		goto unmap;
+
 	return mt76_dma_add_buf(dev, q, buf, n, tx_info, skb, t);
 
 unmap:
-	ret = -ENOMEM;
 	for (n--; n > 0; n--)
 		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
 				 DMA_TO_DEVICE);
-- 
2.20.1

