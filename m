Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24723 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752101AbcJJMHT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 08:07:19 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH] cfg80211: Create structure for combination check/iter function parameters
Date: Mon, 10 Oct 2016 17:36:59 +0530
Message-ID: <1476101219-29599-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20161010_140732_512617_717CB671)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move growing parameter list to a structure for check/iter combination
functions in cfg80211 and mac80211.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 25 ++++-----
 include/net/cfg80211.h                             | 56 ++++++++++----------
 net/mac80211/util.c                                | 42 ++++++++-------
 net/wireless/util.c                                | 59 +++++++++-------------
 4 files changed, 86 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 1e73c88..00c5fb2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -414,24 +414,25 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 				     struct brcmf_cfg80211_vif *vif,
 				     enum nl80211_iftype new_type)
 {
-	int iftype_num[NUM_NL80211_IFTYPES];
+	struct iface_combination_params params;
 	struct brcmf_cfg80211_vif *pos;
 	bool check_combos = false;
 	int ret = 0;
 
-	memset(&iftype_num[0], 0, sizeof(iftype_num));
+	memset(&params, 0, sizeof(params));
+	params.num_different_channels = 1;
+
 	list_for_each_entry(pos, &cfg->vif_list, list)
 		if (pos == vif) {
-			iftype_num[new_type]++;
+			params.iftype_num[new_type]++;
 		} else {
 			/* concurrent interfaces so need check combinations */
 			check_combos = true;
-			iftype_num[pos->wdev.iftype]++;
+			params.iftype_num[pos->wdev.iftype]++;
 		}
 
 	if (check_combos)
-		ret = cfg80211_check_combinations(cfg->wiphy, 1, 0,
-						  iftype_num, 0, false);
+		ret = cfg80211_check_combinations(cfg->wiphy, &params);
 
 	return ret;
 }
@@ -439,16 +440,16 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 static int brcmf_vif_add_validate(struct brcmf_cfg80211_info *cfg,
 				  enum nl80211_iftype new_type)
 {
-	int iftype_num[NUM_NL80211_IFTYPES];
+	struct iface_combination_params params;
 	struct brcmf_cfg80211_vif *pos;
 
-	memset(&iftype_num[0], 0, sizeof(iftype_num));
+	memset(&params, 0, sizeof(params));
 	list_for_each_entry(pos, &cfg->vif_list, list)
-		iftype_num[pos->wdev.iftype]++;
+		params.iftype_num[pos->wdev.iftype]++;
 
-	iftype_num[new_type]++;
-	return cfg80211_check_combinations(cfg->wiphy, 1, 0,
-					   iftype_num, 0, false);
+	params.iftype_num[new_type]++;
+	params.num_different_channels = 1;
+	return cfg80211_check_combinations(cfg->wiphy, &params);
 }
 
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 49aa6a0..4e509ed 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -772,6 +772,30 @@ struct cfg80211_csa_settings {
 };
 
 /**
+ * struct iface_combination_params - input parameters for interface combinations
+ *
+ * Used to pass interface combination parameters
+ *
+ * @num_different_channels: the number of different channels we want
+ *	to use for verification
+ * @radar_detect: a bitmap where each bit corresponds to a channel
+ *	width where radar detection is needed, as in the definition of
+ *	&struct ieee80211_iface_combination.@radar_detect_widths
+ * @iftype_num: array with the numbers of interfaces of each interface
+ *	type.  The index is the interface type as specified in &enum
+ *	nl80211_iftype.
+ * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
+ * @diff_bi: a flag which denotes beacon intervals are different or same.
+ */
+struct iface_combination_params {
+	int num_different_channels;
+	u8 radar_detect;
+	int iftype_num[NUM_NL80211_IFTYPES];
+	u32 beacon_gcd;
+	bool diff_bi;
+};
+
+/**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
  * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
@@ -5583,41 +5607,20 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
  * cfg80211_check_combinations - check interface combinations
  *
  * @wiphy: the wiphy
- * @num_different_channels: the number of different channels we want
- *	to use for verification
- * @radar_detect: a bitmap where each bit corresponds to a channel
- *	width where radar detection is needed, as in the definition of
- *	&struct ieee80211_iface_combination.@radar_detect_widths
- * @iftype_num: array with the numbers of interfaces of each interface
- *	type.  The index is the interface type as specified in &enum
- *	nl80211_iftype.
- * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
- * @diff_bi: a flag which denotes beacon intervals are different or same.
+ * @params: the interface combinations parameter.
  *
  * This function can be called by the driver to check whether a
  * combination of interfaces and their types are allowed according to
  * the interface combinations.
  */
 int cfg80211_check_combinations(struct wiphy *wiphy,
-				const int num_different_channels,
-				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES],
-				const u32 beacon_gcd, bool diff_bi);
+				struct iface_combination_params *params);
 
 /**
  * cfg80211_iter_combinations - iterate over matching combinations
  *
  * @wiphy: the wiphy
- * @num_different_channels: the number of different channels we want
- *	to use for verification
- * @radar_detect: a bitmap where each bit corresponds to a channel
- *	width where radar detection is needed, as in the definition of
- *	&struct ieee80211_iface_combination.@radar_detect_widths
- * @iftype_num: array with the numbers of interfaces of each interface
- *	type.  The index is the interface type as specified in &enum
- *	nl80211_iftype.
- * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
- * @diff_bi: a flag which denotes beacon intervals are different or same.
+ * @params: the interface combinations parameter.
  * @iter: function to call for each matching combination
  * @data: pointer to pass to iter function
  *
@@ -5626,10 +5629,7 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
  * purposes.
  */
 int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       const int num_different_channels,
