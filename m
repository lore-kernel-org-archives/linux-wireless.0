Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 120BFC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B035A20684
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B035A20684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbeJDTAB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:00:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40031 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbeJDTAA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:00:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id z204-v6so7951035wmc.5
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:06:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fFWZnZFTn8vhyHhhdqx9o/D8nmm/04sBjAhXmIpwm3U=;
        b=rJouxq7mjKQbT+SYv9yuFYMm+xSwsJ4BkTiQLoYUeSoL/vuDUtx9RFNMsdZtsj6A3h
         9ak2yUujQgChuFLRFiI5mLi8BmVnO5rVyZOxQG5wQiAf8hZiqs9bD9392r9fGfi8ZojR
         HG9JthEncZbkQPcd9+iZIiEhdejpxAuyPcF2Yyuml4LFyFuB/zTgL+/0mSm3WueK5Vi9
         svhffKbOrorxbDqkdPGqbSinrPB5R5uqQB/LeJv4GNVBY5FdtLFCf5xxFb9yCCYDIYlv
         PQKygBWVsnjplHuJPQlWBc+ZFShp98JKPVi6w2o500xSJN0++OqdVgNzQr83E+RVJ3Z/
         rgKw==
X-Gm-Message-State: ABuFfoguNE4A6x0uTKAtCQwNpxlj9w1afJRDiSJSD57s6xXq26j55uVX
        zzNaffGL5MaRTGyHJ+IuiAfP7YKA5Cg=
X-Google-Smtp-Source: ACcGV61WJ9Gq9EW8HbYvYoaqTQhZ5ykq00enLUs6VJ3h/QNAloabaecABS2rlTSh9k7k0reYbBW02A==
X-Received: by 2002:a1c:870c:: with SMTP id j12-v6mr4618840wmd.40.1538654817874;
        Thu, 04 Oct 2018 05:06:57 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.06.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:06:57 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_mcu.c
Date:   Thu,  4 Oct 2018 14:06:44 +0200
Message-Id: <23fbcdc16d4c4c0d5ebd01cec05d8120f070fc3c.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
References: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_mcu.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../net/wireless/mediatek/mt76/mt76x0/init.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   |  2 +-
 .../net/wireless/mediatek/mt76/mt76x0/phy.c   | 24 +++---
 .../net/wireless/mediatek/mt76/mt76x02_mcu.c  | 74 +++++++++----------
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  | 14 ++--
 .../wireless/mediatek/mt76/mt76x2/pci_init.c  |  4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_mcu.c   |  4 +-
 .../wireless/mediatek/mt76/mt76x2/pci_phy.c   | 22 +++---
 .../net/wireless/mediatek/mt76/mt76x2/phy.c   |  3 +-
 .../wireless/mediatek/mt76/mt76x2/usb_init.c  |  2 +-
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   |  7 +-
 .../wireless/mediatek/mt76/mt76x2/usb_phy.c   | 20 +++--
 12 files changed, 86 insertions(+), 92 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
index ee2b8e885608..abd8313f22e7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/init.c
@@ -280,7 +280,7 @@ int mt76x0_init_hardware(struct mt76x02_dev *dev)
 		return -ETIMEDOUT;
 
 	mt76x0_reset_csr_bbp(dev);
-	ret = mt76x02_mcu_function_select(&dev->mt76, Q_SELECT, 1, false);
+	ret = mt76x02_mcu_function_select(dev, Q_SELECT, 1, false);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 5c1045fbf699..3a5c7cd06265 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -185,7 +185,7 @@ static void mt76x0e_cleanup(struct mt76x02_dev *dev)
 	mt76x0_chip_onoff(dev, false, false);
 	mt76x0e_stop_hw(dev);
 	mt76x02_dma_cleanup(dev);
