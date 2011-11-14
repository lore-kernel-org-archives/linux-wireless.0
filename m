Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh06.mail.saunalahti.fi ([62.142.5.116]:50603 "EHLO
	emh06.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab1KNRbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 12:31:04 -0500
Subject: [PATCH 05/10] ath6kl: add name field to struct ath6kl_hw
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 14 Nov 2011 19:30:54 +0200
Message-ID: <20111114173054.29925.67004.stgit@localhost6.localdomain6> (sfid-20111114_183106_943589_29B10B87)
In-Reply-To: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
References: <20111114172836.29925.4134.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

To make it easier to print name for each hardware type. Also move the hw
info print to ath6kl_init_hw_start() which is more logical place for it.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    1 +
 drivers/net/wireless/ath/ath6kl/init.c |   25 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/main.c |   21 ---------------------
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 6227f11..b034001 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -544,6 +544,7 @@ struct ath6kl {
 
 	struct ath6kl_hw {
 		u32 id;
+		const char *name;
 		u32 dataset_patch_addr;
 		u32 app_load_addr;
 		u32 app_start_override_addr;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 0b0ae5e..acfe79a 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -36,6 +36,7 @@ module_param(suspend_cutpower, bool, 0444);
 static const struct ath6kl_hw hw_list[] = {
 	{
 		.id				= AR6003_REV2_VERSION,
+		.name				= "ar6003 hw 2.0",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x543180,
 		.board_ext_data_addr		= 0x57e500,
@@ -46,6 +47,7 @@ static const struct ath6kl_hw hw_list[] = {
 	},
 	{
 		.id				= AR6003_REV3_VERSION,
+		.name				= "ar6003 hw 2.1.1",
 		.dataset_patch_addr		= 0x57ff74,
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x542330,
@@ -53,6 +55,7 @@ static const struct ath6kl_hw hw_list[] = {
 	},
 	{
 		.id				= AR6004_REV1_VERSION,
+		.name				= "ar6004 hw 1.0",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x437000,
@@ -61,6 +64,7 @@ static const struct ath6kl_hw hw_list[] = {
 	},
 	{
 		.id				= AR6004_REV2_VERSION,
+		.name				= "ar6004 hw 1.1",
 		.dataset_patch_addr		= 0x57e884,
 		.app_load_addr			= 0x1234,
 		.board_ext_data_addr		= 0x437000,
@@ -1408,6 +1412,18 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
 	return 0;
 }
 
+static const char *ath6kl_init_get_hif_name(enum ath6kl_hif_type type)
+{
+	switch (type) {
+	case ATH6KL_HIF_TYPE_SDIO:
+		return "sdio";
+	case ATH6KL_HIF_TYPE_USB:
+		return "usb";
+	}
+
+	return NULL;
+}
+
 int ath6kl_init_hw_start(struct ath6kl *ar)
 {
 	long timeleft;
@@ -1468,6 +1484,15 @@ int ath6kl_init_hw_start(struct ath6kl *ar)
 
 	ath6kl_dbg(ATH6KL_DBG_BOOT, "firmware booted\n");
 
+
+	if (test_and_clear_bit(FIRST_BOOT, &ar->flag)) {
+		ath6kl_info("%s %s fw %s%s\n",
+			    ar->hw.name,
+			    ath6kl_init_get_hif_name(ar->hif_type),
+			    ar->wiphy->fw_version,
+			    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
+	}
+
 	if (ar->version.abi_ver != ATH6KL_ABI_VERSION) {
 		ath6kl_err("abi version mismatch: host(0x%x), target(0x%x)\n",
 			   ATH6KL_ABI_VERSION, ar->version.abi_ver);
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index ea84894..d9b4ba4 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -525,20 +525,6 @@ void ath6kl_disconnect(struct ath6kl_vif *vif)
 
 /* WMI Event handlers */
 
-static const char *get_hw_id_string(u32 id)
-{
-	switch (id) {
-	case AR6003_REV1_VERSION:
-		return "1.0";
-	case AR6003_REV2_VERSION:
-		return "2.0";
-	case AR6003_REV3_VERSION:
-		return "2.1.1";
-	default:
-		return "unknown";
-	}
-}
-
 void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 {
 	struct ath6kl *ar = devt;
@@ -561,13 +547,6 @@ void ath6kl_ready_event(void *devt, u8 *datap, u32 sw_ver, u32 abi_ver)
 	/* indicate to the waiting thread that the ready event was received */
 	set_bit(WMI_READY, &ar->flag);
 	wake_up(&ar->event_wq);
-
-	if (test_and_clear_bit(FIRST_BOOT, &ar->flag)) {
-		ath6kl_info("hw %s fw %s%s\n",
-			    get_hw_id_string(ar->wiphy->hw_version),
-			    ar->wiphy->fw_version,
-			    test_bit(TESTMODE, &ar->flag) ? " testmode" : "");
-	}
 }
 
 void ath6kl_scan_complete_evt(struct ath6kl_vif *vif, int status)

