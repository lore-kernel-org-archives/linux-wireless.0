Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27286 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1JFKuR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 06:50:17 -0400
Message-ID: <4E8D8766.1030809@qca.qualcomm.com> (sfid-20111006_125022_840127_51560A68)
Date: Thu, 6 Oct 2011 13:48:06 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: <linux-wireless@vger.kernel.org>, <patches@linaro.org>
Subject: Re: [PATCH] ath6kl:Fix execution address of OTP AR6003 HW2.0
References: <1317824077-13476-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1317824077-13476-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: multipart/mixed;
	boundary="------------000603040702080902080409"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------000603040702080902080409
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 10/05/2011 05:14 PM, Sangwook Lee wrote:
> Fix OTP execution address for AR6003 HW2.0
> 
> ath6kl: writing otp to 0x543180 (3689 B)
> ath6kl: bmi LZ stream start: addr: 0x543180)
> ath6kl: bmi send LZ data: len: 3688)
> ath6kl: bmi send LZ data: len: 4)
> ath6kl: bmi LZ stream start: addr: 0x0)
> ath6kl: bmi read memory: device: addr: 0x54061c, len: 4
> ath6kl: app_start_override_addr 0x0
> ath6kl: executing OTP at 0x0
> ath6kl: bmi execute: addr: 0x0, param: 0)
> ath6kl: bmi_recv_buf FIFO empty
> ath6kl: Unable to read from the device: -22

Ah, now I understand. So this patch broke it:

commit 639d0b8996aa5913402b846932d57a51a23a40c9
Author: Kalle Valo <kvalo@qca.qualcomm.com>
Date:   Mon Sep 12 12:48:09 2011 +0300

    ath6kl: read firmware start address from hardware

    It's actually possible to read the firmware start address from hardware,
    that way there's no need to hardcode the address in hardware.


So the firmware start address detections doesn't actually work with hw
2.0, too bad.

Actually I would like to fix this a bit differently, can you please try
the attached patch? Compile tested only. If it works, please send me a
Tested-by tag.

BTW, do you still need to enable debug logs to get hw2.0 working properly?

Kalle

--------------000603040702080902080409
Content-Type: text/x-patch;
	name="0001-ath6kl-fix-firmware-start-address-for-ar6003-hw2.0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-ath6kl-fix-firmware-start-address-for-ar6003-hw2.0.patc";
	filename*1="h"

>From e982bc13435b3f5dca76c77d472dcd2cfcba2b66 Mon Sep 17 00:00:00 2001
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Thu, 6 Oct 2011 13:26:58 +0300
Subject: [PATCH] ath6kl: fix firmware start address for ar6003 hw2.0

Sangwook found out that commit 639d0b89 ("ath6kl: read firmware start
address from hardware") broke firmware boot on ar6003 hw2.0 as it seems
it's not posible to automatically query the address from hardware. So
we need to hardcode the address for hw2.0.

Reported-by: Sangwook Lee <sangwook.lee@linaro.org>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   34 ++++++++++++++++++++-----------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 8466f3d..d52c925 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1182,6 +1182,7 @@ static int ath6kl_upload_board_file(struct ath6kl *ar)
 static int ath6kl_upload_otp(struct ath6kl *ar)
 {
 	u32 address, param;
+	bool from_hw = false;
 	int ret;
 
 	if (WARN_ON(ar->fw_otp == NULL))
@@ -1199,24 +1200,29 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 		return ret;
 	}
 
-	/* read firmware start address */
-	ret = ath6kl_bmi_read(ar,
-			      ath6kl_get_hi_item_addr(ar,
-						      HI_ITEM(hi_app_start)),
-			      (u8 *) &address, sizeof(address));
+	if (ar->hw.app_start_override_addr == 0) {
+		/* read firmware start address */
+		ret = ath6kl_bmi_read(ar,
+				      ath6kl_get_hi_item_addr(ar,
+							      HI_ITEM(hi_app_start)),
+				      (u8 *) &address, sizeof(address));
 
-	if (ret) {
-		ath6kl_err("Failed to read hi_app_start: %d\n", ret);
-		return ret;
-	}
+		if (ret) {
+			ath6kl_err("Failed to read hi_app_start: %d\n", ret);
+			return ret;
+		}
 
-	ar->hw.app_start_override_addr = address;
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
 	ath6kl_bmi_execute(ar, address, &param);
 
@@ -1420,6 +1426,10 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
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
1.7.1


--------------000603040702080902080409--