-			       const u8 radar_detect,
-			       const int iftype_num[NUM_NL80211_IFTYPES],
-			       const u32 beacon_gcd, bool diff_bi,
+			       struct iface_combination_params *params,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index cfef5ce..0607fe1 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3308,9 +3308,8 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *sdata_iter;
 	enum nl80211_iftype iftype = sdata->wdev.iftype;
-	int num[NUM_NL80211_IFTYPES];
+	struct iface_combination_params params;
 	struct ieee80211_chanctx *ctx;
-	int num_different_channels = 0;
 	int total = 1;
 
 	lockdep_assert_held(&local->chanctx_mtx);
@@ -3322,9 +3321,6 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		    !chandef->chan))
 		return -EINVAL;
 
-	if (chandef)
-		num_different_channels = 1;
-
 	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return -EINVAL;
 
@@ -3335,24 +3331,27 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
-	memset(num, 0, sizeof(num));
+	memset(&params, 0, sizeof(params));
+
+	if (chandef)
+		params.num_different_channels = 1;
 
 	if (iftype != NL80211_IFTYPE_UNSPECIFIED)
-		num[iftype] = 1;
+		params.iftype_num[iftype] = 1;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
 			continue;
 		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
 		if (ctx->mode == IEEE80211_CHANCTX_EXCLUSIVE) {
-			num_different_channels++;
+			params.num_different_channels++;
 			continue;
 		}
 		if (chandef && chanmode == IEEE80211_CHANCTX_SHARED &&
 		    cfg80211_chandef_compatible(chandef,
 						&ctx->conf.def))
 			continue;
-		num_different_channels++;
+		params.num_different_channels++;
 	}
 
 	list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
@@ -3365,16 +3364,16 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
-		num[wdev_iter->iftype]++;
+		params.iftype_num[wdev_iter->iftype]++;
 		total++;
 	}
 
 	if (total == 1 && !radar_detect)
 		return 0;
 
-	return cfg80211_check_combinations(local->hw.wiphy,
-					   num_different_channels,
-					   radar_detect, num, 0, false);
+	params.radar_detect = radar_detect;
+
+	return cfg80211_check_combinations(local->hw.wiphy, &params);
 }
 
 static void
@@ -3390,30 +3389,29 @@ ieee80211_iter_max_chans(const struct ieee80211_iface_combination *c,
 int ieee80211_max_num_channels(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int num[NUM_NL80211_IFTYPES] = {};
 	struct ieee80211_chanctx *ctx;
-	int num_different_channels = 0;
-	u8 radar_detect = 0;
+	struct iface_combination_params params;
 	u32 max_num_different_channels = 1;
 	int err;
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
+	memset(&params, 0, sizeof(params));
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
 			continue;
 
-		num_different_channels++;
+		params.num_different_channels++;
 
-		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
+		params.radar_detect |=
+			ieee80211_chanctx_radar_detect(local, ctx);
 	}
 
 	list_for_each_entry_rcu(sdata, &local->interfaces, list)
-		num[sdata->wdev.iftype]++;
+		params.iftype_num[sdata->wdev.iftype]++;
 
-	err = cfg80211_iter_combinations(local->hw.wiphy,
-					 num_different_channels, radar_detect,
-					 num, 0, false, ieee80211_iter_max_chans,
+	err = cfg80211_iter_combinations(local->hw.wiphy, &params,
+					 ieee80211_iter_max_chans,
 					 &max_num_different_channels);
 	if (err < 0)
 		return err;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0d3bda4..fe39ece 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1562,52 +1562,47 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 enum nl80211_iftype iftype, u32 beacon_int)
 {
 	struct wireless_dev *wdev;
-	bool diff_bi = false;
 	int res = 0;
-	u32 bi_prev, tmp_bi, gcd;
-	int iftype_num[NUM_NL80211_IFTYPES];
+	u32 bi_prev, tmp_bi;
+	struct iface_combination_params params;
 
 	if (beacon_int < 10 || beacon_int > 10000)
 		return -EINVAL;
 
-	memset(iftype_num, 0, sizeof(iftype_num));
-	iftype_num[iftype] = 1;
+	memset(&params, 0, sizeof(params));
+	params.iftype_num[iftype] = 1;
 
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 
-		iftype_num[wdev->iftype]++;
+		params.iftype_num[wdev->iftype]++;
 	}
 
 	/* GCD(n) = n */
-	gcd = beacon_int;
+	params.beacon_gcd = beacon_int;
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
-			diff_bi = true;
+			params.diff_bi = true;
 			/* Get the GCD */
 			bi_prev = wdev->beacon_interval;
 			while (bi_prev != 0) {
 				tmp_bi = bi_prev;
-				bi_prev = gcd % bi_prev;
-				gcd = tmp_bi;
+				bi_prev = params.beacon_gcd % bi_prev;
+				params.beacon_gcd = tmp_bi;
 			}
 			break;
 		}
 	}
 
