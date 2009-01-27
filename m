Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:63423 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbZA0XeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 18:34:09 -0500
Received: by ewy14 with SMTP id 14so2476781ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 15:34:07 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/3] rt2x00: Validate firmware in driver
Date: Wed, 28 Jan 2009 00:33:47 +0100
Cc: rt2400-devel@lists.sourceforge.net,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200901280032.13646.IvDoorn@gmail.com> <200901280032.33474.IvDoorn@gmail.com>
In-Reply-To: <200901280032.33474.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200901280033.47687.IvDoorn@gmail.com> (sfid-20090128_003415_833126_C916596C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The get_firmware_crc() callback function isn't flexible
enough when dealing with multiple firmware versions.
It might in some cases be possible that the firmware
file contains multiple CRC checksums.

Create the check_firmware() callback function where the driver
has complete freedom in how to validate the firmware.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00.h         |    7 +++--
 drivers/net/wireless/rt2x00/rt2x00firmware.c |   27 ++++++++++++++++--------
 drivers/net/wireless/rt2x00/rt2x00reg.h      |   10 +++++++++
 drivers/net/wireless/rt2x00/rt61pci.c        |   29 ++++++++++++++++---------
 drivers/net/wireless/rt2x00/rt73usb.c        |   29 ++++++++++++++++---------
 5 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 94fb571..84bd6f1 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -468,9 +468,10 @@ struct rt2x00lib_ops {
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
 	char *(*get_firmware_name) (struct rt2x00_dev *rt2x00dev);
-	u16 (*get_firmware_crc) (const void *data, const size_t len);
-	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, const void *data,
-			      const size_t len);
+	int (*check_firmware) (struct rt2x00_dev *rt2x00dev,
+			       const u8 *data, const size_t len);
+	int (*load_firmware) (struct rt2x00_dev *rt2x00dev,
+			      const u8 *data, const size_t len);
 
 	/*
 	 * Device initialization/deinitialization handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 2a7e8bc..d2deea2 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -35,7 +35,6 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 	const struct firmware *fw;
 	char *fw_name;
 	int retval;
-	u16 crc;
 
 	/*
 	 * Read correct firmware from harddisk.
@@ -61,16 +60,26 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 		return -ENOENT;
 	}
 
-	crc = rt2x00dev->ops->lib->get_firmware_crc(fw->data, fw->size);
-	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
-		ERROR(rt2x00dev, "Firmware checksum error.\n");
-		retval = -ENOENT;
-		goto exit;
-	}
-
 	INFO(rt2x00dev, "Firmware detected - version: %d.%d.\n",
 	     fw->data[fw->size - 4], fw->data[fw->size - 3]);
 
+	retval = rt2x00dev->ops->lib->check_firmware(rt2x00dev, fw->data, fw->size);
+	switch (retval) {
+	case FW_OK:
+		break;
+	case FW_BAD_CRC:
+		ERROR(rt2x00dev, "Firmware checksum error.\n");
+		goto exit;
+	case FW_BAD_LENGTH:
+		ERROR(rt2x00dev,
+		      "Invalid firmware file length (len=%zu)\n", fw->size);
+		goto exit;
+	case FW_BAD_VERSION:
+		ERROR(rt2x00dev,
+		      "Current firmware does not support detected chipset.\n");
+		goto exit;
+	};
+
 	rt2x00dev->fw = fw;
 
 	return 0;
@@ -78,7 +87,7 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 exit:
 	release_firmware(fw);
 
-	return retval;
+	return -ENOENT;
 }
 
 int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
diff --git a/drivers/net/wireless/rt2x00/rt2x00reg.h b/drivers/net/wireless/rt2x00/rt2x00reg.h
index 9ddc2d0..861322d 100644
--- a/drivers/net/wireless/rt2x00/rt2x00reg.h
+++ b/drivers/net/wireless/rt2x00/rt2x00reg.h
@@ -135,6 +135,16 @@ enum rate_modulation {
 };
 
 /*
+ * Firmware validation error codes
+ */
+enum firmware_errors {
+	FW_OK,
+	FW_BAD_CRC,
+	FW_BAD_LENGTH,
+	FW_BAD_VERSION,
+};
+
+/*
  * Register handlers.
  * We store the position of a register field inside a field structure,
  * This will simplify the process of setting and reading a certain field
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c7ad1b3..0be147f 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -1176,34 +1176,41 @@ static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return fw_name;
 }
 
-static u16 rt61pci_get_firmware_crc(const void *data, const size_t len)
+static int rt61pci_check_firmware(struct rt2x00_dev *rt2x00dev,
+				  const u8 *data, const size_t len)
 {
+	u16 fw_crc;
 	u16 crc;
 
 	/*
-	 * Use the crc itu-t algorithm.
+	 * Only support 8kb firmware files.
+	 */
+	if (len != 8192)
+		return FW_BAD_LENGTH;
+
+	/*
 	 * The last 2 bytes in the firmware array are the crc checksum itself,
 	 * this means that we should never pass those 2 bytes to the crc
 	 * algorithm.
 	 */
+	fw_crc = (data[len - 2] << 8 | data[len - 1]);
+
+	/*
+	 * Use the crc itu-t algorithm.
+	 */
 	crc = crc_itu_t(0, data, len - 2);
 	crc = crc_itu_t_byte(crc, 0);
 	crc = crc_itu_t_byte(crc, 0);
 
-	return crc;
+	return (fw_crc == crc) ? FW_OK : FW_BAD_CRC;
 }
 
