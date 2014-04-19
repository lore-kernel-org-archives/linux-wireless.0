Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34217 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaDSQeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 12:34:00 -0400
Received: by mail-pb0-f47.google.com with SMTP id up15so2384290pbc.34
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 09:34:00 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/3] cfg80211/mac80211: rename cfg80211_chandef_dfs_required()
Date: Sun, 20 Apr 2014 00:32:38 +0800
Message-Id: <2cb4d1718de3cbda2d9a26b4da3100ded10ae730.1397924746.git.gamerh2o@gmail.com> (sfid-20140419_183405_955655_ED750745)
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change the name to cfg80211_chandef_dfs_check to emphasize that the
function isn't a yes/no function, its return value must be fully
checked.

Also rename the helper function's name to
cfg80211_do_chandef_dfs_check for consistency.

Variable width needn't to be checked for sanity, since above
cfg80211_chandef_valid() already checked the sanity of chandef->width.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 include/net/cfg80211.h |  6 +++---
 net/mac80211/ibss.c    | 12 ++++++------
 net/mac80211/mesh.c    |  4 ++--
 net/wireless/chan.c    | 32 +++++++++++++++-----------------
 net/wireless/mesh.c    |  2 +-
 net/wireless/nl80211.c |  8 ++++----
 net/wireless/trace.h   |  2 +-
 7 files changed, 32 insertions(+), 34 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 6eb2420..54d4f67 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -438,13 +438,13 @@ bool cfg80211_chandef_usable(struct wiphy *wiphy,
 			     u32 prohibited_flags);
 
 /**
- * cfg80211_chandef_dfs_required - checks if radar detection is required
+ * cfg80211_chandef_dfs_check - checks if radar detection is required
  * @wiphy: the wiphy to validate against
  * @chandef: the channel definition to check
  * Return: 1 if radar detection is required, 0 if it is not, < 0 on error
  */
-int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef);
+int cfg80211_chandef_dfs_check(struct wiphy *wiphy,
+			       const struct cfg80211_chan_def *chandef);
 
 /**
  * ieee80211_chandef_rate_flags - returns rate flags for a channel
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 06d2878..18dd2e2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -281,8 +281,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &chandef);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &chandef);
 	if (err < 0) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, invalid chandef\n");
@@ -774,8 +774,8 @@ static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
 	/* if the current channel is a DFS channel, mark the channel as
 	 * unavailable.
 	 */
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &ifibss->chandef);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &ifibss->chandef);
 	if (err > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
@@ -872,8 +872,8 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &params.chandef);
 	if (err < 0)
 		goto disconnect;
 	if (err) {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index f70e9cd..33cf125 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -902,8 +902,8 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	err = cfg80211_chandef_dfs_required(sdata->local->hw.wiphy,
-					    &params.chandef);
+	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+					 &params.chandef);
 	if (err < 0)
 		return false;
 	if (err) {
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 2cfff9e..aaf24fc 100644
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
@@ -325,8 +325,8 @@ static int cfg80211_get_chans_dfs_required(struct wiphy *wiphy,
 }
 
 
-int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
-				  const struct cfg80211_chan_def *chandef)
+int cfg80211_chandef_dfs_check(struct wiphy *wiphy,
+			       const struct cfg80211_chan_def *chandef)
 {
 	int width;
 	int r;
@@ -335,21 +335,19 @@ int cfg80211_chandef_dfs_required(struct wiphy *wiphy,
 		return -EINVAL;
 
 	width = cfg80211_chandef_get_width(chandef);
-	if (width < 0)
-		return -EINVAL;
 
-	r = cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq1,
-					    width);
+	r = cfg80211_do_chandef_dfs_check(wiphy, chandef->center_freq1,
+					  width);
 	if (r)
 		return r;
 
 	if (!chandef->center_freq2)
 		return 0;
 
-	return cfg80211_get_chans_dfs_required(wiphy, chandef->center_freq2,
-					       width);
+	return cfg80211_do_chandef_dfs_check(wiphy, chandef->center_freq2,
+					     width);
 }
-EXPORT_SYMBOL(cfg80211_chandef_dfs_required);
+EXPORT_SYMBOL(cfg80211_chandef_dfs_check);
 
 static int cfg80211_get_chans_dfs_usable(struct wiphy *wiphy,
 					 u32 center_freq,
@@ -671,7 +669,7 @@ bool cfg80211_reg_can_beacon(struct wiphy *wiphy,
 
 	trace_cfg80211_reg_can_beacon(wiphy, chandef);
 
-	if (cfg80211_chandef_dfs_required(wiphy, chandef) > 0 &&
+	if (cfg80211_chandef_dfs_check(wiphy, chandef) > 0 &&
 	    cfg80211_chandef_dfs_available(wiphy, chandef)) {
 		/* We can skip IEEE80211_CHAN_NO_IR if chandef dfs available */
 		prohibited_flags = IEEE80211_CHAN_DISABLED;
@@ -743,8 +741,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef) > 0)
+			if (cfg80211_chandef_dfs_check(wdev->wiphy,
+						       &wdev->chandef) > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
@@ -753,8 +751,8 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 			*chan = wdev->chandef.chan;
 			*chanmode = CHAN_MODE_SHARED;
 
-			if (cfg80211_chandef_dfs_required(wdev->wiphy,
-							  &wdev->chandef) > 0)
+			if (cfg80211_chandef_dfs_check(wdev->wiphy,
+						       &wdev->chandef) > 0)
 				*radar_detect |= BIT(wdev->chandef.width);
 		}
 		return;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index 5af5cc6..d196a7c 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -178,7 +178,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &setup->chandef);
+	err = cfg80211_chandef_dfs_check(wdev->wiphy, &setup->chandef);
 	if (err < 0)
 		return err;
 	if (err)
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b6b2f6f..305ede8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3261,7 +3261,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
+	err = cfg80211_chandef_dfs_check(wdev->wiphy, &params.chandef);
 	if (err < 0)
 		return err;
 	if (err) {
@@ -5796,7 +5796,7 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_required(wdev->wiphy, &chandef);
+	err = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef);
 	if (err < 0)
 		return err;
 
@@ -5936,8 +5936,8 @@ skip_beacons:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		err = cfg80211_chandef_dfs_required(wdev->wiphy,
-						    &params.chandef);
+		err = cfg80211_chandef_dfs_check(wdev->wiphy,
+						 &params.chandef);
 		if (err < 0)
 			return err;
 		if (err) {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index aabccf1..80770f4 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2207,7 +2207,7 @@ TRACE_EVENT(cfg80211_reg_can_beacon,
 		  WIPHY_PR_ARG, CHAN_DEF_PR_ARG)
 );
 
-TRACE_EVENT(cfg80211_chandef_dfs_required,
+TRACE_EVENT(cfg80211_chandef_dfs_check,
 	TP_PROTO(struct wiphy *wiphy, struct cfg80211_chan_def *chandef),
 	TP_ARGS(wiphy, chandef),
 	TP_STRUCT__entry(
-- 
1.9.0

