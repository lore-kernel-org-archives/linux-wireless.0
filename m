Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52346 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab2DFSBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 14:01:45 -0400
Message-ID: <1333735303.5577.8.camel@jlt3.sipsolutions.net> (sfid-20120406_200149_298510_A1D7C930)
Subject: [RFC] nl80211/mac80211: support full station state in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Eliad Peller <eliad@wizery.com>
Date: Fri, 06 Apr 2012 20:01:43 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
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

Completely untested so far, just wanted to see what
everybody thinks. I'll need to work on the hostapd
patch as well, but I think TI had something there to
fix a race which I need to look into.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/nl80211.h |   16 ++++++
 net/mac80211/cfg.c      |  113 +++++++++++++++++++++++++++++-------------------
 net/mac80211/main.c     |    3 -
 net/wireless/nl80211.c  |   24 ++++++++++
 4 files changed, 111 insertions(+), 45 deletions(-)

--- a/include/linux/nl80211.h	2012-04-06 19:03:09.000000000 +0200
+++ b/include/linux/nl80211.h	2012-04-06 19:19:12.000000000 +0200
@@ -1570,6 +1570,9 @@ enum nl80211_iftype {
  *	flag can't be changed, it is only valid while adding a station, and
  *	attempts to change it will silently be ignored (rather than rejected
  *	as errors.)
+ * @NL80211_STA_FLAG_ASSOCIATED: station is associated; used with drivers
+ *	that support %NL80211_FEATURE_FULL_AP_CLIENT_STATE to transition a
+ *	previously added station into associated state
  * @NL80211_STA_FLAG_MAX: highest station flag number currently defined
  * @__NL80211_STA_FLAG_AFTER_LAST: internal use
  */
@@ -1581,6 +1584,7 @@ enum nl80211_sta_flags {
 	NL80211_STA_FLAG_MFP,
 	NL80211_STA_FLAG_AUTHENTICATED,
 	NL80211_STA_FLAG_TDLS_PEER,
+	NL80211_STA_FLAG_ASSOCIATED,
 
 	/* keep last */
 	__NL80211_STA_FLAG_AFTER_LAST,
@@ -2845,11 +2849,23 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_HT_IBSS: This driver supports IBSS with HT datarates.
  * @NL80211_FEATURE_INACTIVITY_TIMER: This driver takes care of freeing up
  *	the connected inactive stations in AP mode.
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
 	NL80211_FEATURE_SK_TX_STATUS	= 1 << 0,
 	NL80211_FEATURE_HT_IBSS		= 1 << 1,
 	NL80211_FEATURE_INACTIVITY_TIMER = 1 << 2,
+	NL80211_FEATURE_FULL_AP_CLIENT_STATE = 1 << 3,
 };
 
 /**
--- a/net/mac80211/main.c	2012-04-06 19:03:06.000000000 +0200
+++ b/net/mac80211/main.c	2012-04-06 19:03:20.000000000 +0200
@@ -563,7 +563,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 		wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
 	wiphy->features = NL80211_FEATURE_SK_TX_STATUS |
-			  NL80211_FEATURE_HT_IBSS;
+			  NL80211_FEATURE_HT_IBSS |
+			  NL80211_FEATURE_FULL_AP_CLIENT_STATE;
 
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
--- a/net/mac80211/cfg.c	2012-04-06 19:03:06.000000000 +0200
+++ b/net/mac80211/cfg.c	2012-04-06 19:45:58.000000000 +0200
@@ -431,6 +431,7 @@ static void sta_set_sinfo(struct sta_inf
 				BIT(NL80211_STA_FLAG_WME) |
 				BIT(NL80211_STA_FLAG_MFP) |
 				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				BIT(NL80211_STA_FLAG_ASSOCIATED) |
 				BIT(NL80211_STA_FLAG_TDLS_PEER);
 	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
@@ -442,6 +443,8 @@ static void sta_set_sinfo(struct sta_inf
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
 	if (test_sta_flag(sta, WLAN_STA_AUTH))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	if (test_sta_flag(sta, WLAN_STA_ASSOC))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
 	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 }
@@ -735,41 +738,26 @@ static void ieee80211_send_layer2_update
 	netif_rx_ni(skb);
 }
 
-static int sta_apply_parameters(struct ieee80211_local *local,
+static int sta_apply_auth_flags(struct ieee80211_local *local,
 				struct sta_info *sta,
-				struct station_parameters *params)
+				u32 mask, u32 set)
 {
-	int ret = 0;
-	u32 rates;
-	int i, j;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_sub_if_data *sdata = sta->sdata;
-	u32 mask, set;
-
-	sband = local->hw.wiphy->bands[local->oper_channel->band];
+	int ret;
 
-	mask = params->sta_flags_mask;
-	set = params->sta_flags_set;
-
-	/*
-	 * In mesh mode, we can clear AUTHENTICATED flag but must
-	 * also make ASSOCIATED follow appropriately for the driver
-	 * API. See also below, after AUTHORIZED changes.
-	 */
-	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		/* cfg80211 should not allow this in non-mesh modes */
-		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
-			return -EINVAL;
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    !test_sta_flag(sta, WLAN_STA_AUTH)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+		if (ret)
+			return ret;
+	}
 
