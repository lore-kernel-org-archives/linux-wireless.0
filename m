Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35659 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754778Ab1JFNOM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 09:14:12 -0400
Received: by gyg10 with SMTP id 10so2540522gyg.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 06:14:11 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath6kl: fix firmware start address for ar6003 hw2.0
Date: Thu,  6 Oct 2011 14:12:05 +0100
Message-Id: <1317906725-31130-1-git-send-email-sangwook.lee@linaro.org> (sfid-20111006_151415_477769_004A8CDD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@qca.qualcomm.com>

Sangwook found out that commit 639d0b89 ("ath6kl: read firmware start
address from hardware") broke firmware boot on ar6003 hw2.0 as it seems
it's not posible to automatically query the address from hardware. So
we need to hardcode the address for hw2.0.

Reported-by: Sangwook Lee <sangwook.lee@linaro.org>
Tested-by: Sangwook Lee <sangwook.lee@linaro.org>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
Kalle:
I slightly changed again. without running ath6kl_bmi_read() before,
ath6kl_bmi_execute() failed with hw2.0 board, but I am not clear about this reason.

 drivers/net/wireless/ath/ath6kl/init.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index b277111..07a6a44 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1183,6 +1183,7 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 static int ath6kl_upload_otp(struct ath6kl *ar)
 {
 	u32 address, param;
+	bool from_hw = false;
 	int ret;
 
 	if (WARN_ON(ar->fw_otp == NULL))
@@ -1201,25 +1202,28 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 	}
 
 	/* read firmware start address */
-	ret = ath6kl_bmi_read(ar,
-			      ath6kl_get_hi_item_addr(ar,
-						      HI_ITEM(hi_app_start)),
-			      (u8 *) &address, sizeof(address));
+	ret = ath6kl_bmi_read(ar, ath6kl_get_hi_item_addr(ar,
+		HI_ITEM(hi_app_start)), (u8 *) &address, sizeof(address));
 
 	if (ret) {
 		ath6kl_err("Failed to read hi_app_start: %d\n", ret);
 		return ret;
 	}
 
-	ar->hw.app_start_override_addr = address;
+	if (ar->hw.app_start_override_addr == 0) {
+		ar->hw.app_start_override_addr = address;
+		from_hw = true;
+	}
 
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "app_start_override_addr 0x%x\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "app_start_override_addr%s 0x%x\n",
+		   from_hw ? " (from hw)" : "",
 		   ar->hw.app_start_override_addr);
 
 	/* execute the OTP code */
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "executing OTP at 0x%x\n", address);
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "executing OTP at 0x%x\n",
+		   ar->hw.app_start_override_addr);
 	param = 0;
-	ath6kl_bmi_execute(ar, address, &param);
+	ath6kl_bmi_execute(ar, ar->hw.app_start_override_addr, &param);
 
 	return ret;
 }
@@ -1421,6 +1425,10 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 		ar->hw.app_load_addr = AR6003_REV2_APP_LOAD_ADDRESS;
 		ar->hw.board_ext_data_addr = AR6003_REV2_BOARD_EXT_DATA_ADDRESS;
 		ar->hw.reserved_ram_size = AR6003_REV2_RAM_RESERVE_SIZE;
+
+		/* hw2.0 needs override address hardcoded */
+		ar->hw.app_start_override_addr = 0x944C00;
+
 		break;
 	case AR6003_REV3_VERSION:
 		ar->hw.dataset_patch_addr = AR6003_REV3_DATASET_PATCH_ADDRESS;
-- 
1.7.4.1

