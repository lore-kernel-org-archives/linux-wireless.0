Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44447 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcHLIkA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 04:40:00 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<djindal@qti.qualcomm.com>, <pkushwah@qti.qualcomm.com>
Subject: [PATCH v6] cfg80211: Provision to allow the support for different beacon intervals
Date: Fri, 12 Aug 2016 14:09:38 +0530
Message-ID: <1470991178-11024-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160812_104006_931081_A6DDE010)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit provides a mechanism for the host drivers to advertise the
support for different beacon intervals among the respective interface
combinations in a group, through diff_beacon_int_gcd (u32).

The configured BI for a specific interface must be a multiple of this
value and also the active beaconing interfaces (along with the current
one) must match with the interface combinations in a group that advertise
the support for different beacon interval.

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  8 ++++++--
 net/wireless/core.h          |  2 +-
 net/wireless/nl80211.c       | 13 ++++++++++---
 net/wireless/util.c          | 36 ++++++++++++++++++++++++++++++++++--
 5 files changed, 55 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..a0c635a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2939,6 +2939,8 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  * @radar_detect_regions: bitmap of regions supported for radar detection
+ * @diff_beacon_int_gcd: This interface combination supports different beacon
+ *	intervals in multiple of GCD value.
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2970,6 +2972,7 @@ struct ieee80211_iface_limit {
  *	.n_limits = ARRAY_SIZE(limits2),
  *	.max_interfaces = 8,
  *	.num_different_channels = 1,
+ *	.diff_beacon_int_gcd = 100,
  *  };
  *
  *
@@ -2997,6 +3000,7 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
 	u8 radar_detect_regions;
+	u32 diff_beacon_int_gcd;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..369e403 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4203,6 +4203,9 @@ enum nl80211_iface_limit_attrs {
  *	of supported channel widths for radar detection.
  * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
  *	of supported regulatory regions for radar detection.
+ * @NL80211_IFACE_COMB_DIFF_BI_GCD: u32 attribute specifying the GCD of
+ *	different beacon intervals supported by all the interface combinations
+ *	in this group (not present if all beacon interval must match).
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -4210,8 +4213,8 @@ enum nl80211_iface_limit_attrs {
  *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI, channels = 1, max = 2
  *	=> allows an AP and a STA that must match BIs
  *
- *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
- *	=> allows 8 of AP/GO
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], diff BI gcd, channels = 1, max = 8,
+ *	=> allows 8 of AP/GO that can beacon at multiple of gcd intervals
  *
  *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
  *	=> allows two STAs on different channels
@@ -4237,6 +4240,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+	NL80211_IFACE_COMB_DIFF_BI_GCD,
 
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
index 4997857..01945fb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1020,6 +1020,10 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 				c->radar_detect_regions)))
 			goto nla_put_failure;
+		if (c->diff_beacon_int_gcd &&
+		    nla_put_u32(msg, NL80211_IFACE_COMB_DIFF_BI_GCD,
+				c->diff_beacon_int_gcd))
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
index 0675f51..a8f0171 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1553,20 +1553,52 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
+struct diff_beacon_int {
+	u32 beacon_int;
+	bool valid;
+};
+
+static void
+cfg80211_validate_diff_beacon_int(const struct ieee80211_iface_combination *c,
+				  void *data)
+{
+	struct diff_beacon_int *diff_bi = data;
+
+	if (c->diff_beacon_int_gcd &&
+	    !(diff_bi->beacon_int % c->diff_beacon_int_gcd))
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
+			struct diff_beacon_int diff_bi = { beacon_int, false };
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

