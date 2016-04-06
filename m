Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17030 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbcDFOpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 10:45:11 -0400
Subject: [PATCH 2/8] ath10k: refactor firmware images to struct
 ath10k_fw_components
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 6 Apr 2016 17:44:59 +0300
Message-ID: <20160406144458.28399.45870.stgit@potku.adurom.net> (sfid-20160406_164546_094240_070BF13C)
In-Reply-To: <20160406144355.28399.23733.stgit@potku.adurom.net>
References: <20160406144355.28399.23733.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to share ath10k_core_fetch_board_data_api_n() with testmode.c
refactor all firmware components to struct ath10k_fw_components. This structure
will hold firmware related files, for example firmware-N.bin and board-N.bin.

For firmware-N.bin create a new struct ath10k_fw_file which contains the actual
firmware image as well as the parsed data from the image.

Modify ath10k_core_start() to take struct ath10k_fw_components() as an argument
which makes it possible in following patches to drop some ugly hacks from
testmode.c.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |  176 +++++++++++++++-------------
 drivers/net/wireless/ath/ath10k/core.h     |   45 +++++--
 drivers/net/wireless/ath/ath10k/debug.c    |   28 +++-
 drivers/net/wireless/ath/ath10k/mac.c      |    3 
 drivers/net/wireless/ath/ath10k/swap.c     |   21 ++-
 drivers/net/wireless/ath/ath10k/testmode.c |   57 ++++++---
 6 files changed, 193 insertions(+), 137 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index a04e911bd7e9..c4a36661cb17 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -538,7 +538,8 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 
 	address = ar->hw_params.patch_load_addr;
 
-	if (!ar->otp_data || !ar->otp_len) {
+	if (!ar->normal_mode_fw.fw_file.otp_data ||
+	    !ar->normal_mode_fw.fw_file.otp_len) {
 		ath10k_warn(ar,
 			    "failed to retrieve board id because of invalid otp\n");
 		return -ENODATA;
@@ -546,9 +547,11 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
 		   "boot upload otp to 0x%x len %zd for board id\n",
-		   address, ar->otp_len);
+		   address, ar->normal_mode_fw.fw_file.otp_len);
 
-	ret = ath10k_bmi_fast_download(ar, address, ar->otp_data, ar->otp_len);
+	ret = ath10k_bmi_fast_download(ar, address,
+				       ar->normal_mode_fw.fw_file.otp_data,
+				       ar->normal_mode_fw.fw_file.otp_len);
 	if (ret) {
 		ath10k_err(ar, "could not write otp for board id check: %d\n",
 			   ret);
@@ -586,7 +589,9 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	u32 bmi_otp_exe_param = ar->hw_params.otp_exe_param;
 	int ret;
 
-	ret = ath10k_download_board_data(ar, ar->board_data, ar->board_len);
+	ret = ath10k_download_board_data(ar,
+					 ar->running_fw->board_data,
+					 ar->running_fw->board_len);
 	if (ret) {
 		ath10k_err(ar, "failed to download board data: %d\n", ret);
 		return ret;
@@ -594,16 +599,20 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 
 	/* OTP is optional */
 
-	if (!ar->otp_data || !ar->otp_len) {
+	if (!ar->running_fw->fw_file.otp_data ||
+	    !ar->running_fw->fw_file.otp_len) {
 		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %p otp_len %zd)!\n",
-			    ar->otp_data, ar->otp_len);
+			    ar->running_fw->fw_file.otp_data,
+			    ar->running_fw->fw_file.otp_len);
 		return 0;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
-		   address, ar->otp_len);
+		   address, ar->running_fw->fw_file.otp_len);
 
