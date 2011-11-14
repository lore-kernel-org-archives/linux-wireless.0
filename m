Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37248 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab1KNRbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:11 -0500
Subject: [PATCH 06/10] ath6kl: use hardware version names consistently
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:31:07 +0200
Message-ID: <20111114173107.29925.8188.stgit@localhost6.localdomain6> (sfid-20111114_183115_057128_2B848C27)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Part of ath6kl uses "REV3" style of naming hardware versions and elsewhere
"hw 2.1.1" is used instead for the same version. This is confusing, use
the latter term everywhere.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |   60 +++++++++++-----------
 drivers/net/wireless/ath/ath6kl/init.c |   88 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath6kl/sdio.c |   20 ++++---
 drivers/net/wireless/ath/ath6kl/usb.c  |   12 ++--
 4 files changed, 91 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b034001..b14ad11 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -89,44 +89,46 @@ struct ath6kl_fw_ie {
 };
 
 /* AR6003 1.0 definitions */
-#define AR6003_REV1_VERSION                 0x300002ba
+#define AR6003_HW_1_0_VERSION                 0x300002ba
 
 /* AR6003 2.0 definitions */
-#define AR6003_REV2_VERSION                 0x30000384
-#define AR6003_REV2_PATCH_DOWNLOAD_ADDRESS  0x57e910
-#define AR6003_REV2_OTP_FILE                "ath6k/AR6003/hw2.0/otp.bin.z77"
-#define AR6003_REV2_FIRMWARE_FILE           "ath6k/AR6003/hw2.0/athwlan.bin.z77"
-#define AR6003_REV2_TCMD_FIRMWARE_FILE      "ath6k/AR6003/hw2.0/athtcmd_ram.bin"
-#define AR6003_REV2_PATCH_FILE              "ath6k/AR6003/hw2.0/data.patch.bin"
-#define AR6003_REV2_FIRMWARE_2_FILE         "ath6k/AR6003/hw2.0/fw-2.bin"
-#define AR6003_REV2_BOARD_DATA_FILE         "ath6k/AR6003/hw2.0/bdata.bin"
-#define AR6003_REV2_DEFAULT_BOARD_DATA_FILE "ath6k/AR6003/hw2.0/bdata.SD31.bin"
+#define AR6003_HW_2_0_VERSION                 0x30000384
+#define AR6003_HW_2_0_PATCH_DOWNLOAD_ADDRESS  0x57e910
+#define AR6003_HW_2_0_OTP_FILE "ath6k/AR6003/hw2.0/otp.bin.z77"
+#define AR6003_HW_2_0_FIRMWARE_FILE "ath6k/AR6003/hw2.0/athwlan.bin.z77"
+#define AR6003_HW_2_0_TCMD_FIRMWARE_FILE "ath6k/AR6003/hw2.0/athtcmd_ram.bin"
+#define AR6003_HW_2_0_PATCH_FILE "ath6k/AR6003/hw2.0/data.patch.bin"
+#define AR6003_HW_2_0_FIRMWARE_2_FILE "ath6k/AR6003/hw2.0/fw-2.bin"
+#define AR6003_HW_2_0_BOARD_DATA_FILE "ath6k/AR6003/hw2.0/bdata.bin"
+#define AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE \
+			"ath6k/AR6003/hw2.0/bdata.SD31.bin"
 
 /* AR6003 3.0 definitions */
-#define AR6003_REV3_VERSION                 0x30000582
-#define AR6003_REV3_OTP_FILE                "ath6k/AR6003/hw2.1.1/otp.bin"
-#define AR6003_REV3_FIRMWARE_FILE           "ath6k/AR6003/hw2.1.1/athwlan.bin"
-#define AR6003_REV3_TCMD_FIRMWARE_FILE    "ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
-#define AR6003_REV3_PATCH_FILE            "ath6k/AR6003/hw2.1.1/data.patch.bin"
-#define AR6003_REV3_FIRMWARE_2_FILE           "ath6k/AR6003/hw2.1.1/fw-2.bin"
-#define AR6003_REV3_BOARD_DATA_FILE       "ath6k/AR6003/hw2.1.1/bdata.bin"
-#define AR6003_REV3_DEFAULT_BOARD_DATA_FILE	\
-	"ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
+#define AR6003_HW_2_1_1_VERSION                 0x30000582
+#define AR6003_HW_2_1_1_OTP_FILE "ath6k/AR6003/hw2.1.1/otp.bin"
+#define AR6003_HW_2_1_1_FIRMWARE_FILE "ath6k/AR6003/hw2.1.1/athwlan.bin"
+#define AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE \
+			"ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
+#define AR6003_HW_2_1_1_PATCH_FILE "ath6k/AR6003/hw2.1.1/data.patch.bin"
+#define AR6003_HW_2_1_1_FIRMWARE_2_FILE "ath6k/AR6003/hw2.1.1/fw-2.bin"
+#define AR6003_HW_2_1_1_BOARD_DATA_FILE "ath6k/AR6003/hw2.1.1/bdata.bin"
+#define AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE	\
+			"ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
 
 /* AR6004 1.0 definitions */
