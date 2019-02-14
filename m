Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF8F1C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DE0321928
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550163045;
	bh=sReStVg5N7KR3VdZA/aJvnO+YS722gS1Z2H/eE8VpVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Zh8ZFwhXZCpz5DLangaVR8usPW7c2LSPE1XfW4ZY3tupTGJy6QmkLR1+MVytY4Jst
	 nDW4wLOiCzunyeQZOMtF+5JgBDT1ewtxxEJWqhv4hX+UnZBnxXJoEykUL4mVLoqDK8
	 bzERl9pKUnnyetiISOh8xTxKLbwwV9sgueotKmjo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393682AbfBNQuo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:50:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:45054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfBNQuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 11:50:44 -0500
Received: from localhost.localdomain (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19347222DA;
        Thu, 14 Feb 2019 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550163043;
        bh=sReStVg5N7KR3VdZA/aJvnO+YS722gS1Z2H/eE8VpVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6x0VciH0A06MtHlcMZWv5x7XBH+P+4IDrXt09W1i5ipW8BRpFvdDCFFXDsYNGJ2b
         JgvS08nDc2XaHoXwH0GsFPoOn0HRUr2iDlUdVm7CWjIqOdgIy8WqMtZCD37OPo3hoM
         Qp8qqd0YckxQNcQPunEV/kkdr0dyuu3ThfHXjDvg=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 2/2] mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module
Date:   Thu, 14 Feb 2019 17:50:20 +0100
Message-Id: <c84626ec786d94c32e6745fa62b3353295d74bf8.1550162430.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550162430.git.lorenzo@kernel.org>
References: <cover.1550162430.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76x02_init_tx_queue and mt76x02_init_rx_queue in mt76
module in order to be reused adding support for mt7603 driver
and remove duplicated code.
Squash mt76x02_init_tx_queue and mt76x02_init_rx_queue in
mt76_dma_alloc_queue

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      |  9 ++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 +-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 32 ++++++++++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 38 -------------------
 4 files changed, 43 insertions(+), 40 deletions(-)

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
index 01f06b5766d7..e0524db171fc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -147,7 +147,9 @@ struct mt76_mcu_ops {
 struct mt76_queue_ops {
 	int (*init)(struct mt76_dev *dev);
 
-	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q);
+	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize,
+		     u32 ring_base);
 
 	int (*add_buf)(struct mt76_dev *dev, struct mt76_queue *q,
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index ecbdb4385885..ab9e58679833 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -203,6 +203,38 @@ static inline void mt76x02_irq_disable(struct mt76x02_dev *dev, u32 mask)
 	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
 }
 
+static inline int
+mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc)
+{
+	int err;
+
+	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
+			       MT_TX_RING_BASE);
+	if (err < 0)
+		return err;
+
+	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
+
+	return 0;
+}
+
+static inline int
+mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc, int bufsize)
+{
+	int err;
+
+	err = mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+			       MT_RX_RING_BASE);
+	if (err < 0)
+		return err;
+
+	mt76x02_irq_enable(dev, MT_INT_RX_DONE(idx));
+
+	return 0;
+}
+
 static inline bool
 mt76x02_wait_for_txrx_idle(struct mt76_dev *dev)
 {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index c86af8c85fd4..a7ba9f5528aa 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -151,44 +151,6 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 	spin_unlock_bh(&q->lock);
 }
 
-static int
-mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
-		      int idx, int n_desc)
-{
-	int ret;
-
-	q->regs = dev->mt76.mmio.regs + MT_TX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->hw_idx = idx;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
-
-	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
-
-	return 0;
-}
-
-static int
-mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
-		      int idx, int n_desc, int bufsize)
-{
-	int ret;
-
-	q->regs = dev->mt76.mmio.regs + MT_RX_RING_BASE + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->buf_size = bufsize;
-
-	ret = mt76_queue_alloc(dev, q);
-	if (ret)
-		return ret;
-
-	mt76x02_irq_enable(dev, MT_INT_RX_DONE(idx));
-
-	return 0;
-}
-
 static void mt76x02_process_tx_status_fifo(struct mt76x02_dev *dev)
 {
 	struct mt76x02_tx_status stat;
-- 
2.20.1

