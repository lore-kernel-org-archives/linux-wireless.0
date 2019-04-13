Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8D0C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4C932084D
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 14:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555164123;
	bh=HXkmlXTgVRnExQ/N6/SrY5Wb8h1JVbdxiIXGbrraQjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=JHkYHYYYB69oe1N9EG10QHrlCIBS3uAq2kGhXi2FPt6/NVoLA6QyZeS6bcCdjHAnU
	 G11EL0YvgaofqpAlYAuZH+BUFgM7Ik1tQwf6PVkPAlSxdN70qwqUWsp0gZSOUWam9k
	 jN+IqbDmaqfAllwL13hPd1pD6hy0dsT1Xqtvaq/E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfDMOCC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 10:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726207AbfDMOCC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 10:02:02 -0400
Received: from localhost.localdomain.com (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C78E32084D;
        Sat, 13 Apr 2019 14:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555164120;
        bh=HXkmlXTgVRnExQ/N6/SrY5Wb8h1JVbdxiIXGbrraQjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=11PcLKpvpDQ/ir4n+/1usp09PJqqlec7HieeF1f3+v0Dia9uesOfikzr0MtM8XFQL
         B9TVSs2se238PJ//zGn9+50sAV0Dq/5Z20GMG2LlDZ8uwlslO8OJsWjnATh4P9FJkK
         sD5dP0qvuQC5jqkXaf5StA7Rs3/O5yWmZc9vpfzE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] mt7603: initialize mt76_mcu_ops data structure
Date:   Sat, 13 Apr 2019 16:01:26 +0200
Message-Id: <292d60a78c39c3d2b4e2923874f7578a9847fd77.1555163776.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1555163776.git.lorenzo@kernel.org>
References: <cover.1555163776.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use __mt76_mcu_send_msg wrapper instead of mt7603_mcu_msg_send.
This is a preliminary patch for mt7615-mt7603 mcu code unification

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76.h     |  1 +
 .../net/wireless/mediatek/mt76/mt7603/init.c  |  2 +-
 .../net/wireless/mediatek/mt76/mt7603/mcu.c   | 28 +++++++++++++------
 .../wireless/mediatek/mt76/mt7603/mt7603.h    |  2 +-
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index f0d34901c825..cff9c57d2838 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -536,6 +536,7 @@ struct mt76_rx_status {
 #define mt76_rd_rp(dev, ...)	(dev)->mt76.bus->rd_rp(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
+#define __mt76_mcu_send_msg(dev, ...)	(dev)->mcu_ops->mcu_send_msg((dev), __VA_ARGS__)
 
 #define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
 #define mt76_clear(dev, offset, val)	mt76_rmw(dev, offset, val, 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index 569c61b9b5ae..849261dc0e0b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -282,7 +282,7 @@ mt7603_init_hardware(struct mt7603_dev *dev)
 		mt76_poll(dev, MT_PSE_RTA, MT_PSE_RTA_BUSY, 0, 5000);
 	}
 
-	ret = mt7603_load_firmware(dev);
+	ret = mt7603_mcu_init(dev);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
index a978305cc969..c52ae301062c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mcu.c
@@ -54,10 +54,10 @@ __mt7603_mcu_msg_send(struct mt7603_dev *dev, struct sk_buff *skb,
 }
 
 static int
-mt7603_mcu_msg_send(struct mt7603_dev *dev, int cmd, const void *data,
+mt7603_mcu_msg_send(struct mt76_dev *mdev, int cmd, const void *data,
 		    int len, bool wait_resp)
 {
-	struct mt76_dev *mdev = &dev->mt76;
+	struct mt7603_dev *dev = container_of(mdev, struct mt7603_dev, mt76);
 	unsigned long expires = jiffies + 3 * HZ;
 	struct mt7603_mcu_rxd *rxd;
 	struct sk_buff *skb;
@@ -115,7 +115,7 @@ mt7603_mcu_init_download(struct mt7603_dev *dev, u32 addr, u32 len)
 		.mode = cpu_to_le32(BIT(31)),
 	};
 
-	return mt7603_mcu_msg_send(dev, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
+	return __mt76_mcu_send_msg(&dev->mt76, -MCU_CMD_TARGET_ADDRESS_LEN_REQ,
 				   &req, sizeof(req), true);
 }
 
@@ -156,18 +156,18 @@ mt7603_mcu_start_firmware(struct mt7603_dev *dev, u32 addr)
 		.addr = cpu_to_le32(addr),
 	};
 
