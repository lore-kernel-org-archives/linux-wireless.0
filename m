Return-Path: <SRS0=G8on=RY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07805C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D62DB21874
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Mar 2019 15:26:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbfCUP0R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:26:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40998 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbfCUP0R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Mar 2019 11:26:17 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 87E395D5F4;
        Thu, 21 Mar 2019 15:26:16 +0000 (UTC)
Received: from localhost (ovpn-204-211.brq.redhat.com [10.40.204.211])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 701135D75F;
        Thu, 21 Mar 2019 15:26:10 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/12] mt76usb: remove mt76u_buf redundant fileds
Date:   Thu, 21 Mar 2019 16:25:30 +0100
Message-Id: <20190321152537.19105-6-sgruszka@redhat.com>
In-Reply-To: <20190321152537.19105-1-sgruszka@redhat.com>
References: <20190321152537.19105-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 21 Mar 2019 15:26:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76u_buf->{len, buf} fields and operate on corresponding
urb fields directly.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 56 +++++++++++++----------
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index ab93d7e94b36..4cb01502f5b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -91,8 +91,6 @@ struct mt76_tx_info {
 
 struct mt76u_buf {
 	struct urb *urb;
-	size_t len;
-	void *buf;
 	bool done;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 28552c622fee..8bb660e0d65a 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -315,7 +315,7 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf, int nsgs,
 	}
 
 	urb->num_sgs = max_t(int, i, urb->num_sgs);
-	buf->len = urb->num_sgs * sglen,
+	urb->transfer_buffer_length = urb->num_sgs * sglen,
 	sg_init_marker(urb->sg, urb->num_sgs);
 
 	return i ? : -ENOMEM;
@@ -328,8 +328,11 @@ mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
 	if (dev->usb.sg_en) {
 		return mt76u_fill_rx_sg(dev, buf, nsgs, gfp);
 	} else {
-		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
-		return buf->buf ? 0 : -ENOMEM;
+		buf->urb->transfer_buffer_length =
+			SKB_WITH_OVERHEAD(q->buf_size);
+		buf->urb->transfer_buffer =
+			page_frag_alloc(&q->rx_page, q->buf_size, gfp);
+		return buf->urb->transfer_buffer ? 0 : -ENOMEM;
 	}
 }
 
@@ -338,8 +341,6 @@ mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 
-	buf->len = SKB_WITH_OVERHEAD(q->buf_size);
-
 	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!buf->urb)
 		return -ENOMEM;
@@ -365,8 +366,8 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
 	for (i = 0; i < urb->num_sgs; i++)
 		skb_free_frag(sg_virt(&urb->sg[i]));
 
-	if (buf->buf)
-		skb_free_frag(buf->buf);
+	if (urb->transfer_buffer)
+		skb_free_frag(urb->transfer_buffer);
 
 	usb_free_urb(buf->urb);
 }
@@ -377,7 +378,6 @@ mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
 		    void *context)
 {
 	struct usb_device *udev = to_usb_device(dev->dev);
-	u8 *data = buf->urb->num_sgs ? NULL : buf->buf;
 	unsigned int pipe;
 
 	if (dir == USB_DIR_IN)
@@ -385,8 +385,10 @@ mt76u_fill_bulk_urb(struct mt76_dev *dev, int dir, int index,
 	else
 		pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[index]);
 
-	usb_fill_bulk_urb(buf->urb, udev, pipe, data, buf->len,
-			  complete_fn, context);
+	buf->urb->dev = udev;
+	buf->urb->pipe = pipe;
+	buf->urb->complete = complete_fn;
+	buf->urb->context = context;
 }
 
 static inline struct mt76u_buf
@@ -426,8 +428,9 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb = buf->urb;
-	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : buf->buf;
-	int data_len, len, nsgs = 1;
+	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : urb->transfer_buffer;
+	int data_len = urb->num_sgs ? urb->sg[0].length : urb->actual_length;
+	int len, nsgs = 1;
 	struct sk_buff *skb;
 
 	if (!test_bit(MT76_STATE_INITIALIZED, &dev->state))
@@ -437,7 +440,6 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 	if (len < 0)
 		return 0;
 
-	data_len = urb->num_sgs ? urb->sg[0].length : buf->len;
 	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
 	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
 		return 0;
@@ -701,15 +703,21 @@ static void mt76u_complete_tx(struct urb *urb)
 }
 
 static int
-mt76u_tx_build_sg(struct mt76_dev *dev, struct sk_buff *skb,
-		  struct urb *urb)
+mt76u_tx_setup_buffers(struct mt76_dev *dev, struct sk_buff *skb,
+		       struct urb *urb)
 {
-	if (!dev->usb.sg_en)
-		return 0;
+	urb->transfer_buffer_length = skb->len;
 
-	sg_init_table(urb->sg, MT_SG_MAX_SIZE);
-	urb->num_sgs = skb_to_sgvec(skb, urb->sg, 0, skb->len);
-	return urb->num_sgs;
+	if (!dev->usb.sg_en) {
+		urb->transfer_buffer = skb->data;
+		return 0;
+	} else {
+		sg_init_table(urb->sg, MT_SG_MAX_SIZE);
+		urb->num_sgs = skb_to_sgvec(skb, urb->sg, 0, skb->len);
+		if (urb->num_sgs == 0)
+			return -ENOMEM;
+		return urb->num_sgs;
+	}
 }
 
 static int
@@ -731,14 +739,12 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, enum mt76_txq_id qid,
 		return err;
 
 	buf = &q->entry[idx].ubuf;
-	buf->buf = skb->data;
-	buf->len = skb->len;
-	buf->done = false;
-
-	err = mt76u_tx_build_sg(dev, skb, buf->urb);
+	err = mt76u_tx_setup_buffers(dev, skb, buf->urb);
 	if (err < 0)
 		return err;
 
+	buf->done = false;
+
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
 			    buf, mt76u_complete_tx, buf);
 
-- 
2.20.1

