Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:44926 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755389AbeBOLIc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Feb 2018 06:08:32 -0500
Received: by mail-wr0-f195.google.com with SMTP id v65so2921938wrc.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 Feb 2018 03:08:31 -0800 (PST)
From: Loic Poulain <loic.poulain@linaro.org>
To: kvalo@codeaurora.org, k.eugene.e@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        wcn36xx@lists.infradead.org, Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: Fix warning due to duplicate scan_completed notification
Date: Thu, 15 Feb 2018 12:08:28 +0100
Message-Id: <1518692908-29303-1-git-send-email-loic.poulain@linaro.org> (sfid-20180215_120836_808462_2357281B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The wcn36xx_cancel_hw_scan method stops the hw scan and notify the
scan completion via ieee80211_scan_completed.
However, on scan offload cancellation, firmware sends a scan complete
indication, triggering a new call to ieee80211_scan_completed.
This leads to kernel warn since the scan has already been completed.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 9 +++------
 drivers/net/wireless/ath/wcn36xx/smd.c  | 2 ++
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index ab5be6d..fcc98d4 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -666,16 +666,13 @@ static void wcn36xx_cancel_hw_scan(struct ieee80211_hw *hw,
 {
 	struct wcn36xx *wcn = hw->priv;
 
-	if (!wcn36xx_smd_stop_hw_scan(wcn)) {
-		struct cfg80211_scan_info scan_info = { .aborted = true };
-
-		ieee80211_scan_completed(wcn->hw, &scan_info);
-	}
-
 	mutex_lock(&wcn->scan_lock);
 	wcn->scan_aborted = true;
 	mutex_unlock(&wcn->scan_lock);
 
+	/* ieee80211_scan_completed will be called on FW scan indication */
+	wcn36xx_smd_stop_hw_scan(wcn);
+
 	cancel_work_sync(&wcn->scan_work);
 }
 
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2a4871c..7cc2928 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2138,6 +2138,8 @@ static int wcn36xx_smd_hw_scan_ind(struct wcn36xx *wcn, void *buf, size_t len)
 	case WCN36XX_HAL_SCAN_IND_COMPLETED:
 		mutex_lock(&wcn->scan_lock);
 		wcn->scan_req = NULL;
+		if (wcn->scan_aborted)
+			scan_info.aborted = true;
 		mutex_unlock(&wcn->scan_lock);
 		ieee80211_scan_completed(wcn->hw, &scan_info);
 		break;
-- 
2.7.4
