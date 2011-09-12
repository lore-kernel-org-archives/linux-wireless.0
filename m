Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:54970 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872Ab1ILLMV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:21 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id DBB058C735
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:19 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id B2B2D404E
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:17 +0300 (EEST)
Subject: [PATCH 2/9] ath6kl: separate firmware fetch from upload
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:16 +0300
Message-ID: <20110912111216.16921.14550.stgit@localhost6.localdomain6> (sfid-20110912_131224_874411_FA17D9A8)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for the new firmware image format.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |  249 ++++++++++++++++++++------------
 1 files changed, 153 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 9171670..4055947 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -744,6 +744,9 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	const char *filename;
 	int ret;
 
+	if (ar->fw_board != NULL)
+		return 0;
+
 	switch (ar->version.target_ver) {
 	case AR6003_REV2_VERSION:
 		filename = AR6003_REV2_BOARD_DATA_FILE;
@@ -798,6 +801,144 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	return 0;
 }
 
+static int ath6kl_fetch_otp_file(struct ath6kl *ar)
+{
+	const char *filename;
+	int ret;
+
+	if (ar->fw_otp != NULL)
+		return 0;
+
+	switch (ar->version.target_ver) {
+	case AR6003_REV2_VERSION:
+		filename = AR6003_REV2_OTP_FILE;
+		break;
+	case AR6004_REV1_VERSION:
+		ath6kl_dbg(ATH6KL_DBG_TRC, "AR6004 doesn't need OTP file\n");
+		return 0;
+		break;
+	default:
+		filename = AR6003_REV3_OTP_FILE;
+		break;
+	}
+
+	ret = ath6kl_get_fw(ar, filename, &ar->fw_otp,
+			    &ar->fw_otp_len);
+	if (ret) {
+		ath6kl_err("Failed to get OTP file %s: %d\n",
+			   filename, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath6kl_fetch_fw_file(struct ath6kl *ar)
+{
+	const char *filename;
+	int ret;
+
+	if (ar->fw != NULL)
+		return 0;
+
+	if (testmode) {
+		switch (ar->version.target_ver) {
+		case AR6003_REV2_VERSION:
+			filename = AR6003_REV2_TCMD_FIRMWARE_FILE;
+			break;
+		case AR6003_REV3_VERSION:
+			filename = AR6003_REV3_TCMD_FIRMWARE_FILE;
+			break;
+		case AR6004_REV1_VERSION:
+			ath6kl_warn("testmode not supported with ar6004\n");
+			return -EOPNOTSUPP;
+		default:
+			ath6kl_warn("unknown target version: 0x%x\n",
+				       ar->version.target_ver);
+			return -EINVAL;
+		}
+
+		set_bit(TESTMODE, &ar->flag);
+
+		goto get_fw;
+	}
+
+	switch (ar->version.target_ver) {
+	case AR6003_REV2_VERSION:
+		filename = AR6003_REV2_FIRMWARE_FILE;
+		break;
+	case AR6004_REV1_VERSION:
+		filename = AR6004_REV1_FIRMWARE_FILE;
+		break;
+	default:
+		filename = AR6003_REV3_FIRMWARE_FILE;
+		break;
+	}
+
+get_fw:
+	ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
+	if (ret) {
+		ath6kl_err("Failed to get firmware file %s: %d\n",
+			   filename, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath6kl_fetch_patch_file(struct ath6kl *ar)
+{
+	const char *filename;
+	int ret;
+
+	switch (ar->version.target_ver) {
+	case AR6003_REV2_VERSION:
+		filename = AR6003_REV2_PATCH_FILE;
+		break;
+	case AR6004_REV1_VERSION:
+		/* FIXME: implement for AR6004 */
+		return 0;
+		break;
+	default:
+		filename = AR6003_REV3_PATCH_FILE;
+		break;
+	}
+
+	if (ar->fw_patch == NULL) {
+		ret = ath6kl_get_fw(ar, filename, &ar->fw_patch,
+				    &ar->fw_patch_len);
+		if (ret) {
+			ath6kl_err("Failed to get patch file %s: %d\n",
+				   filename, ret);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int ath6kl_fetch_firmwares(struct ath6kl *ar)
+{
+	int ret;
+
+	ret = ath6kl_fetch_board_file(ar);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_fetch_otp_file(ar);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_fetch_fw_file(ar);
+	if (ret)
+		return ret;
+
+	ret = ath6kl_fetch_patch_file(ar);
+	if (ret)
+		return ret;
+
+	return 0;
+}
 
 static int ath6kl_upload_board_file(struct ath6kl *ar)
 {
@@ -805,11 +946,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	u32 board_data_size, board_ext_data_size;
 	int ret;
 
-	if (ar->fw_board == NULL) {
-		ret = ath6kl_fetch_board_file(ar);
-		if (ret)
-			return ret;
-	}
+	if (WARN_ON(ar->fw_board == NULL))
+		return -ENOENT;
 
 	/*
 	 * Determine where in Target RAM to write Board Data.
@@ -909,32 +1047,11 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 
 static int ath6kl_upload_otp(struct ath6kl *ar)
 {
-	const char *filename;
 	u32 address, param;
 	int ret;
 
-	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_OTP_FILE;
-		break;
-	case AR6004_REV1_VERSION:
-		ath6kl_dbg(ATH6KL_DBG_TRC, "AR6004 doesn't need OTP file\n");
-		return 0;
-		break;
-	default:
-		filename = AR6003_REV3_OTP_FILE;
-		break;
-	}
-
-	if (ar->fw_otp == NULL) {
-		ret = ath6kl_get_fw(ar, filename, &ar->fw_otp,
-				    &ar->fw_otp_len);
-		if (ret) {
-			ath6kl_err("Failed to get OTP file %s: %d\n",
-				   filename, ret);
-			return ret;
-		}
-	}
+	if (WARN_ON(ar->fw_otp == NULL))
+		return -ENOENT;
 
 	address = ath6kl_get_load_address(ar->version.target_ver,
 					  APP_LOAD_ADDR);
@@ -957,54 +1074,11 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 
 static int ath6kl_upload_firmware(struct ath6kl *ar)
 {
-	const char *filename;
 	u32 address;
 	int ret;
 
-	if (testmode) {
-		switch (ar->version.target_ver) {
-		case AR6003_REV2_VERSION:
-			filename = AR6003_REV2_TCMD_FIRMWARE_FILE;
-			break;
-		case AR6003_REV3_VERSION:
-			filename = AR6003_REV3_TCMD_FIRMWARE_FILE;
-			break;
-		case AR6004_REV1_VERSION:
-			ath6kl_warn("testmode not supported with ar6004\n");
-			return -EOPNOTSUPP;
-		default:
-			ath6kl_warn("unknown target version: 0x%x\n",
-				       ar->version.target_ver);
-			return -EINVAL;
-		}
-
-		set_bit(TESTMODE, &ar->flag);
-
-		goto get_fw;
-	}
-
-	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_FIRMWARE_FILE;
-		break;
-	case AR6004_REV1_VERSION:
-		filename = AR6004_REV1_FIRMWARE_FILE;
-		break;
-	default:
-		filename = AR6003_REV3_FIRMWARE_FILE;
-		break;
-	}
-
-get_fw:
-
-	if (ar->fw == NULL) {
-		ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
-		if (ret) {
-			ath6kl_err("Failed to get firmware file %s: %d\n",
-				   filename, ret);
-			return ret;
-		}
-	}
+	if (WARN_ON(ar->fw == NULL))
+		return -ENOENT;
 
 	address = ath6kl_get_load_address(ar->version.target_ver,
 					  APP_LOAD_ADDR);
@@ -1030,32 +1104,11 @@ get_fw:
 
 static int ath6kl_upload_patch(struct ath6kl *ar)
 {
-	const char *filename;
 	u32 address, param;
 	int ret;
 
-	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		filename = AR6003_REV2_PATCH_FILE;
-		break;
-	case AR6004_REV1_VERSION:
-		/* FIXME: implement for AR6004 */
-		return 0;
-		break;
-	default:
-		filename = AR6003_REV3_PATCH_FILE;
-		break;
-	}
-
-	if (ar->fw_patch == NULL) {
-		ret = ath6kl_get_fw(ar, filename, &ar->fw_patch,
-				    &ar->fw_patch_len);
-		if (ret) {
-			ath6kl_err("Failed to get patch file %s: %d\n",
-				   filename, ret);
-			return ret;
-		}
-	}
+	if (WARN_ON(ar->fw_patch == NULL))
+		return -ENOENT;
 
 	address = ath6kl_get_load_address(ar->version.target_ver,
 					  DATASET_PATCH_ADDR);
@@ -1362,6 +1415,10 @@ int ath6kl_core_init(struct ath6kl *ar)
 		goto err_htc_cleanup;
 	}
 
+	ret = ath6kl_fetch_firmwares(ar);
+	if (ret)
+		goto err_htc_cleanup;
+
 	ret = ath6kl_init_upload(ar);
 	if (ret)
 		goto err_htc_cleanup;

