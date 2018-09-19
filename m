Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40011 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbeISRbv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:31:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207-v6so6549647wme.5
        for <linux-wireless@vger.kernel.org>; Wed, 19 Sep 2018 04:54:15 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: nbd@nbd.name
Cc: linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: [PATCH] mt76x0: pci: add fw uploading routine
Date: Wed, 19 Sep 2018 13:53:58 +0200
Message-Id: <5cfdd943b73c2ffe92e23360e7668d688faaa687.1537357781.git.lorenzo.bianconi@redhat.com> (sfid-20180919_135419_742867_5B7F8160)
In-Reply-To: <cover.1537357781.git.lorenzo.bianconi@redhat.com>
References: <cover.1537357781.git.lorenzo.bianconi@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add pci load firmware routine. Move some shared mcu definitions
in mt76x02_mcu.h

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
This patch is based on top of Felix's pull request:
https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-09-19
---
 .../net/wireless/mediatek/mt76/mt76x0/mcu.h   |   5 +
 .../net/wireless/mediatek/mt76/mt76x0/pci.c   | 120 +++++++++++++++++-
 .../net/wireless/mediatek/mt76/mt76x0/usb.c   |   5 -
 .../net/wireless/mediatek/mt76/mt76x02_mcu.h  |   9 ++
 .../net/wireless/mediatek/mt76/mt76x2_mcu.h   |   7 -
 5 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
index f2a87d283e09..09c78a101593 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h
@@ -41,4 +41,9 @@ enum mcu_calibrate {
 	MCU_CAL_TX_GROUP_DELAY,
 };
 
+static inline int mt76x0_firmware_running(struct mt76x0_dev *dev)
+{
+	return mt76_rr(dev, MT_MCU_COM_REG0) == 1;
+}
+
 #endif
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index c5e47bc70202..76e6d52b3a64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -15,10 +15,122 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 
 #include "mt76x0.h"
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
+	if (mt76x0_firmware_running(dev))
+		return 0;
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
 
 static int
 mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
@@ -49,7 +161,13 @@ mt76x0e_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->mt76.rev = mt76_rr(dev, MT_ASIC_VERSION);
 	dev_info(dev->mt76.dev, "ASIC revision: %08x\n", dev->mt76.rev);
 
-/* error: */
+	ret = mt76x0e_load_firmware(dev);
+	if (ret < 0)
+		goto error;
+
+	return 0;
+
+error:
 	ieee80211_free_hw(mt76_hw(dev));
 	return ret;
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index bb8c0cd3d48a..94a2968147a3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -54,11 +54,6 @@ static struct usb_device_id mt76x0_device_table[] = {
 #define MCU_FW_URB_MAX_PAYLOAD		0x38f8
 #define MCU_FW_URB_SIZE			(MCU_FW_URB_MAX_PAYLOAD + 12)
 
-static inline int mt76x0_firmware_running(struct mt76x0_dev *dev)
-{
-	return mt76_rr(dev, MT_MCU_COM_REG0) == 1;
-}
-
 static int
 mt76x0u_upload_firmware(struct mt76x0_dev *dev,
 			const struct mt76x02_fw_header *hdr)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
index 2f5af3dad2bb..7bfd403f56f6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mcu.h
@@ -27,6 +27,15 @@
 #define MT_INBAND_PACKET_MAX_LEN	192
 #define MT_MCU_MEMMAP_WLAN		0x410000
 
+#define MT_MCU_PCIE_REMAP_BASE4		0x074C
+
+#define MT_MCU_SEMAPHORE_00		0x07B0
+#define MT_MCU_SEMAPHORE_01		0x07B4
+#define MT_MCU_SEMAPHORE_02		0x07B8
+#define MT_MCU_SEMAPHORE_03		0x07BC
+
+#define MT_MCU_ILM_ADDR			0x80000
+
 enum mcu_cmd {
 	CMD_FUN_SET_OP = 1,
 	CMD_LOAD_CR = 2,
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
index 3de062d0b644..fa72d5a5ecad 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.h
@@ -25,7 +25,6 @@
 #define MT_MCU_PCIE_REMAP_BASE1		0x0740
 #define MT_MCU_PCIE_REMAP_BASE2		0x0744
 #define MT_MCU_PCIE_REMAP_BASE3		0x0748
-#define MT_MCU_PCIE_REMAP_BASE4		0x074C
 
 #define MT_LED_CTRL			0x0770
 #define MT_LED_CTRL_REPLAY(_n)		BIT(0 + (8 * (_n)))
@@ -50,16 +49,10 @@
 #define MT_LED_STATUS_DURATION(_v)	(((_v) << __ffs(MT_LED_STATUS_DURATION_MASK)) & \
 					 MT_LED_STATUS_DURATION_MASK)
 
-#define MT_MCU_SEMAPHORE_00		0x07B0
-#define MT_MCU_SEMAPHORE_01		0x07B4
-#define MT_MCU_SEMAPHORE_02		0x07B8
-#define MT_MCU_SEMAPHORE_03		0x07BC
-
 #define MT_MCU_ROM_PATCH_OFFSET		0x80000
 #define MT_MCU_ROM_PATCH_ADDR		0x90000
 
 #define MT_MCU_ILM_OFFSET		0x80000
-#define MT_MCU_ILM_ADDR			0x80000
 
 #define MT_MCU_DLM_OFFSET		0x100000
 #define MT_MCU_DLM_ADDR			0x90000
-- 
2.17.1
