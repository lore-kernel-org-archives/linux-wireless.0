Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F206EC43444
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C233220657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 12:34:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729590AbfAOMeB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 07:34:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37298 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbfAOMd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 07:33:57 -0500
Received: by mail-wm1-f68.google.com with SMTP id g67so3018223wmd.2
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 04:33:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+UGhwTaubaVTZoqPzgQYfWu2x839nH8fbhXUm/EzEO4=;
        b=DF09B/MaZpsj7x3Uyn8WEtydtsJUd/bgz+A17KYA5HYFGPHFoP2THi9Sf9bUqqgAHN
         nxC/+t6brubLL4Ye+tJbZ5TWcVcJJ+6Uol+ZpvwMGMxl80MudV1mN6GZRdE+g9DEj21o
         f6fMi41z2QLqoQhjvbQbf+WehPzucep/IJ6RpABIHIUdcDbu6vtIy7OeOC/qQZp7fM3S
         Q8oL/xaRpFnwwG0BrxmIqYcPnNleGCVhJm7SRyGN3AtbkgHqzyBN8Kp9zePUcfPSSybp
         lkG02QsLAyCC0ZfP4teArXKx6ug1UV5uxY8szCEJzojM0hHFGfC1iww02vMm2r/AUQjm
         pRPw==
X-Gm-Message-State: AJcUukdOIHWLec3cztyxWW817G98AWGhHpOrkJ9wbWYbvmpibOfocp5l
        lBZTI2qG0wGa7mKxncPw32OYGw==
X-Google-Smtp-Source: ALg8bN48QeIp2pQrZ4isv8Bh7GZgKu71DS1hZ5/DH7wDykwY7ZERbfRaNGMTk4uJxfNvt2SQcxipCQ==
X-Received: by 2002:a1c:c44c:: with SMTP id u73mr3351935wmf.45.1547555635499;
        Tue, 15 Jan 2019 04:33:55 -0800 (PST)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a6sm28218186wmh.10.2019.01.15.04.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 15 Jan 2019 04:33:54 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, rosenp@gmail.com,
        sgruszka@redhat.com
Subject: [RFC 3/4] mt76: usb: use a linear buffer for tx/rx datapath if sg is not supported
Date:   Tue, 15 Jan 2019 13:33:44 +0100
Message-Id: <34f057f93935e28e9586a9a53331db27d3cc75f1.1547549771.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
References: <cover.1547549771.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use linear fragment and not a single usb scatter-gather buffer in mt76u
{tx,rx} datapath if the usb controller has sg data length constraints

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/usb.c | 87 +++++++++++++++---------
 1 file changed, 54 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 4dc288e86fd1..491b17756ccd 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -426,10 +426,11 @@ static int mt76u_get_rx_entry_len(u8 *data, u32 data_len)
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
 
@@ -440,7 +441,8 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 	if (len < 0)
 		return 0;
 
-	data_len = min_t(int, len, urb->sg[0].length - MT_DMA_HDR_LEN);
+	data_len = urb->num_sgs ? urb->sg[0].length : buf->len;
+	data_len = min_t(int, len, data_len - MT_DMA_HDR_LEN);
 	if (MT_DMA_HDR_LEN + data_len > SKB_WITH_OVERHEAD(q->buf_size))
 		return 0;
 
@@ -452,7 +454,7 @@ mt76u_process_rx_entry(struct mt76_dev *dev, struct urb *urb)
 	__skb_put(skb, data_len);
 	len -= data_len;
 
-	while (len > 0) {
+	while (len > 0 && urb->num_sgs) {
 		data_len = min_t(int, len, urb->sg[nsgs].length);
 		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
 				sg_page(&urb->sg[nsgs]),
@@ -497,12 +499,26 @@ static void mt76u_complete_rx(struct urb *urb)
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
 
@@ -511,11 +527,9 @@ static void mt76u_rx_tasklet(unsigned long data)
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
@@ -553,7 +567,7 @@ EXPORT_SYMBOL_GPL(mt76u_submit_rx_buffers);
 static int mt76u_alloc_rx(struct mt76_dev *dev)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
-	int i, err, nsgs;
+	int i, err;
 
 	spin_lock_init(&q->rx_page_lock);
 	spin_lock_init(&q->lock);
@@ -563,19 +577,18 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
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
 	for (i = 0; i < MT_NUM_RX_ENTRIES; i++) {
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
@@ -724,7 +737,7 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 {
 	struct usb_interface *intf = to_usb_interface(dev->dev);
 	struct usb_device *udev = interface_to_usbdev(intf);
-	u8 ep = q2ep(q->hw_idx);
+	u8 *data = NULL, ep = q2ep(q->hw_idx);
 	struct mt76u_buf *buf;
 	u16 idx = q->tail;
 	unsigned int pipe;
@@ -741,12 +754,16 @@ mt76u_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
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
@@ -782,10 +799,8 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 {
 	struct mt76u_buf *buf;
 	struct mt76_queue *q;
-	size_t size;
 	int i, j;
 
-	size = MT_SG_MAX_SIZE * sizeof(struct scatterlist);
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		q = &dev->q_tx[i];
 		spin_lock_init(&q->lock);
@@ -807,9 +822,15 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
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

