Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59784 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824AbaJMGlC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Oct 2014 02:41:02 -0400
Subject: [PATCH 3/3] ath10k: retrieve calibration data from file
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 13 Oct 2014 09:40:59 +0300
Message-ID: <20141013064059.30315.54101.stgit@potku.adurom.net> (sfid-20141013_084109_571581_150107D5)
In-Reply-To: <20141013063929.30315.41969.stgit@potku.adurom.net>
References: <20141013063929.30315.41969.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A frequent request have been to be able to provide calibration data from a
file as some of the AP devices store the calibration data on an MTD partition.
This patchset adds support for that and also makes it easier to add Device Tree
support later on.

The calibration data is found by using the id string provided by dev_name()
using this format:

cal-<bus>-<id>.bin

With PCI the id string contains bus, slot and func values. For example for a
PCI device in bus 2 slot 0, ath10k will try to retrieve a calibration data from
a file:

/lib/firmware/ath10k/cal-pci-0000:02:00.0.bin

The calibration data sequence is:

1. Check with request_firmware() if there's a calibration file
   ("cal-<bus>-<id>.bin") on the filesystem for this device. If yes, use that. If
   not, goto 2

2. Check if otp.bin is able to successfully load the calibration data
   from OTP. If yes, use that. If not, goto 3.

4. Print an error message that no calibration data found and stop driver
   initialization for this device.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c  |   86 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/core.h  |   20 +++++++
 drivers/net/wireless/ath/ath10k/debug.c |    5 +-
 drivers/net/wireless/ath/ath10k/hw.h    |    4 +
 4 files changed, 102 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index d0b67a7512cf..5c23d00f7d60 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -138,7 +138,8 @@ static const struct firmware *ath10k_fetch_fw_file(struct ath10k *ar,
 	return fw;
 }
 