-	ret = ath10k_bmi_fast_download(ar, address, ar->otp_data, ar->otp_len);
+	ret = ath10k_bmi_fast_download(ar, address,
+				       ar->running_fw->fw_file.otp_data,
+				       ar->running_fw->fw_file.otp_len);
 	if (ret) {
 		ath10k_err(ar, "could not write otp (%d)\n", ret);
 		return ret;
@@ -627,46 +636,33 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
+static int ath10k_download_fw(struct ath10k *ar)
 {
 	u32 address, data_len;
-	const char *mode_name;
 	const void *data;
 	int ret;
 
 	address = ar->hw_params.patch_load_addr;
 
-	switch (mode) {
-	case ATH10K_FIRMWARE_MODE_NORMAL:
-		data = ar->firmware_data;
-		data_len = ar->firmware_len;
-		mode_name = "normal";
-		ret = ath10k_swap_code_seg_configure(ar,
-						     ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW);
-		if (ret) {
-			ath10k_err(ar, "failed to configure fw code swap: %d\n",
-				   ret);
-			return ret;
-		}
-		break;
-	case ATH10K_FIRMWARE_MODE_UTF:
-		data = ar->testmode.utf_firmware_data;
-		data_len = ar->testmode.utf_firmware_len;
-		mode_name = "utf";
-		break;
-	default:
-		ath10k_err(ar, "unknown firmware mode: %d\n", mode);
-		return -EINVAL;
+	data = ar->running_fw->fw_file.firmware_data;
+	data_len = ar->running_fw->fw_file.firmware_len;
+
+	ret = ath10k_swap_code_seg_configure(ar,
+					     ATH10K_SWAP_CODE_SEG_BIN_TYPE_FW);
+	if (ret) {
+		ath10k_err(ar, "failed to configure fw code swap: %d\n",
+			   ret);
+		return ret;
 	}
 
 	ath10k_dbg(ar, ATH10K_DBG_BOOT,
-		   "boot uploading firmware image %p len %d mode %s\n",
-		   data, data_len, mode_name);
+		   "boot uploading firmware image %p len %d\n",
+		   data, data_len);
 
 	ret = ath10k_bmi_fast_download(ar, address, data, data_len);
 	if (ret) {
-		ath10k_err(ar, "failed to download %s firmware: %d\n",
-			   mode_name, ret);
+		ath10k_err(ar, "failed to download firmware: %d\n",
+			   ret);
 		return ret;
 	}
 
@@ -675,30 +671,30 @@ static int ath10k_download_fw(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 static void ath10k_core_free_board_files(struct ath10k *ar)
 {
-	if (!IS_ERR(ar->board))
-		release_firmware(ar->board);
+	if (!IS_ERR(ar->normal_mode_fw.board))
+		release_firmware(ar->normal_mode_fw.board);
 
-	ar->board = NULL;
-	ar->board_data = NULL;
-	ar->board_len = 0;
+	ar->normal_mode_fw.board = NULL;
+	ar->normal_mode_fw.board_data = NULL;
+	ar->normal_mode_fw.board_len = 0;
 }
 
 static void ath10k_core_free_firmware_files(struct ath10k *ar)
 {
-	if (!IS_ERR(ar->firmware))
-		release_firmware(ar->firmware);
+	if (!IS_ERR(ar->normal_mode_fw.fw_file.firmware))
+		release_firmware(ar->normal_mode_fw.fw_file.firmware);
 
 	if (!IS_ERR(ar->cal_file))
 		release_firmware(ar->cal_file);
 
 	ath10k_swap_code_seg_release(ar);
 
-	ar->otp_data = NULL;
-	ar->otp_len = 0;
+	ar->normal_mode_fw.fw_file.otp_data = NULL;
+	ar->normal_mode_fw.fw_file.otp_len = 0;
 
-	ar->firmware = NULL;
-	ar->firmware_data = NULL;
-	ar->firmware_len = 0;
+	ar->normal_mode_fw.fw_file.firmware = NULL;
+	ar->normal_mode_fw.fw_file.firmware_data = NULL;
+	ar->normal_mode_fw.fw_file.firmware_len = 0;
 
 	ar->cal_file = NULL;
 }
@@ -737,14 +733,14 @@ static int ath10k_core_fetch_board_data_api_1(struct ath10k *ar)
 		return -EINVAL;
 	}
 
-	ar->board = ath10k_fetch_fw_file(ar,
-					 ar->hw_params.fw.dir,
-					 ar->hw_params.fw.board);
-	if (IS_ERR(ar->board))
-		return PTR_ERR(ar->board);
+	ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
+							ar->hw_params.fw.dir,
+							ar->hw_params.fw.board);
+	if (IS_ERR(ar->normal_mode_fw.board))
+		return PTR_ERR(ar->normal_mode_fw.board);
 
-	ar->board_data = ar->board->data;
-	ar->board_len = ar->board->size;
+	ar->normal_mode_fw.board_data = ar->normal_mode_fw.board->data;
+	ar->normal_mode_fw.board_len = ar->normal_mode_fw.board->size;
 
 	return 0;
 }
