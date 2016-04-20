Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22826 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbcDTQot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:44:49 -0400
Subject: [PATCH v2 1/8] ath10k: remove deprecated firmware API 1 support
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 20 Apr 2016 19:44:36 +0300
Message-ID: <20160420164436.8801.79430.stgit@potku.adurom.net> (sfid-20160420_184452_435784_732868D6)
In-Reply-To: <20160420164301.8801.12099.stgit@potku.adurom.net>
References: <20160420164301.8801.12099.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This has ben deprecated years ago, I haven't heard anyone using it since and
most likely it won't even work anymore. So just remove all of it.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   73 --------------------------------
 drivers/net/wireless/ath/ath10k/core.h |    3 -
 drivers/net/wireless/ath/ath10k/hw.h   |   12 -----
 drivers/net/wireless/ath/ath10k/pci.c  |    1 
 drivers/net/wireless/ath/ath10k/wmi.c  |    4 --
 5 files changed, 93 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 1c4106b84a35..48389e0b87f6 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -63,8 +63,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 2116,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
-			.fw = QCA988X_HW_2_0_FW_FILE,
-			.otp = QCA988X_HW_2_0_OTP_FILE,
 			.board = QCA988X_HW_2_0_BOARD_DATA_FILE,
 			.board_size = QCA988X_BOARD_DATA_SZ,
 			.board_ext_size = QCA988X_BOARD_EXT_DATA_SZ,
@@ -82,8 +80,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
-			.fw = QCA6174_HW_2_1_FW_FILE,
-			.otp = QCA6174_HW_2_1_OTP_FILE,
 			.board = QCA6174_HW_2_1_BOARD_DATA_FILE,
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
@@ -102,8 +98,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
-			.fw = QCA6174_HW_2_1_FW_FILE,
-			.otp = QCA6174_HW_2_1_OTP_FILE,
 			.board = QCA6174_HW_2_1_BOARD_DATA_FILE,
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
@@ -122,8 +116,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
-			.fw = QCA6174_HW_3_0_FW_FILE,
-			.otp = QCA6174_HW_3_0_OTP_FILE,
 			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
