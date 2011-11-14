Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:45069 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1KNRb1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:27 -0500
Subject: [PATCH 08/10] ath6kl: add firmware filename info to struct ath6kl_hw
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:31:23 +0200
Message-ID: <20111114173123.29925.51892.stgit@localhost6.localdomain6> (sfid-20111114_183135_346293_74B45D95)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    8 ++
 drivers/net/wireless/ath/ath6kl/init.c |  149 +++++++++++++-------------------
 2 files changed, 67 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index b14ad11..1697c00 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -553,6 +553,14 @@ struct ath6kl {
 		u32 board_ext_data_addr;
 		u32 reserved_ram_size;
 		u32 board_addr;
+
+		const char *fw_otp;
+		const char *fw;
+		const char *fw_tcmd;
+		const char *fw_patch;
+		const char *fw_api2;
+		const char *fw_board;
+		const char *fw_default_board;
 	} hw;
 
 	u16 conf_flags;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 208e77e..9d6e50d 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -44,6 +44,14 @@ static const struct ath6kl_hw hw_list[] = {
 
 		/* hw2.0 needs override address hardcoded */
 		.app_start_override_addr	= 0x944C00,
+
+		.fw_otp			= AR6003_HW_2_0_OTP_FILE,
+		.fw			= AR6003_HW_2_0_FIRMWARE_FILE,
+		.fw_tcmd		= AR6003_HW_2_0_TCMD_FIRMWARE_FILE,
+		.fw_patch		= AR6003_HW_2_0_PATCH_FILE,
+		.fw_api2		= AR6003_HW_2_0_FIRMWARE_2_FILE,
+		.fw_board		= AR6003_HW_2_0_BOARD_DATA_FILE,
+		.fw_default_board	= AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE,
 	},
 	{
 		.id				= AR6003_HW_2_1_1_VERSION,
@@ -52,6 +60,14 @@ static const struct ath6kl_hw hw_list[] = {
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x542330,
 		.reserved_ram_size		= 512,
+
+		.fw_otp			= AR6003_HW_2_1_1_OTP_FILE,
+		.fw			= AR6003_HW_2_1_1_FIRMWARE_FILE,
+		.fw_tcmd		= AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE,
+		.fw_patch		= AR6003_HW_2_1_1_PATCH_FILE,
+		.fw_api2		= AR6003_HW_2_1_1_FIRMWARE_2_FILE,
+		.fw_board		= AR6003_HW_2_1_1_BOARD_DATA_FILE,
+		.fw_default_board	= AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
 	{
 		.id				= AR6004_HW_1_0_VERSION,
@@ -61,6 +77,11 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 19456,
 		.board_addr			= 0x433900,
+
+		.fw			= AR6004_HW_1_0_FIRMWARE_FILE,
+		.fw_api2		= AR6004_HW_1_0_FIRMWARE_2_FILE,
+		.fw_board		= AR6004_HW_1_0_BOARD_DATA_FILE,
+		.fw_default_board	= AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE,
 	},
 	{
 		.id				= AR6004_HW_1_1_VERSION,
@@ -70,6 +91,11 @@ static const struct ath6kl_hw hw_list[] = {
 		.board_ext_data_addr		= 0x437000,
 		.reserved_ram_size		= 11264,
 		.board_addr			= 0x43d400,
+
+		.fw			= AR6004_HW_1_1_FIRMWARE_FILE,
+		.fw_api2		= AR6004_HW_1_1_FIRMWARE_2_FILE,
+		.fw_board		= AR6004_HW_1_1_BOARD_DATA_FILE,
+		.fw_default_board	= AR6004_HW_1_1_DEFAULT_BOARD_DATA_FILE,
 	},
 };
 
@@ -652,17 +678,10 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	if (ar->fw_board != NULL)
 		return 0;
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_BOARD_DATA_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		filename = AR6004_HW_1_0_BOARD_DATA_FILE;
-		break;
-	default:
-		filename = AR6003_HW_2_1_1_BOARD_DATA_FILE;
-		break;
-	}
+	if (WARN_ON(ar->hw.fw_board == NULL))
+		return -EINVAL;
+
+	filename = ar->hw.fw_board;
 
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_board,
 			    &ar->fw_board_len);
@@ -680,17 +699,7 @@ static int ath6kl_fetch_board_file(struct ath6kl *ar)
 	ath6kl_warn("Failed to get board file %s (%d), trying to find default board file.\n",
 		    filename, ret);
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_DEFAULT_BOARD_DATA_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		filename = AR6004_HW_1_0_DEFAULT_BOARD_DATA_FILE;
-		break;
-	default:
-		filename = AR6003_HW_2_1_1_DEFAULT_BOARD_DATA_FILE;
-		break;
-	}
+	filename = ar->hw.fw_default_board;
 
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_board,
 			    &ar->fw_board_len);
