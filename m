Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45328 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937769AbeE1Nrq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 09:47:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/5] nl80211: refactor common code in scan flags checks
Date: Mon, 28 May 2018 15:47:37 +0200
Message-Id: <20180528134741.10386-2-johannes@sipsolutions.net> (sfid-20180528_154818_825681_E3E4C9DA)
In-Reply-To: <20180528134741.10386-1-johannes@sipsolutions.net>
References: <20180528134741.10386-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's a very common pattern to check for a scan flag and
then reject it if an extended feature flag isn't set, factor
this out into a helper function.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 60 ++++++++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bc40a783cb27..384fdad9825d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6861,6 +6861,16 @@ static bool cfg80211_off_channel_oper_allowed(struct wireless_dev *wdev)
 	return regulatory_pre_cac_allowed(wdev->wiphy);
 }
 
+static bool nl80211_check_scan_feat(struct wiphy *wiphy, u32 flags, u32 flag,
+				    enum nl80211_ext_feature_index feat)
+{
+	if (!(flags & flag))
+		return true;
+	if (wiphy_ext_feature_isset(wiphy, feat))
+		return true;
+	return false;
+}
+
 static int
 nl80211_check_scan_flags(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 void *request, struct nlattr **attrs,
@@ -6895,15 +6905,27 @@ nl80211_check_scan_flags(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	if (((*flags & NL80211_SCAN_FLAG_LOW_PRIORITY) &&
 	     !(wiphy->features & NL80211_FEATURE_LOW_PRIORITY_SCAN)) ||
-	    ((*flags & NL80211_SCAN_FLAG_LOW_SPAN) &&
-	     !wiphy_ext_feature_isset(wiphy,
-				      NL80211_EXT_FEATURE_LOW_SPAN_SCAN)) ||
-	    ((*flags & NL80211_SCAN_FLAG_LOW_POWER) &&
-	     !wiphy_ext_feature_isset(wiphy,
-				      NL80211_EXT_FEATURE_LOW_POWER_SCAN)) ||
-	    ((*flags & NL80211_SCAN_FLAG_HIGH_ACCURACY) &&
-	     !wiphy_ext_feature_isset(wiphy,
-				      NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN)))
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_LOW_SPAN,
+				     NL80211_EXT_FEATURE_LOW_SPAN_SCAN) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_LOW_POWER,
+				     NL80211_EXT_FEATURE_LOW_POWER_SCAN) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_HIGH_ACCURACY,
+				     NL80211_EXT_FEATURE_HIGH_ACCURACY_SCAN) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_FILS_MAX_CHANNEL_TIME,
+				     NL80211_EXT_FEATURE_FILS_MAX_CHANNEL_TIME) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP,
+				     NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION,
+				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION) ||
+	    !nl80211_check_scan_feat(wiphy, *flags,
+				     NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE,
+				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE))
 		return -EOPNOTSUPP;
 
 	if (*flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
@@ -6918,26 +6940,6 @@ nl80211_check_scan_flags(struct wiphy *wiphy, struct wireless_dev *wdev,
 			return err;
 	}
 
-	if ((*flags & NL80211_SCAN_FLAG_FILS_MAX_CHANNEL_TIME) &&
-	    !wiphy_ext_feature_isset(wiphy,
-				     NL80211_EXT_FEATURE_FILS_MAX_CHANNEL_TIME))
-		return -EOPNOTSUPP;
-
-	if ((*flags & NL80211_SCAN_FLAG_ACCEPT_BCAST_PROBE_RESP) &&
-	   !wiphy_ext_feature_isset(wiphy,
-				    NL80211_EXT_FEATURE_ACCEPT_BCAST_PROBE_RESP))
-		return -EOPNOTSUPP;
-
-	if ((*flags & NL80211_SCAN_FLAG_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION) &&
-	    !wiphy_ext_feature_isset(wiphy,
-				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_DEFERRAL_SUPPRESSION))
-		return -EOPNOTSUPP;
-
-	if ((*flags & NL80211_SCAN_FLAG_OCE_PROBE_REQ_HIGH_TX_RATE) &&
-	    !wiphy_ext_feature_isset(wiphy,
-				     NL80211_EXT_FEATURE_OCE_PROBE_REQ_HIGH_TX_RATE))
-		return -EOPNOTSUPP;
-
 	return 0;
 }
 
-- 
2.14.3
