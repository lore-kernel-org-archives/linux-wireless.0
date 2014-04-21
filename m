Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52921 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaDUEz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 00:55:28 -0400
Received: by mail-pd0-f181.google.com with SMTP id p10so3266426pdj.26
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 21:55:27 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 12/12] cfg80211/mac80211: change variable name
Date: Mon, 21 Apr 2014 12:53:07 +0800
Message-Id: <556860ba8846b238bddd8f41af02842177e08ba9.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065542_173068_4D8271D1)
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1398055853.git.gamerh2o@gmail.com>
References: <cover.1398055853.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change "err" to "ret", since return value isn't zero doesn't always
mean error occured, sometimes it means success.

if (err)
        /* do things if function successfully returned */

looks strange to me, so change it.

This change related to the functions which call
cfg80211_chandef_dfs_check(), since cfg80211_chandef_dfs_check()
returns 1 means dfs is required.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/ibss.c    | 38 ++++++++++++++---------------
 net/mac80211/mesh.c    | 16 ++++++------
 net/wireless/nl80211.c | 66 +++++++++++++++++++++++++-------------------------
 3 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 63e3034..18466f8 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,7 +229,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
 	bool radar_required;
-	int err;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -283,20 +283,20 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &chandef, NL80211_IFTYPE_ADHOC);
-	if (err < 0) {
+	if (ret < 0) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, invalid chandef\n");
 		return;
 	}
-	if (err > 0 && !ifibss->userspace_handles_dfs) {
+	if (ret > 0 && !ifibss->userspace_handles_dfs) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, DFS channel without control program\n");
 		return;
 	}
 
-	radar_required = err;
+	radar_required = ret;
 
 	mutex_lock(&local->mtx);
 	if (ieee80211_vif_use_channel(sdata, &chandef,
@@ -360,8 +360,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
 
-	err = drv_join_ibss(local, sdata);
-	if (err) {
+	ret = drv_join_ibss(local, sdata);
+	if (ret) {
 		sdata->vif.bss_conf.ibss_joined = false;
 		sdata->vif.bss_conf.ibss_creator = false;
 		sdata->vif.bss_conf.enable_beacon = false;
@@ -372,7 +372,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&local->mtx);
 		sdata_info(sdata, "Failed to join IBSS, driver failure: %d\n",
-			   err);
+			   ret);
 		return;
 	}
 
@@ -770,15 +770,15 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 static void ieee80211_ibss_csa_mark_radar(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
-	int err;
+	int ret;
 
 	/* if the current channel is a DFS channel, mark the channel as
 	 * unavailable.
 	 */
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &ifibss->chandef,
 					 NL80211_IFTYPE_ADHOC);
-	if (err > 0)
+	if (ret > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
 }
@@ -792,7 +792,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	enum nl80211_channel_type ch_type;
-	int err;
+	int ret;
 	u32 sta_flags;
 
 	sdata_assert_lock(sdata);
@@ -813,15 +813,15 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
+	ret = ieee80211_parse_ch_switch_ie(sdata, elems, beacon,
 					   ifibss->chandef.chan->band,
 					   sta_flags, ifibss->bssid, &csa_ie);
 	/* can't switch to destination channel, fail */
-	if (err < 0)
+	if (ret < 0)
 		goto disconnect;
 
 	/* did not contain a CSA */
-	if (err)
+	if (ret)
 		return false;
 
 	/* channel switch is not supported, disconnect */
@@ -875,17 +875,17 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &params.chandef,
 					 NL80211_IFTYPE_ADHOC);
-	if (err < 0)
+	if (ret < 0)
 		goto disconnect;
-	if (err > 0 && !ifibss->userspace_handles_dfs) {
+	if (ret > 0 && !ifibss->userspace_handles_dfs) {
 		/* IBSS-DFS only allowed with a control program */
 		goto disconnect;
 	}
 
-	params.radar_required = err;
+	params.radar_required = ret;
 
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 601d51f..a745a10 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -861,7 +861,7 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
-	int err;
+	int ret;
 	u32 sta_flags;
 
 	sdata_assert_lock(sdata);
@@ -879,12 +879,12 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	memset(&params, 0, sizeof(params));
 	memset(&csa_ie, 0, sizeof(csa_ie));
-	err = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
+	ret = ieee80211_parse_ch_switch_ie(sdata, elems, beacon, band,
 					   sta_flags, sdata->vif.addr,
 					   &csa_ie);
-	if (err < 0)
+	if (ret < 0)
 		return false;
-	if (err)
+	if (ret)
 		return false;
 
 	params.chandef = csa_ie.chandef;
@@ -902,16 +902,16 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &params.chandef,
 					 NL80211_IFTYPE_MESH_POINT);
