Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CF6DC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 565C820693
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 15:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfCLPGl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 11:06:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35944 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfCLPGl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 11:06:41 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 22662307DAC8;
        Tue, 12 Mar 2019 15:06:41 +0000 (UTC)
Received: from localhost (unknown [10.43.2.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9A64B100194A;
        Tue, 12 Mar 2019 15:06:38 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC 05/12] mt76usb: remove mt76u_buf redundant fileds
Date:   Tue, 12 Mar 2019 16:05:59 +0100
Message-Id: <1552403166-3821-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
References: <1552403166-3821-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 12 Mar 2019 15:06:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove mt76u_buf->{len, buf} fields and operate on corresponding
urb fields directly.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 --
 drivers/net/wireless/mediatek/mt76/usb.c  | 40 +++++++++++++++++--------------
 2 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 89cdfe4abf33..476cb39c99b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -85,8 +85,6 @@ struct mt76_queue_buf {
 
 struct mt76u_buf {
 	struct urb *urb;
-	size_t len;
-	void *buf;
 	bool done;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 954feb311620..86bf852c6e3d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -315,7 +315,7 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
 	}
 
 	urb->num_sgs = max_t(int, i, urb->num_sgs);
-	buf->len = urb->num_sgs * sglen,
+	urb->transfer_buffer_length = urb->num_sgs * sglen,
 	sg_init_marker(urb->sg, urb->num_sgs);
 
 	return i ? : -ENOMEM;
@@ -328,8 +328,11 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
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
 
@@ -338,8 +341,6 @@ static bool mt76u_check_sg(struct mt76_dev *dev)
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
@@ -377,7 +378,6 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
 		    void *context)
 {
 	struct usb_device *udev = to_usb_device(dev->dev);
-	u8 *data = buf->urb->num_sgs ? NULL : buf->buf;
 	unsigned int pipe;
 
 	if (dir == USB_DIR_IN)
@@ -385,8 +385,10 @@ static void mt76u_buf_free(struct mt76u_buf *buf)
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
@@ -426,7 +428,7 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 	struct urb *urb = buf->urb;
-	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : buf->buf;
+	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : urb->transfer_buffer;
 	int data_len, len, nsgs = 1;
 	struct sk_buff *skb;
 
@@ -437,7 +439,7 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 	if (len < 0)
 		return 0;
 
-	data_len = urb->num_sgs ? urb->sg[0].length : buf->len;
+	data_len = urb->num_sgs ? urb->sg[0].length : INT_MAX;
 	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
 	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
 		return 0;
@@ -731,14 +733,16 @@ static void mt76u_complete_tx(struct urb *urb)
 		return err;
 
 	buf = &q->entry[idx].ubuf;
-	buf->buf = skb->data;
-	buf->len = skb->len;
+	if (!dev->usb.sg_en) {
+		buf->urb->transfer_buffer = skb->data;
+	} else {
+		err = mt76u_tx_build_sg(dev, skb, buf->urb);
+		if (err < 0)
+			return err;
+	}
+	buf->urb->transfer_buffer_length = skb->len;
 	buf->done = false;
 
-	err = mt76u_tx_build_sg(dev, skb, buf->urb);
-	if (err < 0)
-		return err;
-
 	mt76u_fill_bulk_urb(dev, USB_DIR_OUT, q2ep(q->hw_idx),
 			    buf, mt76u_complete_tx, buf);
 
-- 
1.9.3