-static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
-				 const size_t len)
+static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev,
+				 const u8 *data, const size_t len)
 {
 	int i;
 	u32 reg;
 
-	if (len != 8192) {
-		ERROR(rt2x00dev, "Invalid firmware file length (len=%zu)\n", len);
-		return -ENOENT;
-	}
-
 	/*
 	 * Wait for stable hardware.
 	 */
@@ -2750,7 +2757,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.irq_handler		= rt61pci_interrupt,
 	.probe_hw		= rt61pci_probe_hw,
 	.get_firmware_name	= rt61pci_get_firmware_name,
-	.get_firmware_crc	= rt61pci_get_firmware_crc,
+	.check_firmware		= rt61pci_check_firmware,
 	.load_firmware		= rt61pci_load_firmware,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 24e97b3..be791a4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1061,35 +1061,42 @@ static char *rt73usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return FIRMWARE_RT2571;
 }
 
-static u16 rt73usb_get_firmware_crc(const void *data, const size_t len)
+static int rt73usb_check_firmware(struct rt2x00_dev *rt2x00dev,
+				  const u8 *data, const size_t len)
 {
+	u16 fw_crc;
 	u16 crc;
 
 	/*
-	 * Use the crc itu-t algorithm.
+	 * Only support 2kb firmware files.
+	 */
+	if (len != 2048)
+		return FW_BAD_LENGTH;
+
+	/*
 	 * The last 2 bytes in the firmware array are the crc checksum itself,
 	 * this means that we should never pass those 2 bytes to the crc
 	 * algorithm.
 	 */
+	fw_crc = (data[len - 2] << 8 | data[len - 1]);
+
+	/*
+	 * Use the crc itu-t algorithm.
+	 */
 	crc = crc_itu_t(0, data, len - 2);
 	crc = crc_itu_t_byte(crc, 0);
 	crc = crc_itu_t_byte(crc, 0);
 
-	return crc;
+	return (fw_crc == crc) ? FW_OK : FW_BAD_CRC;
 }
 
-static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, const void *data,
-				 const size_t len)
+static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev,
+				 const u8 *data, const size_t len)
 {
 	unsigned int i;
 	int status;
 	u32 reg;
 
-	if (len != 2048) {
-		ERROR(rt2x00dev, "Invalid firmware file length (len=%zu)\n", len);
-		return -ENOENT;
-	}
-
 	/*
 	 * Wait for stable hardware.
 	 */
@@ -2278,7 +2285,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.probe_hw		= rt73usb_probe_hw,
 	.get_firmware_name	= rt73usb_get_firmware_name,
-	.get_firmware_crc	= rt73usb_get_firmware_crc,
+	.check_firmware		= rt73usb_check_firmware,
 	.load_firmware		= rt73usb_load_firmware,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
-- 
1.5.6.1

