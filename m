Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f54.google.com ([209.85.160.54]:55306 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaDSQeF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Apr 2014 12:34:05 -0400
Received: by mail-pb0-f54.google.com with SMTP id ma3so2400298pbc.27
        for <linux-wireless@vger.kernel.org>; Sat, 19 Apr 2014 09:34:05 -0700 (PDT)
From: "Zhao, Gang" <gamerh2o@gmail.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 3/3] cfg80211: change variable name
Date: Sun, 20 Apr 2014 00:32:39 +0800
Message-Id: <d0f5d57fd8619741e295e35b1bcba933adb1f19d.1397924746.git.gamerh2o@gmail.com> (sfid-20140419_183410_777401_BE52D30B)
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
In-Reply-To: <cover.1397924746.git.gamerh2o@gmail.com>
References: <cover.1397924746.git.gamerh2o@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Change "err" to "ret", since return value isn't zero doesn't always
mean error occured, sometimes it means success.

if (err)
        /* do things if function successfully returned */

looks strange to me, so change it.

Signed-off-by: Zhao, Gang <gamerh2o@gmail.com>
---
 net/mac80211/ibss.c    |  34 +++++++-------
 net/mac80211/mesh.c    |  14 +++---
 net/wireless/mesh.c    |  22 ++++-----
 net/wireless/nl80211.c | 118 ++++++++++++++++++++++++-------------------------
 4 files changed, 94 insertions(+), 94 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 18dd2e2..6c08424 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -229,7 +229,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	enum nl80211_bss_scan_width scan_width;
 	bool have_higher_than_11mbit;
 	bool radar_required = false;
-	int err;
+	int ret;
 
 	sdata_assert_lock(sdata);
 