@@ -804,8 +800,8 @@ static int ath10k_core_parse_bd_ie_board(struct ath10k *ar,
 				   "boot found board data for '%s'",
 				   boardname);
 
-			ar->board_data = board_ie_data;
-			ar->board_len = board_ie_len;
+			ar->normal_mode_fw.board_data = board_ie_data;
+			ar->normal_mode_fw.board_len = board_ie_len;
 
 			ret = 0;
 			goto out;
@@ -838,12 +834,14 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	const u8 *data;
 	int ret, ie_id;
 
-	ar->board = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, filename);
-	if (IS_ERR(ar->board))
-		return PTR_ERR(ar->board);
+	ar->normal_mode_fw.board = ath10k_fetch_fw_file(ar,
+							ar->hw_params.fw.dir,
+							filename);
+	if (IS_ERR(ar->normal_mode_fw.board))
+		return PTR_ERR(ar->normal_mode_fw.board);
 
-	data = ar->board->data;
-	len = ar->board->size;
+	data = ar->normal_mode_fw.board->data;
+	len = ar->normal_mode_fw.board->size;
 
 	/* magic has extra null byte padded */
 	magic_len = strlen(ATH10K_BOARD_MAGIC) + 1;
@@ -910,7 +908,7 @@ static int ath10k_core_fetch_board_data_api_n(struct ath10k *ar,
 	}
 
 out:
-	if (!ar->board_data || !ar->board_len) {
+	if (!ar->normal_mode_fw.board_data || !ar->normal_mode_fw.board_len) {
 		ath10k_err(ar,
 			   "failed to fetch board data for %s from %s/%s\n",
 			   boardname, ar->hw_params.fw.dir, filename);
@@ -978,7 +976,8 @@ success:
 	return 0;
 }
 
-static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
+static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
+					    struct ath10k_fw_file *fw_file)
 {
 	size_t magic_len, len, ie_len;
 	int ie_id, i, index, bit, ret;
@@ -987,15 +986,17 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 	__le32 *timestamp, *version;
 
 	/* first fetch the firmware file (firmware-*.bin) */
-	ar->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir, name);
-	if (IS_ERR(ar->firmware)) {
+	fw_file->firmware = ath10k_fetch_fw_file(ar, ar->hw_params.fw.dir,
+						 name);
+	if (IS_ERR(fw_file->firmware)) {
 		ath10k_err(ar, "could not fetch firmware file '%s/%s': %ld\n",
-			   ar->hw_params.fw.dir, name, PTR_ERR(ar->firmware));
-		return PTR_ERR(ar->firmware);
+			   ar->hw_params.fw.dir, name,
+			   PTR_ERR(fw_file->firmware));
+		return PTR_ERR(fw_file->firmware);
 	}
 
-	data = ar->firmware->data;
-	len = ar->firmware->size;
+	data = fw_file->firmware->data;
+	len = fw_file->firmware->size;
 
 	/* magic also includes the null byte, check that as well */
 	magic_len = strlen(ATH10K_FIRMWARE_MAGIC) + 1;
