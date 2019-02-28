Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07168C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA5142184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 16:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551372907;
	bh=BbvWRlZgC24hzp53/nSTwwUB/CmEd7A7R+wEpFLpUDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wkEzHGXRi7ydqocOUIxIR4MZSXkFnO910ULQIDd2zLuGoHnx86fBRzWGno6ElpnJn
	 gHTM5Hu2hvs99lbA01NrRDAuEqybd4xYfcouOfBNOFsoDjx7jxsliKOpLBf/MXdjXn
	 dzdBYNPcRTkO6jEtX+MoOiu7Ejoy2aSCFIbr2f08=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732659AbfB1QzH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:55:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730732AbfB1QzH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 11:55:07 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72BF52184A;
        Thu, 28 Feb 2019 16:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551372905;
        bh=BbvWRlZgC24hzp53/nSTwwUB/CmEd7A7R+wEpFLpUDs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y/3nu9zqWZDJwgzuoSp07CtOagFHGOuO7UZ1n7pOsktoPbX44XaV1JB1T6/6Ufaf+
         fEBWd4r4UOBKOK8pCEp60paWF3qChHZw3QDxsAiN3Yt0fAprDVOtSZlvLGMSp/yDV9
         e2eYSsyu2nW4fa9edggee4YEYmb8ejATT3orM5dY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v3 2/2] mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module
Date:   Thu, 28 Feb 2019 17:54:32 +0100
Message-Id: <17f57fcb847f495bfc015137de32944bd7a500c8.1551370209.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551370209.git.lorenzo@kernel.org>
References: <cover.1551370209.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76x02_init_tx_queue and mt76x02_init_rx_queue in mt76
module in order to be reused adding support for mt7603 driver
and remove duplicated code.
Squash mt76x02_init_tx_queue and mt76x02_init_rx_queue in
mt76_dma_alloc_queue

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  9 ++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 ++-
 .../net/wireless/mediatek/mt76/mt7603/dma.c   | 26 +++++++------------
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 26 +++++++------------
 4 files changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 6eedc0ec7661..d2b7fa2c76d1 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -21,7 +21,9 @@
 #define DMA_DUMMY_TXWI	((void *) ~0)
 
 static int
-mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
+mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize,
+		     u32 ring_base)
 {
 	int size;
 	int i;
@@ -29,6 +31,11 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	spin_lock_init(&q->lock);
 	INIT_LIST_HEAD(&q->swq);
 
+	q->regs = dev->mmio.regs + ring_base + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->buf_size = bufsize;
+	q->hw_idx = idx;
+
 	size = q->ndesc * sizeof(struct mt76_desc);
 	q->desc = dmam_alloc_coherent(dev->dev, size, &q->desc_dma, GFP_KERNEL);
 	if (!q->desc)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 6376592e3cfd..29409f0871b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -148,7 +148,9 @@ struct mt76_mcu_ops {
 struct mt76_queue_ops {
 	int (*init)(struct mt76_dev *dev);
 
-	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q);
+	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize,
+		     u32 ring_base);
 
 	int (*add_buf)(struct mt76_dev *dev, struct mt76_queue *q,
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index d69e82c66ab2..5067c49142f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -8,15 +8,12 @@ static int
 mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc)
 {
-	int ret;
-
-	q->hw_idx = idx;
-	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
+	int err;
 
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
+	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
+			       MT_TX_RING_BASE);
+	if (err < 0)
+		return err;
 
 	mt7603_irq_enable(dev, MT_INT_TX_DONE(idx));
 
@@ -106,15 +103,12 @@ static int
 mt7603_init_rx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize)
 {
-	int ret;
-
-	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->buf_size = bufsize;
+	int err;
 
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
+	err = mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+			       MT_RX_RING_BASE);
+	if (err < 0)
+		return err;
 
 	mt7603_irq_enable(dev, MT_INT_RX_DONE(idx));
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 507f368ed3f7..1a7926de1dec 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -155,15 +155,12 @@ static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc)
 {
-	int ret;
+	int err;
 
-	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->hw_idx = idx;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
+	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
+			       MT_TX_RING_BASE);
+	if (err < 0)
+		return err;
 
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
 
@@ -174,15 +171,12 @@ static int
 mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc, int bufsize)
 {
-	int ret;
+	int err;
 
-	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->buf_size = bufsize;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
+	err = mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+			       MT_RX_RING_BASE);
+	if (err < 0)
+		return err;
 
 	mt76x02_irq_enable(dev, MT_INT_RX_DONE(idx));
 
-- 
2.20.1

