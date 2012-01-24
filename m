Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:41015 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2AXLu0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 06:50:26 -0500
Subject: [PATCH] ath6kl: fix testmode when fw-2.bin or fw-3.bin is used
To: kvalo@qca.qualcomm.com
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 24 Jan 2012 13:50:16 +0200
Message-ID: <20120124115016.15053.44588.stgit@localhost6.localdomain6> (sfid-20120124_125030_130804_589FF048)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testmode (TCMD and ART) was not enabled when fw-2.bin or fw-3.bin files
were available, fix that by fetching testmode file just after the
board file but before rest of the firmware files are fetched.

I also added testmode field to struct ath6kl and moved the module parameter
to core.c. Now all module parameters are grouped in one place.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.c |    4 ++
 drivers/net/wireless/ath/ath6kl/core.h |    1 
 drivers/net/wireless/ath/ath6kl/init.c |   74 ++++++++++++++++++++------------
 3 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.c b/drivers/net/wireless/ath/ath6kl/core.c
index d764afe..a15966a 100644
--- a/drivers/net/wireless/ath/ath6kl/core.c
+++ b/drivers/net/wireless/ath/ath6kl/core.c
@@ -28,11 +28,13 @@ unsigned int debug_mask;
 static bool suspend_cutpower;
 static unsigned int uart_debug;
 static unsigned int ath6kl_p2p;
+static unsigned int testmode;
 
 module_param(debug_mask, uint, 0644);
 module_param(suspend_cutpower, bool, 0444);
 module_param(uart_debug, uint, 0644);
 module_param(ath6kl_p2p, uint, 0644);
+module_param(testmode, uint, 0644);
 
 int ath6kl_core_init(struct ath6kl *ar)
 {
@@ -76,6 +78,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 		goto err_power_off;
 	}
 
+	ar->testmode = testmode;
+
 	ret = ath6kl_init_fetch_firmwares(ar);
 	if (ret)
 		goto err_htc_cleanup;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 67b22e4..3fba54e 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -526,6 +526,7 @@ struct ath6kl {
 	struct wiphy *wiphy;
 
 	enum ath6kl_state state;
+	unsigned int testmode;
 
 	struct ath6kl_bmi bmi;
 	const struct ath6kl_hif_ops *hif_ops;
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index 167dc41..3c9a661 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -27,10 +27,6 @@
 #include "debug.h"
 #include "hif-ops.h"
 
-static unsigned int testmode;
-
-module_param(testmode, uint, 0644);
-
 static const struct ath6kl_hw hw_list[] = {
 	{
 		.id				= AR6003_HW_2_0_VERSION,
@@ -731,39 +727,54 @@ static int ath6kl_fetch_otp_file(struct ath6kl *ar)
 	return 0;
 }
 
-static int ath6kl_fetch_fw_file(struct ath6kl *ar)
+static int ath6kl_fetch_testmode_file(struct ath6kl *ar)
 {
 	char filename[100];
 	int ret;
 
-	if (ar->fw != NULL)
+	if (ar->testmode == 0)
 		return 0;
 
-	if (testmode) {
-		ath6kl_dbg(ATH6KL_DBG_BOOT, "testmode %d\n",
-				testmode);
-		if (testmode == 2) {
-			if (ar->hw.fw.utf == NULL) {
-				ath6kl_warn("testmode 2 not supported\n");
-				return -EOPNOTSUPP;
-			}
+	ath6kl_dbg(ATH6KL_DBG_BOOT, "testmode %d\n", ar->testmode);
 
-			snprintf(filename, sizeof(filename), "%s/%s",
-				ar->hw.fw.dir, ar->hw.fw.utf);
-		} else {
-			if (ar->hw.fw.tcmd == NULL) {
-				ath6kl_warn("testmode 1 not supported\n");
-				return -EOPNOTSUPP;
-			}
+	if (ar->testmode == 2) {
+		if (ar->hw.fw.utf == NULL) {
+			ath6kl_warn("testmode 2 not supported\n");
+			return -EOPNOTSUPP;
+		}
 
-			snprintf(filename, sizeof(filename), "%s/%s",
-				ar->hw.fw.dir, ar->hw.fw.tcmd);
+		snprintf(filename, sizeof(filename), "%s/%s",
+			 ar->hw.fw.dir, ar->hw.fw.utf);
+	} else {
+		if (ar->hw.fw.tcmd == NULL) {
+			ath6kl_warn("testmode 1 not supported\n");
+			return -EOPNOTSUPP;
 		}
-		set_bit(TESTMODE, &ar->flag);
 
-		goto get_fw;
+		snprintf(filename, sizeof(filename), "%s/%s",
+			 ar->hw.fw.dir, ar->hw.fw.tcmd);
 	}
 
+	set_bit(TESTMODE, &ar->flag);
+
+	ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
+	if (ret) {
+		ath6kl_err("Failed to get testmode %d firmware file %s: %d\n",
+			   ar->testmode, filename, ret);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int ath6kl_fetch_fw_file(struct ath6kl *ar)
+{
+	char filename[100];
+	int ret;
+
+	if (ar->fw != NULL)
+		return 0;
+
 	/* FIXME: remove WARN_ON() as we won't support FW API 1 for long */
 	if (WARN_ON(ar->hw.fw.fw == NULL))
 		return -EINVAL;
@@ -771,7 +782,6 @@ static int ath6kl_fetch_fw_file(struct ath6kl *ar)
 	snprintf(filename, sizeof(filename), "%s/%s",
 		 ar->hw.fw.dir, ar->hw.fw.fw);
 
-get_fw:
 	ret = ath6kl_get_fw(ar, filename, &ar->fw, &ar->fw_len);
 	if (ret) {
 		ath6kl_err("Failed to get firmware file %s: %d\n",
@@ -812,7 +822,7 @@ static int ath6kl_fetch_testscript_file(struct ath6kl *ar)
 	char filename[100];
 	int ret;
 
-	if (testmode != 2)
+	if (ar->testmode != 2)
 		return 0;
 
 	if (ar->fw_testscript != NULL)
@@ -927,6 +937,10 @@ static int ath6kl_fetch_fw_apin(struct ath6kl *ar, const char *name)
 			ath6kl_dbg(ATH6KL_DBG_BOOT, "found fw image ie (%zd B)\n",
 				ie_len);
 
+			/* in testmode we already might have a fw file */
+			if (ar->fw != NULL)
+				break;
+
 			ar->fw = kmemdup(data, ie_len, GFP_KERNEL);
 
 			if (ar->fw == NULL) {
@@ -1038,6 +1052,10 @@ int ath6kl_init_fetch_firmwares(struct ath6kl *ar)
 	if (ret)
 		return ret;
 
+	ret = ath6kl_fetch_testmode_file(ar);
+	if (ret)
+		return ret;
+
 	ret = ath6kl_fetch_fw_apin(ar, ATH6KL_FW_API3_FILE);
 	if (ret == 0) {
 		ar->fw_api = 3;
@@ -1283,7 +1301,7 @@ static int ath6kl_upload_testscript(struct ath6kl *ar)
 	u32 address, param;
 	int ret;
 
-	if (testmode != 2)
+	if (ar->testmode != 2)
 		return 0;
 
 	if (ar->fw_testscript == NULL)