@@ -1086,8 +1087,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 				   "found fw image ie (%zd B)\n",
 				   ie_len);
 
-			ar->firmware_data = data;
-			ar->firmware_len = ie_len;
+			fw_file->firmware_data = data;
+			fw_file->firmware_len = ie_len;
 
 			break;
 		case ATH10K_FW_IE_OTP_IMAGE:
@@ -1095,8 +1096,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 				   "found otp image ie (%zd B)\n",
 				   ie_len);
 
-			ar->otp_data = data;
-			ar->otp_len = ie_len;
+			fw_file->otp_data = data;
+			fw_file->otp_len = ie_len;
 
 			break;
 		case ATH10K_FW_IE_WMI_OP_VERSION:
@@ -1125,8 +1126,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 			ath10k_dbg(ar, ATH10K_DBG_BOOT,
 				   "found fw code swap image ie (%zd B)\n",
 				   ie_len);
-			ar->swap.firmware_codeswap_data = data;
-			ar->swap.firmware_codeswap_len = ie_len;
+			fw_file->codeswap_data = data;
+			fw_file->codeswap_len = ie_len;
 			break;
 		default:
 			ath10k_warn(ar, "Unknown FW IE: %u\n",
@@ -1141,7 +1142,8 @@ static int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name)
 		data += ie_len;
 	}
 
-	if (!ar->firmware_data || !ar->firmware_len) {
+	if (!fw_file->firmware_data ||
+	    !fw_file->firmware_len) {
 		ath10k_warn(ar, "No ATH10K_FW_IE_FW_IMAGE found from '%s/%s', skipping\n",
 			    ar->hw_params.fw.dir, name);
 		ret = -ENOMEDIUM;
@@ -1165,28 +1167,32 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	ar->fw_api = 5;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API5_FILE);
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API5_FILE,
+					       &ar->normal_mode_fw.fw_file);
 	if (ret == 0)
 		goto success;
 
 	ar->fw_api = 4;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API4_FILE);
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API4_FILE,
+					       &ar->normal_mode_fw.fw_file);
 	if (ret == 0)
 		goto success;
 
 	ar->fw_api = 3;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API3_FILE);
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API3_FILE,
+					       &ar->normal_mode_fw.fw_file);
 	if (ret == 0)
 		goto success;
 
 	ar->fw_api = 2;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE);
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE,
+					       &ar->normal_mode_fw.fw_file);
 	if (ret)
 		return ret;
 
@@ -1585,7 +1591,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	return 0;
 }
 
-int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
+int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
+		      const struct ath10k_fw_components *fw)
 {
 	int status;
 	u32 val;
@@ -1594,6 +1601,8 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 
 	clear_bit(ATH10K_FLAG_CRASH_FLUSH, &ar->dev_flags);
 
+	ar->running_fw = fw;
+
 	ath10k_bmi_start(ar);
 
 	if (ath10k_init_configure_target(ar)) {
@@ -1621,7 +1630,7 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 		}
 	}
 
-	status = ath10k_download_fw(ar, mode);
+	status = ath10k_download_fw(ar);
 	if (status)
 		goto err;
 
@@ -1900,7 +1909,8 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	mutex_lock(&ar->conf_mutex);
 