@@ -714,19 +723,14 @@ static int ath6kl_fetch_otp_file(struct ath6kl *ar)
 	if (ar->fw_otp != NULL)
 		return 0;
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_OTP_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		ath6kl_dbg(ATH6KL_DBG_TRC, "AR6004 doesn't need OTP file\n");
+	if (ar->hw.fw_otp == NULL) {
+		ath6kl_dbg(ATH6KL_DBG_BOOT,
+			   "no OTP file configured for this hw\n");
 		return 0;
-		break;
-	default:
-		filename = AR6003_HW_2_1_1_OTP_FILE;
-		break;
 	}
 
+	filename = ar->hw.fw_otp;
+
 	ret = ath6kl_get_fw(ar, filename, &ar->fw_otp,
 			    &ar->fw_otp_len);
 	if (ret) {
@@ -747,38 +751,22 @@ static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 		return 0;
 
 	if (testmode) {
-		switch (ar->version.target_ver) {
-		case AR6003_HW_2_0_VERSION:
-			filename = AR6003_HW_2_0_TCMD_FIRMWARE_FILE;
-			break;
-		case AR6003_HW_2_1_1_VERSION:
-			filename = AR6003_HW_2_1_1_TCMD_FIRMWARE_FILE;
-			break;
-		case AR6004_HW_1_0_VERSION:
-			ath6kl_warn("testmode not supported with ar6004\n");
+		if (ar->hw.fw_tcmd == NULL) {
+			ath6kl_warn("testmode not supported\n");
 			return -EOPNOTSUPP;
-		default:
-			ath6kl_warn("unknown target version: 0x%x\n",
-				       ar->version.target_ver);
-			return -EINVAL;
 		}
 
+		filename = ar->hw.fw_tcmd;
+
 		set_bit(TESTMODE, &ar->flag);
 
 		goto get_fw;
 	}
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_FIRMWARE_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		filename = AR6004_HW_1_0_FIRMWARE_FILE;
-		break;
-	default:
-		filename = AR6003_HW_2_1_1_FIRMWARE_FILE;
-		break;
-	}
+	if (WARN_ON(ar->hw.fw == NULL))
+		return -EINVAL;
+
+	filename = ar->hw.fw;
 
 get_fw:
 	ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
@@ -796,27 +784,20 @@ static int ath6kl_fetch_patch_file(struct ath6kl *ar)
 	const char *filename;
 	int ret;
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_PATCH_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		/* FIXME: implement for AR6004 */
+	if (ar->fw_patch != NULL)
 		return 0;
-		break;
-	default:
-		filename = AR6003_HW_2_1_1_PATCH_FILE;
-		break;
-	}
 
-	if (ar->fw_patch == NULL) {
-		ret = ath6kl_get_fw(ar, filename, &ar->fw_patch,
-				    &ar->fw_patch_len);
-		if (ret) {
-			ath6kl_err("Failed to get patch file %s: %d\n",
-				   filename, ret);
-			return ret;
-		}
+	if (ar->hw.fw_patch == NULL)
+		return 0;
+
+	filename = ar->hw.fw_patch;
+
+	ret = ath6kl_get_fw(ar, filename, &ar->fw_patch,
+			    &ar->fw_patch_len);
+	if (ret) {
+		ath6kl_err("Failed to get patch file %s: %d\n",
+			   filename, ret);
+		return ret;
 	}
 
 	return 0;
@@ -851,22 +832,10 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	int ret, ie_id, i, index, bit;
 	__le32 *val;
 
-	switch (ar->version.target_ver) {
-	case AR6003_HW_2_0_VERSION:
-		filename = AR6003_HW_2_0_FIRMWARE_2_FILE;
-		break;
-	case AR6003_HW_2_1_1_VERSION:
-		filename = AR6003_HW_2_1_1_FIRMWARE_2_FILE;
-		break;
-	case AR6004_HW_1_0_VERSION:
-		filename = AR6004_HW_1_0_FIRMWARE_2_FILE;
-		break;
-	case AR6004_HW_1_1_VERSION:
-		filename = AR6004_HW_1_1_FIRMWARE_2_FILE;
-		break;
-	default:
+	if (ar->hw.fw_api2 == NULL)
 		return -EOPNOTSUPP;
-	}
+
+	filename = ar->hw.fw_api2;
 
 	ret = request_firmware(&fw, filename, ar->dev);
 	if (ret)

