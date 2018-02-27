Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57678 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752805AbeB0NcT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 08:32:19 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: k.eugene.e@gmail.com, kvalo@codeaurora.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH v2] wcn36xx: reduce verbosity of drivers messages
Date: Tue, 27 Feb 2018 15:31:49 +0200
Message-Id: <20180227133149.26805-1-rfried@codeaurora.org> (sfid-20180227_143231_397006_700180C5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the WLAN interface is started the FW
version and caps are printed.
The caps now will be displayed only in debug mode.
Firmware version will be displayed only once on first
startup of the interface.

Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
v2: print the firwmare version as info but only
	onetime.

 drivers/net/wireless/ath/wcn36xx/main.c |  2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 19 +++++++++++--------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index ab5be6d2c691..8c2654075eb8 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -261,7 +261,7 @@ static void wcn36xx_feat_caps_info(struct wcn36xx *wcn)
 
 	for (i = 0; i < MAX_FEATURE_SUPPORTED; i++) {
 		if (get_feat_caps(wcn->fw_feat_caps, i))
-			wcn36xx_info("FW Cap %s\n", wcn36xx_get_cap_name(i));
+			wcn36xx_dbg(WCN36XX_DBG_MAC, "FW Cap %s\n", wcn36xx_get_cap_name(i));
 	}
 }
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2a4871ca9c72..3048722f0484 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -385,6 +385,7 @@ out:	return ret;
 
 static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
 {
+	static bool first = true;
 	struct wcn36xx_hal_mac_start_rsp_msg *rsp;
 
 	if (len < sizeof(*rsp))
@@ -409,15 +410,17 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
 	wcn->fw_minor = rsp->start_rsp_params.version.minor;
 	wcn->fw_major = rsp->start_rsp_params.version.major;
 
-	wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
-		     wcn->wlan_version, wcn->crm_version);
-
-	wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
-		     wcn->fw_major, wcn->fw_minor,
-		     wcn->fw_version, wcn->fw_revision,
-		     rsp->start_rsp_params.stations,
-		     rsp->start_rsp_params.bssids);
+	if (first) {
+		first = false;
+		wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
+			     wcn->wlan_version, wcn->crm_version);
 
+		wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
+			     wcn->fw_major, wcn->fw_minor,
+			     wcn->fw_version, wcn->fw_revision,
+			     rsp->start_rsp_params.stations,
+			     rsp->start_rsp_params.bssids);
+	}
 	return 0;
 }
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
