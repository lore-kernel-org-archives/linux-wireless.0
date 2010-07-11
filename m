Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:57913 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab0GKKcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:32:14 -0400
Received: by mail-ew0-f46.google.com with SMTP id 23so640186ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Jul 2010 03:32:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 16/17] rt2x00: Move common firmware loading into rt2800lib
Date: Sun, 11 Jul 2010 12:30:37 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
References: <201007111223.11190.IvDoorn@gmail.com> <201007111229.50936.IvDoorn@gmail.com> <201007111230.14710.IvDoorn@gmail.com>
In-Reply-To: <201007111230.14710.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201007111230.38605.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Large parts of the firmware initialization are shared
between rt2800pci and rt2800usb. Move this code into
rt2800lib.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  155 +++++++++++++++++++++++++++++++
 drivers/net/wireless/rt2x00/rt2800lib.h |   15 +++
 drivers/net/wireless/rt2x00/rt2800pci.c |  101 +-------------------
 drivers/net/wireless/rt2x00/rt2800usb.c |  119 +-----------------------
 4 files changed, 179 insertions(+), 211 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9587236..b66e0fd 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -33,6 +33,7 @@
 	Abstract: rt2800 generic device routines.
  */
 
+#include <linux/crc-ccitt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -272,6 +273,160 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_wait_wpdma_ready);
 
+static bool rt2800_check_firmware_crc(const u8 *data, const size_t len)
+{
+	u16 fw_crc;
+	u16 crc;
+
+	/*
+	 * The last 2 bytes in the firmware array are the crc checksum itself,
+	 * this means that we should never pass those 2 bytes to the crc
+	 * algorithm.
+	 */
+	fw_crc = (data[len - 2] << 8 | data[len - 1]);
+
+	/*
+	 * Use the crc ccitt algorithm.
+	 * This will return the same value as the legacy driver which
+	 * used bit ordering reversion on the both the firmware bytes
+	 * before input input as well as on the final output.
+	 * Obviously using crc ccitt directly is much more efficient.
+	 */
+	crc = crc_ccitt(~0, data, len - 2);
+
+	/*
+	 * There is a small difference between the crc-itu-t + bitrev and
+	 * the crc-ccitt crc calculation. In the latter method the 2 bytes
+	 * will be swapped, use swab16 to convert the crc to the correct
+	 * value.
+	 */
+	crc = swab16(crc);
+
+	return fw_crc == crc;
+}
+
+int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
+			  const u8 *data, const size_t len)
+{
+	size_t offset = 0;
+	size_t fw_len;
+	bool multiple;
+
+	/*
+	 * PCI(e) & SOC devices require firmware with a length
+	 * of 8kb. USB devices require firmware files with a length
+	 * of 4kb. Certain USB chipsets however require different firmware,
+	 * which Ralink only provides attached to the original firmware
+	 * file. Thus for USB devices, firmware files have a length
+	 * which is a multiple of 4kb.
+	 */
+	if (rt2x00_is_usb(rt2x00dev)) {
+		fw_len = 4096;
+		multiple = true;
+	} else {
+		fw_len = 8192;
+		multiple = true;
+	}
+
+	/*
+	 * Validate the firmware length
+	 */
+	if (len != fw_len && (!multiple || (len % fw_len) != 0))
+		return FW_BAD_LENGTH;
+
+	/*
+	 * Check if the chipset requires one of the upper parts
+	 * of the firmware.
+	 */
+	if (rt2x00_is_usb(rt2x00dev) &&
+	    !rt2x00_rt(rt2x00dev, RT2860) &&
+	    !rt2x00_rt(rt2x00dev, RT2872) &&
+	    !rt2x00_rt(rt2x00dev, RT3070) &&
+	    ((len / fw_len) == 1))
+		return FW_BAD_VERSION;
+
+	/*
+	 * 8kb firmware files must be checked as if it were
+	 * 2 separate firmware files.
+	 */
+	while (offset < len) {
+		if (!rt2800_check_firmware_crc(data + offset, fw_len))
+			return FW_BAD_CRC;
+
+		offset += fw_len;
+	}
+
+	return FW_OK;
+}
+EXPORT_SYMBOL_GPL(rt2800_check_firmware);
+
+int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
+			 const u8 *data, const size_t len)
+{
+	unsigned int i;
+	u32 reg;
+
+	/*
+	 * Wait for stable hardware.
+	 */
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
+		if (reg && reg != ~0)
+			break;
+		msleep(1);
+	}
+
+	if (i == REGISTER_BUSY_COUNT) {
+		ERROR(rt2x00dev, "Unstable hardware.\n");
+		return -EBUSY;
+	}
+
+	if (rt2x00_is_pci(rt2x00dev))
+		rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
+
+	/*
+	 * Disable DMA, will be reenabled later when enabling
+	 * the radio.
+	 */
+	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
+	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
+	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
+
+	/*
+	 * Write firmware to the device.
+	 */
+	rt2800_drv_write_firmware(rt2x00dev, data, len);
+
+	/*
+	 * Wait for device to stabilize.
+	 */
+	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
+		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
+			break;
+		msleep(1);
+	}
+
+	if (i == REGISTER_BUSY_COUNT) {
+		ERROR(rt2x00dev, "PBF system register not ready.\n");
+		return -EBUSY;
+	}
+
+	/*
+	 * Initialize firmware.
+	 */
+	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
+	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	msleep(1);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rt2800_load_firmware);
+
 void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc)
 {
 	u32 word;
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.h b/drivers/net/wireless/rt2x00/rt2800lib.h
index 10f8f2f..cecbd3a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.h
+++ b/drivers/net/wireless/rt2x00/rt2800lib.h
@@ -41,6 +41,8 @@ struct rt2800_ops {
 			    const unsigned int offset,
 			    const struct rt2x00_field32 field, u32 *reg);
 
+	int (*drv_write_firmware)(struct rt2x00_dev *rt2x00dev,
+				  const u8 *data, const size_t len);
 	int (*drv_init_registers)(struct rt2x00_dev *rt2x00dev);
 };
 