-#define AR6004_REV1_VERSION                 0x30000623
-#define AR6004_REV1_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.0/fw-2.bin"
-#define AR6004_REV1_FIRMWARE_FILE           "ath6k/AR6004/hw1.0/fw.ram.bin"
-#define AR6004_REV1_BOARD_DATA_FILE         "ath6k/AR6004/hw1.0/bdata.bin"
-#define AR6004_REV1_DEFAULT_BOARD_DATA_FILE \
+#define AR6004_HW_1_0_VERSION                 0x30000623
+#define AR6004_HW_1_0_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.0/fw-2.bin"
+#define AR6004_HW_1_0_FIRMWARE_FILE           "ath6k/AR6004/hw1.0/fw.ram.bin"
+#define AR6004_HW_1_0_BOARD_DATA_FILE         "ath6k/AR6004/hw1.0/bdata.bin"
+#define AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE \
 	"ath6k/AR6004/hw1.0/bdata.DB132.bin"
 
 /* AR6004 1.1 definitions */
-#define AR6004_REV2_VERSION                 0x30000001
-#define AR6004_REV2_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.1/fw-2.bin"
-#define AR6004_REV2_FIRMWARE_FILE           "ath6k/AR6004/hw1.1/fw.ram.bin"
-#define AR6004_REV2_BOARD_DATA_FILE         "ath6k/AR6004/hw1.1/bdata.bin"
-#define AR6004_REV2_DEFAULT_BOARD_DATA_FILE \
+#define AR6004_HW_1_1_VERSION                 0x30000001
+#define AR6004_HW_1_1_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.1/fw-2.bin"
+#define AR6004_HW_1_1_FIRMWARE_FILE           "ath6k/AR6004/hw1.1/fw.ram.bin"
+#define AR6004_HW_1_1_BOARD_DATA_FILE         "ath6k/AR6004/hw1.1/bdata.bin"
+#define AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE \
 	"ath6k/AR6004/hw1.1/bdata.DB132.bin"
 
 /* Per STA data, used in AP mode */
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index acfe79a..208e77e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -35,7 +35,7 @@ module_param(suspend_cutpower, bool, 0444);
 
 static const struct ath6kl_hw hw_list[] = {
 	{
-		.id				= AR6003_REV2_VERSION,
+		.id				= AR6003_HW_2_0_VERSION,
 		.name				= "ar6003 hw 2.0",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x543180,
@@ -46,7 +46,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_start_override_addr	= 0x944C00,
 	},
 	{
-		.id				= AR6003_REV3_VERSION,
+		.id				= AR6003_HW_2_1_1_VERSION,
 		.name				= "ar6003 hw 2.1.1",
 		.dataset_patch_addr		= 0x57ff74,
 		.app_load_addr			= 0x1234,
@@ -54,7 +54,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 512,
 	},
 	{
-		.id				= AR6004_REV1_VERSION,
+		.id				= AR6004_HW_1_0_VERSION,
 		.name				= "ar6004 hw 1.0",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x1234,
@@ -63,7 +63,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_addr			= 0x433900,
 	},
 	{
-		.id				= AR6004_REV2_VERSION,
+		.id				= AR6004_HW_1_1_VERSION,
 		.name				= "ar6004 hw 1.1",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x1234,
@@ -590,11 +590,11 @@ static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 static const char *get_target_ver_dir(const struct ath6kl *ar)
 {
 	switch (ar->version.target_ver) {
-	case AR6003_REV1_VERSION:
+	case AR6003_HW_1_0_VERSION:
 		return "ath6k/AR6003/hw1.0";
-	case AR6003_REV2_VERSION:
+	case AR6003_HW_2_0_VERSION:
 		return "ath6k/AR6003/hw2.0";
-	case AR6003_REV3_VERSION:
+	case AR6003_HW_2_1_1_VERSION:
 		return "ath6k/AR6003/hw2.1.1";
 	}
 	ath6kl_warn("%s: unsupported target version 0x%x.\n", __func__,
@@ -653,14 +653,14 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 		return 0;
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_BOARD_DATA_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_BOARD_DATA_FILE;
 		break;
-	case AR6004_REV1_VERSION:
-		filename = AR6004_REV1_BOARD_DATA_FILE;
+	case AR6004_HW_1_0_VERSION:
+		filename = AR6004_HW_1_0_BOARD_DATA_FILE;
 		break;
 	default:
-		filename = AR6003_REV3_BOARD_DATA_FILE;
+		filename = AR6003_HW_2_1_1_BOARD_DATA_FILE;
 		break;
 	}
 
@@ -681,14 +681,14 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 		    filename, ret);
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_DEFAULT_BOARD_DATA_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE;
 		break;
-	case AR6004_REV1_VERSION:
-		filename = AR6004_REV1_DEFAULT_BOARD_DATA_FILE;
+	case AR6004_HW_1_0_VERSION:
+		filename = AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE;
 		break;
 	default:
-		filename = AR6003_REV3_DEFAULT_BOARD_DATA_FILE;
+		filename = AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE;
 		break;
 	}
 
@@ -715,15 +715,15 @@ static int ath6kl_fetch_otp_file(struct ath6kl *ar)
 		return 0;
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_OTP_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_OTP_FILE;
 		break;
-	case AR6004_REV1_VERSION:
+	case AR6004_HW_1_0_VERSION:
 		ath6kl_dbg(ATH6KL_DBG_TRC, "AR6004 doesn't need OTP file\n");
 		return 0;
 		break;
 	default:
-		filename = AR6003_REV3_OTP_FILE;
+		filename = AR6003_HW_2_1_1_OTP_FILE;
 		break;
 	}
 
