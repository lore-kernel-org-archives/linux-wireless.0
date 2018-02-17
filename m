Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751246AbeBQUZQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 15:25:16 -0500
From: Ramon Fried <rfried@codeaurora.org>
To: kvalo@codeaurora.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org
Cc: Ramon Fried <rfried@codeaurora.org>
Subject: [PATCH] wcn36xx: reduce verbosity of drivers messages
Date: Sat, 17 Feb 2018 22:25:10 +0200
Message-Id: <20180217202510.13707-1-rfried@codeaurora.org> (sfid-20180217_212526_443416_EE427FDA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the WLAN interface is started the FW
version and caps are printed, this info should appear as
debug info.

Signed-off-by: Ramon Fried <rfried@codeaurora.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 2 +-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

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
index 2a4871ca9c72..7c4d19b041bc 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -409,10 +409,10 @@ static int wcn36xx_smd_start_rsp(struct wcn36xx *wcn, void *buf, size_t len)
 	wcn->fw_minor = rsp->start_rsp_params.version.minor;
 	wcn->fw_major = rsp->start_rsp_params.version.major;
 
-	wcn36xx_info("firmware WLAN version '%s' and CRM version '%s'\n",
+	wcn36xx_dbg(WCN36XX_DBG_HAL, "firmware WLAN version '%s' and CRM version '%s'\n",
 		     wcn->wlan_version, wcn->crm_version);
 
-	wcn36xx_info("firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
+	wcn36xx_dbg(WCN36XX_DBG_HAL, "firmware API %u.%u.%u.%u, %u stations, %u bssids\n",
 		     wcn->fw_major, wcn->fw_minor,
 		     wcn->fw_version, wcn->fw_revision,
 		     rsp->start_rsp_params.stations,
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