@@ -109,6 +111,14 @@ static inline int rt2800_regbusy_read(struct rt2x00_dev *rt2x00dev,
 	return rt2800ops->regbusy_read(rt2x00dev, offset, field, reg);
 }
 
+static inline int rt2800_drv_write_firmware(struct rt2x00_dev *rt2x00dev,
+					    const u8 *data, const size_t len)
+{
+	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
+
+	return rt2800ops->drv_write_firmware(rt2x00dev, data, len);
+}
+
 static inline int rt2800_drv_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	const struct rt2800_ops *rt2800ops = rt2x00dev->priv;
@@ -120,6 +130,11 @@ void rt2800_mcu_request(struct rt2x00_dev *rt2x00dev,
 			const u8 command, const u8 token,
 			const u8 arg0, const u8 arg1);
 
+int rt2800_check_firmware(struct rt2x00_dev *rt2x00dev,
+			  const u8 *data, const size_t len);
+int rt2800_load_firmware(struct rt2x00_dev *rt2x00dev,
+			 const u8 *data, const size_t len);
+
 void rt2800_write_txwi(__le32 *txwi, struct txentry_desc *txdesc);
 void rt2800_process_rxwi(struct queue_entry *entry, struct rxdone_entry_desc *txdesc);
 
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index 520236d..0fdd58b 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -31,7 +31,6 @@
 	Supported chipsets: RT2800E & RT2800ED.
  */
 
-#include <linux/crc-ccitt.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -192,82 +191,14 @@ static char *rt2800pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return FIRMWARE_RT2860;
 }
 
