Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44513 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbcB2VdY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:33:24 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 15/15] wil6210: add oob_mode module parameter
Date: Mon, 29 Feb 2016 23:32:50 +0200
Message-Id: <1456781570-16552-16-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20160229_225949_762288_1D9F5C56)
In-Reply-To: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1456781570-16552-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

Add module parameter oob_mode. Takes effect the next time
the interface is brought up and FW is loaded. Puts the FW
in special "out of the box" (OOB) mode which is used for
diagnostics and certification.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c    | 15 +++++++++++++++
 drivers/net/wireless/ath/wil6210/wil6210.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index c2a0a66..9bf9fe2 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -27,6 +27,10 @@ bool debug_fw; /* = false; */
 module_param(debug_fw, bool, S_IRUGO);
 MODULE_PARM_DESC(debug_fw, " do not perform card reset. For FW debug");
 
+static bool oob_mode;
+module_param(oob_mode, bool, S_IRUGO);
+MODULE_PARM_DESC(oob_mode, " enable OOB mode in FW");
+
 bool no_fw_recovery;
 module_param(no_fw_recovery, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(no_fw_recovery, " disable automatic FW error recovery");
@@ -547,6 +551,16 @@ static inline void wil_release_cpu(struct wil6210_priv *wil)
 	wil_w(wil, RGF_USER_USER_CPU_0, 1);
 }
 
+static void wil_set_oob_mode(struct wil6210_priv *wil, bool enable)
+{
+	wil_info(wil, "%s: enable=%d\n", __func__, enable);
+	if (enable) {
+		wil_s(wil, RGF_USER_USAGE_6, BIT_USER_OOB_MODE);
+	} else {
+		wil_c(wil, RGF_USER_USAGE_6, BIT_USER_OOB_MODE);
+	}
+}
+
 static int wil_target_reset(struct wil6210_priv *wil)
 {
 	int delay = 0;
@@ -823,6 +837,7 @@ int wil_reset(struct wil6210_priv *wil, bool load_fw)
 	if (rc)
 		return rc;
 
+	wil_set_oob_mode(wil, oob_mode);
 	if (load_fw) {
 		wil_info(wil, "Use firmware <%s> + board <%s>\n", WIL_FW_NAME,
 			 WIL_FW2_NAME);
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index d18c448..4d699ea4 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -132,6 +132,7 @@ struct RGF_ICR {
 /* registers - FW addresses */
 #define RGF_USER_USAGE_1		(0x880004)
 #define RGF_USER_USAGE_6		(0x880018)
+	#define BIT_USER_OOB_MODE		BIT(31)
 #define RGF_USER_HW_MACHINE_STATE	(0x8801dc)
 	#define HW_MACHINE_BOOT_DONE	(0x3fffffd)
 #define RGF_USER_USER_CPU_0		(0x8801e0)
-- 
1.8.5.2

