Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22469C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BACBD20869
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 11:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="HakDci72"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfDMLjp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 07:39:45 -0400
Received: from nbd.name ([46.4.11.11]:54050 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfDMLjp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 07:39:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:
        MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cr1isKnR+U9j1MGRFTNwcgPN3Zx6tgpoinFM2Y0lb70=; b=HakDci72w41eEZlgRQ+jQYbEPZ
        hH+h2R/X5JG6epL3Vm6BaUKMBChn+RJW/OfBklBB5WalerKYcBlpsSHI8sXEny39tt6ptFOQri9un
        zH3qAK6ZozHYsZXrZXoS4PQAYALwAweJ8iyPk8FAtIuhQT4ZDqRBBZHQd2mWOqNdhww4=;
Received: from p4ff13bac.dip0.t-ipconnect.de ([79.241.59.172] helo=maeck-2.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1hFH0a-00075K-1A
        for linux-wireless@vger.kernel.org; Sat, 13 Apr 2019 13:39:44 +0200
Received: by maeck-2.local (Postfix, from userid 501)
        id 53A0B5849352; Sat, 13 Apr 2019 13:39:43 +0200 (CEST)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: use readl/writel instead of ioread32/iowrite32
Date:   Sat, 13 Apr 2019 13:39:43 +0200
Message-Id: <20190413113943.75675-1-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Switching to readl/writel is faster because it gets rid of an unnecessary
wrapper with extra checks.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 22 +++++++++----------
 drivers/net/wireless/mediatek/mt76/mmio.c     |  4 ++--
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  4 ++--
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 7b8a998103d7..cdeca22bf3a7 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -49,10 +49,10 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
 	for (i = 0; i < q->ndesc; i++)
 		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
-	iowrite32(q->desc_dma, &q->regs->desc_base);
-	iowrite32(0, &q->regs->cpu_idx);
-	iowrite32(0, &q->regs->dma_idx);
-	iowrite32(q->ndesc, &q->regs->ring_size);
+	writel(q->desc_dma, &q->regs->desc_base);
+	writel(0, &q->regs->cpu_idx);
+	writel(0, &q->regs->dma_idx);
+	writel(q->ndesc, &q->regs->ring_size);
 
 	return 0;
 }
@@ -136,11 +136,11 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 static void
 mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	iowrite32(q->desc_dma, &q->regs->desc_base);
-	iowrite32(q->ndesc, &q->regs->ring_size);
-	q->head = ioread32(&q->regs->dma_idx);
+	writel(q->desc_dma, &q->regs->desc_base);
+	writel(q->ndesc, &q->regs->ring_size);
+	q->head = readl(&q->regs->dma_idx);
 	q->tail = q->head;
-	iowrite32(q->head, &q->regs->cpu_idx);
+	writel(q->head, &q->regs->cpu_idx);
 }
 
 static void
@@ -159,7 +159,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 	if (flush)
 		last = -1;
 	else
-		last = ioread32(&q->regs->dma_idx);
+		last = readl(&q->regs->dma_idx);
 
 	while (q->queued && q->tail != last) {
 		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
@@ -181,7 +181,7 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 		}
 
 		if (!flush && q->tail == last)
-			last = ioread32(&q->regs->dma_idx);
+			last = readl(&q->regs->dma_idx);
 	}
 
 	if (!flush)
@@ -251,7 +251,7 @@ mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 static void
 mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	iowrite32(q->head, &q->regs->cpu_idx);
+	writel(q->head, &q->regs->cpu_idx);
 }
 
 static int
diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 059f13bf9dff..38368d19aa6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -21,7 +21,7 @@ static u32 mt76_mmio_rr(struct mt76_dev *dev, u32 offset)
 {
 	u32 val;
 
-	val = ioread32(dev->mmio.regs + offset);
+	val = readl(dev->mmio.regs + offset);
 	trace_reg_rr(dev, offset, val);
 
 	return val;
@@ -30,7 +30,7 @@ static u32 mt76_mmio_rr(struct mt76_dev *dev, u32 offset)
 static void mt76_mmio_wr(struct mt76_dev *dev, u32 offset, u32 val)
 {
 	trace_reg_wr(dev, offset, val);
-	iowrite32(val, dev->mmio.regs + offset);
+	writel(val, dev->mmio.regs + offset);
 }
 
 static u32 mt76_mmio_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 5f800467c628..5a5337e2dad4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1417,11 +1417,11 @@ static bool mt7603_tx_hang(struct mt7603_dev *dev)
 			continue;
 
 		prev_dma_idx = dev->tx_dma_idx[i];
-		dma_idx = ioread32(&q->regs->dma_idx);
+		dma_idx = readl(&q->regs->dma_idx);
 		dev->tx_dma_idx[i] = dma_idx;
 
 		if (dma_idx == prev_dma_idx &&
-		    dma_idx != ioread32(&q->regs->cpu_idx))
+		    dma_idx != readl(&q->regs->cpu_idx))
 			break;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index ca8320711bc2..705c0939d10b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -349,7 +349,7 @@ static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
 			continue;
 
 		prev_dma_idx = dev->mt76.tx_dma_idx[i];
-		dma_idx = ioread32(&q->regs->dma_idx);
+		dma_idx = readl(&q->regs->dma_idx);
 		dev->mt76.tx_dma_idx[i] = dma_idx;
 
 		if (prev_dma_idx == dma_idx)
-- 
2.17.0