-	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL,
+				&ar->normal_mode_fw);
 	if (ret) {
 		ath10k_err(ar, "could not init core (%d)\n", ret);
 		goto err_unlock;
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 2d0cc92f3c5b..ff3d92d7dc8d 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -627,6 +627,27 @@ enum ath10k_tx_pause_reason {
 	ATH10K_TX_PAUSE_MAX,
 };
 
+struct ath10k_fw_file {
+	const struct firmware *firmware;
+
+	const void *firmware_data;
+	size_t firmware_len;
+
+	const void *otp_data;
+	size_t otp_len;
+
+	const void *codeswap_data;
+	size_t codeswap_len;
+};
+
+struct ath10k_fw_components {
+	const struct firmware *board;
+	const void *board_data;
+	size_t board_len;
+
+	struct ath10k_fw_file fw_file;
+};
+
 struct ath10k {
 	struct ath_common ath_common;
 	struct ieee80211_hw *hw;
@@ -714,23 +735,17 @@ struct ath10k {
 		} fw;
 	} hw_params;
 
-	const struct firmware *board;
-	const void *board_data;
-	size_t board_len;
+	/* contains the firmware images used with ATH10K_FIRMWARE_MODE_NORMAL */
+	struct ath10k_fw_components normal_mode_fw;
 
-	const void *otp_data;
-	size_t otp_len;
-
-	const struct firmware *firmware;
-	const void *firmware_data;
-	size_t firmware_len;
+	/* READ-ONLY images of the running firmware, which can be either
+	 * normal or UTF. Do not modify, release etc! */
+	const struct ath10k_fw_components *running_fw;
 
 	const struct firmware *pre_cal_file;
 	const struct firmware *cal_file;
 
 	struct {
-		const void *firmware_codeswap_data;
-		size_t firmware_codeswap_len;
 		struct ath10k_swap_code_seg_info *firmware_swap_code_seg_info;
 	} swap;
 
@@ -876,13 +891,12 @@ struct ath10k {
 
 	struct {
 		/* protected by conf_mutex */
-		const struct firmware *utf;
+		struct ath10k_fw_components utf_mode_fw;
 		char utf_version[32];
-		const void *utf_firmware_data;
-		size_t utf_firmware_len;
 		DECLARE_BITMAP(orig_fw_features, ATH10K_FW_FEATURE_COUNT);
 		enum ath10k_fw_wmi_op_version orig_wmi_op_version;
 		enum ath10k_fw_wmi_op_version op_version;
+
 		/* protected by data_lock */
 		bool utf_monitor;
 	} testmode;
@@ -919,7 +933,8 @@ void ath10k_core_get_fw_features_str(struct ath10k *ar,
 				     char *buf,
 				     size_t max_len);
 
-int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode);
+int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
+		      const struct ath10k_fw_components *fw_components);
 int ath10k_wait_for_suspend(struct ath10k *ar, u32 suspend_opt);
 void ath10k_core_stop(struct ath10k *ar);
 int ath10k_core_register(struct ath10k *ar, u32 chip_id);
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 76bbe17b25b6..07b15ffce220 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -144,8 +144,10 @@ void ath10k_debug_print_hwfw_info(struct ath10k *ar)
 		    config_enabled(CONFIG_ATH10K_DFS_CERTIFIED),
 		    config_enabled(CONFIG_NL80211_TESTMODE));
 
-	if (ar->firmware)
-		crc = crc32_le(0, ar->firmware->data, ar->firmware->size);
+	/* FIXME: is this ok? */
+	if (ar->normal_mode_fw.fw_file.firmware)
+		crc = crc32_le(0, ar->normal_mode_fw.fw_file.firmware->data,
+			       ar->normal_mode_fw.fw_file.firmware->size);
 
 	ath10k_info(ar, "firmware ver %s api %d features %s crc32 %08x\n",
 		    ar->hw->wiphy->fw_version,
@@ -167,7 +169,8 @@ void ath10k_debug_print_board_info(struct ath10k *ar)
 	ath10k_info(ar, "board_file api %d bmi_id %s crc32 %08x",
 		    ar->bd_api,
 		    boardinfo,
-		    crc32_le(0, ar->board->data, ar->board->size));
+		    crc32_le(0, ar->normal_mode_fw.board->data,
+			     ar->normal_mode_fw.board->size));
 }
 
 void ath10k_debug_print_boot_info(struct ath10k *ar)
