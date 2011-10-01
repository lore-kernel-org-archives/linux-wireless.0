Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:35728 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab1JAGwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 02:52:14 -0400
Subject: [PATCH] ath6kl: fix size_t related warnings
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 01 Oct 2011 09:52:02 +0300
Message-ID: <20111001065201.25817.35530.stgit@localhost6.localdomain6> (sfid-20111001_085224_519351_E437989E)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My earlier debug log additions added these warnings when compiling 64 bit
kernels:

ath6kl/init.c:962: warning: format ‘%d’ expects type ‘int’,
  but argument 3 has type ‘size_t’
ath6kl/init.c:975: warning: format ‘%d’ expects type ‘int’,
  but argument 3 has type ‘size_t’
ath6kl/init.c:988: warning: format ‘%d’ expects type ‘int’,
  but argument 3 has type ‘size_t’
ath6kl/init.c:1009: warning: format ‘%d’ expects type ‘int’,
  but argument 3 has type ‘size_t’
ath6kl/init.c:1192: warning: format ‘%d’ expects type ‘int’,
  but argument 4 has type ‘size_t’
ath6kl/init.c:1236: warning: format ‘%d’ expects type ‘int’,
  but argument 4 has type ‘size_t’
ath6kl/init.c:1267: warning: format ‘%d’ expects type ‘int’,
  but argument 4 has type ‘size_t’

Reported-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 5995bb9..c1d2366 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -959,7 +959,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 
 		switch (ie_id) {
 		case ATH6KL_FW_IE_OTP_IMAGE:
-			ath6kl_dbg(ATH6KL_DBG_BOOT, "found otp image ie (%d B)\n",
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found otp image ie (%zd B)\n",
 				ie_len);
 
 			ar->fw_otp = kmemdup(data, ie_len, GFP_KERNEL);
@@ -972,7 +972,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->fw_otp_len = ie_len;
 			break;
 		case ATH6KL_FW_IE_FW_IMAGE:
-			ath6kl_dbg(ATH6KL_DBG_BOOT, "found fw image ie (%d B)\n",
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found fw image ie (%zd B)\n",
 				ie_len);
 
 			ar->fw = kmemdup(data, ie_len, GFP_KERNEL);
@@ -985,7 +985,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			ar->fw_len = ie_len;
 			break;
 		case ATH6KL_FW_IE_PATCH_IMAGE:
-			ath6kl_dbg(ATH6KL_DBG_BOOT, "found patch image ie (%d B)\n",
+			ath6kl_dbg(ATH6KL_DBG_BOOT, "found patch image ie (%zd B)\n",
 				ie_len);
 
 			ar->fw_patch = kmemdup(data, ie_len, GFP_KERNEL);
@@ -1007,7 +1007,7 @@ static int ath6kl_fetch_fw_api2(struct ath6kl *ar)
 			break;
 		case ATH6KL_FW_IE_CAPABILITIES:
 			ath6kl_dbg(ATH6KL_DBG_BOOT,
-				   "found firmware capabilities ie (%d B)\n",
+				   "found firmware capabilities ie (%zd B)\n",
 				   ie_len);
 
 			for (i = 0; i < ATH6KL_FW_CAPABILITY_MAX; i++) {
@@ -1189,7 +1189,7 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 
 	address = ar->hw.app_load_addr;
 
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing otp to 0x%x (%d B)\n", address,
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing otp to 0x%x (%zd B)\n", address,
 		   ar->fw_otp_len);
 
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw_otp,
@@ -1233,7 +1233,7 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 
 	address = ar->hw.app_load_addr;
 
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing firmware to 0x%x (%d B)\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing firmware to 0x%x (%zd B)\n",
 		   address, ar->fw_len);
 
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw, ar->fw_len);
@@ -1264,7 +1264,7 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 
 	address = ar->hw.dataset_patch_addr;
 
-	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing patch to 0x%x (%d B)\n",
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "writing patch to 0x%x (%zd B)\n",
 		   address, ar->fw_patch_len);
 
 	ret = ath6kl_bmi_write(ar, address, ar->fw_patch, ar->fw_patch_len);

