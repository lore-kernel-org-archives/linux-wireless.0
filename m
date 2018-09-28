Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F7A0C43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 419C021547
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 11:39:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 419C021547
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbeI1SCw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 14:02:52 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40574 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729570AbeI1SCw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 14:02:52 -0400
Received: by mail-wr1-f68.google.com with SMTP id y8-v6so6034254wrh.7
        for <linux-wireless@vger.kernel.org>; Fri, 28 Sep 2018 04:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=V6aLmCTeRqKQDmGfz4tFVEhW7El7e4cR5NdIpV+nebE=;
        b=YQYYWJl7lfuAITeBy1u2+Isxw4EzkgX+FYci9F7QAGhHfX8E3C6pdCxJbOo2bH4CCs
         gQQcaENzATX+0+yWAJhimwzinaGWbL8mZ7fw+HFlUmHtgEblOofqs5bEh/TT+pUwfeUS
         MUGIomjwz0TwxA1eBWpgmdBuMwntsT/IIswg9i9dM1u1D7y2gNIWR3fYlvoTDolNdYGo
         kPY9MeeUPo1GlbHVmezJwLHA2VY+AQDvCNl0h9mQPaPxq9LQL8RTwxOpllWLwelDQzAc
         OamivTPTGtu+K4Db8Si1Q6yFR/xl8PaGMl1R1PlIbzC7Eexb/Q/xEjY7ZZ6beRheVHSx
         MSjA==
X-Gm-Message-State: ABuFfogBzYmNuUGUc+aE6jOfPG9D1FtNJXQnMrt92JYW9B5hFjuKdCoM
        j45q9llOBnRvqRHreVR02+pqDg==
X-Google-Smtp-Source: ACcGV62cNIz2NRFwH+7LmbBM+fVj26lIrayieizAN21bJHvOvd/I0I6SJXBoRViewyWHB/LOZTw6/g==
X-Received: by 2002:a5d:6782:: with SMTP id v2-v6mr12202566wru.245.1538134767356;
        Fri, 28 Sep 2018 04:39:27 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id s10-v6sm2395655wmd.22.2018.09.28.04.39.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Sep 2018 04:39:26 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH v3 11/24] mt76x0: usb: move mcu code in usb_mcu.c
Date:   Fri, 28 Sep 2018 13:38:54 +0200
Message-Id: <0b590ed58917578fa3b9e8640a60b470035429b3.1538134522.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
References: <cover.1538134522.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move usb mcu code in a dedicated source file in order to remove
usb dependency from generic source files and improve code
maintainability

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   | 157 ----------------
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   | 176 ++++++++++++++++++
 4 files changed, 178 insertions(+), 158 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 598c4f53a8a4..254d94efd24d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -5,7 +5,7 @@ obj-$(CONFIG_MT76x0_COMMON) += mt76x0-common.o
 mt76x0-common-y := \
 	init.o main.o trace.o eeprom.o phy.o \
 	mac.o debugfs.o tx.o
-mt76x0u-y := usb.o
+mt76x0u-y := usb.o usb_mcu.o
 mt76x0e-y := pci.o pci_mcu.o
 
 # ccflags-y := -DDEBUG
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index dae9da105238..297bf6b94d8c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -42,6 +42,7 @@ enum mcu_calibrate {
 };
 
 int mt76x0e_mcu_init(struct mt76x0_dev *dev);