-	mt76x02_mcu_cleanup(&dev->mt76);
+	mt76x02_mcu_cleanup(dev);
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
index 4850a2db18d7..a59e2dcd83f7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/phy.c
@@ -587,7 +587,7 @@ mt76x0_bbp_set_bw(struct mt76x02_dev *dev, enum nl80211_chan_width width)
 		return ;
 	}
 
-	mt76x02_mcu_function_select(&dev->mt76, BW_SETTING, bw, false);
+	mt76x02_mcu_function_select(dev, BW_SETTING, bw, false);
 }
 
 void mt76x0_phy_set_txpower(struct mt76x02_dev *dev)
@@ -697,7 +697,7 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
 
 	mt76x0_vco_cal(dev, channel);
 	if (scan)
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 1, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
 
 	mt76x0_phy_set_txpower(dev);
 
@@ -710,7 +710,7 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	u8 channel = dev->mt76.chandef.chan->hw_value;
 	int is_5ghz = (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ) ? 1 : 0;
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_R, 0, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 
 	mt76x0_vco_cal(dev, channel);
 
@@ -722,22 +722,20 @@ void mt76x0_phy_recalibrate_after_assoc(struct mt76x02_dev *dev)
 	reg_val &= 0xffffff7e;
 	mt76_wr(dev, 0x2124, reg_val);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 0, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 0, false);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_LC, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_LOFT, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TX_GROUP_DELAY,
