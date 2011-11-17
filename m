Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:55502 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755103Ab1KQElp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 23:41:45 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-bluetooth@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Gustavo Padovan <padovan@profusion.mobi>,
	Bing Zhao <bzhao@marvell.com>, Frank Huang <frankh@marvell.com>
Subject: [PATCH] Bluetooth: btmrvl: support Marvell Bluetooth device SD8797
Date: Wed, 16 Nov 2011 20:40:42 -0800
Message-Id: <1321504842-11199-1-git-send-email-bzhao@marvell.com> (sfid-20111117_054152_670843_7EEEE9CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SD8797 firmware image is shared with mwifiex driver.
Whoever gets loaded first will be responsible for firmware
downloading.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/bluetooth/Kconfig       |    6 +++---
 drivers/bluetooth/btmrvl_sdio.c |   15 +++++++++++++--
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index 11b41fd..5ccf142 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -188,7 +188,7 @@ config BT_MRVL
 	  The core driver to support Marvell Bluetooth devices.
 
 	  This driver is required if you want to support
-	  Marvell Bluetooth devices, such as 8688/8787.
+	  Marvell Bluetooth devices, such as 8688/8787/8797.
 
 	  Say Y here to compile Marvell Bluetooth driver
 	  into the kernel or say M to compile it as module.
@@ -201,8 +201,8 @@ config BT_MRVL_SDIO
 	  The driver for Marvell Bluetooth chipsets with SDIO interface.
 
 	  This driver is required if you want to use Marvell Bluetooth
-	  devices with SDIO interface. Currently SD8688/SD8787 chipsets are
-	  supported.
+	  devices with SDIO interface. Currently SD8688/SD8787/SD8797
+	  chipsets are supported.
 
 	  Say Y here to compile support for Marvell BT-over-SDIO driver
 	  into the kernel or say M to compile it as module.
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index c827d73..37b5639 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -64,7 +64,7 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_8688 = {
 	.io_port_1 = 0x01,
 	.io_port_2 = 0x02,
 };
-static const struct btmrvl_sdio_card_reg btmrvl_reg_8787 = {
+static const struct btmrvl_sdio_card_reg btmrvl_reg_87xx = {
 	.cfg = 0x00,
 	.host_int_mask = 0x02,
 	.host_intstatus = 0x03,
@@ -91,7 +91,14 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8787 = {
 	.helper		= NULL,
 	.firmware	= "mrvl/sd8787_uapsta.bin",
-	.reg		= &btmrvl_reg_8787,
+	.reg		= &btmrvl_reg_87xx,
+	.sd_blksz_fw_dl	= 256,
+};
+
+static const struct btmrvl_sdio_device btmrvl_sdio_sd8797 = {
+	.helper		= NULL,
+	.firmware	= "mrvl/sd8797_uapsta.bin",
+	.reg		= &btmrvl_reg_87xx,
 	.sd_blksz_fw_dl	= 256,
 };
 
@@ -102,6 +109,9 @@ static const struct sdio_device_id btmrvl_sdio_ids[] = {
 	/* Marvell SD8787 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x911A),
 			.driver_data = (unsigned long) &btmrvl_sdio_sd8787 },
+	/* Marvell SD8797 Bluetooth device */
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x912A),
+			.driver_data = (unsigned long) &btmrvl_sdio_sd8797 },
 
 	{ }	/* Terminating entry */
 };
@@ -1075,3 +1085,4 @@ MODULE_LICENSE("GPL v2");
 MODULE_FIRMWARE("sd8688_helper.bin");
 MODULE_FIRMWARE("sd8688.bin");
 MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
+MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
-- 
1.7.4.1

