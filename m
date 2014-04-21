Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44930 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaDUEzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:25 -0400
Received: by mail-pd0-f181.google.com with SMTP id p10so3297426pdj.12
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:24 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 11/12] cfg80211/mac80211: rename cfg80211_chandef_dfs_required()
Date: Mon, 21 Apr 2014 12:53:06 +0800
Message-Id: <00719736535b7e8348c746cf44cc453dd7893e14.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065541_390358_465A2B3E)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the name to cfg80211_chandef_dfs_check to emphasize that the
function isn't a bool function, its return value must be fully
checked.

Also rename the helper function's name to
cfg80211_do_chandef_dfs_check for consistency.

Variable width in cfg80211_chandef_dfs_check() needn't to be checked
for sanity, since above cfg80211_chandef_valid() already checked the
sanity of chandef->width.

Since cfg80211.h is touched, also correct a typo in comment.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/net/cfg80211.h | 10 +++++-----
 net/mac80211/chan.c    |  6 +++---
 net/mac80211/ibss.c    | 22 +++++++++++-----------
 net/mac80211/mesh.c    |  6 +++---
 net/wireless/chan.c    | 45 +++++++++++++++++++++------------------------
 net/wireless/nl80211.c | 10 +++++-----
 net/wireless/trace.h   |  2 +-
 7 files changed, 49 insertions(+), 52 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9496fe5..65ee338 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -443,16 +443,16 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
 /**
- * cfg80211_chandef_dfs_required - checks if radar detection is required
+ * cfg80211_chandef_dfs_check - checks if radar detection is required
  * @wiphy: the wiphy to validate against
  * @chandef: the channel definition to check
  * @iftype: the interface type as specified in &enum nl80211_iftype
  * Returns:
  *	1 if radar detection is required, 0 if it is not, < 0 on error
  */
-int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef,
-				  enum nl80211_iftype);
+int cfg80211_chandef_dfs_check(struct wiphy *wiphy,
+			       const struct cfg80211_chan_def *chandef,
+			       enum nl80211_iftype);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
@@ -1625,7 +1625,7 @@ struct cfg80211_assoc_request {
  * @ie_len: Length of ie buffer in octets
  * @reason_code: The reason code for the deauthentication
  * @local_state_change: if set, change local state only and
- *	do not set a deauth frame
+ *	do not send a deauth frame
  */
 struct cfg80211_deauth_request {
 	const u8 *bssid;
diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 57b8ab1..c59df5a 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -558,9 +558,9 @@ int ieee80211_vif_use_channel(struct ieee80211_sub_if_data *sdata,
 
 	mutex_lock(&local->chanctx_mtx);
 
-	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
-					    chandef,
-					    sdata->wdev.iftype);
+	ret = cfg80211_chandef_dfs_check(local->hw.wiphy,
+					 chandef,
+					 sdata->wdev.iftype);
 	if (ret < 0)
 		goto out;
 	if (ret > 0)
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index ff4d415..63e3034 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -283,8 +283,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &chandef, NL80211_IFTYPE_ADHOC);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &chandef, NL80211_IFTYPE_ADHOC);
 	if (err < 0) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, invalid chandef\n");
@@ -775,9 +775,9 @@ static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
 	/* if the current channel is a DFS channel, mark the channel as
 	 * unavailable.
 	 */
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &ifibss->chandef,
-					    NL80211_IFTYPE_ADHOC);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &ifibss->chandef,
+					 NL80211_IFTYPE_ADHOC);
 	if (err > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
@@ -875,9 +875,9 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef,
-					    NL80211_IFTYPE_ADHOC);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &params.chandef,
+					 NL80211_IFTYPE_ADHOC);
 	if (err < 0)
 		goto disconnect;
 	if (err > 0 && !ifibss->userspace_handles_dfs) {
@@ -1645,9 +1645,9 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
 	int i;
 	int ret;
 
-	ret = cfg80211_chandef_dfs_required(local->hw.wiphy,
-					    &params->chandef,
-					    sdata->wdev.iftype);
+	ret = cfg80211_chandef_dfs_check(local->hw.wiphy,
+					 &params->chandef,
+					 sdata->wdev.iftype);
 	if (ret < 0)
 		return ret;
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 9d29237..601d51f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -902,9 +902,9 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef,
-					    NL80211_IFTYPE_MESH_POINT);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &params.chandef,
+					 NL80211_IFTYPE_MESH_POINT);
 	if (err < 0)
 		return false;
 	if (err > 0)
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index e9d8f46..82c0e16 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -303,9 +303,9 @@ static u32 cfg80211_get_end_freq(u32 center_freq,
 	return end_freq;
 }
 
