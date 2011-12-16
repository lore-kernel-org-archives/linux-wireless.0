Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59031 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932529Ab1LPSxi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 13:53:38 -0500
Subject: [PATCH 1/2] ath6kl: handle firmware names more dynamically
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Fri, 16 Dec 2011 20:53:31 +0200
Message-ID: <20111216185331.18442.48268.stgit@localhost6.localdomain6> (sfid-20111216_195343_439278_DB74B6CA)
In-Reply-To: <20111216185200.18442.29650.stgit@localhost6.localdomain6>
References: <20111216185200.18442.29650.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath6kl has just hardcoded paths to each firmware file. Change
this more dynamic by separating the the directory and file name from each
other. That way it's easier to dynamically create full paths to firmware and
code looks better. And now it's possible to remove a function needed by
devicetree code.

While at it add a structure inside struct ath6kl_hw to contain all
firmware names. I deliberately omitted board file support as
those will be handled later.

This is needed for firmware API 3.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |   45 ++++++++-------
 drivers/net/wireless/ath/ath6kl/init.c |   95 +++++++++++++++++---------------
 drivers/net/wireless/ath/ath6kl/sdio.c |   16 +++--
 drivers/net/wireless/ath/ath6kl/usb.c  |    5 +-
 4 files changed, 87 insertions(+), 74 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index c863a28..2679577 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -97,45 +97,46 @@ struct ath6kl_fw_ie {
 	u8 data[0];
 };
 
+#define ATH6KL_FW_API2_FILE "fw-2.bin"
+
 /* AR6003 1.0 definitions */
 #define AR6003_HW_1_0_VERSION                 0x300002ba
 
 /* AR6003 2.0 definitions */
 #define AR6003_HW_2_0_VERSION                 0x30000384
 #define AR6003_HW_2_0_PATCH_DOWNLOAD_ADDRESS  0x57e910
-#define AR6003_HW_2_0_OTP_FILE "ath6k/AR6003/hw2.0/otp.bin.z77"
-#define AR6003_HW_2_0_FIRMWARE_FILE "ath6k/AR6003/hw2.0/athwlan.bin.z77"
-#define AR6003_HW_2_0_TCMD_FIRMWARE_FILE "ath6k/AR6003/hw2.0/athtcmd_ram.bin"
-#define AR6003_HW_2_0_PATCH_FILE "ath6k/AR6003/hw2.0/data.patch.bin"
-#define AR6003_HW_2_0_FIRMWARE_2_FILE "ath6k/AR6003/hw2.0/fw-2.bin"
+#define AR6003_HW_2_0_FW_DIR			"ath6k/AR6003/hw2.0"
+#define AR6003_HW_2_0_OTP_FILE			"otp.bin.z77"
+#define AR6003_HW_2_0_FIRMWARE_FILE		"athwlan.bin.z77"
+#define AR6003_HW_2_0_TCMD_FIRMWARE_FILE	"athtcmd_ram.bin"
+#define AR6003_HW_2_0_PATCH_FILE		"data.patch.bin"
 #define AR6003_HW_2_0_BOARD_DATA_FILE "ath6k/AR6003/hw2.0/bdata.bin"
 #define AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE \
 			"ath6k/AR6003/hw2.0/bdata.SD31.bin"
 
 /* AR6003 3.0 definitions */
 #define AR6003_HW_2_1_1_VERSION                 0x30000582
-#define AR6003_HW_2_1_1_OTP_FILE "ath6k/AR6003/hw2.1.1/otp.bin"
-#define AR6003_HW_2_1_1_FIRMWARE_FILE "ath6k/AR6003/hw2.1.1/athwlan.bin"
-#define AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE \
-			"ath6k/AR6003/hw2.1.1/athtcmd_ram.bin"
-#define AR6003_HW_2_1_1_PATCH_FILE "ath6k/AR6003/hw2.1.1/data.patch.bin"
-#define AR6003_HW_2_1_1_FIRMWARE_2_FILE "ath6k/AR6003/hw2.1.1/fw-2.bin"
+#define AR6003_HW_2_1_1_FW_DIR			"ath6k/AR6003/hw2.1.1"
+#define AR6003_HW_2_1_1_OTP_FILE		"otp.bin"
+#define AR6003_HW_2_1_1_FIRMWARE_FILE		"athwlan.bin"
+#define AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE	"athtcmd_ram.bin"
+#define AR6003_HW_2_1_1_PATCH_FILE		"data.patch.bin"
 #define AR6003_HW_2_1_1_BOARD_DATA_FILE "ath6k/AR6003/hw2.1.1/bdata.bin"
 #define AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE	\
 			"ath6k/AR6003/hw2.1.1/bdata.SD31.bin"
 
 /* AR6004 1.0 definitions */
 #define AR6004_HW_1_0_VERSION                 0x30000623
