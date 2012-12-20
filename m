Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51652 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2LTMKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 07:10:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211/mac80211: support full station state in AP mode
Date: Thu, 20 Dec 2012 13:10:40 +0100
Message-Id: <1356005440-22933-1-git-send-email-johannes@sipsolutions.net> (sfid-20121220_131023_822550_FA530319)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Today, stations are added already associated. That is
inefficient if, for example, the driver has no room
for stations any more because then the station will
go through the entire auth/assoc handshake, only to
be kicked out afterwards.

To address this a bit better, at least with drivers
using the new station state callback, allow hostapd
to add stations in unauthenticated mode, just after
receiving the AUTH frame, before even replying. Thus
if there's no more space at that point, it can send
a negative auth frame back. It still needs to handle
later state transition errors though, of course.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h |  16 ++++++
 net/mac80211/cfg.c           | 115 ++++++++++++++++++++++++++-----------------
 net/mac80211/main.c          |   3 +-
 net/wireless/nl80211.c       |  24 +++++++++
 4 files changed, 113 insertions(+), 45 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index e3e19f8..5470171 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1697,6 +1697,9 @@ enum nl80211_iftype {
  *	flag can't be changed, it is only valid while adding a station, and
  *	attempts to change it will silently be ignored (rather than rejected
  *	as errors.)
+ * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
+ *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
+ *	previously added station into associated state
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1708,6 +1711,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
 	NL80211_STA_FLAG_TDLS_PEER,
+	NL80211_STA_FLAG_ASSOCIATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -3140,6 +3144,17 @@ enum nl80211_ap_sme_features {
  *	setting
  * @NL80211_FEATURE_P2P_GO_OPPPS: P2P GO implementation supports opportunistic
  *	powersave
+ * @NL80211_FEATURE_FULL_AP_CLIENT_STATE: The driver supports full state
+ *	transitions for AP clients. Without this flag (and if the driver
+ *	doesn't have the AP SME in the device) the driver supports adding
+ *	stations only when they're associated and adds them in associated
+ *	state (to later be transitioned into authorized), with this flag
+ *	they should be added before even sending the authentication reply
+ *	and then transitioned into authenticated, associated and authorized
+ *	states using station flags.
+ *	Note that even for drivers that support this, the default is to add
+ *	stations in authenticated/associated state, so to add unauthenticated
+ *	stations the authenticated/associated bits have to be set in the mask.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3155,6 +3170,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_NEED_OBSS_SCAN			= 1 << 10,
 	NL80211_FEATURE_P2P_GO_CTWIN			= 1 << 11,
 	NL80211_FEATURE_P2P_GO_OPPPS			= 1 << 12,
+	NL80211_FEATURE_FULL_AP_CLIENT_STATE		= 1 << 13,
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index ff2ccc3..c485b36 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -510,6 +510,7 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 				BIT(NL80211_STA_FLAG_WME) |
 				BIT(NL80211_STA_FLAG_MFP) |
 				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				BIT(NL80211_STA_FLAG_ASSOCIATED) |
 				BIT(NL80211_STA_FLAG_TDLS_PEER);
 	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
@@ -521,6 +522,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
 	if (test_sta_flag(sta, WLAN_STA_AUTH))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	if (test_sta_flag(sta, WLAN_STA_ASSOC))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 }
@@ -1077,6 +1080,58 @@ static void ieee80211_send_layer2_update(struct sta_info *sta)
 	netif_rx_ni(skb);
 }
 
+static int sta_apply_auth_flags(struct ieee80211_local *local,
+				struct sta_info *sta,
+				u32 mask, u32 set)
+{
+	int ret;
+
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    !test_sta_flag(sta, WLAN_STA_AUTH)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+		if (ret)
+			return ret;
+	}
+
+	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    set & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    !test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		if (ret)
+			return ret;
+	}
+
+	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
+		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
+			ret = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
+		else if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
+			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		else
+			ret = 0;
+		if (ret)
+			return ret;
+	}
+
+	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    !(set & BIT(NL80211_STA_FLAG_ASSOCIATED)) &&
+	    test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+		if (ret)
+			return ret;
+	}
+
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    !(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
+	    test_sta_flag(sta, WLAN_STA_AUTH)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_NONE);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int sta_apply_parameters(struct ieee80211_local *local,
 				struct sta_info *sta,
 				struct station_parameters *params)
@@ -1094,52 +1149,20 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	mask = params->sta_flags_mask;
 	set = params->sta_flags_set;
 
