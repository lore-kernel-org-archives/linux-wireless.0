Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86E5FC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A3F42085A
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 09:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551432152;
	bh=YF4V6Xmvf0nE9DLYeQb962gZ3BirBxp/zuWao9nyt2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dgruzmMDb4bsO8tBh2iiA40eExVqGq/jDN4ERDLG3AG4U32+aLjYImCt3ZVhM5r4x
	 uz7WIpOgOgayRd9706GjXqvQDKNBunMM6CxM35Jf7Bk0YZDI6TFbxNjVXmrI+JUuQb
	 /3Ju5mdE0u9UCpCtD9XnaE1Qbte74t1jfohkj3OU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbfCAJWb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 04:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:59296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfCAJWb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 04:22:31 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F216218AE;
        Fri,  1 Mar 2019 09:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551432147;
        bh=YF4V6Xmvf0nE9DLYeQb962gZ3BirBxp/zuWao9nyt2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CAycwnAnBz3oIjl4nkMB4Y5hzUD5SKn8Ykrs01S/GIFjUmc7r9skH7Ls9ejAp+B7G
         bjbuDxeGI3SHkGNSLvoHzAjiomyF4OsrkmU/fnaVeGwJwflWjrNztZHAVoyjK2+ZRq
         PJUvPC6ZsUp8fySDncDr5CIOikEwGq1V7oBNky00=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
        roychl666@gmail.com, lorenzo.bianconi@redhat.com
Subject: [RFC 2/2] mt76: introduce mt76_hw_queue data structure
Date:   Fri,  1 Mar 2019 10:22:04 +0100
Message-Id: <e42f2de79766a2bd507d66ea2dabb0e79a684450.1551431791.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551431791.git.lorenzo@kernel.org>
References: <cover.1551431791.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Introduce mt76_hw_queue data structure in order to support new
chipsets (mt7615) that have a shared hardware queue for all traffic
identifier. mt76_queue will be used to track outstanding packets

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  |   6 +-
 drivers/net/wireless/mediatek/mt76/dma.c      | 249 +++++++++---------
 drivers/net/wireless/mediatek/mt76/mac80211.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt76.h     |  34 ++-
 .../wireless/mediatek/mt76/mt7603/beacon.c    |  26 +-
 .../net/wireless/mediatek/mt76/mt7603/dma.c   |  21 +-
 .../net/wireless/mediatek/mt76/mt7603/mac.c   |  12 +-
 .../net/wireless/mediatek/mt76/mt7603/main.c  |   2 +-
 .../net/wireless/mediatek/mt76/mt76x02_mmio.c |  38 +--
 .../wireless/mediatek/mt76/mt76x02_usb_core.c |   3 +-
 .../net/wireless/mediatek/mt76/mt76x02_util.c |   2 +-
 drivers/net/wireless/mediatek/mt76/tx.c       |  50 ++--
 drivers/net/wireless/mediatek/mt76/usb.c      | 222 +++++++++-------
 13 files changed, 363 insertions(+), 306 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
index a5adf22c3ffa..52764732e0c5 100644
--- a/drivers/net/wireless/mediatek/mt76/debugfs.c
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -44,13 +44,15 @@ mt76_queues_read(struct seq_file *s, void *data)
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
 		struct mt76_queue *q = &dev->q_tx[i];
+		struct mt76_hw_queue *hwq = q->hwq;
 
-		if (!q->ndesc)
+		if (!hwq->ndesc)
 			continue;
 
 		seq_printf(s,
 			   "%d:	queued=%d head=%d tail=%d swq_queued=%d\n",
-			   i, q->queued, q->head, q->tail, q->swq_queued);
+			   i, hwq->queued, hwq->head, hwq->tail,
+			   q->swq_queued);
 	}
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index d2b7fa2c76d1..d43b9def3b89 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -20,46 +20,50 @@
 
 #define DMA_DUMMY_TXWI	((void *) ~0)
 
-static int
-mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q,
-		     int idx, int n_desc, int bufsize,
-		     u32 ring_base)
+static struct mt76_hw_queue *
+mt76_dma_alloc_queue(struct mt76_dev *dev, int idx, int n_desc,
+		     int bufsize, u32 ring_base)
 {
+	struct mt76_hw_queue *hwq;
 	int size;
 	int i;
 
-	spin_lock_init(&q->lock);
-	INIT_LIST_HEAD(&q->swq);
+	hwq = devm_kzalloc(dev->dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return ERR_PTR(-ENOMEM);
 
-	q->regs = dev->mmio.regs + ring_base + idx * MT_RING_SIZE;
-	q->ndesc = n_desc;
-	q->buf_size = bufsize;
-	q->hw_idx = idx;
+	spin_lock_init(&hwq->lock);
 
-	size = q->ndesc * sizeof(struct mt76_desc);
-	q->desc = dmam_alloc_coherent(dev->dev, size, &q->desc_dma, GFP_KERNEL);
-	if (!q->desc)
-		return -ENOMEM;
+	hwq->regs = dev->mmio.regs + ring_base + idx * MT_RING_SIZE;
+	hwq->ndesc = n_desc;
+	hwq->buf_size = bufsize;
+	hwq->hw_idx = idx;
 
-	size = q->ndesc * sizeof(*q->entry);
-	q->entry = devm_kzalloc(dev->dev, size, GFP_KERNEL);
-	if (!q->entry)
-		return -ENOMEM;
+	size = hwq->ndesc * sizeof(struct mt76_desc);
+	hwq->desc = dmam_alloc_coherent(dev->dev, size, &hwq->desc_dma,
+					GFP_KERNEL);
+	if (!hwq->desc)
+		return ERR_PTR(-ENOMEM);
+
+	size = hwq->ndesc * sizeof(*hwq->entry);
+	hwq->entry = devm_kzalloc(dev->dev, size, GFP_KERNEL);
+	if (!hwq->entry)
+		return ERR_PTR(-ENOMEM);
 
 	/* clear descriptors */
-	for (i = 0; i < q->ndesc; i++)
-		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+	for (i = 0; i < hwq->ndesc; i++)
+		hwq->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
-	iowrite32(q->desc_dma, &q->regs->desc_base);
-	iowrite32(0, &q->regs->cpu_idx);
-	iowrite32(0, &q->regs->dma_idx);
-	iowrite32(q->ndesc, &q->regs->ring_size);
+	iowrite32(hwq->desc_dma, &hwq->regs->desc_base);
+	iowrite32(0, &hwq->regs->cpu_idx);
+	iowrite32(0, &hwq->regs->dma_idx);
+	iowrite32(hwq->ndesc, &hwq->regs->ring_size);
 
-	return 0;
+	return hwq;
 }
 
 static int
-mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
+mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_hw_queue *hwq,
 		 struct mt76_queue_buf *buf, int nbufs, u32 info,
 		 struct sk_buff *skb, void *txwi)
 {
@@ -68,7 +72,7 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 	int i, idx = -1;
 
 	if (txwi)
-		q->entry[q->head].txwi = DMA_DUMMY_TXWI;
+		hwq->entry[hwq->head].txwi = DMA_DUMMY_TXWI;
 
 	for (i = 0; i < nbufs; i += 2, buf += 2) {
 		u32 buf0 = buf[0].addr, buf1 = 0;
@@ -84,21 +88,21 @@ mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
 		else if (i == nbufs - 2)
 			ctrl |= MT_DMA_CTL_LAST_SEC1;
 
-		idx = q->head;
-		q->head = (q->head + 1) % q->ndesc;
+		idx = hwq->head;
+		hwq->head = (hwq->head + 1) % hwq->ndesc;
 
-		desc = &q->desc[idx];
+		desc = &hwq->desc[idx];
 
 		WRITE_ONCE(desc->buf0, cpu_to_le32(buf0));
 		WRITE_ONCE(desc->buf1, cpu_to_le32(buf1));
 		WRITE_ONCE(desc->info, cpu_to_le32(info));
 		WRITE_ONCE(desc->ctrl, cpu_to_le32(ctrl));
 
-		q->queued++;
+		hwq->queued++;
 	}
 
-	q->entry[idx].txwi = txwi;
-	q->entry[idx].skb = skb;
+	hwq->entry[idx].txwi = txwi;
+	hwq->entry[idx].skb = skb;
 
 	return idx;
 }