-#define AR6004_HW_1_0_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.0/fw-2.bin"
-#define AR6004_HW_1_0_FIRMWARE_FILE           "ath6k/AR6004/hw1.0/fw.ram.bin"
+#define AR6004_HW_1_0_FW_DIR			"ath6k/AR6004/hw1.0"
+#define AR6004_HW_1_0_FIRMWARE_FILE		"fw.ram.bin"
 #define AR6004_HW_1_0_BOARD_DATA_FILE         "ath6k/AR6004/hw1.0/bdata.bin"
 #define AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE \
 	"ath6k/AR6004/hw1.0/bdata.DB132.bin"
 
 /* AR6004 1.1 definitions */
 #define AR6004_HW_1_1_VERSION                 0x30000001
-#define AR6004_HW_1_1_FIRMWARE_2_FILE         "ath6k/AR6004/hw1.1/fw-2.bin"
-#define AR6004_HW_1_1_FIRMWARE_FILE           "ath6k/AR6004/hw1.1/fw.ram.bin"
+#define AR6004_HW_1_1_FW_DIR			"ath6k/AR6004/hw1.1"
+#define AR6004_HW_1_1_FIRMWARE_FILE		"fw.ram.bin"
 #define AR6004_HW_1_1_BOARD_DATA_FILE         "ath6k/AR6004/hw1.1/bdata.bin"
 #define AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE \
 	"ath6k/AR6004/hw1.1/bdata.DB132.bin"
@@ -575,11 +576,15 @@ struct ath6kl {
 		u32 refclk_hz;
 		u32 uarttx_pin;
 
-		const char *fw_otp;
-		const char *fw;
-		const char *fw_tcmd;
-		const char *fw_patch;
-		const char *fw_api2;
+		struct ath6kl_hw_fw {
+			const char *dir;
+			const char *otp;
+			const char *fw;
+			const char *tcmd;
+			const char *patch;
+			const char *api2;
+		} fw;
+
 		const char *fw_board;
 		const char *fw_default_board;
 	} hw;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 0643558..c666226 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -47,11 +47,15 @@ static const struct ath6kl_hw hw_list[] = {
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
 
-		.fw_otp			= AR6003_HW_2_0_OTP_FILE,
-		.fw			= AR6003_HW_2_0_FIRMWARE_FILE,
-		.fw_tcmd		= AR6003_HW_2_0_TCMD_FIRMWARE_FILE,
-		.fw_patch		= AR6003_HW_2_0_PATCH_FILE,
-		.fw_api2		= AR6003_HW_2_0_FIRMWARE_2_FILE,
+		.fw = {
+			.dir		= AR6003_HW_2_0_FW_DIR,
+			.otp		= AR6003_HW_2_0_OTP_FILE,
+			.fw		= AR6003_HW_2_0_FIRMWARE_FILE,
+			.tcmd		= AR6003_HW_2_0_TCMD_FIRMWARE_FILE,
+			.patch		= AR6003_HW_2_0_PATCH_FILE,
+			.api2		= ATH6KL_FW_API2_FILE,
+		},
+
 		.fw_board		= AR6003_HW_2_0_BOARD_DATA_FILE,
 		.fw_default_board	= AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE,
 	},
@@ -65,11 +69,15 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
 
-		.fw_otp			= AR6003_HW_2_1_1_OTP_FILE,
-		.fw			= AR6003_HW_2_1_1_FIRMWARE_FILE,
-		.fw_tcmd		= AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE,
-		.fw_patch		= AR6003_HW_2_1_1_PATCH_FILE,
-		.fw_api2		= AR6003_HW_2_1_1_FIRMWARE_2_FILE,
+		.fw = {
+			.dir		= AR6003_HW_2_1_1_FW_DIR,
+			.otp		= AR6003_HW_2_1_1_OTP_FILE,
+			.fw		= AR6003_HW_2_1_1_FIRMWARE_FILE,
+			.tcmd		= AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE,
+			.patch		= AR6003_HW_2_1_1_PATCH_FILE,
+			.api2		= ATH6KL_FW_API2_FILE,
+		},
+
 		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
 		.fw_default_board	= AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
