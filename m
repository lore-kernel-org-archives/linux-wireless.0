Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9582 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755880AbcJMPQE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 11:16:04 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH v3] cfg80211: Check radar_detect and num_different_channels with beacon interface combinations.
Date: Thu, 13 Oct 2016 20:45:30 +0530
Message-ID: <1476371730-23027-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20161013_171613_155962_F81FEF3D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit enhances the current beacon interval validation to also consider
the "radar_detect" and "num_different_channels".

Move calculation of GCD for all beaconing interfaces to "cfg80211_iter_combinations".

Rename "cfg80211_validate_beacon_int" to "cfg80211_validate_beacon_combination"
as the validation considers other parameters.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h |  3 --
 net/wireless/core.h    |  7 ++--
 net/wireless/mesh.c    |  7 ++++
 net/wireless/nl80211.c | 32 ++++++++----------
 net/wireless/util.c    | 91 +++++++++++++++++++++++++++++++++++++++-----------
 5 files changed, 97 insertions(+), 43 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 5000ec7..f5e076c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -788,15 +788,12 @@ struct cfg80211_csa_settings {
  *	the GCD of a single value is considered the value itself, so for
  *	a single interface this should be set to that interface's beacon
  *	interval
- * @beacon_int_different: a flag indicating whether or not all beacon
- *	intervals (of beaconing interfaces) are different or not.
  */
 struct iface_combination_params {
 	int num_different_channels;
 	u8 radar_detect;
 	int iftype_num[NUM_NL80211_IFTYPES];
 	u32 beacon_int_gcd;
-	bool beacon_int_different;
 };
 
 /**
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 21e3188..e39c8a9 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -474,8 +474,11 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   const u8 *rates, unsigned int n_rates,
 			   u32 *mask);
 
-int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 enum nl80211_iftype iftype, u32 beacon_int);
+int
+cfg80211_validate_beacon_combination(struct cfg80211_registered_device *rdev,
+				     enum nl80211_iftype iftype,
+				     struct cfg80211_chan_def *chandef,
+				     u32 beacon_int);
 
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
diff --git a/net/wireless/mesh.c b/net/wireless/mesh.c
index fa2066b..1d864b4 100644
--- a/net/wireless/mesh.c
+++ b/net/wireless/mesh.c
@@ -178,6 +178,13 @@ int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
 				     NL80211_IFTYPE_MESH_POINT))
 		return -EINVAL;
 
+	err = cfg80211_validate_beacon_combination(rdev,
+						   NL80211_IFTYPE_MESH_POINT,
+						   &setup->chandef,
+						   setup->beacon_interval);
+	if (err)
+		return err;
+
 	err = rdev_join_mesh(rdev, dev, conf, setup);
 	if (!err) {
 		memcpy(wdev->ssid, setup->mesh_id, setup->mesh_id_len);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 903cd5a..eb2bfae 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3807,11 +3807,6 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	params.dtim_period =
 		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
 
-	err = cfg80211_validate_beacon_int(rdev, dev->ieee80211_ptr->iftype,
-					   params.beacon_interval);
-	if (err)
-		return err;
-
 	/*
 	 * In theory, some of these attributes should be required here
 	 * but since they were not used when the command was originally
@@ -3899,6 +3894,13 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 					   wdev->iftype))
 		return -EINVAL;
 
+	err = cfg80211_validate_beacon_combination(rdev,
+						   dev->ieee80211_ptr->iftype,
+						   &params.chandef,
+						   params.beacon_interval);
+	if (err)
+		return err;
+
 	if (info->attrs[NL80211_ATTR_TX_RATES]) {
 		err = nl80211_parse_tx_bitrate_mask(info, &params.beacon_rate);
 		if (err)
@@ -8157,11 +8159,6 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-	err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_ADHOC,
-					   ibss.beacon_interval);
-	if (err)
-		return err;
-
 	if (!rdev->ops->join_ibss)
 		return -EOPNOTSUPP;
 
@@ -8188,6 +8185,12 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
+	err = cfg80211_validate_beacon_combination(rdev, NL80211_IFTYPE_ADHOC,
+						   &ibss.chandef,
+						   ibss.beacon_interval);
+	if (err)
+		return err;
+
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef,
 				     NL80211_IFTYPE_ADHOC))
 		return -EINVAL;
@@ -9419,17 +9422,10 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			    nla_get_u32(info->attrs[NL80211_ATTR_MCAST_RATE])))
 			return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL]) {
+	if (info->attrs[NL80211_ATTR_BEACON_INTERVAL])
 		setup.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-		err = cfg80211_validate_beacon_int(rdev,
-						   NL80211_IFTYPE_MESH_POINT,
-						   setup.beacon_interval);
-		if (err)
-			return err;
-	}
-
 	if (info->attrs[NL80211_ATTR_DTIM_PERIOD]) {
 		setup.dtim_period =
 			nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d2ea1f1..eb89cb9 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1558,44 +1558,67 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
-int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 enum nl80211_iftype iftype, u32 beacon_int)
+int
+cfg80211_validate_beacon_combination(struct cfg80211_registered_device *rdev,
+				     enum nl80211_iftype iftype,
+				     struct cfg80211_chan_def *chandef,
+				     u32 beacon_int)
 {
+	int res, i;
 	struct wireless_dev *wdev;
+	struct ieee80211_channel *ch;
+	enum cfg80211_chan_mode chmode;
+	struct ieee80211_channel
+		*used_channels[CFG80211_MAX_NUM_DIFFERENT_CHANNELS];
 	struct iface_combination_params params = {
+		.num_different_channels = 1,
 		.beacon_int_gcd = beacon_int,	/* GCD(n) = n */
 	};
 
 	if (beacon_int < 10 || beacon_int > 10000)
 		return -EINVAL;
 