@@ -2266,23 +2269,28 @@ static ssize_t ath10k_debug_fw_checksums_read(struct file *file,
 
 	len += scnprintf(buf + len, buf_len - len,
 			 "firmware-N.bin\t\t%08x\n",
-			 crc32_le(0, ar->firmware->data, ar->firmware->size));
+			 crc32_le(0, ar->normal_mode_fw.fw_file.firmware->data,
+				  ar->normal_mode_fw.fw_file.firmware->size));
 	len += scnprintf(buf + len, buf_len - len,
 			 "athwlan\t\t\t%08x\n",
-			 crc32_le(0, ar->firmware_data, ar->firmware_len));
+			 crc32_le(0, ar->normal_mode_fw.fw_file.firmware_data,
+				  ar->normal_mode_fw.fw_file.firmware_len));
 	len += scnprintf(buf + len, buf_len - len,
 			 "otp\t\t\t%08x\n",
-			 crc32_le(0, ar->otp_data, ar->otp_len));
+			 crc32_le(0, ar->normal_mode_fw.fw_file.otp_data,
+				  ar->normal_mode_fw.fw_file.otp_len));
 	len += scnprintf(buf + len, buf_len - len,
 			 "codeswap\t\t%08x\n",
-			 crc32_le(0, ar->swap.firmware_codeswap_data,
-				  ar->swap.firmware_codeswap_len));
+			 crc32_le(0, ar->normal_mode_fw.fw_file.codeswap_data,
+				  ar->normal_mode_fw.fw_file.codeswap_len));
 	len += scnprintf(buf + len, buf_len - len,
 			 "board-N.bin\t\t%08x\n",
-			 crc32_le(0, ar->board->data, ar->board->size));
+			 crc32_le(0, ar->normal_mode_fw.board->data,
+				  ar->normal_mode_fw.board->size));
 	len += scnprintf(buf + len, buf_len - len,
 			 "board\t\t\t%08x\n",
-			 crc32_le(0, ar->board_data, ar->board_len));
+			 crc32_le(0, ar->normal_mode_fw.board_data,
+				  ar->normal_mode_fw.board_len));
 
 	ret_cnt = simple_read_from_buffer(user_buf, count, ppos, buf, len);
 
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 03d4d5ceddfa..d807f7e1828c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4356,7 +4356,8 @@ static int ath10k_start(struct ieee80211_hw *hw)
 		goto err_off;
 	}
 
