Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:37065 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1KNRaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:30:25 -0500
Subject: [PATCH 01/10] ath6kl: remove hw version related parameter defines
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:30:13 +0200
Message-ID: <20111114173013.29925.97884.stgit@localhost6.localdomain6> (sfid-20111114_183028_890408_93383A69)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Having separate defines, in a different file, makes it difficult to read
the actual values. As we are just setting named fields in a struct
the defines don't make any sense anymore.

There are no functional changes, only moving of constants.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c   |   26 +++++++++++++-------------
 drivers/net/wireless/ath/ath6kl/target.h |   14 --------------
 2 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index e96ce07..3286b1b 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1337,32 +1337,32 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 {
 	switch (ar->version.target_ver) {
 	case AR6003_REV2_VERSION:
-		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
-		ar->hw.app_load_addr = AR6003_REV2_APP_LOAD_ADDRESS;
-		ar->hw.board_ext_data_addr = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
-		ar->hw.reserved_ram_size = AR6003_REV2_RAM_RESERVE_SIZE;
+		ar->hw.dataset_patch_addr = 0x57e884;
+		ar->hw.app_load_addr = 0x543180;
+		ar->hw.board_ext_data_addr = 0x57e500;
+		ar->hw.reserved_ram_size = 6912;
 
 		/* hw2.0 needs override address hardcoded */
 		ar->hw.app_start_override_addr = 0x944C00;
 
 		break;
 	case AR6003_REV3_VERSION:
-		ar->hw.dataset_patch_addr = AR6003_REV3_DATASET_PATCH_ADDRESS;
+		ar->hw.dataset_patch_addr = 0x57ff74;
 		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
-		ar->hw.reserved_ram_size = AR6003_REV3_RAM_RESERVE_SIZE;
+		ar->hw.board_ext_data_addr = 0x542330;
+		ar->hw.reserved_ram_size = 512;
 		break;
 	case AR6004_REV1_VERSION:
-		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
+		ar->hw.dataset_patch_addr = 0x57e884;
 		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
-		ar->hw.reserved_ram_size = AR6004_REV1_RAM_RESERVE_SIZE;
+		ar->hw.board_ext_data_addr = 0x437000;
+		ar->hw.reserved_ram_size = 19456;
 		break;
 	case AR6004_REV2_VERSION:
-		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
+		ar->hw.dataset_patch_addr = 0x57e884;
 		ar->hw.app_load_addr = 0x1234;
-		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
-		ar->hw.reserved_ram_size = AR6004_REV2_RAM_RESERVE_SIZE;
+		ar->hw.board_ext_data_addr = 0x437000;
+		ar->hw.reserved_ram_size = 11264;
 		break;
 	default:
 		ath6kl_err("Unsupported hardware version: 0x%x\n",
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 35478d4..ece0f13 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -334,22 +334,8 @@ struct host_interest {
 	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
 	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
 
-#define AR6003_REV2_APP_LOAD_ADDRESS            0x543180
-#define AR6003_REV2_BOARD_EXT_DATA_ADDRESS      0x57E500
-#define AR6003_REV2_DATASET_PATCH_ADDRESS       0x57e884
-#define AR6003_REV2_RAM_RESERVE_SIZE            6912
-
-#define AR6003_REV3_APP_LOAD_ADDRESS            0x545000
-#define AR6003_REV3_BOARD_EXT_DATA_ADDRESS      0x542330
-#define AR6003_REV3_DATASET_PATCH_ADDRESS       0x57FF74
-#define AR6003_REV3_RAM_RESERVE_SIZE            512
-
 #define AR6004_REV1_BOARD_DATA_ADDRESS          0x433900
-#define AR6004_REV1_BOARD_EXT_DATA_ADDRESS      0x437000
-#define AR6004_REV1_RAM_RESERVE_SIZE            19456
-
 #define AR6004_REV2_BOARD_DATA_ADDRESS          0x43d400
-#define AR6004_REV2_RAM_RESERVE_SIZE            11264
 
 #define ATH6KL_FWLOG_PAYLOAD_SIZE		1500
 

