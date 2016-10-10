Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31644 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751264AbcJJMGr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 08:06:47 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH v9] cfg80211: Provision to allow the support for different beacon intervals
Date: Mon, 10 Oct 2016 17:36:11 +0530
Message-ID: <1476101171-29564-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20161010_140651_933405_061D8E2F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit provides a mechanism for the host drivers to advertise the
support for different beacon intervals among the respective interface
combinations in a group, through beacon_int_min_gcd (u32).
This beacon_int_min_gcd will be compared against GCD of all beaconing
interfaces of matching combinations.

Following sets the expectation for beacon_int_min_gcd.

= 0 - all beacon intervals for different interfaces must be same.
> 0 - any beacon interval for the interface part of this combination AND
      *GCD* of all beacon intervals from beaconing interfaces of this
      combination must be greator or equal to this value.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 .../broadcom/brcm80211/brcmfmac/cfg80211.c         |  6 ++-
 include/net/cfg80211.h                             | 18 ++++++++-
 include/uapi/linux/nl80211.h                       |  8 +++-
 net/mac80211/util.c                                |  4 +-
 net/wireless/core.h                                |  2 +-
 net/wireless/nl80211.c                             | 14 +++++--
 net/wireless/util.c                                | 43 ++++++++++++++++++++--
 7 files changed, 79 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index b777e1b..1e73c88 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -430,7 +430,8 @@ static int brcmf_vif_change_validate(struct brcmf_cfg80211_info *cfg,
 		}
 
 	if (check_combos)
-		ret = cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+		ret = cfg80211_check_combinations(cfg->wiphy, 1, 0,
+						  iftype_num, 0, false);
 
 	return ret;
 }
@@ -446,7 +447,8 @@ static int brcmf_vif_add_validate(struct brcmf_cfg80211_info *cfg,
 		iftype_num[pos->wdev.iftype]++;
 
 	iftype_num[new_type]++;
-	return cfg80211_check_combinations(cfg->wiphy, 1, 0, iftype_num);
+	return cfg80211_check_combinations(cfg->wiphy, 1, 0,
+					   iftype_num, 0, false);
 }
 
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index fe78f02..49aa6a0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3080,6 +3080,12 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  * @radar_detect_regions: bitmap of regions supported for radar detection
+ * @beacon_int_min_gcd: This interface combination supports different
+ *	beacon intervals.
+ *	= 0 - all beacon intervals for different interface must be same.
+ *	> 0 - any beacon interval for the interface part of this combination AND
+ *	      *GCD* of all beacon intervals from beaconing interfaces of this
+ *	      combination must be greator or equal to this value.
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -3100,7 +3106,7 @@ struct ieee80211_iface_limit {
  *  };
  *
  *
- * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
+ * 2. Allow #{AP, P2P-GO} <= 8, BI min gcd = 10, channels = 1, 8 total:
  *
  *  struct ieee80211_iface_limit limits2[] = {
  *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
@@ -3111,6 +3117,7 @@ struct ieee80211_iface_limit {
  *	.n_limits = ARRAY_SIZE(limits2),
  *	.max_interfaces = 8,
  *	.num_different_channels = 1,
+ *	.beacon_int_min_gcd = 10,
  *  };
  *
  *
@@ -3138,6 +3145,7 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
 	u8 radar_detect_regions;
+	u32 beacon_int_min_gcd;
 };
 
 struct ieee80211_txrx_stypes {
@@ -5583,6 +5591,8 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
  * @iftype_num: array with the numbers of interfaces of each interface
  *	type.  The index is the interface type as specified in &enum
  *	nl80211_iftype.
+ * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
+ * @diff_bi: a flag which denotes beacon intervals are different or same.
  *
  * This function can be called by the driver to check whether a
  * combination of interfaces and their types are allowed according to
@@ -5591,7 +5601,8 @@ unsigned int ieee80211_get_num_supported_channels(struct wiphy *wiphy);
 int cfg80211_check_combinations(struct wiphy *wiphy,
 				const int num_different_channels,
 				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES]);
