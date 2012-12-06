Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53218 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945984Ab2LFQrq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:47:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 15/24] regulatory: simplify freq_reg_info_regd
Date: Thu,  6 Dec 2012 17:47:39 +0100
Message-Id: <1354812468-15709-16-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174906_737442_40046E40)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
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
index fe8a13f..ab8740b 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -679,28 +679,15 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
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
 
@@ -736,10 +723,24 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
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

