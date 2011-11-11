Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:37746 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab1KKKSL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Nov 2011 05:18:11 -0500
Subject: [PATCH 05/10] ath6kl: firmware boot fixes for ar6004
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 11 Nov 2011 12:18:06 +0200
Message-ID: <20111111101806.12075.41071.stgit@localhost6.localdomain6> (sfid-20111111_111814_180776_1CAD95C9)
In-Reply-To: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
References: <20111111101551.12075.94865.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These have changed a bit since last time ar6004 code was commited.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   34 +++++++++++++++++++++++---------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index df43fdb..1446d7e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -821,6 +821,9 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 	case AR6004_REV1_VERSION:
 		filename = AR6004_REV1_FIRMWARE_2_FILE;
 		break;
+	case AR6004_REV2_VERSION:
+		filename = AR6004_REV2_FIRMWARE_2_FILE;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -995,7 +998,11 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 	 * writing board data.
 	 */
 	if (ar->target_type == TARGET_TYPE_AR6004) {
-		board_address = AR6004_REV1_BOARD_DATA_ADDRESS;
+		if (ar->version.target_ver == AR6004_REV1_VERSION)
+			board_address = AR6004_REV1_BOARD_DATA_ADDRESS;
+		else
+			board_address = AR6004_REV2_BOARD_DATA_ADDRESS;
+
 		ath6kl_bmi_write(ar,
 				ath6kl_get_hi_item_addr(ar,
 				HI_ITEM(hi_board_data)),
@@ -1013,7 +1020,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 			HI_ITEM(hi_board_ext_data)),
 			(u8 *) &board_ext_address, 4);
 
-	if (board_ext_address == 0) {
+	if (ar->target_type == TARGET_TYPE_AR6003 &&
+	    board_ext_address == 0) {
 		ath6kl_err("Failed to get board file target address.\n");
 		return -EINVAL;
 	}
@@ -1033,8 +1041,8 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 		break;
 	}
 
-	if (ar->fw_board_len == (board_data_size +
-				 board_ext_data_size)) {
+	if (board_ext_address &&
+	    ar->fw_board_len == (board_data_size + board_ext_data_size)) {
 
 		/* write extended board data */
 		ath6kl_dbg(ATH6KL_DBG_BOOT,
@@ -1092,8 +1100,8 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 	bool from_hw = false;
 	int ret;
 
-	if (WARN_ON(ar->fw_otp == NULL))
-		return -ENOENT;
+	if (ar->fw_otp == NULL)
+		return 0;
 
 	address = ar->hw.app_load_addr;
 
@@ -1142,7 +1150,7 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 	int ret;
 
 	if (WARN_ON(ar->fw == NULL))
-		return -ENOENT;
+		return 0;
 
 	address = ar->hw.app_load_addr;
 
@@ -1172,8 +1180,8 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 	u32 address, param;
 	int ret;
 
-	if (WARN_ON(ar->fw_patch == NULL))
-		return -ENOENT;
+	if (ar->fw_patch == NULL)
+		return 0;
 
 	address = ar->hw.dataset_patch_addr;
 
@@ -1346,10 +1354,16 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		break;
 	case AR6004_REV1_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
-		ar->hw.app_load_addr = AR6003_REV3_APP_LOAD_ADDRESS;
+		ar->hw.app_load_addr = 0x1234;
 		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
 		ar->hw.reserved_ram_size = AR6004_REV1_RAM_RESERVE_SIZE;
 		break;
+	case AR6004_REV2_VERSION:
+		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
+		ar->hw.app_load_addr = 0x1234;
+		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
+		ar->hw.reserved_ram_size = AR6004_REV2_RAM_RESERVE_SIZE;
+		break;
 	default:
 		ath6kl_err("Unsupported hardware version: 0x%x\n",
 			   ar->version.target_ver);

