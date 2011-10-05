Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56766 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884Ab1JEOQo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 10:16:44 -0400
Received: by wwf22 with SMTP id 22so2622618wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 07:16:43 -0700 (PDT)
From: Sangwook Lee <sangwook.lee@linaro.org>
To: kvalo@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, patches@linaro.org,
	Sangwook Lee <sangwook.lee@linaro.org>
Subject: [PATCH] ath6kl:Fix execution address of OTP AR6003 HW2.0
Date: Wed,  5 Oct 2011 15:14:37 +0100
Message-Id: <1317824077-13476-1-git-send-email-sangwook.lee@linaro.org> (sfid-20111005_161647_462177_ECB42A48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix OTP execution address for AR6003 HW2.0

ath6kl: writing otp to 0x543180 (3689 B)
ath6kl: bmi LZ stream start: addr: 0x543180)
ath6kl: bmi send LZ data: len: 3688)
ath6kl: bmi send LZ data: len: 4)
ath6kl: bmi LZ stream start: addr: 0x0)
ath6kl: bmi read memory: device: addr: 0x54061c, len: 4
ath6kl: app_start_override_addr 0x0
ath6kl: executing OTP at 0x0
ath6kl: bmi execute: addr: 0x0, param: 0)
ath6kl: bmi_recv_buf FIFO empty
ath6kl: Unable to read from the device: -22

Signed-off-by: Sangwook Lee <sangwook.lee@linaro.org>
---
 drivers/net/wireless/ath/ath6kl/init.c   |    3 +++
 drivers/net/wireless/ath/ath6kl/target.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index b277111..bfe802b 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1211,6 +1211,9 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 		return ret;
 	}
 
+	if (ar->version.target_ver == AR6003_REV2_VERSION)
+		address = AR6003_REV2_APP_START_OVERRIDE;
+	
 	ar->hw.app_start_override_addr = address;
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "app_start_override_addr 0x%x\n",
diff --git a/drivers/net/wireless/ath/ath6kl/target.h b/drivers/net/wireless/ath/ath6kl/target.h
index c9a7605..253c489 100644
--- a/drivers/net/wireless/ath/ath6kl/target.h
+++ b/drivers/net/wireless/ath/ath6kl/target.h
@@ -331,6 +331,7 @@ struct host_interest {
 	(((target_type) == TARGET_TYPE_AR6003) ? AR6003_VTOP(vaddr) : \
 	(((target_type) == TARGET_TYPE_AR6004) ? AR6004_VTOP(vaddr) : 0))
 
+#define AR6003_REV2_APP_START_OVERRIDE          0x944C00
 #define AR6003_REV2_APP_LOAD_ADDRESS            0x543180
 #define AR6003_REV2_BOARD_EXT_DATA_ADDRESS      0x57E500
 #define AR6003_REV2_DATASET_PATCH_ADDRESS       0x57e884
-- 
1.7.4.1

