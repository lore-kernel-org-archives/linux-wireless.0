Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54353 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbcCJKNp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 05:13:45 -0500
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 3/3] ath10k: incorporate qca4019 cal data download sequence
Date: Thu, 10 Mar 2016 15:42:38 +0530
Message-ID: <1457604758-14454-4-git-send-email-rmani@qti.qualcomm.com> (sfid-20160310_111354_936312_B3D4BF25)
In-Reply-To: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com>
References: <1457604758-14454-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

qca4019 calibration data is stored in the host memory and it's mandatory
to download it even before reading board id and chip id from the target.
Also, there is a need to execute otp (download and run) twice, one after
cal data download and another one after board data download.

Existing cal data file name 'cal-<bus>-<id>.bin' and device tree entry
'qcom,ath10k-calibration-data' used in ath10k has assumption that it
carries other data (like board data) also along with the calibration data.
But, qca4019 cal data contains pure calibration data (doesn't include
any other info). So, using existing same cal file name and DT entry
in qca4019 case would alter the purpose of it. To avoid this, new cal
file name 'pre-cal-<bus>-<id>.bin' and new device tree entry name
'qcom,ath10k-pre-calibration-data are introduced.

Overall qca4019's firmware download sequence would look like,

   1) Download cal data (either from a file or device tree entry)
      at the address specified by target in the host interest area
      member "hi_board_data".

   2) Download otp and run with 0x10 (PARAM_GET_EEPROM_BOARD_ID)
      as a argument.

      At this point, otp will take back up of downloaded cal data
      content in another location in the target and return valid
      board id and chip id to the host.

   3) Download board data at the address specified by target
      in host interest area member "hi_board_data".

   4) Download otp and run with 0x10000 (PARAM_FLASH_SECTION_ALL) as
      a argument.

      Now otp will apply cal data content from it's backup on top
      of board data download in step 3 and prepare final data base.

   5) Download code swap and athwlan binary content.

Above sequences are implemented (step 1 to step 4) in the name of
pre calibration configuration.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 85 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/core.h | 11 ++++-
 2 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2a901c6..3d05929 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -729,6 +729,14 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 {
 	char filename[100];
 
+	/* pre-cal-<bus>-<id>.bin */
+	scnprintf(filename, sizeof(filename), "pre-cal-%s-%s.bin",
+		  ath10k_bus_str(ar->hif.bus), dev_name(ar->dev));
+
+	ar->pre_cal_file = ath10k_fetch_fw_file(ar, ATH10K_FW_DIR, filename);
+	if (!IS_ERR(ar->pre_cal_file))
+		goto success;
+
 	/* cal-<bus>-<id>.bin */
 	scnprintf(filename, sizeof(filename), "cal-%s-%s.bin",
 		  ath10k_bus_str(ar->hif.bus), dev_name(ar->dev));
@@ -737,7 +745,7 @@ static int ath10k_fetch_cal_file(struct ath10k *ar)
 	if (IS_ERR(ar->cal_file))
 		/* calibration file is optional, don't print any warnings */
 		return PTR_ERR(ar->cal_file);
-
+success:
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "found calibration file %s/%s\n",
 		   ATH10K_FW_DIR, filename);
 
@@ -1261,10 +1269,76 @@ success:
 	return 0;
 }
 
+static int ath10k_core_pre_cal_download(struct ath10k *ar)
+{
+	int ret;
+
+	ret = ath10k_download_cal_file(ar, ar->pre_cal_file);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_PRE_CAL_MODE_FILE;
+		goto success;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find a pre calibration file, try DT next: %d\n",
+		   ret);
+
+	ret = ath10k_download_cal_dt(ar, "qcom,ath10k-pre-calibration-data");
+	if (ret) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "unable to load pre cal data from DT: %d\n", ret);
+		return ret;
+	}
+	ar->cal_mode = ATH10K_PRE_CAL_MODE_DT;
+
+success:
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using calibration mode %s\n",
+		   ath10k_cal_mode_str(ar->cal_mode));
+
+	return 0;
+}
+
+static int ath10k_core_pre_cal_config(struct ath10k *ar)
+{
+	int ret;
+
+	ret = ath10k_core_pre_cal_download(ar);
+	if (ret) {
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "failed to load pre cal data: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_core_get_board_id_from_otp(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to get board id: %d\n", ret);
+		return ret;
+	}
+
+	ret = ath10k_download_and_run_otp(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to run otp: %d\n", ret);
+		return ret;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "pre cal configuration done successfully\n");
+
+	return 0;
+}
+
 static int ath10k_download_cal_data(struct ath10k *ar)
 {
 	int ret;
 
+	ret = ath10k_core_pre_cal_config(ar);
+	if (ret == 0)
+		return 0;
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "pre cal download procedure failed, try cal file: %d\n",
+		   ret);
+
 	ret = ath10k_download_cal_file(ar, ar->cal_file);
 	if (ret == 0) {
 		ar->cal_mode = ATH10K_CAL_MODE_FILE;
@@ -1842,6 +1916,15 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ath10k_debug_print_hwfw_info(ar);
 
+	ret = ath10k_core_pre_cal_download(ar);
+	if (ret) {
+		/* pre calibration data download is not necessary
+		 * for all the chipsets. Ignore failures and continue.
+		 */
+		ath10k_dbg(ar, ATH10K_DBG_BOOT,
+			   "could not load pre cal data: %d\n", ret);
+	}
+
 	ret = ath10k_core_get_board_id_from_otp(ar);
 	if (ret && ret != -EOPNOTSUPP) {
 		ath10k_err(ar, "failed to get board id from otp: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 322a9eb..d9481ea 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -567,6 +567,8 @@ enum ath10k_cal_mode {
 	ATH10K_CAL_MODE_FILE,
 	ATH10K_CAL_MODE_OTP,
 	ATH10K_CAL_MODE_DT,
+	ATH10K_PRE_CAL_MODE_FILE,
+	ATH10K_PRE_CAL_MODE_DT,
 };
 
 enum ath10k_crypt_mode {
@@ -585,6 +587,10 @@ static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
 		return "otp";
 	case ATH10K_CAL_MODE_DT:
 		return "dt";
+	case ATH10K_PRE_CAL_MODE_FILE:
+		return "pre-cal-file";
+	case ATH10K_PRE_CAL_MODE_DT:
+		return "pre-cal-dt";
 	}
 
 	return "unknown";
@@ -719,7 +725,10 @@ struct ath10k {
 	const void *firmware_data;
 	size_t firmware_len;
 
-	const struct firmware *cal_file;
+	union {
+		const struct firmware *pre_cal_file;
+		const struct firmware *cal_file;
+	};
 
 	struct {
 		const void *firmware_codeswap_data;
-- 
1.8.1.2