+	used_channels[0] = chandef->chan;
 	params.iftype_num[iftype] = 1;
-	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		if (!wdev->beacon_interval)
-			continue;
 
-		params.iftype_num[wdev->iftype]++;
-	}
+	res = cfg80211_chandef_dfs_required(&rdev->wiphy, chandef, iftype);
+	if (res < 0)
+		return res;
+	if (res)
+		params.radar_detect = BIT(chandef->width);
 
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-		u32 bi_prev = wdev->beacon_interval;
-
 		if (!wdev->beacon_interval)
 			continue;
 
-		/* slight optimisation - skip identical BIs */
-		if (wdev->beacon_interval == beacon_int)
-			continue;
+		mutex_lock_nested(&wdev->mtx, 1);
+		__acquire(wdev->mtx);
+		cfg80211_get_chan_state(wdev, &ch, &chmode,
+					&params.radar_detect);
+		wdev_unlock(wdev);
 
-		params.beacon_int_different = true;
+		switch (chmode) {
+		case CHAN_MODE_UNDEFINED:
+			break;
+		case CHAN_MODE_SHARED:
+			for (i = 0; i < CFG80211_MAX_NUM_DIFFERENT_CHANNELS; i++)
+				if (!used_channels[i] || used_channels[i] == ch)
+					break;
 
-		/* Get the GCD */
-		while (bi_prev != 0) {
-			u32 tmp_bi = bi_prev;
+			if (i == CFG80211_MAX_NUM_DIFFERENT_CHANNELS)
+				return -EBUSY;
 
-			bi_prev = params.beacon_int_gcd % bi_prev;
-			params.beacon_int_gcd = tmp_bi;
+			if (!used_channels[i]) {
+				used_channels[i] = ch;
+				params.num_different_channels++;
+			}
+			break;
+		case CHAN_MODE_EXCLUSIVE:
+			params.num_different_channels++;
+			break;
 		}
+
+		params.iftype_num[wdev->iftype]++;
 	}
 
 	return cfg80211_check_combinations(&rdev->wiphy, &params);
@@ -1612,6 +1635,35 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 	int i, j, iftype;
 	int num_interfaces = 0;
 	u32 used_iftypes = 0;
+	struct wireless_dev *wdev;
+	bool beacon_int_different = false;
+
+	list_for_each_entry(wdev, &wiphy->wdev_list, list) {
+		u32 curr_bi = wdev->beacon_interval;
+
+		if (!curr_bi)
+			continue;
+
+		/* set first beacon_int as GCD if beacon_int_gcd = 0 */
+		if (!params->beacon_int_gcd) {
+			params->beacon_int_gcd = curr_bi;
+			continue;
+		}
+
+		/* slight optimisation - skip identical BIs */
+		if (curr_bi == params->beacon_int_gcd)
+			continue;
+
+		beacon_int_different = true;
+
+		/* Get the GCD */
+		while (curr_bi != 0) {
+			u32 tmp_bi = curr_bi;
+
+			curr_bi = params->beacon_int_gcd % curr_bi;
+			params->beacon_int_gcd = tmp_bi;
+		}
+	}
 
 	if (params->radar_detect) {
 		rcu_read_lock();
@@ -1678,8 +1730,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 			if (c->beacon_int_min_gcd &&
 			    params->beacon_int_gcd < c->beacon_int_min_gcd)
 				return -EINVAL;
-			if (!c->beacon_int_min_gcd &&
-			    params->beacon_int_different)
+			if (!c->beacon_int_min_gcd && beacon_int_different)
 				goto cont;
 		}
 
-- 
1.9.1
