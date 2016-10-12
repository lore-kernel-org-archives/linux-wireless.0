Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26722 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932874AbcJLM7A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 08:59:00 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH v2] cfg80211: Create structure for combination check/iter function parameters
Date: Wed, 12 Oct 2016 18:25:35 +0530
Message-ID: <1476276935-6902-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20161012_145923_889723_94A16374)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move growing parameter list to a structure for check/iter combination
functions in cfg80211 and mac80211.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 26 ++++++-----
 include/net/cfg80211.h                             | 46 ++++++++++----------
 net/mac80211/util.c                                | 50 +++++++++++-----------
 net/wireless/util.c                                | 28 ++++++------
 4 files changed, 78 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b777e1b..44e1c70 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -414,23 +414,26 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 				     struct brcmf_cfg80211_vif *vif,
 				     enum nl80211_iftype new_type)
 {
-	int iftype_num[NUM_NL80211_IFTYPES];
 	struct brcmf_cfg80211_vif *pos;
 	bool check_combos = false;
 	int ret = 0;
+	struct iface_combination_params params = {
+		.num_different_channels = 1,
+		.radar_detect = 0,
+		.iftype_num = {0},
+	};
 
-	memset(&iftype_num[0], 0, sizeof(iftype_num));
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
-		ret = cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+		ret = cfg80211_check_combinations(cfg->wiphy, &params);
 
 	return ret;
 }
@@ -438,15 +441,18 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 static int brcmf_vif_add_validate(struct brcmf_cfg80211_info *cfg,
 				  enum nl80211_iftype new_type)
 {
-	int iftype_num[NUM_NL80211_IFTYPES];
 	struct brcmf_cfg80211_vif *pos;
+	struct iface_combination_params params = {
+		.num_different_channels = 1,
+		.radar_detect = 0,
+		.iftype_num = {0},
+	};
 
-	memset(&iftype_num[0], 0, sizeof(iftype_num));
 	list_for_each_entry(pos, &cfg->vif_list, list)
-		iftype_num[pos->wdev.iftype]++;
+		params.iftype_num[pos->wdev.iftype]++;
 
-	iftype_num[new_type]++;
-	return cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+	params.iftype_num[new_type]++;
+	return cfg80211_check_combinations(cfg->wiphy, &params);
 }
 
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fe78f02..21bbe44 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -772,6 +772,26 @@ struct cfg80211_csa_settings {
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
+ */
+struct iface_combination_params {
+	int num_different_channels;
+	u8 radar_detect;
+	int iftype_num[NUM_NL80211_IFTYPES];
+};
+
+/**
  * enum station_parameters_apply_mask - station parameter values to apply
  * @STATION_PARAM_APPLY_UAPSD: apply new uAPSD parameters (uapsd_queues, max_sp)
  * @STATION_PARAM_APPLY_CAPABILITY: apply new capability
@@ -5575,36 +5595,20 @@ void cfg80211_report_wowlan_wakeup(struct wireless_dev *wdev,
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
+ * @params: the interface combinations parameter
  *
  * This function can be called by the driver to check whether a
  * combination of interfaces and their types are allowed according to
  * the interface combinations.
  */
 int cfg80211_check_combinations(struct wiphy *wiphy,
-				const int num_different_channels,
-				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES]);
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
+ * @params: the interface combinations parameter
  * @iter: function to call for each matching combination
  * @data: pointer to pass to iter function
  *
@@ -5613,9 +5617,7 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
  * purposes.
  */
 int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       const int num_different_channels,
-			       const u8 radar_detect,
-			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       struct iface_combination_params *params,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 545c79a..cfec67d 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3308,10 +3308,13 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_sub_if_data *sdata_iter;
 	enum nl80211_iftype iftype = sdata->wdev.iftype;
-	int num[NUM_NL80211_IFTYPES];
 	struct ieee80211_chanctx *ctx;
-	int num_different_channels = 0;
 	int total = 1;
+	struct iface_combination_params params = {
+		.num_different_channels = 0,
+		.radar_detect = radar_detect,
+		.iftype_num = {0},
+	};
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -3322,9 +3325,6 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		    !chandef->chan))
 		return -EINVAL;
 
-	if (chandef)
-		num_different_channels = 1;
-
 	if (WARN_ON(iftype >= NUM_NL80211_IFTYPES))
 		return -EINVAL;
 
