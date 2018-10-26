Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AD94C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA2F22084D
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:00:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA2F22084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbeJZUhr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:37:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40530 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727469AbeJZUhq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:37:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D8CDF80F7C;
        Fri, 26 Oct 2018 12:00:56 +0000 (UTC)
Received: from localhost (unknown [10.40.205.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 24DA465F57;
        Fri, 26 Oct 2018 12:00:51 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH 1/4] mt76: remove mcu_msg_alloc
Date:   Fri, 26 Oct 2018 14:00:26 +0200
Message-Id: <1540555229-28582-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
References: <1540555229-28582-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 26 Oct 2018 12:00:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We almost always use patter like this:

       skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
       return mt76_mcu_send_msg(dev, skb, CMD_FUN_SET_OP, wait_resp);

This is not needed, we can allocate skb in mcu_send_msg routine.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76.h          |  6 ++---
 .../net/wireless/mediatek/mt76/mt76x0/pci_mcu.c    |  1 -
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c   | 26 ++++++++++------------
 drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h   |  5 ++---
 .../net/wireless/mediatek/mt76/mt76x02_usb_mcu.c   | 18 +++++++++------
 drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c    | 22 +++++++-----------
 .../net/wireless/mediatek/mt76/mt76x2/pci_mcu.c    |  1 -
 7 files changed, 35 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 94ab00b549af..e1d89163ee6b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -135,9 +135,8 @@ struct mt76_queue {
 };
 
 struct mt76_mcu_ops {
-	struct sk_buff *(*mcu_msg_alloc)(const void *data, int len);
-	int (*mcu_send_msg)(struct mt76_dev *dev, struct sk_buff *skb,
-			    int cmd, bool wait_resp);
+	int (*mcu_send_msg)(struct mt76_dev *dev, int cmd, const void *data,
+			    int len, bool wait_resp);
 	int (*mcu_wr_rp)(struct mt76_dev *dev, u32 base,
 			 const struct mt76_reg_pair *rp, int len);
 	int (*mcu_rd_rp)(struct mt76_dev *dev, u32 base,
@@ -503,7 +502,6 @@ struct mt76_rx_status {
 #define mt76_wr_rp(dev, ...)	(dev)->mt76.bus->wr_rp(&((dev)->mt76), __VA_ARGS__)
 #define mt76_rd_rp(dev, ...)	(dev)->mt76.bus->rd_rp(&((dev)->mt76), __VA_ARGS__)
 
-#define mt76_mcu_msg_alloc(dev, ...)	(dev)->mt76.mcu_ops->mcu_msg_alloc(__VA_ARGS__)
 #define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
index aca0ea318dce..490c1869f2c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -127,7 +127,6 @@ static int mt76x0e_load_firmware(struct mt76x02_dev *dev)
 int mt76x0e_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x0e_mcu_ops = {
-		.mcu_msg_alloc = mt76x02_mcu_msg_alloc,
 		.mcu_send_msg = mt76x02_mcu_msg_send,
 	};
 	int err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
index 1b853bb723fb..550e73f81438 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.c
@@ -21,7 +21,7 @@
 
 #include "mt76x02_mcu.h"
 
-struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
+static struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
 {
 	struct sk_buff *skb;
 
@@ -32,7 +32,6 @@ struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len)
 
 	return skb;
 }
-EXPORT_SYMBOL_GPL(mt76x02_mcu_msg_alloc);
 
 static struct sk_buff *
 mt76x02_mcu_get_response(struct mt76x02_dev *dev, unsigned long expires)
@@ -80,16 +79,18 @@ mt76x02_tx_queue_mcu(struct mt76x02_dev *dev, enum mt76_txq_id qid,
 	return 0;
 }
 
-int mt76x02_mcu_msg_send(struct mt76_dev *mdev, struct sk_buff *skb,
-			 int cmd, bool wait_resp)
+int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
+			 int len, bool wait_resp)
 {
 	struct mt76x02_dev *dev = container_of(mdev, struct mt76x02_dev, mt76);
 	unsigned long expires = jiffies + HZ;
+	struct sk_buff *skb;
 	int ret;
 	u8 seq;
 
+	skb = mt76x02_mcu_msg_alloc(data, len);
 	if (!skb)
-		return -EINVAL;
+		return -ENOMEM;
 
 	mutex_lock(&mdev->mmio.mcu.mutex);
 
@@ -135,7 +136,6 @@ int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 				enum mcu_function func,
 				u32 val, bool wait_resp)
 {
-	struct sk_buff *skb;
 	struct {
 	    __le32 id;
 	    __le32 value;
@@ -144,15 +144,14 @@ int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 	    .value = cpu_to_le32(val),
 	};
 
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_FUN_SET_OP, wait_resp);
+	return mt76_mcu_send_msg(dev, CMD_FUN_SET_OP, &msg, sizeof(msg),
+				 wait_resp);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_function_select);
 
 int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 				bool wait_resp)
 {
-	struct sk_buff *skb;
 	struct {
 		__le32 mode;
 		__le32 level;
@@ -161,15 +160,14 @@ int mt76x02_mcu_set_radio_state(struct mt76x02_dev *dev, bool on,
 		.level = cpu_to_le32(0),
 	};
 
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_POWER_SAVING_OP, wait_resp);
+	return mt76_mcu_send_msg(dev, CMD_POWER_SAVING_OP, &msg, sizeof(msg),
+				 wait_resp);
 }
 EXPORT_SYMBOL_GPL(mt76x02_mcu_set_radio_state);
 
 int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 			  u32 param, bool wait)
 {
-	struct sk_buff *skb;
 	struct {
 		__le32 id;
 		__le32 value;
@@ -182,8 +180,8 @@ int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 	if (wait)
 		mt76_rmw(dev, MT_MCU_COM_REG0, BIT(31), 0);
 
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	ret = mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
+	ret = mt76_mcu_send_msg(dev, CMD_CALIBRATION_OP, &msg, sizeof(msg),
+				true);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 2d8fd2514570..a3aee579d42c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -99,9 +99,8 @@ struct mt76x02_patch_header {
 int mt76x02_mcu_cleanup(struct mt76x02_dev *dev);
 int mt76x02_mcu_calibrate(struct mt76x02_dev *dev, int type,
 			  u32 param, bool wait);
-struct sk_buff *mt76x02_mcu_msg_alloc(const void *data, int len);
-int mt76x02_mcu_msg_send(struct mt76_dev *mdev, struct sk_buff *skb,
-			 int cmd, bool wait_resp);
+int mt76x02_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
+			 int len, bool wait_resp);
 int mt76x02_mcu_function_select(struct mt76x02_dev *dev,
 				enum mcu_function func,
 				u32 val, bool wait_resp);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index da299b8a1334..6db789f90269 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -129,9 +129,6 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 	u8 seq = 0;
 	u32 info;
 
-	if (!skb)
-		return -EINVAL;
-
 	if (test_bit(MT76_REMOVED, &dev->state))
 		return 0;
 
@@ -162,12 +159,17 @@ __mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
 }
 
 static int
-mt76x02u_mcu_send_msg(struct mt76_dev *dev, struct sk_buff *skb,
-		      int cmd, bool wait_resp)
+mt76x02u_mcu_send_msg(struct mt76_dev *dev, int cmd, const void *data,
+		      int len, bool wait_resp)
 {
 	struct mt76_usb *usb = &dev->usb;
+	struct sk_buff *skb;
 	int err;
 
+	skb = mt76x02u_mcu_msg_alloc(data, len);
+	if (!skb)
+		return -ENOMEM;
+
 	mutex_lock(&usb->mcu.mutex);
 	err = __mt76x02u_mcu_send_msg(dev, skb, cmd, wait_resp);
 	mutex_unlock(&usb->mcu.mutex);
@@ -186,6 +188,7 @@ mt76x02u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
 {
 	const int CMD_RANDOM_WRITE = 12;
 	const int max_vals_per_cmd = MT_INBAND_PACKET_MAX_LEN / 8;
+	struct mt76_usb *usb = &dev->usb;
 	struct sk_buff *skb;
 	int cnt, i, ret;
 
@@ -204,7 +207,9 @@ mt76x02u_mcu_wr_rp(struct mt76_dev *dev, u32 base,
 		skb_put_le32(skb, data[i].value);
 	}
 
-	ret = mt76x02u_mcu_send_msg(dev, skb, CMD_RANDOM_WRITE, cnt == n);
+	mutex_lock(&usb->mcu.mutex);
+	ret = __mt76x02u_mcu_send_msg(dev, skb, CMD_RANDOM_WRITE, cnt == n);
+	mutex_unlock(&usb->mcu.mutex);
 	if (ret)
 		return ret;
 
@@ -345,7 +350,6 @@ EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_send_data);
 void mt76x02u_init_mcu(struct mt76_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x02u_mcu_ops = {
-		.mcu_msg_alloc = mt76x02u_mcu_msg_alloc,
 		.mcu_send_msg = mt76x02u_mcu_send_msg,
 		.mcu_wr_rp = mt76x02u_mcu_wr_rp,
 		.mcu_rd_rp = mt76x02u_mcu_rd_rp,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
index 88bd62cfbdf9..cd3e082f486c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/mcu.c
@@ -26,7 +26,6 @@
 int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 			   u8 bw_index, bool scan)
 {
-	struct sk_buff *skb;
 	struct {
 		u8 idx;
 		u8 scan;
@@ -45,21 +44,19 @@ int mt76x2_mcu_set_channel(struct mt76x02_dev *dev, u8 channel, u8 bw,
 	};
 
 	/* first set the channel without the extension channel info */
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	mt76_mcu_send_msg(dev, skb, CMD_SWITCH_CHANNEL_OP, true);
+	mt76_mcu_send_msg(dev, CMD_SWITCH_CHANNEL_OP, &msg, sizeof(msg), true);
 
 	usleep_range(5000, 10000);
 
 	msg.ext_chan = 0xe0 + bw_index;
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_SWITCH_CHANNEL_OP, true);
+	return mt76_mcu_send_msg(dev, CMD_SWITCH_CHANNEL_OP, &msg, sizeof(msg),
+				 true);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_set_channel);
 
 int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 		       u8 channel)
 {
-	struct sk_buff *skb;
 	struct {
 		u8 cr_mode;
 		u8 temp;
@@ -80,15 +77,13 @@ int mt76x2_mcu_load_cr(struct mt76x02_dev *dev, u8 type, u8 temp_level,
 	msg.cfg = cpu_to_le32(val);
 
 	/* first set the channel without the extension channel info */
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_LOAD_CR, true);
+	return mt76_mcu_send_msg(dev, CMD_LOAD_CR, &msg, sizeof(msg), true);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_load_cr);
 
 int mt76x2_mcu_init_gain(struct mt76x02_dev *dev, u8 channel, u32 gain,
 			 bool force)
 {
-	struct sk_buff *skb;
 	struct {
 		__le32 channel;
 		__le32 gain_val;
@@ -100,15 +95,14 @@ int mt76x2_mcu_init_gain(struct mt76x02_dev *dev, u8 channel, u32 gain,
 	if (force)
 		msg.channel |= cpu_to_le32(BIT(31));
 
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_INIT_GAIN_OP, true);
+	return mt76_mcu_send_msg(dev, CMD_INIT_GAIN_OP, &msg, sizeof(msg),
+				 true);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_init_gain);
 
 int mt76x2_mcu_tssi_comp(struct mt76x02_dev *dev,
 			 struct mt76x2_tssi_comp *tssi_data)
 {
-	struct sk_buff *skb;
 	struct {
 		__le32 id;
 		struct mt76x2_tssi_comp data;
@@ -117,7 +111,7 @@ int mt76x2_mcu_tssi_comp(struct mt76x02_dev *dev,
 		.data = *tssi_data,
 	};
 
-	skb = mt76_mcu_msg_alloc(dev, &msg, sizeof(msg));
-	return mt76_mcu_send_msg(dev, skb, CMD_CALIBRATION_OP, true);
+	return mt76_mcu_send_msg(dev, CMD_CALIBRATION_OP, &msg, sizeof(msg),
+				 true);
 }
 EXPORT_SYMBOL_GPL(mt76x2_mcu_tssi_comp);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
index d8fa9ba56437..b5067ee0b001 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_mcu.c
@@ -168,7 +168,6 @@ mt76pci_load_firmware(struct mt76x02_dev *dev)
 int mt76x2_mcu_init(struct mt76x02_dev *dev)
 {
 	static const struct mt76_mcu_ops mt76x2_mcu_ops = {
-		.mcu_msg_alloc = mt76x02_mcu_msg_alloc,
 		.mcu_send_msg = mt76x02_mcu_msg_send,
 	};
 	int ret;
-- 
2.7.5

