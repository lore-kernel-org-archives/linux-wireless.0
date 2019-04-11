Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C663EC10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 972D221850
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 11:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554983578;
	bh=60PTbIvO0ea1a+MIH/nXO11yYjeAXYC/dHbUpNmI3B4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Kx/t4OapA3Ypv0K+EDsoGJ3spLcgxPF/BRrjD06adv01fjlNUKNFdu06SNqGfYGUg
	 C8jT7CbWtSKx4rZxspeK0EJvRw0aNT5CAw0aZC+HJq/VPd12e4J0cA//a0XtNuh3DX
	 hpPh8EPpp/d9DeuwV3Sz+BZq/sCpeYQjoCIfmo1c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfDKLw5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 07:52:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726742AbfDKLw4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 07:52:56 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC5752184E;
        Thu, 11 Apr 2019 11:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554983575;
        bh=60PTbIvO0ea1a+MIH/nXO11yYjeAXYC/dHbUpNmI3B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YSISybPKG/ZJp76e3mg62s6z8PaKAMZ4LlzB5+6cuQqOuzcZo19x/ha7C9K3m5c6
         X0xfx4IPi50CgNNgw1ZB9mOAKgSMoLi+dm3tpq9p+2hiy1yj9rbublWaJOf2wlddn+
         su8ij7jt1P27LqXMpibZh4Ji3QqcAm4pz5+iIuzg=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     lorenzo.bianconi@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 3/5] mt7603: initialize mt76_mcu_ops data structure
Date:   Thu, 11 Apr 2019 13:52:35 +0200
Message-Id: <83d732e026d3296255353703b9883a05007f2004.1554982661.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1554982661.git.lorenzo@kernel.org>
References: <cover.1554982661.git.lorenzo@kernel.org>
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
index b432da3f55c7..a23ec92fae97 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -536,6 +536,7 @@ struct mt76_rx_status {
 #define mt76_rd_rp(dev, ...)	(dev)->mt76.bus->rd_rp(&((dev)->mt76), __VA_ARGS__)
 
 #define mt76_mcu_send_msg(dev, ...)	(dev)->mt76.mcu_ops->mcu_send_msg(&((dev)->mt76), __VA_ARGS__)
+#define __mt76_mcu_send_msg(dev, ...)	(dev)->mcu_ops->mcu_send_msg((dev), __VA_ARGS__)
 
 #define mt76_set(dev, offset, val)	mt76_rmw(dev, offset, 0, val)
 #define mt76_clear(dev, offset, val)	mt76_rmw(dev, offset, val, 0)
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index e17b6b89dfe2..d54dda67d036 100644
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