+				const int iftype_num[NUM_NL80211_IFTYPES],
+				const u32 beacon_gcd, bool diff_bi);
 
 /**
  * cfg80211_iter_combinations - iterate over matching combinations
@@ -5605,6 +5616,8 @@ int cfg80211_check_combinations(struct wiphy *wiphy,
  * @iftype_num: array with the numbers of interfaces of each interface
  *	type.  The index is the interface type as specified in &enum
  *	nl80211_iftype.
+ * @beacon_gcd: a value specifying GCD of all beaconing interfaces.
+ * @diff_bi: a flag which denotes beacon intervals are different or same.
  * @iter: function to call for each matching combination
  * @data: pointer to pass to iter function
  *
@@ -5616,6 +5629,7 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 			       const int num_different_channels,
 			       const u8 radar_detect,
 			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       const u32 beacon_gcd, bool diff_bi,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 56368e9..3c19cca 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4280,6 +4280,9 @@ enum nl80211_iface_limit_attrs {
  *	of supported channel widths for radar detection.
  * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
  *	of supported regulatory regions for radar detection.
+ * @NL80211_IFACE_COMB_BI_MIN_GCD: u32 attribute specifying the minimum GCD of
+ *	different beacon intervals supported by all the interface combinations
+ *	in this group (if not present, all beacon interval must match).
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -4287,8 +4290,8 @@ enum nl80211_iface_limit_attrs {
  *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI, channels = 1, max = 2
  *	=> allows an AP and a STA that must match BIs
  *
- *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
- *	=> allows 8 of AP/GO
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], BI min gcd, channels = 1, max = 8,
+ *	=> allows 8 of AP/GO that can have BI gcd >= min gcd
  *
  *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
  *	=> allows two STAs on different channels
@@ -4314,6 +4317,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+	NL80211_IFACE_COMB_BI_MIN_GCD,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 545c79a..cfef5ce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -3374,7 +3374,7 @@ int ieee80211_check_combinations(struct ieee80211_sub_if_data *sdata,
 
 	return cfg80211_check_combinations(local->hw.wiphy,
 					   num_different_channels,
-					   radar_detect, num);
+					   radar_detect, num, 0, false);
 }
 
 static void
@@ -3413,7 +3413,7 @@ int ieee80211_max_num_channels(struct ieee80211_local *local)
 
 	err = cfg80211_iter_combinations(local->hw.wiphy,
 					 num_different_channels, radar_detect,
-					 num, ieee80211_iter_max_chans,
+					 num, 0, false, ieee80211_iter_max_chans,
 					 &max_num_different_channels);
 	if (err < 0)
 		return err;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 08d2e94..21e3188 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -475,7 +475,7 @@ int ieee80211_get_ratemask(struct ieee80211_supported_band *sband,
 			   u32 *mask);
 
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 u32 beacon_int);
+				 enum nl80211_iftype iftype, u32 beacon_int);
 
 void cfg80211_update_iface_num(struct cfg80211_registered_device *rdev,
 			       enum nl80211_iftype iftype, int num);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c510810..903cd5a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1075,6 +1075,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 				c->radar_detect_regions)))
 			goto nla_put_failure;
+		if (c->beacon_int_min_gcd &&
+		    nla_put_u32(msg, NL80211_IFACE_COMB_BI_MIN_GCD,
+				c->beacon_int_min_gcd))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
@@ -3803,7 +3807,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	params.dtim_period =
 		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
 
-	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, dev->ieee80211_ptr->iftype,
+					   params.beacon_interval);
 	if (err)
 		return err;
 
@@ -8152,7 +8157,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-	err = cfg80211_validate_beacon_int(rdev, ibss.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_ADHOC,
+					   ibss.beacon_interval);
 	if (err)
 		return err;
 
@@ -9417,7 +9423,9 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		setup.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-		err = cfg80211_validate_beacon_int(rdev, setup.beacon_interval);
+		err = cfg80211_validate_beacon_int(rdev,
+						   NL80211_IFTYPE_MESH_POINT,
+						   setup.beacon_interval);
 		if (err)
 			return err;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8edce22..0d3bda4 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1559,30 +1559,55 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 u32 beacon_int)
+				 enum nl80211_iftype iftype, u32 beacon_int)
 {
 	struct wireless_dev *wdev;
+	bool diff_bi = false;
 	int res = 0;
+	u32 bi_prev, tmp_bi, gcd;
+	int iftype_num[NUM_NL80211_IFTYPES];
 
 	if (beacon_int < 10 || beacon_int > 10000)
 		return -EINVAL;
 
+	memset(iftype_num, 0, sizeof(iftype_num));
+	iftype_num[iftype] = 1;
+
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (!wdev->beacon_interval)
+			continue;
+
+		iftype_num[wdev->iftype]++;
+	}
+
+	/* GCD(n) = n */
+	gcd = beacon_int;
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
-			res = -EINVAL;
+			diff_bi = true;
+			/* Get the GCD */
+			bi_prev = wdev->beacon_interval;
+			while (bi_prev != 0) {
+				tmp_bi = bi_prev;
+				bi_prev = gcd % bi_prev;
+				gcd = tmp_bi;
+			}
 			break;
 		}
 	}
 
-	return res;
+	res = cfg80211_check_combinations(&rdev->wiphy, 0, 0,
+					  iftype_num, gcd, diff_bi);
+	return (res < 0) ? res : 0;
 }
 
 int cfg80211_iter_combinations(struct wiphy *wiphy,
 			       const int num_different_channels,
 			       const u8 radar_detect,
 			       const int iftype_num[NUM_NL80211_IFTYPES],
+			       const u32 beacon_gcd, bool diff_bi,
 			       void (*iter)(const struct ieee80211_iface_combination *c,
 					    void *data),
 			       void *data)
@@ -1653,6 +1678,14 @@ int cfg80211_iter_combinations(struct wiphy *wiphy,
 		if ((all_iftypes & used_iftypes) != used_iftypes)
 			goto cont;
 
+		if (beacon_gcd) {
+			if (c->beacon_int_min_gcd &&
+			    beacon_gcd < c->beacon_int_min_gcd)
+				return -EINVAL;
+			if (!c->beacon_int_min_gcd && diff_bi)
+				goto cont;
+		}
+
 		/* This combination covered all interface types and
 		 * supported the requested numbers, so we're good.
 		 */
@@ -1677,12 +1710,14 @@ cfg80211_iter_sum_ifcombs(const struct ieee80211_iface_combination *c,
 int cfg80211_check_combinations(struct wiphy *wiphy,
 				const int num_different_channels,
 				const u8 radar_detect,
-				const int iftype_num[NUM_NL80211_IFTYPES])
+				const int iftype_num[NUM_NL80211_IFTYPES],
+				const u32 beacon_gcd, bool diff_bi)
 {
 	int err, num = 0;
 
 	err = cfg80211_iter_combinations(wiphy, num_different_channels,
 					 radar_detect, iftype_num,
+					 beacon_gcd, diff_bi,
 					 cfg80211_iter_sum_ifcombs, &num);
 	if (err)
 		return err;
-- 
1.9.1
