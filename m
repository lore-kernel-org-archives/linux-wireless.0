Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF2D0C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4F6D20834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C4F6D20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbeLCOf7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 09:35:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39421 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeLCOf6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 09:35:58 -0500
Received: by mail-wm1-f68.google.com with SMTP id f81so3497259wmd.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2018 06:34:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=msJbzeL7JL+n07PYTSAFbAgFda6kwH4oemDnatrAGPQ=;
        b=CKaP8DdjgID7fDOML7cllBkO1GiGt50cyRDv6716IriTyWMkbfjaovzng9PZotOdKE
         625OMfnBAwDrL2FU6M7KThc1PmGCykf99ADStrbY8P/3bbNaiDNmvOM5HldpzPsEN74M
         TlrxCdFDc7csbqoiqxK8CUYF7lXahXiKOQXy0wtypQE+pVzDD8Cb6Uljvg9PlFQ8YE5M
         Mk1NA1av/nqIu5npzuI+fdAFKu0/G5UQo5+9gQkIkCQho+wA1NINgsosIxgO2P6kTff0
         cPJxBOZk9Bmv/1pD0q7qQAoJ0/od0pwO63ws/6ypif7eq2GZcM5RkBoZV1k+I2v88mtB
         TXoQ==
X-Gm-Message-State: AA+aEWbrLPEd3WuIbq0NBdEq5CHSATOpfoEXLjoIg8ALwbRaBGPYiC+N
        Q1/szT60Kt3waQ6hpdIp8GDrLy0//to=
X-Google-Smtp-Source: AFSGD/XfNAdjm6GdXcbUMhhUlbQtKjd4Bzrc1a1QJJuxl+X3eg4KozEsg3ZB52T6/DX5QgDkWH8aSA==
X-Received: by 2002:a1c:dd06:: with SMTP id u6mr8249248wmg.81.1543847683042;
        Mon, 03 Dec 2018 06:34:43 -0800 (PST)
Received: from localhost.localdomain ([151.66.39.232])
        by smtp.gmail.com with ESMTPSA id c77sm9911023wmh.12.2018.12.03.06.34.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Dec 2018 06:34:42 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mt76: dma: add rx buffer recycle support
Date:   Mon,  3 Dec 2018 15:34:25 +0100
Message-Id: <8c05c03018ca9f98047ff961028f09da2e1565d0.1543846816.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Add support for recycling rx buffers if they are not forwarded
to network stack instead of reallocate them from scratch

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 60 +++++++++++++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76.h |  3 ++
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 1db163c40dcf..eceadfa3f980 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -39,6 +39,15 @@ mt76_dma_alloc_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	if (!q->entry)
 		return -ENOMEM;
 
+	/* allocate recycle buffer ring */
+	if (q == &dev->q_rx[MT_RXQ_MCU] ||
+	    q == &dev->q_rx[MT_RXQ_MAIN]) {
+		size = q->ndesc * sizeof(*q->recycle);
+		q->recycle = devm_kzalloc(dev->dev, size, GFP_KERNEL);
+		if (!q->recycle)
+			return -ENOMEM;
+	}
+
 	/* clear descriptors */
 	for (i = 0; i < q->ndesc; i++)
 		q->desc[i].ctrl = cpu_to_le32(MT_DMA_CTL_DMA_DONE);
@@ -317,6 +326,49 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 }
 EXPORT_SYMBOL_GPL(mt76_dma_tx_queue_skb);
 
+/* caller must hold mt76_queue spinlock */
+static u8 *mt76_dma_get_free_buf(struct mt76_queue *q, bool flush)
+{
+	if (q->recycle[q->rhead] || flush) {
+		u8 *buff = q->recycle[q->rhead];
+
+		q->recycle[q->rhead] = NULL;
+		q->rhead = (q->rhead + 1) % q->ndesc;
+		return buff;
+	}
+
+	return page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+}
+
+static void
+mt76_dma_set_recycle_buf(struct mt76_queue *q, u8 *data)
+{
+	spin_lock_bh(&q->lock);
+	if (!q->recycle[q->rtail]) {
+		q->recycle[q->rtail] = data;
+		q->rtail = (q->rtail + 1) % q->ndesc;
+	} else {
+		skb_free_frag(data);
+	}
+	spin_unlock_bh(&q->lock);
+}
+
+static void
+mt76_dma_free_recycle_ring(struct mt76_queue *q)
+{
+	u8 *buf;
+
+	spin_lock_bh(&q->lock);
+	while (true) {
+		buf = mt76_dma_get_free_buf(q, true);
+		if (!buf)
+			break;
+
+		skb_free_frag(buf);
+	}
+	spin_unlock_bh(&q->lock);
+}
+
 static int
 mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 {
@@ -332,7 +384,7 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 	while (q->queued < q->ndesc - 1) {
 		struct mt76_queue_buf qbuf;
 
-		buf = page_frag_alloc(&q->rx_page, q->buf_size, GFP_ATOMIC);
+		buf = mt76_dma_get_free_buf(q, false);
 		if (!buf)
 			break;
 
@@ -373,6 +425,8 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 	} while (1);
 	spin_unlock_bh(&q->lock);
 
+	mt76_dma_free_recycle_ring(q);
+
 	if (!q->rx_page.va)
 		return;
 
@@ -438,7 +492,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 			dev_kfree_skb(q->rx_head);
 			q->rx_head = NULL;
 
-			skb_free_frag(data);
+			mt76_dma_set_recycle_buf(q, data);
 			continue;
 		}
 
@@ -449,7 +503,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 
 		skb = build_skb(data, q->buf_size);
 		if (!skb) {
-			skb_free_frag(data);
+			mt76_dma_set_recycle_buf(q, data);
 			continue;
 		}
 		skb_reserve(skb, q->buf_offset);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5cd508a68609..95546c744494 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -114,6 +114,9 @@ struct mt76_queue {
 	spinlock_t lock;
 	struct mt76_queue_entry *entry;
 	struct mt76_desc *desc;
+	/* recycle ring */
+	u16 rhead, rtail;
+	u8 **recycle;
 
 	struct list_head swq;
 	int swq_queued;
-- 
2.19.2