@@ -3335,24 +3335,26 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		return 0;
 	}
 
-	memset(num, 0, sizeof(num));
+	if (chandef)
+		params.num_different_channels = 1;
 
 	if (iftype != NL80211_IFTYPE_UNSPECIFIED)
-		num[iftype] = 1;
+		params.iftype_num[iftype] = 1;
 
 	list_for_each_entry(ctx, &local->chanctx_list, list) {
 		if (ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED)
 			continue;
-		radar_detect |= ieee80211_chanctx_radar_detect(local, ctx);
+		params.radar_detect |=
+			ieee80211_chanctx_radar_detect(local, ctx);
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
@@ -3365,16 +3367,14 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 		    local->hw.wiphy->software_iftypes & BIT(wdev_iter->iftype))
 			continue;
 
-		num[wdev_iter->iftype]++;
+		params.iftype_num[wdev_iter->iftype]++;
 		total++;
 	}
 
-	if (total == 1 && !radar_detect)
+	if (total == 1 && !params.radar_detect)
 		return 0;
 
-	return cfg80211_check_combinations(local->hw.wiphy,
-					   num_different_channels,
-					   radar_detect, num);
+	return cfg80211_check_combinations(local->hw.wiphy, &params);
 }
 
 static void
@@ -3390,12 +3390,14 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 int ieee80211_max_num_channels(struct ieee80211_local *local)
 {
 	struct ieee80211_sub_if_data *sdata;
-	int num[NUM_NL80211_IFTYPES] = {};
 	struct ieee80211_chanctx *ctx;
-	int num_different_channels = 0;
-	u8 radar_detect = 0;
 	u32 max_num_different_channels = 1;
 	int err;
+	struct iface_combination_params params = {
+		.num_different_channels = 0,
+		.radar_detect = 0,
+		.iftype_num = {0},
+	};
 
 	lockdep_assert_held(&local->chanctx_mtx);
 
@@ -3403,17 +3405,17 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
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
-					 num, ieee80211_iter_max_chans,
+	err = cfg80211_iter_combinations(local->hw.wiphy, &params,
+					 ieee80211_iter_max_chans,
 					 &max_num_different_channels);
 	if (err < 0)
 		return err;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8edce22..0d69b25 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1580,9 +1580,7 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 }
 
 int cfg80211_iter_combinations(struct wiphy *wiphy,
-			       const int num_different_channels,
-			       const u8 radar_detect,
-			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       struct iface_combination_params *params,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data)
@@ -1593,7 +1591,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	int num_interfaces = 0;
 	u32 used_iftypes = 0;
 
-	if (radar_detect) {
+	if (params->radar_detect) {
 		rcu_read_lock();
 		regdom = rcu_dereference(cfg80211_regdomain);
 		if (regdom)
@@ -1602,8 +1600,8 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	}
 
 	for (iftype = 0; iftype < NUM_NL80211_IFTYPES; iftype++) {
-		num_interfaces += iftype_num[iftype];
-		if (iftype_num[iftype] > 0 &&
+		num_interfaces += params->iftype_num[iftype];
+		if (params->iftype_num[iftype] > 0 &&
 		    !(wiphy->software_iftypes & BIT(iftype)))
 			used_iftypes |= BIT(iftype);
 	}
@@ -1617,7 +1615,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 
 		if (num_interfaces > c->max_interfaces)
 			continue;
-		if (num_different_channels > c->num_different_channels)
+		if (params->num_different_channels > c->num_different_channels)
 			continue;
 
 		limits = kmemdup(c->limits, sizeof(limits[0]) * c->n_limits,
@@ -1632,16 +1630,17 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
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
 
@@ -1675,14 +1674,11 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 }
 
 int cfg80211_check_combinations(struct wiphy *wiphy,
-				const int num_different_channels,
-				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES])
+				struct iface_combination_params *params)
 {
 	int err, num = 0;
 
-	err = cfg80211_iter_combinations(wiphy, num_different_channels,
-					 radar_detect, iftype_num,
+	err = cfg80211_iter_combinations(wiphy, params,
 					 cfg80211_iter_sum_ifcombs, &num);
 	if (err)
 		return err;
-- 
1.9.1
