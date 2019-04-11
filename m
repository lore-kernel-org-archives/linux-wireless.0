Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7306BC282CE
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 440982133D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554983574;
	bh=D3JJTQC1P//3TawFjxLuH09hxLcIpWVNo0Y60YZtrv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TKDpmLEcC0IF++xnQalSLQ2VNWcdu0wKiLqAZo1l3i4h1PYz6cxkNAZUxNqLBDO1k
	 I/VfNSZ0chcYXDGphNXfs72jnhgVw6MeoulVtc2dXvHkyi4oLXDpRoZbemn4debKR9
	 UsN14vhtj6nQ7tPcGL6r5YErgy8XSrvyjeCdSlWk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbfDKLwx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:32970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726628AbfDKLww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 07:52:52 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 893132133D;
        Thu, 11 Apr 2019 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554983571;
        bh=D3JJTQC1P//3TawFjxLuH09hxLcIpWVNo0Y60YZtrv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NR94tbOE618JfUiYOXg+Ca/A0lC+6g3U+0+Uz2nbtdNRorbcugaPc9gh/WVafbt2P
         Mo/5WAU14roXg8t23c1B6JKx1otHKr0TyxWAZ5vn/irafYuZwRGfVA6qPKEJv2C1eK
         B8z/pFQVy1myoP/4huYhYQw2lA3DDxrNdxeBZZfU=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 1/5] mt7603: remove query from mt7603_mcu_msg_send signature
Date:   Thu, 11 Apr 2019 13:52:33 +0200
Message-Id: <c37dd74a2cc4846b64344fb802a0ab386f5b7a81.1554982661.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554982661.git.lorenzo@kernel.org>
References: <cover.1554982661.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove query parameter from mt7603_mcu_msg_send/__mt7603_mcu_msg_send
routine signature since it can be obtained from cmd value. This is a
preliminary patch for mcu code unification between mt7615 and mt7603
drivers

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 36 ++++++++-----------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index 57481012ee47..868a4b601a6f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -14,8 +14,8 @@ struct mt7603_fw_trailer {
 } __packed;
 
 static int
-__mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
-		      int query, int *wait_seq)
+__mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
+		      int cmd, int *wait_seq)
 {
 	int hdrlen = dev->mcu_running ? sizeof(struct mt7603_mcu_txd) : 12;
 	struct mt76_dev *mdev = &dev->mt76;
@@ -42,15 +42,14 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
 
 	if (cmd < 0) {
 		txd->cid = -cmd;
+		txd->set_query = MCU_Q_NA;
 	} else {
 		txd->cid = MCU_CMD_EXT_CID;
 		txd->ext_cid = cmd;
-		if (query != MCU_Q_NA)
-			txd->ext_cid_ack = 1;
+		txd->set_query = MCU_Q_SET;
+		txd->ext_cid_ack = 1;
 	}
 
-	txd->set_query = query;
-
 	if (wait_seq)
 		*wait_seq = seq;
 
@@ -58,8 +57,7 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
 }
 
 static int
-mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
-		    int query)
+mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd)
 {
 	struct mt76_dev *mdev = &dev->mt76;
 	unsigned long expires = jiffies + 3 * HZ;
@@ -68,7 +66,7 @@ mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb, int cmd,
 
 	mutex_lock(&mdev->mmio.mcu.mutex);
 
-	ret = __mt7603_mcu_msg_send(dev, skb, cmd, query, &seq);
+	ret = __mt7603_mcu_msg_send(dev, skb, cmd, &seq);
 	if (ret)
 		goto out;
 
@@ -115,8 +113,7 @@ mt7603_mcu_init_download(struct mt7603_dev *dev, u32 addr, u32 len)
 	};
 	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
 
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
-				   MCU_Q_NA);
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_TARGET_ADDRESS_LEN_REQ);
 }
 
 static int
@@ -134,7 +131,7 @@ mt7603_mcu_send_firmware(struct mt7603_dev *dev, const void *data, int len)
 			return -ENOMEM;
 
 		ret = __mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_SCATTER,
-					    MCU_Q_NA, NULL);
+					    NULL);
 		if (ret)
 			break;
 
@@ -157,8 +154,7 @@ mt7603_mcu_start_firmware(struct mt7603_dev *dev, u32 addr)
 	};
 	struct sk_buff *skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
 
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_START_REQ,
-				   MCU_Q_NA);
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_FW_START_REQ);
 }
 
 static int
@@ -166,8 +162,7 @@ mt7603_mcu_restart(struct mt7603_dev *dev)
 {
 	struct sk_buff *skb = mt7603_mcu_msg_alloc(NULL, 0);
 
-	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_RESTART_DL_REQ,
-				   MCU_Q_NA);
+	return mt7603_mcu_msg_send(dev, skb, -MCU_CMD_RESTART_DL_REQ);
 }
 
 int mt7603_load_firmware(struct mt7603_dev *dev)
@@ -371,8 +366,7 @@ int mt7603_mcu_set_eeprom(struct mt7603_dev *dev)
 		data[i].pad = 0;
 	}
 
-	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
-				   MCU_Q_SET);
+	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_EFUSE_BUFFER_MODE);
 }
 
 static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
@@ -417,8 +411,7 @@ static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
 	       sizeof(req.temp_comp_power));
 
 	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
-	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_SET_TX_POWER_CTRL,
-				   MCU_Q_SET);
+	return mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_SET_TX_POWER_CTRL);
 }
 
 int mt7603_mcu_set_channel(struct mt7603_dev *dev)
@@ -466,8 +459,7 @@ int mt7603_mcu_set_channel(struct mt7603_dev *dev)
 		req.txpower[i] = tx_power;
 
 	skb = mt7603_mcu_msg_alloc(&req, sizeof(req));
-	ret = mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_CHANNEL_SWITCH,
-				  MCU_Q_SET);
+	ret = mt7603_mcu_msg_send(dev, skb, MCU_EXT_CMD_CHANNEL_SWITCH);
 	if (ret)
 		return ret;
 
-- 
2.20.1

