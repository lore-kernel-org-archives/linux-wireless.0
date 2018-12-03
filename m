Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E6EEC04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4113E20834
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 14:34:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4113E20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbeLCOf4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 09:35:56 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53461 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbeLCOf4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 09:35:56 -0500
Received: by mail-wm1-f65.google.com with SMTP id y1so6046840wmi.3
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2018 06:34:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d//qVM9jVpSOvUd5ZS6wDI+lA9i/aX+EmIvbG/vCXc0=;
        b=a1k2URuphLaMOwGgQQaBkrwwXKl42uXWb1evtCnCzMv3qSQiv5snKrD9xSjM/f7vDv
         2JZG5QOsNM3+MSVHC63eJPIDj0p7GlvKcOKsKnj8h2E1dT055etB2Y33wpNliwdNzE3u
         L6JbOWTQ8ek/duEQY8kGMMkEby4cpIsPDUjDykZU4i4o2G7JkusfaXUzAv0G9XNjJAJK
         +Lo9VA6SyFLzXas9A/wxKZPif1PldlAhxLavsghEG0Rq7ZnQtTnnV1GzlqqtvLUzT83F
         lV6hI6aCuK2dJkd2uBu7NrxmM3I9dhyh9izY9IDuP4uuXb4kXOtcDXJV8FaJZIEEt4mz
         jCXw==
X-Gm-Message-State: AA+aEWYHp4yKy/6dA6pscMsjeLoQSKKsYcmScAOQId6PtT0tP47cvM8V
        iuWxVGWBZE+R715wM6/MWq9VGs5IFsE=
X-Google-Smtp-Source: AFSGD/Uk9an8eAXxSr4PLcJhOoheB913r0pQe3YGMVz82GumrQSeqSZuMb93ogkM4tI2crSIS4nFcw==
X-Received: by 2002:a1c:9803:: with SMTP id a3mr8916355wme.69.1543847680614;
        Mon, 03 Dec 2018 06:34:40 -0800 (PST)
Received: from localhost.localdomain ([151.66.39.232])
        by smtp.gmail.com with ESMTPSA id c77sm9911023wmh.12.2018.12.03.06.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Dec 2018 06:34:39 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] mt76: dma: do not build skb if reported len does not fit in buf_size
Date:   Mon,  3 Dec 2018 15:34:24 +0100
Message-Id: <0583d3f607ef493df9a2ff12bbe773174008027d.1543846816.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
References: <cover.1543846816.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Precompute data length in order to avoid to allocate the related
skb data structure if reported length does not fit in queue buf_size

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index b7fd2e110663..1db163c40dcf 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -417,10 +417,9 @@ mt76_add_fragment(struct mt76_dev *dev, struct mt76_queue *q, void *data,
 static int
 mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 {
+	int len, data_len, done = 0;
 	struct sk_buff *skb;
 	unsigned char *data;
-	int len;
-	int done = 0;
 	bool more;
 
 	while (done < budget) {
@@ -430,7 +429,12 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 		if (!data)
 			break;
 
-		if (q->buf_size < len + q->buf_offset) {
+		if (q->rx_head)
+			data_len = q->buf_size;
+		else
+			data_len = SKB_WITH_OVERHEAD(q->buf_size);
+
+		if (data_len < len + q->buf_offset) {
 			dev_kfree_skb(q->rx_head);
 			q->rx_head = NULL;
 
@@ -448,12 +452,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 			skb_free_frag(data);
 			continue;
 		}
-
 		skb_reserve(skb, q->buf_offset);
-		if (skb->tail + len > skb->end) {
-			dev_kfree_skb(skb);
-			continue;
-		}
 
 		if (q == &dev->q_rx[MT_RXQ_MCU]) {
 			u32 *rxfce = (u32 *) skb->cb;
-- 
2.19.2