@@ -748,13 +748,13 @@ static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 
 	if (testmode) {
 		switch (ar->version.target_ver) {
-		case AR6003_REV2_VERSION:
-			filename = AR6003_REV2_TCMD_FIRMWARE_FILE;
+		case AR6003_HW_2_0_VERSION:
+			filename = AR6003_HW_2_0_TCMD_FIRMWARE_FILE;
 			break;
-		case AR6003_REV3_VERSION:
-			filename = AR6003_REV3_TCMD_FIRMWARE_FILE;
+		case AR6003_HW_2_1_1_VERSION:
+			filename = AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE;
 			break;
-		case AR6004_REV1_VERSION:
+		case AR6004_HW_1_0_VERSION:
 			ath6kl_warn("testmode not supported with ar6004\n");
 			return -EOPNOTSUPP;
 		default:
@@ -769,14 +769,14 @@ static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 	}
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_FIRMWARE_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_FIRMWARE_FILE;
 		break;
-	case AR6004_REV1_VERSION:
-		filename = AR6004_REV1_FIRMWARE_FILE;
+	case AR6004_HW_1_0_VERSION:
+		filename = AR6004_HW_1_0_FIRMWARE_FILE;
 		break;
 	default:
-		filename = AR6003_REV3_FIRMWARE_FILE;
+		filename = AR6003_HW_2_1_1_FIRMWARE_FILE;
 		break;
 	}
 
@@ -797,15 +797,15 @@ static int ath6kl_fetch_patch_file(struct ath6kl *ar)
 	int ret;
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_PATCH_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_PATCH_FILE;
 		break;
-	case AR6004_REV1_VERSION:
+	case AR6004_HW_1_0_VERSION:
 		/* FIXME: implement for AR6004 */
 		return 0;
 		break;
 	default:
-		filename = AR6003_REV3_PATCH_FILE;
+		filename = AR6003_HW_2_1_1_PATCH_FILE;
 		break;
 	}
 
@@ -852,17 +852,17 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	__le32 *val;
 
 	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_FIRMWARE_2_FILE;
+	case AR6003_HW_2_0_VERSION:
+		filename = AR6003_HW_2_0_FIRMWARE_2_FILE;
 		break;
-	case AR6003_REV3_VERSION:
-		filename = AR6003_REV3_FIRMWARE_2_FILE;
+	case AR6003_HW_2_1_1_VERSION:
+		filename = AR6003_HW_2_1_1_FIRMWARE_2_FILE;
 		break;
-	case AR6004_REV1_VERSION:
-		filename = AR6004_REV1_FIRMWARE_2_FILE;
+	case AR6004_HW_1_0_VERSION:
+		filename = AR6004_HW_1_0_FIRMWARE_2_FILE;
 		break;
-	case AR6004_REV2_VERSION:
-		filename = AR6004_REV2_FIRMWARE_2_FILE;
+	case AR6004_HW_1_1_VERSION:
+		filename = AR6004_HW_1_1_FIRMWARE_2_FILE;
 		break;
 	default:
 		return -EOPNOTSUPP;
@@ -1313,7 +1313,7 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 		return status;
 
 	/* WAR to avoid SDIO CRC err */
-	if (ar->version.target_ver == AR6003_REV2_VERSION) {
+	if (ar->version.target_ver == AR6003_HW_2_0_VERSION) {
 		ath6kl_err("temporary war to avoid sdio crc error\n");
 
 		param = 0x20;
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 1d097d0..1dab96a 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1329,13 +1329,13 @@ MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x SDIO devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
-MODULE_FIRMWARE(AR6003_REV2_OTP_FILE);
-MODULE_FIRMWARE(AR6003_REV2_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6003_REV2_PATCH_FILE);
-MODULE_FIRMWARE(AR6003_REV2_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6003_REV2_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6003_REV3_OTP_FILE);
-MODULE_FIRMWARE(AR6003_REV3_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6003_REV3_PATCH_FILE);
-MODULE_FIRMWARE(AR6003_REV3_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6003_REV3_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_OTP_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_PATCH_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_OTP_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_PATCH_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index b85ca3f..e3cf397 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -423,9 +423,9 @@ module_exit(ath6kl_usb_exit);
 MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x USB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_FIRMWARE(AR6004_REV1_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6004_REV1_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_REV1_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_REV2_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6004_REV2_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_REV2_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);