-			      is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RX_GROUP_DELAY,
-			      is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LC, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_LOFT, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_GROUP_DELAY, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQ, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RX_GROUP_DELAY, is_5ghz, false);
 
 	mt76_wr(dev, 0x2124, reg_val);
 	mt76_wr(dev, MT_TX_ALC_CFG_0, tx_alc);
 	msleep(100);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, 1, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
 }
 
 void mt76x0_agc_save(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 6d565133b7af..1b853bb723fb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -19,9 +19,7 @@
 #include <linux/firmware.h>
 #include <linux/delay.h>
 
-#include "mt76.h"
 #include "mt76x02_mcu.h"
-#include "mt76x02_dma.h"
 
 struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
 {
@@ -37,7 +35,7 @@ struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
 EXPORT_SYMBOL_GPL(mt76x02_mcu_msg_alloc);
 
 static struct sk_buff *
-mt76x02_mcu_get_response(struct mt76_dev *dev, unsigned long expires)
+mt76x02_mcu_get_response(struct mt76x02_dev *dev, unsigned long expires)
 {
 	unsigned long timeout;
 
@@ -45,17 +43,17 @@ mt76x02_mcu_get_response(struct mt76_dev *dev, unsigned long expires)
 		return NULL;
 
 	timeout = expires - jiffies;
-	wait_event_timeout(dev->mmio.mcu.wait,
-			   !skb_queue_empty(&dev->mmio.mcu.res_q),
+	wait_event_timeout(dev->mt76.mmio.mcu.wait,
+			   !skb_queue_empty(&dev->mt76.mmio.mcu.res_q),
 			   timeout);
-	return skb_dequeue(&dev->mmio.mcu.res_q);
+	return skb_dequeue(&dev->mt76.mmio.mcu.res_q);
 }
 
 static int
-mt76x02_tx_queue_mcu(struct mt76_dev *dev, enum mt76_txq_id qid,
+mt76x02_tx_queue_mcu(struct mt76x02_dev *dev, enum mt76_txq_id qid,
 		     struct sk_buff *skb, int cmd, int seq)
 {
-	struct mt76_queue *q = &dev->q_tx[qid];
+	struct mt76_queue *q = &dev->mt76.q_tx[qid];
 	struct mt76_queue_buf buf;
 	dma_addr_t addr;
 	u32 tx_info;
@@ -66,24 +64,26 @@ mt76x02_tx_queue_mcu(struct mt76_dev *dev, enum mt76_txq_id qid,
 		  FIELD_PREP(MT_MCU_MSG_PORT, CPU_TX_PORT) |
 		  FIELD_PREP(MT_MCU_MSG_LEN, skb->len);
 
-	addr = dma_map_single(dev->dev, skb->data, skb->len,
+	addr = dma_map_single(dev->mt76.dev, skb->data, skb->len,
 			      DMA_TO_DEVICE);
-	if (dma_mapping_error(dev->dev, addr))
+	if (dma_mapping_error(dev->mt76.dev, addr))
 		return -ENOMEM;
 
 	buf.addr = addr;
 	buf.len = skb->len;
+
 	spin_lock_bh(&q->lock);
-	dev->queue_ops->add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
-	dev->queue_ops->kick(dev, q);
+	mt76_queue_add_buf(dev, q, &buf, 1, tx_info, skb, NULL);
+	mt76_queue_kick(dev, q);
 	spin_unlock_bh(&q->lock);
 
 	return 0;
 }
 
-int mt76x02_mcu_msg_send(struct mt76_dev *dev, struct sk_buff *skb,
+int mt76x02_mcu_msg_send(struct mt76_dev *mdev, struct sk_buff *skb,
 			 int cmd, bool wait_resp)
 {
+	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	unsigned long expires = jiffies + HZ;
 	int ret;
 	u8 seq;
@@ -91,11 +91,11 @@ int mt76x02_mcu_msg_send(struct mt76_dev *dev, struct sk_buff *skb,
 	if (!skb)
 		return -EINVAL;
 
-	mutex_lock(&dev->mmio.mcu.mutex);
+	mutex_lock(&mdev->mmio.mcu.mutex);
 
-	seq = ++dev->mmio.mcu.msg_seq & 0xf;
+	seq = ++mdev->mmio.mcu.msg_seq & 0xf;
 	if (!seq)
-		seq = ++dev->mmio.mcu.msg_seq & 0xf;
+		seq = ++mdev->mmio.mcu.msg_seq & 0xf;
 
 	ret = mt76x02_tx_queue_mcu(dev, MT_TXQ_MCU, skb, cmd, seq);
 	if (ret)
@@ -107,7 +107,7 @@ int mt76x02_mcu_msg_send(struct mt76_dev *dev, struct sk_buff *skb,
 
 		skb = mt76x02_mcu_get_response(dev, expires);
 		if (!skb) {
-			dev_err(dev->dev,
+			dev_err(mdev->dev,
 				"MCU message %d (seq %d) timed out\n", cmd,
 				seq);
 			ret = -ETIMEDOUT;
@@ -125,13 +125,13 @@ int mt76x02_mcu_msg_send(struct mt76_dev *dev, struct sk_buff *skb,
 	}
 
 out:
-	mutex_unlock(&dev->mmio.mcu.mutex);
+	mutex_unlock(&mdev->mmio.mcu.mutex);
 
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_msg_send);
 
-int mt76x02_mcu_function_select(struct mt76_dev *dev,
+int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 				enum mcu_function func,
 				u32 val, bool wait_resp)
 {
@@ -144,13 +144,12 @@ int mt76x02_mcu_function_select(struct mt76_dev *dev,
 	    .value = cpu_to_le32(val),
 	};
 
-	skb = dev->mcu_ops->mcu_msg_alloc(&msg, sizeof(msg));
-	return dev->mcu_ops->mcu_send_msg(dev, skb, CMD_FUN_SET_OP,
-					  wait_resp);
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76_mcu_send_msg(dev, skb, CMD_FUN_SET_OP, wait_resp);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_function_select);
 
-int mt76x02_mcu_set_radio_state(struct mt76_dev *dev, bool on,
+int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 				bool wait_resp)
 {
 	struct sk_buff *skb;
@@ -162,13 +161,12 @@ int mt76x02_mcu_set_radio_state(struct mt76_dev *dev, bool on,
 		.level = cpu_to_le32(0),
 	};
 
-	skb = dev->mcu_ops->mcu_msg_alloc(&msg, sizeof(msg));
-	return dev->mcu_ops->mcu_send_msg(dev, skb, CMD_POWER_SAVING_OP,
-					  wait_resp);
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	return mt76_mcu_send_msg(dev, skb, CMD_POWER_SAVING_OP, wait_resp);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_set_radio_state);
 
-int mt76x02_mcu_calibrate(struct mt76_dev *dev, int type,
+int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 			  u32 param, bool wait)
 {
 	struct sk_buff *skb;
@@ -182,44 +180,44 @@ int mt76x02_mcu_calibrate(struct mt76_dev *dev, int type,
 	int ret;
 
 	if (wait)
-		dev->bus->rmw(dev, MT_MCU_COM_REG0, BIT(31), 0);
+		mt76_rmw(dev, MT_MCU_COM_REG0, BIT(31), 0);
 
-	skb = dev->mcu_ops->mcu_msg_alloc(&msg, sizeof(msg));
-	ret = dev->mcu_ops->mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
+	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
+	ret = mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
 	if (ret)
 		return ret;
 
 	if (wait &&
-	    WARN_ON(!__mt76_poll_msec(dev, MT_MCU_COM_REG0,
-				      BIT(31), BIT(31), 100)))
+	    WARN_ON(!mt76_poll_msec(dev, MT_MCU_COM_REG0,
+				    BIT(31), BIT(31), 100)))
 		return -ETIMEDOUT;
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_calibrate);
 
-int mt76x02_mcu_cleanup(struct mt76_dev *dev)
+int mt76x02_mcu_cleanup(struct mt76x02_dev *dev)
 {
 	struct sk_buff *skb;
 
-	dev->bus->wr(dev, MT_MCU_INT_LEVEL, 1);
+	mt76_wr(dev, MT_MCU_INT_LEVEL, 1);
 	usleep_range(20000, 30000);
 
-	while ((skb = skb_dequeue(&dev->mmio.mcu.res_q)) != NULL)
+	while ((skb = skb_dequeue(&dev->mt76.mmio.mcu.res_q)) != NULL)
 		dev_kfree_skb(skb);
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_cleanup);
 
-void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
+void mt76x02_set_ethtool_fwver(struct mt76x02_dev *dev,
 			       const struct mt76x02_fw_header *h)
 {
 	u16 bld = le16_to_cpu(h->build_ver);
 	u16 ver = le16_to_cpu(h->fw_ver);
 
-	snprintf(dev->hw->wiphy->fw_version,
-		 sizeof(dev->hw->wiphy->fw_version),
+	snprintf(dev->mt76.hw->wiphy->fw_version,
+		 sizeof(dev->mt76.hw->wiphy->fw_version),
 		 "%d.%d.%02d-b%x",
 		 (ver >> 12) & 0xf, (ver >> 8) & 0xf, ver & 0xf, bld);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index ce664f8b1c94..2d8fd2514570 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -17,6 +17,8 @@
 #ifndef __MT76x02_MCU_H
 #define __MT76x02_MCU_H
 
+#include "mt76x02.h"
+
 #define MT_MCU_RESET_CTL		0x070C
 #define MT_MCU_INT_LEVEL		0x0718
 #define MT_MCU_COM_REG0			0x0730
@@ -94,18 +96,18 @@ struct mt76x02_patch_header {
 	u8 pad[2];
 };
 
-int mt76x02_mcu_cleanup(struct mt76_dev *dev);
-int mt76x02_mcu_calibrate(struct mt76_dev *dev, int type,
+int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
+int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 			  u32 param, bool wait);
 struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len);
-int mt76x02_mcu_msg_send(struct mt76_dev *dev, struct sk_buff *skb,
+int mt76x02_mcu_msg_send(struct mt76_dev *mdev, struct sk_buff *skb,
 			 int cmd, bool wait_resp);
-int mt76x02_mcu_function_select(struct mt76_dev *dev,
+int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 				enum mcu_function func,
 				u32 val, bool wait_resp);
-int mt76x02_mcu_set_radio_state(struct mt76_dev *dev, bool on,
+int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 				bool wait_resp);
-void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
+void mt76x02_set_ethtool_fwver(struct mt76x02_dev *dev,
 			       const struct mt76x02_fw_header *h);
 
 #endif /* __MT76x02_MCU_H */
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index f229c6eb65dc..620a8c93c222 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -337,7 +337,7 @@ void mt76x2_stop_hardware(struct mt76x02_dev *dev)
 {
 	cancel_delayed_work_sync(&dev->cal_work);
 	cancel_delayed_work_sync(&dev->mac_work);
-	mt76x02_mcu_set_radio_state(&dev->mt76, false, true);
+	mt76x02_mcu_set_radio_state(dev, false, true);
 	mt76x2_mac_stop(dev, false);
 }
 
@@ -347,7 +347,7 @@ void mt76x2_cleanup(struct mt76x02_dev *dev)
 	tasklet_disable(&dev->pre_tbtt_tasklet);
 	mt76x2_stop_hardware(dev);
 	mt76x02_dma_cleanup(dev);
-	mt76x02_mcu_cleanup(&dev->mt76);
+	mt76x02_mcu_cleanup(dev);
 }
 
 struct mt76x02_dev *mt76x2_alloc_device(struct device *pdev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index 898aa229671c..563e2c459409 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -152,8 +152,8 @@ mt76pci_load_firmware(struct mt76x02_dev *dev)
 		return -ETIMEDOUT;
 	}
 
+	mt76x02_set_ethtool_fwver(dev, hdr);
 	dev_info(dev->mt76.dev, "Firmware running!\n");
-	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
 
 	release_firmware(fw);
 
@@ -183,6 +183,6 @@ int mt76x2_mcu_init(struct mt76x02_dev *dev)
 	if (ret)
 		return ret;
 
-	mt76x02_mcu_function_select(&dev->mt76, Q_SELECT, 1, true);
+	mt76x02_mcu_function_select(dev, Q_SELECT, 1, true);
 	return 0;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
index 40ea5f7480fb..bdc6fba217b1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_phy.c
@@ -38,7 +38,7 @@ mt76x2_phy_tssi_init_cal(struct mt76x02_dev *dev)
 	if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
 		flag |= BIT(8);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TSSI, flag, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, true);
 	dev->cal.tssi_cal_done = true;
 	return true;
 }
@@ -62,13 +62,13 @@ mt76x2_phy_channel_calibrate(struct mt76x02_dev *dev, bool mac_stopped)
 		mt76x2_mac_stop(dev, false);
 
 	if (is_5ghz)
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_LC, 0, true);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0, true);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TX_LOFT, is_5ghz, true);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TXIQ, is_5ghz, true);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXIQC_FI, is_5ghz, true);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TEMP_SENSOR, 0, true);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TX_SHAPING, 0, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_SHAPING, 0, true);
 
 	if (!mac_stopped)
 		mt76x2_mac_resume(dev);
@@ -364,14 +364,14 @@ int mt76x2_phy_set_channel(struct mt76x02_dev *dev,
 		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
-			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_R, 0, true);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, true);
 	}
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, channel, true);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel, true);
 
 	/* Rx LPF calibration */
 	if (!dev->cal.init_cal_done)
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RC, 0, true);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0, true);
 
 	dev->cal.init_cal_done = true;
 
