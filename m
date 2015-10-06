Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:43745 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbbJFNP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 09:15:57 -0400
Subject: [PATCH 2/2] ath10k: select board data based on BMI chip id and board
 id
To: ath10k@lists.infradead.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Oct 2015 16:15:53 +0300
Message-ID: <20151006131553.14278.17820.stgit@potku.adurom.net> (sfid-20151006_151600_523243_6EA3E9EF)
In-Reply-To: <20151006131455.14278.28222.stgit@potku.adurom.net>
References: <20151006131455.14278.28222.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

QCA99X0 uses radio specific board names based on chip id and
board id combinations. We get these IDs from the target using BMI after otp.bin
has been started.

This patch reorders the call to the function ath10k_core_fetch_board_file
so that we have OTP binary before requesting for boardid-chipid. We get this
OTP data after parsing firmware-N.bin.

[kvalo@qca.qualcomm.com: try BMI_PARAM_GET_EEPROM_BOARD_ID with
 all boards and detect if command is not supported]
Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h   |   10 ++++
 drivers/net/wireless/ath/ath10k/core.c  |   79 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/core.h  |    4 ++
 drivers/net/wireless/ath/ath10k/debug.c |    8 ++-
 4 files changed, 93 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index df7c7616533b..7d3231acfb24 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -82,6 +82,16 @@ enum bmi_cmd_id {
 
 #define BMI_NVRAM_SEG_NAME_SZ 16
 
+#define BMI_PARAM_GET_EEPROM_BOARD_ID 0x10
+
+#define ATH10K_BMI_BOARD_ID_FROM_OTP_MASK   0x7c00
+#define ATH10K_BMI_BOARD_ID_FROM_OTP_LSB    10
+
+#define ATH10K_BMI_CHIP_ID_FROM_OTP_MASK    0x18000
+#define ATH10K_BMI_CHIP_ID_FROM_OTP_LSB     15
+
+#define ATH10K_BMI_BOARD_ID_STATUS_MASK 0xff
+
 struct bmi_cmd {
 	__le32 id; /* enum bmi_cmd_id */
 	union {
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 9d3d9a7fdea4..9d4ac02c8635 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -448,6 +448,56 @@ out:
 	return ret;
 }
 
+static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
+{
+	u32 result, address;
+	u8 board_id, chip_id;
+	int ret;
+
+	address = ar->hw_params.patch_load_addr;
+
+	if (!ar->otp_data || !ar->otp_len) {
+		ath10k_warn(ar,
+			    "failed to retrieve board id because of invalid otp\n");
+		return -ENODATA;
+	}
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot upload otp to 0x%x len %zd for board id\n",
+		   address, ar->otp_len);
+
+	ret = ath10k_bmi_fast_download(ar, address, ar->otp_data, ar->otp_len);
+	if (ret) {
+		ath10k_err(ar, "could not write otp for board id check: %d\n",
+			   ret);
+		return ret;
+	}
+
+	ret = ath10k_bmi_execute(ar, address, BMI_PARAM_GET_EEPROM_BOARD_ID,
+				 &result);
+	if (ret) {
+		ath10k_err(ar, "could not execute otp for board id check: %d\n",
+			   ret);
+		return ret;
+	}
+
+	board_id = MS(result, ATH10K_BMI_BOARD_ID_FROM_OTP);
+	chip_id = MS(result, ATH10K_BMI_CHIP_ID_FROM_OTP);
+
+	ath10k_dbg(ar, ATH10K_DBG_BOOT,
+		   "boot get otp board id result 0x%08x board_id %d chip_id %d\n",
+		   result, board_id, chip_id);
+
+	if ((result & ATH10K_BMI_BOARD_ID_STATUS_MASK) != 0)
+		return -EOPNOTSUPP;
+
+	ar->id.bmi_ids_valid = true;
+	ar->id.bmi_board_id = board_id;
+	ar->id.bmi_chip_id = chip_id;
+
+	return 0;
+}
+
 static int ath10k_download_and_run_otp(struct ath10k *ar)
 {
 	u32 result, address = ar->hw_params.patch_load_addr;
@@ -792,12 +842,22 @@ err:
 static int ath10k_core_create_board_name(struct ath10k *ar, char *name,
 					 size_t name_len)
 {
+	if (ar->id.bmi_ids_valid) {
+		scnprintf(name, name_len,
+			  "bus=%s,bmi-chip-id=%d,bmi-board-id=%d",
+			  ath10k_bus_str(ar->hif.bus),
+			  ar->id.bmi_chip_id,
+			  ar->id.bmi_board_id);
+		goto out;
+	}
+
 	scnprintf(name, name_len,
 		  "bus=%s,vendor=%04x,device=%04x,subsystem-vendor=%04x,subsystem-device=%04x",
 		  ath10k_bus_str(ar->hif.bus),
 		  ar->id.vendor, ar->id.device,
 		  ar->id.subsystem_vendor, ar->id.subsystem_device);
 
+out:
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "boot using board name '%s'\n", name);
 
 	return 0;
@@ -1060,12 +1120,6 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	/* calibration file is optional, don't check for any errors */
 	ath10k_fetch_cal_file(ar);
 
-	ret = ath10k_core_fetch_board_file(ar);
-	if (ret) {
-		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
-		return ret;
-	}
-
 	ar->fw_api = 5;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
@@ -1675,6 +1729,19 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		goto err_power_down;
 	}
 
+	ret = ath10k_core_get_board_id_from_otp(ar);
+	if (ret && ret != -EOPNOTSUPP) {
+		ath10k_err(ar, "failed to get board id from otp for qca99x0: %d\n",
+			   ret);
+		return ret;
+	}
+
+	ret = ath10k_core_fetch_board_file(ar);
+	if (ret) {
+		ath10k_err(ar, "failed to fetch board file: %d\n", ret);
+		goto err_free_firmware_files;
+	}
+
 	ret = ath10k_core_init_firmware_features(ar);
 	if (ret) {
 		ath10k_err(ar, "fatal problem with firmware features: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index af5c0d741659..7cc7cdd56c95 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -681,6 +681,10 @@ struct ath10k {
 		u32 device;
 		u32 subsystem_vendor;
 		u32 subsystem_device;
+
+		bool bmi_ids_valid;
+		u8 bmi_board_id;
+		u8 bmi_chip_id;
 	} id;
 
 	int fw_api;
diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index 7e8f6511b232..eab71e2eb4d7 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -129,8 +129,12 @@ void ath10k_print_driver_info(struct ath10k *ar)
 
 	ath10k_core_get_fw_features_str(ar, fw_features, sizeof(fw_features));
 
-	scnprintf(boardinfo, sizeof(boardinfo), "sub %04x:%04x",
-		  ar->id.subsystem_vendor, ar->id.subsystem_device);
+	if (ar->id.bmi_ids_valid)
+		scnprintf(boardinfo, sizeof(boardinfo), "bmi %d:%d",
+			  ar->id.bmi_chip_id, ar->id.bmi_board_id);
+	else
+		scnprintf(boardinfo, sizeof(boardinfo), "sub %04x:%04x",
+			  ar->id.subsystem_vendor, ar->id.subsystem_device);
 
 	ath10k_info(ar, "%s (0x%08x, 0x%08x %s) fw %s fwapi %d bdapi %d htt-ver %d.%d wmi-op %d htt-op %d cal %s max-sta %d raw %d hwcrypto %d features %s\n",
 		    ar->hw_params.name,

