Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECFB2C65BA7
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACD4720684
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 12:07:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ACD4720684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbeJDTAD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 15:00:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37994 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbeJDTAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 15:00:02 -0400
Received: by mail-wr1-f65.google.com with SMTP id a13-v6so9629643wrt.5
        for <linux-wireless@vger.kernel.org>; Thu, 04 Oct 2018 05:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hAFOvsPOKL+sx6rB8zMgq67khu1wtjFgEjM7ucdslgo=;
        b=qDw+X1EmlF/fxmKsejcIarKEpLaTkNi9WB87gsf43pNu8tmlQHpTKiBgHBQJztJuIh
         i+ODe4UPbsBFKYJ4xR+GjBNKW0BrEQmj6zwF+aHf+FfvQW3GHGQeeZ6T0EJH4jgQAytc
         v/xuzq4uDhfR07HNLsOLEGAotYrX3s2jG9Mo+zmBPYYvyZdXqphjJ5OCwl/rr46BNDr9
         WIvDBjCL9pGHUktiDEzUG43Z4gLXw/qdsdlctwGxgeHlq3khx7ZNUgnImdqttys+/i7/
         OfrgD2Dqepcg6risw2E9Qvwg28+ELPPcjoWuNDkUpjzx2/RObymdmNyjgDoq3o8vo8+B
         gP8g==
X-Gm-Message-State: ABuFfojXeyyDbKH/TnfyVw52zK66mrnNrYiLvYtSdu2PuwvJUrieKWL5
        5EXAPAL4Fx5kgjiKI8ENxKdPoQ==
X-Google-Smtp-Source: ACcGV63tJffgHOFOx4+JoQi9291fZdkJGgitZNOMIfCNsqltRyBGroJ9WxMLNScGTjwoXmkLDdAeeA==
X-Received: by 2002:adf:b30f:: with SMTP id j15-v6mr4733149wrd.207.1538654821505;
        Thu, 04 Oct 2018 05:07:01 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id j2-v6sm4991195wrw.29.2018.10.04.05.07.00
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Oct 2018 05:07:00 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [RFC 4/7] mt76: use mt76x02_dev instead of mt76_dev in mt76x02_usb_mcu.c
Date:   Thu,  4 Oct 2018 14:06:47 +0200
Message-Id: <2b564ea0fc6cb7404df520b41d1aa66737a31a07.1538654389.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
References: <cover.1538654389.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use mt76x02_dev data structure as reference in mt76x02_usb_mcu.c
instead of mt76_dev

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/usb_mcu.c   |  7 +++--
 .../net/wireless/mediatek/mt76/mt76x02_usb.h  |  6 ++---
 .../wireless/mediatek/mt76/mt76x02_usb_mcu.c  | 27 +++++++++----------
 .../wireless/mediatek/mt76/mt76x2/usb_mcu.c   | 11 ++++----
 4 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