-	return mt7603_mcu_msg_send(dev, -MCU_CMD_FW_START_REQ,
+	return __mt76_mcu_send_msg(&dev->mt76, -MCU_CMD_FW_START_REQ,
 				   &req, sizeof(req), true);
 }
 
 static int
 mt7603_mcu_restart(struct mt7603_dev *dev)
 {
-	return mt7603_mcu_msg_send(dev, -MCU_CMD_RESTART_DL_REQ,
+	return __mt76_mcu_send_msg(&dev->mt76, -MCU_CMD_RESTART_DL_REQ,
 				   NULL, 0, true);
 }
 
-int mt7603_load_firmware(struct mt7603_dev *dev)
+static int mt7603_load_firmware(struct mt7603_dev *dev)
 {
 	const struct firmware *fw;
 	const struct mt7603_fw_trailer *hdr;
@@ -265,6 +265,16 @@ int mt7603_load_firmware(struct mt7603_dev *dev)
 	return ret;
 }
 
+int mt7603_mcu_init(struct mt7603_dev *dev)
+{
+	static const struct mt76_mcu_ops mt7603_mcu_ops = {
+		.mcu_send_msg = mt7603_mcu_msg_send,
+	};
+
+	dev->mt76.mcu_ops = &mt7603_mcu_ops;
+	return mt7603_load_firmware(dev);
+}
+
 void mt7603_mcu_exit(struct mt7603_dev *dev)
 {
 	mt7603_mcu_restart(dev);
@@ -361,7 +371,7 @@ int mt7603_mcu_set_eeprom(struct mt7603_dev *dev)
 		req.data[i].pad = 0;
 	}
 
-	return mt7603_mcu_msg_send(dev, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
+	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_EFUSE_BUFFER_MODE,
 				   &req, sizeof(req), true);
 }
 
@@ -405,7 +415,7 @@ static int mt7603_mcu_set_tx_power(struct mt7603_dev *dev)
 	memcpy(req.temp_comp_power, eep + MT_EE_STEP_NUM_NEG_6_7,
 	       sizeof(req.temp_comp_power));
 
-	return mt7603_mcu_msg_send(dev, MCU_EXT_CMD_SET_TX_POWER_CTRL,
+	return __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_SET_TX_POWER_CTRL,
 				   &req, sizeof(req), true);
 }
 
@@ -451,7 +461,7 @@ int mt7603_mcu_set_channel(struct mt7603_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(req.txpower); i++)
 		req.txpower[i] = tx_power;
 
-	ret = mt7603_mcu_msg_send(dev, MCU_EXT_CMD_CHANNEL_SWITCH,
+	ret = __mt76_mcu_send_msg(&dev->mt76, MCU_EXT_CMD_CHANNEL_SWITCH,
 				  &req, sizeof(req), true);
 	if (ret)
 		return ret;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
index 9cc8ca7a4d1c..f414ff2a5279 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mt7603.h
@@ -176,7 +176,7 @@ void mt7603_unregister_device(struct mt7603_dev *dev);
 int mt7603_eeprom_init(struct mt7603_dev *dev);
 int mt7603_dma_init(struct mt7603_dev *dev);
 void mt7603_dma_cleanup(struct mt7603_dev *dev);
-int mt7603_load_firmware(struct mt7603_dev *dev);
+int mt7603_mcu_init(struct mt7603_dev *dev);
 void mt7603_init_debugfs(struct mt7603_dev *dev);
 
 static inline void mt7603_irq_enable(struct mt7603_dev *dev, u32 mask)
-- 
2.20.1

