Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:59077 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932548Ab1LPSxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 13:53:46 -0500
Subject: [PATCH 2/2] ath6kl: add support for FW API 3
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Fri, 16 Dec 2011 20:53:41 +0200
Message-ID: <20111216185341.18442.7476.stgit@localhost6.localdomain6> (sfid-20111216_195353_059412_68ED7293)
In-Reply-To: <20111216185200.18442.29650.stgit@localhost6.localdomain6>
References: <20111216185200.18442.29650.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As firmware starting from 3.2.0.12 has some API changes and doesn't work
with older versions of ath6kl we need to bump up the API version. This
way we don't break anything.

Also store which version of API is used and print that during boot:

ath6kl: ar6003 hw 2.1.1 sdio fw 3.2.0.13 api 3

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 ++-
 drivers/net/wireless/ath/ath6kl/init.c |   32 +++++++++++++++++---------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 2679577..c095faf 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -98,6 +98,7 @@ struct ath6kl_fw_ie {
 };
 
 #define ATH6KL_FW_API2_FILE "fw-2.bin"
+#define ATH6KL_FW_API3_FILE "fw-3.bin"
 
 /* AR6003 1.0 definitions */
 #define AR6003_HW_1_0_VERSION                 0x300002ba
@@ -582,7 +583,6 @@ struct ath6kl {
 			const char *fw;
 			const char *tcmd;
 			const char *patch;
-			const char *api2;
 		} fw;
 
 		const char *fw_board;
@@ -608,6 +608,7 @@ struct ath6kl {
 	u8 *fw_patch;
 	size_t fw_patch_len;
 
+	unsigned int fw_api;
 	unsigned long fw_capabilities[ATH6KL_CAPABILITY_LEN];
 
 	struct workqueue_struct *ath6kl_wq;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c666226..5f62a65 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -53,7 +53,6 @@ static const struct ath6kl_hw hw_list[] = {
 			.fw		= AR6003_HW_2_0_FIRMWARE_FILE,
 			.tcmd		= AR6003_HW_2_0_TCMD_FIRMWARE_FILE,
 			.patch		= AR6003_HW_2_0_PATCH_FILE,
-			.api2		= ATH6KL_FW_API2_FILE,
 		},
 
 		.fw_board		= AR6003_HW_2_0_BOARD_DATA_FILE,
@@ -75,7 +74,6 @@ static const struct ath6kl_hw hw_list[] = {
 			.fw		= AR6003_HW_2_1_1_FIRMWARE_FILE,
 			.tcmd		= AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE,
 			.patch		= AR6003_HW_2_1_1_PATCH_FILE,
-			.api2		= ATH6KL_FW_API2_FILE,
 		},
 
 		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
@@ -95,7 +93,6 @@ static const struct ath6kl_hw hw_list[] = {
 		.fw = {
 			.dir		= AR6004_HW_1_0_FW_DIR,
 			.fw		= AR6004_HW_1_0_FIRMWARE_FILE,
-			.api2		= ATH6KL_FW_API2_FILE,
 		},
 
 		.fw_board		= AR6004_HW_1_0_BOARD_DATA_FILE,
@@ -115,7 +112,6 @@ static const struct ath6kl_hw hw_list[] = {
 		.fw = {
 			.dir		= AR6004_HW_1_1_FW_DIR,
 			.fw		= AR6004_HW_1_1_FIRMWARE_FILE,
-			.api2		= ATH6KL_FW_API2_FILE,
 		},
 
 		.fw_board		= AR6004_HW_1_1_BOARD_DATA_FILE,
@@ -841,7 +837,7 @@ static int ath6kl_fetch_fw_api1(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
+static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 {
 	size_t magic_len, len, ie_len;
 	const struct firmware *fw;
@@ -851,11 +847,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	int ret, ie_id, i, index, bit;
 	__le32 *val;
 
-	if (ar->hw.fw.api2 == NULL)
-		return -EOPNOTSUPP;
-
-	snprintf(filename, sizeof(filename), "%s/%s",
-		 ar->hw.fw.dir, ar->hw.fw.api2);
+	snprintf(filename, sizeof(filename), "%s/%s", ar->hw.fw.dir, name);
 
 	ret = request_firmware(&fw, filename, ar->dev);
 	if (ret)
@@ -1025,17 +1017,26 @@ static int ath6kl_fetch_firmwares(struct ath6kl *ar)
 	if (ret)
 		return ret;
 
-	ret = ath6kl_fetch_fw_api2(ar);
+	ret = ath6kl_fetch_fw_apin(ar, ATH6KL_FW_API3_FILE);
 	if (ret == 0) {
-		ath6kl_dbg(ATH6KL_DBG_BOOT, "using fw api 2\n");
-		return 0;
+		ar->fw_api = 3;
+		goto out;
+	}
+
+	ret = ath6kl_fetch_fw_apin(ar, ATH6KL_FW_API2_FILE);
+	if (ret == 0) {
+		ar->fw_api = 2;
+		goto out;
 	}
 
 	ret = ath6kl_fetch_fw_api1(ar);
 	if (ret)
 		return ret;
 
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "using fw api 1\n");
+	ar->fw_api = 1;
+
+out:
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "using fw api %d\n", ar->fw_api);
 
 	return 0;
 }
@@ -1488,10 +1489,11 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 
 
 	if (test_and_clear_bit(FIRST_BOOT, &ar->flag)) {
-		ath6kl_info("%s %s fw %s%s\n",
+		ath6kl_info("%s %s fw %s api %d%s\n",
 			    ar->hw.name,
 			    ath6kl_init_get_hif_name(ar->hif_type),
 			    ar->wiphy->fw_version,
+			    ar->fw_api,
 			    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
 	}
 

