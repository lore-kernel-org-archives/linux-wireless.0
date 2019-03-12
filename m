Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 699F2C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D04320693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfCLPGr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34294 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:47 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B6AF20276;
        Tue, 12 Mar 2019 15:06:46 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A815D71D;
        Tue, 12 Mar 2019 15:06:43 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 07/12] mt76usb: remove mt76u_buf and use urb directly
Date:   Tue, 12 Mar 2019 16:06:01 +0100
Message-Id: <1552403166-3821-8-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 12 Mar 2019 15:06:46 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Put urb pointer in mt76_queue_entry directly instead of mt76u_buf
structure.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |   6 +-
 drivers/net/wireless/mediatek/mt76/usb.c  | 132 +++++++++++++++---------------
 2 files changed, 65 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 998505064dee..859d0325583b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -83,10 +83,6 @@ struct mt76_queue_buf {
 	int len;
 };
 
-struct mt76u_buf {
-	struct urb *urb;
-};
-
 struct mt76_queue_entry {
 	union {
 		void *buf;
@@ -94,7 +90,7 @@ struct mt76_queue_entry {
 	};
 	union {
 		struct mt76_txwi_cache *txwi;
-		struct mt76u_buf ubuf;
+		struct urb *urb;
 	};
 	enum mt76_txq_id qid;
 	bool schedule;
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index a4ef9bb1603d..2c21f4773a19 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -283,12 +283,11 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 }
 
 static int
-mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
+mt76u_fill_rx_sg(struct mt76_dev *dev, struct urb *urb, int nsgs,
 		 gfp_t gfp)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	int sglen = SKB_WITH_OVERHEAD(q->buf_size);
-	struct urb *urb = buf->urb;
 
 	int i;
 
@@ -323,44 +322,43 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 
 static int
 mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
-		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
+		struct urb *urb, int nsgs, gfp_t gfp)
 {
 	if (dev->usb.sg_en) {
-		return mt76u_fill_rx_sg(dev, buf, nsgs, gfp);
+		return mt76u_fill_rx_sg(dev, urb, nsgs, gfp);
 	} else {
-		buf->urb->transfer_buffer_length =
-			SKB_WITH_OVERHEAD(q->buf_size);
-		buf->urb->transfer_buffer =
-			page_frag_alloc(&q->rx_page, q->buf_size, gfp);
-		return buf->urb->transfer_buffer ? 0 : -ENOMEM;
+		urb->transfer_buffer_length = SKB_WITH_OVERHEAD(q->buf_size);
+		urb->transfer_buffer = page_frag_alloc(&q->rx_page,
+						       q->buf_size, gfp);
+		return urb->transfer_buffer ? 0 : -ENOMEM;
 	}
 }
 
 static int
-mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
+mt76u_urb_alloc(struct mt76_dev *dev, struct mt76_queue_entry *e)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
+	struct urb *urb;
 
-	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
-	if (!buf->urb)
+	urb = usb_alloc_urb(0, GFP_KERNEL);
+	if (!urb)
 		return -ENOMEM;
+	e->urb = urb;
 
 	if (dev->usb.sg_en) {
-		buf->urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
-					    sizeof(*buf->urb->sg),
-					    GFP_KERNEL);
-		if (!buf->urb->sg)
+		urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
+				       sizeof(urb->sg), GFP_KERNEL);
+		if (!urb->sg)
 			return -ENOMEM;
 
-		sg_init_table(buf->urb->sg, MT_SG_MAX_SIZE);
+		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
 	}
 
-	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
+	return mt76u_refill_rx(dev, q, urb, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
-static void mt76u_buf_free(struct mt76u_buf *buf)
+static void mt76u_urb_free(struct urb *urb)
 {
-	struct urb *urb = buf->urb;
 	int i;
 
 	for (i = 0; i < urb->num_sgs; i++)
@@ -369,12 +367,12 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
 	if (urb->transfer_buffer)
 		skb_free_frag(urb->transfer_buffer);
 
-	usb_free_urb(buf->urb);
+	usb_free_urb(urb);
 }
 
 static void
 mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
-		    struct mt76u_buf *buf, usb_complete_t complete_fn,
+		    struct urb *urb, usb_complete_t complete_fn,
 		    void *context)
 {
 	struct usb_device *udev = to_usb_device(dev->dev);
@@ -385,27 +383,27 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	buf->urb->dev = udev;
-	buf->urb->pipe = pipe;
-	buf->urb->complete = complete_fn;
-	buf->urb->context = context;
+	urb->dev = udev;
+	urb->pipe = pipe;
+	urb->complete = complete_fn;
+	urb->context = context;
 }
 
