Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22370 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbcHMFC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 01:02:58 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<djindal@qti.qualcomm.com>, <pkushwah@qti.qualcomm.com>
Subject: [PATCH v7] cfg80211: Provision to allow the support for different beacon intervals
Date: Sat, 13 Aug 2016 10:32:22 +0530
Message-ID: <1471064542-29322-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160813_070301_921876_9D9A5D78)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit provides a mechanism for the host drivers to advertise the
support for different beacon intervals among the respective interface
combinations in a group, through diff_beacon_int_gcd_min (u32).

Following sets the expectation for diff_beacon_int_gcd_min.

= 0 - all beacon intervals for different interfaces must be same.
> 0 - different beacon intervals must have a GCD that's at
      least as big as this value.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  9 ++++++++-
 include/uapi/linux/nl80211.h |  8 ++++++--
 net/wireless/core.h          |  2 +-
 net/wireless/nl80211.c       | 13 ++++++++++---
 net/wireless/util.c          | 46 ++++++++++++++++++++++++++++++++++++++++++--
 5 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..c3dd46c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2939,6 +2939,11 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  * @radar_detect_regions: bitmap of regions supported for radar detection
+ * @diff_beacon_int_gcd_min: This interface combination supports different
+ *	beacon intervals.
+ *	= 0 - all beacon intervals for different interface must be same.
+ *	> 0 - different beacon intervals must have a GCD that's at
+ *	least as big as this value.
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2959,7 +2964,7 @@ struct ieee80211_iface_limit {
  *  };
  *
  *
- * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
+ * 2. Allow #{AP, P2P-GO} <= 8, diff BI min gcd = 10, channels = 1, 8 total:
  *
  *  struct ieee80211_iface_limit limits2[] = {
  *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
@@ -2970,6 +2975,7 @@ struct ieee80211_iface_limit {
  *	.n_limits = ARRAY_SIZE(limits2),
  *	.max_interfaces = 8,
  *	.num_different_channels = 1,
+ *	.diff_beacon_int_gcd_min = 10,
  *  };
  *
  *
@@ -2997,6 +3003,7 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
 	u8 radar_detect_regions;
+	u32 diff_beacon_int_gcd_min;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..894d131 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4203,6 +4203,9 @@ enum nl80211_iface_limit_attrs {
  *	of supported channel widths for radar detection.
  * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
  *	of supported regulatory regions for radar detection.
+ * @NL80211_IFACE_COMB_DIFF_BI_GCD_MIN: u32 attribute specifying the minimum GCD
+ *	of different beacon intervals supported by all the interface combinations
+ *	in this group (if not present, all beacon interval must match).
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -4210,8 +4213,8 @@ enum nl80211_iface_limit_attrs {
  *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI, channels = 1, max = 2
  *	=> allows an AP and a STA that must match BIs
  *
- *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
- *	=> allows 8 of AP/GO
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], diff BI min gcd, channels = 1, max = 8,
+ *	=> allows 8 of AP/GO that can have BI gcd >= min gcd
  *
  *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
  *	=> allows two STAs on different channels
@@ -4237,6 +4240,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+	NL80211_IFACE_COMB_DIFF_BI_GCD_MIN,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
diff --git a/net/wireless/core.h b/net/wireless/core.h
index eee9144..5fffe58 100644
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
index 4997857..c1741d9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1020,6 +1020,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 				c->radar_detect_regions)))
 			goto nla_put_failure;
+		if (c->diff_beacon_int_gcd_min &&
+		    nla_put_u32(msg, NL80211_IFACE_COMB_DIFF_BI_GCD_MIN,
+				c->diff_beacon_int_gcd_min))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
@@ -3433,7 +3437,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	params.dtim_period =
 		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
 
-	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, dev->ieee80211_ptr->iftype,
+					   params.beacon_interval);
 	if (err)
 		return err;
 
@@ -7768,7 +7773,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-	err = cfg80211_validate_beacon_int(rdev, ibss.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_ADHOC,
+					   ibss.beacon_interval);
 	if (err)
 		return err;
 
@@ -9245,7 +9251,8 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		setup.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-		err = cfg80211_validate_beacon_int(rdev, setup.beacon_interval);
+		err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_MESH_POINT,
+						   setup.beacon_interval);
 		if (err)
 			return err;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0675f51..844f02a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1553,20 +1553,62 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
+struct diff_beacon_int {
+	u32 gcd;
+	bool valid;
+};
+
+static void
+cfg80211_validate_diff_beacon_int(const struct ieee80211_iface_combination *c,
+				  void *data)
+{
+	struct diff_beacon_int *diff_bi = data;
+
+	if (c->diff_beacon_int_gcd_min &&
+	    (diff_bi->gcd >= c->diff_beacon_int_gcd_min))
+		diff_bi->valid = true;
+}
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 u32 beacon_int)
+				 enum nl80211_iftype iftype, u32 beacon_int)
 {
 	struct wireless_dev *wdev;
 	int res = 0;
+	int iftype_num[NUM_NL80211_IFTYPES];
 
 	if (beacon_int < 10 || beacon_int > 10000)
 		return -EINVAL;
 
+	memset(iftype_num, 0, sizeof(iftype_num));
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		if (!wdev->beacon_interval)
+			continue;
+		iftype_num[wdev->iftype]++;
+	}
+	iftype_num[iftype]++;
+
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
-			res = -EINVAL;
+			struct diff_beacon_int diff_bi = {
+				wdev->beacon_interval,
+				false,
+			};
+
+			/* Get the GCD */
+			while (beacon_int != 0) {
+				u32 tmp_bi = beacon_int;
+				beacon_int = diff_bi.gcd % beacon_int;
+				diff_bi.gcd = tmp_bi;
+			}
+
+			res = cfg80211_iter_combinations(&rdev->wiphy, 0, 0, iftype_num,
+							 cfg80211_validate_diff_beacon_int,
+							 &diff_bi);
+			if (res)
+				return res;
+			res = (diff_bi.valid) ? 0 : -EINVAL;
 			break;
 		}
 	}
-- 
1.9.1