@@ -107,12 +111,13 @@ static void
 mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 			struct mt76_queue_entry *prev_e)
 {
-	struct mt76_queue_entry *e = &q->entry[idx];
-	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
+	struct mt76_hw_queue *hwq = q->hwq;
+	struct mt76_queue_entry *e = &hwq->entry[idx];
+	__le32 __ctrl = READ_ONCE(hwq->desc[idx].ctrl);
 	u32 ctrl = le32_to_cpu(__ctrl);
 
 	if (!e->txwi || !e->skb) {
-		__le32 addr = READ_ONCE(q->desc[idx].buf0);
+		__le32 addr = READ_ONCE(hwq->desc[idx].buf0);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
 
 		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
@@ -120,7 +125,7 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 	}
 
 	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
-		__le32 addr = READ_ONCE(q->desc[idx].buf1);
+		__le32 addr = READ_ONCE(hwq->desc[idx].buf1);
 		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
 
 		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
@@ -135,42 +140,43 @@ mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 }
 
 static void
-mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
+mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_hw_queue *hwq)
 {
-	q->head = ioread32(&q->regs->dma_idx);
-	q->tail = q->head;
-	iowrite32(q->head, &q->regs->cpu_idx);
+	hwq->head = ioread32(&hwq->regs->dma_idx);
+	hwq->tail = hwq->head;
+	iowrite32(hwq->head, &hwq->regs->cpu_idx);
 }
 
 static void
 mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 {
 	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_hw_queue *hwq = q->hwq;
 	struct mt76_queue_entry entry;
 	bool wake = false;
 	int last;
 
-	if (!q->ndesc)
+	if (!hwq->ndesc)
 		return;
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 	if (flush)
 		last = -1;
 	else
-		last = ioread32(&q->regs->dma_idx);
+		last = ioread32(&hwq->regs->dma_idx);
 
-	while (q->queued && q->tail != last) {
-		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
+	while (hwq->queued && hwq->tail != last) {
+		mt76_dma_tx_cleanup_idx(dev, q, hwq->tail, &entry);
 		if (entry.schedule)
-			q->swq_queued--;
+			dev->q_tx[entry.qid].swq_queued--;
 
-		q->tail = (q->tail + 1) % q->ndesc;
-		q->queued--;
+		hwq->tail = (hwq->tail + 1) % hwq->ndesc;
+		hwq->queued--;
 
 		if (entry.skb) {
-			spin_unlock_bh(&q->lock);
+			spin_unlock_bh(&hwq->lock);
 			dev->drv->tx_complete_skb(dev, q, &entry, flush);
-			spin_lock_bh(&q->lock);
+			spin_lock_bh(&hwq->lock);
 		}
 
 		if (entry.txwi) {
@@ -178,35 +184,35 @@ mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
 			wake = !flush;
 		}
 
-		if (!flush && q->tail == last)
-			last = ioread32(&q->regs->dma_idx);
+		if (!flush && hwq->tail == last)
+			last = ioread32(&hwq->regs->dma_idx);
 	}
 
 	if (!flush)
 		mt76_txq_schedule(dev, q);
 	else
-		mt76_dma_sync_idx(dev, q);
+		mt76_dma_sync_idx(dev, hwq);
 
-	wake = wake && qid < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+	wake = wake && qid < IEEE80211_NUM_ACS && hwq->queued < hwq->ndesc - 8;
 
-	if (!q->queued)
+	if (!hwq->queued)
 		wake_up(&dev->tx_wait);
 
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&hwq->lock);
 
 	if (wake)
 		ieee80211_wake_queue(dev->hw, qid);
 }
 
 static void *
-mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
-		 int *len, u32 *info, bool *more)
+mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_hw_queue *hwq,
+		 int idx, int *len, u32 *info, bool *more)
 {
-	struct mt76_queue_entry *e = &q->entry[idx];
-	struct mt76_desc *desc = &q->desc[idx];
+	struct mt76_queue_entry *e = &hwq->entry[idx];
+	struct mt76_desc *desc = &hwq->desc[idx];
 	dma_addr_t buf_addr;
 	void *buf = e->buf;
-	int buf_len = SKB_WITH_OVERHEAD(q->buf_size);
+	int buf_len = SKB_WITH_OVERHEAD(hwq->buf_size);
 
 	buf_addr = le32_to_cpu(READ_ONCE(desc->buf0));
 	if (len) {
@@ -225,28 +231,29 @@ mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
 }
 
 static void *
-mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
-		 int *len, u32 *info, bool *more)
+mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_hw_queue *hwq,
+		 bool flush, int *len, u32 *info, bool *more)
 {
-	int idx = q->tail;
+	int idx = hwq->tail;
 
 	*more = false;
-	if (!q->queued)
+	if (!hwq->queued)
 		return NULL;
 
-	if (!flush && !(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_DMA_DONE)))
+	if (!flush && !(hwq->desc[idx].ctrl &
+			cpu_to_le32(MT_DMA_CTL_DMA_DONE)))
 		return NULL;
 
-	q->tail = (q->tail + 1) % q->ndesc;
-	q->queued--;
+	hwq->tail = (hwq->tail + 1) % hwq->ndesc;
+	hwq->queued--;
 
-	return mt76_dma_get_buf(dev, q, idx, len, info, more);
+	return mt76_dma_get_buf(dev, hwq, idx, len, info, more);
 }
 
 static void
-mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
+mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_hw_queue *hwq)
 {
-	iowrite32(q->head, &q->regs->cpu_idx);
+	iowrite32(hwq->head, &hwq->regs->cpu_idx);
 }
 
 static int
@@ -254,6 +261,7 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 			  struct sk_buff *skb, u32 tx_info)
 {
 	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_hw_queue *hwq = q->hwq;
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 
@@ -265,10 +273,10 @@ mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
 	buf.addr = addr;
 	buf.len = skb->len;
 
-	spin_lock_bh(&q->lock);
-	mt76_dma_add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
-	mt76_dma_kick_queue(dev, q);
-	spin_unlock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
+	mt76_dma_add_buf(dev, hwq, &buf, 1, tx_info, skb, NULL);
+	mt76_dma_kick_queue(dev, hwq);
+	spin_unlock_bh(&hwq->lock);
 
 	return 0;
 }
@@ -277,6 +285,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
 {
+	struct mt76_hw_queue *hwq = q->hwq;
 	struct mt76_queue_entry e;
 	struct mt76_txwi_cache *t;
 	struct mt76_queue_buf buf[32];
@@ -328,10 +337,10 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		buf[n++].len = iter->len;
 	}
 