-	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL);
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_NORMAL,
+				&ar->normal_mode_fw);
 	if (ret) {
 		ath10k_err(ar, "Could not init core: %d\n", ret);
 		goto err_power_down;
diff --git a/drivers/net/wireless/ath/ath10k/swap.c b/drivers/net/wireless/ath/ath10k/swap.c
index 3ca3fae408a7..8d6dc86799f5 100644
--- a/drivers/net/wireless/ath/ath10k/swap.c
+++ b/drivers/net/wireless/ath/ath10k/swap.c
@@ -171,8 +171,12 @@ int ath10k_swap_code_seg_configure(struct ath10k *ar,
 void ath10k_swap_code_seg_release(struct ath10k *ar)
 {
 	ath10k_swap_code_seg_free(ar, ar->swap.firmware_swap_code_seg_info);
-	ar->swap.firmware_codeswap_data = NULL;
-	ar->swap.firmware_codeswap_len = 0;
+
+	/* FIXME: these two assignments look to bein wrong place! Shouldn't
+	 * they be in ath10k_core_free_firmware_files() like the rest? */
+	ar->normal_mode_fw.fw_file.codeswap_data = NULL;
+	ar->normal_mode_fw.fw_file.codeswap_len = 0;
+
 	ar->swap.firmware_swap_code_seg_info = NULL;
 }
 
@@ -180,20 +184,23 @@ int ath10k_swap_code_seg_init(struct ath10k *ar)
 {
 	int ret;
 	struct ath10k_swap_code_seg_info *seg_info;
+	const void *codeswap_data;
+	size_t codeswap_len;
+
+	codeswap_data = ar->normal_mode_fw.fw_file.codeswap_data;
+	codeswap_len = ar->normal_mode_fw.fw_file.codeswap_len;
 
-	if (!ar->swap.firmware_codeswap_len || !ar->swap.firmware_codeswap_data)
+	if (!codeswap_len || !codeswap_data)
 		return 0;
 
-	seg_info = ath10k_swap_code_seg_alloc(ar,
-					      ar->swap.firmware_codeswap_len);
+	seg_info = ath10k_swap_code_seg_alloc(ar, codeswap_len);
 	if (!seg_info) {
 		ath10k_err(ar, "failed to allocate fw code swap segment\n");
 		return -ENOMEM;
 	}
 
 	ret = ath10k_swap_code_seg_fill(ar, seg_info,
-					ar->swap.firmware_codeswap_data,
-					ar->swap.firmware_codeswap_len);
+					codeswap_data, codeswap_len);
 
 	if (ret) {
 		ath10k_warn(ar, "failed to initialize fw code swap segment: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 1d5a2fdcbf56..e80aa4eeed05 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -139,7 +139,8 @@ static int ath10k_tm_cmd_get_version(struct ath10k *ar, struct nlattr *tb[])
 	return cfg80211_testmode_reply(skb);
 }
 
-static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
+static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar,
+					      struct ath10k_fw_file *fw_file)
 {
 	size_t len, magic_len, ie_len;
 	struct ath10k_fw_ie *hdr;
@@ -152,15 +153,15 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
 		 ar->hw_params.fw.dir, ATH10K_FW_UTF_API2_FILE);
 
 	/* load utf firmware image */
-	ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
+	ret = request_firmware(&fw_file->firmware, filename, ar->dev);
 	if (ret) {
 		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
 			    filename, ret);
 		return ret;
 	}
 
-	data = ar->testmode.utf->data;
-	len = ar->testmode.utf->size;
+	data = fw_file->firmware->data;
+	len = fw_file->firmware->size;
 
 	/* FIXME: call release_firmware() in error cases */
 
@@ -222,8 +223,8 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
 				   "testmode found fw image ie (%zd B)\n",
 				   ie_len);
 
-			ar->testmode.utf_firmware_data = data;
-			ar->testmode.utf_firmware_len = ie_len;
+			fw_file->firmware_data = data;
+			fw_file->firmware_len = ie_len;
 			break;
 		case ATH10K_FW_IE_WMI_OP_VERSION:
 			if (ie_len != sizeof(u32))
@@ -245,7 +246,7 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
 		data += ie_len;
 	}
 
-	if (!ar->testmode.utf_firmware_data || !ar->testmode.utf_firmware_len) {
+	if (!fw_file->firmware_data || !fw_file->firmware_len) {
 		ath10k_err(ar, "No ATH10K_FW_IE_FW_IMAGE found\n");
 		ret = -EINVAL;
 		goto err;
@@ -254,12 +255,13 @@ static int ath10k_tm_fetch_utf_firmware_api_2(struct ath10k *ar)
 	return 0;
 
 err:
-	release_firmware(ar->testmode.utf);
+	release_firmware(fw_file->firmware);
 
 	return ret;
 }
 
-static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar)
+static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
+					      struct ath10k_fw_file *fw_file)
 {
 	char filename[100];
 	int ret;
@@ -268,7 +270,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar)
 		 ar->hw_params.fw.dir, ATH10K_FW_UTF_FILE);
 
 	/* load utf firmware image */
-	ret = request_firmware(&ar->testmode.utf, filename, ar->dev);
+	ret = request_firmware(&fw_file->firmware, filename, ar->dev);
 	if (ret) {
 		ath10k_warn(ar, "failed to retrieve utf firmware '%s': %d\n",
 			    filename, ret);
@@ -282,8 +284,8 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar)
 	 */
 
 	ar->testmode.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
-	ar->testmode.utf_firmware_data = ar->testmode.utf->data;
-	ar->testmode.utf_firmware_len = ar->testmode.utf->size;
+	fw_file->firmware_data = fw_file->firmware->data;
+	fw_file->firmware_len = fw_file->firmware->size;
 
 	return 0;
 }