+int mt76x0u_mcu_init(struct mt76x0_dev *dev);
 static inline int mt76x0_firmware_running(struct mt76x0_dev *dev)
 {
 	return mt76_rr(dev, MT_MCU_COM_REG0) == 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0d563462871f..7ad4dacb7411 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -13,7 +13,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/firmware.h>
 #include <linux/usb.h>
 
 #include "mt76x0.h"
@@ -22,8 +21,6 @@
 #include "../mt76x02_util.h"
 #include "../mt76x02_usb.h"
 
-#define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
-
 static struct usb_device_id mt76x0_device_table[] = {
 	{ USB_DEVICE(0x148F, 0x7610) },	/* MT7610U */
 	{ USB_DEVICE(0x13B1, 0x003E) },	/* Linksys AE6000 */
@@ -52,159 +49,6 @@ static struct usb_device_id mt76x0_device_table[] = {
 	{ 0, }
 };
 
-#define MCU_FW_URB_MAX_PAYLOAD		0x38f8
-#define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
-
-static int
-mt76x0u_upload_firmware(struct mt76x0_dev *dev,
-			const struct mt76x02_fw_header *hdr)
-{
-	u8 *fw_payload = (u8 *)(hdr + 1);
-	u32 ilm_len, dlm_len;
-	void *ivb;
-	int err;
-
-	ivb = kmemdup(fw_payload, MT_MCU_IVB_SIZE, GFP_KERNEL);
-	if (!ivb)
-		return -ENOMEM;
-
-	ilm_len = le32_to_cpu(hdr->ilm_len) - MT_MCU_IVB_SIZE;
-	dev_dbg(dev->mt76.dev, "loading FW - ILM %u + IVB %u\n",
-		ilm_len, MT_MCU_IVB_SIZE);
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
-					fw_payload + MT_MCU_IVB_SIZE,
-					ilm_len, MCU_FW_URB_MAX_PAYLOAD,
-					MT_MCU_IVB_SIZE);
-	if (err)
-		goto out;
-
-	dlm_len = le32_to_cpu(hdr->dlm_len);
-	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
-					fw_payload + le32_to_cpu(hdr->ilm_len),
-					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
-					MT_MCU_DLM_OFFSET);
-	if (err)
-		goto out;
-
-	err = mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
-				   USB_DIR_OUT | USB_TYPE_VENDOR,
-				   0x12, 0, ivb, MT_MCU_IVB_SIZE);
-	if (err < 0)
-		goto out;
-
-	if (!mt76_poll_msec(dev, MT_MCU_COM_REG0, 1, 1, 1000)) {
-		dev_err(dev->mt76.dev, "Firmware failed to start\n");
-		err = -ETIMEDOUT;
-		goto out;
-	}
-
-	dev_dbg(dev->mt76.dev, "Firmware running!\n");
-
-out:
-	kfree(ivb);
-
-	return err;
-}
-
-static int mt76x0u_load_firmware(struct mt76x0_dev *dev)
-{
-	const struct firmware *fw;
-	const struct mt76x02_fw_header *hdr;
-	int len, ret;
-	u32 val;
-
-	mt76_wr(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
-				      MT_USB_DMA_CFG_TX_BULK_EN));
-
-	if (mt76x0_firmware_running(dev))
-		return 0;
-
-	ret = request_firmware(&fw, MT7610U_FIRMWARE, dev->mt76.dev);
-	if (ret)
-		return ret;
-
-	if (!fw || !fw->data || fw->size < sizeof(*hdr))
-		goto err_inv_fw;
-
-	hdr = (const struct mt76x02_fw_header *)fw->data;
-
-	if (le32_to_cpu(hdr->ilm_len) <= MT_MCU_IVB_SIZE)
-		goto err_inv_fw;
-
-	len = sizeof(*hdr);
-	len += le32_to_cpu(hdr->ilm_len);
-	len += le32_to_cpu(hdr->dlm_len);
-
-	if (fw->size != len)
-		goto err_inv_fw;
-
-	val = le16_to_cpu(hdr->fw_ver);
-	dev_dbg(dev->mt76.dev,
-		"Firmware Version: %d.%d.%02d Build: %x Build time: %.16s\n",
-		(val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf,
-		le16_to_cpu(hdr->build_ver), hdr->build_time);
-
-	len = le32_to_cpu(hdr->ilm_len);
-
-	mt76_wr(dev, 0x1004, 0x2c);
-
-	mt76_set(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
-				       MT_USB_DMA_CFG_TX_BULK_EN) |
-				       FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
-	mt76x02u_mcu_fw_reset(&dev->mt76);
-	msleep(5);
-/*
-	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
-					 MT_PBF_CFG_TX1Q_EN |
-					 MT_PBF_CFG_TX2Q_EN |
-					 MT_PBF_CFG_TX3Q_EN));
-*/
-
-	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
-
-	/* FCE tx_fs_base_ptr */
-	mt76_wr(dev, MT_TX_CPU_FROM_FCE_BASE_PTR, 0x400230);
-	/* FCE tx_fs_max_cnt */
-	mt76_wr(dev, MT_TX_CPU_FROM_FCE_MAX_COUNT, 1);
-	/* FCE pdma enable */
-	mt76_wr(dev, MT_FCE_PDMA_GLOBAL_CONF, 0x44);
-	/* FCE skip_fs_en */
-	mt76_wr(dev, MT_FCE_SKIP_FS, 3);
-
-	val = mt76_rr(dev, MT_USB_DMA_CFG);
-	val |= MT_USB_DMA_CFG_UDMA_TX_WL_DROP;
-	mt76_wr(dev, MT_USB_DMA_CFG, val);
-	val &= ~MT_USB_DMA_CFG_UDMA_TX_WL_DROP;
-	mt76_wr(dev, MT_USB_DMA_CFG, val);
-
-	ret = mt76x0u_upload_firmware(dev, hdr);
-	mt76x02_set_ethtool_fwver(&dev->mt76, hdr);
-	release_firmware(fw);
-
-	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
-
-	return ret;
-
-err_inv_fw:
-	dev_err(dev->mt76.dev, "Invalid firmware image\n");
-	release_firmware(fw);
-	return -ENOENT;
-}
-
-static int mt76x0u_mcu_init(struct mt76x0_dev *dev)
-{
-	int ret;
-
-	ret = mt76x0u_load_firmware(dev);
-	if (ret < 0)
-		return ret;
-
-	set_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
-
-	return 0;
-}
-
 static int mt76x0u_probe(struct usb_interface *usb_intf,
 			 const struct usb_device_id *id)
 {
@@ -351,7 +195,6 @@ static int __maybe_unused mt76x0_resume(struct usb_interface *usb_intf)
 }
 
 MODULE_DEVICE_TABLE(usb, mt76x0_device_table);
