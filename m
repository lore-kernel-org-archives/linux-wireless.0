Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:53844 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbYCIVvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2008 17:51:09 -0400
Received: by fg-out-1718.google.com with SMTP id e21so1676623fga.17
        for <linux-wireless@vger.kernel.org>; Sun, 09 Mar 2008 14:51:08 -0700 (PDT)
To: "John W. Linville" <linville@redhat.com>
Subject: [PATCH 13/24] rt2x00: Move firmware checksumming to driver
Date: Sun, 9 Mar 2008 22:44:54 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200803092237.43451.IvDoorn@gmail.com>
In-Reply-To: <200803092237.43451.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803092244.54579.IvDoorn@gmail.com> (sfid-20080309_215454_386428_4D596429)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00lib depended on 2 crc algorithms because rt61/rt73
use a different algorithm then rt2800. This means that
even when only 1 algorithm was needed, the dependency was
still present for both.
By moving the checksum generation to the driver we can clean
up 2 annoying flags (which indicated which checksum was required)
and move the dependency to where it belongs: the driver.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig          |    4 +-
 drivers/net/wireless/rt2x00/rt2x00.h         |    3 +-
 drivers/net/wireless/rt2x00/rt2x00firmware.c |   34 +-------------------------
 drivers/net/wireless/rt2x00/rt61pci.c        |   28 +++++++++++++++++----
 drivers/net/wireless/rt2x00/rt73usb.c        |   28 +++++++++++++++++----
 5 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index d5240aa..4709c11 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -27,8 +27,6 @@ config RT2X00_LIB_USB
 config RT2X00_LIB_FIRMWARE
 	boolean
 	depends on RT2X00_LIB
-	select CRC_CCITT
-	select CRC_ITU_T
 	select FW_LOADER
 
 config RT2X00_LIB_RFKILL
@@ -102,6 +100,7 @@ config RT61PCI
 	depends on PCI
 	select RT2X00_LIB_PCI
 	select RT2X00_LIB_FIRMWARE
+	select CRC_ITU_T
 	select EEPROM_93CX6
 	---help---
 	  This is an experimental driver for the Ralink rt61 wireless chip.
@@ -145,6 +144,7 @@ config RT73USB
 	depends on USB
 	select RT2X00_LIB_USB
 	select RT2X00_LIB_FIRMWARE
+	select CRC_ITU_T
 	---help---
 	  This is an experimental driver for the Ralink rt73 wireless chip.
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index fd65fcc..8718ad3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -495,6 +495,7 @@ struct rt2x00lib_ops {
 	 */
 	int (*probe_hw) (struct rt2x00_dev *rt2x00dev);
 	char *(*get_firmware_name) (struct rt2x00_dev *rt2x00dev);
+	u16 (*get_firmware_crc) (void *data, const size_t len);
 	int (*load_firmware) (struct rt2x00_dev *rt2x00dev, void *data,
 			      const size_t len);
 
@@ -613,8 +614,6 @@ enum rt2x00_flags {
 	 */
 	DRIVER_SUPPORT_MIXED_INTERFACES,
 	DRIVER_REQUIRE_FIRMWARE,
-	DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T,
-	DRIVER_REQUIRE_FIRMWARE_CCITT,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 4f9fe56..b971bc6 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -23,8 +23,6 @@
 	Abstract: rt2x00 firmware loading routines.
  */
 
-#include <linux/crc-ccitt.h>
-#include <linux/crc-itu-t.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
@@ -63,36 +61,7 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 		return -ENOENT;
 	}
 
-	/*
-	 * Perform crc validation on the firmware.
-	 * The last 2 bytes in the firmware array are the crc checksum itself,
-	 * this means that we should never pass those 2 bytes to the crc
-	 * algorithm.
-	 */
-	if (test_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags)) {
-		/*
-		 * Use the crc itu-t algorithm.
-		 * Use 0 for the last 2 bytes to complete the checksum.
-		 */
-		crc = crc_itu_t(0, fw->data, fw->size - 2);
-		crc = crc_itu_t_byte(crc, 0);
-		crc = crc_itu_t_byte(crc, 0);
-	} else if (test_bit(DRIVER_REQUIRE_FIRMWARE_CCITT, &rt2x00dev->flags)) {
-		/*
-		 * Use the crc ccitt algorithm.
-		 * This will return the same value as the legacy driver which
-		 * used bit ordering reversion on the both the firmware bytes
-		 * before input input as well as on the final output.
-		 * Obviously using crc ccitt directly is much more efficient.
-		 */
-		crc = crc_ccitt(~0, fw->data, fw->size - 2);
-	} else {
-		ERROR(rt2x00dev, "No checksum algorithm selected "
-		      "for firmware validation.\n");
-		retval = -ENOENT;
-		goto exit;
-	}
-
+	crc = rt2x00dev->ops->lib->get_firmware_crc(fw->data, fw->size);
 	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
 		ERROR(rt2x00dev, "Firmware checksum error.\n");
 		retval = -ENOENT;
