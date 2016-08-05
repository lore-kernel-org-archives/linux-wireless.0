Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22918 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbcHEF0b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2016 01:26:31 -0400
From: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <jouni@qca.qualcomm.com>,
	<usdutt@qti.qualcomm.com>, <ganeshk@qti.qualcomm.com>,
	<mkalikot@qca.qualcomm.com>, <amarnath@qca.qualcomm.com>,
	<pkushwah@qti.qualcomm.com>
Subject: [PATCH v4] cfg80211: Provision to allow the support for different beacon intervals
Date: Fri, 5 Aug 2016 10:56:08 +0530
Message-ID: <1470374768-22297-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160805_072636_752076_D3093C6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This commit provides the option for the host drivers to advertise the
support for different beacon intervals among the respective interface
combinations, through supp_diff_beacon_int (bool).

Signed-off-by: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
---
 include/net/cfg80211.h       |  4 ++++
 include/uapi/linux/nl80211.h |  7 +++++--
 net/wireless/core.c          | 13 ++++++++++++-
 net/wireless/nl80211.c       |  3 +++
 net/wireless/util.c          | 24 +++++++++++++++++++++++-
 5 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9c23f4d3..1b7cd42 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2939,6 +2939,8 @@ struct ieee80211_iface_limit {
  *	only in special cases.
  * @radar_detect_widths: bitmap of channel widths supported for radar detection
  * @radar_detect_regions: bitmap of regions supported for radar detection
+ * @supp_diff_beacon_int: In this combination, the interface combinations
+ *	support different beacon intervals.
  *
  * With this structure the driver can describe which interface
  * combinations it supports concurrently.
@@ -2970,6 +2972,7 @@ struct ieee80211_iface_limit {
  *	.n_limits = ARRAY_SIZE(limits2),
  *	.max_interfaces = 8,
  *	.num_different_channels = 1,
+ *	.supp_diff_beacon_int = true,
  *  };
  *
  *
@@ -2997,6 +3000,7 @@ struct ieee80211_iface_combination {
 	bool beacon_int_infra_match;
 	u8 radar_detect_widths;
 	u8 radar_detect_regions;
+	bool supp_diff_beacon_int;
 };
 
 struct ieee80211_txrx_stypes {
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 2206941..b8d147c 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -4203,6 +4203,8 @@ enum nl80211_iface_limit_attrs {
  *	of supported channel widths for radar detection.
  * @NL80211_IFACE_COMB_RADAR_DETECT_REGIONS: u32 attribute containing the bitmap
  *	of supported regulatory regions for radar detection.
+ * @NL80211_IFACE_COMB_DIFF_BEACON_INTERVAL: flag attribute specifying that
+ *	different beacon interval within this group is allowed.
  * @NUM_NL80211_IFACE_COMB: number of attributes
  * @MAX_NL80211_IFACE_COMB: highest attribute number
  *
@@ -4210,8 +4212,8 @@ enum nl80211_iface_limit_attrs {
  *	limits = [ #{STA} <= 1, #{AP} <= 1 ], matching BI, channels = 1, max = 2
  *	=> allows an AP and a STA that must match BIs
  *
- *	numbers = [ #{AP, P2P-GO} <= 8 ], channels = 1, max = 8
- *	=> allows 8 of AP/GO
+ *	numbers = [ #{AP, P2P-GO} <= 8 ], different BI, channels = 1, max = 8,
+ *	=> allows 8 of AP/GO that may have different beacon interval
  *
  *	numbers = [ #{STA} <= 2 ], channels = 2, max = 2
  *	=> allows two STAs on different channels
@@ -4237,6 +4239,7 @@ enum nl80211_if_combination_attrs {
 	NL80211_IFACE_COMB_NUM_CHANNELS,
 	NL80211_IFACE_COMB_RADAR_DETECT_WIDTHS,
 	NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
+	NL80211_IFACE_COMB_DIFF_BEACON_INTERVAL,
 
 	/* keep last */
 	NUM_NL80211_IFACE_COMB,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7645e97..204f861 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -485,7 +485,7 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 	int i, j;
 
 	for (i = 0; i < wiphy->n_iface_combinations; i++) {
-		u32 cnt = 0;
+		u32 cnt = 0, ap_cnt;
 		u16 all_iftypes = 0;
 
 		c = &wiphy->iface_combinations[i];
@@ -517,6 +517,7 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 		if (WARN_ON(!c->n_limits))
 			return -EINVAL;
 
+		ap_cnt = 0;
 		for (j = 0; j < c->n_limits; j++) {
 			u16 types = c->limits[j].types;
 
@@ -538,6 +539,9 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				return -EINVAL;
 
 			cnt += c->limits[j].max;
+			ap_cnt += (types & (BIT(NL80211_IFTYPE_AP) |
+					    BIT(NL80211_IFTYPE_P2P_GO))) ?
+					c->limits[j].max : 0;
 			/*
 			 * Don't advertise an unsupported type
 			 * in a combination.
@@ -546,6 +550,13 @@ static int wiphy_verify_combinations(struct wiphy *wiphy)
 				return -EINVAL;
 		}
 
+		/*
+		 * Different beacon interval allowed only in AP or P2P_GO
+		 * multi-interface combinations.
+		 */
+		if (WARN_ON(c->supp_diff_beacon_int && (ap_cnt < 2)))
+			return -EINVAL;
+
 		/* You can't even choose that many! */
 		if (WARN_ON(cnt < c->max_interfaces))
 			return -EINVAL;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 46417f9..0a35d54 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1020,6 +1020,9 @@ static int nl80211_put_iface_combinations(struct wiphy *wiphy,
 		     nla_put_u32(msg, NL80211_IFACE_COMB_RADAR_DETECT_REGIONS,
 				c->radar_detect_regions)))
 			goto nla_put_failure;
+		if (c->supp_diff_beacon_int &&
+		    nla_put_flag(msg, NL80211_IFACE_COMB_DIFF_BEACON_INTERVAL))
+			goto nla_put_failure;
 
 		nla_nest_end(msg, nl_combi);
 	}
diff --git a/net/wireless/util.c b/net/wireless/util.c
index b7d1592..3ceaa97 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1553,6 +1553,27 @@ bool ieee80211_chandef_to_operating_class(struct cfg80211_chan_def *chandef,
 }
 EXPORT_SYMBOL(ieee80211_chandef_to_operating_class);
 
+static bool diff_beacon_interval_supported(struct wiphy *wiphy)
+{
+	const struct ieee80211_iface_combination *c;
+	int i, j;
+
+	for (i = 0; i < wiphy->n_iface_combinations; i++) {
+		c = &wiphy->iface_combinations[i];
+
+		if (!c->supp_diff_beacon_int)
+			continue;
+
+		for (j = 0; j < c->n_limits; j++)
+			if (c->limits[j].types &
+				(BIT(NL80211_IFTYPE_AP) |
+				  BIT(NL80211_IFTYPE_P2P_GO)))
+				return true;
+	}
+
+	return false;
+}
+
 int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 				 u32 beacon_int)
 {
@@ -1565,7 +1586,8 @@ int cfg80211_validate_beacon_int(struct cfg80211_registered_device *rdev,
 	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
 		if (!wdev->beacon_interval)
 			continue;
-		if (wdev->beacon_interval != beacon_int) {
+		if (wdev->beacon_interval != beacon_int &&
+		    !diff_beacon_interval_supported(&rdev->wiphy)) {
 			res = -EINVAL;
 			break;
 		}
-- 
1.9.1