-static inline struct mt76u_buf
-*mt76u_get_next_rx_entry(struct mt76_queue *q)
+static inline struct urb *
+mt76u_get_next_rx_entry(struct mt76_queue *q)
 {
-	struct mt76u_buf *buf = NULL;
+	struct urb *urb = NULL;
 	unsigned long flags;
 
 	spin_lock_irqsave(&q->lock, flags);
 	if (q->queued > 0) {
-		buf = &q->entry[q->head].ubuf;
+		urb = q->entry[q->head].urb;
 		q->head = (q->head + 1) % q->ndesc;
 		q->queued--;
 	}
 	spin_unlock_irqrestore(&q->lock, flags);
 
-	return buf;
+	return urb;
 }
 
 static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
@@ -424,10 +422,9 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 }
 
 static int
-mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
+mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	struct urb *urb = buf->urb;
 	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : urb->transfer_buffer;
 	int data_len, len, nsgs = 1;
 	struct sk_buff *skb;
@@ -488,7 +485,7 @@ static void mt76u_complete_rx(struct urb *urb)
 	}
 
 	spin_lock_irqsave(&q->lock, flags);
-	if (WARN_ONCE(q->entry[q->tail].ubuf.urb != urb, "rx urb mismatch"))
+	if (WARN_ONCE(q->entry[q->tail].urb != urb, "rx urb mismatch"))
 		goto out;
 
 	q->tail = (q->tail + 1) % q->ndesc;
@@ -499,37 +496,37 @@ static void mt76u_complete_rx(struct urb *urb)
 }
 
 static int
-mt76u_submit_rx_buf(struct mt76_dev *dev, struct mt76u_buf *buf)
+mt76u_submit_rx_buf(struct mt76_dev *dev, struct urb *urb)
 {
-	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, buf,
+	mt76u_fill_bulk_urb(dev, USB_DIR_IN, MT_EP_IN_PKT_RX, urb,
 			    mt76u_complete_rx, dev);
-	trace_submit_urb(dev, buf->urb);
+	trace_submit_urb(dev, urb);
 
-	return usb_submit_urb(buf->urb, GFP_ATOMIC);
+	return usb_submit_urb(urb, GFP_ATOMIC);
 }
 
 static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	struct mt76u_buf *buf;
+	struct urb *urb;
 	int err, count;
 
 	rcu_read_lock();
 
 	while (true) {
-		buf = mt76u_get_next_rx_entry(q);
-		if (!buf)
+		urb = mt76u_get_next_rx_entry(q);
+		if (!urb)
 			break;
 
-		count = mt76u_process_rx_entry(dev, buf);
+		count = mt76u_process_rx_entry(dev, urb);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, buf, count,
+			err = mt76u_refill_rx(dev, q, urb, count,
 					      GFP_ATOMIC);
 			if (err < 0)
 				break;
 		}
-		mt76u_submit_rx_buf(dev, buf);
+		mt76u_submit_rx_buf(dev, urb);
 	}
 	mt76_rx_poll_complete(dev, MT_RXQ_MAIN, NULL);
 
@@ -544,7 +541,7 @@ int mt76u_submit_rx_buffers(struct mt76_dev *dev)
 
 	spin_lock_irqsave(&q->lock, flags);
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_submit_rx_buf(dev, &q->entry[i].ubuf);
+		err = mt76u_submit_rx_buf(dev, q->entry[i].urb);
 		if (err < 0)
 			break;
 	}
@@ -576,7 +573,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
 	q->ndesc = MT_NUM_RX_ENTRIES;
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf);
+		err = mt76u_urb_alloc(dev, &q->entry[i]);
 		if (err < 0)
 			return err;
 	}
@@ -591,7 +588,7 @@ static void mt76u_free_rx(struct mt76_dev *dev)
 	int i;
 
 	for (i = 0; i < q->ndesc; i++)
-		mt76u_buf_free(&q->entry[i].ubuf);
+		mt76u_urb_free(q->entry[i].urb);
 
 	if (!q->rx_page.va)
 		return;
