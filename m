Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8748 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2GQGbx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 02:31:53 -0400
From: Bala Shanmugam <bkamatch@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath6kl: Add support for AR6004 hardware version 1.3
Date: Tue, 17 Jul 2012 12:01:55 +0530
Message-ID: <1342506715-13168-1-git-send-email-bkamatch@qca.qualcomm.com> (sfid-20120717_083157_681542_2F3B91B2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for AR6004 hardware with version 1.3 and has
id 0x31c8088a.

Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    7 +++++++
 drivers/net/wireless/ath/ath6kl/init.c |   20 ++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/sdio.c |    3 +++
 drivers/net/wireless/ath/ath6kl/usb.c  |    3 +++
 4 files changed, 33 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c655438..2d1b8ac 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -192,6 +192,13 @@ enum ath6kl_hw_flags {
 #define AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE \
 	AR6004_HW_1_2_FW_DIR "/bdata.bin"
 
+/* AR6004 1.3 definitions */
+#define AR6004_HW_1_3_VERSION			0x31c8088a
+#define AR6004_HW_1_3_FW_DIR			"ath6k/AR6004/hw1.3"
+#define AR6004_HW_1_3_FIRMWARE_FILE		"fw.ram.bin"
+#define AR6004_HW_1_3_BOARD_DATA_FILE		"ath6k/AR6004/hw1.3/bdata.bin"
+#define AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE	"ath6k/AR6004/hw1.3/bdata.bin"
+
 /* Per STA data, used in AP mode */
 #define STA_PS_AWAKE		BIT(0)
 #define	STA_PS_SLEEP		BIT(1)
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f90b5db..8bd4299 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -142,6 +142,26 @@ static const struct ath6kl_hw hw_list[] = {
 		.fw_board		= AR6004_HW_1_2_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE,
 	},
+	{
+		.id				= AR6004_HW_1_3_VERSION,
+		.name				= "ar6004 hw 1.3",
+		.dataset_patch_addr		= 0x437860,
+		.app_load_addr			= 0x1234,
+		.board_ext_data_addr		= 0x437000,
+		.reserved_ram_size		= 7168,
+		.board_addr			= 0x436400,
+		.refclk_hz                      = 40000000,
+		.uarttx_pin                     = 11,
+		.flags                          = ATH6KL_HW_FLAG_64BIT_RATES,
+
+		.fw = {
+			.dir            = AR6004_HW_1_3_FW_DIR,
+			.fw             = AR6004_HW_1_3_FIRMWARE_FILE,
+		},
+
+		.fw_board               = AR6004_HW_1_3_BOARD_DATA_FILE,
+		.fw_default_board       = AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE,
+	},
 };
 
 /*
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 05b9540..65e9983 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1462,3 +1462,6 @@ MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_FW_DIR "/" AR6004_HW_1_2_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_FW_DIR "/" AR6004_HW_1_3_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index 3740c3d..4aa97aa 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -1220,3 +1220,6 @@ MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_2_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_FW_DIR "/" AR6004_HW_1_3_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_3_DEFAULT_BOARD_DATA_FILE);
-- 
1.7.9.5

