Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:57530 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932669AbcIEJve (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2016 05:51:34 -0400
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org
Subject: [PATCH v3 2/3] mt76: add common code shared between multiple chipsets
Date: Mon,  5 Sep 2016 11:51:27 +0200
Message-Id: <20160905095128.80560-3-nbd@nbd.name> (sfid-20160905_115146_037822_B778EA61)
In-Reply-To: <20160905095128.80560-1-nbd@nbd.name>
References: <20160905095128.80560-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

This will be used by drivers for MT76x2e, MT7603e and MT7628

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/debugfs.c  |  76 ++++
 drivers/net/wireless/mediatek/mt76/dma.c      | 451 +++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/dma.h      |  38 ++
 drivers/net/wireless/mediatek/mt76/eeprom.c   | 122 ++++++
 drivers/net/wireless/mediatek/mt76/mac80211.c | 314 ++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mmio.c     |  61 +++
 drivers/net/wireless/mediatek/mt76/mt76.h     | 355 ++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/trace.c    |  23 ++
 drivers/net/wireless/mediatek/mt76/trace.h    |  71 ++++
 drivers/net/wireless/mediatek/mt76/tx.c       | 511 ++++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/util.c     |  78 ++++
 drivers/net/wireless/mediatek/mt76/util.h     |  44 +++
 12 files changed, 2144 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/debugfs.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/eeprom.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mac80211.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mmio.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/trace.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/tx.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/util.h

diff --git a/drivers/net/wireless/mediatek/mt76/debugfs.c b/drivers/net/wireless/mediatek/mt76/debugfs.c
new file mode 100644
index 0000000..cfe32e5
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/debugfs.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "mt76.h"
+
+static int
+mt76_reg_set(void *data, u64 val)
+{
+	struct mt76_dev *dev = data;
+
+	dev->bus->wr(dev, dev->debugfs_reg, val);
+	return 0;
+}
+
+static int
+mt76_reg_get(void *data, u64 *val)
+{
+	struct mt76_dev *dev = data;
+
+	*val = dev->bus->rr(dev, dev->debugfs_reg);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(fops_regval, mt76_reg_get, mt76_reg_set, "0x%08llx\n");
+
+static int
+mt76_queues_read(struct seq_file *s, void *data)
+{
+	struct mt76_dev *dev = dev_get_drvdata(s->private);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++) {
+		struct mt76_queue *q = &dev->q_tx[i];
+
+		if (!q->ndesc)
+			continue;
+
+		seq_printf(s,
+			   "%d:	queued=%d head=%d tail=%d swq_queued=%d\n",
+			   i, q->queued, q->head, q->tail, q->swq_queued);
+	}
+
+	return 0;
+}
+
+struct dentry *mt76_register_debugfs(struct mt76_dev *dev)
+{
+	struct dentry *dir;
+
+	dir = debugfs_create_dir("mt76", dev->hw->wiphy->debugfsdir);
+	if (!dir)
+		return NULL;
+
+	debugfs_create_u32("regidx", S_IRUSR | S_IWUSR, dir, &dev->debugfs_reg);
+	debugfs_create_file("regval", S_IRUSR | S_IWUSR, dir, dev,
+			    &fops_regval);
+	debugfs_create_blob("eeprom", S_IRUSR, dir, &dev->eeprom);
+	if (dev->otp.data)
+		debugfs_create_blob("otp", S_IRUSR, dir, &dev->otp);
+	debugfs_create_devm_seqfile(dev->dev, "queues", dir, mt76_queues_read);
+
+	return dir;
+}
+EXPORT_SYMBOL_GPL(mt76_register_debugfs);
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
new file mode 100644
index 0000000..ec4880c
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -0,0 +1,451 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/dma-mapping.h>
+#include "mt76.h"
+#include "dma.h"
+
+#define DMA_DUMMY_TXWI	((void *) ~0)
+
+static int
+mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	int size;
+	int i;
+
+	spin_lock_init(&q->lock);
+	INIT_LIST_HEAD(&q->swq);
+
+	size = q->ndesc * sizeof(struct mt76_desc);
+	q->desc = dmam_alloc_coherent(dev->dev, size, &q->desc_dma, GFP_KERNEL);
+	if (!q->desc)
+		return -ENOMEM;
+
+	size = q->ndesc * sizeof(*q->entry);
+	q->entry = devm_kzalloc(dev->dev, size, GFP_KERNEL);
+	if (!q->entry)
+		return -ENOMEM;
+
+	/* clear descriptors */
+	for (i = 0; i < q->ndesc; i++)
+		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+
+	iowrite32(q->desc_dma, &q->regs->desc_base);
+	iowrite32(0, &q->regs->cpu_idx);
+	iowrite32(0, &q->regs->dma_idx);
+	iowrite32(q->ndesc, &q->regs->ring_size);
+
+	return 0;
+}
+
+static int
+mt76_dma_add_buf(struct mt76_dev *dev, struct mt76_queue *q,
+		 struct mt76_queue_buf *buf, int nbufs, u32 info,
+		 struct sk_buff *skb, void *txwi)
+{
+	struct mt76_desc *desc;
+	u32 ctrl;
+	int i, idx = -1;
+
+	if (txwi)
+		q->entry[q->head].txwi = DMA_DUMMY_TXWI;
+
+	for (i = 0; i < nbufs; i += 2, buf += 2) {
+		u32 buf0 = buf[0].addr, buf1 = 0;
+
+		ctrl = FIELD_PREP(MT_DMA_CTL_SD_LEN0, buf[0].len);
+		if (i < nbufs - 1) {
+			buf1 = buf[1].addr;
+			ctrl |= FIELD_PREP(MT_DMA_CTL_SD_LEN1, buf[1].len);
+		}
+
+		if (i == nbufs - 1)
+			ctrl |= MT_DMA_CTL_LAST_SEC0;
+		else if (i == nbufs - 2)
+			ctrl |= MT_DMA_CTL_LAST_SEC1;
+
+		idx = q->head;
+		q->head = (q->head + 1) % q->ndesc;
+
+		desc = &q->desc[idx];
+
+		WRITE_ONCE(desc->buf0, cpu_to_le32(buf0));
+		WRITE_ONCE(desc->buf1, cpu_to_le32(buf1));
+		WRITE_ONCE(desc->info, cpu_to_le32(info));
+		WRITE_ONCE(desc->ctrl, cpu_to_le32(ctrl));
+
+		q->queued++;
+	}
+
+	q->entry[idx].txwi = txwi;
+	q->entry[idx].skb = skb;
+
+	return idx;
+}
+
+static void
+mt76_dma_tx_cleanup_idx(struct mt76_dev *dev, struct mt76_queue *q, int idx,
+			struct mt76_queue_entry *prev_e)
+{
+	struct mt76_queue_entry *e = &q->entry[idx];
+	__le32 __ctrl = READ_ONCE(q->desc[idx].ctrl);
+	u32 ctrl = le32_to_cpu(__ctrl);
+
+	if (!e->txwi || !e->skb) {
+		__le32 addr = READ_ONCE(q->desc[idx].buf0);
+		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctrl);
+
+		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
+				 DMA_TO_DEVICE);
+	}
+
+	if (!(ctrl & MT_DMA_CTL_LAST_SEC0)) {
+		__le32 addr = READ_ONCE(q->desc[idx].buf1);
+		u32 len = FIELD_GET(MT_DMA_CTL_SD_LEN1, ctrl);
+
+		dma_unmap_single(dev->dev, le32_to_cpu(addr), len,
+				 DMA_TO_DEVICE);
+	}
+
+	if (e->txwi == DMA_DUMMY_TXWI)
+		e->txwi = NULL;
+
+	*prev_e = *e;
+	memset(e, 0, sizeof(*e));
+}
+
+static void
+mt76_dma_sync_idx(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	q->head = ioread32(&q->regs->dma_idx);
+	q->tail = q->head;
+	iowrite32(q->head, &q->regs->cpu_idx);
+}
+
+static void
+mt76_dma_tx_cleanup(struct mt76_dev *dev, enum mt76_txq_id qid, bool flush)
+{
+	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue_entry entry;
+	bool wake = false;
+	int last;
+
+	if (!q->ndesc)
+		return;
+
+	spin_lock_bh(&q->lock);
+	if (flush)
+		last = -1;
+	else
+		last = ioread32(&q->regs->dma_idx);
+
+	while (q->queued && q->tail != last) {
+		mt76_dma_tx_cleanup_idx(dev, q, q->tail, &entry);
+		if (entry.schedule)
+			q->swq_queued--;
+
+		if (entry.skb)
+			dev->drv->tx_complete_skb(dev, q, &entry, flush);
+
+		if (entry.txwi) {
+			mt76_put_txwi(dev, entry.txwi);
+			wake = true;
+		}
+
+		q->tail = (q->tail + 1) % q->ndesc;
+		q->queued--;
+
+		if (!flush && q->tail == last)
+			last = ioread32(&q->regs->dma_idx);
+	}
+
+	if (!flush)
+		mt76_txq_schedule(dev, q);
+	else
+		mt76_dma_sync_idx(dev, q);
+
+	wake = wake && qid < IEEE80211_NUM_ACS && q->queued < q->ndesc - 8;
+	spin_unlock_bh(&q->lock);
+
+	if (wake)
+		ieee80211_wake_queue(dev->hw, qid);
+}
+
+static void *
+mt76_dma_get_buf(struct mt76_dev *dev, struct mt76_queue *q, int idx,
+		 int *len, u32 *info, bool *more)
+{
+	struct mt76_queue_entry *e = &q->entry[idx];
+	struct mt76_desc *desc = &q->desc[idx];
+	dma_addr_t buf_addr;
+	void *buf = e->buf;
+	int buf_len = SKB_WITH_OVERHEAD(q->buf_size);
+
+	buf_addr = READ_ONCE(desc->buf0);
+	if (len) {
+		u32 ctl = READ_ONCE(desc->ctrl);
+		*len = FIELD_GET(MT_DMA_CTL_SD_LEN0, ctl);
+		*more = !(ctl & MT_DMA_CTL_LAST_SEC0);
+	}
+
+	if (info)
+		*info = le32_to_cpu(desc->info);
+
+	dma_unmap_single(dev->dev, buf_addr, buf_len, DMA_FROM_DEVICE);
+	e->buf = NULL;
+
+	return buf;
+}
+
+static void *
+mt76_dma_dequeue(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
+		 int *len, u32 *info, bool *more)
+{
+	int idx = q->tail;
+
+	*more = false;
+	if (!q->queued)
+		return NULL;
+
+	if (!flush && !(q->desc[idx].ctrl & cpu_to_le32(MT_DMA_CTL_DMA_DONE)))
+		return NULL;
+
+	q->tail = (q->tail + 1) % q->ndesc;
+	q->queued--;
+
+	return mt76_dma_get_buf(dev, q, idx, len, info, more);
+}
+
+static void
+mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	iowrite32(q->head, &q->regs->cpu_idx);
+}
+
+static int
+mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q, bool napi)
+{
+	dma_addr_t addr;
+	void *buf;
+	int frames = 0;
+	int len = SKB_WITH_OVERHEAD(q->buf_size);
+	int offset = q->buf_offset;
+	int idx;
+	void *(*alloc)(unsigned int fragsz);
+
+	if (napi)
+		alloc = napi_alloc_frag;
+	else
+		alloc = netdev_alloc_frag;
+
+	spin_lock_bh(&q->lock);
+
+	while (q->queued < q->ndesc - 1) {
+		struct mt76_queue_buf qbuf;
+
+		buf = alloc(q->buf_size);
+		if (!buf)
+			break;
+
+		addr = dma_map_single(dev->dev, buf, len, DMA_FROM_DEVICE);
+		if (dma_mapping_error(dev->dev, addr)) {
+			skb_free_frag(buf);
+			break;
+		}
+
+		qbuf.addr = addr + offset;
+		qbuf.len = len - offset;
+		idx = mt76_dma_add_buf(dev, q, &qbuf, 1, 0, buf, NULL);
+		frames++;
+	}
+
+	if (frames)
+		mt76_dma_kick_queue(dev, q);
+
+	spin_unlock_bh(&q->lock);
+
+	return frames;
+}
+
+static void
+mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
+{
+	void *buf;
+	bool more;
+
+	spin_lock_bh(&q->lock);
+	do {
+		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
+		if (!buf)
+			break;
+
+		skb_free_frag(buf);
+	} while (1);
+	spin_unlock_bh(&q->lock);
+}
+
+static void
+mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
+{
+	struct mt76_queue *q = &dev->q_rx[qid];
+	int i;
+
+	for (i = 0; i < q->ndesc; i++)
+		q->desc[i].ctrl &= ~cpu_to_le32(MT_DMA_CTL_DMA_DONE);
+
+	mt76_dma_rx_cleanup(dev, q);
+	mt76_dma_sync_idx(dev, q);
+	mt76_dma_rx_fill(dev, q, false);
+}
+
+static void
+mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
+		  int len, bool more)
+{
+	struct page *page = virt_to_head_page(data);
+	int offset = data - page_address(page);
+	struct sk_buff *skb = q->rx_head;
+
+	offset += q->buf_offset;
+	skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page, offset, len,
+			q->buf_size);
+
+	if (more)
+		return;
+
+	q->rx_head = NULL;
+	dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+}
+
+static int
+mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
+{
+	struct sk_buff *skb;
+	unsigned char *data;
+	int len;
+	int done = 0;
+	bool more;
+
+	while (done < budget) {
+		u32 info;
+
+		data = mt76_dma_dequeue(dev, q, false, &len, &info, &more);
+		if (!data)
+			break;
+
+		if (q->rx_head) {
+			mt76_add_fragment(dev, q, data, len, more);
+			continue;
+		}
+
+		skb = build_skb(data, q->buf_size);
+		if (!skb) {
+			skb_free_frag(data);
+			continue;
+		}
+
+		skb_reserve(skb, q->buf_offset);
+		if (skb->tail + len > skb->end) {
+			dev_kfree_skb(skb);
+			continue;
+		}
+
+		if (q == &dev->q_rx[MT_RXQ_MCU]) {
+			u32 *rxfce = (u32 *) skb->cb;
+			*rxfce = info;
+		}
+
+		__skb_put(skb, len);
+		done++;
+
+		if (more) {
+			q->rx_head = skb;
+			continue;
+		}
+
+		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
+	}
+
+	mt76_dma_rx_fill(dev, q, true);
+	return done;
+}
+
+static int
+mt76_dma_rx_poll(struct napi_struct *napi, int budget)
+{
+	struct mt76_dev *dev;
+	int qid, done;
+
+	dev = container_of(napi->dev, struct mt76_dev, napi_dev);
+	qid = napi - dev->napi;
+
+	done = mt76_dma_rx_process(dev, &dev->q_rx[qid], budget);
+	if (done < budget) {
+		napi_complete(napi);
+		dev->drv->rx_poll_complete(dev, qid);
+	}
+	mt76_rx_complete(dev, qid);
+
+	return done;
+}
+
+static int
+mt76_dma_init(struct mt76_dev *dev)
+{
+	int i;
+
+	init_dummy_netdev(&dev->napi_dev);
+
+	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++) {
+		netif_napi_add(&dev->napi_dev, &dev->napi[i], mt76_dma_rx_poll,
+			       64);
+		mt76_dma_rx_fill(dev, &dev->q_rx[i], false);
+		skb_queue_head_init(&dev->rx_skb[i]);
+		napi_enable(&dev->napi[i]);
+	}
+
+	return 0;
+}
+
+static const struct mt76_queue_ops mt76_dma_ops = {
+	.init = mt76_dma_init,
+	.alloc = mt76_dma_alloc_queue,
+	.add_buf = mt76_dma_add_buf,
+	.tx_cleanup = mt76_dma_tx_cleanup,
+	.rx_reset = mt76_dma_rx_reset,
+	.kick = mt76_dma_kick_queue,
+};
+
+int mt76_dma_attach(struct mt76_dev *dev)
+{
+	dev->queue_ops = &mt76_dma_ops;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mt76_dma_attach);
+
+void mt76_dma_cleanup(struct mt76_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dev->q_tx); i++)
+		mt76_dma_tx_cleanup(dev, i, true);
+
+	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++) {
+		netif_napi_del(&dev->napi[i]);
+		mt76_dma_rx_cleanup(dev, &dev->q_rx[i]);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_dma_cleanup);
diff --git a/drivers/net/wireless/mediatek/mt76/dma.h b/drivers/net/wireless/mediatek/mt76/dma.h
new file mode 100644
index 0000000..1dad396
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/dma.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef __MT76_DMA_H
+#define __MT76_DMA_H
+
+#define MT_RING_SIZE			0x10
+
+#define MT_DMA_CTL_SD_LEN1		GENMASK(13, 0)
+#define MT_DMA_CTL_LAST_SEC1		BIT(14)
+#define MT_DMA_CTL_BURST		BIT(15)
+#define MT_DMA_CTL_SD_LEN0		GENMASK(29, 16)
+#define MT_DMA_CTL_LAST_SEC0		BIT(30)
+#define MT_DMA_CTL_DMA_DONE		BIT(31)
+
+struct mt76_desc {
+	__le32 buf0;
+	__le32 ctrl;
+	__le32 buf1;
+	__le32 info;
+} __packed __aligned(4);
+
+int mt76_dma_attach(struct mt76_dev *dev);
+void mt76_dma_cleanup(struct mt76_dev *dev);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
new file mode 100644
index 0000000..444865c
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/of.h>
+#include <linux/of_net.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/etherdevice.h>
+#include "mt76.h"
+
+static int
+mt76_get_of_eeprom(struct mt76_dev *dev, int len)
+{
+#ifdef CONFIG_OF
+	struct device_node *np = dev->dev->of_node;
+	struct mtd_info *mtd;
+	const __be32 *list;
+	const char *part;
+	phandle phandle;
+	int offset = 0;
+	int size;
+	size_t retlen;
+	int ret;
+
+	if (!np)
+		return -ENOENT;
+
+	list = of_get_property(np, "mediatek,mtd-eeprom", &size);
+	if (!list)
+		return -ENOENT;
+
+	phandle = be32_to_cpup(list++);
+	if (!phandle)
+		return -ENOENT;
+
+	np = of_find_node_by_phandle(phandle);
+	if (!np)
+		return -EINVAL;
+
+	part = of_get_property(np, "label", NULL);
+	if (!part)
+		part = np->name;
+
+	mtd = get_mtd_device_nm(part);
+	if (IS_ERR(mtd))
+		return PTR_ERR(mtd);
+
+	if (size <= sizeof(*list))
+		return -EINVAL;
+
+	offset = be32_to_cpup(list);
+	ret = mtd_read(mtd, offset, len, &retlen, dev->eeprom.data);
+	put_mtd_device(mtd);
+	if (ret)
+		return ret;
+
+	if (retlen < len)
+		return -EINVAL;
+
+	return 0;
+#else
+	return -ENOENT;
+#endif
+}
+
+void
+mt76_eeprom_override(struct mt76_dev *dev)
+{
+#ifdef CONFIG_OF
+	struct device_node *np = dev->dev->of_node;
+	const __be32 *val;
+	const u8 *mac;
+	int size;
+
+	if (!np)
+		return;
+
+	val = of_get_property(np, "mediatek,2ghz", &size);
+	if (val)
+		dev->cap.has_2ghz = be32_to_cpup(val);
+
+	val = of_get_property(np, "mediatek,5ghz", &size);
+	if (val)
+		dev->cap.has_5ghz = be32_to_cpup(val);
+
+	mac = of_get_mac_address(np);
+	if (mac)
+		memcpy(dev->macaddr, mac, ETH_ALEN);
+#endif
+
+	if (!is_valid_ether_addr(dev->macaddr)) {
+		eth_random_addr(dev->macaddr);
+		dev_info(dev->dev,
+			 "Invalid MAC address, using random address %pM\n",
+			 dev->macaddr);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_eeprom_override);
+
+int
+mt76_eeprom_init(struct mt76_dev *dev, int len)
+{
+	dev->eeprom.size = len;
+	dev->eeprom.data = devm_kzalloc(dev->dev, len, GFP_KERNEL);
+	if (!dev->eeprom.data)
+		return -ENOMEM;
+
+	return !mt76_get_of_eeprom(dev, len);
+}
+EXPORT_SYMBOL_GPL(mt76_eeprom_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
new file mode 100644
index 0000000..f6900f1
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -0,0 +1,314 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include "mt76.h"
+
+#define CHAN2G(_idx, _freq) {			\
+	.band = NL80211_BAND_2GHZ,		\
+	.center_freq = (_freq),			\
+	.hw_value = (_idx),			\
+	.max_power = 30,			\
+}
+
+#define CHAN5G(_idx, _freq) {			\
+	.band = NL80211_BAND_5GHZ,		\
+	.center_freq = (_freq),			\
+	.hw_value = (_idx),			\
+	.max_power = 30,			\
+}
+
+static const struct ieee80211_channel mt76_channels_2ghz[] = {
+	CHAN2G(1, 2412),
+	CHAN2G(2, 2417),
+	CHAN2G(3, 2422),
+	CHAN2G(4, 2427),
+	CHAN2G(5, 2432),
+	CHAN2G(6, 2437),
+	CHAN2G(7, 2442),
+	CHAN2G(8, 2447),
+	CHAN2G(9, 2452),
+	CHAN2G(10, 2457),
+	CHAN2G(11, 2462),
+	CHAN2G(12, 2467),
+	CHAN2G(13, 2472),
+	CHAN2G(14, 2484),
+};
+
+static const struct ieee80211_channel mt76_channels_5ghz[] = {
+	CHAN5G(36, 5180),
+	CHAN5G(40, 5200),
+	CHAN5G(44, 5220),
+	CHAN5G(48, 5240),
+
+	CHAN5G(52, 5260),
+	CHAN5G(56, 5280),
+	CHAN5G(60, 5300),
+	CHAN5G(64, 5320),
+
+	CHAN5G(100, 5500),
+	CHAN5G(104, 5520),
+	CHAN5G(108, 5540),
+	CHAN5G(112, 5560),
+	CHAN5G(116, 5580),
+	CHAN5G(120, 5600),
+	CHAN5G(124, 5620),
+	CHAN5G(128, 5640),
+	CHAN5G(132, 5660),
+	CHAN5G(136, 5680),
+	CHAN5G(140, 5700),
+
+	CHAN5G(149, 5745),
+	CHAN5G(153, 5765),
+	CHAN5G(157, 5785),
+	CHAN5G(161, 5805),
+	CHAN5G(165, 5825),
+};
+
+static int
+mt76_init_sband(struct mt76_dev *dev, struct mt76_sband *msband,
+		const struct ieee80211_channel *chan, int n_chan,
+		struct ieee80211_rate *rates, int n_rates, bool vht)
+{
+	struct ieee80211_supported_band *sband = &msband->sband;
+	struct ieee80211_sta_ht_cap *ht_cap;
+	struct ieee80211_sta_vht_cap *vht_cap;
+	void *chanlist;
+	u16 mcs_map;
+	int size;
+
+	size = n_chan * sizeof(*chan);
+	chanlist = devm_kmemdup(dev->dev, chan, size, GFP_KERNEL);
+	if (!chanlist)
+		return -ENOMEM;
+
+	msband->chan = devm_kzalloc(dev->dev, n_chan * sizeof(*msband->chan),
+				    GFP_KERNEL);
+	if (!msband->chan)
+		return -ENOMEM;
+
+	sband->channels = chanlist;
+	sband->n_channels = n_chan;
+	sband->bitrates = rates;
+	sband->n_bitrates = n_rates;
+	dev->chandef.chan = &sband->channels[0];
+
+	ht_cap = &sband->ht_cap;
+	ht_cap->ht_supported = true;
+	ht_cap->cap |= IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+		       IEEE80211_HT_CAP_GRN_FLD |
+		       IEEE80211_HT_CAP_SGI_20 |
+		       IEEE80211_HT_CAP_SGI_40 |
+		       IEEE80211_HT_CAP_TX_STBC |
+		       (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT);
+
+	ht_cap->mcs.rx_mask[0] = 0xff;
+	ht_cap->mcs.rx_mask[1] = 0xff;
+	ht_cap->mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	ht_cap->ampdu_factor = IEEE80211_HT_MAX_AMPDU_64K;
+	ht_cap->ampdu_density = IEEE80211_HT_MPDU_DENSITY_4;
+
+	if (!vht)
+		return 0;
+
+	vht_cap = &sband->vht_cap;
+	vht_cap->vht_supported = true;
+
+	mcs_map = (IEEE80211_VHT_MCS_SUPPORT_0_9 << (0 * 2)) |
+		  (IEEE80211_VHT_MCS_SUPPORT_0_9 << (1 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (2 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (3 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (4 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (5 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (6 * 2)) |
+		  (IEEE80211_VHT_MCS_NOT_SUPPORTED << (7 * 2));
+
+	vht_cap->vht_mcs.rx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->vht_mcs.tx_mcs_map = cpu_to_le16(mcs_map);
+	vht_cap->cap |= IEEE80211_VHT_CAP_RXLDPC |
+			IEEE80211_VHT_CAP_TXSTBC |
+			IEEE80211_VHT_CAP_RXSTBC_1 |
+			IEEE80211_VHT_CAP_SHORT_GI_80;
+
+	return 0;
+}
+
+static int
+mt76_init_sband_2g(struct mt76_dev *dev, struct ieee80211_rate *rates,
+		   int n_rates)
+{
+	dev->hw->wiphy->bands[NL80211_BAND_2GHZ] = &dev->sband_2g.sband;
+
+	return mt76_init_sband(dev, &dev->sband_2g,
+			       mt76_channels_2ghz,
+			       ARRAY_SIZE(mt76_channels_2ghz),
+			       rates, n_rates, false);
+}
+
+static int
+mt76_init_sband_5g(struct mt76_dev *dev, struct ieee80211_rate *rates,
+		   int n_rates, bool vht)
+{
+	dev->hw->wiphy->bands[NL80211_BAND_5GHZ] = &dev->sband_5g.sband;
+
+	return mt76_init_sband(dev, &dev->sband_5g,
+			       mt76_channels_5ghz,
+			       ARRAY_SIZE(mt76_channels_5ghz),
+			       rates, n_rates, vht);
+}
+
+int mt76_register_device(struct mt76_dev *dev, bool vht,
+			 struct ieee80211_rate *rates, int n_rates)
+{
+	struct ieee80211_hw *hw = dev->hw;
+	struct wiphy *wiphy = hw->wiphy;
+	int ret;
+
+	dev_set_drvdata(dev->dev, dev);
+
+	spin_lock_init(&dev->lock);
+	spin_lock_init(&dev->cc_lock);
+	INIT_LIST_HEAD(&dev->txwi_cache);
+
+	SET_IEEE80211_DEV(hw, dev->dev);
+	SET_IEEE80211_PERM_ADDR(hw, dev->macaddr);
+
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_AP) |
+#ifdef CONFIG_MAC80211_MESH
+		BIT(NL80211_IFTYPE_MESH_POINT) |
+#endif
+		BIT(NL80211_IFTYPE_ADHOC);
+
+	wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+
+	hw->txq_data_size = sizeof(struct mt76_txq);
+	hw->max_tx_fragments = 16;
+
+	ieee80211_hw_set(hw, SIGNAL_DBM);
+	ieee80211_hw_set(hw, PS_NULLFUNC_STACK);
+	ieee80211_hw_set(hw, HOST_BROADCAST_PS_BUFFERING);
+	ieee80211_hw_set(hw, AMPDU_AGGREGATION);
+	ieee80211_hw_set(hw, SUPPORTS_RC_TABLE);
+	ieee80211_hw_set(hw, SUPPORT_FAST_XMIT);
+	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
+	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
+	ieee80211_hw_set(hw, TX_AMSDU);
+	ieee80211_hw_set(hw, TX_FRAG_LIST);
+
+	if (dev->cap.has_2ghz) {
+		ret = mt76_init_sband_2g(dev, rates, n_rates);
+		if (ret)
+			return ret;
+	}
+
+	if (dev->cap.has_5ghz) {
+		ret = mt76_init_sband_5g(dev, rates + 4, n_rates - 4, vht);
+		if (ret)
+			return ret;
+	}
+
+	return ieee80211_register_hw(hw);
+}
+EXPORT_SYMBOL_GPL(mt76_register_device);
+
+void mt76_unregister_device(struct mt76_dev *dev)
+{
+	struct ieee80211_hw *hw = dev->hw;
+
+	ieee80211_unregister_hw(hw);
+	mt76_tx_free(dev);
+}
+EXPORT_SYMBOL_GPL(mt76_unregister_device);
+
+void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb)
+{
+	if (!test_bit(MT76_STATE_RUNNING, &dev->state)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	__skb_queue_tail(&dev->rx_skb[q], skb);
+}
+EXPORT_SYMBOL_GPL(mt76_rx);
+
+void mt76_set_channel(struct mt76_dev *dev)
+{
+	struct ieee80211_hw *hw = dev->hw;
+	struct cfg80211_chan_def *chandef = &hw->conf.chandef;
+	struct mt76_channel_state *state;
+	bool offchannel = hw->conf.flags & IEEE80211_CONF_OFFCHANNEL;
+
+	if (dev->drv->update_survey)
+		dev->drv->update_survey(dev);
+
+	dev->chandef = *chandef;
+
+	if (!offchannel)
+		dev->main_chan = chandef->chan;
+
+	if (chandef->chan != dev->main_chan) {
+		state = mt76_channel_state(dev, chandef->chan);
+		memset(state, 0, sizeof(*state));
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_set_channel);
+
+int mt76_get_survey(struct ieee80211_hw *hw, int idx,
+		    struct survey_info *survey)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76_sband *sband;
+	struct ieee80211_channel *chan;
+	struct mt76_channel_state *state;
+	int ret = 0;
+
+	if (idx == 0 && dev->drv->update_survey)
+		dev->drv->update_survey(dev);
+
+	sband = &dev->sband_2g;
+	if (idx >= sband->sband.n_channels) {
+		idx -= sband->sband.n_channels;
+		sband = &dev->sband_5g;
+	}
+
+	if (idx >= sband->sband.n_channels)
+		return -ENOENT;
+
+	chan = &sband->sband.channels[idx];
+	state = mt76_channel_state(dev, chan);
+
+	memset(survey, 0, sizeof(*survey));
+	survey->channel = chan;
+	survey->filled = SURVEY_INFO_TIME | SURVEY_INFO_TIME_BUSY;
+	if (chan == dev->main_chan)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
+	spin_lock_bh(&dev->cc_lock);
+	survey->time = div_u64(state->cc_active, 1000);
+	survey->time_busy = div_u64(state->cc_busy, 1000);
+	spin_unlock_bh(&dev->cc_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76_get_survey);
+
+void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q)
+{
+	struct sk_buff *skb;
+
+	while ((skb = __skb_dequeue(&dev->rx_skb[q])) != NULL)
+		ieee80211_rx_napi(dev->hw, NULL, skb, &dev->napi[q]);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
new file mode 100644
index 0000000..09a14de
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -0,0 +1,61 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76.h"
+#include "trace.h"
+
+static u32 mt76_mmio_rr(struct mt76_dev *dev, u32 offset)
+{
+	u32 val;
+
+	val = ioread32(dev->regs + offset);
+	trace_reg_rr(dev, offset, val);
+
+	return val;
+}
+
+static void mt76_mmio_wr(struct mt76_dev *dev, u32 offset, u32 val)
+{
+	trace_reg_wr(dev, offset, val);
+	iowrite32(val, dev->regs + offset);
+}
+
+static u32 mt76_mmio_rmw(struct mt76_dev *dev, u32 offset, u32 mask, u32 val)
+{
+	val |= mt76_mmio_rr(dev, offset) & ~mask;
+	mt76_mmio_wr(dev, offset, val);
+	return val;
+}
+
+static void mt76_mmio_copy(struct mt76_dev *dev, u32 offset, const void *data,
+			   int len)
+{
+	__iowrite32_copy(dev->regs + offset, data, len >> 2);
+}
+
+void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs)
+{
+	static const struct mt76_bus_ops mt76_mmio_ops = {
+		.rr = mt76_mmio_rr,
+		.rmw = mt76_mmio_rmw,
+		.wr = mt76_mmio_wr,
+		.copy = mt76_mmio_copy,
+	};
+
+	dev->bus = &mt76_mmio_ops;
+	dev->regs = regs;
+}
+EXPORT_SYMBOL_GPL(mt76_mmio_init);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
new file mode 100644
index 0000000..f94f78a
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -0,0 +1,355 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef __MT76_H
+#define __MT76_H
+
+#include <linux/kernel.h>
+#include <linux/io.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <net/mac80211.h>
+#include "util.h"
+
+#define MT_RX_RING_SIZE     128
+#define MT_TX_RING_SIZE     256
+#define MT_MCU_RING_SIZE    32
+#define MT_RX_BUF_SIZE      2048
+
+struct mt76_dev;
+
+struct mt76_bus_ops {
+	u32 (*rr)(struct mt76_dev *dev, u32 offset);
+	void (*wr)(struct mt76_dev *dev, u32 offset, u32 val);
+	u32 (*rmw)(struct mt76_dev *dev, u32 offset, u32 mask, u32 val);
+	void (*copy)(struct mt76_dev *dev, u32 offset, const void *data,
+		     int len);
+};
+
+enum mt76_txq_id {
+	MT_TXQ_VO = IEEE80211_AC_VO,
+	MT_TXQ_VI = IEEE80211_AC_VI,
+	MT_TXQ_BE = IEEE80211_AC_BE,
+	MT_TXQ_BK = IEEE80211_AC_BK,
+	MT_TXQ_PSD,
+	MT_TXQ_MCU,
+	MT_TXQ_BEACON,
+	MT_TXQ_CAB,
+	__MT_TXQ_MAX
+};
+
+enum mt76_rxq_id {
+	MT_RXQ_MAIN,
+	MT_RXQ_MCU,
+	__MT_RXQ_MAX
+};
+
+struct mt76_queue_buf {
+	dma_addr_t addr;
+	int len;
+};
+
+struct mt76_queue_entry {
+	union {
+		void *buf;
+		struct sk_buff *skb;
+	};
+	struct mt76_txwi_cache *txwi;
+	bool schedule;
+};
+
+struct mt76_queue_regs {
+	u32 desc_base;
+	u32 ring_size;
+	u32 cpu_idx;
+	u32 dma_idx;
+} __packed __aligned(4);
+
+struct mt76_queue {
+	struct mt76_queue_regs __iomem *regs;
+
+	spinlock_t lock;
+	struct mt76_queue_entry *entry;
+	struct mt76_desc *desc;
+
+	struct list_head swq;
+	int swq_queued;
+
+	u16 head;
+	u16 tail;
+	int ndesc;
+	int queued;
+	int buf_size;
+
+	u8 buf_offset;
+	u8 hw_idx;
+
+	dma_addr_t desc_dma;
+	struct sk_buff *rx_head;
+};
+
+struct mt76_queue_ops {
+	int (*init)(struct mt76_dev *dev);
+
+	int (*alloc)(struct mt76_dev *dev, struct mt76_queue *q);
+
+	int (*add_buf)(struct mt76_dev *dev, struct mt76_queue *q,
+		       struct mt76_queue_buf *buf, int nbufs, u32 info,
+		       struct sk_buff *skb, void *txwi);
+
+	void *(*dequeue)(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
+			 int *len, u32 *info, bool *more);
+
+	void (*rx_reset)(struct mt76_dev *dev, enum mt76_rxq_id qid);
+
+	void (*tx_cleanup)(struct mt76_dev *dev, enum mt76_txq_id qid,
+			   bool flush);
+
+	void (*kick)(struct mt76_dev *dev, struct mt76_queue *q);
+};
+
+struct mt76_wcid {
+	u8 idx;
+	u8 hw_key_idx;
+
+	__le16 tx_rate;
+	bool tx_rate_set;
+	u8 tx_rate_nss;
+	s8 max_txpwr_adj;
+};
+
+struct mt76_txq {
+	struct list_head list;
+	struct mt76_queue *hwq;
+	struct mt76_wcid *wcid;
+
+	struct sk_buff_head retry_q;
+
+	u16 agg_ssn;
+	bool send_bar;
+	bool aggr;
+};
+
+struct mt76_txwi_cache {
+	u32 txwi[8];
+	dma_addr_t dma_addr;
+	struct list_head list;
+};
+
+enum {
+	MT76_STATE_INITIALIZED,
+	MT76_STATE_RUNNING,
+	MT76_SCANNING,
+	MT76_RESET,
+};
+
+struct mt76_hw_cap {
+	bool has_2ghz;
+	bool has_5ghz;
+};
+
+struct mt76_driver_ops {
+	u16 txwi_size;
+
+	void (*update_survey)(struct mt76_dev *dev);
+
+	int (*tx_prepare_skb)(struct mt76_dev *dev, void *txwi_ptr,
+			      struct sk_buff *skb, struct mt76_queue *q,
+			      struct mt76_wcid *wcid,
+			      struct ieee80211_sta *sta, u32 *tx_info);
+
+	void (*tx_complete_skb)(struct mt76_dev *dev, struct mt76_queue *q,
+				struct mt76_queue_entry *e, bool flush);
+
+	void (*rx_skb)(struct mt76_dev *dev, enum mt76_rxq_id q,
+		       struct sk_buff *skb);
+
+	void (*rx_poll_complete)(struct mt76_dev *dev, enum mt76_rxq_id q);
+};
+
+struct mt76_channel_state {
+	u64 cc_active;
+	u64 cc_busy;
+};
+
+struct mt76_sband {
+	struct ieee80211_supported_band sband;
+	struct mt76_channel_state *chan;
+};
+
+struct mt76_dev {
+	struct ieee80211_hw *hw;
+	struct cfg80211_chan_def chandef;
+	struct ieee80211_channel *main_chan;
+
+	spinlock_t lock;
+	spinlock_t cc_lock;
+	const struct mt76_bus_ops *bus;
+	const struct mt76_driver_ops *drv;
+	void __iomem *regs;
+	struct device *dev;
+
+	struct net_device napi_dev;
+	struct napi_struct napi[__MT_RXQ_MAX];
+	struct sk_buff_head rx_skb[__MT_RXQ_MAX];
+
+	struct list_head txwi_cache;
+	struct mt76_queue q_tx[__MT_TXQ_MAX];
+	struct mt76_queue q_rx[__MT_RXQ_MAX];
+	const struct mt76_queue_ops *queue_ops;
+
+	u8 macaddr[ETH_ALEN];
+	u32 rev;
+	unsigned long state;
+
+	struct mt76_sband sband_2g;
+	struct mt76_sband sband_5g;
+	struct debugfs_blob_wrapper eeprom;
+	struct debugfs_blob_wrapper otp;
+	struct mt76_hw_cap cap;
+
+	u32 debugfs_reg;
+};
+
+enum mt76_phy_type {
+	MT_PHY_TYPE_CCK,
+	MT_PHY_TYPE_OFDM,
+	MT_PHY_TYPE_HT,
+	MT_PHY_TYPE_HT_GF,
+	MT_PHY_TYPE_VHT,
+};
+
+struct mt76_rate_power {
+	union {
+		struct {
+			s8 cck[4];
+			s8 ofdm[8];
+			s8 ht[16];
+			s8 vht[10];
+		};
+		s8 all[38];
+	};
+};
+
+#define mt76_rr(dev, ...)	(dev)->mt76.bus->rr(&((dev)->mt76), __VA_ARGS__)
+#define mt76_wr(dev, ...)	(dev)->mt76.bus->wr(&((dev)->mt76), __VA_ARGS__)
+#define mt76_rmw(dev, ...)	(dev)->mt76.bus->rmw(&((dev)->mt76), __VA_ARGS__)
+#define mt76_wr_copy(dev, ...)	(dev)->mt76.bus->copy(&((dev)->mt76), __VA_ARGS__)
+
+#define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
+#define mt76_clear(dev, offset, val)	mt76_rmw(dev, offset, val, 0)
+
+#define mt76_get_field(_dev, _reg, _field)		\
+	FIELD_GET(_field, mt76_rr(dev, _reg))
+
+#define mt76_rmw_field(_dev, _reg, _field, _val)	\
+	mt76_rmw(_dev, _reg, _field, FIELD_PREP(_field, _val))
+
+#define mt76_hw(dev) (dev)->mt76.hw
+
+bool __mt76_poll(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+		 int timeout);
+
+#define mt76_poll(dev, ...) __mt76_poll(&((dev)->mt76), __VA_ARGS__)
+
+bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+		      int timeout);
+
+#define mt76_poll_msec(dev, ...) __mt76_poll_msec(&((dev)->mt76), __VA_ARGS__)
+
+void mt76_mmio_init(struct mt76_dev *dev, void __iomem *regs);
+
+static inline u16 mt76_chip(struct mt76_dev *dev)
+{
+	return dev->rev >> 16;
+}
+
+static inline u16 mt76_rev(struct mt76_dev *dev)
+{
+	return dev->rev & 0xffff;
+}
+
+#define mt76xx_chip(dev) mt76_chip(&((dev)->mt76))
+#define mt76xx_rev(dev) mt76_rev(&((dev)->mt76))
+
+#define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
+#define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
+
+static inline struct mt76_channel_state *
+mt76_channel_state(struct mt76_dev *dev, struct ieee80211_channel *c)
+{
+	struct mt76_sband *msband;
+	int idx;
+
+	if (c->band == NL80211_BAND_2GHZ)
+		msband = &dev->sband_2g;
+	else
+		msband = &dev->sband_5g;
+
+	idx = c - &msband->sband.channels[0];
+	return &msband->chan[idx];
+}
+
+int mt76_register_device(struct mt76_dev *dev, bool vht,
+			 struct ieee80211_rate *rates, int n_rates);
+void mt76_unregister_device(struct mt76_dev *dev);
+
+struct dentry *mt76_register_debugfs(struct mt76_dev *dev);
+
+int mt76_eeprom_init(struct mt76_dev *dev, int len);
+void mt76_eeprom_override(struct mt76_dev *dev);
+
+static inline struct ieee80211_txq *
+mtxq_to_txq(struct mt76_txq *mtxq)
+{
+	void *ptr = mtxq;
+
+	return container_of(ptr, struct ieee80211_txq, drv_priv);
+}
+
+int mt76_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+		      struct sk_buff *skb, struct mt76_wcid *wcid,
+		      struct ieee80211_sta *sta);
+
+void mt76_rx(struct mt76_dev *dev, enum mt76_rxq_id q, struct sk_buff *skb);
+void mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
+	     struct mt76_wcid *wcid, struct sk_buff *skb);
+void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq);
+void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq);
+void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
+			 bool send_bar);
+void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq);
+void mt76_txq_schedule_all(struct mt76_dev *dev);
+void mt76_release_buffered_frames(struct ieee80211_hw *hw,
+				  struct ieee80211_sta *sta,
+				  u16 tids, int nframes,
+				  enum ieee80211_frame_release_type reason,
+				  bool more_data);
+void mt76_set_channel(struct mt76_dev *dev);
+int mt76_get_survey(struct ieee80211_hw *hw, int idx,
+		    struct survey_info *survey);
+
+/* internal */
+void mt76_tx_free(struct mt76_dev *dev);
+void mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t);
+void mt76_rx_complete(struct mt76_dev *dev, enum mt76_rxq_id q);
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/trace.c b/drivers/net/wireless/mediatek/mt76/trace.c
new file mode 100644
index 0000000..ea4ab87
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/trace.c
@@ -0,0 +1,23 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+
+#ifndef __CHECKER__
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/trace.h b/drivers/net/wireless/mediatek/mt76/trace.h
new file mode 100644
index 0000000..ea30895
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/trace.h
@@ -0,0 +1,71 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#if !defined(__MT76_TRACE_H) || defined(TRACE_HEADER_MULTI_READ)
+#define __MT76_TRACE_H
+
+#include <linux/tracepoint.h>
+#include "mt76.h"
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mt76
+
+#define MAXNAME		32
+#define DEV_ENTRY   __array(char, wiphy_name, 32)
+#define DEV_ASSIGN  strlcpy(__entry->wiphy_name, wiphy_name(dev->hw->wiphy), MAXNAME)
+#define DEV_PR_FMT  "%s"
+#define DEV_PR_ARG  __entry->wiphy_name
+
+#define REG_ENTRY	__field(u32, reg) __field(u32, val)
+#define REG_ASSIGN	__entry->reg = reg; __entry->val = val
+#define REG_PR_FMT	" %04x=%08x"
+#define REG_PR_ARG	__entry->reg, __entry->val
+
+DECLARE_EVENT_CLASS(dev_reg_evt,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val),
+	TP_STRUCT__entry(
+		DEV_ENTRY
+		REG_ENTRY
+	),
+	TP_fast_assign(
+		DEV_ASSIGN;
+		REG_ASSIGN;
+	),
+	TP_printk(
+		DEV_PR_FMT REG_PR_FMT,
+		DEV_PR_ARG, REG_PR_ARG
+	)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_rr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+DEFINE_EVENT(dev_reg_evt, reg_wr,
+	TP_PROTO(struct mt76_dev *dev, u32 reg, u32 val),
+	TP_ARGS(dev, reg, val)
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
new file mode 100644
index 0000000..45bf0b1
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -0,0 +1,511 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include "mt76.h"
+
+static struct mt76_txwi_cache *
+mt76_alloc_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t;
+	dma_addr_t addr;
+	int size;
+
+	size = (sizeof(*t) + L1_CACHE_BYTES - 1) & ~(L1_CACHE_BYTES - 1);
+	t = devm_kzalloc(dev->dev, size, GFP_ATOMIC);
+	if (!t)
+		return NULL;
+
+	addr = dma_map_single(dev->dev, &t->txwi, sizeof(t->txwi),
+			      DMA_TO_DEVICE);
+	t->dma_addr = addr;
+
+	return t;
+}
+
+static struct mt76_txwi_cache *
+__mt76_get_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t = NULL;
+
+	spin_lock_bh(&dev->lock);
+	if (!list_empty(&dev->txwi_cache)) {
+		t = list_first_entry(&dev->txwi_cache, struct mt76_txwi_cache,
+				     list);
+		list_del(&t->list);
+	}
+	spin_unlock_bh(&dev->lock);
+
+	return t;
+}
+
+static struct mt76_txwi_cache *
+mt76_get_txwi(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t = __mt76_get_txwi(dev);
+
+	if (t)
+		return t;
+
+	return mt76_alloc_txwi(dev);
+}
+
+void
+mt76_put_txwi(struct mt76_dev *dev, struct mt76_txwi_cache *t)
+{
+	if (!t)
+		return;
+
+	spin_lock_bh(&dev->lock);
+	list_add(&t->list, &dev->txwi_cache);
+	spin_unlock_bh(&dev->lock);
+}
+
+void mt76_tx_free(struct mt76_dev *dev)
+{
+	struct mt76_txwi_cache *t;
+
+	while ((t = __mt76_get_txwi(dev)) != NULL)
+		dma_unmap_single(dev->dev, t->dma_addr, sizeof(t->txwi),
+				 DMA_TO_DEVICE);
+}
+
+static int
+mt76_txq_get_qid(struct ieee80211_txq *txq)
+{
+	if (!txq->sta)
+		return MT_TXQ_BE;
+
+	return txq->ac;
+}
+
+int mt76_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
+		      struct sk_buff *skb, struct mt76_wcid *wcid,
+		      struct ieee80211_sta *sta)
+{
+	struct mt76_queue_entry e;
+	struct mt76_txwi_cache *t;
+	struct mt76_queue_buf buf[32];
+	struct sk_buff *iter;
+	dma_addr_t addr;
+	int len;
+	u32 tx_info = 0;
+	int n, ret;
+
+	t = mt76_get_txwi(dev);
+	if (!t) {
+		ieee80211_free_txskb(dev->hw, skb);
+		return -ENOMEM;
+	}
+
+	dma_sync_single_for_cpu(dev->dev, t->dma_addr, sizeof(t->txwi),
+				DMA_TO_DEVICE);
+	ret = dev->drv->tx_prepare_skb(dev, &t->txwi, skb, q, wcid, sta,
+				       &tx_info);
+	dma_sync_single_for_device(dev->dev, t->dma_addr, sizeof(t->txwi),
+				   DMA_TO_DEVICE);
+	if (ret < 0)
+		goto free;
+
+	len = skb->len - skb->data_len;
+	addr = dma_map_single(dev->dev, skb->data, len, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev->dev, addr)) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
+	n = 0;
+	buf[n].addr = t->dma_addr;
+	buf[n++].len = dev->drv->txwi_size;
+	buf[n].addr = addr;
+	buf[n++].len = len;
+
+	skb_walk_frags(skb, iter) {
+		if (n == ARRAY_SIZE(buf))
+			goto unmap;
+
+		addr = dma_map_single(dev->dev, iter->data, iter->len,
+				      DMA_TO_DEVICE);
+		if (dma_mapping_error(dev->dev, addr))
+			goto unmap;
+
+		buf[n].addr = addr;
+		buf[n++].len = iter->len;
+	}
+
+	if (q->queued + (n + 1) / 2 >= q->ndesc - 1)
+		goto unmap;
+
+	return dev->queue_ops->add_buf(dev, q, buf, n, tx_info, skb, t);
+
+unmap:
+	ret = -ENOMEM;
+	for (n--; n > 0; n--)
+		dma_unmap_single(dev->dev, buf[n].addr, buf[n].len,
+				 DMA_TO_DEVICE);
+
+free:
+	e.skb = skb;
+	e.txwi = t;
+	dev->drv->tx_complete_skb(dev, q, &e, true);
+	mt76_put_txwi(dev, t);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mt76_tx_queue_skb);
+
+void
+mt76_tx(struct mt76_dev *dev, struct ieee80211_sta *sta,
+	struct mt76_wcid *wcid, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76_queue *q;
+	int qid = skb_get_queue_mapping(skb);
+
+	if (WARN_ON(qid >= MT_TXQ_PSD)) {
+		qid = MT_TXQ_BE;
+		skb_set_queue_mapping(skb, qid);
+	}
+
+	if (!wcid->tx_rate_set)
+		ieee80211_get_tx_rates(info->control.vif, sta, skb,
+				       info->control.rates, 1);
+
+	q = &dev->q_tx[qid];
+
+	spin_lock_bh(&q->lock);
+	mt76_tx_queue_skb(dev, q, skb, wcid, sta);
+	dev->queue_ops->kick(dev, q);
+
+	if (q->queued > q->ndesc - 8)
+		ieee80211_stop_queue(dev->hw, skb_get_queue_mapping(skb));
+	spin_unlock_bh(&q->lock);
+}
+EXPORT_SYMBOL_GPL(mt76_tx);
+
+static struct sk_buff *
+mt76_txq_dequeue(struct mt76_dev *dev, struct mt76_txq *mtxq, bool ps)
+{
+	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
+	struct sk_buff *skb;
+
+	skb = skb_dequeue(&mtxq->retry_q);
+	if (skb) {
+		u8 tid = skb->priority & IEEE80211_QOS_CTL_TID_MASK;
+
+		if (ps && skb_queue_empty(&mtxq->retry_q))
+			ieee80211_sta_set_buffered(txq->sta, tid, false);
+
+		return skb;
+	}
+
+	skb = ieee80211_tx_dequeue(dev->hw, txq);
+	if (!skb)
+		return NULL;
+
+	return skb;
+}
+
+static void
+mt76_check_agg_ssn(struct mt76_txq *mtxq, struct sk_buff *skb)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return;
+
+	mtxq->agg_ssn = le16_to_cpu(hdr->seq_ctrl) + 0x10;
+}
+
+static void
+mt76_queue_ps_skb(struct mt76_dev *dev, struct ieee80211_sta *sta,
+		  struct sk_buff *skb, bool last)
+{
+	struct mt76_wcid *wcid = (struct mt76_wcid *) sta->drv_priv;
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
+
+	info->control.flags |= IEEE80211_TX_CTRL_PS_RESPONSE;
+	if (last)
+		info->flags |= IEEE80211_TX_STATUS_EOSP;
+
+	mt76_skb_set_moredata(skb, !last);
+	mt76_tx_queue_skb(dev, hwq, skb, wcid, sta);
+}
+
+void
+mt76_release_buffered_frames(struct ieee80211_hw *hw, struct ieee80211_sta *sta,
+			     u16 tids, int nframes,
+			     enum ieee80211_frame_release_type reason,
+			     bool more_data)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct sk_buff *last_skb = NULL;
+	struct mt76_queue *hwq = &dev->q_tx[MT_TXQ_PSD];
+	int i;
+
+	spin_lock_bh(&hwq->lock);
+	for (i = 0; tids && nframes; i++, tids >>= 1) {
+		struct ieee80211_txq *txq = sta->txq[i];
+		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+		struct sk_buff *skb;
+
+		if (!(tids & 1))
+			continue;
+
+		do {
+			skb = mt76_txq_dequeue(dev, mtxq, true);
+			if (!skb)
+				break;
+
+			if (mtxq->aggr)
+				mt76_check_agg_ssn(mtxq, skb);
+
+			nframes--;
+			if (last_skb)
+				mt76_queue_ps_skb(dev, sta, last_skb, false);
+
+			last_skb = skb;
+		} while (nframes);
+	}
+
+	if (last_skb) {
+		mt76_queue_ps_skb(dev, sta, last_skb, true);
+		dev->queue_ops->kick(dev, hwq);
+	}
+	spin_unlock_bh(&hwq->lock);
+}
+EXPORT_SYMBOL_GPL(mt76_release_buffered_frames);
+
+static int
+mt76_txq_send_burst(struct mt76_dev *dev, struct mt76_queue *hwq,
+		    struct mt76_txq *mtxq, bool *empty)
+{
+	struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
+	struct ieee80211_tx_info *info;
+	struct mt76_wcid *wcid = mtxq->wcid;
+	struct sk_buff *skb = NULL;
+	int n_frames = 1, limit;
+	struct ieee80211_tx_rate tx_rate;
+	bool ampdu;
+	bool probe;
+	int idx;
+
+	skb = mt76_txq_dequeue(dev, mtxq, false);
+	if (!skb) {
+		*empty = true;
+		return 0;
+	}
+
+	info = IEEE80211_SKB_CB(skb);
+	if (!wcid->tx_rate_set)
+		ieee80211_get_tx_rates(txq->vif, txq->sta, skb,
+				       info->control.rates, 1);
+	tx_rate = info->control.rates[0];
+
+	probe = (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE);
+	ampdu = IEEE80211_SKB_CB(skb)->flags & IEEE80211_TX_CTL_AMPDU;
+	limit = ampdu ? 16 : 3;
+
+	if (ampdu)
+		mt76_check_agg_ssn(mtxq, skb);
+
+	idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+
+	if (idx < 0)
+		return idx;
+
+	do {
+		bool cur_ampdu;
+
+		if (probe)
+			break;
+
+		skb = mt76_txq_dequeue(dev, mtxq, false);
+		if (!skb) {
+			*empty = true;
+			break;
+		}
+
+		cur_ampdu = info->flags & IEEE80211_TX_CTL_AMPDU;
+
+		if (ampdu != cur_ampdu ||
+		    (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)) {
+			skb_queue_tail(&mtxq->retry_q, skb);
+			break;
+		}
+
+		info = IEEE80211_SKB_CB(skb);
+		info->control.rates[0] = tx_rate;
+
+		if (cur_ampdu)
+			mt76_check_agg_ssn(mtxq, skb);
+
+		idx = mt76_tx_queue_skb(dev, hwq, skb, wcid, txq->sta);
+		if (idx < 0)
+			return idx;
+
+		n_frames++;
+	} while (n_frames < limit);
+
+	if (!probe) {
+		hwq->swq_queued++;
+		hwq->entry[idx].schedule = true;
+	}
+
+	dev->queue_ops->kick(dev, hwq);
+
+	return n_frames;
+}
+
+static int
+mt76_txq_schedule_list(struct mt76_dev *dev, struct mt76_queue *hwq)
+{
+	struct mt76_txq *mtxq, *mtxq_last;
+	int len = 0;
+
+restart:
+	mtxq_last = list_last_entry(&hwq->swq, struct mt76_txq, list);
+	while (!list_empty(&hwq->swq)) {
+		bool empty = false;
+		int cur;
+
+		mtxq = list_first_entry(&hwq->swq, struct mt76_txq, list);
+		if (mtxq->send_bar && mtxq->aggr) {
+			struct ieee80211_txq *txq = mtxq_to_txq(mtxq);
+			struct ieee80211_sta *sta = txq->sta;
+			struct ieee80211_vif *vif = txq->vif;
+			u16 agg_ssn = mtxq->agg_ssn;
+			u8 tid = txq->tid;
+
+			mtxq->send_bar = false;
+			spin_unlock_bh(&hwq->lock);
+			ieee80211_send_bar(vif, sta->addr, tid, agg_ssn);
+			spin_lock_bh(&hwq->lock);
+			goto restart;
+		}
+
+		list_del_init(&mtxq->list);
+
+		cur = mt76_txq_send_burst(dev, hwq, mtxq, &empty);
+		if (!empty)
+			list_add_tail(&mtxq->list, &hwq->swq);
+
+		if (cur < 0)
+			return cur;
+
+		len += cur;
+
+		if (mtxq == mtxq_last)
+			break;
+	}
+
+	return len;
+}
+
+void mt76_txq_schedule(struct mt76_dev *dev, struct mt76_queue *hwq)
+{
+	int len;
+
+	if (test_bit(MT76_SCANNING, &dev->state) ||
+	    test_bit(MT76_RESET, &dev->state))
+		return;
+
+	do {
+		if (hwq->swq_queued >= 4 || list_empty(&hwq->swq))
+			break;
+
+		len = mt76_txq_schedule_list(dev, hwq);
+	} while (len > 0);
+}
+EXPORT_SYMBOL_GPL(mt76_txq_schedule);
+
+void mt76_txq_schedule_all(struct mt76_dev *dev)
+{
+	int i;
+
+	for (i = 0; i <= MT_TXQ_BK; i++) {
+		struct mt76_queue *q = &dev->q_tx[i];
+
+		spin_lock_bh(&q->lock);
+		mt76_txq_schedule(dev, q);
+		spin_unlock_bh(&q->lock);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_txq_schedule_all);
+
+void mt76_stop_tx_queues(struct mt76_dev *dev, struct ieee80211_sta *sta,
+			 bool send_bar)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sta->txq); i++) {
+		struct ieee80211_txq *txq = sta->txq[i];
+		struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+
+		spin_lock_bh(&mtxq->hwq->lock);
+		mtxq->send_bar = mtxq->aggr && send_bar;
+		if (!list_empty(&mtxq->list))
+			list_del_init(&mtxq->list);
+		spin_unlock_bh(&mtxq->hwq->lock);
+	}
+}
+EXPORT_SYMBOL_GPL(mt76_stop_tx_queues);
+
+void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
+{
+	struct mt76_dev *dev = hw->priv;
+	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+	struct mt76_queue *hwq = mtxq->hwq;
+
+	spin_lock_bh(&hwq->lock);
+	if (list_empty(&mtxq->list))
+		list_add_tail(&mtxq->list, &hwq->swq);
+	mt76_txq_schedule(dev, hwq);
+	spin_unlock_bh(&hwq->lock);
+}
+EXPORT_SYMBOL_GPL(mt76_wake_tx_queue);
+
+void mt76_txq_remove(struct mt76_dev *dev, struct ieee80211_txq *txq)
+{
+	struct mt76_txq *mtxq;
+	struct mt76_queue *hwq;
+	struct sk_buff *skb;
+
+	if (!txq)
+		return;
+
+	mtxq = (struct mt76_txq *) txq->drv_priv;
+	hwq = mtxq->hwq;
+
+	spin_lock_bh(&hwq->lock);
+	if (!list_empty(&mtxq->list))
+		list_del(&mtxq->list);
+	spin_unlock_bh(&hwq->lock);
+
+	while ((skb = skb_dequeue(&mtxq->retry_q)) != NULL)
+		ieee80211_free_txskb(dev->hw, skb);
+}
+EXPORT_SYMBOL_GPL(mt76_txq_remove);
+
+void mt76_txq_init(struct mt76_dev *dev, struct ieee80211_txq *txq)
+{
+	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
+
+	INIT_LIST_HEAD(&mtxq->list);
+	skb_queue_head_init(&mtxq->retry_q);
+
+	mtxq->hwq = &dev->q_tx[mt76_txq_get_qid(txq)];
+}
+EXPORT_SYMBOL_GPL(mt76_txq_init);
diff --git a/drivers/net/wireless/mediatek/mt76/util.c b/drivers/net/wireless/mediatek/mt76/util.c
new file mode 100644
index 0000000..0c35b8d
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/util.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include "mt76.h"
+
+bool __mt76_poll(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+		 int timeout)
+{
+	u32 cur;
+
+	timeout /= 10;
+	do {
+		cur = dev->bus->rr(dev, offset) & mask;
+		if (cur == val)
+			return true;
+
+		udelay(10);
+	} while (timeout-- > 0);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(__mt76_poll);
+
+bool __mt76_poll_msec(struct mt76_dev *dev, u32 offset, u32 mask, u32 val,
+		      int timeout)
+{
+	u32 cur;
+
+	timeout /= 10;
+	do {
+		cur = dev->bus->rr(dev, offset) & mask;
+		if (cur == val)
+			return true;
+
+		usleep_range(10000, 20000);
+	} while (timeout-- > 0);
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(__mt76_poll_msec);
+
+int mt76_wcid_alloc(unsigned long *mask, int size)
+{
+	int i, idx = 0, cur;
+
+	for (i = 0; i < size / BITS_PER_LONG; i++) {
+		idx = ffs(~mask[i]);
+		if (!idx)
+			continue;
+
+		idx--;
+		cur = i * BITS_PER_LONG + idx;
+		if (cur >= size)
+			break;
+
+		mask[i] |= BIT(idx);
+		return cur;
+	}
+
+	return -1;
+}
+EXPORT_SYMBOL_GPL(mt76_wcid_alloc);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/net/wireless/mediatek/mt76/util.h b/drivers/net/wireless/mediatek/mt76/util.h
new file mode 100644
index 0000000..018d475
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/util.h
@@ -0,0 +1,44 @@
+/*
+ * Copyright (C) 2016 Felix Fietkau <nbd@nbd.name>
+ * Copyright (C) 2004 - 2009 Ivo van Doorn <IvDoorn@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef __MT76_UTIL_H
+#define __MT76_UTIL_H
+
+#include <linux/skbuff.h>
+#include <linux/bitops.h>
+#include <linux/bitfield.h>
+
+#define MT76_INCR(_var, _size) \
+	_var = (((_var) + 1) % _size)
+
+int mt76_wcid_alloc(unsigned long *mask, int size);
+
+static inline void
+mt76_wcid_free(unsigned long *mask, int idx)
+{
+	mask[idx / BITS_PER_LONG] &= ~BIT(idx % BITS_PER_LONG);
+}
+
+static inline void
+mt76_skb_set_moredata(struct sk_buff *skb, bool enable)
+{
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+
+	if (enable)
+		hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+	else
+		hdr->frame_control &= ~cpu_to_le16(IEEE80211_FCTL_MOREDATA);
+}
+
+#endif
-- 
2.8.4