-	res = cfg80211_check_combinations(&rdev->wiphy, 0, 0,
-					  iftype_num, gcd, diff_bi);
+	res = cfg80211_check_combinations(&rdev->wiphy, &params);
 	return (res < 0) ? res : 0;
 }
 
 int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       const int num_different_channels,
-			       const u8 radar_detect,
-			       const int iftype_num[NUM_NL80211_IFTYPES],
-			       const u32 beacon_gcd, bool diff_bi,
+			       struct iface_combination_params *params,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data)
@@ -1618,7 +1613,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	int num_interfaces = 0;
 	u32 used_iftypes = 0;
 
-	if (radar_detect) {
+	if (params->radar_detect) {
 		rcu_read_lock();
 		regdom = rcu_dereference(cfg80211_regdomain);
 		if (regdom)
@@ -1627,8 +1622,8 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	}
 
 	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-		num_interfaces += iftype_num[iftype];
-		if (iftype_num[iftype] > 0 &&
+		num_interfaces += params->iftype_num[iftype];
+		if (params->iftype_num[iftype] > 0 &&
 		    !(wiphy->software_iftypes & BIT(iftype)))
 			used_iftypes |= BIT(iftype);
 	}
@@ -1642,7 +1637,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 
 		if (num_interfaces > c->max_interfaces)
 			continue;
-		if (num_different_channels > c->num_different_channels)
+		if (params->num_different_channels > c->num_different_channels)
 			continue;
 
 		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
@@ -1657,16 +1652,17 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 				all_iftypes |= limits[j].types;
 				if (!(limits[j].types & BIT(iftype)))
 					continue;
-				if (limits[j].max < iftype_num[iftype])
+				if (limits[j].max < params->iftype_num[iftype])
 					goto cont;
-				limits[j].max -= iftype_num[iftype];
+				limits[j].max -= params->iftype_num[iftype];
 			}
 		}
 
-		if (radar_detect != (c->radar_detect_widths & radar_detect))
+		if (params->radar_detect !=
+			(c->radar_detect_widths & params->radar_detect))
 			goto cont;
 
-		if (radar_detect && c->radar_detect_regions &&
+		if (params->radar_detect && c->radar_detect_regions &&
 		    !(c->radar_detect_regions & BIT(region)))
 			goto cont;
 
@@ -1678,11 +1674,11 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 		if ((all_iftypes & used_iftypes) != used_iftypes)
 			goto cont;
 
-		if (beacon_gcd) {
+		if (params->beacon_gcd) {
 			if (c->beacon_int_min_gcd &&
-			    beacon_gcd < c->beacon_int_min_gcd)
+			    params->beacon_gcd < c->beacon_int_min_gcd)
 				return -EINVAL;
-			if (!c->beacon_int_min_gcd && diff_bi)
+			if (!c->beacon_int_min_gcd && params->diff_bi)
 				goto cont;
 		}
 
@@ -1708,16 +1704,11 @@ cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
 }
 
 int cfg80211_check_combinations(struct wiphy *wiphy,
-				const int num_different_channels,
-				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES],
-				const u32 beacon_gcd, bool diff_bi)
+				struct iface_combination_params *params)
 {
 	int err, num = 0;
 
-	err = cfg80211_iter_combinations(wiphy, num_different_channels,
-					 radar_detect, iftype_num,
-					 beacon_gcd, diff_bi,
+	err = cfg80211_iter_combinations(wiphy, params,
 					 cfg80211_iter_sum_ifcombs, &num);
 	if (err)
 		return err;
-- 
1.9.1