@@ -449,7 +449,7 @@ int mt76x2_phy_start(struct mt76x02_dev *dev)
 {
 	int ret;
 
-	ret = mt76x02_mcu_set_radio_state(&dev->mt76, true, true);
+	ret = mt76x02_mcu_set_radio_state(dev, true, true);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
index f00aed915ee8..31bf0f891028 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/phy.c
@@ -289,8 +289,7 @@ void mt76x2_phy_tssi_compensate(struct mt76x02_dev *dev, bool wait)
 			return;
 
 		usleep_range(10000, 20000);
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_DPD,
-				      chan->hw_value, wait);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_DPD, chan->hw_value, wait);
 		dev->cal.dpd_cal_done = true;
 	}
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index c82f16efa327..7578c7dcd62a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -303,7 +303,7 @@ void mt76x2u_stop_hw(struct mt76x02_dev *dev)
 
 void mt76x2u_cleanup(struct mt76x02_dev *dev)
 {
-	mt76x02_mcu_set_radio_state(&dev->mt76, false, false);
+	mt76x02_mcu_set_radio_state(dev, false, false);
 	mt76x2u_stop_hw(dev);
 	mt76u_queues_deinit(&dev->mt76);
 	mt76u_mcu_deinit(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 259ceae2a3a9..0475bff454c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -260,8 +260,8 @@ static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 	mt76_set(dev, MT_MCU_COM_REG0, BIT(1));
 	/* enable FCE to send in-band cmd */
 	mt76_wr(dev, MT_FCE_PSE_CTRL, 0x1);
+	mt76x02_set_ethtool_fwver(dev, hdr);
 	dev_dbg(dev->mt76.dev, "firmware running\n");
-	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
 
 out:
 	release_firmware(fw);
@@ -283,10 +283,9 @@ int mt76x2u_mcu_init(struct mt76x02_dev *dev)
 {
 	int err;
 
-	err = mt76x02_mcu_function_select(&dev->mt76, Q_SELECT,
-					   1, false);
+	err = mt76x02_mcu_function_select(dev, Q_SELECT, 1, false);
 	if (err < 0)
 		return err;
 
-	return mt76x02_mcu_set_radio_state(&dev->mt76, true, false);
+	return mt76x02_mcu_set_radio_state(dev, true, false);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
index b11f8a6a6254..e0ffdd51dced 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_phy.c
@@ -29,12 +29,12 @@ void mt76x2u_phy_channel_calibrate(struct mt76x02_dev *dev)
 	mt76x2u_mac_stop(dev);
 
 	if (is_5ghz)
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_LC, 0, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_LC, 0, false);
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TX_LOFT, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TXIQ, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXIQC_FI, is_5ghz, false);
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TEMP_SENSOR, 0, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TX_LOFT, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TXIQ, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXIQC_FI, is_5ghz, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_TEMP_SENSOR, 0, false);
 
 	mt76x2u_mac_resume(dev);
 }
@@ -180,15 +180,14 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 		u8 val = mt76x02_eeprom_get(&dev->mt76, MT_EE_BT_RCAL_RESULT);
 
 		if (val != 0xff)
-			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_R,
-					      0, false);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_R, 0, false);
 	}
 
-	mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RXDCOC, channel, false);
+	mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, channel, false);
 
 	/* Rx LPF calibration */
 	if (!dev->cal.init_cal_done)
-		mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_RC, 0, false);
+		mt76x02_mcu_calibrate(dev, MCU_CAL_RC, 0, false);
 	dev->cal.init_cal_done = true;
 
 	mt76_wr(dev, MT_BBP(AGC, 61), 0xff64a4e2);
@@ -220,8 +219,7 @@ int mt76x2u_phy_set_channel(struct mt76x02_dev *dev,
 				flag |= BIT(0);
 			if (mt76x02_ext_pa_enabled(&dev->mt76, chan->band))
 				flag |= BIT(8);
-			mt76x02_mcu_calibrate(&dev->mt76, MCU_CAL_TSSI,
-					      flag, false);
+			mt76x02_mcu_calibrate(dev, MCU_CAL_TSSI, flag, false);
 			dev->cal.tssi_cal_done = true;
 		}
 	}
-- 
2.17.1