index fb6fa1fa5548..a9f14d5149d1 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb_mcu.c
@@ -40,8 +40,7 @@ mt76x0u_upload_firmware(struct mt76x02_dev *dev,
 	ilm_len = le32_to_cpu(hdr->ilm_len) - MT_MCU_IVB_SIZE;
 	dev_dbg(dev->mt76.dev, "loading FW - ILM %u + IVB %u\n",
 		ilm_len, MT_MCU_IVB_SIZE);
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
-					fw_payload + MT_MCU_IVB_SIZE,
+	err = mt76x02u_mcu_fw_send_data(dev, fw_payload + MT_MCU_IVB_SIZE,
 					ilm_len, MCU_FW_URB_MAX_PAYLOAD,
 					MT_MCU_IVB_SIZE);
 	if (err)
@@ -49,7 +48,7 @@ mt76x0u_upload_firmware(struct mt76x02_dev *dev,
 
 	dlm_len = le32_to_cpu(hdr->dlm_len);
 	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
+	err = mt76x02u_mcu_fw_send_data(dev,
 					fw_payload + le32_to_cpu(hdr->ilm_len),
 					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
 					MT_MCU_DLM_OFFSET);
@@ -121,7 +120,7 @@ static int mt76x0u_load_firmware(struct mt76x02_dev *dev)
 	mt76_set(dev, MT_USB_DMA_CFG,
 		 (MT_USB_DMA_CFG_RX_BULK_EN | MT_USB_DMA_CFG_TX_BULK_EN) |
 		 FIELD_PREP(MT_USB_DMA_CFG_RX_BULK_AGG_TOUT, 0x20));
-	mt76x02u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(dev);
 	usleep_range(5000, 6000);
 /*
 	mt76x0_rmw(dev, MT_PBF_CFG, 0, (MT_PBF_CFG_TX0Q_EN |
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
index 6b2138328eb2..28aabcfd1195 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb.h
@@ -17,11 +17,11 @@
 #ifndef __MT76x02_USB_H
 #define __MT76x02_USB_H
 
-#include "mt76.h"
+#include "mt76x02.h"
 
 void mt76x02u_init_mcu(struct mt76_dev *dev);
-void mt76x02u_mcu_fw_reset(struct mt76_dev *dev);
-int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+void mt76x02u_mcu_fw_reset(struct mt76x02_dev *dev);
+int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset);
 
 int mt76x02u_skb_dma_info(struct sk_buff *skb, int port, u32 flags);
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index cb5f073f08af..da299b8a1334 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -17,8 +17,7 @@
 #include <linux/module.h>
 #include <linux/firmware.h>
 
-#include "mt76.h"
-#include "mt76x02_dma.h"
+#include "mt76x02.h"
 #include "mt76x02_mcu.h"
 #include "mt76x02_usb.h"
 
@@ -255,16 +254,16 @@ mt76x02u_mcu_rd_rp(struct mt76_dev *dev, u32 base,
 	return ret;
 }
 
-void mt76x02u_mcu_fw_reset(struct mt76_dev *dev)
+void mt76x02u_mcu_fw_reset(struct mt76x02_dev *dev)
 {
-	mt76u_vendor_request(dev, MT_VEND_DEV_MODE,
+	mt76u_vendor_request(&dev->mt76, MT_VEND_DEV_MODE,
 			     USB_DIR_OUT | USB_TYPE_VENDOR,
 			     0x1, 0, NULL, 0);
 }
 EXPORT_SYMBOL_GPL(mt76x02u_mcu_fw_reset);
 
 static int
-__mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
+__mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 			    const void *fw_data, int len, u32 dst_addr)
 {
 	u8 *data = sg_virt(&buf->urb->sg[0]);
@@ -281,14 +280,14 @@ __mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
 	memcpy(data + sizeof(info), fw_data, len);
 	memset(data + sizeof(info) + len, 0, 4);
 
-	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
+	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE,
 			MT_FCE_DMA_ADDR, dst_addr);
 	len = roundup(len, 4);
-	mt76u_single_wr(dev, MT_VEND_WRITE_FCE,
+	mt76u_single_wr(&dev->mt76, MT_VEND_WRITE_FCE,
 			MT_FCE_DMA_LEN, len << 16);
 
 	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
-	err = mt76u_submit_buf(dev, USB_DIR_OUT,
+	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
 			       MT_EP_OUT_INBAND_CMD,
 			       buf, GFP_KERNEL,
 			       mt76u_mcu_complete_urb, &cmpl);
@@ -297,31 +296,31 @@ __mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, struct mt76u_buf *buf,
 
 	if (!wait_for_completion_timeout(&cmpl,
 					 msecs_to_jiffies(1000))) {
-		dev_err(dev->dev, "firmware upload timed out\n");
+		dev_err(dev->mt76.dev, "firmware upload timed out\n");
 		usb_kill_urb(buf->urb);
 		return -ETIMEDOUT;
 	}
 
 	if (mt76u_urb_error(buf->urb)) {
-		dev_err(dev->dev, "firmware upload failed: %d\n",
+		dev_err(dev->mt76.dev, "firmware upload failed: %d\n",
 			buf->urb->status);
 		return buf->urb->status;
 	}
 
-	val = mt76u_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
+	val = mt76_rr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX);
 	val++;
-	mt76u_wr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX, val);
+	mt76_wr(dev, MT_TX_CPU_FROM_FCE_CPU_DESC_IDX, val);
 
 	return 0;
 }
 
-int mt76x02u_mcu_fw_send_data(struct mt76_dev *dev, const void *data,
+int mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, const void *data,
 			      int data_len, u32 max_payload, u32 offset)
 {
 	int err, len, pos = 0, max_len = max_payload - 8;
 	struct mt76u_buf buf;
 
-	err = mt76u_buf_alloc(dev, &buf, 1, max_payload, max_payload,
+	err = mt76u_buf_alloc(&dev->mt76, &buf, 1, max_payload, max_payload,
 			      GFP_KERNEL);
 	if (err < 0)
 		return err;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
index 0475bff454c0..3f1e558e5e6d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_mcu.c
@@ -137,7 +137,7 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_VEND_ADDR(CFG, MT_USB_U3DMA_CFG), val);
 
 	/* vendor reset */
-	mt76x02u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(dev);
 	usleep_range(5000, 10000);
 
 	/* enable FCE to send in-band cmd */
@@ -151,7 +151,7 @@ static int mt76x2u_mcu_load_rom_patch(struct mt76x02_dev *dev)
 	/* FCE skip_fs_en */
 	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
 
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+	err = mt76x02u_mcu_fw_send_data(dev, fw->data + sizeof(*hdr),
 					fw->size - sizeof(*hdr),
 					MCU_ROM_PATCH_MAX_PAYLOAD,
 					MT76U_MCU_ROM_PATCH_OFFSET);
@@ -210,7 +210,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 	dev_info(dev->mt76.dev, "Build Time: %.16s\n", hdr->build_time);
 
 	/* vendor reset */
-	mt76x02u_mcu_fw_reset(&dev->mt76);
+	mt76x02u_mcu_fw_reset(dev);
 	usleep_range(5000, 10000);
 
 	/* enable USB_DMA_CFG */
@@ -230,7 +230,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 	mt76_wr(dev, MT_FCE_SKIP_FS, 0x3);
 
 	/* load ILM */
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76, fw->data + sizeof(*hdr),
+	err = mt76x02u_mcu_fw_send_data(dev, fw->data + sizeof(*hdr),
 					ilm_len, MCU_FW_URB_MAX_PAYLOAD,
 					MT76U_MCU_ILM_OFFSET);
 	if (err < 0) {
@@ -241,8 +241,7 @@ static int mt76x2u_mcu_load_firmware(struct mt76x02_dev *dev)
 	/* load DLM */
 	if (mt76xx_rev(dev) >= MT76XX_REV_E3)
 		dlm_offset += 0x800;
-	err = mt76x02u_mcu_fw_send_data(&dev->mt76,
-					fw->data + sizeof(*hdr) + ilm_len,
+	err = mt76x02u_mcu_fw_send_data(dev, fw->data + sizeof(*hdr) + ilm_len,
 					dlm_len, MCU_FW_URB_MAX_PAYLOAD,
 					dlm_offset);
 	if (err < 0) {
-- 
2.17.1

