Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:49045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444AbXB1OHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 09:07:18 -0500
Received: by nf-out-0910.google.com with SMTP id o25so562557nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 06:07:17 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 18/28] rt2x00: Move firmware handling to rt2x00lib
Date: Wed, 28 Feb 2007 15:07:09 +0100
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200702281507.10014.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move firmware handling to rt2x00lib, andmake sure that device
initialization (debugfs etc) waits until the firmware is loaded.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>

---

diff --git a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
index 85e6377..dc63411 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt61pci.c
@@ -1187,158 +1187,6 @@ static int rt61pci_set_state(struct rt2x00_dev *rt2x00dev,
 /*
  * Initialization functions.
  */
-static int rt61pci_init_firmware_wait(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-
-	for (i = 0; i < 150; i++) {
-		if (GET_FLAG(rt2x00dev, FIRMWARE_FAILED))
-			return -EIO;
-		if (GET_FLAG(rt2x00dev, FIRMWARE_LOADED))
-			return 0;
-		msleep(20);
-	}
-
-	ERROR("Firmware loading timed out.\n");
-	return -EIO;
-}
-
-static void rt61pci_init_firmware_cont(const struct firmware *fw,
-	void *context)
-{
-	struct rt2x00_dev *rt2x00dev = context;
-	int i;
-	u32 reg;
-	u16 crc;
-
-	if (!fw || !fw->size || !fw->data) {
-		ERROR("Failed to load Firmware.\n");
-		goto exit;
-	}
-
-	/*
-	 * Wait for stable hardware.
-	 */
-	for (i = 0; i < 100; i++) {
-		rt2x00_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg)
-			break;
-		msleep(1);
-	}
-
-	if (!reg) {
-		ERROR("Unstable hardware.\n");
-		goto exit;
-	}
-
-	/*
-	 * Prepare MCU and mailbox for firmware loading.
-	 */
-	reg = 0;
-	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
-	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
-	rt2x00_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
-	rt2x00_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
-	rt2x00_register_write(rt2x00dev, HOST_CMD_CSR, 0);
-
-	/*
-	 * Validate the firmware using 16 bit CRC.
-	 * The last 2 bytes of the firmware are the CRC
-	 * so substract those 2 bytes from the CRC checksum,
-	 * and set those 2 bytes to 0 when calculating CRC.
-	 */
-	reg = 0;
-	crc = crc_itu_t(0, fw->data, fw->size - 2);
-	crc = crc_itu_t(crc, (u8*)&reg, 2);
-
-	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
-		ERROR("Firmware CRC error.\n");
-		goto exit;
-	}
-
-	rt2x00_set_chip_fw(&rt2x00dev->chip,
-		fw->data[fw->size - 4], fw->data[fw->size - 3]);
-
-	/*
-	 * Write firmware to device.
-	 */
-	reg = 0;
-	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
-	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 1);
-	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
-
-	rt2x00_register_multiwrite(
-		rt2x00dev, FIRMWARE_IMAGE_BASE, (u32*)fw->data, fw->size);
-
-	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 0);
-	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
-
-	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 0);
-	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
-
-	for (i = 0; i < 100; i++) {
-		rt2x00_register_read(rt2x00dev, MCU_CNTL_CSR, &reg);
-		if (rt2x00_get_field32(reg, MCU_CNTL_CSR_READY))
-			break;
-		msleep(1);
-	}
-
-	if (i == 100) {
-		ERROR("MCU Control register not ready.\n");
-		goto exit;
-	}
-
-	/*
-	 * Reset MAC and BBP registers.
-	 */
-	reg = 0;
-	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
-	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
-	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR1, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 0);
-	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 0);
-	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
-
-	rt2x00_register_read(rt2x00dev, MAC_CSR1, &reg);
-	rt2x00_set_field32(&reg, MAC_CSR1_HOST_READY, 1);
-	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
-
-	SET_FLAG(rt2x00dev, FIRMWARE_LOADED);
-
-	return;
-
-exit:
-	SET_FLAG(rt2x00dev, FIRMWARE_FAILED);
-}
-
-static int rt61pci_init_firmware(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-	static const struct {
-		char	*name;
-		u32	chip;
-	} firmware[] = {
-		{ "rt2561.bin",		RT2561 },
-		{ "rt2561s.bin",	RT2561s },
-		{ "rt2661.bin",		RT2661 },
-	};
-
-	/*
-	 * Read correct firmware from harddisk.
-	 */
-	for (i = 0; i < ARRAY_SIZE(firmware); i++) {
-		if (!rt2x00_rt(&rt2x00dev->chip, firmware[i].chip))
-			continue;
-		return request_firmware_nowait(THIS_MODULE, 1,
-			firmware[i].name, &rt2x00dev_pci(rt2x00dev)->dev,
-			rt2x00dev, rt61pci_init_firmware_cont);
-	}
-
-	return -EINVAL;
-}
-
 static int rt61pci_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 	enum ring_index ring_type, work_func_t handler,
 	const u16 max_entries, const u16 data_size, const u16 desc_size)