@@ -292,13 +294,13 @@ static int ath10k_tm_fetch_firmware(struct ath10k *ar)
 {
 	int ret;
 
-	ret = ath10k_tm_fetch_utf_firmware_api_2(ar);
+	ret = ath10k_tm_fetch_utf_firmware_api_2(ar, &ar->testmode.utf_mode_fw.fw_file);
 	if (ret == 0) {
 		ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode using fw utf api 2");
-		return 0;
+		goto out;
 	}
 
-	ret = ath10k_tm_fetch_utf_firmware_api_1(ar);
+	ret = ath10k_tm_fetch_utf_firmware_api_1(ar, &ar->testmode.utf_mode_fw.fw_file);
 	if (ret) {
 		ath10k_err(ar, "failed to fetch utf firmware binary: %d", ret);
 		return ret;
@@ -306,6 +308,18 @@ static int ath10k_tm_fetch_firmware(struct ath10k *ar)
 
 	ath10k_dbg(ar, ATH10K_DBG_TESTMODE, "testmode using utf api 1");
 
+out:
+	/* use the same board data file as the normal firmware uses (but
+	 * it's still "owned" by normal_mode_fw so we shouldn't free it */
+	ar->testmode.utf_mode_fw.board_data = ar->normal_mode_fw.board_data;
+	ar->testmode.utf_mode_fw.board_len = ar->normal_mode_fw.board_len;
+
+	if (!ar->testmode.utf_mode_fw.fw_file.otp_data) {
+		ath10k_info(ar, "utf.bin didn't contain otp binary, taking it from the normal mode firmware");
+		ar->testmode.utf_mode_fw.fw_file.otp_data = ar->normal_mode_fw.fw_file.otp_data;
+		ar->testmode.utf_mode_fw.fw_file.otp_len = ar->normal_mode_fw.fw_file.otp_len;
+	}
+
 	return 0;
 }
 
@@ -329,7 +343,7 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 		goto err;
 	}
 
-	if (WARN_ON(ar->testmode.utf != NULL)) {
+	if (WARN_ON(ar->testmode.utf_mode_fw.fw_file.firmware != NULL)) {
 		/* utf image is already downloaded, it shouldn't be */
 		ret = -EEXIST;
 		goto err;
@@ -364,7 +378,8 @@ static int ath10k_tm_cmd_utf_start(struct ath10k *ar, struct nlattr *tb[])
 		goto err_fw_features;
 	}
 
-	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF);
+	ret = ath10k_core_start(ar, ATH10K_FIRMWARE_MODE_UTF,
+				&ar->testmode.utf_mode_fw);
 	if (ret) {
 		ath10k_err(ar, "failed to start core (testmode): %d\n", ret);
 		ar->state = ATH10K_STATE_OFF;
@@ -393,8 +408,8 @@ err_fw_features:
 	       sizeof(ar->fw_features));
 	ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
 
-	release_firmware(ar->testmode.utf);
-	ar->testmode.utf = NULL;
+	release_firmware(ar->testmode.utf_mode_fw.fw_file.firmware);
+	ar->testmode.utf_mode_fw.fw_file.firmware = NULL;
 
 err:
 	mutex_unlock(&ar->conf_mutex);
@@ -420,8 +435,8 @@ static void __ath10k_tm_cmd_utf_stop(struct ath10k *ar)
 	       sizeof(ar->fw_features));
 	ar->wmi.op_version = ar->testmode.orig_wmi_op_version;
 
-	release_firmware(ar->testmode.utf);
-	ar->testmode.utf = NULL;
+	release_firmware(ar->testmode.utf_mode_fw.fw_file.firmware);
+	ar->testmode.utf_mode_fw.fw_file.firmware = NULL;
 
 	ar->state = ATH10K_STATE_OFF;
 }

