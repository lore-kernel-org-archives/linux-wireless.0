Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8841CC004D5
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ACE421580
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:02:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4ACE421580
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbeI0PTZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:19:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43837 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727340AbeI0PTZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:19:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id z14-v6so1679861wrs.10
        for <linux-wireless@vger.kernel.org>; Thu, 27 Sep 2018 02:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Agq1NqY8sAPkE3xlY8s5NGwuPUhSGzMLvn0oChNonOc=;
        b=XXMYQMMoC457MuMX2uqIxETG5pqwV40bglPF0RaVZtTee8ydrzNzFzVo0OiM0gv9vB
         EwYWHqiAyDUVs5mg58ygyB6p8RM8sWMEgJL5NM2pLGe0G2oXvreqQ1TWnTNhqqo79RjH
         IwCp1AJvKLzMtLOoF+HkCl/B1xEUjW5DDJ8rk0K3FDb/UwwrlLQBMaQOIkCh13StkUKe
         mqAXaJ7SUFdnFc69lAwufIhxiiNpn+7l2n/z8iGOpFEVDurXn7tTB+1rB8bn6bJIG0Jw
         Esks/2l1zmI4XEPG3tQh2D3/JQ3UlDyDHD7FkdynzKsHO7YzuWkYi+YNjiAqdLzf6uM6
         dvZw==
X-Gm-Message-State: ABuFfojLN49yzdi8cl3BNtEDxJDRZ2MA6ovuaqXFBHVYjvTOQBkvp5A7
        Ix/EyDe6uhg2hfN/J0HqWfAy5nvFldo=
X-Google-Smtp-Source: ACcGV62lChzcMH/mDlc2QMlGBJUQN/fS4SViV3y7D6V5hekvM967KAg7OFH1pIdKNwbxf6sH4fjuhw==
X-Received: by 2002:a5d:4b84:: with SMTP id b4-v6mr8318144wrt.168.1538038931513;
        Thu, 27 Sep 2018 02:02:11 -0700 (PDT)
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a17-v6sm1802382wme.40.2018.09.27.02.02.10
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 02:02:10 -0700 (PDT)
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     nbd@nbd.name
Cc:     sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: [PATCH 10/26] mt76x0: pci: move mcu code in pci_mcu.c
Date:   Thu, 27 Sep 2018 11:01:39 +0200
Message-Id: <ad84907d832ff51bcad2436076280f636ec0ce5b.1538036134.git.lorenzo.bianconi@redhat.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
References: <cover.1538036134.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Move pci mcu code in a dedicated source file in order to
improve maintainability and facilitate new device support
development

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
---
 .../wireless/mediatek/mt76/mt76x0/Makefile    |   2 +-
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   1 +
 .../wireless/mediatek/mt76/mt76x0/mt76x0.h    |   1 +
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 113 +-------------
 .../wireless/mediatek/mt76/mt76x0/pci_mcu.c   | 146 ++++++++++++++++++
 5 files changed, 150 insertions(+), 113 deletions(-)
 create mode 100644 drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
index 48f7979e36ef..598c4f53a8a4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/Makefile
@@ -6,7 +6,7 @@ mt76x0-common-y := \
 	init.o main.o trace.o eeprom.o phy.o \
 	mac.o debugfs.o tx.o
 mt76x0u-y := usb.o
-mt76x0e-y := pci.o
+mt76x0e-y := pci.o pci_mcu.o
 
 # ccflags-y := -DDEBUG
 CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index 09c78a101593..dae9da105238 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -41,6 +41,7 @@ enum mcu_calibrate {
 	MCU_CAL_TX_GROUP_DELAY,
 };
 