@@ -1793,7 +1641,7 @@ static int rt61pci_initialize(struct rt2x00_dev *rt2x00dev)
 	 * We must wait on the firmware before
 	 * we can safely continue.
 	 */
-	if (rt61pci_init_firmware_wait(rt2x00dev))
+	if (rt2x00lib_load_firmware_wait(rt2x00dev))
 		return -ENODEV;
 
 	/*
@@ -3581,6 +3429,126 @@ static int rt61pci_init_hw(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static void rt61pci_load_firmware(const struct firmware *fw, void *context)
+{
+	struct rt2x00_dev *rt2x00dev = context;
+	int i;
+	u32 reg;
+	u16 crc;
+
+	if (!fw || !fw->size || !fw->data) {
+		ERROR("Failed to load Firmware.\n");
+		goto exit;
+	}
+
+	/*
+	 * Wait for stable hardware.
+	 */
+	for (i = 0; i < 100; i++) {
+		rt2x00_register_read(rt2x00dev, MAC_CSR0, &reg);
+		if (reg)
+			break;
+		msleep(1);
+	}
+
+	if (!reg) {
+		ERROR("Unstable hardware.\n");
+		goto exit;
+	}
+
+	/*
+	 * Prepare MCU and mailbox for firmware loading.
+	 */
+	reg = 0;
+	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
+	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+	rt2x00_register_write(rt2x00dev, M2H_CMD_DONE_CSR, 0xffffffff);
+	rt2x00_register_write(rt2x00dev, H2M_MAILBOX_CSR, 0);
+	rt2x00_register_write(rt2x00dev, HOST_CMD_CSR, 0);
+
+	/*
+	 * Validate the firmware using 16 bit CRC.
+	 * The last 2 bytes of the firmware are the CRC
+	 * so substract those 2 bytes from the CRC checksum,
+	 * and set those 2 bytes to 0 when calculating CRC.
+	 */
+	reg = 0;
+	crc = crc_itu_t(0, fw->data, fw->size - 2);
+	crc = crc_itu_t(crc, (u8*)&reg, 2);
+
+	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
+		ERROR("Firmware CRC error.\n");
+		goto exit;
+	}
+
+	rt2x00_set_chip_fw(&rt2x00dev->chip,
+		fw->data[fw->size - 4], fw->data[fw->size - 3]);
+
+	/*
+	 * Write firmware to device.
+	 */
+	reg = 0;
+	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 1);
+	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 1);
+	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+
+	rt2x00_register_multiwrite(
+		rt2x00dev, FIRMWARE_IMAGE_BASE, (u32*)fw->data, fw->size);
+
+	rt2x00_set_field32(&reg, MCU_CNTL_CSR_SELECT_BANK, 0);
+	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+
+	rt2x00_set_field32(&reg, MCU_CNTL_CSR_RESET, 0);
+	rt2x00_register_write(rt2x00dev, MCU_CNTL_CSR, reg);
+
+	for (i = 0; i < 100; i++) {
+		rt2x00_register_read(rt2x00dev, MCU_CNTL_CSR, &reg);
+		if (rt2x00_get_field32(reg, MCU_CNTL_CSR_READY))
+			break;
+		msleep(1);
+	}
+
+	if (i == 100) {
+		ERROR("MCU Control register not ready.\n");
+		goto exit;
+	}
+
+	/*
+	 * Reset MAC and BBP registers.
+	 */
+	reg = 0;
+	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 1);
+	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 1);
+	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR1_SOFT_RESET, 0);
+	rt2x00_set_field32(&reg, MAC_CSR1_BBP_RESET, 0);
+	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
+
+	rt2x00_register_read(rt2x00dev, MAC_CSR1, &reg);
+	rt2x00_set_field32(&reg, MAC_CSR1_HOST_READY, 1);
+	rt2x00_register_write(rt2x00dev, MAC_CSR1, reg);
+
+	SET_FLAG(rt2x00dev, FIRMWARE_LOADED);
+
+	/*
+	 * Initialize the remaining bits of the device
+	 * that had to wait until the firmware was loaded.
+	 */
+	if (rt61pci_init_hw(rt2x00dev)) {
+		ERROR("Failed to initialize device.\n");
+		return;
+	}
+
+	rt61pci_open_debugfs(rt2x00dev);
+
+	return;
+
+exit:
+	SET_FLAG(rt2x00dev, FIRMWARE_FAILED);
+}
+
 static void rt61pci_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
