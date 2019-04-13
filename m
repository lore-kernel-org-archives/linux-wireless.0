Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F400BC282CE
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCC1E2084D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555164109;
	bh=D3JJTQC1P//3TawFjxLuH09hxLcIpWVNo0Y60YZtrv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=LfuOn3i2whk/DuBtlP5ec4tYffxV4qrPjZ4yvYs4WcV0o/T9c56FBZwEzM8lvtaAj
	 CXW/DqnPUheJp4IWPRXcYYte2loh5n6sW7JsG66+HtTj4TOsV5kCd9r5M3mjyiuFfL
	 UDs1dY8HOduS1bMpK1wlaZeLNGGE4lk3daPmPqhI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfDMOBs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 10:01:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfDMOBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 10:01:48 -0400
Received: from localhost.localdomain.com (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D3AD20848;
        Sat, 13 Apr 2019 14:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555164106;
        bh=D3JJTQC1P//3TawFjxLuH09hxLcIpWVNo0Y60YZtrv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkRzm1FAsFJBI0OQvNMdZq1E9X6Agn6NpiueAiWHMPu3giNFgw7J2SkSpETayCKSa
         JUZ9sQyRA3qJ2TuVoWlTz/76/rotndpsl1qdPPHMxHmZ5yMzSh1tbEzZtRY8Eh47Kr
         t4NufWDkCCCMeJ8YH949wtClRVJeGZ3rYLCGQcvA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] mt7603: remove query from mt7603_mcu_msg_send signature
Date:   Sat, 13 Apr 2019 16:01:24 +0200
Message-Id: <3e4e2d49aad1e8c5b9a567d0bff9bb0dadb91b2e.1555163776.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555163776.git.lorenzo@kernel.org>
References: <cover.1555163776.git.lorenzo@kernel.org>
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