+int mt76x0e_mcu_init(struct mt76x0_dev *dev);
 static inline int mt76x0_firmware_running(struct mt76x0_dev *dev)
 {
 	return mt76_rr(dev, MT_MCU_COM_REG0) == 1;
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 66fcb90c1083..18fb763d6168 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -168,4 +168,5 @@ int mt76x0_tx_prepare_skb(struct mt76_dev *mdev, void *data,
 			  struct sk_buff *skb, struct mt76_queue *q,
 			  struct mt76_wcid *wcid, struct ieee80211_sta *sta,
 			  u32 *tx_info);
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 76e6d52b3a64..99d142319d1c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -15,123 +15,12 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
 #include "mt76x0.h"
 #include "mcu.h"
 
-#define MT7610E_FIRMWARE	"mediatek/mt7610e.bin"
-#define MT7650E_FIRMWARE	"mediatek/mt7650e.bin"
-
-#define MT_MCU_IVB_ADDR		(MT_MCU_ILM_ADDR + 0x54000 - MT_MCU_IVB_SIZE)
-
-static int mt76x0e_load_firmware(struct mt76x0_dev *dev)
-{
-	bool is_combo_chip = mt76_chip(&dev->mt76) != 0x7610;
-	u32 val, ilm_len, dlm_len, offset = 0;
-	const struct mt76x02_fw_header *hdr;
-	const struct firmware *fw;
-	const char *firmware;
-	const u8 *fw_payload;
-	int len, err;
-
-	if (mt76x0_firmware_running(dev))
-		return 0;
-
-	if (is_combo_chip)
-		firmware = MT7650E_FIRMWARE;
-	else
-		firmware = MT7610E_FIRMWARE;
-
-	err = request_firmware(&fw, firmware, dev->mt76.dev);
-	if (err)
-		return err;
-
-	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
-		err = -EIO;
-		goto out;
-	}
-
-	hdr = (const struct mt76x02_fw_header *)fw->data;
-
-	len = sizeof(*hdr);
-	len += le32_to_cpu(hdr->ilm_len);
-	len += le32_to_cpu(hdr->dlm_len);
-
-	if (fw->size != len) {
-		err = -EIO;
-		goto out;
-	}
-
-	fw_payload = fw->data + sizeof(*hdr);
-
-	val = le16_to_cpu(hdr->fw_ver);
-	dev_info(dev->mt76.dev, "Firmware Version: %d.%d.%02d\n",
-		 (val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf);
-
-	val = le16_to_cpu(hdr->fw_ver);
-	dev_dbg(dev->mt76.dev,
-		"Firmware Version: %d.%d.%02d Build: %x Build time: %.16s\n",
-		(val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf,
-		le16_to_cpu(hdr->build_ver), hdr->build_time);
-
-	if (is_combo_chip && !mt76_poll(dev, MT_MCU_SEMAPHORE_00, 1, 1, 600)) {
-		dev_err(dev->mt76.dev,
-			"Could not get hardware semaphore for loading fw\n");
-		err = -ETIMEDOUT;
-		goto out;
-	}
-
-	/* upload ILM. */
-	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
-	ilm_len = le32_to_cpu(hdr->ilm_len);
-	if (is_combo_chip) {
-		ilm_len -= MT_MCU_IVB_SIZE;
-		offset = MT_MCU_IVB_SIZE;
-	}
-	dev_dbg(dev->mt76.dev, "loading FW - ILM %u\n", ilm_len);
-	mt76_wr_copy(dev, MT_MCU_ILM_ADDR + offset, fw_payload + offset,
-		     ilm_len);
-
-	/* upload IVB. */
-	if (is_combo_chip) {
-		dev_dbg(dev->mt76.dev, "loading FW - IVB %u\n",
-			MT_MCU_IVB_SIZE);
-		mt76_wr_copy(dev, MT_MCU_IVB_ADDR, fw_payload, MT_MCU_IVB_SIZE);
-	}
-
-	/* upload DLM. */
-	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, MT_MCU_DLM_OFFSET);
-	dlm_len = le32_to_cpu(hdr->dlm_len);
-	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
-	mt76_wr_copy(dev, MT_MCU_ILM_ADDR,
-		     fw_payload + le32_to_cpu(hdr->ilm_len), dlm_len);
-
-	/* trigger firmware */
-	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
-	if (is_combo_chip)
-		mt76_wr(dev, MT_MCU_INT_LEVEL, 0x3);
-	else
-		mt76_wr(dev, MT_MCU_RESET_CTL, 0x300);
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
-	if (is_combo_chip)
-		mt76_wr(dev, MT_MCU_SEMAPHORE_00, 0x1);
-	release_firmware(fw);
-
-	return err;
-}
-
 static int
 mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
@@ -161,7 +50,7 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-	ret = mt76x0e_load_firmware(dev);
+	ret = mt76x0e_mcu_init(dev);
 	if (ret < 0)
 		goto error;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
new file mode 100644
index 000000000000..e3cf049314bb
--- /dev/null
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c
@@ -0,0 +1,146 @@
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
+
+#define MT7610E_FIRMWARE	"mediatek/mt7610e.bin"
+#define MT7650E_FIRMWARE	"mediatek/mt7650e.bin"
+
+#define MT_MCU_IVB_ADDR		(MT_MCU_ILM_ADDR + 0x54000 - MT_MCU_IVB_SIZE)
+
+static int mt76x0e_load_firmware(struct mt76x0_dev *dev)
+{
+	bool is_combo_chip = mt76_chip(&dev->mt76) != 0x7610;
+	u32 val, ilm_len, dlm_len, offset = 0;
+	const struct mt76x02_fw_header *hdr;
+	const struct firmware *fw;
+	const char *firmware;
+	const u8 *fw_payload;
+	int len, err;
+
+	if (is_combo_chip)
+		firmware = MT7650E_FIRMWARE;
+	else
+		firmware = MT7610E_FIRMWARE;
+
+	err = request_firmware(&fw, firmware, dev->mt76.dev);
+	if (err)
+		return err;
+
+	if (!fw || !fw->data || fw->size < sizeof(*hdr)) {
+		err = -EIO;
+		goto out;
+	}
+
+	hdr = (const struct mt76x02_fw_header *)fw->data;
+
+	len = sizeof(*hdr);
+	len += le32_to_cpu(hdr->ilm_len);
+	len += le32_to_cpu(hdr->dlm_len);
+
+	if (fw->size != len) {
+		err = -EIO;
+		goto out;
+	}
+
+	fw_payload = fw->data + sizeof(*hdr);
+
+	val = le16_to_cpu(hdr->fw_ver);
+	dev_info(dev->mt76.dev, "Firmware Version: %d.%d.%02d\n",
+		 (val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf);
+
+	val = le16_to_cpu(hdr->fw_ver);
+	dev_dbg(dev->mt76.dev,
+		"Firmware Version: %d.%d.%02d Build: %x Build time: %.16s\n",
+		(val >> 12) & 0xf, (val >> 8) & 0xf, val & 0xf,
+		le16_to_cpu(hdr->build_ver), hdr->build_time);
+
+	if (is_combo_chip && !mt76_poll(dev, MT_MCU_SEMAPHORE_00, 1, 1, 600)) {
+		dev_err(dev->mt76.dev,
+			"Could not get hardware semaphore for loading fw\n");
+		err = -ETIMEDOUT;
+		goto out;
+	}
+
+	/* upload ILM. */
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
+	ilm_len = le32_to_cpu(hdr->ilm_len);
+	if (is_combo_chip) {
+		ilm_len -= MT_MCU_IVB_SIZE;
+		offset = MT_MCU_IVB_SIZE;
+	}
+	dev_dbg(dev->mt76.dev, "loading FW - ILM %u\n", ilm_len);
+	mt76_wr_copy(dev, MT_MCU_ILM_ADDR + offset, fw_payload + offset,
+		     ilm_len);
+
+	/* upload IVB. */
+	if (is_combo_chip) {
+		dev_dbg(dev->mt76.dev, "loading FW - IVB %u\n",
+			MT_MCU_IVB_SIZE);
+		mt76_wr_copy(dev, MT_MCU_IVB_ADDR, fw_payload, MT_MCU_IVB_SIZE);
+	}
+
+	/* upload DLM. */
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, MT_MCU_DLM_OFFSET);
+	dlm_len = le32_to_cpu(hdr->dlm_len);
+	dev_dbg(dev->mt76.dev, "loading FW - DLM %u\n", dlm_len);
+	mt76_wr_copy(dev, MT_MCU_ILM_ADDR,
+		     fw_payload + le32_to_cpu(hdr->ilm_len), dlm_len);
+
+	/* trigger firmware */
+	mt76_wr(dev, MT_MCU_PCIE_REMAP_BASE4, 0);
+	if (is_combo_chip)
+		mt76_wr(dev, MT_MCU_INT_LEVEL, 0x3);
+	else
+		mt76_wr(dev, MT_MCU_RESET_CTL, 0x300);
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
+	if (is_combo_chip)
+		mt76_wr(dev, MT_MCU_SEMAPHORE_00, 0x1);
+	release_firmware(fw);
+
+	return err;
+}
+
+int mt76x0e_mcu_init(struct mt76x0_dev *dev)
+{
+	static const struct mt76_mcu_ops mt76x0e_mcu_ops = {
+		.mcu_msg_alloc = mt76x02_mcu_msg_alloc,
+		.mcu_send_msg = mt76x02_mcu_msg_send,
+	};
+	int err;
+
+	dev->mt76.mcu_ops = &mt76x0e_mcu_ops;
+
+	err = mt76x0e_load_firmware(dev);
+	if (err < 0)
+		return err;
+
+	set_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
+
+	return 0;
+}
-- 
2.17.1