-	if (err < 0)
+	if (ret < 0)
 		return false;
-	if (err > 0)
+	if (ret > 0)
 		/* TODO: DFS not (yet) supported */
 		return false;
 
-	params.radar_required = err;
+	params.radar_required = ret;
 
 	if (cfg80211_chandef_identical(&params.chandef,
 				       &sdata->vif.bss_conf.chandef)) {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 710bb69..89c9ece 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5774,15 +5774,15 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	struct cfg80211_chan_def chandef;
 	enum nl80211_dfs_regions dfs_region;
 	unsigned int cac_time_ms;
-	int err;
+	int ret;
 
 	dfs_region = reg_get_dfs_region(wdev->wiphy);
 	if (dfs_region == NL80211_DFS_UNSET)
 		return -EINVAL;
 
-	err = nl80211_parse_chandef(rdev, info, &chandef);
-	if (err)
-		return err;
+	ret = nl80211_parse_chandef(rdev, info, &chandef);
+	if (ret)
+		return ret;
 
 	if (netif_carrier_ok(dev))
 		return -EBUSY;
@@ -5790,12 +5790,12 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef,
+	ret = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef,
 					 NL80211_IFTYPE_UNSPECIFIED);
-	if (err < 0)
-		return err;
+	if (ret < 0)
+		return ret;
 
-	if (err == 0)
+	if (ret == 0)
 		return -EINVAL;
 
 	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
@@ -5808,15 +5808,15 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (WARN_ON(!cac_time_ms))
 		cac_time_ms = IEEE80211_DFS_MIN_CAC_TIME_MS;
 
-	err = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
+	ret = rdev->ops->start_radar_detection(&rdev->wiphy, dev, &chandef,
 					       cac_time_ms);
-	if (!err) {
+	if (!ret) {
 		wdev->chandef = chandef;
 		wdev->cac_started = true;
 		wdev->cac_start_time = jiffies;
 		wdev->cac_time_ms = cac_time_ms;
 	}
-	return err;
+	return ret;
 }
 
 static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
@@ -5830,7 +5830,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	 */
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
 	u8 radar_detect_width = 0;
-	int err;
+	int ret;
 	bool need_new_beacon = false;
 
 	if (!rdev->ops->channel_switch ||
@@ -5873,19 +5873,19 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	if (!need_new_beacon)
 		goto skip_beacons;
 
-	err = nl80211_parse_beacon(info->attrs, &params.beacon_after);
-	if (err)
-		return err;
+	ret = nl80211_parse_beacon(info->attrs, &params.beacon_after);
+	if (ret)
+		return ret;
 
-	err = nla_parse_nested(csa_attrs, NL80211_ATTR_MAX,
+	ret = nla_parse_nested(csa_attrs, NL80211_ATTR_MAX,
 			       info->attrs[NL80211_ATTR_CSA_IES],
 			       nl80211_policy);
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
-	err = nl80211_parse_beacon(csa_attrs, &params.beacon_csa);
-	if (err)
-		return err;
+	ret = nl80211_parse_beacon(csa_attrs, &params.beacon_csa);
+	if (ret)
+		return ret;
 
 	if (!csa_attrs[NL80211_ATTR_CSA_C_OFF_BEACON])
 		return -EINVAL;
@@ -5913,21 +5913,21 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 skip_beacons:
-	err = nl80211_parse_chandef(rdev, info, &params.chandef);
-	if (err)
-		return err;
+	ret = nl80211_parse_chandef(rdev, info, &params.chandef);
+	if (ret)
+		return ret;
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef,
 				     wdev->iftype))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_check(wdev->wiphy,
+	ret = cfg80211_chandef_dfs_check(wdev->wiphy,
 					 &params.chandef,
 					 wdev->iftype);
-	if (err < 0)
-		return err;
+	if (ret < 0)
+		return ret;
 
-	if (err > 0) {
+	if (ret > 0) {
 		radar_detect_width = BIT(params.chandef.width);
 		params.radar_required = true;
 	}
@@ -5936,21 +5936,21 @@ skip_beacons:
 	 * verification is a bit more complicated, because we only do
 	 * it later when the channel switch really happens.
 	 */
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+	ret = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
 					   radar_detect_width);
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
 	if (info->attrs[NL80211_ATTR_CH_SWITCH_BLOCK_TX])
 		params.block_tx = true;
 
 	wdev_lock(wdev);
-	err = rdev_channel_switch(rdev, dev, &params);
+	ret = rdev_channel_switch(rdev, dev, &params);
 	wdev_unlock(wdev);
 
-	return err;
+	return ret;
 }
 
 static int nl80211_send_bss(struct sk_buff *msg, struct netlink_callback *cb,
-- 
1.9.0