-static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
-					    u32 center_freq,
-					    u32 bandwidth)
+static int cfg80211_do_chandef_dfs_check(struct wiphy *wiphy,
+					 u32 center_freq,
+					 u32 bandwidth)
 {
 	struct ieee80211_channel *c;
 	u32 freq, start_freq, end_freq;
@@ -325,9 +325,9 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 }
 
 
-int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef,
-				  enum nl80211_iftype iftype)
+int cfg80211_chandef_dfs_check(struct wiphy *wiphy,
+			       const struct cfg80211_chan_def *chandef,
+			       enum nl80211_iftype iftype)
 {
 	int width;
 	int ret;
@@ -341,12 +341,9 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_MESH_POINT:
 		width = cfg80211_chandef_get_width(chandef);
-		if (width < 0)
-			return -EINVAL;
-
-		ret = cfg80211_get_chans_dfs_required(wiphy,
-						      chandef->center_freq1,
-						      width);
+		ret = cfg80211_do_chandef_dfs_check(wiphy,
+						    chandef->center_freq1,
+						    width);
 		if (ret < 0)
 			return ret;
 		else if (ret > 0)
@@ -355,9 +352,9 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 		if (!chandef->center_freq2)
 			return 0;
 
-		ret = cfg80211_get_chans_dfs_required(wiphy,
-						      chandef->center_freq2,
-						      width);
+		ret = cfg80211_do_chandef_dfs_check(wiphy,
+						    chandef->center_freq2,
+						    width);
 		if (ret < 0)
 			return ret;
 		else if (ret > 0)
@@ -378,7 +375,7 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 
 	return 0;
 }
-EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
+EXPORT_SYMBOL(cfg80211_chandef_dfs_check);
 
 static int cfg80211_get_chans_dfs_usable(struct wiphy *wiphy,
 					 u32 center_freq,
@@ -778,8 +775,8 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 	    !cfg80211_go_permissive_chan(rdev, chandef->chan))
 		prohibited_flags |= IEEE80211_CHAN_NO_IR;
 
-	if (cfg80211_chandef_dfs_required(wiphy, chandef,
-					  NL80211_IFTYPE_UNSPECIFIED) > 0 &&
+	if (cfg80211_chandef_dfs_check(wiphy, chandef,
+				       NL80211_IFTYPE_UNSPECIFIED) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
 		prohibited_flags = IEEE80211_CHAN_DISABLED;
@@ -853,9 +850,9 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
-							    &wdev->chandef,
-							    wdev->iftype);
+			ret = cfg80211_chandef_dfs_check(wdev->wiphy,
+							 &wdev->chandef,
+							 wdev->iftype);
 			WARN_ON(ret < 0);
 			if (ret > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
@@ -866,9 +863,9 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			ret = cfg80211_chandef_dfs_required(wdev->wiphy,
-							    &wdev->chandef,
-							    wdev->iftype);
+			ret = cfg80211_chandef_dfs_check(wdev->wiphy,
+							 &wdev->chandef,
+							 wdev->iftype);
 			WARN_ON(ret < 0);
 			if (ret > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fce423a..710bb69 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5790,8 +5790,8 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef,
-					    NL80211_IFTYPE_UNSPECIFIED);
+	err = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef,
+					 NL80211_IFTYPE_UNSPECIFIED);
 	if (err < 0)
 		return err;
 
@@ -5921,9 +5921,9 @@ skip_beacons:
 				     wdev->iftype))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy,
-					    &params.chandef,
-					    wdev->iftype);
+	err = cfg80211_chandef_dfs_check(wdev->wiphy,
+					 &params.chandef,
+					 wdev->iftype);
 	if (err < 0)
 		return err;
 
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 47b499f..df7ec99 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2210,7 +2210,7 @@ TRACE_EVENT(cfg80211_reg_can_beacon,
 		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG, __entry->iftype)
 );
 
-TRACE_EVENT(cfg80211_chandef_dfs_required,
+TRACE_EVENT(cfg80211_chandef_dfs_check,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
 	TP_ARGS(wiphy, chandef),
 	TP_STRUCT__entry(
-- 
1.9.0

