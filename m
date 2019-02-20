Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B998C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C99E20880
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 22:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550702135;
	bh=C9CTsaSPZ0NPbrhx4VcnGn8KWhGt8eNdR9nlBVJQFYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=N978o6/lE7ieOGpmQKH69KZrSj8I/gcJVqYKgAcH+vgYfLC8Lm9xYMQfdkGhdYZdp
	 YNhh7eQZN8ITzzk4aSJu21GWwLC8fukNYjamF1n7M4im+B3RzPdtL+TmkMVFgFpuXQ
	 3a36bFcFUQbfnGKYM7ZFa4RlSFfWFf/E0DbU5FQI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbfBTWfe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 17:35:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfBTWfe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 17:35:34 -0500
Received: from lore-desk.lan (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1C0220880;
        Wed, 20 Feb 2019 22:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550702133;
        bh=C9CTsaSPZ0NPbrhx4VcnGn8KWhGt8eNdR9nlBVJQFYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wIFmGAlIDoUtopKZFG5GJbJgoQLJqWvnqdpZUO5Rns7vG1EARpJZYAdl0f4nmJxDc
         da+N8OL8XvCnV0RAB5VsddpFSpx4gy1jjzXqq1olDoxC7D+3Kdiw+enhzTDEraIpe/
         zsksFLLU3nIqhhfSHxrBrl256CzWqX2PRcfQ+9WU=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH 2/3] mt76: usb: simplify rx buffer allocation
Date:   Wed, 20 Feb 2019 23:35:17 +0100
Message-Id: <313ad2969b0630806683752704de8054c6ab4d0c.1550701735.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550701735.git.lorenzo@kernel.org>
References: <cover.1550701735.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Squash mt76u_buf_alloc_sg and mt76u_buf_alloc and remove duplicated
code. Reuse mt76u_refill_rx in mt76u_buf_alloc

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 76 ++++++++---------------
 2 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index a689af307a71..3b674228542d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -751,8 +751,6 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int len, int data_len, gfp_t gfp);
 void mt76u_buf_free(struct mt76u_buf *buf);
 int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 		     struct mt76u_buf *buf, gfp_t gfp,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 76c952c29c6e..211ef7876de2 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -324,41 +324,41 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
 }
 
 static int
-mt76u_buf_alloc_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
-		   int nsgs, int len, int sglen, gfp_t gfp)
+mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
+		struct mt76u_buf *buf, int nsgs, gfp_t gfp)
 {
-	buf->urb = usb_alloc_urb(0, gfp);
-	if (!buf->urb)
-		return -ENOMEM;
-
-	buf->urb->sg = devm_kcalloc(dev->dev, nsgs, sizeof(*buf->urb->sg),
-				    gfp);
-	if (!buf->urb->sg)
-		return -ENOMEM;
-
-	sg_init_table(buf->urb->sg, nsgs);
-	buf->dev = dev;
-
-	return mt76u_fill_rx_sg(dev, buf, nsgs, len, sglen);
+	if (dev->usb.sg_en) {
+		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
+					SKB_WITH_OVERHEAD(q->buf_size));
+	} else {
+		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size, gfp);
+		return buf->buf ? 0 : -ENOMEM;
+	}
 }
 
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int len, int data_len, gfp_t gfp)
+static int
+mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf)
 {
 	struct mt76_queue *q = &dev->q_rx[MT_RXQ_MAIN];
 
-	buf->urb = usb_alloc_urb(0, gfp);
+	buf->len = SKB_WITH_OVERHEAD(q->buf_size);
+	buf->dev = dev;
+
+	buf->urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!buf->urb)
 		return -ENOMEM;
 
-	buf->buf = page_frag_alloc(&q->rx_page, len, gfp);
-	if (!buf->buf)
-		return -ENOMEM;
+	if (dev->usb.sg_en) {
+		buf->urb->sg = devm_kcalloc(dev->dev, MT_SG_MAX_SIZE,
+					    sizeof(*buf->urb->sg),
+					    GFP_KERNEL);
+		if (!buf->urb->sg)
+			return -ENOMEM;
 
-	buf->len = data_len;
-	buf->dev = dev;
+		sg_init_table(buf->urb->sg, MT_SG_MAX_SIZE);
+	}
 
-	return 0;
+	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, GFP_KERNEL);
 }
 
 void mt76u_buf_free(struct mt76u_buf *buf)
@@ -519,20 +519,6 @@ static void mt76u_complete_rx(struct urb *urb)
 	spin_unlock_irqrestore(&q->lock, flags);
 }
 
-static int
-mt76u_refill_rx(struct mt76_dev *dev, struct mt76_queue *q,
-		struct mt76u_buf *buf, int nsgs)
-{
-	if (dev->usb.sg_en) {
-		return mt76u_fill_rx_sg(dev, buf, nsgs, q->buf_size,
-					SKB_WITH_OVERHEAD(q->buf_size));
-	} else {
-		buf->buf = page_frag_alloc(&q->rx_page, q->buf_size,
-					   GFP_ATOMIC);
-		return buf->buf ? 0 : -ENOMEM;
-	}
-}
-
 static void mt76u_rx_tasklet(unsigned long data)
 {
 	struct mt76_dev *dev = (struct mt76_dev *)data;
@@ -549,7 +535,8 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 		count = mt76u_process_rx_entry(dev, buf);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, buf, count);
+			err = mt76u_refill_rx(dev, q, buf, count,
+					      GFP_ATOMIC);
 			if (err < 0)
 				break;
 		}
@@ -605,16 +592,7 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
 	q->buf_size = dev->usb.sg_en ? MT_RX_BUF_SIZE : PAGE_SIZE;
 	q->ndesc = MT_NUM_RX_ENTRIES;
 	for (i = 0; i < q->ndesc; i++) {
-		if (dev->usb.sg_en)
-			err = mt76u_buf_alloc_sg(dev, &q->entry[i].ubuf,
-					MT_SG_MAX_SIZE, q->buf_size,
-					SKB_WITH_OVERHEAD(q->buf_size),
-					GFP_KERNEL);
-		else
-			err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
-					      q->buf_size,
-					      SKB_WITH_OVERHEAD(q->buf_size),
-					      GFP_KERNEL);
+		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf);
 		if (err < 0)
 			return err;
 	}
-- 
2.20.1

