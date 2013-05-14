Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42067 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab3ENBS3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 21:18:29 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-bluetooth@vger.kernel.org>
CC: <linux-wireless@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] Bluetooth: btmrvl: support Marvell Bluetooth device SD8897
Date: Mon, 13 May 2013 18:15:32 -0700
Message-ID: <1368494132-23701-1-git-send-email-bzhao@marvell.com> (sfid-20130514_031833_783870_7D045B73)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The register offsets have been changed in SD8897 and newer chips.
Define a new btmrvl_sdio_card_reg map for SD88xx.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/bluetooth/Kconfig       |  4 ++--
 drivers/bluetooth/btmrvl_sdio.c | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/Kconfig b/drivers/bluetooth/Kconfig
index fdfd61a..11a6104 100644
--- a/drivers/bluetooth/Kconfig
+++ b/drivers/bluetooth/Kconfig
@@ -201,7 +201,7 @@ config BT_MRVL
 	  The core driver to support Marvell Bluetooth devices.
 
 	  This driver is required if you want to support
-	  Marvell Bluetooth devices, such as 8688/8787/8797.
+	  Marvell Bluetooth devices, such as 8688/8787/8797/8897.
 
 	  Say Y here to compile Marvell Bluetooth driver
 	  into the kernel or say M to compile it as module.
@@ -214,7 +214,7 @@ config BT_MRVL_SDIO
 	  The driver for Marvell Bluetooth chipsets with SDIO interface.
 
 	  This driver is required if you want to use Marvell Bluetooth
-	  devices with SDIO interface. Currently SD8688/SD8787/SD8797
+	  devices with SDIO interface. Currently SD8688/SD8787/SD8797/SD8897
 	  chipsets are supported.
 
 	  Say Y here to compile support for Marvell BT-over-SDIO driver
diff --git a/drivers/bluetooth/btmrvl_sdio.c b/drivers/bluetooth/btmrvl_sdio.c
index c63488c..13693b7 100644
--- a/drivers/bluetooth/btmrvl_sdio.c
+++ b/drivers/bluetooth/btmrvl_sdio.c
@@ -82,6 +82,23 @@ static const struct btmrvl_sdio_card_reg btmrvl_reg_87xx = {
 	.io_port_2 = 0x7a,
 };
 
+static const struct btmrvl_sdio_card_reg btmrvl_reg_88xx = {
+	.cfg = 0x00,
+	.host_int_mask = 0x02,
+	.host_intstatus = 0x03,
+	.card_status = 0x50,
+	.sq_read_base_addr_a0 = 0x60,
+	.sq_read_base_addr_a1 = 0x61,
+	.card_revision = 0xbc,
+	.card_fw_status0 = 0xc0,
+	.card_fw_status1 = 0xc1,
+	.card_rx_len = 0xc2,
+	.card_rx_unit = 0xc3,
+	.io_port_0 = 0xd8,
+	.io_port_1 = 0xd9,
+	.io_port_2 = 0xda,
+};
+
 static const struct btmrvl_sdio_device btmrvl_sdio_sd8688 = {
 	.helper		= "mrvl/sd8688_helper.bin",
 	.firmware	= "mrvl/sd8688.bin",
@@ -103,6 +120,13 @@ static const struct btmrvl_sdio_device btmrvl_sdio_sd8797 = {
 	.sd_blksz_fw_dl	= 256,
 };
 
+static const struct btmrvl_sdio_device btmrvl_sdio_sd8897 = {
+	.helper		= NULL,
+	.firmware	= "mrvl/sd8897_uapsta.bin",
+	.reg		= &btmrvl_reg_88xx,
+	.sd_blksz_fw_dl	= 256,
+};
+
 static const struct sdio_device_id btmrvl_sdio_ids[] = {
 	/* Marvell SD8688 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x9105),
@@ -116,6 +140,9 @@ static const struct sdio_device_id btmrvl_sdio_ids[] = {
 	/* Marvell SD8797 Bluetooth device */
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x912A),
 			.driver_data = (unsigned long) &btmrvl_sdio_sd8797 },
+	/* Marvell SD8897 Bluetooth device */
+	{ SDIO_DEVICE(SDIO_VENDOR_ID_MARVELL, 0x912E),
+			.driver_data = (unsigned long) &btmrvl_sdio_sd8897 },
 
 	{ }	/* Terminating entry */
 };
@@ -1194,3 +1221,4 @@ MODULE_FIRMWARE("mrvl/sd8688_helper.bin");
 MODULE_FIRMWARE("mrvl/sd8688.bin");
 MODULE_FIRMWARE("mrvl/sd8787_uapsta.bin");
 MODULE_FIRMWARE("mrvl/sd8797_uapsta.bin");
+MODULE_FIRMWARE("mrvl/sd8897_uapsta.bin");
-- 
1.8.2.3

