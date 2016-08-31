Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41490 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759680AbcHaN0u (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Aug 2016 09:26:50 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
        <usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
        <pkushwah@qti.qualcomm.com>
Subject: [PATCH v8] cfg80211: Provision to allow the support for different beacon intervals
Date: Wed, 31 Aug 2016 18:56:12 +0530
Message-ID: <1472649972-6649-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160831_152655_164903_38DE1386)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit provides a mechanism for the host drivers to advertise the
support for different beacon intervals among the respective interface
combinations in a group, through diff_beacon_int_gcd_min (u32).

Following sets the expectation for diff_beacon_int_gcd_min.

= 0 - all beacon intervals for different interfaces must be same.
> 0 - any beacon interval for the interface part of this combination
      must also be bigger than this value

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  9 +++++++-
 include/uapi/linux/nl80211.h |  8 +++++--
 net/wireless/core.h          |  2 +-
 net/wireless/nl80211.c       | 13 ++++++++---
 net/wireless/util.c          | 53 +++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 75 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c58afc8..b149a57 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2943,6 +2943,11 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  * @radar_detect_regions: bitmap of regions supported for radar detection
+ * @beacon_int_min_gcd: This interface combination supports different
+ *	beacon intervals.
+ *	= 0 - all beacon intervals for different interface must be same.
+ *	> 0 - any beacon interval for the interface part of this combination
+ *	      must also be bigger than this value
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2963,7 +2968,7 @@ struct ieee80211_iface_limit {
  *  };
  *
  *
- * 2. Allow #{AP, P2P-GO} <= 8, channels = 1, 8 total:
+ * 2. Allow #{AP, P2P-GO} <= 8, BI min gcd = 10, channels = 1, 8 total:
  *
  *  struct ieee80211_iface_limit limits2[] = {
  *	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) |
@@ -2974,6 +2979,7 @@ struct ieee80211_iface_limit {
  *	.n_limits = ARRAY_SIZE(limits2),
  *	.max_interfaces = 8,
  *	.num_different_channels = 1,
+ *	.beacon_int_min_gcd = 10,
  *  };
  *
  *
@@ -3001,6 +3007,7 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
 	u8 radar_detect_regions;
+	u32 beacon_int_min_gcd;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..5770d4f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4203,6 +4203,9 @@ enum nl80211_iface_limit_attrs {
  *	of supported channel widths for radar detection.
  * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
  *	of supported regulatory regions for radar detection.
+ * @NL80211_IFACE_COMB_BI_MIN_GCD: u32 attribute specifying the minimum GCD of
+ *	different beacon intervals supported by all the interface combinations
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
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], BI min gcd, channels = 1, max = 8,
+ *	=> allows 8 of AP/GO that can have BI gcd >= min gcd
  *
  *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
  *	=> allows two STAs on different channels
@@ -4237,6 +4240,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+	NL80211_IFACE_COMB_BI_MIN_GCD,
 
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
index 047bd26..4ee01ad 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1020,6 +1020,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 				c->radar_detect_regions)))
 			goto nla_put_failure;
+		if (c->beacon_int_min_gcd &&
+		    nla_put_u32(msg, NL80211_IFACE_COMB_BI_MIN_GCD,
+				c->beacon_int_min_gcd))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
@@ -3692,7 +3696,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	params.dtim_period =
 		nla_get_u32(info->attrs[NL80211_ATTR_DTIM_PERIOD]);
 
-	err = cfg80211_validate_beacon_int(rdev, params.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, dev->ieee80211_ptr->iftype,
+					   params.beacon_interval);
 	if (err)
 		return err;
 
@@ -8063,7 +8068,8 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 		ibss.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-	err = cfg80211_validate_beacon_int(rdev, ibss.beacon_interval);
+	err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_ADHOC,
+					   ibss.beacon_interval);
 	if (err)
 		return err;
 
@@ -9323,7 +9329,8 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 		setup.beacon_interval =
 			nla_get_u32(info->attrs[NL80211_ATTR_BEACON_INTERVAL]);
 
-		err = cfg80211_validate_beacon_int(rdev, setup.beacon_interval);
+		err = cfg80211_validate_beacon_int(rdev, NL80211_IFTYPE_MESH_POINT,
+						   setup.beacon_interval);
 		if (err)
 			return err;
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0675f51..ee8e5c5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1553,25 +1553,72 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
+static void
+cfg80211_get_beacon_int_min_gcd(const struct ieee80211_iface_combination *c,
+				void *data)
+{
+	u32 *gcd = data;
+
+	/* Get the least beacon_int_min_gcd among the matched combinations */
+	if (c->beacon_int_min_gcd) {
+		if (*gcd) {
+			if (*gcd > c->beacon_int_min_gcd)
+				*gcd = c->beacon_int_min_gcd;
+		} else {
+			*gcd = c->beacon_int_min_gcd;
+		}
+	}
+}
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
-				 u32 beacon_int)
+				 enum nl80211_iftype iftype, u32 beacon_int)
 {
 	struct wireless_dev *wdev;
 	int res = 0;
+	u32 min_gcd = 0;
+	u32 bi_prev, tmp_bi, gcd;
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
+	res = cfg80211_iter_combinations(&rdev->wiphy, 0, 0, iftype_num,
+					 cfg80211_get_beacon_int_min_gcd,
+					 &min_gcd);
+	if (res)
+		return res;
+
+	/* GCD(n) = n */
+	gcd = beacon_int;
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
 		if (wdev->beacon_interval != beacon_int) {
-			res = -EINVAL;
+			/* beacon_int_min_gcd=0 or not specified, all
+			 * beacon interval of this combination must match
+			 */
+			if (min_gcd == 0)
+				return -EINVAL;
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
+	return (gcd < min_gcd) ? -EINVAL : 0;
 }
 
 int cfg80211_iter_combinations(struct wiphy *wiphy,
-- 
1.9.1
