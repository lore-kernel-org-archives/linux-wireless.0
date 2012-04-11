Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63816 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab2DKCDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 22:03:36 -0400
From: <raychen@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Ray Chen <raychen@qca.qualcomm.com>
Subject: [PATCH 1/1] ath6kl: Add AR6004 1.2 support for USB and SDIO
Date: Wed, 11 Apr 2012 10:03:13 +0800
Message-ID: <1334109793-2451-1-git-send-email-raychen@qca.qualcomm.com> (sfid-20120411_040341_848169_1727D4F0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ray Chen <raychen@qca.qualcomm.com>

Add the necessary change for AR6004 1.2 chip support

Signed-off-by: Ray Chen <raychen@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    8 ++++++++
 drivers/net/wireless/ath/ath6kl/init.c |   18 ++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 +++
 drivers/net/wireless/ath/ath6kl/usb.c  |    3 +++
 4 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 75b1d86..c35cd33 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -156,6 +156,14 @@ struct ath6kl_fw_ie {
 #define AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE \
 	"ath6k/AR6004/hw1.1/bdata.DB132.bin"
 
+/* AR6004 1.2 definitions */
+#define AR6004_HW_1_2_VERSION                 0x300007e8
+#define AR6004_HW_1_2_FW_DIR			"ath6k/AR6004/hw1.2"
+#define AR6004_HW_1_2_FIRMWARE_FILE           "fw.ram.bin"
+#define AR6004_HW_1_2_BOARD_DATA_FILE         "ath6k/AR6004/hw1.2/bdata.bin"
+#define AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE \
+	"ath6k/AR6004/hw1.2/bdata.bin"
+
 /* Per STA data, used in AP mode */
 #define STA_PS_AWAKE		BIT(0)
 #define	STA_PS_SLEEP		BIT(1)
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5949ab5..0071f82 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -117,6 +117,24 @@ static const struct ath6kl_hw hw_list[] = {
 		.fw_board		= AR6004_HW_1_1_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
+	{
+		.id				= AR6004_HW_1_2_VERSION,
+		.name				= "ar6004 hw 1.2",
+		.dataset_patch_addr		= 0x436ecc,
+		.app_load_addr			= 0x1234,
+		.board_ext_data_addr		= 0x437000,
+		.reserved_ram_size		= 9216,
+		.board_addr			= 0x435c00,
+		.refclk_hz			= 40000000,
+		.uarttx_pin			= 11,
+
+		.fw = {
+			.dir		= AR6004_HW_1_2_FW_DIR,
+			.fw		= AR6004_HW_1_2_FIRMWARE_FILE,
+		},
+		.fw_board		= AR6004_HW_1_2_BOARD_DATA_FILE,
+		.fw_default_board	= AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE,
+	},
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 44ea7a7..b41220d 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1457,3 +1457,6 @@ MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_FW_DIR "/" AR6004_HW_1_1_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_FW_DIR "/" AR6004_HW_1_2_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index ec7f1f5..73aacdd 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1207,3 +1207,6 @@ MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE);
-- 
1.7.0.4