-	/*
-	 * In mesh mode, we can clear AUTHENTICATED flag but must
-	 * also make ASSOCIATED follow appropriately for the driver
-	 * API. See also below, after AUTHORIZED changes.
-	 */
-	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		/* cfg80211 should not allow this in non-mesh modes */
-		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
-			return -EINVAL;
-
-		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
-		    !test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-			if (ret)
-				return ret;
-			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-			if (ret)
-				return ret;
-		}
-	}
-
-	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
-		if (set & BIT(NL80211_STA_FLAG_AUTHORIZED))
-			ret = sta_info_move_state(sta, IEEE80211_STA_AUTHORIZED);
-		else if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
-			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-		if (ret)
-			return ret;
-	}
-
-	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		/* cfg80211 should not allow this in non-mesh modes */
-		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
-			return -EINVAL;
-
-		if (!(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
-		    test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-			if (ret)
-				return ret;
-			ret = sta_info_move_state(sta, IEEE80211_STA_NONE);
-			if (ret)
-				return ret;
-		}
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/*
+		 * In mesh mode, ASSOCIATED isn't part of the nl80211
+		 * API but must follow AUTHENTICATED for driver state.
+		 */
+		if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			mask |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	}
 
+	ret = sta_apply_auth_flags(local, sta, mask, set);
+	if (ret)
+		return ret;
 
 	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
 		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
@@ -1273,6 +1296,10 @@ static int ieee80211_add_station(struct wiphy *wiphy, struct net_device *dev,
 	if (!sta)
 		return -ENOMEM;
 
+	/*
+	 * defaults -- if userspace wants something else we'll
+	 * change it accordingly in sta_apply_parameters()
+	 */
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
 
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 73ca515..475e85b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -541,7 +541,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	wiphy->features |= NL80211_FEATURE_SK_TX_STATUS |
 			   NL80211_FEATURE_SAE |
 			   NL80211_FEATURE_HT_IBSS |
-			   NL80211_FEATURE_VIF_TXPOWER;
+			   NL80211_FEATURE_VIF_TXPOWER |
+			   NL80211_FEATURE_FULL_AP_CLIENT_STATE;
 
 	if (!ops->hw_scan)
 		wiphy->features |= NL80211_FEATURE_LOW_PRIORITY_SCAN |
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b3cf7cc..087f68b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3231,11 +3231,21 @@ static int nl80211_set_station(struct sk_buff *skb, struct genl_info *info)
 		/* accept only the listed bits */
 		if (params.sta_flags_mask &
 				~(BIT(NL80211_STA_FLAG_AUTHORIZED) |
+				  BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				  BIT(NL80211_STA_FLAG_ASSOCIATED) |
 				  BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				  BIT(NL80211_STA_FLAG_WME) |
 				  BIT(NL80211_STA_FLAG_MFP)))
 			return -EINVAL;
 
+		/* but authenticated/associated only if driver handles it */
+		if (!(rdev->wiphy.features &
+				NL80211_FEATURE_FULL_AP_CLIENT_STATE) &&
+		    params.sta_flags_mask &
+				(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				 BIT(NL80211_STA_FLAG_ASSOCIATED)))
+			return -EINVAL;
+
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
 		if (IS_ERR(params.vlan))
@@ -3393,17 +3403,31 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		/* but don't bother the driver with it */
 		params.sta_flags_mask &= ~BIT(NL80211_STA_FLAG_TDLS_PEER);
 
+		/* allow authenticated/associated only if driver handles it */
+		if (!(rdev->wiphy.features &
+				NL80211_FEATURE_FULL_AP_CLIENT_STATE) &&
+		    params.sta_flags_mask &
+				(BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				 BIT(NL80211_STA_FLAG_ASSOCIATED)))
+			return -EINVAL;
+
 		/* must be last in here for error handling */
 		params.vlan = get_vlan(info, rdev);
 		if (IS_ERR(params.vlan))
 			return PTR_ERR(params.vlan);
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
+		/* associated is disallowed */
+		if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_ASSOCIATED))
+			return -EINVAL;
 		/* TDLS peers cannot be added */
 		if (params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER))
 			return -EINVAL;
 		break;
 	case NL80211_IFTYPE_STATION:
+		/* associated is disallowed */
+		if (params.sta_flags_mask & BIT(NL80211_STA_FLAG_ASSOCIATED))
+			return -EINVAL;
 		/* Only TDLS peers can be added */
 		if (!(params.sta_flags_set & BIT(NL80211_STA_FLAG_TDLS_PEER)))
 			return -EINVAL;
-- 
1.8.0