@@ -3684,21 +3652,19 @@ static int rt61pci_alloc_dev(struct pci_dev *pci_dev,
 	/*
 	 * Initialize hardware.
 	 */
-	if (rt61pci_init_eeprom(rt2x00dev) ||
-	    rt61pci_init_hw(rt2x00dev)) {
+	if (rt61pci_init_eeprom(rt2x00dev)) {
 		ERROR("Failed to initialize device.\n");
 		goto exit;
 	}
 
-	if (rt61pci_init_firmware(rt2x00dev)) {
-		ERROR("Failed to load Firmware.\n");
-		goto exit;
-	}
-
 	/*
-	 * Open the debugfs entry.
+	 * Request firmware and wait with further
+	 * initializing of the card until the firmware
+	 * has been loaded.
 	 */
-	rt61pci_open_debugfs(rt2x00dev);
+	if (rt2x00lib_load_firmware(rt2x00dev, &rt2x00dev_pci(rt2x00dev)->dev,
+		rt61pci_load_firmware))
+		goto exit;
 
 	return 0;
 
diff --git a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
index 467ab4c..a4aa876 100644
--- a/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/mac80211/rt2x00/rt73usb.c
@@ -1080,108 +1080,6 @@ static int rt73usb_set_state(struct rt2x00_dev *rt2x00dev,
 /*
  * Initialization functions.
  */
-static int rt73usb_init_firmware_wait(struct rt2x00_dev *rt2x00dev)
-{
-	unsigned int i;
-
-	for (i = 0; i < 150; i++) {
-		if (GET_FLAG(rt2x00dev, FIRMWARE_FAILED))
-			return -EIO;
-		if (GET_FLAG(rt2x00dev, FIRMWARE_LOADED))
-			return 0;
-		msleep(20);
-	}
-
-	ERROR("Firmware loading timed out.\n");
-	return -EIO;
-}
-
-static void rt73usb_init_firmware_cont(const struct firmware *fw,
-	void *context)
-{
-	struct rt2x00_dev *rt2x00dev = context;
-	unsigned int i;
-	int status;
-	u32 reg;
-	u16 crc;
-
-	if (!fw || !fw->size || !fw->data) {
-		ERROR("Failed to load Firmware.\n");
-		goto exit;
-	}
-
-	/*
-	 * Wait for stable hardware.
-	 */
-	for (i = 0; i < 100; i++) {
-		rt2x00_register_read(rt2x00dev, MAC_CSR0, &reg);
-		if (reg)
-			break;
-		msleep(1);
-	}
-
-	if (!reg) {
-		ERROR("Unstable hardware.\n");
-		goto exit;
-	}
-
-	/*
-	 * Validate the firmware using 16 bit CRC.
-	 * The last 2 bytes of the firmware are the CRC
-	 * so substract those 2 bytes from the CRC checksum,
-	 * and set those 2 bytes to 0 when calculating CRC.
-	 */
-	reg = 0;
-	crc = crc_itu_t(0, fw->data, fw->size - 2);
-	crc = crc_itu_t(crc, (u8*)&reg, 2);
-
-	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
-		ERROR("Firmware CRC error.\n");
-		goto exit;
-	}
-
-	rt2x00_set_chip_fw(&rt2x00dev->chip,
-		fw->data[fw->size - 4], fw->data[fw->size - 3]);
-
-	/*
-	 * Write firmware to device.
-	 */
-	for (i = 0; i < fw->size; i += sizeof(u32))
-		rt2x00_register_write(rt2x00dev, FIRMWARE_IMAGE_BASE + i,
-			*((u32*)(fw->data + i)));
-
-	/*
-	 * Send firmware request to device to load firmware,
-	 * we need to specify a long timeout time.
-	 */
-	status = rt2x00_vendor_request(rt2x00dev, USB_DEVICE_MODE,
-		USB_VENDOR_REQUEST_OUT, 0x00, USB_MODE_FIRMWARE,
-		NULL, 0, REGISTER_TIMEOUT_FIRMWARE);
-	if (status  < 0) {
-		ERROR("Failed to load Firmware error %d.\n", status);
-		goto exit;
-	}
-
-	rt73usb_disable_led(rt2x00dev);
-
-	SET_FLAG(rt2x00dev, FIRMWARE_LOADED);
-
-	return;
-
-exit:
-	SET_FLAG(rt2x00dev, FIRMWARE_FAILED);
-}
-
-static int rt73usb_init_firmware(struct rt2x00_dev *rt2x00dev)
-{
-	/*
-	 * Read correct firmware from harddisk.
-	 */
-	return request_firmware_nowait(THIS_MODULE, 1,
-		"rt73.bin", &rt2x00dev_usb(rt2x00dev)->dev, rt2x00dev,
-		rt73usb_init_firmware_cont);
-}
-
 static int rt73usb_alloc_dma_ring(struct rt2x00_dev *rt2x00dev,
 	enum ring_index ring_type, const u16 max_entries,
 	const u16 data_size, const u16 desc_size)
@@ -1524,7 +1422,7 @@ static int rt73usb_initialize(struct rt2x00_dev *rt2x00dev)
 	 * We must wait on the firmware before
 	 * we can safely continue.
 	 */
-	if (rt73usb_init_firmware_wait(rt2x00dev))
+	if (rt2x00lib_load_firmware_wait(rt2x00dev))
 		return -ENODEV;
 
 	/*
@@ -3239,6 +3137,93 @@ static int rt73usb_init_hw(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static void rt73usb_load_firmware(const struct firmware *fw, void *context)
+{
+	struct rt2x00_dev *rt2x00dev = context;
+	unsigned int i;
+	int status;
+	u32 reg;
+	u16 crc;
+
+	if (!fw || !fw->size || !fw->data) {
+		ERROR("Failed to load Firmware.\n");
+		goto exit;
+	}
+
+	/*
+	 * Wait for stable hardware.
+	 */
+	for (i = 0; i < 100; i++) {
+		rt2x00_register_read(rt2x00dev, MAC_CSR0, &reg);
+		if (reg)
+			break;
+		msleep(1);
+	}
+
+	if (!reg) {
+		ERROR("Unstable hardware.\n");
+		goto exit;
+	}
+
+	/*
+	 * Validate the firmware using 16 bit CRC.
+	 * The last 2 bytes of the firmware are the CRC
+	 * so substract those 2 bytes from the CRC checksum,
+	 * and set those 2 bytes to 0 when calculating CRC.
+	 */
+	reg = 0;
+	crc = crc_itu_t(0, fw->data, fw->size - 2);
+	crc = crc_itu_t(crc, (u8*)&reg, 2);
+
+	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
+		ERROR("Firmware CRC error.\n");
+		goto exit;
+	}
+
+	rt2x00_set_chip_fw(&rt2x00dev->chip,
+		fw->data[fw->size - 4], fw->data[fw->size - 3]);
+
+	/*
+	 * Write firmware to device.
+	 */
+	for (i = 0; i < fw->size; i += sizeof(u32)) {
+		reg = *((u32*)&fw->data[i]);
+		rt2x00_register_multiwrite(rt2x00dev, FIRMWARE_IMAGE_BASE + i,
+			&reg, sizeof(u32));
+	}
+
+	/*
+	 * Send firmware request to device to load firmware,
+	 * we need to specify a long timeout time.
+	 */
+	status = rt2x00_vendor_request(rt2x00dev, USB_DEVICE_MODE,
+		USB_VENDOR_REQUEST_OUT, 0x00, USB_MODE_FIRMWARE,
+		NULL, 0, REGISTER_TIMEOUT_FIRMWARE);
+	if (status  < 0) {
+		ERROR("Failed to write Firmware to device.\n");
+		goto exit;
+	}
+
+	SET_FLAG(rt2x00dev, FIRMWARE_LOADED);
+
+	/*
+	 * Initialize the remaining bits of the device
+	 * that had to wait until the firmware was loaded.
+	 */
+	if (rt73usb_init_hw(rt2x00dev)) {
+		ERROR("Failed to initialize device.\n");
+		return;
+	}
+
+	rt73usb_disable_led(rt2x00dev);
+	rt73usb_open_debugfs(rt2x00dev);
+
+	return;
+
+exit:
+	SET_FLAG(rt2x00dev, FIRMWARE_FAILED);
+}
+
 static void rt73usb_free_dev(struct rt2x00_dev *rt2x00dev)
 {
 	/*
@@ -3323,21 +3308,19 @@ static int rt73usb_alloc_dev(struct usb_interface *usb_intf,
 	/*
 	 * Initialize hardware.
 	 */
-	if (rt73usb_init_eeprom(rt2x00dev) ||
-	    rt73usb_init_hw(rt2x00dev)) {
+	if (rt73usb_init_eeprom(rt2x00dev)) {
 		ERROR("Failed to initialize device.\n");
 		goto exit;
 	}
 
-	if (rt73usb_init_firmware(rt2x00dev)) {
-		ERROR("Failed to load Firmware.\n");
-		goto exit;
-	}
-
 	/*
-	 * Open the debugfs entry.
+	 * Request firmware and wait with further
+	 * initializing of the card until the firmware
+	 * has been loaded.
 	 */
-	rt73usb_open_debugfs(rt2x00dev);
+	if (rt2x00lib_load_firmware(rt2x00dev, &rt2x00dev_usb(rt2x00dev)->dev,
+		rt73usb_load_firmware))
+		goto exit;
 
 	return 0;
 