@@ -607,7 +604,7 @@ static void mt76u_stop_rx(struct mt76_dev *dev)
 	int i;
 
 	for (i = 0; i < q->ndesc; i++)
-		usb_kill_urb(q->entry[i].ubuf.urb);
+		usb_kill_urb(q->entry[i].urb);
 }
 
 static void mt76u_tx_tasklet(unsigned long data)
@@ -718,7 +715,7 @@ static void mt76u_complete_tx(struct urb *urb)
 		   struct ieee80211_sta *sta)
 {
 	struct mt76_queue *q = dev->q_tx[qid].q;
-	struct mt76u_buf *buf;
+	struct urb *urb;
 	u16 idx = q->tail;
 	int err;
 
@@ -731,18 +728,18 @@ static void mt76u_complete_tx(struct urb *urb)
 		return err;
 
 	q->entry[idx].done = false;
-	buf = &q->entry[idx].ubuf;
+	urb = q->entry[idx].urb;
 	if (!dev->usb.sg_en) {
-		buf->urb->transfer_buffer = skb->data;
+		urb->transfer_buffer = skb->data;
 	} else {
-		err = mt76u_tx_build_sg(dev, skb, buf->urb);
+		err = mt76u_tx_build_sg(dev, skb, urb);
 		if (err < 0)
 			return err;
 	}
-	buf->urb->transfer_buffer_length = skb->len;
+	urb->transfer_buffer_length = skb->len;
 
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
-			    buf, mt76u_complete_tx, &q->entry[idx]);
+			    urb, mt76u_complete_tx, &q->entry[idx]);
 
 	q->tail = (q->tail + 1) % q->ndesc;
 	q->entry[idx].skb = skb;
@@ -753,14 +750,14 @@ static void mt76u_complete_tx(struct urb *urb)
 
 static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 {
-	struct mt76u_buf *buf;
+	struct urb *urb;
 	int err;
 
 	while (q->first != q->tail) {
-		buf = &q->entry[q->first].ubuf;
+		urb = q->entry[q->first].urb;
 
-		trace_submit_urb(dev, buf->urb);
-		err = usb_submit_urb(buf->urb, GFP_ATOMIC);
+		trace_submit_urb(dev, urb);
+		err = usb_submit_urb(urb, GFP_ATOMIC);
 		if (err < 0) {
 			if (err == -ENODEV)
 				set_bit(MT76_REMOVED, &dev->state);
@@ -775,7 +772,7 @@ static void mt76u_tx_kick(struct mt76_dev *dev, struct mt76_queue *q)
 
 static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
-	struct mt76u_buf *buf;
+	struct urb *urb;
 	struct mt76_queue *q;
 	int i, j;
 
@@ -803,19 +800,18 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 
 		q->ndesc = MT_NUM_TX_ENTRIES;
 		for (j = 0; j < q->ndesc; j++) {
-			buf = &q->entry[j].ubuf;
-
-			buf->urb = usb_alloc_urb(0, GFP_KERNEL);
-			if (!buf->urb)
+			urb = usb_alloc_urb(0, GFP_KERNEL);
+			if (!urb)
 				return -ENOMEM;
+			q->entry[j].urb = urb;
 
 			if (dev->usb.sg_en) {
 				size_t size = MT_SG_MAX_SIZE *
 					      sizeof(struct scatterlist);
 
-				buf->urb->sg = devm_kzalloc(dev->dev, size,
-							    GFP_KERNEL);
-				if (!buf->urb->sg)
+				urb->sg = devm_kzalloc(dev->dev, size,
+						       GFP_KERNEL);
+				if (!urb->sg)
 					return -ENOMEM;
 			}
 		}
@@ -831,7 +827,7 @@ static void mt76u_free_tx(struct mt76_dev *dev)
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		q = dev->q_tx[i].q;
 		for (j = 0; j < q->ndesc; j++)
-			usb_free_urb(q->entry[j].ubuf.urb);
+			usb_free_urb(q->entry[j].urb);
 	}
 }
 
@@ -843,7 +839,7 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		q = dev->q_tx[i].q;
 		for (j = 0; j < q->ndesc; j++)
-			usb_kill_urb(q->entry[j].ubuf.urb);
+			usb_kill_urb(q->entry[j].urb);
 	}
 }
 
-- 
1.9.3