@@ -143,8 +135,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.fw = {
 			/* uses same binaries as hw3.0 */
 			.dir = QCA6174_HW_3_0_FW_DIR,
-			.fw = QCA6174_HW_3_0_FW_FILE,
-			.otp = QCA6174_HW_3_0_OTP_FILE,
 			.board = QCA6174_HW_3_0_BOARD_DATA_FILE,
 			.board_size = QCA6174_BOARD_DATA_SZ,
 			.board_ext_size = QCA6174_BOARD_EXT_DATA_SZ,
@@ -167,8 +157,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 12064,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
-			.fw = QCA99X0_HW_2_0_FW_FILE,
-			.otp = QCA99X0_HW_2_0_OTP_FILE,
 			.board = QCA99X0_HW_2_0_BOARD_DATA_FILE,
 			.board_size = QCA99X0_BOARD_DATA_SZ,
 			.board_ext_size = QCA99X0_BOARD_EXT_DATA_SZ,
@@ -186,8 +174,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA9377_HW_1_0_FW_DIR,
-			.fw = QCA9377_HW_1_0_FW_FILE,
-			.otp = QCA9377_HW_1_0_OTP_FILE,
 			.board = QCA9377_HW_1_0_BOARD_DATA_FILE,
 			.board_size = QCA9377_BOARD_DATA_SZ,
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
@@ -205,8 +191,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 8124,
 		.fw = {
 			.dir = QCA9377_HW_1_0_FW_DIR,
-			.fw = QCA9377_HW_1_0_FW_FILE,
-			.otp = QCA9377_HW_1_0_OTP_FILE,
 			.board = QCA9377_HW_1_0_BOARD_DATA_FILE,
 			.board_size = QCA9377_BOARD_DATA_SZ,
 			.board_ext_size = QCA9377_BOARD_EXT_DATA_SZ,
@@ -229,8 +213,6 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.cal_data_len = 12064,
 		.fw = {
 			.dir = QCA4019_HW_1_0_FW_DIR,
-			.fw = QCA4019_HW_1_0_FW_FILE,
-			.otp = QCA4019_HW_1_0_OTP_FILE,
 			.board = QCA4019_HW_1_0_BOARD_DATA_FILE,
 			.board_size = QCA4019_BOARD_DATA_SZ,
 			.board_ext_size = QCA4019_BOARD_EXT_DATA_SZ,
@@ -703,9 +685,6 @@ static void ath10k_core_free_board_files(struct ath10k *ar)
 
 static void ath10k_core_free_firmware_files(struct ath10k *ar)
 {
-	if (!IS_ERR(ar->otp))
-		release_firmware(ar->otp);
-
 	if (!IS_ERR(ar->firmware))
 		release_firmware(ar->firmware);
 
@@ -714,7 +693,6 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 
 	ath10k_swap_code_seg_release(ar);
 
-	ar->otp = NULL;
 	ar->otp_data = NULL;
 	ar->otp_len = 0;
 
@@ -1000,50 +978,6 @@ success:
 	return 0;
 }
 
-static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
-{
-	int ret = 0;
-
-	if (ar->hw_params.fw.fw == NULL) {
-		ath10k_err(ar, "firmware file not defined\n");
-		return -EINVAL;
-	}
-
-	ar->firmware = ath10k_fetch_fw_file(ar,
-					    ar->hw_params.fw.dir,
-					    ar->hw_params.fw.fw);
-	if (IS_ERR(ar->firmware)) {
-		ret = PTR_ERR(ar->firmware);
-		ath10k_err(ar, "could not fetch firmware (%d)\n", ret);
-		goto err;
-	}
-
-	ar->firmware_data = ar->firmware->data;
-	ar->firmware_len = ar->firmware->size;
-
-	/* OTP may be undefined. If so, don't fetch it at all */
-	if (ar->hw_params.fw.otp == NULL)
-		return 0;
-
-	ar->otp = ath10k_fetch_fw_file(ar,
-				       ar->hw_params.fw.dir,
-				       ar->hw_params.fw.otp);
-	if (IS_ERR(ar->otp)) {
-		ret = PTR_ERR(ar->otp);
-		ath10k_err(ar, "could not fetch otp (%d)\n", ret);
-		goto err;
-	}
-
-	ar->otp_data = ar->otp->data;
-	ar->otp_len = ar->otp->size;
-
-	return 0;
-
-err:
-	ath10k_core_free_firmware_files(ar);
-	return ret;
-}
-
 static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 {
 	size_t magic_len, len, ie_len;
@@ -1253,13 +1187,6 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
 	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
-	if (ret == 0)
-		goto success;
-
-	ar->fw_api = 1;
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
-
-	ret = ath10k_core_fetch_firmware_api_1(ar);
 	if (ret)
 		return ret;
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index ccc3d639b077..01427a96dffc 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -708,8 +708,6 @@ struct ath10k {
 
 		struct ath10k_hw_params_fw {
 			const char *dir;
-			const char *fw;
-			const char *otp;
 			const char *board;
 			size_t board_size;
 			size_t board_ext_size;
@@ -720,7 +718,6 @@ struct ath10k {
 	const void *board_data;
 	size_t board_len;
 
-	const struct firmware *otp;
 	const void *otp_data;
 	size_t otp_len;
 
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index c0179bc4af29..aedd8987040b 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -35,8 +35,6 @@
 #define QCA988X_HW_2_0_VERSION		0x4100016c
 #define QCA988X_HW_2_0_CHIP_ID_REV	0x2
 #define QCA988X_HW_2_0_FW_DIR		ATH10K_FW_DIR "/QCA988X/hw2.0"
-#define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
-#define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"
 #define QCA988X_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
@@ -76,14 +74,10 @@ enum qca9377_chip_id_rev {
 };
 
 #define QCA6174_HW_2_1_FW_DIR		"ath10k/QCA6174/hw2.1"
-#define QCA6174_HW_2_1_FW_FILE		"firmware.bin"
-#define QCA6174_HW_2_1_OTP_FILE		"otp.bin"
 #define QCA6174_HW_2_1_BOARD_DATA_FILE	"board.bin"
 #define QCA6174_HW_2_1_PATCH_LOAD_ADDR	0x1234
 
 #define QCA6174_HW_3_0_FW_DIR		"ath10k/QCA6174/hw3.0"
-#define QCA6174_HW_3_0_FW_FILE		"firmware.bin"
-#define QCA6174_HW_3_0_OTP_FILE		"otp.bin"
 #define QCA6174_HW_3_0_BOARD_DATA_FILE	"board.bin"
 #define QCA6174_HW_3_0_PATCH_LOAD_ADDR	0x1234
 
@@ -94,23 +88,17 @@ enum qca9377_chip_id_rev {
 #define QCA99X0_HW_2_0_DEV_VERSION     0x01000000
 #define QCA99X0_HW_2_0_CHIP_ID_REV     0x1
 #define QCA99X0_HW_2_0_FW_DIR          ATH10K_FW_DIR "/QCA99X0/hw2.0"
-#define QCA99X0_HW_2_0_FW_FILE         "firmware.bin"
-#define QCA99X0_HW_2_0_OTP_FILE        "otp.bin"
 #define QCA99X0_HW_2_0_BOARD_DATA_FILE "board.bin"
 #define QCA99X0_HW_2_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA9377 1.0 definitions */
 #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
-#define QCA9377_HW_1_0_FW_FILE         "firmware.bin"
-#define QCA9377_HW_1_0_OTP_FILE        "otp.bin"
 #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234
 
 /* QCA4019 1.0 definitions */
 #define QCA4019_HW_1_0_DEV_VERSION     0x01000000
 #define QCA4019_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA4019/hw1.0"
-#define QCA4019_HW_1_0_FW_FILE         "firmware.bin"
-#define QCA4019_HW_1_0_OTP_FILE        "otp.bin"
 #define QCA4019_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA4019_HW_1_0_PATCH_LOAD_ADDR  0x1234
 
diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index cdd8a307c55b..8133d7b5b956 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3173,7 +3173,6 @@ MODULE_DESCRIPTION("Driver support for Atheros QCA988X PCIe devices");
 MODULE_LICENSE("Dual BSD/GPL");
 
 /* QCA988x 2.0 firmware files */
-MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" QCA988X_HW_2_0_FW_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API2_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API3_FILE);
 MODULE_FIRMWARE(QCA988X_HW_2_0_FW_DIR "/" ATH10K_FW_API4_FILE);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index adb31e188ebd..e711346b6ca9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4604,10 +4604,6 @@ static void ath10k_wmi_event_service_ready_work(struct work_struct *work)
 	ath10k_dbg_dump(ar, ATH10K_DBG_WMI, NULL, "wmi svc: ",
 			arg.service_map, arg.service_map_len);
 
-	/* only manually set fw features when not using FW IE format */
-	if (ar->fw_api == 1 && ar->fw_version_build > 636)
-		set_bit(ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX, ar->fw_features);
-
 	if (ar->num_rf_chains > ar->max_spatial_stream) {
 		ath10k_warn(ar, "hardware advertises support for more spatial streams than it should (%d > %d)\n",
 			    ar->num_rf_chains, ar->max_spatial_stream);