-static int rt2800pci_check_firmware(struct rt2x00_dev *rt2x00dev,
+static int rt2800pci_write_firmware(struct rt2x00_dev *rt2x00dev,
 				    const u8 *data, const size_t len)
 {
-	u16 fw_crc;
-	u16 crc;
-
-	/*
-	 * Only support 8kb firmware files.
-	 */
-	if (len != 8192)
-		return FW_BAD_LENGTH;
-
-	/*
-	 * The last 2 bytes in the firmware array are the crc checksum itself,
-	 * this means that we should never pass those 2 bytes to the crc
-	 * algorithm.
-	 */
-	fw_crc = (data[len - 2] << 8 | data[len - 1]);
-
-	/*
-	 * Use the crc ccitt algorithm.
-	 * This will return the same value as the legacy driver which
-	 * used bit ordering reversion on the both the firmware bytes
-	 * before input input as well as on the final output.
-	 * Obviously using crc ccitt directly is much more efficient.
-	 */
-	crc = crc_ccitt(~0, data, len - 2);
-
-	/*
-	 * There is a small difference between the crc-itu-t + bitrev and
-	 * the crc-ccitt crc calculation. In the latter method the 2 bytes
-	 * will be swapped, use swab16 to convert the crc to the correct
-	 * value.
-	 */
-	crc = swab16(crc);
-
-	return (fw_crc == crc) ? FW_OK : FW_BAD_CRC;
-}
-
-static int rt2800pci_load_firmware(struct rt2x00_dev *rt2x00dev,
-				   const u8 *data, const size_t len)
-{
-	unsigned int i;
 	u32 reg;
 
-	/*
-	 * Wait for stable hardware.
-	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg && reg != ~0)
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "Unstable hardware.\n");
-		return -EBUSY;
-	}
-
-	rt2800_register_write(rt2x00dev, PWR_PIN_CFG, 0x00000002);
 	rt2800_register_write(rt2x00dev, AUTOWAKEUP_CFG, 0x00000000);
 
 	/*
-	 * Disable DMA, will be reenabled later when enabling
-	 * the radio.
-	 */
-	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_RX_DMA_BUSY, 0);
-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_TX_WRITEBACK_DONE, 1);
-	rt2800_register_write(rt2x00dev, WPDMA_GLO_CFG, reg);
-
-	/*
 	 * enable Host program ram write selection
 	 */
 	reg = 0;
@@ -278,34 +209,11 @@ static int rt2800pci_load_firmware(struct rt2x00_dev *rt2x00dev,
 	 * Write firmware to device.
 	 */
 	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
-				      data, len);
+				   data, len);
 
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00000);
 	rt2800_register_write(rt2x00dev, PBF_SYS_CTRL, 0x00001);
 
-	/*
-	 * Wait for device to stabilize.
-	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "PBF system register not ready.\n");
-		return -EBUSY;
-	}
-
-	/*
-	 * Disable interrupts
-	 */
-	rt2x00dev->ops->lib->set_device_state(rt2x00dev, STATE_RADIO_IRQ_OFF);
-
-	/*
-	 * Initialize BBP R/W access agent
-	 */
 	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
 	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
 
@@ -1029,6 +937,7 @@ static const struct rt2800_ops rt2800pci_rt2800_ops = {
 
 	.regbusy_read		= rt2x00pci_regbusy_read,
 
+	.drv_write_firmware	= rt2800pci_write_firmware,
 	.drv_init_registers	= rt2800pci_init_registers,
 };
 
@@ -1114,8 +1023,8 @@ static const struct rt2x00lib_ops rt2800pci_rt2x00_ops = {
 	.irq_handler_thread	= rt2800pci_interrupt_thread,
 	.probe_hw		= rt2800pci_probe_hw,
 	.get_firmware_name	= rt2800pci_get_firmware_name,
-	.check_firmware		= rt2800pci_check_firmware,
-	.load_firmware		= rt2800pci_load_firmware,
+	.check_firmware		= rt2800_check_firmware,
+	.load_firmware		= rt2800_load_firmware,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
 	.get_entry_state	= rt2800pci_get_entry_state,
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index f8eb6d7..7b8d51f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -28,7 +28,6 @@
 	Supported chipsets: RT2800U.
  */
 
-#include <linux/crc-ccitt.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -57,84 +56,10 @@ static char *rt2800usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return FIRMWARE_RT2870;
 }
 
