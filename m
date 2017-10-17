Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44416 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759964AbdJQTmz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:42:55 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Maya Erez <qca_merez@qca.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wil6210: disallow changing RSN in beacon change
Date: Tue, 17 Oct 2017 21:42:53 +0200
Message-Id: <20171017194253.10212-1-johannes@sipsolutions.net> (sfid-20171017_214258_405163_EED7D448)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This is a code path that will never really get hit anyway, since
it's nonsense to change the beacon of an existing BSS to suddenly
include or no longer include the RSN IE. Reject this instead of
having the dead code, and get rid of accessing wdev->ssid/_len by
way of that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 85d5c04618eb..a81711451691 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1389,7 +1389,6 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 				      struct cfg80211_beacon_data *bcon)
 {
 	struct wil6210_priv *wil = wiphy_to_wil(wiphy);
-	int rc;
 	u32 privacy = 0;
 
 	wil_dbg_misc(wil, "change_beacon\n");
@@ -1400,24 +1399,11 @@ static int wil_cfg80211_change_beacon(struct wiphy *wiphy,
 			     bcon->tail_len))
 		privacy = 1;
 
-	/* in case privacy has changed, need to restart the AP */
-	if (wil->privacy != privacy) {
-		struct wireless_dev *wdev = ndev->ieee80211_ptr;
-
-		wil_dbg_misc(wil, "privacy changed %d=>%d. Restarting AP\n",
-			     wil->privacy, privacy);
-
-		rc = _wil_cfg80211_start_ap(wiphy, ndev, wdev->ssid,
-					    wdev->ssid_len, privacy,
-					    wdev->beacon_interval,
-					    wil->channel, bcon,
-					    wil->hidden_ssid,
-					    wil->pbss);
-	} else {
-		rc = _wil_cfg80211_set_ies(wiphy, bcon);
-	}
+	/* privacy (really RSN) shouldn't be changing */
+	if (wil->privacy != privacy)
+		return -EINVAL;
 
-	return rc;
+	return _wil_cfg80211_set_ies(wiphy, bcon);
 }
 
 static int wil_cfg80211_start_ap(struct wiphy *wiphy,
-- 
2.14.2
