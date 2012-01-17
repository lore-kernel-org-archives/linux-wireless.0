Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:13698 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2AQNhh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 08:37:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Alex Yang <xiaojuny@qca.qualcomm.com>
Subject: [PATCH] Add testmode 2 for 6003 ART.
Date: Tue, 17 Jan 2012 15:32:29 +0200
Message-ID: <1326807149-3809-1-git-send-email-kvalo@qca.qualcomm.com> (sfid-20120117_143746_448961_A4BCC71B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alex Yang <xiaojuny@qca.qualcomm.com>

Add testmode 2 for 6003 ART. When you insmod ath6kl_sdio.ko testmode=2, ath6kl will load ART firmware utf.bin and testscript nullTestFlow.bin. These files should be put in the firmware folder.

Signed-off-by: Alex Yang <xiaojuny@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    8 +++
 drivers/net/wireless/ath/ath6kl/init.c |  109 ++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index ba39539..f53594f 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -125,6 +125,8 @@ struct ath6kl_fw_ie {
 #define AR6003_HW_2_1_1_OTP_FILE		"otp.bin"
 #define AR6003_HW_2_1_1_FIRMWARE_FILE		"athwlan.bin"
 #define AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE	"athtcmd_ram.bin"
+#define AR6003_HW_2_1_1_UTF_FIRMWARE_FILE	"utf.bin"
+#define AR6003_HW_2_1_1_TESTSCRIPT_FILE	"nullTestFlow.bin"
 #define AR6003_HW_2_1_1_PATCH_FILE		"data.patch.bin"
 #define AR6003_HW_2_1_1_BOARD_DATA_FILE "ath6k/AR6003/hw2.1.1/bdata.bin"
 #define AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE	\
@@ -592,6 +594,7 @@ struct ath6kl {
 		u32 board_addr;
 		u32 refclk_hz;
 		u32 uarttx_pin;
+		u32 testscript_addr;
 
 		struct ath6kl_hw_fw {
 			const char *dir;
@@ -599,6 +602,8 @@ struct ath6kl {
 			const char *fw;
 			const char *tcmd;
 			const char *patch;
+			const char *utf;
+			const char *testscript;
 		} fw;
 
 		const char *fw_board;
@@ -624,6 +629,9 @@ struct ath6kl {
 	u8 *fw_patch;
 	size_t fw_patch_len;
 
+	u8 *fw_testscript;
+	size_t fw_testscript_len;
+
 	unsigned int fw_api;
 	unsigned long fw_capabilities[ATH6KL_CAPABILITY_LEN];
 
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e5969c1..6227928 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -69,6 +69,7 @@ static const struct ath6kl_hw hw_list[] = {
 		.reserved_ram_size		= 512,
 		.refclk_hz			= 26000000,
 		.uarttx_pin			= 8,
+		.testscript_addr		= 0x57ef74,
 
 		.fw = {
 			.dir		= AR6003_HW_2_1_1_FW_DIR,
@@ -76,6 +77,8 @@ static const struct ath6kl_hw hw_list[] = {
 			.fw		= AR6003_HW_2_1_1_FIRMWARE_FILE,
 			.tcmd		= AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE,
 			.patch		= AR6003_HW_2_1_1_PATCH_FILE,
+			.utf		= AR6003_HW_2_1_1_UTF_FIRMWARE_FILE,
+			.testscript	= AR6003_HW_2_1_1_TESTSCRIPT_FILE,
 		},
 
 		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
@@ -620,6 +623,7 @@ void ath6kl_core_cleanup(struct ath6kl *ar)
 	kfree(ar->fw_otp);
 	kfree(ar->fw);
 	kfree(ar->fw_patch);
+	kfree(ar->fw_testscript);
 
 	ath6kl_deinit_ieee80211_hw(ar);
 }
@@ -771,14 +775,25 @@ static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 		return 0;
 
 	if (testmode) {
-		if (ar->hw.fw.tcmd == NULL) {
-			ath6kl_warn("testmode not supported\n");
-			return -EOPNOTSUPP;
-		}
+		ath6kl_dbg(ATH6KL_DBG_BOOT, "testmode %d\n",
+				testmode);
+		if (testmode == 2) {
+			if (ar->hw.fw.utf == NULL) {
+				ath6kl_warn("testmode 2 not supported\n");
+				return -EOPNOTSUPP;
+			}
 
-		snprintf(filename, sizeof(filename), "%s/%s",
-			 ar->hw.fw.dir, ar->hw.fw.tcmd);
+			snprintf(filename, sizeof(filename), "%s/%s",
+				ar->hw.fw.dir, ar->hw.fw.utf);
+		} else {
+			if (ar->hw.fw.tcmd == NULL) {
+				ath6kl_warn("testmode 1 not supported\n");
+				return -EOPNOTSUPP;
+			}
 
+			snprintf(filename, sizeof(filename), "%s/%s",
+				ar->hw.fw.dir, ar->hw.fw.tcmd);
+		}
 		set_bit(TESTMODE, &ar->flag);
 
 		goto get_fw;
@@ -827,6 +842,35 @@ static int ath6kl_fetch_patch_file(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_fetch_testscript_file(struct ath6kl *ar)
+{
+	char filename[100];
+	int ret;
+
+
+	if (testmode != 2)
+		return 0;
+
+	if (ar->fw_testscript != NULL)
+		return 0;
+
+	if (ar->hw.fw.testscript == NULL)
+		return 0;
+
+	snprintf(filename, sizeof(filename), "%s/%s",
+		ar->hw.fw.dir, ar->hw.fw.testscript);
+
+	ret = ath6kl_get_fw(ar, filename, &ar->fw_testscript,
+				&ar->fw_testscript_len);
+	if (ret) {
+		ath6kl_err("Failed to get testscript file %s: %d\n",
+			filename, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
 static int ath6kl_fetch_fw_api1(struct ath6kl *ar)
 {
 	int ret;
@@ -843,6 +887,10 @@ static int ath6kl_fetch_fw_api1(struct ath6kl *ar)
 	if (ret)
 		return ret;
 
+	ret = ath6kl_fetch_testscript_file(ar);
+	if (ret)
+		return ret;
+
 	return 0;
 }
 
@@ -1266,6 +1314,50 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_upload_testscript(struct ath6kl *ar)
+{
+	u32 address, param;
+	int ret;
+
+	if (testmode != 2)
+		return 0;
+
+	if (ar->fw_testscript == NULL)
+		return 0;
+
+	address = ar->hw.testscript_addr;
+
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing testscript to 0x%x (%zd B)\n",
+		address, ar->fw_testscript_len);
+
+	ret = ath6kl_bmi_write(ar, address, ar->fw_testscript,
+		ar->fw_testscript_len);
+	if (ret) {
+		ath6kl_err("Failed to write testscript file: %d\n", ret);
+		return ret;
+	}
+
+	param = address;
+	ath6kl_bmi_write(ar,
+			ath6kl_get_hi_item_addr(ar,
+			HI_ITEM(hi_ota_testscript)),
+			(unsigned char *) &param, 4);
+
+	param = 4096;
+	ath6kl_bmi_write(ar,
+			ath6kl_get_hi_item_addr(ar,
+			HI_ITEM(hi_end_ram_reserve_sz)),
+			(unsigned char *) &param, 4);
+
+	param = 1;
+	ath6kl_bmi_write(ar,
+			ath6kl_get_hi_item_addr(ar,
+			HI_ITEM(hi_test_apps_related)),
+			(unsigned char *) &param, 4);
+
+	return 0;
+}
+
 static int ath6kl_init_upload(struct ath6kl *ar)
 {
 	u32 param, options, sleep, address;
@@ -1374,6 +1466,11 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	if (status)
 		return status;
 
+	/* Download the test script */
+	status = ath6kl_upload_testscript(ar);
+	if (status)
+		return status;
+
 	/* Restore system sleep */
 	address = RTC_BASE_ADDRESS + SYSTEM_SLEEP_ADDRESS;
 	status = ath6kl_bmi_reg_write(ar, address, sleep);
-- 
1.7.0.4