-static bool rt2800usb_check_crc(const u8 *data, const size_t len)
-{
-	u16 fw_crc;
-	u16 crc;
-
-	/*
-	 * The last 2 bytes in the firmware array are the crc checksum itself,
-	 * this means that we should never pass those 2 bytes to the crc
-	 * algorithm.
-	 */
-	fw_crc = (data[len - 2] << 8 | data[len - 1]);
-
-	/*
-	 * Use the crc ccitt algorithm.
-	 * This will return the same value as the legacy driver which
-	 * used bit ordering reversion on the both the firmware bytes
-	 * before input input as well as on the final output.
-	 * Obviously using crc ccitt directly is much more efficient.
-	 */
-	crc = crc_ccitt(~0, data, len - 2);
-
-	/*
-	 * There is a small difference between the crc-itu-t + bitrev and
-	 * the crc-ccitt crc calculation. In the latter method the 2 bytes
-	 * will be swapped, use swab16 to convert the crc to the correct
-	 * value.
-	 */
-	crc = swab16(crc);
-
-	return fw_crc == crc;
-}
-
-static int rt2800usb_check_firmware(struct rt2x00_dev *rt2x00dev,
+static int rt2800usb_write_firmware(struct rt2x00_dev *rt2x00dev,
 				    const u8 *data, const size_t len)
 {
-	size_t offset = 0;
-
-	/*
-	 * Firmware files:
-	 * There are 2 variations of the rt2870 firmware.
-	 * a) size: 4kb
-	 * b) size: 8kb
-	 * Note that (b) contains 2 separate firmware blobs of 4k
-	 * within the file. The first blob is the same firmware as (a),
-	 * but the second blob is for the additional chipsets.
-	 */
-	if (len != 4096 && len != 8192)
-		return FW_BAD_LENGTH;
-
-	/*
-	 * Check if we need the upper 4kb firmware data or not.
-	 */
-	if ((len == 4096) &&
-	    !rt2x00_rt(rt2x00dev, RT2860) &&
-	    !rt2x00_rt(rt2x00dev, RT2872) &&
-	    !rt2x00_rt(rt2x00dev, RT3070))
-		return FW_BAD_VERSION;
-
-	/*
-	 * 8kb firmware files must be checked as if it were
-	 * 2 separate firmware files.
-	 */
-	while (offset < len) {
-		if (!rt2800usb_check_crc(data + offset, 4096))
-			return FW_BAD_CRC;
-
-		offset += 4096;
-	}
-
-	return FW_OK;
-}
-
-static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
-				   const u8 *data, const size_t len)
-{
-	unsigned int i;
 	int status;
-	u32 reg;
 	u32 offset;
 	u32 length;
 
@@ -152,21 +77,6 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/*
-	 * Wait for stable hardware.
-	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg && reg != ~0)
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "Unstable hardware.\n");
-		return -EBUSY;
-	}
-
-	/*
 	 * Write firmware to device.
 	 */
 	rt2800_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE,
@@ -203,28 +113,6 @@ static int rt2800usb_load_firmware(struct rt2x00_dev *rt2x00dev,
 		udelay(10);
 	}
 
-	/*
-	 * Wait for device to stabilize.
-	 */
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
-		rt2800_register_read(rt2x00dev, PBF_SYS_CTRL, &reg);
-		if (rt2x00_get_field32(reg, PBF_SYS_CTRL_READY))
-			break;
-		msleep(1);
-	}
-
-	if (i == REGISTER_BUSY_COUNT) {
-		ERROR(rt2x00dev, "PBF system register not ready.\n");
-		return -EBUSY;
-	}
-
-	/*
-	 * Initialize firmware.
-	 */
-	rt2800_register_write(rt2x00dev, H2M_BBP_AGENT, 0);
-	rt2800_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	msleep(1);
-
 	return 0;
 }
 
@@ -593,6 +481,7 @@ static const struct rt2800_ops rt2800usb_rt2800_ops = {
 
 	.regbusy_read		= rt2x00usb_regbusy_read,
 
+	.drv_write_firmware	= rt2800usb_write_firmware,
 	.drv_init_registers	= rt2800usb_init_registers,
 };
 
@@ -670,8 +559,8 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.probe_hw		= rt2800usb_probe_hw,
 	.get_firmware_name	= rt2800usb_get_firmware_name,
-	.check_firmware		= rt2800usb_check_firmware,
-	.load_firmware		= rt2800usb_load_firmware,
+	.check_firmware		= rt2800_check_firmware,
+	.load_firmware		= rt2800_load_firmware,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
 	.clear_entry		= rt2x00usb_clear_entry,
-- 
1.7.1.1

