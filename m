Return-Path: <SRS0=FAJS=OK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D3EC04EB9
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 09:56:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD95E20834
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Dec 2018 09:56:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CD95E20834
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbeLAVIM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 16:08:12 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54326 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbeLAVIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 16:08:12 -0500
Received: by mail-wm1-f67.google.com with SMTP id z18so1223276wmc.4
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2018 01:56:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w4VVcarR0quicuo6wDr7ZHlqKkiD7TbywVDf4EsV/J0=;
        b=tmoAT+YhU1ujrqE6FnUcNbM6OP1idduHtM4pJdiVB6C+piNxnKKGQT+AcIDD1m7mXS
         MPKeEbF/XEZSHdGrb9l7VbL4V0qPpF1SLooSatpWvyN08r2MR+FgP3YrOA3LBog+LJx6
         zeVGfnyuGwa1XNd13QhmmYNO/Oj2m+QFuBBVQytGleylI6c2SU57DaXSlzZm77U/rQaO
         64GIu90ly08kGC0fdjnUziS6Stphy0FV2zZToOA2uTCQ3HF9uzw0mKIMAJU0wuJFc8zr
         bvZ5TGEO1jFnGgPa2s+ilaKM8/+1vpYnNDJrEQEJI+rjmS2I1dYkhRTsb0x7S52fhvTl
         mFLg==
X-Gm-Message-State: AA+aEWbnS5sXPSVT8aaM0eZA6B0oH8mmr39hznVnDzvMAMk0KySkSvqT
        J+3uSUIUEO5uGP9H4z/6TJmwxJwDMY4=
X-Google-Smtp-Source: AFSGD/WOJdZ5ljV7wXvbvrVtRmxqybRTF2R1Udraw6XnkO9JgjgxbR2u/T8p/bZzJQd3uxQCBt6efA==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr1001687wmh.18.1543658162548;
        Sat, 01 Dec 2018 01:56:02 -0800 (PST)
Received: from localhost.localdomain ([151.66.56.232])
        by smtp.gmail.com with ESMTPSA id e17sm6793895wrs.79.2018.12.01.01.56.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 01 Dec 2018 01:56:01 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org
Subject: [PATCH] mt76: dma: remove napi from mt76_dma_rx_fill signature
Date:   Sat,  1 Dec 2018 10:55:06 +0100
Message-Id: <289d48757b2dc8f07e8a4e1ca35df8476927935a.1543657995.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <cover.1543657995.git.lorenzo.bianconi@redhat.com>
References: <cover.1543657995.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove napi from mt76_dma_rx_fill routine signature since
it is a leftover of a previous implementation and it is no
longer used

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e2ba26378575..1e557d16272e 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -318,7 +318,7 @@ int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 EXPORT_SYMBOL_GPL(mt76_dma_tx_queue_skb);
 
 static int
-mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q, bool napi)
+mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 {
 	dma_addr_t addr;
 	void *buf;
@@ -392,7 +392,7 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 
 	mt76_dma_rx_cleanup(dev, q);
 	mt76_dma_sync_idx(dev, q);
-	mt76_dma_rx_fill(dev, q, false);
+	mt76_dma_rx_fill(dev, q);
 }
 
 static void
@@ -463,7 +463,7 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 		dev->drv->rx_skb(dev, q - dev->q_rx, skb);
 	}
 
-	mt76_dma_rx_fill(dev, q, true);
+	mt76_dma_rx_fill(dev, q);
 	return done;
 }
 
@@ -504,7 +504,7 @@ mt76_dma_init(struct mt76_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(dev->q_rx); i++) {
 		netif_napi_add(&dev->napi_dev, &dev->napi[i], mt76_dma_rx_poll,
 			       64);
-		mt76_dma_rx_fill(dev, &dev->q_rx[i], false);
+		mt76_dma_rx_fill(dev, &dev->q_rx[i]);
 		skb_queue_head_init(&dev->rx_skb[i]);
 		napi_enable(&dev->napi[i]);
 	}
-- 
2.19.2