-	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
+	if (hwq->queued + (n + 1) / 2 >= hwq->ndesc - 1)
 		goto unmap;
 
-	return mt76_dma_add_buf(dev, q, buf, n, tx_info, skb, t);
+	return mt76_dma_add_buf(dev, hwq, buf, n, tx_info, skb, t);
 
 unmap:
 	ret = -ENOMEM;
@@ -349,21 +358,21 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 EXPORT_SYMBOL_GPL(mt76_dma_tx_queue_skb);
 
 static int
-mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
+mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_hw_queue *hwq)
 {
 	dma_addr_t addr;
 	void *buf;
 	int frames = 0;
-	int len = SKB_WITH_OVERHEAD(q->buf_size);
-	int offset = q->buf_offset;
+	int len = SKB_WITH_OVERHEAD(hwq->buf_size);
+	int offset = hwq->buf_offset;
 	int idx;
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 
-	while (q->queued < q->ndesc - 1) {
+	while (hwq->queued < hwq->ndesc - 1) {
 		struct mt76_queue_buf qbuf;
 
-		buf = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+		buf = page_frag_alloc(&hwq->rx_page, hwq->buf_size, GFP_ATOMIC);
 		if (!buf)
 			break;
 
@@ -375,55 +384,55 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 
 		qbuf.addr = addr + offset;
 		qbuf.len = len - offset;
-		idx = mt76_dma_add_buf(dev, q, &qbuf, 1, 0, buf, NULL);
+		idx = mt76_dma_add_buf(dev, hwq, &qbuf, 1, 0, buf, NULL);
 		frames++;
 	}
 
 	if (frames)
-		mt76_dma_kick_queue(dev, q);
+		mt76_dma_kick_queue(dev, hwq);
 
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&hwq->lock);
 
 	return frames;
 }
 
 static void
-mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
+mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_hw_queue *hwq)
 {
 	struct page *page;
 	void *buf;
 	bool more;
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 	do {
-		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
+		buf = mt76_dma_dequeue(dev, hwq, true, NULL, NULL, &more);
 		if (!buf)
 			break;
 
 		skb_free_frag(buf);
 	} while (1);
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&hwq->lock);
 
-	if (!q->rx_page.va)
+	if (!hwq->rx_page.va)
 		return;
 
-	page = virt_to_page(q->rx_page.va);
-	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
-	memset(&q->rx_page, 0, sizeof(q->rx_page));
+	page = virt_to_page(hwq->rx_page.va);
+	__page_frag_cache_drain(page, hwq->rx_page.pagecnt_bias);
+	memset(&hwq->rx_page, 0, sizeof(hwq->rx_page));
 }
 
 static void
 mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 {
-	struct mt76_queue *q = &dev->q_rx[qid];
+	struct mt76_hw_queue *hwq = dev->q_rx[qid].hwq;
 	int i;
 
-	for (i = 0; i < q->ndesc; i++)
-		q->desc[i].ctrl &= ~cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+	for (i = 0; i < hwq->ndesc; i++)
+		hwq->desc[i].ctrl &= ~cpu_to_le32(MT_DMA_CTL_DMA_DONE);
 
-	mt76_dma_rx_cleanup(dev, q);
-	mt76_dma_sync_idx(dev, q);
-	mt76_dma_rx_fill(dev, q);
+	mt76_dma_rx_cleanup(dev, hwq);
+	mt76_dma_sync_idx(dev, hwq);
+	mt76_dma_rx_fill(dev, hwq);
 }
 
 static void
@@ -432,22 +441,24 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 {
 	struct page *page = virt_to_head_page(data);
 	int offset = data - page_address(page);
-	struct sk_buff *skb = q->rx_head;
+	struct mt76_hw_queue *hwq = q->hwq;
+	struct sk_buff *skb = hwq->rx_head;
 
-	offset += q->buf_offset;
+	offset += hwq->buf_offset;
 	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page, offset, len,
-			q->buf_size);
+			hwq->buf_size);
 
 	if (more)
 		return;
 
