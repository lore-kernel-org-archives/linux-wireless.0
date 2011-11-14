Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:34532 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1KNRaf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:30:35 -0500
Subject: [PATCH 02/10] ath6kl: move hw version related to parameters to struct
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:30:29 +0200
Message-ID: <20111114173029.29925.63000.stgit@localhost6.localdomain6> (sfid-20111114_183037_880354_18ECDB07)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's easier to handle the values when they are defined in a struct.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    3 +
 drivers/net/wireless/ath/ath6kl/init.c |   73 ++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 03e378d..f5a8334 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -541,7 +541,8 @@ struct ath6kl {
 		size_t rx_report_len;
 	} tm;
 
-	struct {
+	struct ath6kl_hw {
+		u32 id;
 		u32 dataset_patch_addr;
 		u32 app_load_addr;
 		u32 app_start_override_addr;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 3286b1b..77444d1 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -33,6 +33,40 @@ module_param(debug_mask, uint, 0644);
 module_param(testmode, uint, 0644);
 module_param(suspend_cutpower, bool, 0444);
 
+static const struct ath6kl_hw hw_list[] = {
+	{
+		.id				= AR6003_REV2_VERSION,
+		.dataset_patch_addr		= 0x57e884,
+		.app_load_addr			= 0x543180,
+		.board_ext_data_addr		= 0x57e500,
+		.reserved_ram_size		= 6912,
+
+		/* hw2.0 needs override address hardcoded */
+		.app_start_override_addr	= 0x944C00,
+	},
+	{
+		.id				= AR6003_REV3_VERSION,
+		.dataset_patch_addr		= 0x57ff74,
+		.app_load_addr			= 0x1234,
+		.board_ext_data_addr		= 0x542330,
+		.reserved_ram_size		= 512,
+	},
+	{
+		.id				= AR6004_REV1_VERSION,
+		.dataset_patch_addr		= 0x57e884,
+		.app_load_addr			= 0x1234,
+		.board_ext_data_addr		= 0x437000,
+		.reserved_ram_size		= 19456,
+	},
+	{
+		.id				= AR6004_REV2_VERSION,
+		.dataset_patch_addr		= 0x57e884,
+		.app_load_addr			= 0x1234,
+		.board_ext_data_addr		= 0x437000,
+		.reserved_ram_size		= 11264,
+	},
+};
+
 /*
  * Include definitions here that can be used to tune the WLAN module
  * behavior. Different customers can tune the behavior as per their needs,
@@ -1335,41 +1369,24 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 
 static int ath6kl_init_hw_params(struct ath6kl *ar)
 {
-	switch (ar->version.target_ver) {
-	case AR6003_REV2_VERSION:
-		ar->hw.dataset_patch_addr = 0x57e884;
-		ar->hw.app_load_addr = 0x543180;
-		ar->hw.board_ext_data_addr = 0x57e500;
-		ar->hw.reserved_ram_size = 6912;
+	const struct ath6kl_hw *hw;
+	int i;
 
-		/* hw2.0 needs override address hardcoded */
-		ar->hw.app_start_override_addr = 0x944C00;
+	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
+		hw = &hw_list[i];
 
-		break;
-	case AR6003_REV3_VERSION:
-		ar->hw.dataset_patch_addr = 0x57ff74;
-		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = 0x542330;
-		ar->hw.reserved_ram_size = 512;
-		break;
-	case AR6004_REV1_VERSION:
-		ar->hw.dataset_patch_addr = 0x57e884;
-		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = 0x437000;
-		ar->hw.reserved_ram_size = 19456;
-		break;
-	case AR6004_REV2_VERSION:
-		ar->hw.dataset_patch_addr = 0x57e884;
-		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = 0x437000;
-		ar->hw.reserved_ram_size = 11264;
-		break;
-	default:
+		if (hw->id == ar->version.target_ver)
+			break;
+	}
+
+	if (i == ARRAY_SIZE(hw_list)) {
 		ath6kl_err("Unsupported hardware version: 0x%x\n",
 			   ar->version.target_ver);
 		return -EINVAL;
 	}
 
+	ar->hw = *hw;
+
 	ath6kl_dbg(ATH6KL_DBG_BOOT,
 		   "target_ver 0x%x target_type 0x%x dataset_patch 0x%x app_load_addr 0x%x\n",
 		   ar->version.target_ver, ar->target_type,

