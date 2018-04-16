Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:57028 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754988AbeDPNQr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:16:47 -0400
From: Daniel Mack <daniel@zonque.org>
To: linux-wireless@vger.kernel.org
Cc: wcn36xx@lists.infradead.org, kvalo@codeaurora.org,
        loic.poulain@linaro.org, rfried@codeaurora.org,
        bjorn.andersson@linaro.org, Daniel Mack <daniel@zonque.org>
Subject: [PATCH 3/5] wcn36xx: handle scan cancellation when firmware support is missing
Date: Mon, 16 Apr 2018 15:16:32 +0200
Message-Id: <20180416131634.25432-4-daniel@zonque.org> (sfid-20180416_151651_446880_786D4C89)
In-Reply-To: <20180416131634.25432-1-daniel@zonque.org>
References: <20180416131634.25432-1-daniel@zonque.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For firmwares that don't have the SCAN_OFFLOAD feature bit set, do
not call into wcn36xx_smd_stop_hw_scan(). Instead, stop the asynchronous
work and call into ieee80211_scan_completed() immediately.

Signed-off-by: Daniel Mack <daniel@zonque.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index e5ef2cbb622f..28c0286ae47b 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -685,10 +685,18 @@ static void wcn36xx_cancel_hw_scan(struct ieee80211_hw *hw,
 	wcn->scan_aborted = true;
 	mutex_unlock(&wcn->scan_lock);
 
-	/* ieee80211_scan_completed will be called on FW scan indication */
-	wcn36xx_smd_stop_hw_scan(wcn);
+	if (get_feat_caps(wcn->fw_feat_caps, SCAN_OFFLOAD)) {
+		/* ieee80211_scan_completed will be called on FW scan
+		 * indication */
+		wcn36xx_smd_stop_hw_scan(wcn);
+	} else {
+		struct cfg80211_scan_info scan_info = {
+			.aborted = true,
+		};
 
-	cancel_work_sync(&wcn->scan_work);
+		cancel_work_sync(&wcn->scan_work);
+		ieee80211_scan_completed(wcn->hw, &scan_info);
+	}
 }
 
 static void wcn36xx_update_allowed_rates(struct ieee80211_sta *sta,
-- 
2.14.3
