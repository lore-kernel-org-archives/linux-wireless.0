Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453F7C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E27220848
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555164118;
	bh=gi8MVHXI0mIv1QvbiqHXecgEezDwMiIY63JsDUz90cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xLQNPZrpkDzyvBVqpsKE0Qwwfe/x/4XTkNVlaJJW+ANBJr+tOOd+e5ZzEmU/6PTvO
	 8Lmj2tUze8zpgJjJBL6DOzJlmboiLtrEplrXZ/fEFhfoONESku1auuINbF6PWvb8P5
	 iw587xnAqnwJqtz5bUVsq9iB7jS4hBbnrDK1+70o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfDMOB5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 10:01:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfDMOB4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 10:01:56 -0400
Received: from localhost.localdomain.com (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8213320848;
        Sat, 13 Apr 2019 14:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555164115;
        bh=gi8MVHXI0mIv1QvbiqHXecgEezDwMiIY63JsDUz90cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vw39Q7VrZ8R3A8fvPUMe7i7Yb1tMS1lMQVKSPlk2Keavoq7cUwyqywKAAOt5CRL6V
         RA5EemGMfF/vZehAaW5mcRuWDDlWgmAzkyRjO640FCJmZ1Ovqx2p77cexAKdsAEccv
         cv+VjPTKadaghTcD/M8Y4YgJeg3nUq+A2hHQZQd4=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mt7603: use standard signature for mt7603_mcu_msg_send
Date:   Sat, 13 Apr 2019 16:01:25 +0200
Message-Id: <b949ee70544356898c14a8432aa6ec4434cb10fe.1555163776.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555163776.git.lorenzo@kernel.org>
References: <cover.1555163776.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76 common signature for mt7603_mcu_msg_send. Move skb allocation
in mt7603_mcu_msg_send and remove duplicated code. This is a preliminary
patch for mt7615-mt7603 mcu code unification

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 61 ++++++++-----------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 868a4b601a6f..a978305cc969 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -22,9 +22,6 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
 	struct mt7603_mcu_txd *txd;
 	u8 seq;
 
-	if (!skb)
-		return -EINVAL;
-
 	seq = ++mdev->mmio.mcu.msg_seq & 0xf;
 	if (!seq)
 		seq = ++mdev->mmio.mcu.msg_seq & 0xf;
@@ -57,20 +54,26 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
 }
 
 static int
-mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd)
+mt7603_mcu_msg_send(struct mt7603_dev *dev, int cmd, const void *data,
+		    int len, bool wait_resp)
 {
 	struct mt76_dev *mdev = &dev->mt76;
 	unsigned long expires = jiffies + 3 * HZ;
 	struct mt7603_mcu_rxd *rxd;
+	struct sk_buff *skb;
 	int ret, seq;
 
+	skb = mt7603_mcu_msg_alloc(data, len);
+	if (!skb)
+		return -ENOMEM;
+
 	mutex_lock(&mdev->mmio.mcu.mutex);
 
 	ret = __mt7603_mcu_msg_send(dev, skb, cmd, &seq);
 	if (ret)
 		goto out;
 
-	while (1) {
+	while (wait_resp) {
 		bool check_seq = false;
 
 		skb = mt76_mcu_get_response(&dev->mt76, expires);
@@ -111,9 +114,9 @@ mt7603_mcu_init_download(struct mt7603_dev *dev, u32 addr, u32 len)
 		.len = cpu_to_le32(len),
 		.mode = cpu_to_le32(BIT(31)),
 	};
-	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
 
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_TARGET_ADDRESS_LEN_REQ);
+	return mt7603_mcu_msg_send(dev, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
+				   &req, sizeof(req), true);
 }
 
 static int
@@ -152,17 +155,16 @@ mt7603_mcu_start_firmware(struct mt7603_dev *dev, u32 addr)
 		.override = cpu_to_le32(addr ? 1 : 0),
 		.addr = cpu_to_le32(addr),
 	};
