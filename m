Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:48997 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884Ab1ILLM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:57 -0400
Received: from saunalahti-vams (vs3-12.mail.saunalahti.fi [62.142.5.96])
	by emh07-2.mail.saunalahti.fi (Postfix) with SMTP id 258F218CFD0
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:56 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh04.mail.saunalahti.fi (Postfix) with ESMTP id 10E9241BE3
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:54 +0300 (EEST)
Subject: [PATCH 7/9] ath6kl: read firmware start address from hardware
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:54 +0300
Message-ID: <20110912111254.16921.7357.stgit@localhost6.localdomain6> (sfid-20110912_131259_453718_CE8F6995)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's actually possible to read the firmware start address from hardware,
that way there's no need to hardcore the address in hardware.

Thanks to Chilam Ng for the idea.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c   |   17 +++++++++++++----
 drivers/net/wireless/ath/ath6kl/target.h |    2 --
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index bf0385e..5865466 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1146,9 +1146,21 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 		return ret;
 	}
 
+	/* read firmware start address */
+	ret = ath6kl_bmi_read(ar,
+			      ath6kl_get_hi_item_addr(ar,
+						      HI_ITEM(hi_app_start)),
+			      (u8 *) &address, sizeof(address));
+
+	if (ret) {
+		ath6kl_err("Failed to read hi_app_start: %d\n", ret);
+		return ret;
+	}
+
+	ar->hw.app_start_override_addr = address;
+
 	/* execute the OTP code */
 	param = 0;
-	address = ar->hw.app_start_override_addr;
 	ath6kl_bmi_execute(ar, address, &param);
 
 	return ret;
@@ -1343,21 +1355,18 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	case AR6003_REV2_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = AR6003_REV2_APP_LOAD_ADDRESS;
-		ar->hw.app_start_override_addr = AR6003_REV2_APP_START_OVERRIDE;
 		ar->hw.board_ext_data_addr = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
 		ar->hw.reserved_ram_size = AR6003_REV2_RAM_RESERVE_SIZE;
 		break;
 	case AR6003_REV3_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV3_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = 0x1234;
-		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
 		ar->hw.board_ext_data_addr = AR6003_REV3_BOARD_EXT_DATA_ADDRESS;
 		ar->hw.reserved_ram_size = AR6003_REV3_RAM_RESERVE_SIZE;
 		break;
 	case AR6004_REV1_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
 		ar->hw.app_load_addr = AR6003_REV3_APP_LOAD_ADDRESS;
-		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
 		ar->hw.board_ext_data_addr = AR6004_REV1_BOARD_EXT_DATA_ADDRESS;
 		ar->hw.reserved_ram_size = AR6004_REV1_RAM_RESERVE_SIZE;
 		break;
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index 7db06a5..c9a7605 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -331,13 +331,11 @@ struct host_interest {
 	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
 	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
 
-#define AR6003_REV2_APP_START_OVERRIDE          0x944C00
 #define AR6003_REV2_APP_LOAD_ADDRESS            0x543180
 #define AR6003_REV2_BOARD_EXT_DATA_ADDRESS      0x57E500
 #define AR6003_REV2_DATASET_PATCH_ADDRESS       0x57e884
 #define AR6003_REV2_RAM_RESERVE_SIZE            6912
 
-#define AR6003_REV3_APP_START_OVERRIDE          0x945d00
 #define AR6003_REV3_APP_LOAD_ADDRESS            0x545000
 #define AR6003_REV3_BOARD_EXT_DATA_ADDRESS      0x542330
 #define AR6003_REV3_DATASET_PATCH_ADDRESS       0x57FF74

