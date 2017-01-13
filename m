Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34762 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751440AbdAMVf2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:35:28 -0500
Received: by mail-lf0-f65.google.com with SMTP id q89so7082095lfi.1
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:35:27 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 04/10] ath10k: new fw fetch functionality
Date: Fri, 13 Jan 2017 22:35:03 +0100
Message-Id: <1484343309-6327-5-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_223943_978264_5E5D0F26)
In-Reply-To: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new function for creating the fw file name dynamically.

Since both SDIO and USB based chipsets will use different
firmware from the PCIe and AHB chipsets, the fw file name
is created dynamically.

The new firmware names are:

For PCIe and AHB:
firmware-<api_version>.bin (same as before)

For SDIO:
firmware-sdio-<api_version>.bin

For USB:
firmware-usb-<api_version>.bin

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 56 ++++++++++++++++------------------
 drivers/net/wireless/ath/ath10k/hw.h   |  4 +++
 2 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index e985316..c275a52 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1284,44 +1284,40 @@ int ath10k_core_fetch_firmware_api_n(struct ath10k *ar, const char *name,
 	return ret;
 }
 
+static void ath10k_core_get_fw_name(struct ath10k *ar, char *fw_name,
+				    int fw_api)
+{
+	if ((ar->hif.bus != ATH10K_BUS_PCI) && (ar->hif.bus != ATH10K_BUS_AHB))
+		snprintf(fw_name, ATH10K_FW_FILE_NAME_MAX_LEN, "%s-%s-%d.bin",
+			 ATH10K_FW_FILE_BASE, ath10k_bus_str(ar->hif.bus),
+			 fw_api);
+	else
+		snprintf(fw_name, ATH10K_FW_FILE_NAME_MAX_LEN, "%s-%d.bin",
+			 ATH10K_FW_FILE_BASE, fw_api);
+}
+
 static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 {
-	int ret;
+	int ret, i;
+	char fw_name[ATH10K_FW_FILE_NAME_MAX_LEN];
 
 	/* calibration file is optional, don't check for any errors */
 	ath10k_fetch_cal_file(ar);
 
-	ar->fw_api = 5;
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
-
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API5_FILE,
-					       &ar->normal_mode_fw.fw_file);
-	if (ret == 0)
-		goto success;
-
-	ar->fw_api = 4;
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
-
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API4_FILE,
-					       &ar->normal_mode_fw.fw_file);
-	if (ret == 0)
-		goto success;
-
-	ar->fw_api = 3;
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
-
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API3_FILE,
-					       &ar->normal_mode_fw.fw_file);
-	if (ret == 0)
-		goto success;
+	for (i = 5; i >= 2; i--) {
+		ar->fw_api = i;
+		ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n",
+			   ar->fw_api);
 
-	ar->fw_api = 2;
-	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+		ath10k_core_get_fw_name(ar, fw_name, ar->fw_api);
+		ret = ath10k_core_fetch_firmware_api_n(ar, fw_name,
+						       &ar->normal_mode_fw.fw_file);
+		if (!ret)
+			goto success;
+	}
 
-	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API2_FILE,
-					       &ar->normal_mode_fw.fw_file);
-	if (ret)
-		return ret;
+	/* We end up here if we couldn't fetch any firmware */
+	return ret;
 
 success:
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "using fw api %d\n", ar->fw_api);
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 6bdea86..9f4cd76 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -128,6 +128,10 @@ enum qca9377_chip_id_rev {
 #define QCA4019_HW_1_0_BOARD_DATA_FILE "board.bin"
 #define QCA4019_HW_1_0_PATCH_LOAD_ADDR  0x1234
 
+#define ATH10K_FW_FILE_NAME_MAX_LEN	100
+
+#define ATH10K_FW_FILE_BASE		"firmware"
+
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
-- 
2.7.4
