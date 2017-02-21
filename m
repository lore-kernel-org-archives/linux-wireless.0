Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17504 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752806AbdBUOcQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 09:32:16 -0500
From: Maya Erez <qca_merez@qca.qualcomm.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Lior David <qca_liord@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        Maya Erez <qca_merez@qca.qualcomm.com>
Subject: [PATCH 02/10] wil6210: do not start regular scan on stopped p2p device
Date: Tue, 21 Feb 2017 16:32:00 +0200
Message-Id: <1487687528-12832-3-git-send-email-qca_merez@qca.qualcomm.com> (sfid-20170221_153220_793165_1114D422)
In-Reply-To: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
References: <1487687528-12832-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Lior David <qca_liord@qca.qualcomm.com>

The driver should not allow starting any type of scan on a stopped
P2P device. Current implementation only checked social scan.

Signed-off-by: Lior David <qca_liord@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 83155b5..14aa6d3 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -390,22 +390,23 @@ static int wil_cfg80211_scan(struct wiphy *wiphy,
 	}
 	mutex_unlock(&wil->p2p_wdev_mutex);
 
-	/* social scan on P2P_DEVICE is handled as p2p search */
-	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE &&
-	    wil_p2p_is_social_scan(request)) {
+	if (wdev->iftype == NL80211_IFTYPE_P2P_DEVICE) {
 		if (!wil->p2p.p2p_dev_started) {
 			wil_err(wil, "P2P search requested on stopped P2P device\n");
 			rc = -EIO;
 			goto out;
 		}
-		wil->scan_request = request;
-		wil->radio_wdev = wdev;
-		rc = wil_p2p_search(wil, request);
-		if (rc) {
-			wil->radio_wdev = wil_to_wdev(wil);
-			wil->scan_request = NULL;
+		/* social scan on P2P_DEVICE is handled as p2p search */
+		if (wil_p2p_is_social_scan(request)) {
+			wil->scan_request = request;
+			wil->radio_wdev = wdev;
+			rc = wil_p2p_search(wil, request);
+			if (rc) {
+				wil->radio_wdev = wil_to_wdev(wil);
+				wil->scan_request = NULL;
+			}
+			goto out;
 		}
-		goto out;
 	}
 
 	(void)wil_p2p_stop_discovery(wil);
-- 
1.9.1
