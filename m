Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DEAC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 23:45:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00ACE222C9
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 23:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550101539;
	bh=Bh2Rh9Qn99qCGaXqaYREjxyp0NAUXoyromK0SVWdbco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wDtWLixv1mbQg3wi6xgPBkf7wqKXbKUfswP+IiV2nGavhOLtsKPHtZ4LhBmRFNzpU
	 vx5Qvj5ESrZ8DN//GuoKD/hcPXfa7ckH8+wbOFAmccYeW9mx4xyHjeejzdmAJZ8xHZ
	 UYGzyyy/aBRSdWM741zSEu4mN+4MaEoUK/6aGVVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732478AbfBMXpi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 18:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728665AbfBMXpi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 18:45:38 -0500
Received: from localhost.localdomain (unknown [151.66.10.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489722229F;
        Wed, 13 Feb 2019 23:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550101537;
        bh=Bh2Rh9Qn99qCGaXqaYREjxyp0NAUXoyromK0SVWdbco=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WBWOWW+GREXtROsS7MZKnsZoNmg6/VIuRx4kyc8OG34Wsyr2+NfzyM3OkjyH6KYTs
         qkX8rKfE9eRPDFyoQl6hDiHnOlpcnVTDHGd0XG8k8T31IEww+e1cGS0OKMONp6Pixo
         /ZL4b4jn/FInApZTxT41cKaigx9PscOQqIWq6VO4=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH 2/2] mt76: dma: move mt76x02_init_{tx,rx}_queue in mt76 module
Date:   Thu, 14 Feb 2019 00:44:59 +0100
Message-Id: <ba0b6ea3aa2d75df0f1ba14a1df9934331646245.1550099224.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550099224.git.lorenzo@kernel.org>
References: <cover.1550099224.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Move mt76x02_init_tx_queue and mt76x02_init_rx_queue in mt76
module in order to be reused adding support for mt7603 driver.
Squash mt76x02_init_tx_queue and mt76x02_init_rx_queue in
mt76_alloc_hw_queue

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 24 +++++++++++-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  5 ++-
 drivers/net/wireless/mediatek/mt76/mt76x02.h  | 18 +++++++++
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c | 38 -------------------
 4 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 6eedc0ec7661..420d09c1a06e 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -51,6 +51,28 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	return 0;
 }
 
+static int
+mt76_alloc_hw_queue(struct mt76_dev *dev, struct mt76_queue *q,
+		    int idx, int n_desc, int bufsize,
+		    u32 ring_base, u32 irq_addr,
+		    u32 irq_mask)
+{
+	int ret;
+
+	q->regs = dev->mmio.regs + ring_base + idx * MT_RING_SIZE;
+	q->ndesc = n_desc;
+	q->buf_size = bufsize;
+	q->hw_idx = idx;
+
+	ret = mt76_dma_alloc_queue(dev, q);
+	if (ret)
+		return ret;
+
+	mt76_irq_enable(dev, irq_addr, irq_mask);
+
+	return 0;
+}
+
 static int
 mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 		 struct mt76_queue_buf *buf, int nbufs, u32 info,
@@ -545,7 +567,7 @@ mt76_dma_init(struct mt76_dev *dev)
 
 static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
-	.alloc = mt76_dma_alloc_queue,
+	.alloc = mt76_alloc_hw_queue,
 	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index b54611f53605..5b6790b5e31e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -147,7 +147,10 @@ struct mt76_mcu_ops {
 struct mt76_queue_ops {
 	int (*init)(struct mt76_dev *dev);
 
-	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q);
+	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q,
+		     int idx, int n_desc, int bufsize,
+		     u32 ring_base, u32 irq_addr,
+		     u32 irq_mask);
 
 	int (*add_buf)(struct mt76_dev *dev, struct mt76_queue *q,
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02.h b/drivers/net/wireless/mediatek/mt76/mt76x02.h
index ecbdb4385885..d323aeb92424 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02.h
@@ -203,6 +203,24 @@ static inline void mt76x02_irq_disable(struct mt76x02_dev *dev, u32 mask)
 	mt76_set_irq_mask(&dev->mt76, MT_INT_MASK_CSR, mask, 0);
 }
 
+static inline int
+mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc)
+{
+	return mt76_queue_alloc(dev, q, idx, n_desc, 0,
+				MT_TX_RING_BASE, MT_INT_MASK_CSR,
+				MT_INT_TX_DONE(idx));
+}
+
+static inline int
+mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
+		      int idx, int n_desc, int bufsize)
+{
+	return mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+				MT_RX_RING_BASE, MT_INT_MASK_CSR,
+				MT_INT_RX_DONE(idx));
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