@@ -281,14 +281,14 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &chandef);
-	if (err < 0) {
+	if (ret < 0) {
 		sdata_info(sdata,
 			   "Failed to join IBSS, invalid chandef\n");
 		return;
 	}
-	if (err > 0) {
+	if (ret > 0) {
 		if (!ifibss->userspace_handles_dfs) {
 			sdata_info(sdata,
 				   "Failed to join IBSS, DFS channel without control program\n");
@@ -359,8 +359,8 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.bss_conf.ibss_joined = true;
 	sdata->vif.bss_conf.ibss_creator = creator;
 
-	err = drv_join_ibss(local, sdata);
-	if (err) {
+	ret = drv_join_ibss(local, sdata);
+	if (ret) {
 		sdata->vif.bss_conf.ibss_joined = false;
 		sdata->vif.bss_conf.ibss_creator = false;
 		sdata->vif.bss_conf.enable_beacon = false;
@@ -371,7 +371,7 @@ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
 		ieee80211_vif_release_channel(sdata);
 		mutex_unlock(&local->mtx);
 		sdata_info(sdata, "Failed to join IBSS, driver failure: %d\n",
-			   err);
+			   ret);
 		return;
 	}
 
@@ -769,14 +769,14 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
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
 					 &ifibss->chandef);
-	if (err > 0)
+	if (ret > 0)
 		cfg80211_radar_event(sdata->local->hw.wiphy, &ifibss->chandef,
 				     GFP_ATOMIC);
 }
@@ -790,7 +790,7 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_csa_ie csa_ie;
 	struct ieee80211_if_ibss *ifibss = &sdata->u.ibss;
 	enum nl80211_channel_type ch_type;
-	int err;
+	int ret;
 	u32 sta_flags;
 
 	sdata_assert_lock(sdata);
@@ -811,15 +811,15 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 
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
@@ -872,11 +872,11 @@ ieee80211_ibss_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		goto disconnect;
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &params.chandef);
-	if (err < 0)
+	if (ret < 0)
 		goto disconnect;
-	if (err) {
+	if (ret) {
 		/* IBSS-DFS only allowed with a control program */
 		if (!ifibss->userspace_handles_dfs)
 			goto disconnect;
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 33cf125..336b963 100644
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
@@ -902,11 +902,11 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 		return false;
 	}
 
-	err = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
+	ret = cfg80211_chandef_dfs_check(sdata->local->hw.wiphy,
 					 &params.chandef);
-	if (err < 0)
+	if (ret < 0)
 		return false;
-	if (err) {
+	if (ret) {
 		params.radar_required = true;
 		/* TODO: DFS not (yet) supported */
 		return false;
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index d196a7c..1e74e5d 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -100,7 +100,7 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	u8 radar_detect_width = 0;
-	int err;
+	int ret;
 
 	BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
 
@@ -178,27 +178,27 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &setup->chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_check(wdev->wiphy, &setup->chandef);
-	if (err < 0)
-		return err;
-	if (err)
+	ret = cfg80211_chandef_dfs_check(wdev->wiphy, &setup->chandef);
+	if (ret < 0)
+		return ret;
+	if (ret)
 		radar_detect_width = BIT(setup->chandef.width);
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+	ret = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   setup->chandef.chan,
 					   CHAN_MODE_SHARED,
 					   radar_detect_width);
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
-	err = rdev_join_mesh(rdev, dev, conf, setup);
-	if (!err) {
+	ret = rdev_join_mesh(rdev, dev, conf, setup);
+	if (!ret) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
 		wdev->mesh_id_len = setup->mesh_id_len;
 		wdev->chandef = setup->chandef;
 	}
 
-	return err;
+	return ret;
 }
 
 int cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 305ede8..eca64cd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3141,7 +3141,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
-	int err;
+	int ret;
 	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
@@ -3162,18 +3162,18 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	    !info->attrs[NL80211_ATTR_BEACON_HEAD])
 		return -EINVAL;
 
-	err = nl80211_parse_beacon(info->attrs, &params.beacon);
-	if (err)
-		return err;
+	ret = nl80211_parse_beacon(info->attrs, &params.beacon);
+	if (ret)
+		return ret;
 
 	params.beacon_interval =
 		nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 	params.dtim_period =
 		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
 
-	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
-	if (err)
-		return err;
+	ret = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
+	if (ret)
+		return ret;
 
 	/*
 	 * In theory, some of these attributes should be required here
@@ -3211,10 +3211,10 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	} else
 		params.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 
-	err = nl80211_crypto_settings(rdev, info, &params.crypto,
+	ret = nl80211_crypto_settings(rdev, info, &params.crypto,
 				      NL80211_MAX_NR_CIPHER_SUITES);
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
 	if (info->attrs[NL80211_ATTR_INACTIVITY_TIMEOUT]) {
 		if (!(rdev->wiphy.features & NL80211_FEATURE_INACTIVITY_TIMER))
@@ -3250,9 +3250,9 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_FREQ]) {
-		err = nl80211_parse_chandef(rdev, info, &params.chandef);
-		if (err)
-			return err;
+		ret = nl80211_parse_chandef(rdev, info, &params.chandef);
+		if (ret)
+			return ret;
 	} else if (wdev->preset_chandef.chan) {
 		params.chandef = wdev->preset_chandef;
 	} else if (!nl80211_get_ap_channel(rdev, &params))
@@ -3261,20 +3261,20 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
-	err = cfg80211_chandef_dfs_check(wdev->wiphy, &params.chandef);
-	if (err < 0)
-		return err;
-	if (err) {
+	ret = cfg80211_chandef_dfs_check(wdev->wiphy, &params.chandef);
+	if (ret < 0)
+		return ret;
+	if (ret) {
 		radar_detect_width = BIT(params.chandef.width);
 		params.radar_required = true;
 	}
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+	ret = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   params.chandef.chan,
 					   CHAN_MODE_SHARED,
 					   radar_detect_width);
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
 	if (info->attrs[NL80211_ATTR_ACL_POLICY]) {
 		params.acl = parse_acl_data(&rdev->wiphy, info);
@@ -3283,8 +3283,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	wdev_lock(wdev);
-	err = rdev_start_ap(rdev, dev, &params);
-	if (!err) {
+	ret = rdev_start_ap(rdev, dev, &params);
+	if (!ret) {
 		wdev->preset_chandef = params.chandef;
 		wdev->beacon_interval = params.beacon_interval;
 		wdev->chandef = params.chandef;
@@ -3295,7 +3295,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 
 	kfree(params.acl);
 
-	return err;
+	return ret;
 }
 
 static int nl80211_set_beacon(struct sk_buff *skb, struct genl_info *info)
@@ -5780,15 +5780,15 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
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
@@ -5796,11 +5796,11 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (wdev->cac_started)
 		return -EBUSY;
 
-	err = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef);
-	if (err < 0)
-		return err;
+	ret = cfg80211_chandef_dfs_check(wdev->wiphy, &chandef);
+	if (ret < 0)
+		return ret;
 
-	if (err == 0)
+	if (ret == 0)
 		return -EINVAL;
 
 	if (!cfg80211_chandef_dfs_usable(wdev->wiphy, &chandef))
@@ -5809,25 +5809,25 @@ static int nl80211_start_radar_detection(struct sk_buff *skb,
 	if (!rdev->ops->start_radar_detection)
 		return -EOPNOTSUPP;
 
-	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+	ret = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
 					   chandef.chan, CHAN_MODE_SHARED,
 					   BIT(chandef.width));
-	if (err)
-		return err;
+	if (ret)
+		return ret;
 
 	cac_time_ms = cfg80211_chandef_dfs_cac_time(&rdev->wiphy, &chandef);
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
@@ -5841,7 +5841,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	 */
 	static struct nlattr *csa_attrs[NL80211_ATTR_MAX+1];
 	u8 radar_detect_width = 0;
-	int err;
+	int ret;
 	bool need_new_beacon = false;
 
 	if (!rdev->ops->channel_switch ||
@@ -5884,19 +5884,19 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
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
@@ -5924,9 +5924,9 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 skip_beacons:
-	err = nl80211_parse_chandef(rdev, info, &params.chandef);
-	if (err)
-		return err;
+	ret = nl80211_parse_chandef(rdev, info, &params.chandef);
+	if (ret)
+		return ret;
 
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
@@ -5936,11 +5936,11 @@ skip_beacons:
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_ADHOC:
 	case NL80211_IFTYPE_MESH_POINT:
-		err = cfg80211_chandef_dfs_check(wdev->wiphy,
+		ret = cfg80211_chandef_dfs_check(wdev->wiphy,
 						 &params.chandef);
-		if (err < 0)
-			return err;
-		if (err) {
+		if (ret < 0)
+			return ret;
+		if (ret) {
 			radar_detect_width = BIT(params.chandef.width);
 			params.radar_required = true;
 		}
@@ -5949,21 +5949,21 @@ skip_beacons:
 		break;
 	}
 
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