-	q->rx_head = NULL;
+	hwq->rx_head = NULL;
 	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
 }
 
 static int
 mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 {
+	struct mt76_hw_queue *hwq = q->hwq;
 	int len, data_len, done = 0;
 	struct sk_buff *skb;
 	unsigned char *data;
@@ -456,34 +467,34 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 	while (done < budget) {
 		u32 info;
 
-		data = mt76_dma_dequeue(dev, q, false, &len, &info, &more);
+		data = mt76_dma_dequeue(dev, hwq, false, &len, &info, &more);
 		if (!data)
 			break;
 
-		if (q->rx_head)
-			data_len = q->buf_size;
+		if (hwq->rx_head)
+			data_len = hwq->buf_size;
 		else
-			data_len = SKB_WITH_OVERHEAD(q->buf_size);
+			data_len = SKB_WITH_OVERHEAD(hwq->buf_size);
 
-		if (data_len < len + q->buf_offset) {
-			dev_kfree_skb(q->rx_head);
-			q->rx_head = NULL;
+		if (data_len < len + hwq->buf_offset) {
+			dev_kfree_skb(hwq->rx_head);
+			hwq->rx_head = NULL;
 
 			skb_free_frag(data);
 			continue;
 		}
 
-		if (q->rx_head) {
+		if (hwq->rx_head) {
 			mt76_add_fragment(dev, q, data, len, more);
 			continue;
 		}
 
-		skb = build_skb(data, q->buf_size);
+		skb = build_skb(data, hwq->buf_size);
 		if (!skb) {
 			skb_free_frag(data);
 			continue;
 		}
-		skb_reserve(skb, q->buf_offset);
+		skb_reserve(skb, hwq->buf_offset);
 
 		if (q == &dev->q_rx[MT_RXQ_MCU]) {
 			u32 *rxfce = (u32 *) skb->cb;
@@ -494,14 +505,14 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 		done++;
 
 		if (more) {
-			q->rx_head = skb;
+			hwq->rx_head = skb;
 			continue;
 		}
 
 		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
 	}
 
-	mt76_dma_rx_fill(dev, q);
+	mt76_dma_rx_fill(dev, hwq);
 	return done;
 }
 
@@ -542,7 +553,7 @@ mt76_dma_init(struct mt76_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++) {
 		netif_napi_add(&dev->napi_dev, &dev->napi[i], mt76_dma_rx_poll,
 			       64);
-		mt76_dma_rx_fill(dev, &dev->q_rx[i]);
+		mt76_dma_rx_fill(dev, dev->q_rx[i].hwq);
 		skb_queue_head_init(&dev->rx_skb[i]);
 		napi_enable(&dev->napi[i]);
 	}
@@ -575,7 +586,7 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++) {
 		netif_napi_del(&dev->napi[i]);
-		mt76_dma_rx_cleanup(dev, &dev->q_rx[i]);
+		mt76_dma_rx_cleanup(dev, dev->q_rx[i].hwq);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76_dma_cleanup);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index a033745adb2f..b267abcb47f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -386,10 +386,12 @@ EXPORT_SYMBOL_GPL(mt76_rx);
 
 static bool mt76_has_tx_pending(struct mt76_dev *dev)
 {
+	struct mt76_hw_queue *hwq;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
-		if (dev->q_tx[i].queued)
+		hwq = dev->q_tx[i].hwq;
+		if (hwq && hwq->queued)
 			return true;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5a87bb03cf05..8d97c575b967 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -100,6 +100,7 @@ struct mt76_queue_entry {
 		struct mt76_txwi_cache *txwi;
 		struct mt76u_buf ubuf;
 	};
+	enum mt76_txq_id qid;
 	bool schedule;
 };
 
@@ -110,30 +111,37 @@ struct mt76_queue_regs {
 	u32 dma_idx;
 } __packed __aligned(4);
 
-struct mt76_queue {
+struct mt76_hw_queue {
 	struct mt76_queue_regs __iomem *regs;
 
-	spinlock_t lock;
 	struct mt76_queue_entry *entry;
 	struct mt76_desc *desc;
+	spinlock_t lock;
 
-	struct list_head swq;
-	int swq_queued;
+	int queued;
+	int ndesc;
 
 	u16 first;
 	u16 head;
 	u16 tail;
-	int ndesc;
-	int queued;
-	int buf_size;
 
+	dma_addr_t desc_dma;
+
+	int buf_size;
 	u8 buf_offset;
+
 	u8 hw_idx;
 
-	dma_addr_t desc_dma;
-	struct sk_buff *rx_head;
 	struct page_frag_cache rx_page;
 	spinlock_t rx_page_lock;
+	struct sk_buff *rx_head;
+};
+
+struct mt76_queue {
+	struct mt76_hw_queue *hwq;
+
+	struct list_head swq;
+	int swq_queued;
 };
 
 struct mt76_mcu_ops {
@@ -148,9 +156,9 @@ struct mt76_mcu_ops {
 struct mt76_queue_ops {
 	int (*init)(struct mt76_dev *dev);
 
-	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q,
-		     int idx, int n_desc, int bufsize,
-		     u32 ring_base);
+	struct mt76_hw_queue *(*alloc)(struct mt76_dev *dev,
+				       int idx, int n_desc, int bufsize,
+				       u32 ring_base);
 
 	int (*add_buf)(struct mt76_dev *dev, struct mt76_queue *q,
 		       struct mt76_queue_buf *buf, int nbufs, u32 info,
@@ -171,7 +179,7 @@ struct mt76_queue_ops {
 	void (*tx_cleanup)(struct mt76_dev *dev, enum mt76_txq_id qid,
 			   bool flush);
 
-	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
+	void (*kick)(struct mt76_dev *dev, struct mt76_hw_queue *hwq);
 };
 
 enum mt76_wcid_flags {
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
index afcd86f735b4..438bb3cd55a5 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/beacon.c
@@ -30,7 +30,7 @@ mt7603_update_beacon_iter(void *priv, u8 *mac, struct ieee80211_vif *vif)
 	mt76_wr(dev, MT_DMA_FQCR0, MT_DMA_FQCR0_BUSY |
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_WCID, mvif->sta.wcid.idx) |
 		FIELD_PREP(MT_DMA_FQCR0_TARGET_QID,
-			   dev->mt76.q_tx[MT_TXQ_CAB].hw_idx) |
+			   dev->mt76.q_tx[MT_TXQ_CAB].hwq->hw_idx) |
 		FIELD_PREP(MT_DMA_FQCR0_DEST_PORT_ID, 3) |
 		FIELD_PREP(MT_DMA_FQCR0_DEST_QUEUE_ID, 8));
 
@@ -68,7 +68,7 @@ mt7603_add_buffered_bc(void *priv, u8 *mac, struct ieee80211_vif *vif)
 void mt7603_pre_tbtt_tasklet(unsigned long arg)
 {
 	struct mt7603_dev *dev = (struct mt7603_dev *)arg;
-	struct mt76_queue *q;
+	struct mt76_hw_queue *hwq;
 	struct beacon_bc_data data = {};
 	struct sk_buff *skb;
 	int i, nframes;
@@ -76,13 +76,13 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 	data.dev = dev;
 	__skb_queue_head_init(&data.q);
 
-	q = &dev->mt76.q_tx[MT_TXQ_BEACON];
-	spin_lock_bh(&q->lock);
+	hwq = dev->mt76.q_tx[MT_TXQ_BEACON].hwq;
+	spin_lock_bh(&hwq->lock);
 	ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
 		IEEE80211_IFACE_ITER_RESUME_ALL,
 		mt7603_update_beacon_iter, dev);
-	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	mt76_queue_kick(dev, hwq);
+	spin_unlock_bh(&hwq->lock);
 
 	/* Flush all previous CAB queue packets */
 	mt76_wr(dev, MT_WF_ARB_CAB_FLUSH, GENMASK(30, 16) | BIT(0));
@@ -93,7 +93,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 	if (dev->mt76.csa_complete)
 		goto out;
 
-	q = &dev->mt76.q_tx[MT_TXQ_CAB];
+	hwq = dev->mt76.q_tx[MT_TXQ_CAB].hwq;
 	do {
 		nframes = skb_queue_len(&data.q);
 		ieee80211_iterate_active_interfaces_atomic(mt76_hw(dev),
@@ -112,17 +112,17 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 		mt76_skb_set_moredata(data.tail[i], false);
 	}
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
 		struct mt7603_vif *mvif = (struct mt7603_vif *)vif->drv_priv;
 
-		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->sta.wcid,
-				      NULL);
+		mt76_dma_tx_queue_skb(&dev->mt76, &dev->mt76.q_tx[MT_TXQ_CAB],
+				      skb, &mvif->sta.wcid, NULL);
 	}
-	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
+	mt76_queue_kick(dev, hwq);
+	spin_unlock_bh(&hwq->lock);
 
 	for (i = 0; i < ARRAY_SIZE(data.count); i++)
 		mt76_wr(dev, MT_WF_ARB_CAB_COUNT_B0_REG(i),
@@ -135,7 +135,7 @@ void mt7603_pre_tbtt_tasklet(unsigned long arg)
 
 out:
 	mt76_queue_tx_cleanup(dev, MT_TXQ_BEACON, false);
-	if (dev->mt76.q_tx[MT_TXQ_BEACON].queued >
+	if (dev->mt76.q_tx[MT_TXQ_BEACON].hwq->queued >
 	    __sw_hweight8(dev->beacon_mask))
 		dev->beacon_check++;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
index 5067c49142f7..d0bba87a7d13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/dma.c
@@ -8,12 +8,14 @@ static int
 mt7603_init_tx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc)
 {
-	int err;
+	struct mt76_hw_queue *hwq;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
-			       MT_TX_RING_BASE);
-	if (err < 0)
-		return err;
+	hwq = mt76_queue_alloc(dev, idx, n_desc, 0, MT_TX_RING_BASE);
+	if (IS_ERR(hwq))
+		return PTR_ERR(hwq);
+
+	INIT_LIST_HEAD(&q->swq);
+	q->hwq = hwq;
 
 	mt7603_irq_enable(dev, MT_INT_TX_DONE(idx));
 
@@ -103,13 +105,14 @@ static int
 mt7603_init_rx_queue(struct mt7603_dev *dev, struct mt76_queue *q,
 		     int idx, int n_desc, int bufsize)
 {
-	int err;
+	struct mt76_hw_queue *hwq;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+	hwq = mt76_queue_alloc(dev, idx, n_desc, bufsize,
 			       MT_RX_RING_BASE);
-	if (err < 0)
-		return err;
+	if (IS_ERR(hwq))
+		return PTR_ERR(hwq);
 
+	q->hwq = hwq;
 	mt7603_irq_enable(dev, MT_INT_RX_DONE(idx));
 
 	return 0;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index 0a0115861b51..35e4f202580e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -860,7 +860,7 @@ mt7603_mac_write_txwi(struct mt7603_dev *dev, __le32 *txwi,
 	frame_subtype = (fc & IEEE80211_FCTL_STYPE) >> 4;
 
 	val = FIELD_PREP(MT_TXD0_TX_BYTES, skb->len + MT_TXD_SIZE) |
-	      FIELD_PREP(MT_TXD0_Q_IDX, q->hw_idx);
+	      FIELD_PREP(MT_TXD0_Q_IDX, q->hwq->hw_idx);
 	txwi[0] = cpu_to_le32(val);
 
 	val = MT_TXD1_LONG_FORMAT |
@@ -1405,22 +1405,22 @@ static bool mt7603_tx_dma_busy(struct mt7603_dev *dev)
 
 static bool mt7603_tx_hang(struct mt7603_dev *dev)
 {
-	struct mt76_queue *q;
+	struct mt76_hw_queue *hwq;
 	u32 dma_idx, prev_dma_idx;
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		q = &dev->mt76.q_tx[i];
+		hwq = dev->mt76.q_tx[i].hwq;
 
-		if (!q->queued)
+		if (!hwq->queued)
 			continue;
 
 		prev_dma_idx = dev->tx_dma_idx[i];
-		dma_idx = ioread32(&q->regs->dma_idx);
+		dma_idx = ioread32(&hwq->regs->dma_idx);
 		dev->tx_dma_idx[i] = dma_idx;
 
 		if (dma_idx == prev_dma_idx &&
-		    dma_idx != ioread32(&q->regs->cpu_idx))
+		    dma_idx != ioread32(&hwq->regs->cpu_idx))
 			break;
 	}
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/main.c b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
index b10775ed92e6..124a9bd1d4a9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/main.c
@@ -476,7 +476,7 @@ mt7603_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif, u16 queue,
 	u16 cw_max = (1 << 10) - 1;
 	u32 val;
 
-	queue = dev->mt76.q_tx[queue].hw_idx;
+	queue = dev->mt76.q_tx[queue].hwq->hw_idx;
 
 	if (params->cw_min)
 		cw_min = params->cw_min;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 1a7926de1dec..5fecfc0062bd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -139,7 +139,7 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		mt76_skb_set_moredata(data.tail[i], false);
 	}
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&q->hwq->lock);
 	while ((skb = __skb_dequeue(&data.q)) != NULL) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 		struct ieee80211_vif *vif = info->control.vif;
@@ -148,19 +148,21 @@ static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
 		mt76_dma_tx_queue_skb(&dev->mt76, q, skb, &mvif->group_wcid,
 				      NULL);
 	}
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&q->hwq->lock);
 }
 
 static int
 mt76x02_init_tx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc)
 {
-	int err;
+	struct mt76_hw_queue *hwq;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, 0,
-			       MT_TX_RING_BASE);
-	if (err < 0)
-		return err;
+	hwq = mt76_queue_alloc(dev, idx, n_desc, 0, MT_TX_RING_BASE);
+	if (IS_ERR(hwq))
+		return PTR_ERR(hwq);
+
+	INIT_LIST_HEAD(&q->swq);
+	q->hwq = hwq;
 
 	mt76x02_irq_enable(dev, MT_INT_TX_DONE(idx));
 
