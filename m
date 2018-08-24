Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45990 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbeHXRru (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 13:47:50 -0400
From: Sathishkumar Muruganandam <murugana@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Sathishkumar Muruganandam <murugana@codeaurora.org>
Subject: [PATCH 1/2] ath10k: Support extended board data download for dual-band QCA9984
Date: Fri, 24 Aug 2018 19:42:20 +0530
Message-Id: <20180824141221.3661-1-murugana@codeaurora.org> (sfid-20180824_161315_919692_E38FBE57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just moving functions down in the file, no functional changes.

Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 402 ++++++++++++-------------
 1 file changed, 201 insertions(+), 201 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index c40cd129afe7..28c2fecc0a56 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -762,149 +762,6 @@ static int ath10k_push_board_ext_data(struct ath10k *ar, const void *data,
 	return 0;
 }
 
-static int ath10k_download_board_data(struct ath10k *ar, const void *data,
-				      size_t data_len)
-{
-	u32 board_data_size = ar->hw_params.fw.board_size;
-	u32 address;
-	int ret;
-
-	ret = ath10k_push_board_ext_data(ar, data, data_len);
-	if (ret) {
-		ath10k_err(ar, "could not push board ext data (%d)\n", ret);
-		goto exit;
-	}
-
-	ret = ath10k_bmi_read32(ar, hi_board_data, &address);
-	if (ret) {
-		ath10k_err(ar, "could not read board data addr (%d)\n", ret);
-		goto exit;
-	}
-
-	ret = ath10k_bmi_write_memory(ar, address, data,
-				      min_t(u32, board_data_size,
-					    data_len));
-	if (ret) {
-		ath10k_err(ar, "could not write board data (%d)\n", ret);
-		goto exit;
-	}
-
-	ret = ath10k_bmi_write32(ar, hi_board_data_initialized, 1);
-	if (ret) {
-		ath10k_err(ar, "could not write board data bit (%d)\n", ret);
-		goto exit;
-	}
-
-exit:
-	return ret;
-}
-
-static int ath10k_download_cal_file(struct ath10k *ar,
-				    const struct firmware *file)
-{
-	int ret;
-
-	if (!file)
-		return -ENOENT;
-
-	if (IS_ERR(file))
-		return PTR_ERR(file);
-
-	ret = ath10k_download_board_data(ar, file->data, file->size);
-	if (ret) {
-		ath10k_err(ar, "failed to download cal_file data: %d\n", ret);
-		return ret;
-	}
-
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cal file downloaded\n");
-
-	return 0;
-}
-
-static int ath10k_download_cal_dt(struct ath10k *ar, const char *dt_name)
-{
-	struct device_node *node;
-	int data_len;
-	void *data;
-	int ret;
-
-	node = ar->dev->of_node;
-	if (!node)
-		/* Device Tree is optional, don't print any warnings if
-		 * there's no node for ath10k.
-		 */
-		return -ENOENT;
-
-	if (!of_get_property(node, dt_name, &data_len)) {
-		/* The calibration data node is optional */
-		return -ENOENT;
-	}
-
-	if (data_len != ar->hw_params.cal_data_len) {
-		ath10k_warn(ar, "invalid calibration data length in DT: %d\n",
-			    data_len);
-		ret = -EMSGSIZE;
-		goto out;
-	}
-
-	data = kmalloc(data_len, GFP_KERNEL);
-	if (!data) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = of_property_read_u8_array(node, dt_name, data, data_len);
-	if (ret) {
-		ath10k_warn(ar, "failed to read calibration data from DT: %d\n",
-			    ret);
-		goto out_free;
-	}
-
-	ret = ath10k_download_board_data(ar, data, data_len);
-	if (ret) {
-		ath10k_warn(ar, "failed to download calibration data from Device Tree: %d\n",
-			    ret);
-		goto out_free;
-	}
-
-	ret = 0;
-
-out_free:
-	kfree(data);
-
-out:
-	return ret;
-}
-
-static int ath10k_download_cal_eeprom(struct ath10k *ar)
-{
-	size_t data_len;
-	void *data = NULL;
-	int ret;
-
-	ret = ath10k_hif_fetch_cal_eeprom(ar, &data, &data_len);
-	if (ret) {
-		if (ret != -EOPNOTSUPP)
-			ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
-				    ret);
-		goto out_free;
-	}
-
-	ret = ath10k_download_board_data(ar, data, data_len);
-	if (ret) {
-		ath10k_warn(ar, "failed to download calibration data from EEPROM: %d\n",
-			    ret);
-		goto out_free;
-	}
-
-	ret = 0;
-
-out_free:
-	kfree(data);
-
-	return ret;
-}
-
 static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 {
 	u32 result, address;
@@ -1055,64 +912,6 @@ static int ath10k_core_check_dt(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_download_and_run_otp(struct ath10k *ar)
-{
-	u32 result, address = ar->hw_params.patch_load_addr;
-	u32 bmi_otp_exe_param = ar->hw_params.otp_exe_param;
-	int ret;
-
-	ret = ath10k_download_board_data(ar,
-					 ar->running_fw->board_data,
-					 ar->running_fw->board_len);
-	if (ret) {
-		ath10k_err(ar, "failed to download board data: %d\n", ret);
-		return ret;
-	}
-
-	/* OTP is optional */
-
-	if (!ar->running_fw->fw_file.otp_data ||
-	    !ar->running_fw->fw_file.otp_len) {
-		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %pK otp_len %zd)!\n",
-			    ar->running_fw->fw_file.otp_data,
-			    ar->running_fw->fw_file.otp_len);
-		return 0;
-	}
-
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
-		   address, ar->running_fw->fw_file.otp_len);
-
-	ret = ath10k_bmi_fast_download(ar, address,
-				       ar->running_fw->fw_file.otp_data,
-				       ar->running_fw->fw_file.otp_len);
-	if (ret) {
-		ath10k_err(ar, "could not write otp (%d)\n", ret);
-		return ret;
-	}
-
-	/* As of now pre-cal is valid for 10_4 variants */
-	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
-	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
-		bmi_otp_exe_param = BMI_PARAM_FLASH_SECTION_ALL;
-
-	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
-	if (ret) {
-		ath10k_err(ar, "could not execute otp (%d)\n", ret);
-		return ret;
-	}
-
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
-
-	if (!(skip_otp || test_bit(ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
-				   ar->running_fw->fw_file.fw_features)) &&
-	    result != 0) {
-		ath10k_err(ar, "otp calibration failed: %d", result);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int ath10k_download_fw(struct ath10k *ar)
 {
 	u32 address, data_len;
@@ -1490,6 +1289,207 @@ static int ath10k_core_fetch_board_file(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_download_board_data(struct ath10k *ar, const void *data,
+				      size_t data_len)
+{
+	u32 board_data_size = ar->hw_params.fw.board_size;
+	u32 address;
+	int ret;
+
+	ret = ath10k_push_board_ext_data(ar, data, data_len);
+	if (ret) {
+		ath10k_err(ar, "could not push board ext data (%d)\n", ret);
+		goto exit;
+	}
+
+	ret = ath10k_bmi_read32(ar, hi_board_data, &address);
+	if (ret) {
+		ath10k_err(ar, "could not read board data addr (%d)\n", ret);
+		goto exit;
+	}
+
+	ret = ath10k_bmi_write_memory(ar, address, data,
+				      min_t(u32, board_data_size,
+					    data_len));
+	if (ret) {
+		ath10k_err(ar, "could not write board data (%d)\n", ret);
+		goto exit;
+	}
+
+	ret = ath10k_bmi_write32(ar, hi_board_data_initialized, 1);
+	if (ret) {
+		ath10k_err(ar, "could not write board data bit (%d)\n", ret);
+		goto exit;
+	}
+
+exit:
+	return ret;
+}
+
+static int ath10k_download_and_run_otp(struct ath10k *ar)
+{
+	u32 result, address = ar->hw_params.patch_load_addr;
+	u32 bmi_otp_exe_param = ar->hw_params.otp_exe_param;
+	int ret;
+
+	ret = ath10k_download_board_data(ar,
+					 ar->running_fw->board_data,
+					 ar->running_fw->board_len);
+	if (ret) {
+		ath10k_err(ar, "failed to download board data: %d\n", ret);
+		return ret;
+	}
+
+	/* OTP is optional */
+
+	if (!ar->running_fw->fw_file.otp_data ||
+	    !ar->running_fw->fw_file.otp_len) {
+		ath10k_warn(ar, "Not running otp, calibration will be incorrect (otp-data %pK otp_len %zd)!\n",
+			    ar->running_fw->fw_file.otp_data,
+			    ar->running_fw->fw_file.otp_len);
+		return 0;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot upload otp to 0x%x len %zd\n",
+		   address, ar->running_fw->fw_file.otp_len);
+
+	ret = ath10k_bmi_fast_download(ar, address,
+				       ar->running_fw->fw_file.otp_data,
+				       ar->running_fw->fw_file.otp_len);
+	if (ret) {
+		ath10k_err(ar, "could not write otp (%d)\n", ret);
+		return ret;
+	}
+
+	/* As of now pre-cal is valid for 10_4 variants */
+	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+		bmi_otp_exe_param = BMI_PARAM_FLASH_SECTION_ALL;
+
+	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
+	if (ret) {
+		ath10k_err(ar, "could not execute otp (%d)\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot otp execute result %d\n", result);
+
+	if (!(skip_otp || test_bit(ATH10K_FW_FEATURE_IGNORE_OTP_RESULT,
+				   ar->running_fw->fw_file.fw_features)) &&
+	    result != 0) {
+		ath10k_err(ar, "otp calibration failed: %d", result);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int ath10k_download_cal_file(struct ath10k *ar,
+				    const struct firmware *file)
+{
+	int ret;
+
+	if (!file)
+		return -ENOENT;
+
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = ath10k_download_board_data(ar, file->data, file->size);
+	if (ret) {
+		ath10k_err(ar, "failed to download cal_file data: %d\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot cal file downloaded\n");
+
+	return 0;
+}
+
+static int ath10k_download_cal_dt(struct ath10k *ar, const char *dt_name)
+{
+	struct device_node *node;
+	int data_len;
+	void *data;
+	int ret;
+
+	node = ar->dev->of_node;
+	if (!node)
+		/* Device Tree is optional, don't print any warnings if
+		 * there's no node for ath10k.
+		 */
+		return -ENOENT;
+
+	if (!of_get_property(node, dt_name, &data_len)) {
+		/* The calibration data node is optional */
+		return -ENOENT;
+	}
+
+	if (data_len != ar->hw_params.cal_data_len) {
+		ath10k_warn(ar, "invalid calibration data length in DT: %d\n",
+			    data_len);
+		ret = -EMSGSIZE;
+		goto out;
+	}
+
+	data = kmalloc(data_len, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = of_property_read_u8_array(node, dt_name, data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to read calibration data from DT: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = ath10k_download_board_data(ar, data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to download calibration data from Device Tree: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = 0;
+
+out_free:
+	kfree(data);
+
+out:
+	return ret;
+}
+
+static int ath10k_download_cal_eeprom(struct ath10k *ar)
+{
+	size_t data_len;
+	void *data = NULL;
+	int ret;
+
+	ret = ath10k_hif_fetch_cal_eeprom(ar, &data, &data_len);
+	if (ret) {
+		if (ret != -EOPNOTSUPP)
+			ath10k_warn(ar, "failed to read calibration data from EEPROM: %d\n",
+				    ret);
+		goto out_free;
+	}
+
+	ret = ath10k_download_board_data(ar, data, data_len);
+	if (ret) {
+		ath10k_warn(ar, "failed to download calibration data from EEPROM: %d\n",
+			    ret);
+		goto out_free;
+	}
+
+	ret = 0;
+
+out_free:
+	kfree(data);
+
+	return ret;
+}
+
 int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 				     struct ath10k_fw_file *fw_file)
 {
-- 
2.17.1
