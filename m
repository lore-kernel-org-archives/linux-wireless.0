Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37709 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbbKZP0S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 10:26:18 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] cfg80211: handle add_station auth/assoc flag quirks
Date: Thu, 26 Nov 2015 16:26:13 +0100
Message-Id: <1448551574-3207-2-git-send-email-johannes@sipsolutions.net> (sfid-20151126_162635_799934_3507F209)
In-Reply-To: <1448551574-3207-1-git-send-email-johannes@sipsolutions.net>
References: <1448551574-3207-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a new station is added to AP/GO interfaces the default behaviour
is for it to be added authenticated and associated, due to backwards
compatibility. To prevent that, the driver must be able to do that
(setting the NL80211_FEATURE_FULL_AP_CLIENT_STATE feature flag) and
userspace must set the flag mask to auth|assoc and clear the set.

Handle this quirk in the API entirely in nl80211, and always push the
full flags to the drivers. NL80211_FEATURE_FULL_AP_CLIENT_STATE is
still required for userspace to be allowed to set the mask including
those bits, but after checking that add both flags to the mask and
set in case userspace didn't set them otherwise.

This obsoletes the mac80211 code handling this difference, no other
driver is currently using these flags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/cfg.c     | 10 ----------
 net/wireless/nl80211.c | 23 +++++++++++++++++++----
 2 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index c2bd1b6a6922..9ce0b2f60c72 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1216,16 +1216,6 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!sta)
 		return -ENOMEM;
 
-	/*
-	 * defaults -- if userspace wants something else we'll
-	 * change it accordingly in sta_apply_parameters()
-	 */
-	if (!(params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)) &&
-	    !(params->sta_flags_set & (BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-					BIT(NL80211_STA_FLAG_ASSOCIATED)))) {
-		sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
-		sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
-	}
 	if (params->sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 		sta->sta.tdls = true;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5536b69df2ee..5750d84aa466 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4359,6 +4359,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct station_parameters params;
 	u8 *mac_addr = NULL;
+	u32 auth_assoc = BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+			 BIT(NL80211_STA_FLAG_ASSOCIATED);
 
 	memset(&params, 0, sizeof(params));
 
@@ -4470,10 +4472,23 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		/* allow authenticated/associated only if driver handles it */
 		if (!(rdev->wiphy.features &
 				NL80211_FEATURE_FULL_AP_CLIENT_STATE) &&
-		    params.sta_flags_mask &
-				(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
-				 BIT(NL80211_STA_FLAG_ASSOCIATED)))
-			return -EINVAL;
+		    params.sta_flags_mask & auth_assoc)
+			return -EINVAL;
+
+		/* Older userspace, or userspace wanting to be compatible with
+		 * !NL80211_FEATURE_FULL_AP_CLIENT_STATE, will not set the auth
+		 * and assoc flags in the mask, but assumes the station will be
+		 * added as associated anyway since this was the required driver
+		 * behaviour before NL80211_FEATURE_FULL_AP_CLIENT_STATE was
+		 * introduced.
+		 * In order to not bother drivers with this quirk in the API
+		 * set the flags in both the mask and set for new stations in
+		 * this case.
+		 */
+		if (!(params.sta_flags_mask & auth_assoc)) {
+			params.sta_flags_mask |= auth_assoc;
+			params.sta_flags_set |= auth_assoc;
+		}
 
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
-- 
2.6.2

