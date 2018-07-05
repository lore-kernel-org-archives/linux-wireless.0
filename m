Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41156 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753151AbeGEGMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 02:12:54 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        Michal Schmidt <mschmidt@redhat.com>,
        linux-mediatek@lists.infradead.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 10/11] mt76x0: dma and tx files
Date: Thu,  5 Jul 2018 08:12:21 +0200
Message-Id: <1530771142-4118-11-git-send-email-sgruszka@redhat.com> (sfid-20180705_081306_528045_5F0F971E)
In-Reply-To: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
References: <1530771142-4118-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add dma and tx files of mt76x0 driver.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c | 522 ++++++++++++++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h | 126 ++++++
 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c  | 270 ++++++++++++
 3 files changed, 918 insertions(+)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/tx.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
new file mode 100644
index 000000000000..2cf71283de3f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.c
@@ -0,0 +1,522 @@
+/*
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ * Copyright (C) 2018 Stanislaw Gruszka <stf_xl@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "mt76x0.h"
+#include "dma.h"
+#include "usb.h"
+#include "trace.h"
+
+static int mt76x0_submit_rx_buf(struct mt76x0_dev *dev,
+				 struct mt76x0_dma_buf_rx *e, gfp_t gfp);
+
+static unsigned int ieee80211_get_hdrlen_from_buf(const u8 *data, unsigned len)
+{
+	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *)data;
+	unsigned int hdrlen;
+
+	if (unlikely(len < 10))
+		return 0;
+	hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	if (unlikely(hdrlen > len))
+		return 0;
+	return hdrlen;
+}
+
+static struct sk_buff *
+mt76x0_rx_skb_from_seg(struct mt76x0_dev *dev, struct mt76x0_rxwi *rxwi,
+			void *data, u32 seg_len, u32 truesize, struct page *p)
+{
+	struct sk_buff *skb;
+	u32 true_len, hdr_len = 0, copy, frag;
+
+	skb = alloc_skb(p ? 128 : seg_len, GFP_ATOMIC);
+	if (!skb)
+		return NULL;
+
+	true_len = mt76_mac_process_rx(dev, skb, data, rxwi);
+	if (!true_len || true_len > seg_len)
+		goto bad_frame;
+
+	hdr_len = ieee80211_get_hdrlen_from_buf(data, true_len);
+	if (!hdr_len)
+		goto bad_frame;
+
+	if (rxwi->rxinfo & cpu_to_le32(MT_RXINFO_L2PAD)) {
+		memcpy(skb_put(skb, hdr_len), data, hdr_len);
+
+		data += hdr_len + 2;
+		true_len -= hdr_len;
+		hdr_len = 0;
+	}
+
+	/* If not doing paged RX allocated skb will always have enough space */
+	copy = (true_len <= skb_tailroom(skb)) ? true_len : hdr_len + 8;
+	frag = true_len - copy;
+
+	memcpy(skb_put(skb, copy), data, copy);
+	data += copy;
+
+	if (frag) {
+		skb_add_rx_frag(skb, 0, p, data - page_address(p),
+				frag, truesize);
+		get_page(p);
+	}
+
+	return skb;
+
+bad_frame:
+	dev_err_ratelimited(dev->mt76.dev, "Error: incorrect frame len:%u hdr:%u\n",
+			    true_len, hdr_len);
+	dev_kfree_skb(skb);
+	return NULL;
+}
+
+static void mt76x0_rx_process_seg(struct mt76x0_dev *dev, u8 *data,
+				   u32 seg_len, struct page *p)
+{
+	struct sk_buff *skb;
+	struct mt76x0_rxwi *rxwi;
+	u32 fce_info, truesize = seg_len;
+
+	/* DMA_INFO field at the beginning of the segment contains only some of
+	 * the information, we need to read the FCE descriptor from the end.
+	 */
+	fce_info = get_unaligned_le32(data + seg_len - MT_FCE_INFO_LEN);
+	seg_len -= MT_FCE_INFO_LEN;
+
+	data += MT_DMA_HDR_LEN;
+	seg_len -= MT_DMA_HDR_LEN;
+
+	rxwi = (struct mt76x0_rxwi *) data;
+	data += sizeof(struct mt76x0_rxwi);
+	seg_len -= sizeof(struct mt76x0_rxwi);
+
+	if (unlikely(FIELD_GET(MT_RXD_INFO_TYPE, fce_info)))
+		dev_err_once(dev->mt76.dev, "Error: RX path seen a non-pkt urb\n");
+
+	trace_mt_rx(&dev->mt76, rxwi, fce_info);
+
+	skb = mt76x0_rx_skb_from_seg(dev, rxwi, data, seg_len, truesize, p);
+	if (!skb)
+		return;
+
+	spin_lock(&dev->mac_lock);
+	ieee80211_rx(dev->mt76.hw, skb);
+	spin_unlock(&dev->mac_lock);
+}
+
+static u16 mt76x0_rx_next_seg_len(u8 *data, u32 data_len)
+{
+	u32 min_seg_len = MT_DMA_HDR_LEN + MT_RX_INFO_LEN +
+		sizeof(struct mt76x0_rxwi) + MT_FCE_INFO_LEN;
+	u16 dma_len = get_unaligned_le16(data);
+
+	if (data_len < min_seg_len ||
+	    WARN_ON(!dma_len) ||
+	    WARN_ON(dma_len + MT_DMA_HDRS > data_len) ||
+	    WARN_ON(dma_len & 0x3))
+		return 0;
+
+	return MT_DMA_HDRS + dma_len;
+}
+
+static void
+mt76x0_rx_process_entry(struct mt76x0_dev *dev, struct mt76x0_dma_buf_rx *e)
+{
+	u32 seg_len, data_len = e->urb->actual_length;
+	u8 *data = page_address(e->p);
+	struct page *new_p = NULL;
+	int cnt = 0;
+
+	if (!test_bit(MT76_STATE_INITIALIZED, &dev->mt76.state))
+		return;
+
+	/* Copy if there is very little data in the buffer. */
+	if (data_len > 512)
+		new_p = dev_alloc_pages(MT_RX_ORDER);
+
+	while ((seg_len = mt76x0_rx_next_seg_len(data, data_len))) {
+		mt76x0_rx_process_seg(dev, data, seg_len, new_p ? e->p : NULL);
+
+		data_len -= seg_len;
+		data += seg_len;
+		cnt++;
+	}
+
+	if (cnt > 1)
+		trace_mt_rx_dma_aggr(&dev->mt76, cnt, !!new_p);
+
+	if (new_p) {
+		/* we have one extra ref from the allocator */
+		__free_pages(e->p, MT_RX_ORDER);
+
+		e->p = new_p;
+	}
+}
+
+static struct mt76x0_dma_buf_rx *
+mt76x0_rx_get_pending_entry(struct mt76x0_dev *dev)
+{
+	struct mt76x0_rx_queue *q = &dev->rx_q;
+	struct mt76x0_dma_buf_rx *buf = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->rx_lock, flags);
+
+	if (!q->pending)
+		goto out;
+
+	buf = &q->e[q->start];
+	q->pending--;
+	q->start = (q->start + 1) % q->entries;
+out:
+	spin_unlock_irqrestore(&dev->rx_lock, flags);
+
+	return buf;
+}
+
+static void mt76x0_complete_rx(struct urb *urb)
+{
+	struct mt76x0_dev *dev = urb->context;
+	struct mt76x0_rx_queue *q = &dev->rx_q;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->rx_lock, flags);
+
+	if (mt76x0_urb_has_error(urb))
+		dev_err(dev->mt76.dev, "Error: RX urb failed:%d\n", urb->status);
+	if (WARN_ONCE(q->e[q->end].urb != urb, "RX urb mismatch"))
+		goto out;
+
+	q->end = (q->end + 1) % q->entries;
+	q->pending++;
+	tasklet_schedule(&dev->rx_tasklet);
+out:
+	spin_unlock_irqrestore(&dev->rx_lock, flags);
+}
+
+static void mt76x0_rx_tasklet(unsigned long data)
+{
+	struct mt76x0_dev *dev = (struct mt76x0_dev *) data;
+	struct mt76x0_dma_buf_rx *e;
+
+	while ((e = mt76x0_rx_get_pending_entry(dev))) {
+		if (e->urb->status)
+			continue;
+
+		mt76x0_rx_process_entry(dev, e);
+		mt76x0_submit_rx_buf(dev, e, GFP_ATOMIC);
+	}
+}
+
+static void mt76x0_complete_tx(struct urb *urb)
+{
+	struct mt76x0_tx_queue *q = urb->context;
+	struct mt76x0_dev *dev = q->dev;
+	struct sk_buff *skb;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+
+	if (mt76x0_urb_has_error(urb))
+		dev_err(dev->mt76.dev, "Error: TX urb failed:%d\n", urb->status);
+	if (WARN_ONCE(q->e[q->start].urb != urb, "TX urb mismatch"))
+		goto out;
+
+	skb = q->e[q->start].skb;
+	trace_mt_tx_dma_done(&dev->mt76, skb);
+
+	__skb_queue_tail(&dev->tx_skb_done, skb);
+	tasklet_schedule(&dev->tx_tasklet);
+
+	if (q->used == q->entries - q->entries / 8)
+		ieee80211_wake_queue(dev->mt76.hw, skb_get_queue_mapping(skb));
+
+	q->start = (q->start + 1) % q->entries;
+	q->used--;
+out:
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+}
+
+static void mt76x0_tx_tasklet(unsigned long data)
+{
+	struct mt76x0_dev *dev = (struct mt76x0_dev *) data;
+	struct sk_buff_head skbs;
+	unsigned long flags;
+
+	__skb_queue_head_init(&skbs);
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+
+	set_bit(MT76_MORE_STATS, &dev->mt76.state);
+	if (!test_and_set_bit(MT76_READING_STATS, &dev->mt76.state))
+		queue_delayed_work(dev->stat_wq, &dev->stat_work,
+				   msecs_to_jiffies(10));
+
+	skb_queue_splice_init(&dev->tx_skb_done, &skbs);
+
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+	while (!skb_queue_empty(&skbs)) {
+		struct sk_buff *skb = __skb_dequeue(&skbs);
+
+		mt76x0_tx_status(dev, skb);
+	}
+}
+
+static int mt76x0_dma_submit_tx(struct mt76x0_dev *dev,
+				 struct sk_buff *skb, u8 ep)
+{
+	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
+	unsigned snd_pipe = usb_sndbulkpipe(usb_dev, dev->out_ep[ep]);
+	struct mt76x0_dma_buf_tx *e;
+	struct mt76x0_tx_queue *q = &dev->tx_q[ep];
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+
+	if (WARN_ON_ONCE(q->entries <= q->used)) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	e = &q->e[q->end];
+	e->skb = skb;
+	usb_fill_bulk_urb(e->urb, usb_dev, snd_pipe, skb->data, skb->len,
+			  mt76x0_complete_tx, q);
+	ret = usb_submit_urb(e->urb, GFP_ATOMIC);
+	if (ret) {
+		/* Special-handle ENODEV from TX urb submission because it will
+		 * often be the first ENODEV we see after device is removed.
+		 */
+		if (ret == -ENODEV)
+			set_bit(MT76_REMOVED, &dev->mt76.state);
+		else
+			dev_err(dev->mt76.dev, "Error: TX urb submit failed:%d\n",
+				ret);
+		goto out;
+	}
+
+	q->end = (q->end + 1) % q->entries;
+	q->used++;
+
+	if (q->used >= q->entries)
+		ieee80211_stop_queue(dev->mt76.hw, skb_get_queue_mapping(skb));
+out:
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+
+	return ret;
+}
+
+/* Map USB endpoint number to Q id in the DMA engine */
+static enum mt76_qsel ep2dmaq(u8 ep)
+{
+	if (ep == 5)
+		return MT_QSEL_MGMT;
+	return MT_QSEL_EDCA;
+}
+
+int mt76x0_dma_enqueue_tx(struct mt76x0_dev *dev, struct sk_buff *skb,
+			   struct mt76_wcid *wcid, int hw_q)
+{
+	u8 ep = q2ep(hw_q);
+	u32 dma_flags;
+	int ret;
+
+	dma_flags = MT_TXD_PKT_INFO_80211;
+	if (wcid->hw_key_idx == 0xff)
+		dma_flags |= MT_TXD_PKT_INFO_WIV;
+
+	ret = mt76x0_dma_skb_wrap_pkt(skb, ep2dmaq(ep), dma_flags);
+	if (ret)
+		return ret;
+
+	ret = mt76x0_dma_submit_tx(dev, skb, ep);
+
+	if (ret) {
+		ieee80211_free_txskb(dev->mt76.hw, skb);
+		return ret;
+	}
+
+	return 0;
+}
+
+static void mt76x0_kill_rx(struct mt76x0_dev *dev)
+{
+	int i;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->rx_lock, flags);
+
+	for (i = 0; i < dev->rx_q.entries; i++) {
+		int next = dev->rx_q.end;
+
+		spin_unlock_irqrestore(&dev->rx_lock, flags);
+		usb_poison_urb(dev->rx_q.e[next].urb);
+		spin_lock_irqsave(&dev->rx_lock, flags);
+	}
+
+	spin_unlock_irqrestore(&dev->rx_lock, flags);
+}
+
+static int mt76x0_submit_rx_buf(struct mt76x0_dev *dev,
+				 struct mt76x0_dma_buf_rx *e, gfp_t gfp)
+{
+	struct usb_device *usb_dev = mt76x0_to_usb_dev(dev);
+	u8 *buf = page_address(e->p);
+	unsigned pipe;
+	int ret;
+
+	pipe = usb_rcvbulkpipe(usb_dev, dev->in_ep[MT_EP_IN_PKT_RX]);
+
+	usb_fill_bulk_urb(e->urb, usb_dev, pipe, buf, MT_RX_URB_SIZE,
+			  mt76x0_complete_rx, dev);
+
+	trace_mt_submit_urb(&dev->mt76, e->urb);
+	ret = usb_submit_urb(e->urb, gfp);
+	if (ret)
+		dev_err(dev->mt76.dev, "Error: submit RX URB failed:%d\n", ret);
+
+	return ret;
+}
+
+static int mt76x0_submit_rx(struct mt76x0_dev *dev)
+{
+	int i, ret;
+
+	for (i = 0; i < dev->rx_q.entries; i++) {
+		ret = mt76x0_submit_rx_buf(dev, &dev->rx_q.e[i], GFP_KERNEL);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void mt76x0_free_rx(struct mt76x0_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < dev->rx_q.entries; i++) {
+		__free_pages(dev->rx_q.e[i].p, MT_RX_ORDER);
+		usb_free_urb(dev->rx_q.e[i].urb);
+	}
+}
+
+static int mt76x0_alloc_rx(struct mt76x0_dev *dev)
+{
+	int i;
+
+	memset(&dev->rx_q, 0, sizeof(dev->rx_q));
+	dev->rx_q.dev = dev;
+	dev->rx_q.entries = N_RX_ENTRIES;
+
+	for (i = 0; i < N_RX_ENTRIES; i++) {
+		dev->rx_q.e[i].urb = usb_alloc_urb(0, GFP_KERNEL);
+		dev->rx_q.e[i].p = dev_alloc_pages(MT_RX_ORDER);
+
+		if (!dev->rx_q.e[i].urb || !dev->rx_q.e[i].p)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void mt76x0_free_tx_queue(struct mt76x0_tx_queue *q)
+{
+	int i;
+
+	WARN_ON(q->used);
+
+	for (i = 0; i < q->entries; i++)  {
+		usb_poison_urb(q->e[i].urb);
+		usb_free_urb(q->e[i].urb);
+	}
+}
+
+static void mt76x0_free_tx(struct mt76x0_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < __MT_EP_OUT_MAX; i++)
+		mt76x0_free_tx_queue(&dev->tx_q[i]);
+}
+
+static int mt76x0_alloc_tx_queue(struct mt76x0_dev *dev,
+				  struct mt76x0_tx_queue *q)
+{
+	int i;
+
+	q->dev = dev;
+	q->entries = N_TX_ENTRIES;
+
+	for (i = 0; i < N_TX_ENTRIES; i++) {
+		q->e[i].urb = usb_alloc_urb(0, GFP_KERNEL);
+		if (!q->e[i].urb)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int mt76x0_alloc_tx(struct mt76x0_dev *dev)
+{
+	int i;
+
+	dev->tx_q = devm_kcalloc(dev->mt76.dev, __MT_EP_OUT_MAX,
+				 sizeof(*dev->tx_q), GFP_KERNEL);
+
+	for (i = 0; i < __MT_EP_OUT_MAX; i++)
+		if (mt76x0_alloc_tx_queue(dev, &dev->tx_q[i]))
+			return -ENOMEM;
+
+	return 0;
+}
+
+int mt76x0_dma_init(struct mt76x0_dev *dev)
+{
+	int ret = -ENOMEM;
+
+	tasklet_init(&dev->tx_tasklet, mt76x0_tx_tasklet, (unsigned long) dev);
+	tasklet_init(&dev->rx_tasklet, mt76x0_rx_tasklet, (unsigned long) dev);
+
+	ret = mt76x0_alloc_tx(dev);
+	if (ret)
+		goto err;
+	ret = mt76x0_alloc_rx(dev);
+	if (ret)
+		goto err;
+
+	ret = mt76x0_submit_rx(dev);
+	if (ret)
+		goto err;
+
+	return 0;
+err:
+	mt76x0_dma_cleanup(dev);
+	return ret;
+}
+
+void mt76x0_dma_cleanup(struct mt76x0_dev *dev)
+{
+	mt76x0_kill_rx(dev);
+
+	tasklet_kill(&dev->rx_tasklet);
+
+	mt76x0_free_rx(dev);
+	mt76x0_free_tx(dev);
+
+	tasklet_kill(&dev->tx_tasklet);
+}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
new file mode 100644
index 000000000000..891ce1c3461f
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/dma.h
@@ -0,0 +1,126 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
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
+#ifndef __MT76X0U_DMA_H
+#define __MT76X0U_DMA_H
+
+#include <asm/unaligned.h>
+#include <linux/skbuff.h>
+
+#define MT_DMA_HDR_LEN			4
+#define MT_RX_INFO_LEN			4
+#define MT_FCE_INFO_LEN			4
+#define MT_DMA_HDRS			(MT_DMA_HDR_LEN + MT_RX_INFO_LEN)
+
+/* Common Tx DMA descriptor fields */
+#define MT_TXD_INFO_LEN		GENMASK(15, 0)
+#define MT_TXD_INFO_D_PORT	GENMASK(29, 27)
+#define MT_TXD_INFO_TYPE	GENMASK(31, 30)
+
+/* Tx DMA MCU command specific flags */
+#define MT_TXD_CMD_SEQ		GENMASK(19, 16)
+#define MT_TXD_CMD_TYPE		GENMASK(26, 20)
+
+enum mt76_msg_port {
+	WLAN_PORT,
+	CPU_RX_PORT,
+	CPU_TX_PORT,
+	HOST_PORT,
+	VIRTUAL_CPU_RX_PORT,
+	VIRTUAL_CPU_TX_PORT,
+	DISCARD,
+};
+
+enum mt76_info_type {
+	DMA_PACKET,
+	DMA_COMMAND,
+};
+
+/* Tx DMA packet specific flags */
+#define MT_TXD_PKT_INFO_NEXT_VLD	BIT(16)
+#define MT_TXD_PKT_INFO_TX_BURST	BIT(17)
+#define MT_TXD_PKT_INFO_80211		BIT(19)
+#define MT_TXD_PKT_INFO_TSO		BIT(20)
+#define MT_TXD_PKT_INFO_CSO		BIT(21)
+#define MT_TXD_PKT_INFO_WIV		BIT(24)
+#define MT_TXD_PKT_INFO_QSEL		GENMASK(26, 25)
+
+enum mt76_qsel {
+	MT_QSEL_MGMT,
+	MT_QSEL_HCCA,
+	MT_QSEL_EDCA,
+	MT_QSEL_EDCA_2,
+};
+
+
+static inline int mt76x0_dma_skb_wrap(struct sk_buff *skb,
+				       enum mt76_msg_port d_port,
+				       enum mt76_info_type type, u32 flags)
+{
+	u32 info;
+
+	/* Buffer layout:
+	 *	|   4B   | xfer len |      pad       |  4B  |
+	 *	| TXINFO | pkt/cmd  | zero pad to 4B | zero |
+	 *
+	 * length field of TXINFO should be set to 'xfer len'.
+	 */
+
+	info = flags |
+		FIELD_PREP(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
+		FIELD_PREP(MT_TXD_INFO_D_PORT, d_port) |
+		FIELD_PREP(MT_TXD_INFO_TYPE, type);
+
+	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
+	return skb_put_padto(skb, round_up(skb->len, 4) + 4);
+}
+
+static inline int
+mt76x0_dma_skb_wrap_pkt(struct sk_buff *skb, enum mt76_qsel qsel, u32 flags)
+{
+	flags |= FIELD_PREP(MT_TXD_PKT_INFO_QSEL, qsel);
+	return mt76x0_dma_skb_wrap(skb, WLAN_PORT, DMA_PACKET, flags);
+}
+
+/* Common Rx DMA descriptor fields */
+#define MT_RXD_INFO_LEN			GENMASK(13, 0)
+#define MT_RXD_INFO_PCIE_INTR		BIT(24)
+#define MT_RXD_INFO_QSEL		GENMASK(26, 25)
+#define MT_RXD_INFO_PORT		GENMASK(29, 27)
+#define MT_RXD_INFO_TYPE		GENMASK(31, 30)
+
+/* Rx DMA packet specific flags */
+#define MT_RXD_PKT_INFO_UDP_ERR		BIT(16)
+#define MT_RXD_PKT_INFO_TCP_ERR		BIT(17)
+#define MT_RXD_PKT_INFO_IP_ERR		BIT(18)
+#define MT_RXD_PKT_INFO_PKT_80211	BIT(19)
+#define MT_RXD_PKT_INFO_L3L4_DONE	BIT(20)
+#define MT_RXD_PKT_INFO_MAC_LEN		GENMASK(23, 21)
+
+/* Rx DMA MCU command specific flags */
+#define MT_RXD_CMD_INFO_SELF_GEN	BIT(15)
+#define MT_RXD_CMD_INFO_CMD_SEQ		GENMASK(19, 16)
+#define MT_RXD_CMD_INFO_EVT_TYPE	GENMASK(23, 20)
+
+enum mt76_evt_type {
+	CMD_DONE,
+	CMD_ERROR,
+	CMD_RETRY,
+	EVENT_PWR_RSP,
+	EVENT_WOW_RSP,
+	EVENT_CARRIER_DETECT_RSP,
+	EVENT_DFS_DETECT_RSP,
+};
+
+#endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
new file mode 100644
index 000000000000..28b8e1508016
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/tx.c
@@ -0,0 +1,270 @@
+/*
+ * Copyright (C) 2014 Felix Fietkau <nbd@openwrt.org>
+ * Copyright (C) 2015 Jakub Kicinski <kubakici@wp.pl>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include "mt76x0.h"
+#include "trace.h"
+
+/* Take mac80211 Q id from the skb and translate it to hardware Q id */
+static u8 skb2q(struct sk_buff *skb)
+{
+	int qid = skb_get_queue_mapping(skb);
+
+	if (WARN_ON(qid >= MT_TXQ_PSD)) {
+		qid = MT_TXQ_BE;
+		skb_set_queue_mapping(skb, qid);
+	}
+
+	return q2hwq(qid);
+}
+
+static void mt76x0_tx_skb_remove_dma_overhead(struct sk_buff *skb,
+					       struct ieee80211_tx_info *info)
+{
+	int pkt_len = (unsigned long)info->status.status_driver_data[0];
+
+	skb_pull(skb, sizeof(struct mt76_txwi) + 4);
+	if (ieee80211_get_hdrlen_from_skb(skb) % 4)
+		mt76_remove_hdr_pad(skb);
+
+	skb_trim(skb, pkt_len);
+}
+
+void mt76x0_tx_status(struct mt76x0_dev *dev, struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	mt76x0_tx_skb_remove_dma_overhead(skb, info);
+
+	ieee80211_tx_info_clear_status(info);
+	info->status.rates[0].idx = -1;
+	info->flags |= IEEE80211_TX_STAT_ACK;
+
+	spin_lock(&dev->mac_lock);
+	ieee80211_tx_status(dev->mt76.hw, skb);
+	spin_unlock(&dev->mac_lock);
+}
+
+static int mt76x0_skb_rooms(struct mt76x0_dev *dev, struct sk_buff *skb)
+{
+	int hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	u32 need_head;
+
+	need_head = sizeof(struct mt76_txwi) + 4;
+	if (hdr_len % 4)
+		need_head += 2;
+
+	return skb_cow(skb, need_head);
+}
+
+static struct mt76_txwi *
+mt76x0_push_txwi(struct mt76x0_dev *dev, struct sk_buff *skb,
+		  struct ieee80211_sta *sta, struct mt76_wcid *wcid,
+		  int pkt_len)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct ieee80211_tx_rate *rate = &info->control.rates[0];
+	struct mt76_txwi *txwi;
+	unsigned long flags;
+	u16 txwi_flags = 0;
+	u32 pkt_id;
+	u16 rate_ctl;
+	u8 nss;
+
+	txwi = (struct mt76_txwi *)skb_push(skb, sizeof(struct mt76_txwi));
+	memset(txwi, 0, sizeof(*txwi));
+
+	if (!wcid->tx_rate_set)
+		ieee80211_get_tx_rates(info->control.vif, sta, skb,
+				       info->control.rates, 1);
+
+	spin_lock_irqsave(&dev->mt76.lock, flags);
+	if (rate->idx < 0 || !rate->count) {
+		rate_ctl = wcid->tx_rate;
+		nss = wcid->tx_rate_nss;
+	} else {
+		rate_ctl = mt76_mac_tx_rate_val(dev, rate, &nss);
+	}
+	spin_unlock_irqrestore(&dev->mt76.lock, flags);
+
+	txwi->rate_ctl = cpu_to_le16(rate_ctl);
+
+	if (info->flags & IEEE80211_TX_CTL_LDPC)
+		txwi->rate_ctl |= cpu_to_le16(MT_RXWI_RATE_LDPC);
+	if ((info->flags & IEEE80211_TX_CTL_STBC) && nss == 1)
+		txwi->rate_ctl |= cpu_to_le16(MT_RXWI_RATE_STBC);
+	if (nss > 1 && sta && sta->smps_mode == IEEE80211_SMPS_DYNAMIC)
+		txwi_flags |= MT_TXWI_FLAGS_MMPS;
+
+	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK)) {
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_REQ;
+		pkt_id = 1;
+	} else {
+		pkt_id = 0;
+	}
+
+	if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE)
+		pkt_id |= MT_TXWI_PKTID_PROBE;
+
+	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ)
+		txwi->ack_ctl |= MT_TXWI_ACK_CTL_NSEQ;
+
+	if ((info->flags & IEEE80211_TX_CTL_AMPDU) && sta) {
+		u8 ba_size = IEEE80211_MIN_AMPDU_BUF;
+
+		ba_size <<= sta->ht_cap.ampdu_factor;
+		ba_size = min_t(int, 7, ba_size - 1);
+		if (info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+			ba_size = 0;
+		} else {
+			txwi_flags |= MT_TXWI_FLAGS_AMPDU;
+			txwi_flags |= FIELD_PREP(MT_TXWI_FLAGS_MPDU_DENSITY,
+						 sta->ht_cap.ampdu_density);
+		}
+		txwi->ack_ctl |= FIELD_PREP(MT_TXWI_ACK_CTL_BA_WINDOW, ba_size);
+	}
+
+	txwi->wcid = wcid->idx;
+	txwi->flags |= cpu_to_le16(txwi_flags);
+	txwi->len_ctl = cpu_to_le16(pkt_len);
+	txwi->pktid = pkt_id;
+
+	return txwi;
+}
+
+void mt76x0_tx(struct ieee80211_hw *hw, struct ieee80211_tx_control *control,
+		struct sk_buff *skb)
+{
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+	struct mt76x0_dev *dev = hw->priv;
+	struct ieee80211_vif *vif = info->control.vif;
+	struct ieee80211_sta *sta = control->sta;
+	struct mt76_sta *msta = NULL;
+	struct mt76_wcid *wcid = dev->mon_wcid;
+	struct mt76_txwi *txwi;
+	int pkt_len = skb->len;
+	int hw_q = skb2q(skb);
+
+	BUILD_BUG_ON(ARRAY_SIZE(info->status.status_driver_data) < 1);
+	info->status.status_driver_data[0] = (void *)(unsigned long)pkt_len;
+
+	if (mt76x0_skb_rooms(dev, skb) || mt76_insert_hdr_pad(skb)) {
+		ieee80211_free_txskb(dev->mt76.hw, skb);
+		return;
+	}
+
+	if (sta) {
+		msta = (struct mt76_sta *) sta->drv_priv;
+		wcid = &msta->wcid;
+	} else if (vif && (!info->control.hw_key && wcid->hw_key_idx != -1)) {
+		struct mt76_vif *mvif = (struct mt76_vif *)vif->drv_priv;
+
+		wcid = &mvif->group_wcid;
+	}
+
+	txwi = mt76x0_push_txwi(dev, skb, sta, wcid, pkt_len);
+
+	if (mt76x0_dma_enqueue_tx(dev, skb, wcid, hw_q))
+		return;
+
+	trace_mt_tx(&dev->mt76, skb, msta, txwi);
+}
+
+void mt76x0_tx_stat(struct work_struct *work)
+{
+	struct mt76x0_dev *dev = container_of(work, struct mt76x0_dev,
+					       stat_work.work);
+	struct mt76_tx_status stat;
+	unsigned long flags;
+	int cleaned = 0;
+	u8 update = 1;
+
+	while (!test_bit(MT76_REMOVED, &dev->mt76.state)) {
+		stat = mt76x0_mac_fetch_tx_status(dev);
+		if (!stat.valid)
+			break;
+
+		mt76_send_tx_status(dev, &stat, &update);
+
+		cleaned++;
+	}
+	trace_mt_tx_status_cleaned(&dev->mt76, cleaned);
+
+	spin_lock_irqsave(&dev->tx_lock, flags);
+	if (cleaned)
+		queue_delayed_work(dev->stat_wq, &dev->stat_work,
+				   msecs_to_jiffies(10));
+	else if (test_and_clear_bit(MT76_MORE_STATS, &dev->mt76.state))
+		queue_delayed_work(dev->stat_wq, &dev->stat_work,
+				   msecs_to_jiffies(20));
+	else
+		clear_bit(MT76_READING_STATS, &dev->mt76.state);
+	spin_unlock_irqrestore(&dev->tx_lock, flags);
+}
+
+int mt76x0_conf_tx(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+		    u16 queue, const struct ieee80211_tx_queue_params *params)
+{
+	struct mt76x0_dev *dev = hw->priv;
+	u8 cw_min = 5, cw_max = 10, hw_q = q2hwq(queue);
+	u32 val;
+
+	/* TODO: should we do funny things with the parameters?
+	 *	 See what mt76x0_set_default_edca() used to do in init.c.
+	 */
+
+	if (params->cw_min)
+		cw_min = fls(params->cw_min);
+	if (params->cw_max)
+		cw_max = fls(params->cw_max);
+
+	WARN_ON(params->txop > 0xff);
+	WARN_ON(params->aifs > 0xf);
+	WARN_ON(cw_min > 0xf);
+	WARN_ON(cw_max > 0xf);
+
+	val = FIELD_PREP(MT_EDCA_CFG_AIFSN, params->aifs) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMIN, cw_min) |
+	      FIELD_PREP(MT_EDCA_CFG_CWMAX, cw_max);
+	/* TODO: based on user-controlled EnableTxBurst var vendor drv sets
+	 *	 a really long txop on AC0 (see connect.c:2009) but only on
+	 *	 connect? When not connected should be 0.
+	 */
+	if (!hw_q)
+		val |= 0x60;
+	else
+		val |= FIELD_PREP(MT_EDCA_CFG_TXOP, params->txop);
+	mt76_wr(dev, MT_EDCA_CFG_AC(hw_q), val);
+
+	val = mt76_rr(dev, MT_WMM_TXOP(hw_q));
+	val &= ~(MT_WMM_TXOP_MASK << MT_WMM_TXOP_SHIFT(hw_q));
+	val |= params->txop << MT_WMM_TXOP_SHIFT(hw_q);
+	mt76_wr(dev, MT_WMM_TXOP(hw_q), val);
+
+	val = mt76_rr(dev, MT_WMM_AIFSN);
+	val &= ~(MT_WMM_AIFSN_MASK << MT_WMM_AIFSN_SHIFT(hw_q));
+	val |= params->aifs << MT_WMM_AIFSN_SHIFT(hw_q);
+	mt76_wr(dev, MT_WMM_AIFSN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMIN);
+	val &= ~(MT_WMM_CWMIN_MASK << MT_WMM_CWMIN_SHIFT(hw_q));
+	val |= cw_min << MT_WMM_CWMIN_SHIFT(hw_q);
+	mt76_wr(dev, MT_WMM_CWMIN, val);
+
+	val = mt76_rr(dev, MT_WMM_CWMAX);
+	val &= ~(MT_WMM_CWMAX_MASK << MT_WMM_CWMAX_SHIFT(hw_q));
+	val |= cw_max << MT_WMM_CWMAX_SHIFT(hw_q);
+	mt76_wr(dev, MT_WMM_CWMAX, val);
+
+	return 0;
+}
-- 
1.9.3
