Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:21894 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763558AbYBCOvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Feb 2008 09:51:51 -0500
Received: by py-out-1112.google.com with SMTP id u52so2706102pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 03 Feb 2008 06:51:50 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 07/19] rt2x00: Driver requiring firmware should select crc algo
Date: Sun, 3 Feb 2008 15:48:38 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802031541.52167.IvDoorn@gmail.com>
In-Reply-To: <200802031541.52167.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802031548.39121.IvDoorn@gmail.com> (sfid-20080203_145154_567241_097D6BD7)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver should select what CRC algorithm is required
when performing a checksum on the firmware.

rt61pci & rt73usb require crc-itu-t
rt2800pci & rt2800usb require crc-ccitt

Legacy 2800pci/usb driver uses crc-itu-t + bit order reversion,
but that is just inefficient especially since the end result is
the same as a different algorithm which is also available as library. ;)

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/Kconfig          |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h         |    2 +
 drivers/net/wireless/rt2x00/rt2x00dev.c      |    8 ++---
 drivers/net/wireless/rt2x00/rt2x00firmware.c |   41 ++++++++++++++++++++------
 drivers/net/wireless/rt2x00/rt61pci.c        |    3 +-
 drivers/net/wireless/rt2x00/rt73usb.c        |    3 +-
 6 files changed, 42 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
index da05b1f..28f3e5e 100644
--- a/drivers/net/wireless/rt2x00/Kconfig
+++ b/drivers/net/wireless/rt2x00/Kconfig
@@ -28,6 +28,7 @@ config RT2X00_LIB_USB
 config RT2X00_LIB_FIRMWARE
 	boolean
 	depends on RT2X00_LIB
+	select CRC_CCITT
 	select CRC_ITU_T
 	select FW_LOADER
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index 14668f0..d5b9a3c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -555,6 +555,8 @@ enum rt2x00_flags {
 	 * Driver features
 	 */
 	DRIVER_REQUIRE_FIRMWARE,
+	DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T,
+	DRIVER_REQUIRE_FIRMWARE_CCITT,
 	DRIVER_REQUIRE_BEACON_GUARD,
 	DRIVER_REQUIRE_ATIM_QUEUE,
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9c4ebb0..7089808 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -983,11 +983,9 @@ int rt2x00lib_start(struct rt2x00_dev *rt2x00dev)
 	 * If this is the first interface which is added,
 	 * we should load the firmware now.
 	 */
-	if (test_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags)) {
-		retval = rt2x00lib_load_firmware(rt2x00dev);
-		if (retval)
-			return retval;
-	}
+	retval = rt2x00lib_load_firmware(rt2x00dev);
+	if (retval)
+		return retval;
 
 	/*
 	 * Initialize the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00firmware.c b/drivers/net/wireless/rt2x00/rt2x00firmware.c
index 442ff80..4f9fe56 100644
--- a/drivers/net/wireless/rt2x00/rt2x00firmware.c
+++ b/drivers/net/wireless/rt2x00/rt2x00firmware.c
@@ -23,6 +23,7 @@
 	Abstract: rt2x00 firmware loading routines.
  */
 
+#include <linux/crc-ccitt.h>
 #include <linux/crc-itu-t.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
@@ -37,7 +38,6 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 	char *fw_name;
 	int retval;
 	u16 crc;
-	u16 tmp;
 
 	/*
 	 * Read correct firmware from harddisk.
@@ -64,17 +64,37 @@ static int rt2x00lib_request_firmware(struct rt2x00_dev *rt2x00dev)
 	}
 
 	/*
-	 * Validate the firmware using 16 bit CRC.
-	 * The last 2 bytes of the firmware are the CRC
-	 * so substract those 2 bytes from the CRC checksum,
-	 * and set those 2 bytes to 0 when calculating CRC.
+	 * Perform crc validation on the firmware.
+	 * The last 2 bytes in the firmware array are the crc checksum itself,
+	 * this means that we should never pass those 2 bytes to the crc
+	 * algorithm.
 	 */
-	tmp = 0;
-	crc = crc_itu_t(0, fw->data, fw->size - 2);
-	crc = crc_itu_t(crc, (u8 *)&tmp, 2);
+	if (test_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags)) {
+		/*
+		 * Use the crc itu-t algorithm.
+		 * Use 0 for the last 2 bytes to complete the checksum.
+		 */
+		crc = crc_itu_t(0, fw->data, fw->size - 2);
+		crc = crc_itu_t_byte(crc, 0);
+		crc = crc_itu_t_byte(crc, 0);
+	} else if (test_bit(DRIVER_REQUIRE_FIRMWARE_CCITT, &rt2x00dev->flags)) {
+		/*
+		 * Use the crc ccitt algorithm.
+		 * This will return the same value as the legacy driver which
+		 * used bit ordering reversion on the both the firmware bytes
+		 * before input input as well as on the final output.
+		 * Obviously using crc ccitt directly is much more efficient.
+		 */
+		crc = crc_ccitt(~0, fw->data, fw->size - 2);
+	} else {
+		ERROR(rt2x00dev, "No checksum algorithm selected "
+		      "for firmware validation.\n");
+		retval = -ENOENT;
+		goto exit;
+	}
 
 	if (crc != (fw->data[fw->size - 2] << 8 | fw->data[fw->size - 1])) {
-		ERROR(rt2x00dev, "Firmware CRC error.\n");
+		ERROR(rt2x00dev, "Firmware checksum error.\n");
 		retval = -ENOENT;
 		goto exit;
 	}
@@ -96,6 +116,9 @@ int rt2x00lib_load_firmware(struct rt2x00_dev *rt2x00dev)
 {
 	int retval;
 
+	if (!test_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags))
+		return 0;
+
 	if (!rt2x00dev->fw) {
 		retval = rt2x00lib_request_firmware(rt2x00dev);
 		if (retval)
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index fc5acdf..6c97361 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2255,9 +2255,10 @@ static int rt61pci_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt61pci_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device requires firmware
+	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 2231557..01c020b 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1846,9 +1846,10 @@ static int rt73usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	rt73usb_probe_hw_mode(rt2x00dev);
 
 	/*
-	 * This device requires firmware
+	 * This device requires firmware.
 	 */
 	__set_bit(DRIVER_REQUIRE_FIRMWARE, &rt2x00dev->flags);
+	__set_bit(DRIVER_REQUIRE_FIRMWARE_CRC_ITU_T, &rt2x00dev->flags);
 
 	/*
 	 * Set the rssi offset.
-- 
1.5.3.8