-MODULE_FIRMWARE(MT7610U_FIRMWARE);
 MODULE_LICENSE("GPL");
 
 static struct usb_driver mt76x0_driver = {
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
new file mode 100644
index 000000000000..4c5b7a6f15ce
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright (C) 2018 Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/kernel.h>
+#include <linux/firmware.h>
+
+#include "mt76x0.h"
+#include "mcu.h"
+#include "../mt76x02_usb.h"
+
+#define MCU_FW_URB_MAX_PAYLOAD		0x38f8
+#define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
+#define MT7610U_FIRMWARE		"mediatek/mt7610u.bin"
+
+static int
+mt76x0u_upload_firmware(struct mt76x0_dev *dev,
+			const struct mt76x02_fw_header *hdr)
+{
+	u8 *fw_payload = (u8 *)(hdr + 1);
+	u32 ilm_len, dlm_len;
+	void *ivb;
+	int err;
+
+	ivb = kmemdup(fw_payload, MT_MCU_IVB_SIZE, GFP_KERNEL);
+	if (!ivb)
+		return -ENOMEM;
+
+	ilm_len = le32_to_cpu(hdr->ilm_len) - MT_MCU_IVB_SIZE;
+	dev_dbg(dev->mt76.dev, "loading FW - ILM %u + IVB %u\n",
+		ilm_len, MT_MCU_IVB_SIZE);
+	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
+					fw_payload + MT_MCU_IVB_SIZE,
+					ilm_len, MCU_FW_URB_MAX_PAYLOAD,
+					MT_MCU_IVB_SIZE);
+	if (err)
+		goto out;
+
+	dlm_len = le32_to_cpu(hdr->dlm_len);
+	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
+	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
+					fw_payload + le32_to_cpu(hdr->ilm_len),
+					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
+					MT_MCU_DLM_OFFSET);
+	if (err)
+		goto out;
+
+	err = mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
+				   USB_DIR_OUT | USB_TYPE_VENDOR,
+				   0x12, 0, ivb, MT_MCU_IVB_SIZE);
+	if (err < 0)
+		goto out;
+
+	if (!mt76_poll_msec(dev, MT_MCU_COM_REG0, 1, 1, 1000)) {
+		dev_err(dev->mt76.dev, "Firmware failed to start\n");
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	dev_dbg(dev->mt76.dev, "Firmware running!\n");
+
+out:
+	kfree(ivb);
+
+	return err;
+}
+
+static int mt76x0u_load_firmware(struct mt76x0_dev *dev)
+{
+	const struct firmware *fw;
+	const struct mt76x02_fw_header *hdr;
+	int len, ret;
+	u32 val;
+
+	mt76_wr(dev, MT_USB_DMA_CFG, (MT_USB_DMA_CFG_RX_BULK_EN |
+				      MT_USB_DMA_CFG_TX_BULK_EN));
+
+	if (mt76x0_firmware_running(dev))
+		return 0;
+
+	ret = request_firmware(&fw, MT7610U_FIRMWARE, dev->mt76.dev);
+	if (ret)
+		return ret;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr))
+		goto err_inv_fw;
+
+	hdr = (const struct mt76x02_fw_header *)fw->data;
+
+	if (le32_to_cpu(hdr->ilm_len) <= MT_MCU_IVB_SIZE)
+		goto err_inv_fw;
+
+	len = sizeof(*hdr);
+	len += le32_to_cpu(hdr->ilm_len);
+	len += le32_to_cpu(hdr->dlm_len);
+
+	if (fw->size != len)
+		goto err_inv_fw;
+
+	val = le16_to_cpu(hdr->fw_ver);
+	dev_dbg(dev->mt76.dev,
+		"Firmware Version: %d.%d.%02d Build: %x Build time: %.16s\n",
+		(val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf,
+		le16_to_cpu(hdr->build_ver), hdr->build_time);
+
+	len = le32_to_cpu(hdr->ilm_len);
+
+	mt76_wr(dev, 0x1004, 0x2c);
+
+	mt76_set(dev, MT_USB_DMA_CFG,
+		 (MT_USB_DMA_CFG_RX_BULK_EN | MT_USB_DMA_CFG_TX_BULK_EN) |
+		 FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
+	mt76x02u_mcu_fw_reset(&dev->mt76);
+	usleep_range(5000, 6000);
+/*
+	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
+					 MT_PBF_CFG_TX1Q_EN |
+					 MT_PBF_CFG_TX2Q_EN |
+					 MT_PBF_CFG_TX3Q_EN));
+*/
+
+	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
+
+	/* FCE tx_fs_base_ptr */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_BASE_PTR, 0x400230);
+	/* FCE tx_fs_max_cnt */
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_MAX_COUNT, 1);
+	/* FCE pdma enable */
+	mt76_wr(dev, MT_FCE_PDMA_GLOBAL_CONF, 0x44);
+	/* FCE skip_fs_en */
+	mt76_wr(dev, MT_FCE_SKIP_FS, 3);
+
+	val = mt76_rr(dev, MT_USB_DMA_CFG);
+	val |= MT_USB_DMA_CFG_UDMA_TX_WL_DROP;
+	mt76_wr(dev, MT_USB_DMA_CFG, val);
+	val &= ~MT_USB_DMA_CFG_UDMA_TX_WL_DROP;
+	mt76_wr(dev, MT_USB_DMA_CFG, val);
+
+	ret = mt76x0u_upload_firmware(dev, hdr);
+	release_firmware(fw);
+
+	mt76_wr(dev, MT_FCE_PSE_CTRL, 1);
+
+	return ret;
+
+err_inv_fw:
+	dev_err(dev->mt76.dev, "Invalid firmware image\n");
+	release_firmware(fw);
+	return -ENOENT;
+}
+
+int mt76x0u_mcu_init(struct mt76x0_dev *dev)
+{
+	int ret;
+
+	ret = mt76x0u_load_firmware(dev);
+	if (ret < 0)
+		return ret;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
+
+	return 0;
+}
+
+MODULE_FIRMWARE(MT7610U_FIRMWARE);
-- 
2.17.1