@@ -171,13 +173,14 @@ static int
 mt76x02_init_rx_queue(struct mt76x02_dev *dev, struct mt76_queue *q,
 		      int idx, int n_desc, int bufsize)
 {
-	int err;
+	struct mt76_hw_queue *hwq;
 
-	err = mt76_queue_alloc(dev, q, idx, n_desc, bufsize,
+	hwq = mt76_queue_alloc(dev, idx, n_desc, bufsize,
 			       MT_RX_RING_BASE);
-	if (err < 0)
-		return err;
+	if (IS_ERR(hwq))
+		return PTR_ERR(hwq);
 
+	q->hwq = hwq;
 	mt76x02_irq_enable(dev, MT_INT_RX_DONE(idx));
 
 	return 0;
@@ -255,12 +258,13 @@ int mt76x02_dma_init(struct mt76x02_dev *dev)
 		return ret;
 
 	q = &dev->mt76.q_rx[MT_RXQ_MAIN];
-	q->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
 	ret = mt76x02_init_rx_queue(dev, q, 0, MT76X02_RX_RING_SIZE,
 				    MT_RX_BUF_SIZE);
 	if (ret)
 		return ret;
 
+	q->hwq->buf_offset = MT_RX_HEADROOM - sizeof(struct mt76x02_rxwi);
+
 	return mt76_init_queues(dev);
 }
 EXPORT_SYMBOL_GPL(mt76x02_dma_init);
@@ -312,7 +316,7 @@ irqreturn_t mt76x02_irq_handler(int irq, void *dev_instance)
 		if (dev->mt76.csa_complete)
 			mt76_csa_finish(&dev->mt76);
 		else
-			mt76_queue_kick(dev, &dev->mt76.q_tx[MT_TXQ_PSD]);
+			mt76_queue_kick(dev, dev->mt76.q_tx[MT_TXQ_PSD].hwq);
 	}
 
 	if (intr & MT_INT_TX_STAT) {
@@ -380,17 +384,17 @@ EXPORT_SYMBOL_GPL(mt76x02_mac_start);
 static bool mt76x02_tx_hang(struct mt76x02_dev *dev)
 {
 	u32 dma_idx, prev_dma_idx;
-	struct mt76_queue *q;
+	struct mt76_hw_queue *hwq;
 	int i;
 
 	for (i = 0; i < 4; i++) {
-		q = &dev->mt76.q_tx[i];
+		hwq = dev->mt76.q_tx[i].hwq;
 
-		if (!q->queued)
+		if (!hwq->queued)
 			continue;
 
 		prev_dma_idx = dev->mt76.tx_dma_idx[i];
-		dma_idx = ioread32(&q->regs->dma_idx);
+		dma_idx = ioread32(&hwq->regs->dma_idx);
 		dev->mt76.tx_dma_idx[i] = dma_idx;
 
 		if (prev_dma_idx == dma_idx)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
index 43f07461c8d3..d8fc7b29e85f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_core.c
@@ -91,7 +91,8 @@ int mt76x02u_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 	pid = mt76_tx_status_skb_add(mdev, wcid, skb);
 	txwi->pktid = pid;
 
-	if (pid >= MT_PACKET_ID_FIRST || q2ep(q->hw_idx) == MT_EP_OUT_HCCA)
+	if (pid >= MT_PACKET_ID_FIRST ||
+	    q2ep(q->hwq->hw_idx) == MT_EP_OUT_HCCA)
 		qsel = MT_QSEL_MGMT;
 	else
 		qsel = MT_QSEL_EDCA;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index a48c261b0c63..d7f4f07f0a09 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -459,7 +459,7 @@ int mt76x02_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	u8 cw_min = 5, cw_max = 10, qid;
 	u32 val;
 
-	qid = dev->mt76.q_tx[queue].hw_idx;
+	qid = dev->mt76.q_tx[queue].hwq->hw_idx;
 
 	if (params->cw_min)
 		cw_min = fls(params->cw_min);
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 8babda95d283..698c302b4499 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -258,8 +258,9 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct mt76_queue *q;
 	int qid = skb_get_queue_mapping(skb);
+	struct mt76_hw_queue *hwq;
+	struct mt76_queue *q;
 
 	if (WARN_ON(qid >= MT_TXQ_PSD)) {
 		qid = MT_TXQ_BE;
@@ -284,14 +285,15 @@ mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
 	}
 
 	q = &dev->q_tx[qid];
+	hwq = q->hwq;
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 	dev->queue_ops->tx_queue_skb(dev, q, skb, wcid, sta);
-	dev->queue_ops->kick(dev, q);
+	dev->queue_ops->kick(dev, hwq);
 
-	if (q->queued > q->ndesc - 8)
+	if (hwq->queued > hwq->ndesc - 8)
 		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&hwq->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_tx);
 
@@ -343,10 +345,10 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 {
 	struct mt76_dev *dev = hw->priv;
 	struct sk_buff *last_skb = NULL;
-	struct mt76_queue *q = &dev->q_tx[MT_TXQ_PSD];
+	struct mt76_hw_queue *hwq = dev->q_tx[MT_TXQ_PSD].hwq;
 	int i;
 
-	spin_lock_bh(&q->lock);
+	spin_lock_bh(&hwq->lock);
 	for (i = 0; tids && nframes; i++, tids >>= 1) {
 		struct ieee80211_txq *txq = sta->txq[i];
 		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
@@ -373,9 +375,9 @@ mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
 
 	if (last_skb) {
 		mt76_queue_ps_skb(dev, sta, last_skb, true);
-		dev->queue_ops->kick(dev, q);
+		dev->queue_ops->kick(dev, hwq);
 	}
-	spin_unlock_bh(&q->lock);
+	spin_unlock_bh(&hwq->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_release_buffered_frames);
 
@@ -461,11 +463,12 @@ mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *q,
 	} while (n_frames < limit);
 
 	if (!probe) {
+		q->hwq->entry[idx].qid = q - dev->q_tx;
+		q->hwq->entry[idx].schedule = true;
 		q->swq_queued++;
-		q->entry[idx].schedule = true;
 	}
 
-	dev->queue_ops->kick(dev, q);
+	dev->queue_ops->kick(dev, q->hwq);
 
 	return n_frames;
 }
@@ -495,9 +498,9 @@ mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *q)
 			u8 tid = txq->tid;
 
 			mtxq->send_bar = false;
-			spin_unlock_bh(&q->lock);
+			spin_unlock_bh(&q->hwq->lock);
 			ieee80211_send_bar(vif, sta->addr, tid, agg_ssn);
-			spin_lock_bh(&q->lock);
+			spin_lock_bh(&q->hwq->lock);
 			goto restart;
 		}
 
