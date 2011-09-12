Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:45811 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab1ILLMn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 07:12:43 -0400
Received: from saunalahti-vams (vs3-11.mail.saunalahti.fi [62.142.5.95])
	by emh02-2.mail.saunalahti.fi (Postfix) with SMTP id 6EE30EF6DD
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:42 +0300 (EEST)
Received: from localhost6.localdomain6 (a88-115-188-95.elisa-laajakaista.fi [88.115.188.95])
	by emh05.mail.saunalahti.fi (Postfix) with ESMTP id 4761327D8C
	for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 14:12:41 +0300 (EEST)
Subject: [PATCH 5/9] ath6kl: refactor firmware load address code
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Mon, 12 Sep 2011 14:12:40 +0300
Message-ID: <20110912111240.16921.28273.stgit@localhost6.localdomain6> (sfid-20110912_131245_880687_DFED8B21)
In-Reply-To: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
References: <20110912111206.16921.90687.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the load address was calculated everytime when it was needed,
and with a mess if clauses. Simplify this by adding a field to struct
ath6kl for each address and choose the address with simple switch
statements.

Also move the code just after target version is retrieved. That way it's
easier to override the values later in the boot process.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    6 +++
 drivers/net/wireless/ath/ath6kl/init.c |   76 +++++++++++++++-----------------
 2 files changed, 42 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 761e550..77783f8 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -462,6 +462,12 @@ struct ath6kl {
 		size_t rx_report_len;
 	} tm;
 
+	struct {
+		u32 dataset_patch_addr;
+		u32 app_load_addr;
+		u32 app_start_override_addr;
+	} hw;
+
 	u16 conf_flags;
 	wait_queue_head_t event_wq;
 	struct ath6kl_mbox_info mbox_info;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 41f4e0d..f94c049 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -56,12 +56,6 @@ module_param(testmode, uint, 0644);
 
 #define CONFIG_AR600x_DEBUG_UART_TX_PIN 8
 
-enum addr_type {
-	DATASET_PATCH_ADDR,
-	APP_LOAD_ADDR,
-	APP_START_OVERRIDE_ADDR,
-};
-
 #define ATH6KL_DATA_OFFSET    64
 struct sk_buff *ath6kl_buf_alloc(int size)
 {
@@ -636,30 +630,6 @@ int ath6kl_unavail_ev(struct ath6kl *ar)
 }
 
 /* firmware upload */
-static u32 ath6kl_get_load_address(u32 target_ver, enum addr_type type)
-{
-	WARN_ON(target_ver != AR6003_REV2_VERSION &&
-		target_ver != AR6003_REV3_VERSION &&
-		target_ver != AR6004_REV1_VERSION);
-
-	switch (type) {
-	case DATASET_PATCH_ADDR:
-		return (target_ver == AR6003_REV2_VERSION) ?
-			AR6003_REV2_DATASET_PATCH_ADDRESS :
-			AR6003_REV3_DATASET_PATCH_ADDRESS;
-	case APP_LOAD_ADDR:
-		return (target_ver == AR6003_REV2_VERSION) ?
-			AR6003_REV2_APP_LOAD_ADDRESS :
-			0x1234;
-	case APP_START_OVERRIDE_ADDR:
-		return (target_ver == AR6003_REV2_VERSION) ?
-			AR6003_REV2_APP_START_OVERRIDE :
-			AR6003_REV3_APP_START_OVERRIDE;
-	default:
-		return 0;
-	}
-}
-
 static int ath6kl_get_fw(struct ath6kl *ar, const char *filename,
 			 u8 **fw, size_t *fw_len)
 {
@@ -1179,8 +1149,7 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 	if (WARN_ON(ar->fw_otp == NULL))
 		return -ENOENT;
 
-	address = ath6kl_get_load_address(ar->version.target_ver,
-					  APP_LOAD_ADDR);
+	address = ar->hw.app_load_addr;
 
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw_otp,
 				       ar->fw_otp_len);
@@ -1191,8 +1160,7 @@ static int ath6kl_upload_otp(struct ath6kl *ar)
 
 	/* execute the OTP code */
 	param = 0;
-	address = ath6kl_get_load_address(ar->version.target_ver,
-					  APP_START_OVERRIDE_ADDR);
+	address = ar->hw.app_start_override_addr;
 	ath6kl_bmi_execute(ar, address, &param);
 
 	return ret;
@@ -1206,8 +1174,7 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 	if (WARN_ON(ar->fw == NULL))
 		return -ENOENT;
 
-	address = ath6kl_get_load_address(ar->version.target_ver,
-					  APP_LOAD_ADDR);
+	address = ar->hw.app_load_addr;
 
 	ret = ath6kl_bmi_fast_download(ar, address, ar->fw, ar->fw_len);
 
@@ -1221,8 +1188,7 @@ static int ath6kl_upload_firmware(struct ath6kl *ar)
 	 * Don't need to setup app_start override addr on AR6004
 	 */
 	if (ar->target_type != TARGET_TYPE_AR6004) {
-		address = ath6kl_get_load_address(ar->version.target_ver,
-						  APP_START_OVERRIDE_ADDR);
+		address = ar->hw.app_start_override_addr;
 		ath6kl_bmi_set_app_start(ar, address);
 	}
 	return ret;
@@ -1236,8 +1202,7 @@ static int ath6kl_upload_patch(struct ath6kl *ar)
 	if (WARN_ON(ar->fw_patch == NULL))
 		return -ENOENT;
 
-	address = ath6kl_get_load_address(ar->version.target_ver,
-					  DATASET_PATCH_ADDR);
+	address = ar->hw.dataset_patch_addr;
 
 	ret = ath6kl_bmi_write(ar, address, ar->fw_patch, ar->fw_patch_len);
 	if (ret) {
@@ -1384,6 +1349,33 @@ static int ath6kl_init_upload(struct ath6kl *ar)
 	return status;
 }
 
+static int ath6kl_init_hw_params(struct ath6kl *ar)
+{
+	switch (ar->version.target_ver) {
+	case AR6003_REV2_VERSION:
+		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
+		ar->hw.app_load_addr = AR6003_REV2_APP_LOAD_ADDRESS;
+		ar->hw.app_start_override_addr = AR6003_REV2_APP_START_OVERRIDE;
+		break;
+	case AR6003_REV3_VERSION:
+		ar->hw.dataset_patch_addr = AR6003_REV3_DATASET_PATCH_ADDRESS;
+		ar->hw.app_load_addr = 0x1234;
+		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
+		break;
+	case AR6004_REV1_VERSION:
+		ar->hw.dataset_patch_addr = AR6003_REV2_DATASET_PATCH_ADDRESS;
+		ar->hw.app_load_addr = AR6003_REV3_APP_LOAD_ADDRESS;
+		ar->hw.app_start_override_addr = AR6003_REV3_APP_START_OVERRIDE;
+		break;
+	default:
+		ath6kl_err("Unsupported hardware version: 0x%x\n",
+			   ar->version.target_ver);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ath6kl_init(struct net_device *dev)
 {
 	struct ath6kl *ar = ath6kl_priv(dev);
@@ -1523,6 +1515,10 @@ int ath6kl_core_init(struct ath6kl *ar)
 	ar->target_type = le32_to_cpu(targ_info.type);
 	ar->wdev->wiphy->hw_version = le32_to_cpu(targ_info.version);
 
+	ret = ath6kl_init_hw_params(ar);
+	if (ret)
+		goto err_bmi_cleanup;
+
 	ret = ath6kl_configure_target(ar);
 	if (ret)
 		goto err_bmi_cleanup;

