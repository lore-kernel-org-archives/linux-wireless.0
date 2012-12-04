Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44583 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732Ab2LDOtM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:49:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 13/18] regulatory: simplify freq_reg_info_regd
Date: Tue,  4 Dec 2012 15:48:55 +0100
Message-Id: <1354632540-21207-14-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154916_771407_9E5D9308)
In-Reply-To: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
References: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The function itself has dual-purpose: it can
retrieve from a given regdomain or from the
globally installed one. Change it to have a
single purpose only: to look up from a given
regdomain. Pass the correct regdomain in the
freq_reg_info() function instead.

This also changes the locking rules for it,
no locking is required any more.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 999b379..1dc94da 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -687,28 +687,15 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 			      u32 center_freq,
 			      u32 desired_bw_khz,
 			      const struct ieee80211_reg_rule **reg_rule,
-			      const struct ieee80211_regdomain *custom_regd)
+			      const struct ieee80211_regdomain *regd)
 {
 	int i;
 	bool band_rule_found = false;
-	const struct ieee80211_regdomain *regd;
 	bool bw_fits = false;
 
 	if (!desired_bw_khz)
 		desired_bw_khz = MHZ_TO_KHZ(20);
 
-	regd = custom_regd ? custom_regd : cfg80211_regdomain;
-
-	/*
-	 * Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed or a user wants to help complaince further
-	 */
-	if (!custom_regd &&
-	    last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
-	    wiphy->regd)
-		regd = wiphy->regd;
-
 	if (!regd)
 		return -EINVAL;
 
@@ -744,10 +731,24 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 desired_bw_khz,
 		  const struct ieee80211_reg_rule **reg_rule)
 {
+	const struct ieee80211_regdomain *regd;
+
+	assert_reg_lock();
 	assert_cfg80211_lock();
 
+	/*
+	 * Follow the driver's regulatory domain, if present, unless a country
+	 * IE has been processed or a user wants to help complaince further
+	 */
+	if (last_request->initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+	    last_request->initiator != NL80211_REGDOM_SET_BY_USER &&
+	    wiphy->regd)
+		regd = wiphy->regd;
+	else
+		regd = cfg80211_regdomain;
+
 	return freq_reg_info_regd(wiphy, center_freq, desired_bw_khz,
-				  reg_rule, NULL);
+				  reg_rule, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
-- 
1.8.0