@@ -541,9 +544,9 @@ void mt76_txq_schedule_all(struct mt76_dev *dev)
 	for (i = 0; i <= MT_TXQ_BK; i++) {
 		struct mt76_queue *q = &dev->q_tx[i];
 
-		spin_lock_bh(&q->lock);
+		spin_lock_bh(&q->hwq->lock);
 		mt76_txq_schedule(dev, q);
-		spin_unlock_bh(&q->lock);
+		spin_unlock_bh(&q->hwq->lock);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76_txq_schedule_all);
@@ -555,18 +558,20 @@ void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
 
 	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
 		struct ieee80211_txq *txq = sta->txq[i];
+		struct mt76_hw_queue *hwq;
 		struct mt76_txq *mtxq;
 
 		if (!txq)
 			continue;
 
 		mtxq = (struct mt76_txq *)txq->drv_priv;
+		hwq = mtxq->q->hwq;
 
-		spin_lock_bh(&mtxq->q->lock);
+		spin_lock_bh(&hwq->lock);
 		mtxq->send_bar = mtxq->aggr && send_bar;
 		if (!list_empty(&mtxq->list))
 			list_del_init(&mtxq->list);
-		spin_unlock_bh(&mtxq->q->lock);
+		spin_unlock_bh(&hwq->lock);
 	}
 }
 EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
@@ -574,18 +579,20 @@ EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
 void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
 {
 	struct mt76_txq *mtxq = (struct mt76_txq *)txq->drv_priv;
+	struct mt76_hw_queue *hwq = mtxq->q->hwq;
 	struct mt76_dev *dev = hw->priv;
 
-	spin_lock_bh(&mtxq->q->lock);
+	spin_lock_bh(&hwq->lock);
 	if (list_empty(&mtxq->list))
 		list_add_tail(&mtxq->list, &mtxq->q->swq);
 	mt76_txq_schedule(dev, mtxq->q);
-	spin_unlock_bh(&mtxq->q->lock);
+	spin_unlock_bh(&hwq->lock);
 }
 EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
 
 void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 {
+	struct mt76_hw_queue *hwq;
 	struct mt76_txq *mtxq;
 	struct sk_buff *skb;
 
@@ -593,11 +600,12 @@ void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
 		return;
 
 	mtxq = (struct mt76_txq *)txq->drv_priv;
+	hwq = mtxq->q->hwq;
 
-	spin_lock_bh(&mtxq->q->lock);
+	spin_lock_bh(&hwq->lock);
 	if (!list_empty(&mtxq->list))
 		list_del_init(&mtxq->list);
-	spin_unlock_bh(&mtxq->q->lock);
+	spin_unlock_bh(&hwq->lock);
 
 	while ((skb = skb_dequeue(&mtxq->retry_q)) != NULL)
 		ieee80211_free_txskb(dev->hw, skb);
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ae6ada370597..b1c6ed34ad41 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -288,17 +288,17 @@ static int
 mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		 int nsgs, int len, int sglen)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	struct urb *urb = buf->urb;
 	int i;
 
-	spin_lock_bh(&q->rx_page_lock);
+	spin_lock_bh(&hwq->rx_page_lock);
 	for (i = 0; i < nsgs; i++) {
 		struct page *page;
 		void *data;
 		int offset;
 
-		data = page_frag_alloc(&q->rx_page, len, GFP_ATOMIC);
+		data = page_frag_alloc(&hwq->rx_page, len, GFP_ATOMIC);
 		if (!data)
 			break;
 
@@ -306,7 +306,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 		offset = data - page_address(page);
 		sg_set_page(&urb->sg[i], page, sglen, offset);
 	}
-	spin_unlock_bh(&q->rx_page_lock);
+	spin_unlock_bh(&hwq->rx_page_lock);
 
 	if (i < nsgs) {
 		int j;
@@ -324,14 +324,14 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 }
 
 static int
-mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
+mt76u_refill_rx(struct mt76_dev *dev, struct mt76_hw_queue *hwq,
 		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
 {
 	if (dev->usb.sg_en) {
-		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
-					SKB_WITH_OVERHEAD(q->buf_size));
+		return mt76u_fill_rx_sg(dev, buf, nsgs, hwq->buf_size,
+					SKB_WITH_OVERHEAD(hwq->buf_size));
 	} else {
-		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
+		buf->buf = page_frag_alloc(&hwq->rx_page, hwq->buf_size, gfp);
 		return buf->buf ? 0 : -ENOMEM;
 	}
 }
@@ -339,9 +339,9 @@ mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
 static int
 mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 