@@ -84,8 +92,12 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 11,
 
-		.fw			= AR6004_HW_1_0_FIRMWARE_FILE,
-		.fw_api2		= AR6004_HW_1_0_FIRMWARE_2_FILE,
+		.fw = {
+			.dir		= AR6004_HW_1_0_FW_DIR,
+			.fw		= AR6004_HW_1_0_FIRMWARE_FILE,
+			.api2		= ATH6KL_FW_API2_FILE,
+		},
+
 		.fw_board		= AR6004_HW_1_0_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE,
 	},
@@ -100,8 +112,12 @@ static const struct ath6kl_hw hw_list[] = {
 		.refclk_hz			= 40000000,
 		.uarttx_pin			= 11,
 
-		.fw			= AR6004_HW_1_1_FIRMWARE_FILE,
-		.fw_api2		= AR6004_HW_1_1_FIRMWARE_2_FILE,
+		.fw = {
+			.dir		= AR6004_HW_1_1_FW_DIR,
+			.fw		= AR6004_HW_1_1_FIRMWARE_FILE,
+			.api2		= ATH6KL_FW_API2_FILE,
+		},
+
 		.fw_board		= AR6004_HW_1_1_BOARD_DATA_FILE,
 		.fw_default_board	= AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
@@ -626,21 +642,6 @@ static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 }
 
 #ifdef CONFIG_OF
-static const char *get_target_ver_dir(const struct ath6kl *ar)
-{
-	switch (ar->version.target_ver) {
-	case AR6003_HW_1_0_VERSION:
-		return "ath6k/AR6003/hw1.0";
-	case AR6003_HW_2_0_VERSION:
-		return "ath6k/AR6003/hw2.0";
-	case AR6003_HW_2_1_1_VERSION:
-		return "ath6k/AR6003/hw2.1.1";
-	}
-	ath6kl_warn("%s: unsupported target version 0x%x.\n", __func__,
-		    ar->version.target_ver);
-	return NULL;
-}
-
 /*
  * Check the device tree for a board-id and use it to construct
  * the pathname to the firmware file.  Used (for now) to find a
@@ -663,7 +664,7 @@ static bool check_device_tree(struct ath6kl *ar)
 			continue;
 		}
 		snprintf(board_filename, sizeof(board_filename),
-			 "%s/bdata.%s.bin", get_target_ver_dir(ar), board_id);
+			 "%s/bdata.%s.bin", ar->hw.fw.dir, board_id);
 
 		ret = ath6kl_get_fw(ar, board_filename, &ar->fw_board,
 				    &ar->fw_board_len);
@@ -730,19 +731,20 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 
 static int ath6kl_fetch_otp_file(struct ath6kl *ar)
 {
-	const char *filename;
+	char filename[100];
 	int ret;
 
 	if (ar->fw_otp != NULL)
 		return 0;
 
-	if (ar->hw.fw_otp == NULL) {
+	if (ar->hw.fw.otp == NULL) {
 		ath6kl_dbg(ATH6KL_DBG_BOOT,
 			   "no OTP file configured for this hw\n");
 		return 0;
 	}
 
-	filename = ar->hw.fw_otp;
+	snprintf(filename, sizeof(filename), "%s/%s",
+		 ar->hw.fw.dir, ar->hw.fw.otp);
 
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_otp,
 			    &ar->fw_otp_len);
@@ -757,29 +759,32 @@ static int ath6kl_fetch_otp_file(struct ath6kl *ar)
 
 static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 {
-	const char *filename;
+	char filename[100];
 	int ret;
 
 	if (ar->fw != NULL)
 		return 0;
 
 	if (testmode) {
-		if (ar->hw.fw_tcmd == NULL) {
+		if (ar->hw.fw.tcmd == NULL) {
 			ath6kl_warn("testmode not supported\n");
 			return -EOPNOTSUPP;
 		}
 
-		filename = ar->hw.fw_tcmd;
+		snprintf(filename, sizeof(filename), "%s/%s",
+			 ar->hw.fw.dir, ar->hw.fw.tcmd);
 
 		set_bit(TESTMODE, &ar->flag);
 
 		goto get_fw;
 	}
 
-	if (WARN_ON(ar->hw.fw == NULL))
+	/* FIXME: remove WARN_ON() as we won't support FW API 1 for long */
+	if (WARN_ON(ar->hw.fw.fw == NULL))
 		return -EINVAL;
 