-	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
 
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_START_REQ);
+	return mt7603_mcu_msg_send(dev, -MCU_CMD_FW_START_REQ,
+				   &req, sizeof(req), true);
 }
 
 static int
 mt7603_mcu_restart(struct mt7603_dev *dev)
 {
-	struct sk_buff *skb = mt7603_mcu_msg_alloc(NULL, 0);
-
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_RESTART_DL_REQ);
+	return mt7603_mcu_msg_send(dev, -MCU_CMD_RESTART_DL_REQ,
+				   NULL, 0, true);
 }
 
 int mt7603_load_firmware(struct mt7603_dev *dev)
@@ -343,30 +345,24 @@ int mt7603_mcu_set_eeprom(struct mt7603_dev *dev)
 		u8 buffer_mode;
 		u8 len;
 		u8 pad[2];
-	} req_hdr = {
+		struct req_data data[255];
+	} req = {
 		.buffer_mode = 1,
 		.len = ARRAY_SIZE(req_fields) - 1,
 	};
-	struct sk_buff *skb;
-	struct req_data *data;
-	const int size = 0xff * sizeof(struct req_data);
 	u8 *eep = (u8 *)dev->mt76.eeprom.data;
 	int i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(req_fields) * sizeof(*data) > size);
-
-	skb = mt7603_mcu_msg_alloc(NULL, size + sizeof(req_hdr));
-	memcpy(skb_put(skb, sizeof(req_hdr)), &req_hdr, sizeof(req_hdr));
-	data = (struct req_data *)skb_put(skb, size);
-	memset(data, 0, size);
+	BUILD_BUG_ON(ARRAY_SIZE(req_fields) > ARRAY_SIZE(req.data));
 
 	for (i = 0; i < ARRAY_SIZE(req_fields); i++) {
-		data[i].addr = cpu_to_le16(req_fields[i]);
-		data[i].val = eep[req_fields[i]];
-		data[i].pad = 0;
+		req.data[i].addr = cpu_to_le16(req_fields[i]);
+		req.data[i].val = eep[req_fields[i]];
+		req.data[i].pad = 0;
 	}
 
-	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_EFUSE_BUFFER_MODE);
+	return mt7603_mcu_msg_send(dev, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
+				   &req, sizeof(req), true);
 }
 
 static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
@@ -401,7 +397,6 @@ static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
 		},
 #undef EEP_VAL
 	};
-	struct sk_buff *skb;
 	u8 *eep = (u8 *)dev->mt76.eeprom.data;
 
 	memcpy(req.rate_power_delta, eep + MT_EE_TX_POWER_CCK,
@@ -410,8 +405,8 @@ static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
 	memcpy(req.temp_comp_power, eep + MT_EE_STEP_NUM_NEG_6_7,
 	       sizeof(req.temp_comp_power));
 
-	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
-	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_SET_TX_POWER_CTRL);
+	return mt7603_mcu_msg_send(dev, MCU_EXT_CMD_SET_TX_POWER_CTRL,
+				   &req, sizeof(req), true);
 }
 
 int mt7603_mcu_set_channel(struct mt7603_dev *dev)
@@ -435,10 +430,8 @@ int mt7603_mcu_set_channel(struct mt7603_dev *dev)
 		.tx_streams = n_chains,
 		.rx_streams = n_chains,
 	};
-	struct sk_buff *skb;
 	s8 tx_power;
-	int ret;
-	int i;
+	int i, ret;
 
 	if (dev->mt76.chandef.width == NL80211_CHAN_WIDTH_40) {
 		req.bw = MT_BW_40;
@@ -458,8 +451,8 @@ int mt7603_mcu_set_channel(struct mt7603_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(req.txpower); i++)
 		req.txpower[i] = tx_power;
 
-	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
-	ret = mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_CHANNEL_SWITCH);
+	ret = mt7603_mcu_msg_send(dev, MCU_EXT_CMD_CHANNEL_SWITCH,
+				  &req, sizeof(req), true);
 	if (ret)
 		return ret;
 
-- 
2.20.1