-	buf->len = SKB_WITH_OVERHEAD(q->buf_size);
+	buf->len = SKB_WITH_OVERHEAD(hwq->buf_size);
 	buf->dev = dev;
 
 	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -358,7 +358,7 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 		sg_init_table(buf->urb->sg, MT_SG_MAX_SIZE);
 	}
 
-	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
+	return mt76u_refill_rx(dev, hwq, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
 static void mt76u_buf_free(struct mt76u_buf *buf)
@@ -407,18 +407,18 @@ mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 }
 
 static inline struct mt76u_buf
-*mt76u_get_next_rx_entry(struct mt76_queue *q)
+*mt76u_get_next_rx_entry(struct mt76_hw_queue *hwq)
 {
 	struct mt76u_buf *buf = NULL;
 	unsigned long flags;
 
-	spin_lock_irqsave(&q->lock, flags);
-	if (q->queued > 0) {
-		buf = &q->entry[q->head].ubuf;
-		q->head = (q->head + 1) % q->ndesc;
-		q->queued--;
+	spin_lock_irqsave(&hwq->lock, flags);
+	if (hwq->queued > 0) {
+		buf = &hwq->entry[hwq->head].ubuf;
+		hwq->head = (hwq->head + 1) % hwq->ndesc;
+		hwq->queued--;
 	}
-	spin_unlock_irqrestore(&q->lock, flags);
+	spin_unlock_irqrestore(&hwq->lock, flags);
 
 	return buf;
 }
@@ -441,7 +441,7 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 static int
 mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	struct urb *urb = buf->urb;
 	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : buf->buf;
 	int data_len, len, nsgs = 1;
@@ -456,10 +456,10 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 
 	data_len = urb->num_sgs ? urb->sg[0].length : buf->len;
 	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
-	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
+	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(hwq->buf_size))
 		return 0;
 
-	skb = build_skb(data, q->buf_size);
+	skb = build_skb(data, hwq->buf_size);
 	if (!skb)
 		return 0;
 
@@ -472,7 +472,7 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				sg_page(&urb->sg[nsgs]),
 				urb->sg[nsgs].offset,
-				data_len, q->buf_size);
+				data_len, hwq->buf_size);
 		len -= data_len;
 		nsgs++;
 	}
@@ -484,7 +484,7 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 static void mt76u_complete_rx(struct urb *urb)
 {
 	struct mt76_dev *dev = urb->context;
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	unsigned long flags;
 
 	trace_rx_urb(dev, urb);
@@ -502,34 +502,35 @@ static void mt76u_complete_rx(struct urb *urb)
 		break;
 	}
 
-	spin_lock_irqsave(&q->lock, flags);
-	if (WARN_ONCE(q->entry[q->tail].ubuf.urb != urb, "rx urb mismatch"))
+	spin_lock_irqsave(&hwq->lock, flags);
+	if (WARN_ONCE(hwq->entry[hwq->tail].ubuf.urb != urb,
+		      "rx urb mismatch"))
 		goto out;
 
-	q->tail = (q->tail + 1) % q->ndesc;
-	q->queued++;
+	hwq->tail = (hwq->tail + 1) % hwq->ndesc;
+	hwq->queued++;
 	tasklet_schedule(&dev->usb.rx_tasklet);
 out:
-	spin_unlock_irqrestore(&q->lock, flags);
+	spin_unlock_irqrestore(&hwq->lock, flags);
 }
 
 static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	struct mt76u_buf *buf;
 	int err, count;
 
 	rcu_read_lock();
 
 	while (true) {
-		buf = mt76u_get_next_rx_entry(q);
+		buf = mt76u_get_next_rx_entry(hwq);
 		if (!buf)
 			break;
 
 		count = mt76u_process_rx_entry(dev, buf);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, buf, count,
+			err = mt76u_refill_rx(dev, hwq, buf, count,
 					      GFP_ATOMIC);
 			if (err < 0)
 				break;
@@ -545,21 +546,21 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 int mt76u_submit_rx_buffers(struct mt76_dev *dev)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	unsigned long flags;
 	int i, err = 0;
 
-	spin_lock_irqsave(&q->lock, flags);
-	for (i = 0; i < q->ndesc; i++) {
+	spin_lock_irqsave(&hwq->lock, flags);
+	for (i = 0; i < hwq->ndesc; i++) {
 		err = mt76u_submit_buf(dev, USB_DIR_IN, MT_EP_IN_PKT_RX,
-				       &q->entry[i].ubuf, GFP_ATOMIC,
+				       &hwq->entry[i].ubuf, GFP_ATOMIC,
 				       mt76u_complete_rx, dev);
 		if (err < 0)
 			break;
 	}
-	q->head = q->tail = 0;
-	q->queued = 0;
-	spin_unlock_irqrestore(&q->lock, flags);
+	hwq->head = hwq->tail = 0;
+	hwq->queued = 0;
+	spin_unlock_irqrestore(&hwq->lock, flags);
 
 	return err;
 }
@@ -568,25 +569,31 @@ EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
 static int mt76u_alloc_rx(struct mt76_dev *dev)
 {
 	struct mt76_usb *usb = &dev->usb;
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq;
 	int i, err;
 
+	hwq = devm_kzalloc(dev->dev, sizeof(*hwq), GFP_KERNEL);
+	if (!hwq)
+		return -ENOMEM;
+
+	dev->q_rx[MT_RXQ_MAIN].hwq = hwq;
+
 	usb->mcu.data = devm_kmalloc(dev->dev, MCU_RESP_URB_SIZE, GFP_KERNEL);
 	if (!usb->mcu.data)
 		return -ENOMEM;
 
-	spin_lock_init(&q->rx_page_lock);
-	spin_lock_init(&q->lock);
-	q->entry = devm_kcalloc(dev->dev,
-				MT_NUM_RX_ENTRIES, sizeof(*q->entry),
-				GFP_KERNEL);
-	if (!q->entry)
+	spin_lock_init(&hwq->rx_page_lock);
+	spin_lock_init(&hwq->lock);
+	hwq->entry = devm_kcalloc(dev->dev,
+				  MT_NUM_RX_ENTRIES, sizeof(*hwq->entry),
+				  GFP_KERNEL);
+	if (!hwq->entry)
 		return -ENOMEM;
 
-	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
-	q->ndesc = MT_NUM_RX_ENTRIES;
-	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf);
+	hwq->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
+	hwq->ndesc = MT_NUM_RX_ENTRIES;
+	for (i = 0; i < hwq->ndesc; i++) {
+		err = mt76u_buf_alloc(dev, &hwq->entry[i].ubuf);
 		if (err < 0)
 			return err;
 	}
@@ -596,37 +603,38 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 
 static void mt76u_free_rx(struct mt76_dev *dev)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	struct page *page;
 	int i;
 
-	for (i = 0; i < q->ndesc; i++)
-		mt76u_buf_free(&q->entry[i].ubuf);
+	for (i = 0; i < hwq->ndesc; i++)
+		mt76u_buf_free(&hwq->entry[i].ubuf);
 
-	spin_lock_bh(&q->rx_page_lock);
-	if (!q->rx_page.va)
+	spin_lock_bh(&hwq->rx_page_lock);
+	if (!hwq->rx_page.va)
 		goto out;
 
-	page = virt_to_page(q->rx_page.va);
-	__page_frag_cache_drain(page, q->rx_page.pagecnt_bias);
-	memset(&q->rx_page, 0, sizeof(q->rx_page));
+	page = virt_to_page(hwq->rx_page.va);
+	__page_frag_cache_drain(page, hwq->rx_page.pagecnt_bias);
+	memset(&hwq->rx_page, 0, sizeof(hwq->rx_page));
 out:
-	spin_unlock_bh(&q->rx_page_lock);
+	spin_unlock_bh(&hwq->rx_page_lock);
 }
 
 static void mt76u_stop_rx(struct mt76_dev *dev)
 {
-	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct mt76_hw_queue *hwq = dev->q_rx[MT_RXQ_MAIN].hwq;
 	int i;
 
-	for (i = 0; i < q->ndesc; i++)
-		usb_kill_urb(q->entry[i].ubuf.urb);
+	for (i = 0; i < hwq->ndesc; i++)
+		usb_kill_urb(hwq->entry[i].ubuf.urb);
 }
 
 static void mt76u_tx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue_entry entry;
