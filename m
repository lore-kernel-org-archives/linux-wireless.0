Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:55197 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1ILLMu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:50 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh01-2.mail.saunalahti.fi (Postfix) with SMTP id 087358C735
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:49 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh03.mail.saunalahti.fi (Postfix) with ESMTP id E4A1E158A64
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:47 +0300 (EEST)
Subject: [PATCH 6/9] ath6kl: refactor firmware ext data addr and reserved ram
	handling size
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:47 +0300
Message-ID: <20110912111247.16921.73934.stgit@localhost6.localdomain6> (sfid-20110912_131252_239317_60772713)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Less if clauses this way and again easier to override the values.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +
 drivers/net/wireless/ath/ath6kl/init.c |   46 ++++++++++++++------------------
 2 files changed, 22 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 77783f8..3365dc8 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -466,6 +466,8 @@ struct ath6kl {
 		u32 dataset_patch_addr;
 		u32 app_load_addr;
 		u32 app_start_override_addr;
+		u32 board_ext_data_addr;
+		u32 reserved_ram_size;
 	} hw;
 
 	u16 conf_flags;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index f94c049..bf0385e 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -527,33 +527,21 @@ int ath6kl_configure_target(struct ath6kl *ar)
 	 * but possible in theory.
 	 */
 
-	if (ar->target_type == TARGET_TYPE_AR6003 ||
-	    ar->target_type == TARGET_TYPE_AR6004) {
-		if (ar->version.target_ver == AR6003_REV2_VERSION) {
-			param = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
-			ram_reserved_size =  AR6003_REV2_RAM_RESERVE_SIZE;
-		} else if (ar->version.target_ver == AR6004_REV1_VERSION) {
-			param = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
-			ram_reserved_size =  AR6004_REV1_RAM_RESERVE_SIZE;
-		} else {
-			param = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
-			ram_reserved_size =  AR6003_REV3_RAM_RESERVE_SIZE;
-		}
+	param = ar->hw.board_ext_data_addr;
+	ram_reserved_size = ar->hw.reserved_ram_size;
 
-		if (ath6kl_bmi_write(ar,
-				     ath6kl_get_hi_item_addr(ar,
-				     HI_ITEM(hi_board_ext_data)),
-				     (u8 *)&param, 4) != 0) {
-			ath6kl_err("bmi_write_memory for hi_board_ext_data failed\n");
-			return -EIO;
-		}
-		if (ath6kl_bmi_write(ar,
-				     ath6kl_get_hi_item_addr(ar,
-				     HI_ITEM(hi_end_ram_reserve_sz)),
-				     (u8 *)&ram_reserved_size, 4) != 0) {
-			ath6kl_err("bmi_write_memory for hi_end_ram_reserve_sz failed\n");
-			return -EIO;
-		}
+	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
+					HI_ITEM(hi_board_ext_data)),
+			     (u8 *)&param, 4) != 0) {
+		ath6kl_err("bmi_write_memory for hi_board_ext_data failed\n");
+		return -EIO;
+	}
+
+	if (ath6kl_bmi_write(ar, ath6kl_get_hi_item_addr(ar,
+					HI_ITEM(hi_end_ram_reserve_sz)),
+			     (u8 *)&ram_reserved_size, 4) != 0) {
+		ath6kl_err("bmi_write_memory for hi_end_ram_reserve_sz failed\n");
+		return -EIO;
 	}
 
 	/* set the block size for the target */
@@ -1356,16 +1344,22 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = AR6003_REV2_APP_LOAD_ADDRESS;
 		ar->hw.app_start_override_addr = AR6003_REV2_APP_START_OVERRIDE;
+		ar->hw.board_ext_data_addr = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
+		ar->hw.reserved_ram_size = AR6003_REV2_RAM_RESERVE_SIZE;
 		break;
 	case AR6003_REV3_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV3_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = 0x1234;
 		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
+		ar->hw.board_ext_data_addr = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
+		ar->hw.reserved_ram_size = AR6003_REV3_RAM_RESERVE_SIZE;
 		break;
 	case AR6004_REV1_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = AR6003_REV3_APP_LOAD_ADDRESS;
 		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
+		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
+		ar->hw.reserved_ram_size = AR6004_REV1_RAM_RESERVE_SIZE;
 		break;
 	default:
 		ath6kl_err("Unsupported hardware version: 0x%x\n",

