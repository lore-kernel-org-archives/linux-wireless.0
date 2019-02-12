Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119C7C282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4ADC21773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 13:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549978994;
	bh=IFlLQPGaFKxvgQPf4qZGEJgnS1uleu1n2EuwkAMmE2I=;
	h=From:To:Subject:Date:In-Reply-To:References:List-ID:From;
	b=YNflFm6ZrsBqoSpxoi7bO2TMyGxZnQ89kc+Nj8t3wXEjJXRYPSZRU5cOYwJqibFuO
	 n/HygyZvbkennXUtun9xBkrJKjfx/Hf9eXleCrI/hBTpD3A3zqrCHjFwxwVdpj6zcn
	 3ZbIluH/unCcd+3jLpcp1dzURdziJeZ+Nc2Y2M5M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfBLNnO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 08:43:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:47494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbfBLNnN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 08:43:13 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17D022184A
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 13:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549978992;
        bh=IFlLQPGaFKxvgQPf4qZGEJgnS1uleu1n2EuwkAMmE2I=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=P7MuHwWg1y1FPNA48W9jZt1ZSdm+hg0Ago5OBzHTc1GP7aQay+yVwUBH6TuekZDTD
         GHHV08ySwFpP85iPbyI9pGykCO/ytGANXhkrzzMx8jagklwn+5QyC/zWb4SjSZqlhS
         c/y2tjtlczQJRqH5XzJTdSuSU4NIOkX1+v8gf8D4=
From:   lorenzo@kernel.org
To:     linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 3/4] mt76: usb: use a linear buffer for tx/rx datapath if sg is not supported
Date:   Tue, 12 Feb 2019 14:42:41 +0100
Message-Id: <e758d41479573f994166578730c5a62b20f8d24c.1549977282.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549977282.git.lorenzo@kernel.org>
References: <cover.1549977282.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Use linear fragment and not a single usb scatter-gather buffer in mt76u
{tx,rx} datapath if the usb controller has sg data length constraints

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 87 +++++++++++++++---------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 66c9451cb6f3..7e7da6b49a88 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -432,10 +432,11 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
 }
 
 static int
-mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
+mt76u_process_rx_entry(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	u8 *data = sg_virt(&urb->sg[0]);
+	struct urb *urb = buf->urb;
+	u8 *data = urb->num_sgs ? sg_virt(&urb->sg[0]) : buf->buf;
 	int data_len, len, nsgs = 1;
 	struct sk_buff *skb;
 
@@ -446,7 +447,8 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 	if (len < 0)
 		return 0;
 
-	data_len = min_t(int, len, urb->sg[0].length - MT_DMA_HDR_LEN);
+	data_len = urb->num_sgs ? urb->sg[0].length : buf->len;
+	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
 	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
 		return 0;
 
@@ -458,7 +460,7 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 	__skb_put(skb, data_len);
 	len -= data_len;
 
-	while (len > 0) {
+	while (len > 0 && urb->num_sgs) {
 		data_len = min_t(int, len, urb->sg[nsgs].length);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				sg_page(&urb->sg[nsgs]),
@@ -504,12 +506,26 @@ static void mt76u_complete_rx(struct urb *urb)
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
+static int
+mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
+		struct mt76u_buf *buf, int nsgs)
+{
+	if (dev->usb.sg_en) {
+		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
+					SKB_WITH_OVERHEAD(q->buf_size));
+	} else {
+		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size,
+					   GFP_ATOMIC);
+		return buf->buf ? 0 : -ENOMEM;
+	}
+}
+
 static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	int err, nsgs, buf_len = q->buf_size;
 	struct mt76u_buf *buf;
+	int err, count;
 
 	rcu_read_lock();
 
@@ -518,11 +534,9 @@ static void mt76u_rx_tasklet(unsigned long data)
 		if (!buf)
 			break;
 
-		nsgs = mt76u_process_rx_entry(dev, buf->urb);
-		if (nsgs > 0) {
-			err = mt76u_fill_rx_sg(dev, buf, nsgs,
-					       buf_len,
-					       SKB_WITH_OVERHEAD(buf_len));
+		count = mt76u_process_rx_entry(dev, buf);
+		if (count > 0) {
+			err = mt76u_refill_rx(dev, q, buf, count);
 			if (err < 0)
 				break;
 		}
@@ -560,7 +574,7 @@ EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
 static int mt76u_alloc_rx(struct mt76_dev *dev)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	int i, err, nsgs;
+	int i, err;
 
 	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
@@ -570,20 +584,19 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	if (!q->entry)
 		return -ENOMEM;
 
-	if (dev->usb.sg_en) {
-		q->buf_size = MT_RX_BUF_SIZE;
-		nsgs = MT_SG_MAX_SIZE;
-	} else {
-		q->buf_size = PAGE_SIZE;
-		nsgs = 1;
-	}
-
+	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
 	q->ndesc = MT_NUM_RX_ENTRIES;
 	for (i = 0; i < q->ndesc; i++) {
-		err = mt76u_buf_alloc_sg(dev, &q->entry[i].ubuf,
-					 nsgs, q->buf_size,
-					 SKB_WITH_OVERHEAD(q->buf_size),
-					 GFP_KERNEL);
+		if (dev->usb.sg_en)
+			err = mt76u_buf_alloc_sg(dev, &q->entry[i].ubuf,
+					MT_SG_MAX_SIZE, q->buf_size,
+					SKB_WITH_OVERHEAD(q->buf_size),
+					GFP_KERNEL);
+		else
+			err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
+					      q->buf_size,
+					      SKB_WITH_OVERHEAD(q->buf_size),
+					      GFP_KERNEL);
 		if (err < 0)
 			return err;
 	}
@@ -731,7 +744,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 ep = q2ep(q->hw_idx);
+	u8 *data = NULL, ep = q2ep(q->hw_idx);
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	unsigned int pipe;
@@ -748,12 +761,16 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 	buf = &q->entry[idx].ubuf;
 	buf->done = false;
 
-	err = mt76u_tx_build_sg(skb, buf->urb);
-	if (err < 0)
-		return err;
+	if (dev->usb.sg_en) {
+		err = mt76u_tx_build_sg(skb, buf->urb);
+		if (err < 0)
+			return err;
+	} else {
+		data = skb->data;
+	}
 
 	pipe = usb_sndbulkpipe(udev, dev->usb.out_ep[ep]);
-	usb_fill_bulk_urb(buf->urb, udev, pipe, NULL, skb->len,
+	usb_fill_bulk_urb(buf->urb, udev, pipe, data, skb->len,
 			  mt76u_complete_tx, buf);
 
 	q->tail = (q->tail + 1) % q->ndesc;
@@ -789,10 +806,8 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
-	size_t size;
 	int i, j;
 
-	size = MT_SG_MAX_SIZE * sizeof(struct scatterlist);
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		q = &dev->q_tx[i];
 		spin_lock_init(&q->lock);
@@ -814,9 +829,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 			if (!buf->urb)
 				return -ENOMEM;
 
-			buf->urb->sg = devm_kzalloc(dev->dev, size, GFP_KERNEL);
-			if (!buf->urb->sg)
-				return -ENOMEM;
+			if (dev->usb.sg_en) {
+				size_t size = MT_SG_MAX_SIZE *
+					      sizeof(struct scatterlist);
+
+				buf->urb->sg = devm_kzalloc(dev->dev, size,
+							    GFP_KERNEL);
+				if (!buf->urb->sg)
+					return -ENOMEM;
+			}
 		}
 	}
 	return 0;
-- 
2.20.1