-		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
-		    !test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-			if (ret)
-				return ret;
-			ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
-			if (ret)
-				return ret;
-		}
+	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    set & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    !test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
+		if (ret)
+			return ret;
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_AUTHORIZED)) {
@@ -781,22 +769,55 @@ static int sta_apply_parameters(struct i
 			return ret;
 	}
 
-	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED)) {
-		/* cfg80211 should not allow this in non-mesh modes */
-		if (WARN_ON(!ieee80211_vif_is_mesh(&sdata->vif)))
-			return -EINVAL;
+	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
+	    !(set & BIT(NL80211_STA_FLAG_ASSOCIATED)) &&
+	    test_sta_flag(sta, WLAN_STA_ASSOC)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
+		if (ret)
+			return ret;
+	}
 
-		if (!(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
-		    test_sta_flag(sta, WLAN_STA_AUTH)) {
-			ret = sta_info_move_state(sta, IEEE80211_STA_AUTH);
-			if (ret)
-				return ret;
-			ret = sta_info_move_state(sta, IEEE80211_STA_NONE);
-			if (ret)
-				return ret;
-		}
+	if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED) &&
+	    !(set & BIT(NL80211_STA_FLAG_AUTHENTICATED)) &&
+	    test_sta_flag(sta, WLAN_STA_AUTH)) {
+		ret = sta_info_move_state(sta, IEEE80211_STA_NONE);
+		if (ret)
+			return ret;
 	}
 
+	return 0;
+}
+
+static int sta_apply_parameters(struct ieee80211_local *local,
+				struct sta_info *sta,
+				struct station_parameters *params)
+{
+	int ret = 0;
+	u32 rates;
+	int i, j;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_sub_if_data *sdata = sta->sdata;
+	u32 mask, set;
+
+	sband = local->hw.wiphy->bands[local->oper_channel->band];
+
+	mask = params->sta_flags_mask;
+	set = params->sta_flags_set;
+
+	if (ieee80211_vif_is_mesh(&sdata->vif)) {
+		/*
+		 * In mesh mode, ASSOCIATED isn't part of the nl80211
+		 * API but must follow AUTHENTICATED for driver state.
+		 */
+		if (mask & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			mask |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+		if (set & BIT(NL80211_STA_FLAG_AUTHENTICATED))
+			set |= BIT(NL80211_STA_FLAG_ASSOCIATED);
+	}
+
+	ret = sta_apply_auth_flags(local, sta, mask, set);
+	if (ret)
+		return ret;
 
 	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
 		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
@@ -925,6 +946,10 @@ static int ieee80211_add_station(struct
 	if (!sta)
 		return -ENOMEM;
 
+	/*
+	 * defaults -- if userspace wants something else we'll
+	 * change it accordingly in sta_apply_parameters()
+	 */
 	sta_info_pre_move_state(sta, IEEE80211_STA_AUTH);
 	sta_info_pre_move_state(sta, IEEE80211_STA_ASSOC);
 
--- a/net/wireless/nl80211.c	2012-04-06 19:03:09.000000000 +0200
+++ b/net/wireless/nl80211.c	2012-04-06 19:20:32.000000000 +0200
@@ -2702,11 +2702,21 @@ static int nl80211_set_station(struct sk
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
@@ -2860,17 +2870,31 @@ static int nl80211_new_station(struct sk
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