+	struct mt76_hw_queue *hwq;
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
 	bool wake;
@@ -634,32 +642,33 @@ static void mt76u_tx_tasklet(unsigned long data)
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		q = &dev->q_tx[i];
+		hwq = q->hwq;
 
-		spin_lock_bh(&q->lock);
+		spin_lock_bh(&hwq->lock);
 		while (true) {
-			buf = &q->entry[q->head].ubuf;
-			if (!buf->done || !q->queued)
+			buf = &hwq->entry[hwq->head].ubuf;
+			if (!buf->done || !hwq->queued)
 				break;
 
-			if (q->entry[q->head].schedule) {
-				q->entry[q->head].schedule = false;
+			if (hwq->entry[hwq->head].schedule) {
+				hwq->entry[hwq->head].schedule = false;
 				q->swq_queued--;
 			}
 
-			entry = q->entry[q->head];
-			q->head = (q->head + 1) % q->ndesc;
-			q->queued--;
+			entry = hwq->entry[hwq->head];
+			hwq->head = (hwq->head + 1) % hwq->ndesc;
+			hwq->queued--;
 
-			spin_unlock_bh(&q->lock);
+			spin_unlock_bh(&hwq->lock);
 			dev->drv->tx_complete_skb(dev, q, &entry, false);
-			spin_lock_bh(&q->lock);
+			spin_lock_bh(&hwq->lock);
 		}
 		mt76_txq_schedule(dev, q);
-		wake = i < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
-		if (!q->queued)
+		wake = i < IEEE80211_NUM_ACS && hwq->queued < hwq->ndesc - 8;
+		if (!hwq->queued)
 			wake_up(&dev->tx_wait);
 
-		spin_unlock_bh(&q->lock);
+		spin_unlock_bh(&hwq->lock);
 
 		if (!test_and_set_bit(MT76_READING_STATS, &dev->state))
 			ieee80211_queue_delayed_work(dev->hw,
@@ -726,11 +735,12 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 		   struct sk_buff *skb, struct mt76_wcid *wcid,
 		   struct ieee80211_sta *sta)
 {
+	struct mt76_hw_queue *hwq = q->hwq;
 	struct mt76u_buf *buf;
-	u16 idx = q->tail;
+	u16 idx = hwq->tail;
 	int err;
 
-	if (q->queued == q->ndesc)
+	if (hwq->queued == hwq->ndesc)
 		return -ENOSPC;
 
 	skb->prev = skb->next = NULL;
@@ -738,7 +748,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (err < 0)
 		return err;
 
-	buf = &q->entry[idx].ubuf;
+	buf = &hwq->entry[idx].ubuf;
 	buf->buf = skb->data;
 	buf->len = skb->len;
 	buf->done = false;
@@ -747,23 +757,24 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	if (err < 0)
 		return err;
 
-	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
+	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(hwq->hw_idx),
 			    buf, mt76u_complete_tx, buf);
 
-	q->tail = (q->tail + 1) % q->ndesc;
-	q->entry[idx].skb = skb;
-	q->queued++;
+	hwq->tail = (hwq->tail + 1) % hwq->ndesc;
+	hwq->entry[idx].skb = skb;
+	hwq->queued++;
 
 	return idx;
 }
 
-static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
+static void mt76u_tx_kick(struct mt76_dev *dev,
+			  struct mt76_hw_queue *hwq)
 {
 	struct mt76u_buf *buf;
 	int err;
 
-	while (q->first != q->tail) {
-		buf = &q->entry[q->first].ubuf;
+	while (hwq->first != hwq->tail) {
+		buf = &hwq->entry[hwq->first].ubuf;
 
 		trace_submit_urb(dev, buf->urb);
 		err = usb_submit_urb(buf->urb, GFP_ATOMIC);
@@ -775,31 +786,38 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 					err);
 			break;
 		}
-		q->first = (q->first + 1) % q->ndesc;
+		hwq->first = (hwq->first + 1) % hwq->ndesc;
 	}
 }
 
 static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
+	struct mt76_hw_queue *hwq;
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		hwq = devm_kzalloc(dev->dev, sizeof(*hwq), GFP_KERNEL);
+		if (!hwq)
+			return -ENOMEM;
+
 		q = &dev->q_tx[i];
-		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->swq);
-		q->hw_idx = mt76_ac_to_hwq(i);
+		q->hwq = hwq;
 
-		q->entry = devm_kcalloc(dev->dev,
-					MT_NUM_TX_ENTRIES, sizeof(*q->entry),
-					GFP_KERNEL);
-		if (!q->entry)
+		spin_lock_init(&hwq->lock);
+		hwq->hw_idx = mt76_ac_to_hwq(i);
+
+		hwq->entry = devm_kcalloc(dev->dev,
+					  MT_NUM_TX_ENTRIES,
+					  sizeof(*hwq->entry), GFP_KERNEL);
+		if (!hwq->entry)
 			return -ENOMEM;
 
-		q->ndesc = MT_NUM_TX_ENTRIES;
-		for (j = 0; j < q->ndesc; j++) {
-			buf = &q->entry[j].ubuf;
+		hwq->ndesc = MT_NUM_TX_ENTRIES;
+		for (j = 0; j < hwq->ndesc; j++) {
+			buf = &hwq->entry[j].ubuf;
 			buf->dev = dev;
 
 			buf->urb = usb_alloc_urb(0, GFP_KERNEL);
@@ -822,25 +840,25 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 
 static void mt76u_free_tx(struct mt76_dev *dev)
 {
-	struct mt76_queue *q;
+	struct mt76_hw_queue *hwq;
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
-		for (j = 0; j < q->ndesc; j++)
-			usb_free_urb(q->entry[j].ubuf.urb);
+		hwq = dev->q_tx[i].hwq;
+		for (j = 0; j < hwq->ndesc; j++)
+			usb_free_urb(hwq->entry[j].ubuf.urb);
 	}
 }
 
 static void mt76u_stop_tx(struct mt76_dev *dev)
 {
-	struct mt76_queue *q;
+	struct mt76_hw_queue *hwq;
 	int i, j;
 
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
-		q = &dev->q_tx[i];
-		for (j = 0; j < q->ndesc; j++)
-			usb_kill_urb(q->entry[j].ubuf.urb);
+		hwq = dev->q_tx[i].hwq;
+		for (j = 0; j < hwq->ndesc; j++)
+			usb_kill_urb(hwq->entry[j].ubuf.urb);
 	}
 }
 
-- 
2.20.1