-	filename = ar->hw.fw;
+	snprintf(filename, sizeof(filename), "%s/%s",
+		 ar->hw.fw.dir, ar->hw.fw.fw);
 
 get_fw:
 	ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
@@ -794,16 +799,17 @@ get_fw:
 
 static int ath6kl_fetch_patch_file(struct ath6kl *ar)
 {
-	const char *filename;
+	char filename[100];
 	int ret;
 
 	if (ar->fw_patch != NULL)
 		return 0;
 
-	if (ar->hw.fw_patch == NULL)
+	if (ar->hw.fw.patch == NULL)
 		return 0;
 
-	filename = ar->hw.fw_patch;
+	snprintf(filename, sizeof(filename), "%s/%s",
+		 ar->hw.fw.dir, ar->hw.fw.patch);
 
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_patch,
 			    &ar->fw_patch_len);
@@ -840,15 +846,16 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	size_t magic_len, len, ie_len;
 	const struct firmware *fw;
 	struct ath6kl_fw_ie *hdr;
-	const char *filename;
+	char filename[100];
 	const u8 *data;
 	int ret, ie_id, i, index, bit;
 	__le32 *val;
 
-	if (ar->hw.fw_api2 == NULL)
+	if (ar->hw.fw.api2 == NULL)
 		return -EOPNOTSUPP;
 
-	filename = ar->hw.fw_api2;
+	snprintf(filename, sizeof(filename), "%s/%s",
+		 ar->hw.fw.dir, ar->hw.fw.api2);
 
 	ret = request_firmware(&fw, filename, ar->dev);
 	if (ret)
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 15c3f56..278a9f3 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1362,19 +1362,19 @@ MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x SDIO devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
-MODULE_FIRMWARE(AR6003_HW_2_0_OTP_FILE);
-MODULE_FIRMWARE(AR6003_HW_2_0_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6003_HW_2_0_PATCH_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_FW_DIR "/" AR6003_HW_2_0_OTP_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_FW_DIR "/" AR6003_HW_2_0_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_0_FW_DIR "/" AR6003_HW_2_0_PATCH_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6003_HW_2_1_1_OTP_FILE);
-MODULE_FIRMWARE(AR6003_HW_2_1_1_FIRMWARE_FILE);
-MODULE_FIRMWARE(AR6003_HW_2_1_1_PATCH_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_FW_DIR "/" AR6003_HW_2_1_1_OTP_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_FW_DIR "/" AR6003_HW_2_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6003_HW_2_1_1_FW_DIR "/" AR6003_HW_2_1_1_PATCH_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_0_FW_DIR "/" AR6004_HW_1_0_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_FW_DIR "/" AR6004_HW_1_1_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);
diff --git a/drivers/net/wireless/ath/ath6kl/usb.c b/drivers/net/wireless/ath/ath6kl/usb.c
index e3cf397..bb34179 100644
--- a/drivers/net/wireless/ath/ath6kl/usb.c
+++ b/drivers/net/wireless/ath/ath6kl/usb.c
@@ -423,9 +423,10 @@ module_exit(ath6kl_usb_exit);
 MODULE_AUTHOR("Atheros Communications, Inc.");
 MODULE_DESCRIPTION("Driver support for Atheros AR600x USB devices");
 MODULE_LICENSE("Dual BSD/GPL");
-MODULE_FIRMWARE(AR6004_HW_1_0_FIRMWARE_FILE);
+
+MODULE_FIRMWARE(AR6004_HW_1_0_FW_DIR "/" AR6004_HW_1_0_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE);
-MODULE_FIRMWARE(AR6004_HW_1_1_FIRMWARE_FILE);
+MODULE_FIRMWARE(AR6004_HW_1_1_FW_DIR "/" AR6004_HW_1_1_FIRMWARE_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_BOARD_DATA_FILE);
 MODULE_FIRMWARE(AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE);

