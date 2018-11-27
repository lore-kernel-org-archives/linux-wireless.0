Return-Path: <SRS0=Otg8=OG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A124C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB9D02086B
	for <linux-wireless@archiver.kernel.org>; Tue, 27 Nov 2018 22:21:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB9D02086B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbeK1JUw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 28 Nov 2018 04:20:52 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36464 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbeK1JUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Nov 2018 04:20:52 -0500
Received: by mail-wm1-f66.google.com with SMTP id s11so608075wmh.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2018 14:21:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X6w3SuAxSKkd36jG9DGNNXl3ocLr1IIniQlgkOxd9IE=;
        b=KYwsGf3MXNpKxL77xNpcSAnJrtiM6/QHOfs2Hmn/tmQTwqYWCKo6O3eNRfad1vVZT0
         Ktd8Jj8hAxGw00IWWFw5FnyTcZ2RQ67QTuDlEV3+DI9UZhV0dzVVxqORL7igxCG9gbh+
         h8Ov+gzeReGlHQvvRz42QMxA+EffI43iKzAsCcXJgL08v5Dt764VYqKyvfARXmXKKKHr
         u/CnYvHs6J55uTwyQHpJYoKB4NRdgNyDpB3o1LGKSAEagZZQkk75XwfYioY7lC6+jaAy
         KzoHuyIKojfpqpmh37yshK5M7iD8gN03Z2OUuFH8zpLUo2Fp2T/RAMSL1Rm4/nTulgy5
         Wh1Q==
X-Gm-Message-State: AA+aEWbOw9/yEGyADw3rXM0A2KA4kFyY46kiRvqPVAqqO6PJ6XYXBOpc
        AH9RimTytMbeo1gSIaPSsp/irvZm64w=
X-Google-Smtp-Source: AFSGD/VTyhZqyEpwybprNH1zzBXjB0LK03ztayN66dSy5GqTvJAto+l2tvEUhKLk4Qk9Zai1mBMPLg==
X-Received: by 2002:a1c:1286:: with SMTP id 128mr601850wms.70.1543357289658;
        Tue, 27 Nov 2018 14:21:29 -0800 (PST)
Received: from localhost.lan ([151.21.135.68])
        by smtp.gmail.com with ESMTPSA id 142sm866245wmw.27.2018.11.27.14.21.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 27 Nov 2018 14:21:29 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     nbd@nbd.name
Subject: [RFC 3/5] mt76: split mt76_dma_rx_reset in init_rx_reset and complete_rx_reset
Date:   Tue, 27 Nov 2018 23:21:10 +0100
Message-Id: <095486ed9b97ef4a81758859dbeb2c95856dfa30.1543343124.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

This is a preliminary patch to add XDP support to mt76 driver.
In order to reset the rx dma buffers with a proper buffer_size
(XDP does not support fragmented frames and requires one packet
per memory page) split mt76_dma_rx_reset routine in
mt76_dma_init_rx_reset where we free allocated memory and
mt76_dma_complete_rx_reset used to allocate dma memory with a proper
size according to the working mode (standard or xdp)

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c  | 12 ++++++++++--
 drivers/net/wireless/mediatek/mt76/mt76.h |  6 ++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index e2ba26378575..efa0eab7cf01 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -382,7 +382,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 }
 
 static void
-mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
+mt76_dma_init_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 {
 	struct mt76_queue *q = &dev->q_rx[qid];
 	int i;
@@ -392,6 +392,13 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 
 	mt76_dma_rx_cleanup(dev, q);
 	mt76_dma_sync_idx(dev, q);
+}
+
+static void
+mt76_dma_complete_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
+{
+	struct mt76_queue *q = &dev->q_rx[qid];
+
 	mt76_dma_rx_fill(dev, q, false);
 }
 
@@ -518,7 +525,8 @@ static const struct mt76_queue_ops mt76_dma_ops = {
 	.add_buf = mt76_dma_add_buf,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
-	.rx_reset = mt76_dma_rx_reset,
+	.init_rx_reset = mt76_dma_init_rx_reset,
+	.complete_rx_reset = mt76_dma_complete_rx_reset,
 	.kick = mt76_dma_kick_queue,
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 5cd508a68609..70924792d870 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -159,7 +159,8 @@ struct mt76_queue_ops {
 	void *(*dequeue)(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 			 int *len, u32 *info, bool *more);
 
-	void (*rx_reset)(struct mt76_dev *dev, enum mt76_rxq_id qid);
+	void (*init_rx_reset)(struct mt76_dev *dev, enum mt76_rxq_id qid);
+	void (*complete_rx_reset)(struct mt76_dev *dev, enum mt76_rxq_id qid);
 
 	void (*tx_cleanup)(struct mt76_dev *dev, enum mt76_txq_id qid,
 			   bool flush);
@@ -552,9 +553,10 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
 #define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
-#define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_init_rx_reset(dev, ...)	(dev)->mt76.queue_ops->init_rx_reset(&((dev)->mt76), __VA_ARGS__)
+#define mt76_queue_complete_rx_reset(dev, ...)	(dev)->mt76.queue_ops->complete_rx_reset(&((dev)->mt76), __VA_ARGS__)
 
 static inline struct mt76_channel_state *
 mt76_channel_state(struct mt76_dev *dev, struct ieee80211_channel *c)
-- 
2.19.1

