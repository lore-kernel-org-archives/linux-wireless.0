Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED89C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 902BB21872
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 10:11:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfBGKLN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 05:11:13 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36316 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfBGKLN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 05:11:13 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so10873447wrv.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 02:11:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7LaFPI2PaQfO8gRgNIyTXXz2OxmM3M51lY7IXEOBUU=;
        b=S8Qat2Tlzroc3HySkRyjgnCVI1FqCPqpZScUxWRpRXsQc/9mzGYQTow/N7M9vl54Dw
         qgIpcqgXSk9AeU8n/gK0dBqTVLwFfmUExxBzL1EL85qNOA50S7E0Y3hjN9XeS5IJekxF
         wJ7yFAk8R+6CRv5pWUsp/X6FvpNrk/Dx2YWTUp+i+/Dx/mR67EA6dubGT+trwoDelE+T
         ggOPRwrmQkRCbkmyKYGBBMHInQ8Vzwn6F/LRYfkyL4Ektk0o031BBearJdMEENDhK8kk
         4EuMF3lYjwl4dluxlzK/68uu4aL4IxNO+gCnmjoqz502aBo+Sz4tV8fq34+eMpIyTqKX
         SIxg==
X-Gm-Message-State: AHQUAuZ8ERsZs15gS7bCWyLUjbjs6xIajo9nY8t4t9XkLGIxQx4HyoFP
        i5gFOuZp1Q2MAg+l2svKxjgpCsT1Mss=
X-Google-Smtp-Source: AHgI3IYc7Dn0FYnYJJe0mjaXgJ/hTT7n64hxWQGkoNZsMDeTV+qQqDhaf1lDwr/QFSS4Cm//tRG+nA==
X-Received: by 2002:adf:f28d:: with SMTP id k13mr12063298wro.78.1549534270449;
        Thu, 07 Feb 2019 02:11:10 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id t199sm33376346wmt.1.2019.02.07.02.11.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 07 Feb 2019 02:11:09 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH v2] mt76: move mt76_dma_tx_queue_skb_raw in mt76-core module
Date:   Thu,  7 Feb 2019 11:10:57 +0100
Message-Id: <68febba653edb280369615b29e402f3f31bb61f0.1549533229.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549533229.git.lorenzo.bianconi@redhat.com>
References: <cover.1549533229.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_dma_tx_queue_skb_raw routine in dma.c and add the
corresponding entry in mt76_queue_ops data structure.
mt76_dma_tx_queue_skb_raw  will be reused adding support for
mt7603 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
Changes since v1:
- rename mt76_tx_queue_mcu in mt76_dma_tx_queue_skb_raw and
  add related function pointer in mt76_dma_ops
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 25 ++++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  4 ++
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 40 ++++---------------
 3 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a37b284168c6..0dd78d364751 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -242,6 +242,30 @@ mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	iowrite32(q->head, &q->regs->cpu_idx);
 }
 
+static int
+mt76_dma_tx_queue_skb_raw(struct mt76_dev *dev, enum mt76_txq_id qid,
+			  struct sk_buff *skb, u32 tx_info)
+{
+	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue_buf buf;
+	dma_addr_t addr;
+
+	addr = dma_map_single(dev->dev, skb->data, skb->len,
+			      DMA_TO_DEVICE);
+	if (dma_mapping_error(dev->dev, addr))
+		return -ENOMEM;
+
+	buf.addr = addr;
+	buf.len = skb->len;
+
+	spin_lock_bh(&q->lock);
+	mt76_dma_add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
+	mt76_dma_kick_queue(dev, q);
+	spin_unlock_bh(&q->lock);
+
+	return 0;
+}
+
 int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
@@ -523,6 +547,7 @@ static const struct mt76_queue_ops mt76_dma_ops = {
 	.init = mt76_dma_init,
 	.alloc = mt76_dma_alloc_queue,
 	.add_buf = mt76_dma_add_buf,
+	.tx_queue_skb_raw = mt76_dma_tx_queue_skb_raw,
 	.tx_queue_skb = mt76_dma_tx_queue_skb,
 	.tx_cleanup = mt76_dma_tx_cleanup,
 	.rx_reset = mt76_dma_rx_reset,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 1bdac293b347..108d6bab70f0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -157,6 +157,9 @@ struct mt76_queue_ops {
 			    struct sk_buff *skb, struct mt76_wcid *wcid,
 			    struct ieee80211_sta *sta);
 
+	int (*tx_queue_skb_raw)(struct mt76_dev *dev, enum mt76_txq_id qid,
+				struct sk_buff *skb, u32 tx_info);
+
 	void *(*dequeue)(struct mt76_dev *dev, struct mt76_queue *q, bool flush,
 			 int *len, u32 *info, bool *more);
 
@@ -566,6 +569,7 @@ static inline u16 mt76_rev(struct mt76_dev *dev)
 #define mt76_init_queues(dev)		(dev)->mt76.queue_ops->init(&((dev)->mt76))
 #define mt76_queue_alloc(dev, ...)	(dev)->mt76.queue_ops->alloc(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_add_buf(dev, ...)	(dev)->mt76.queue_ops->add_buf(&((dev)->mt76), __VA_ARGS__)
+#define mt76_tx_queue_skb_raw(dev, ...)	(dev)->mt76.queue_ops->tx_queue_skb_raw(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_rx_reset(dev, ...)	(dev)->mt76.queue_ops->rx_reset(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_tx_cleanup(dev, ...)	(dev)->mt76.queue_ops->tx_cleanup(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index b44d128f6f93..4752c104abf3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -21,43 +21,13 @@
 
 #include "mt76x02_mcu.h"
 
-static int
-mt76x02_tx_queue_mcu(struct mt76x02_dev *dev, enum mt76_txq_id qid,
-		     struct sk_buff *skb, int cmd, int seq)
-{
-	struct mt76_queue *q = &dev->mt76.q_tx[qid];
-	struct mt76_queue_buf buf;
-	dma_addr_t addr;
-	u32 tx_info;
-
-	tx_info = MT_MCU_MSG_TYPE_CMD |
-		  FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
-		  FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
-		  FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
-		  FIELD_PREP(MT_MCU_MSG_LEN, skb->len);
-
-	addr = dma_map_single(dev->mt76.dev, skb->data, skb->len,
-			      DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->mt76.dev, addr))
-		return -ENOMEM;
-
-	buf.addr = addr;
-	buf.len = skb->len;
-
-	spin_lock_bh(&q->lock);
-	mt76_queue_add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
-	mt76_queue_kick(dev, q);
-	spin_unlock_bh(&q->lock);
-
-	return 0;
-}
-
 int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 			 int len, bool wait_resp)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	unsigned long expires = jiffies + HZ;
 	struct sk_buff *skb;
+	u32 tx_info;
 	int ret;
 	u8 seq;
 
@@ -71,7 +41,13 @@ int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 	if (!seq)
 		seq = ++mdev->mmio.mcu.msg_seq & 0xf;
 
-	ret = mt76x02_tx_queue_mcu(dev, MT_TXQ_MCU, skb, cmd, seq);
+	tx_info = MT_MCU_MSG_TYPE_CMD |
+		  FIELD_PREP(MT_MCU_MSG_CMD_TYPE, cmd) |
+		  FIELD_PREP(MT_MCU_MSG_CMD_SEQ, seq) |
+		  FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
+		  FIELD_PREP(MT_MCU_MSG_LEN, skb->len);
+
+	ret = mt76_tx_queue_skb_raw(dev, MT_TXQ_MCU, skb, tx_info);
 	if (ret)
 		goto out;
 
-- 
2.20.1

