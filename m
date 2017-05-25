Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43001 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756251AbdEYKvM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 06:51:12 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <akolli@codeaurora.org>,
        Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH] ath10k: Add BMI parameters to fix calibration from DT/pre-cal
Date: Thu, 25 May 2017 16:21:23 +0530
Message-ID: <1495709483-29793-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20170525_125115_804337_9B1E94EE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

QCA99X0, QCA9888, QCA9984 supports calibration data in
either OTP or DT/pre-cal file. Current ath10k supports
Calibration data from OTP only.

If caldata is loaded from DT/pre-cal file, fetching board id
and applying calibration parameters like tx power gets failed.

error log:
[   15.733663] ath10k_pci 0000:01:00.0: failed to fetch board file: -2
[   15.741474] ath10k_pci 0000:01:00.0: could not probe fw (-2)

This patch adds calibration data support from DT/pre-cal
file.  Below parameters are used to get board id and
applying calibration parameters from cal data.

		EEPROM[OTP]	FLASH[DT/pre-cal file]
Cal param	0x700		0x10000
Board id	0x10		0x8000

Tested on QCA9888 with pre-cal file.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/bmi.h  |    2 ++
 drivers/net/wireless/ath/ath10k/core.c |   16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/bmi.h b/drivers/net/wireless/ath/ath10k/bmi.h
index 0342073ed397..9834f351807e 100644
--- a/drivers/net/wireless/ath/ath10k/bmi.h
+++ b/drivers/net/wireless/ath/ath10k/bmi.h
@@ -83,6 +83,8 @@ enum bmi_cmd_id {
 #define BMI_NVRAM_SEG_NAME_SZ 16
 
 #define BMI_PARAM_GET_EEPROM_BOARD_ID 0x10
+#define BMI_PARAM_GET_FLASH_BOARD_ID 0x8000
+#define BMI_PARAM_FLASH_SECTION_ALL 0x10000
 
 #define ATH10K_BMI_BOARD_ID_FROM_OTP_MASK   0x7c00
 #define ATH10K_BMI_BOARD_ID_FROM_OTP_LSB    10
diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index eea111d704c5..fb859a0c197a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -691,7 +691,7 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 {
 	u32 result, address;
 	u8 board_id, chip_id;
-	int ret;
+	int ret, bmi_board_id_param;
 
 	address = ar->hw_params.patch_load_addr;
 
@@ -715,8 +715,13 @@ static int ath10k_core_get_board_id_from_otp(struct ath10k *ar)
 		return ret;
 	}
 
-	ret = ath10k_bmi_execute(ar, address, BMI_PARAM_GET_EEPROM_BOARD_ID,
-				 &result);
+	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+		bmi_board_id_param = BMI_PARAM_GET_FLASH_BOARD_ID;
+	else
+		bmi_board_id_param = BMI_PARAM_GET_EEPROM_BOARD_ID;
+
+	ret = ath10k_bmi_execute(ar, address, bmi_board_id_param, &result);
 	if (ret) {
 		ath10k_err(ar, "could not execute otp for board id check: %d\n",
 			   ret);
@@ -845,6 +850,11 @@ static int ath10k_download_and_run_otp(struct ath10k *ar)
 		return ret;
 	}
 
+	/* As of now pre-cal is valid for 10_4 variants */
+	if (ar->cal_mode == ATH10K_PRE_CAL_MODE_DT ||
+	    ar->cal_mode == ATH10K_PRE_CAL_MODE_FILE)
+		bmi_otp_exe_param = BMI_PARAM_FLASH_SECTION_ALL;
+
 	ret = ath10k_bmi_execute(ar, address, bmi_otp_exe_param, &result);
 	if (ret) {
 		ath10k_err(ar, "could not execute otp (%d)\n", ret);
-- 
1.7.9.5
