Return-Path: <SRS0=0XaW=Q3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E39AC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C032146E
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Feb 2019 14:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550671552;
	bh=OGzSHkDYmDRvtUJfcIFTfs2KbFoherV2BpXMnTAap9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=VnfciiZyqU/4bTbqizY/nZDF5gWvzELaYZHHa1t7MuRgwC7X+Ovdb4Sem+p/zi4ie
	 K8+SlcR5vcrZAjBJ5fsPbEGHlzFGM7PBRV6WrgKzBbwUP1qawJsML0s1eivQILijzN
	 TBGKrUlL6lCTKZSYFJvLXzB5gnSVkPT3xljX2UUQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfBTOFv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbfBTOFv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Feb 2019 09:05:51 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DED552146E;
        Wed, 20 Feb 2019 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550671550;
        bh=OGzSHkDYmDRvtUJfcIFTfs2KbFoherV2BpXMnTAap9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QRmFVFw9yYuXtudOaktwIcruSV6ecCZs0x5lOFr7rge6oHwSbo8ouX+ldnG6D4jWS
         a8fY3ZJgdTY12WhWdQN2KlHQt9OPoOt2LwJBp5Exwr69TRrTFIi2GMOC4seO408XNu
         FMk6eDjBFrG114zbQQXEfdBsc7vo/jBJM5TvEZ4o=
From:   lorenzo@kernel.org
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [RFC 2/3] mt76: usb: simplify rx buffer allocation
Date:   Wed, 20 Feb 2019 15:05:34 +0100
Message-Id: <615da7de976c0c442a6fab4a1f9f2a600ef91010.1550671183.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1550671183.git.lorenzo@kernel.org>
References: <cover.1550671183.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

Squash mt76u_buf_alloc_sg and mt76u_buf_alloc and remove duplicated code

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h |  2 -
 drivers/net/wireless/mediatek/mt76/usb.c  | 78 +++++++++--------------
 2 files changed, 29 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 972f0ca7c818..51a4721df400 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -754,8 +754,6 @@ void mt76u_single_wr(struct mt76_dev *dev, const u8 req,
 		     const u16 offset, const u32 val);
 int mt76u_init(struct mt76_dev *dev, struct usb_interface *intf);
 void mt76u_deinit(struct mt76_dev *dev);
-int mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
-		    int len, int data_len, gfp_t gfp);
 void mt76u_buf_free(struct mt76u_buf *buf);
 int mt76u_submit_buf(struct mt76_dev *dev, int dir, int index,
 		     struct mt76u_buf *buf, gfp_t gfp,
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index c84415caaeaf..24bf96de9f9d 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -324,41 +324,42 @@ mt76u_fill_rx_sg(struct mt76_dev *dev, struct mt76u_buf *buf,
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
+mt76u_buf_alloc(struct mt76_dev *dev, struct mt76u_buf *buf,
+		gfp_t gfp)
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
+	return mt76u_refill_rx(dev, q, buf, MT_SG_MAX_SIZE, gfp);
 }
 
 void mt76u_buf_free(struct mt76u_buf *buf)
@@ -519,20 +520,6 @@ static void mt76u_complete_rx(struct urb *urb)
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
@@ -549,7 +536,8 @@ static void mt76u_rx_tasklet(unsigned long data)
 
 		count = mt76u_process_rx_entry(dev, buf);
 		if (count > 0) {
-			err = mt76u_refill_rx(dev, q, buf, count);
+			err = mt76u_refill_rx(dev, q, buf, count,
+					      GFP_ATOMIC);
 			if (err < 0)
 				break;
 		}
@@ -605,16 +593,8 @@ static int mt76u_alloc_rx(struct mt76_dev *dev)
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
+		err = mt76u_buf_alloc(dev, &q->entry[i].ubuf,
+				      GFP_KERNEL);
 		if (err < 0)
 			return err;
 	}
-- 
2.20.1

