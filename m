Return-Path: <SRS0=cSSL=QN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08742C169C4
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 09:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C193D2175B
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Feb 2019 09:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727582AbfBFJQR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Feb 2019 04:16:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41959 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfBFJQQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Feb 2019 04:16:16 -0500
Received: by mail-wr1-f68.google.com with SMTP id x10so6635423wrs.8
        for <linux-wireless@vger.kernel.org>; Wed, 06 Feb 2019 01:16:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oAoSlDUmzIZwpTqAwlDG3MPKIkzpkVG9fG2Pqy+ob4Q=;
        b=qvcIsAHU85j6xe+FqReKq1nx7ke4nt/XAyl18HULj5kCGo63rxCNJ4ouIpNzhW+YRe
         5zZ28sia1A+p0vU4cqujK3pfF4c6J8or5aTwJTHbW3UhbMV+b7ixToB66GX69VFO7QBa
         BFfz7jxBhosDNIdwFSQRPRF2GnWRHz+pOziBUC8aXym2F2HaLVxd4vf5Vo+1mUrq3gxN
         esDAZfkpmDwe0ttOfg6FdF2aUosy1sbhmSd6zzd9bQbbheN2m5NabR644PHRLmztxyVW
         si1mIXpOn6bCjarc2HJFNaHa0SucjkY0lDY/QGRk8VL8YwM1od+io+6Q+etA0mrPaKiT
         2s2g==
X-Gm-Message-State: AHQUAua46YKp1Kc40r3ntNqMpJgGAR+ux0ck9keW0rtB3gi6YnnWpxmO
        J6vRzRR2mDwW9wr6EtSMENtGwQ==
X-Google-Smtp-Source: AHgI3IZA1TuL/oNTRmKdMxHBExoF8XNpUjpZnQUXvVaWVej1VZ0xlS2KOpPT9guczaB8pzxMYQ6T5w==
X-Received: by 2002:adf:e284:: with SMTP id v4mr6855303wri.26.1549444574743;
        Wed, 06 Feb 2019 01:16:14 -0800 (PST)
Received: from lore-desk.lan ([151.66.10.5])
        by smtp.gmail.com with ESMTPSA id x22sm6206960wmj.40.2019.02.06.01.16.13
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 06 Feb 2019 01:16:13 -0800 (PST)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76: move mt76_tx_queue_mcu in mt76-core module
Date:   Wed,  6 Feb 2019 10:15:42 +0100
Message-Id: <1d76867dab000720e648c68b4e1b90e81564f366.1549444343.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1549444343.git.lorenzo.bianconi@redhat.com>
References: <cover.1549444343.git.lorenzo.bianconi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move mt76_tx_queue_mcu routine in dma.c and remove duplicated code.
mt76_tx_queue_mcu will be reused adding support for mt7603 driver

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 24 +++++++++++
 drivers/net/wireless/mediatek/mt76/mt76.h     |  2 +
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 40 ++++---------------
 3 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a37b284168c6..a4fe1f4ac220 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -242,6 +242,30 @@ mt76_dma_kick_queue(struct mt76_dev *dev, struct mt76_queue *q)
 	iowrite32(q->head, &q->regs->cpu_idx);
 }
 
+int mt76_tx_queue_mcu(struct mt76_dev *dev, enum mt76_txq_id qid,
+		      struct sk_buff *skb, u32 tx_info)
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
+EXPORT_SYMBOL_GPL(mt76_tx_queue_mcu);
+
 int mt76_dma_tx_queue_skb(struct mt76_dev *dev, struct mt76_queue *q,
 			  struct sk_buff *skb, struct mt76_wcid *wcid,
 			  struct ieee80211_sta *sta)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 1bdac293b347..92aeecbb207d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -761,6 +761,8 @@ mt76_mcu_msg_alloc(const void *data, int head_len,
 void mt76_mcu_rx_event(struct mt76_dev *dev, struct sk_buff *skb);
 struct sk_buff *mt76_mcu_get_response(struct mt76_dev *dev,
 				      unsigned long expires);
+int mt76_tx_queue_mcu(struct mt76_dev *dev, enum mt76_txq_id qid,
+		      struct sk_buff *skb, u32 tx_info);
 
 void mt76u_mcu_complete_urb(struct urb *urb);
 int mt76u_mcu_init_rx(struct mt76_dev *dev);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index b44d128f6f93..2b65783deedd 100644
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
+	ret = mt76_tx_queue_mcu(&dev->mt76, MT_TXQ_MCU, skb, tx_info);
 	if (ret)
 		goto out;
 
-- 
2.20.1

