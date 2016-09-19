Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49622 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752725AbcISHzc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:55:32 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add checks for beacon rate, extend to mesh
Date: Mon, 19 Sep 2016 09:55:26 +0200
Message-Id: <1474271726-31013-1-git-send-email-johannes@sipsolutions.net> (sfid-20160919_095536_437018_52B56D00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The previous commit added support for specifying the beacon rate
for AP mode. Add features checks to this, and extend it to also
support the rate configuration for mesh networks. For IBSS it's
not as simple due to joining etc., so that's not yet supported.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       |  4 +++-
 include/uapi/linux/nl80211.h | 17 +++++++++++++++-
 net/wireless/nl80211.c       | 46 +++++++++++++++++++++++++++++++++-----------
 3 files changed, 54 insertions(+), 13 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0949c8bc2d1..ed37304fa09d 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -712,7 +712,7 @@ struct cfg80211_bitrate_mask {
  *	MAC address based access control
  * @pbss: If set, start as a PCP instead of AP. Relevant for DMG
  *	networks.
- * @beacon_rate: masks for setting user configured beacon tx rate.
+ * @beacon_rate: bitrate to be used for beacons
  */
 struct cfg80211_ap_settings {
 	struct cfg80211_chan_def chandef;
@@ -1365,6 +1365,7 @@ struct mesh_config {
  * @beacon_interval: beacon interval to use
  * @mcast_rate: multicat rate for Mesh Node [6Mbps is the default for 802.11a]
  * @basic_rates: basic rates to use when creating the mesh
+ * @beacon_rate: bitrate to be used for beacons
  *
  * These parameters are fixed when the mesh is created.
  */
@@ -1385,6 +1386,7 @@ struct mesh_setup {
 	u16 beacon_interval;
 	int mcast_rate[NUM_NL80211_BANDS];
 	u32 basic_rates;
+	struct cfg80211_bitrate_mask beacon_rate;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 220694151434..ec10d1b2838f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1343,7 +1343,13 @@ enum nl80211_commands {
  *	enum nl80211_band value is used as the index (nla_type() of the nested
  *	data. If a band is not included, it will be configured to allow all
  *	rates based on negotiated supported rates information. This attribute
- *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK.
+ *	is used with %NL80211_CMD_SET_TX_BITRATE_MASK and with starting AP,
+ *	and joining mesh networks (not IBSS yet). In the later case, it must
+ *	specify just a single bitrate, which is to be used for the beacon.
+ *	The driver must also specify support for this with the extended
+ *	features NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
+ *	NL80211_EXT_FEATURE_BEACON_RATE_HT and
+ *	NL80211_EXT_FEATURE_BEACON_RATE_VHT.
  *
  * @NL80211_ATTR_FRAME_MATCH: A binary attribute which typically must contain
  *	at least one byte, currently used with @NL80211_CMD_REGISTER_FRAME.
@@ -4551,6 +4557,12 @@ enum nl80211_feature_flags {
  *	(if available).
  * @NL80211_EXT_FEATURE_SET_SCAN_DWELL: This driver supports configuration of
  *	channel dwell time.
+ * @NL80211_EXT_FEATURE_BEACON_RATE_LEGACY: Driver supports beacon rate
+ *	configuration (AP/mesh), supporting a legacy (non HT/VHT) rate.
+ * @NL80211_EXT_FEATURE_BEACON_RATE_HT: Driver supports beacon rate
+ *	configuration (AP/mesh) with HT rates.
+ * @NL80211_EXT_FEATURE_BEACON_RATE_VHT: Driver supports beacon rate
+ *	configuration (AP/mesh) with VHT rates.
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4562,6 +4574,9 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_SCAN_START_TIME,
 	NL80211_EXT_FEATURE_BSS_PARENT_TSF,
 	NL80211_EXT_FEATURE_SET_SCAN_DWELL,
+	NL80211_EXT_FEATURE_BEACON_RATE_LEGACY,
+	NL80211_EXT_FEATURE_BEACON_RATE_HT,
+	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a10484da60c0..b8441e60b0f6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3569,13 +3569,12 @@ out:
 	return 0;
 }
 
-static int validate_beacon_tx_rate(struct cfg80211_ap_settings *params)
+static int validate_beacon_tx_rate(struct cfg80211_registered_device *rdev,
+				   enum nl80211_band band,
+				   struct cfg80211_bitrate_mask *beacon_rate)
 {
-	u32 rate, count_ht, count_vht, i;
-	enum nl80211_band band;
-
-	band = params->chandef.chan->band;
-	rate = params->beacon_rate.control[band].legacy;
+	u32 count_ht, count_vht, i;
+	u32 rate = beacon_rate->control[band].legacy;
 
 	/* Allow only one rate */
 	if (hweight32(rate) > 1)
@@ -3583,9 +3582,9 @@ static int validate_beacon_tx_rate(struct cfg80211_ap_settings *params)
 
 	count_ht = 0;
 	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
-		if (hweight8(params->beacon_rate.control[band].ht_mcs[i]) > 1) {
+		if (hweight8(beacon_rate->control[band].ht_mcs[i]) > 1) {
 			return -EINVAL;
-		} else if (params->beacon_rate.control[band].ht_mcs[i]) {
+		} else if (beacon_rate->control[band].ht_mcs[i]) {
 			count_ht++;
 			if (count_ht > 1)
 				return -EINVAL;
@@ -3596,9 +3595,9 @@ static int validate_beacon_tx_rate(struct cfg80211_ap_settings *params)
 
 	count_vht = 0;
 	for (i = 0; i < NL80211_VHT_NSS_MAX; i++) {
-		if (hweight16(params->beacon_rate.control[band].vht_mcs[i]) > 1) {
+		if (hweight16(beacon_rate->control[band].vht_mcs[i]) > 1) {
 			return -EINVAL;
-		} else if (params->beacon_rate.control[band].vht_mcs[i]) {
+		} else if (beacon_rate->control[band].vht_mcs[i]) {
 			count_vht++;
 			if (count_vht > 1)
 				return -EINVAL;
@@ -3610,6 +3609,19 @@ static int validate_beacon_tx_rate(struct cfg80211_ap_settings *params)
 	if ((count_ht && count_vht) || (!rate && !count_ht && !count_vht))
 		return -EINVAL;
 
+	if (rate &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_BEACON_RATE_LEGACY))
+		return -EINVAL;
+	if (count_ht &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_BEACON_RATE_HT))
+		return -EINVAL;
+	if (count_vht &&
+	    !wiphy_ext_feature_isset(&rdev->wiphy,
+				     NL80211_EXT_FEATURE_BEACON_RATE_VHT))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3847,7 +3859,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		if (err)
 			return err;
 
-		err = validate_beacon_tx_rate(&params);
+		err = validate_beacon_tx_rate(rdev, params.chandef.chan->band,
+					      &params.beacon_rate);
 		if (err)
 			return err;
 	}
@@ -9406,6 +9419,17 @@ static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
 			return err;
 	}
 
+	if (info->attrs[NL80211_ATTR_TX_RATES]) {
+		err = nl80211_parse_tx_bitrate_mask(info, &setup.beacon_rate);
+		if (err)
+			return err;
+
+		err = validate_beacon_tx_rate(rdev, setup.chandef.chan->band,
+					      &setup.beacon_rate);
+		if (err)
+			return err;
+	}
+
 	return cfg80211_join_mesh(rdev, dev, &setup, &cfg);
 }
 
-- 
2.8.1