@@ -139,4 +108,3 @@ void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
 	release_firmware(rt2x00dev->fw);
 	rt2x00dev->fw = NULL;
 }
-
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 9d8d096..9f5838b 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -24,6 +24,7 @@
 	Supported chipsets: RT2561, RT2561s, RT2661.
  */
 
+#include <linux/crc-itu-t.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -856,7 +857,7 @@ dynamic_cca_tune:
 }
 
 /*
- * Firmware name function.
+ * Firmware functions
  */
 static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 {
@@ -880,9 +881,23 @@ static char *rt61pci_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 	return fw_name;
 }
 
-/*
- * Initialization functions.
- */
+static u16 rt61pci_get_firmware_crc(void *data, const size_t len)
+{
+	u16 crc;
+
+	/*
+	 * Use the crc itu-t algorithm.
+	 * The last 2 bytes in the firmware array are the crc checksum itself,
+	 * this means that we should never pass those 2 bytes to the crc
+	 * algorithm.
+	 */
+	crc = crc_itu_t(0, data, len - 2);
+	crc = crc_itu_t_byte(crc, 0);
+	crc = crc_itu_t_byte(crc, 0);
+
+	return crc;
+}
+
 static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 				 const size_t len)
 {
@@ -963,6 +978,9 @@ static int rt61pci_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	return 0;
 }
 
+/*
+ * Initialization functions.
+ */
 static void rt61pci_init_rxentry(struct rt2x00_dev *rt2x00dev,
 				 struct queue_entry *entry)
 {
@@ -2257,7 +2275,6 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -2457,6 +2474,7 @@ static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
 	.irq_handler		= rt61pci_interrupt,
 	.probe_hw		= rt61pci_probe_hw,
 	.get_firmware_name	= rt61pci_get_firmware_name,
+	.get_firmware_crc	= rt61pci_get_firmware_crc,
 	.load_firmware		= rt61pci_load_firmware,
 	.initialize		= rt2x00pci_initialize,
 	.uninitialize		= rt2x00pci_uninitialize,
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 5e9a0c0..3a2499a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -24,6 +24,7 @@
 	Supported chipsets: rt2571W & rt2671.
  */
 
+#include <linux/crc-itu-t.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
@@ -817,16 +818,30 @@ dynamic_cca_tune:
 }
 
 /*
- * Firmware name function.
+ * Firmware functions
  */
 static char *rt73usb_get_firmware_name(struct rt2x00_dev *rt2x00dev)
 {
 	return FIRMWARE_RT2571;
 }
 
-/*
- * Initialization functions.
- */
+static u16 rt73usb_get_firmware_crc(void *data, const size_t len)
+{
+	u16 crc;
+
+	/*
+	 * Use the crc itu-t algorithm.
+	 * The last 2 bytes in the firmware array are the crc checksum itself,
+	 * this means that we should never pass those 2 bytes to the crc
+	 * algorithm.
+	 */
+	crc = crc_itu_t(0, data, len - 2);
+	crc = crc_itu_t_byte(crc, 0);
+	crc = crc_itu_t_byte(crc, 0);
+
+	return crc;
+}
+
 static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 				 const size_t len)
 {
@@ -896,6 +911,9 @@ static int rt73usb_load_firmware(struct rt2x00_dev *rt2x00dev, void *data,
 	return 0;
 }
 
+/*
+ * Initialization functions.
+ */
 static int rt73usb_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -1852,7 +1870,6 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
-	__set_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
@@ -2061,6 +2078,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
 	.probe_hw		= rt73usb_probe_hw,
 	.get_firmware_name	= rt73usb_get_firmware_name,
+	.get_firmware_crc	= rt73usb_get_firmware_crc,
 	.load_firmware		= rt73usb_load_firmware,
 	.initialize		= rt2x00usb_initialize,
 	.uninitialize		= rt2x00usb_uninitialize,
-- 
1.5.4.3