-static int ath10k_push_board_ext_data(struct ath10k *ar)
+static int ath10k_push_board_ext_data(struct ath10k *ar, const void *data,
+				      size_t data_len)
 {
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 board_ext_data_size = QCA988X_BOARD_EXT_DATA_SZ;
@@ -159,14 +160,14 @@ static int ath10k_push_board_ext_data(struct ath10k *ar)
 	if (board_ext_data_addr == 0)
 		return 0;
 
-	if (ar->board_len != (board_data_size + board_ext_data_size)) {
+	if (data_len != (board_data_size + board_ext_data_size)) {
 		ath10k_err(ar, "invalid board (ext) data sizes %zu != %d+%d\n",
-			   ar->board_len, board_data_size, board_ext_data_size);
+			   data_len, board_data_size, board_ext_data_size);
 		return -EINVAL;
 	}
 
 	ret = ath10k_bmi_write_memory(ar, board_ext_data_addr,
-				      ar->board_data + board_data_size,
+				      data + board_data_size,
 				      board_ext_data_size);
 	if (ret) {
 		ath10k_err(ar, "could not write board ext data (%d)\n", ret);
@@ -184,13 +185,14 @@ static int ath10k_push_board_ext_data(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_download_board_data(struct ath10k *ar)
+static int ath10k_download_board_data(struct ath10k *ar, const void *data,
+				      size_t data_len)
 {
 	u32 board_data_size = QCA988X_BOARD_DATA_SZ;
 	u32 address;
 	int ret;
 
-	ret = ath10k_push_board_ext_data(ar);
+	ret = ath10k_push_board_ext_data(ar, data, data_len);
 	if (ret) {
 		ath10k_err(ar, "could not push board ext data (%d)\n", ret);
 		goto exit;
@@ -202,9 +204,9 @@ static int ath10k_download_board_data(struct ath10k *ar)
 		goto exit;
 	}
 
-	ret = ath10k_bmi_write_memory(ar, address, ar->board_data,
+	ret = ath10k_bmi_write_memory(ar, address, data,
 				      min_t(u32, board_data_size,
-					    ar->board_len));
+					    data_len));
 	if (ret) {
 		ath10k_err(ar, "could not write board data (%d)\n", ret);
 		goto exit;
@@ -220,12 +222,34 @@ exit:
 	return ret;
 }
 
+static int ath10k_download_cal_file(struct ath10k *ar)
+{
+	int ret;
+
+	if (!ar->cal_file)
+		return -ENOENT;
+
+	if (IS_ERR(ar->cal_file))
+		return PTR_ERR(ar->cal_file);
+
+	ret = ath10k_download_board_data(ar, ar->cal_file->data,
+					 ar->cal_file->size);
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
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
 	int ret;
 
-	ret = ath10k_download_board_data(ar);
+	ret = ath10k_download_board_data(ar, ar->board_data, ar->board_len);
 	if (ret) {
 		ath10k_err(ar, "failed to download board data: %d\n", ret);
 		return ret;
@@ -314,6 +338,9 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	if (ar->firmware && !IS_ERR(ar->firmware))
 		release_firmware(ar->firmware);
 
+	if (ar->cal_file && !IS_ERR(ar->cal_file))
+		release_firmware(ar->cal_file);
+
 	ar->board = NULL;
 	ar->board_data = NULL;
 	ar->board_len = 0;
@@ -325,6 +352,27 @@ static void ath10k_core_free_firmware_files(struct ath10k *ar)
 	ar->firmware = NULL;
 	ar->firmware_data = NULL;
 	ar->firmware_len = 0;
+
+	ar->cal_file = NULL;
+}
+
+static int ath10k_fetch_cal_file(struct ath10k *ar)
+{
+	char filename[100];
+
+	/* cal-<bus>-<id>.bin */
+	scnprintf(filename, sizeof(filename), "cal-%s-%s.bin",
+		  ath10k_bus_str(ar->hif.bus), dev_name(ar->dev));
+
+	ar->cal_file = ath10k_fetch_fw_file(ar, ATH10K_FW_DIR, filename);
+	if (IS_ERR(ar->cal_file))
+		/* calibration file is optional, don't print any warnings */
+		return PTR_ERR(ar->cal_file);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "found calibration file %s/%s\n",
+		   ATH10K_FW_DIR, filename);
+
+	return 0;
 }
 
 static int ath10k_core_fetch_firmware_api_1(struct ath10k *ar)
@@ -568,6 +616,9 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 {
 	int ret;
 
+	/* calibration file is optional, don't check for any errors */
+	ath10k_fetch_cal_file(ar);
+
 	ar->fw_api = 3;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
@@ -599,13 +650,28 @@ static int ath10k_download_cal_data(struct ath10k *ar)
 {
 	int ret;
 
+	ret = ath10k_download_cal_file(ar);
+	if (ret == 0) {
+		ar->cal_mode = ATH10K_CAL_MODE_FILE;
+		goto done;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot did not find a calibration file, try OTP next: %d\n",
+		   ret);
+
 	ret = ath10k_download_and_run_otp(ar);
 	if (ret) {
 		ath10k_err(ar, "failed to run otp: %d\n", ret);
 		return ret;
 	}
 
-	return ret;
+	ar->cal_mode = ATH10K_CAL_MODE_OTP;
+
+done:
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using calibration mode %s\n",
+		   ath10k_cal_mode_str(ar->cal_mode));
+	return 0;
 }
 
 static int ath10k_init_uart(struct ath10k *ar)
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 770b0bcc3e69..2c286e73dbf7 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -387,6 +387,23 @@ enum ath10k_dev_flags {
 	ATH10K_FLAG_CORE_REGISTERED,
 };
 
+enum ath10k_cal_mode {
+	ATH10K_CAL_MODE_FILE,
+	ATH10K_CAL_MODE_OTP,
+};
+
+static inline const char *ath10k_cal_mode_str(enum ath10k_cal_mode mode)
+{
+	switch (mode) {
+	case ATH10K_CAL_MODE_FILE:
+		return "file";
+	case ATH10K_CAL_MODE_OTP:
+		return "otp";
+	}
+
+	return "unknown";
+}
+
 enum ath10k_scan_state {
 	ATH10K_SCAN_IDLE,
 	ATH10K_SCAN_STARTING,
@@ -473,7 +490,10 @@ struct ath10k {
 	const void *firmware_data;
 	size_t firmware_len;
 
+	const struct firmware *cal_file;
+
 	int fw_api;
+	enum ath10k_cal_mode cal_mode;
 
 	struct {
 		struct completion started;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 0d94febbb360..9147dd36dcdd 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -124,7 +124,7 @@ EXPORT_SYMBOL(ath10k_info);
 
 void ath10k_print_driver_info(struct ath10k *ar)
 {
-	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d\n",
+	ath10k_info(ar, "%s (0x%08x, 0x%08x) fw %s api %d htt %d.%d wmi %d.%d.%d.%d cal %s\n",
 		    ar->hw_params.name,
 		    ar->target_version,
 		    ar->chip_id,
@@ -135,7 +135,8 @@ void ath10k_print_driver_info(struct ath10k *ar)
 		    ar->fw_version_major,
 		    ar->fw_version_minor,
 		    ar->fw_version_release,
-		    ar->fw_version_build);
+		    ar->fw_version_build,
+		    ath10k_cal_mode_str(ar->cal_mode));
 	ath10k_info(ar, "debug %d debugfs %d tracing %d dfs %d testmode %d\n",
 		    config_enabled(CONFIG_ATH10K_DEBUG),
 		    config_enabled(CONFIG_ATH10K_DEBUGFS),
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 5dd6551801d5..ef09fe8cb4b2 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -20,13 +20,15 @@
 
 #include "targaddrs.h"
 
+#define ATH10K_FW_DIR			"ath10k"
+
 /* QCA988X 1.0 definitions (unsupported) */
 #define QCA988X_HW_1_0_CHIP_ID_REV	0x0
 
 /* QCA988X 2.0 definitions */
 #define QCA988X_HW_2_0_VERSION		0x4100016c
 #define QCA988X_HW_2_0_CHIP_ID_REV	0x2
-#define QCA988X_HW_2_0_FW_DIR		"ath10k/QCA988X/hw2.0"
+#define QCA988X_HW_2_0_FW_DIR		ATH10K_FW_DIR "/QCA988X/hw2.0"
 #define QCA988X_HW_2_0_FW_FILE		"firmware.bin"
 #define QCA988X_HW_2_0_OTP_FILE		"otp.bin"
 #define QCA988X_HW_2_0_BOARD_DATA_FILE	"board.bin"

