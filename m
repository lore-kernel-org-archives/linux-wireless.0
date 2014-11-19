Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39960 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755187AbaKSRfL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:35:11 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/4] cfg80211: allow drivers to support random MAC addresses for scan
Date: Wed, 19 Nov 2014 18:35:02 +0100
Message-Id: <1416418505-7359-2-git-send-email-johannes@sipsolutions.net> (sfid-20141119_183521_975995_5B3C4B1B)
In-Reply-To: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
References: <1416418505-7359-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the necessary feature flags and a scan flag to support using
random MAC addresses for scan while unassociated.

The configuration for this supports an arbitrary MAC address
value and mask, so that any kind of configuration (e.g. fixed
OUI or full 46-bit random) can be requested. Full 46-bit random
is the default when no other configuration is passed.

Also add a small helper function to use the addr/mask correctly.

Change-Id: Iabc713f6281673e37f783964006163b3404d06eb
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-on: https://gerrit.rds.intel.com/r/47440
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Tested-by: IWL Jenkins
---
 include/net/cfg80211.h       | 25 +++++++++++++
 include/uapi/linux/nl80211.h | 29 +++++++++++++++
 net/wireless/nl80211.c       | 86 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 137 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 34535508a006..1e37a4b00f95 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1437,6 +1437,10 @@ struct cfg80211_ssid {
  * @aborted: (internal) scan request was notified as aborted
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @mac_addr: MAC address used with randomisation
+ * @mac_addr_mask: MAC address mask used with randomisation, bits that
+ *	are 0 in the mask should be randomised, bits that are 1 should
+ *	be taken from the @mac_addr
  */
 struct cfg80211_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1451,6 +1455,9 @@ struct cfg80211_scan_request {
 
 	struct wireless_dev *wdev;
 
+	u8 mac_addr[ETH_ALEN] __aligned(2);
+	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
+
 	/* internal */
 	struct wiphy *wiphy;
 	unsigned long scan_start;
@@ -1461,6 +1468,17 @@ struct cfg80211_scan_request {
 	struct ieee80211_channel *channels[0];
 };
 
+static inline void get_random_mask_addr(u8 *buf, const u8 *addr, const u8 *mask)
+{
+	int i;
+
+	get_random_bytes(buf, ETH_ALEN);
+	for (i = 0; i < ETH_ALEN; i++) {
+		buf[i] &= ~mask[i];
+		buf[i] |= addr[i] & mask[i];
+	}
+}
+
 /**
  * struct cfg80211_match_set - sets of attributes to match
  *
@@ -1494,6 +1512,10 @@ struct cfg80211_match_set {
  * @channels: channels to scan
  * @min_rssi_thold: for drivers only supporting a single threshold, this
  *	contains the minimum over all matchsets
+ * @mac_addr: MAC address used with randomisation
+ * @mac_addr_mask: MAC address mask used with randomisation, bits that
+ *	are 0 in the mask should be randomised, bits that are 1 should
+ *	be taken from the @mac_addr
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1508,6 +1530,9 @@ struct cfg80211_sched_scan_request {
 	int n_match_sets;
 	s32 min_rssi_thold;
 
+	u8 mac_addr[ETH_ALEN] __aligned(2);
+	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 142546ec36d6..31c2bd885cf9 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1686,6 +1686,8 @@ enum nl80211_commands {
  *
  * @NL80211_ATTR_OPER_CLASS: operating class
  *
+ * @NL80211_ATTR_MAC_MASK: MAC address mask
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2041,6 +2043,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_OPER_CLASS,
 
+	NL80211_ATTR_MAC_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4146,6 +4150,18 @@ enum nl80211_ap_sme_features {
  *	See 'macaddr' field in the vif_params (cfg80211.h).
  * @NL80211_FEATURE_TDLS_CHANNEL_SWITCH: Driver supports channel switching when
  *	operating as a TDLS peer.
+ * @NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR: This device/driver supports using a
+ *	random MAC address during scan (if the device is unassociated); the
+ *	%NL80211_SCAN_FLAG_RANDOM_ADDR flag may be set for scans and the MAC
+ *	address mask/value will be used.
+ * @NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR: This device/driver supports
+ *	using a random MAC address for every scan iteration during scheduled
+ *	scan (while not associated), the %NL80211_SCAN_FLAG_RANDOM_ADDR may
+ *	be set for scheduled scan and the MAC address mask/value will be used.
+ * @NL80211_FEATURE_ND_RANDOM_MAC_ADDR: This device/driver supports using a
+ *	random MAC address for every scan iteration during "net detect", i.e.
+ *	scan in unassociated WoWLAN, the %NL80211_SCAN_FLAG_RANDOM_ADDR may
+ *	be set for scheduled scan and the MAC address mask/value will be used.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4177,6 +4193,9 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
 	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 27,
 	NL80211_FEATURE_TDLS_CHANNEL_SWITCH		= 1 << 28,
+	NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR		= 1 << 29,
+	NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR	= 1 << 30,
+	NL80211_FEATURE_ND_RANDOM_MAC_ADDR		= 1 << 31,
 };
 
 /**
@@ -4225,11 +4244,21 @@ enum nl80211_connect_failed_reason {
  *	dangerous because will destroy stations performance as a lot of frames
  *	will be lost while scanning off-channel, therefore it must be used only
  *	when really needed
+ * @NL80211_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (or
+ *	for scheduled scan: a different one for every scan iteration). When the
+ *	flag is set, depending on device capabilities the @NL80211_ATTR_MAC and
+ *	@NL80211_ATTR_MAC_MASK attributes may also be given in which case only
+ *	the masked bits will be preserved from the MAC address and the remainder
+ *	randomised. If the attributes are not given full randomisation (46 bits,
+ *	locally administered 1, multicast 0) is assumed.
+ *	This flag must not be requested when the feature isn't supported, check
+ *	the nl80211 feature flags for the device.
  */
 enum nl80211_scan_flags {
 	NL80211_SCAN_FLAG_LOW_PRIORITY			= 1<<0,
 	NL80211_SCAN_FLAG_FLUSH				= 1<<1,
 	NL80211_SCAN_FLAG_AP				= 1<<2,
+	NL80211_SCAN_FLAG_RANDOM_ADDR			= 1<<3,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 610ee49fb655..aa8ed59f7c00 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -395,6 +395,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 };
 
 /* policy for the key attributes */
@@ -5481,6 +5482,43 @@ static int validate_scan_freqs(struct nlattr *freqs)
 	return n_channels;
 }
 
+static int nl80211_parse_random_mac(struct nlattr **attrs,
+				    u8 *mac_addr, u8 *mac_addr_mask)
+{
+	int i;
+
+	if (!attrs[NL80211_ATTR_MAC] && !attrs[NL80211_ATTR_MAC_MASK]) {
+		memset(mac_addr, 0, ETH_ALEN);
+		memset(mac_addr_mask, 0, ETH_ALEN);
+		mac_addr[0] = 0x2;
+		mac_addr_mask[0] = 0x3;
+
+		return 0;
+	}
+
+	/* need both or none */
+	if (!attrs[NL80211_ATTR_MAC] || !attrs[NL80211_ATTR_MAC_MASK])
+		return -EINVAL;
+
+	memcpy(mac_addr, nla_data(attrs[NL80211_ATTR_MAC]), ETH_ALEN);
+	memcpy(mac_addr_mask, nla_data(attrs[NL80211_ATTR_MAC_MASK]), ETH_ALEN);
+
+	/* don't allow or configure an mcast address */
+	if (!is_multicast_ether_addr(mac_addr_mask) ||
+	    is_multicast_ether_addr(mac_addr))
+		return -EINVAL;
+
+	/*
+	 * allow users to pass a MAC address that has bits set outside
+	 * of the mask, but don't bother drivers with having to deal
+	 * with such bits
+	 */
+	for (i = 0; i < ETH_ALEN; i++)
+		mac_addr[i] &= mac_addr_mask[i];
+
+	return 0;
+}
+
 static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -5658,6 +5696,25 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
+
+		if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+			if (!(wiphy->features &
+					NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR)) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			if (wdev->current_bss) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			err = nl80211_parse_random_mac(info->attrs,
+						       request->mac_addr,
+						       request->mac_addr_mask);
+			if (err)
+				goto out_free;
+		}
 	}
 
 	request->no_cck =
@@ -5685,7 +5742,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 }
 
 static struct cfg80211_sched_scan_request *
-nl80211_parse_sched_scan(struct wiphy *wiphy,
+nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct nlattr **attrs)
 {
 	struct cfg80211_sched_scan_request *request;
@@ -5934,6 +5991,28 @@ nl80211_parse_sched_scan(struct wiphy *wiphy,
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
+
+		if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+			u32 flg = NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR;
+
+			if (!wdev) /* must be net-detect */
+				flg = NL80211_FEATURE_ND_RANDOM_MAC_ADDR;
+
+			if (!(wiphy->features & flg)) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			if (wdev && wdev->current_bss) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			err = nl80211_parse_random_mac(attrs, request->mac_addr,
+						       request->mac_addr_mask);
+			if (err)
+				goto out_free;
+		}
 	}
 
 	request->interval = interval;
@@ -5951,6 +6030,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
@@ -5960,7 +6040,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (rdev->sched_scan_req)
 		return -EINPROGRESS;
 
-	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy,
+	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
 							info->attrs);
 	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
 	if (err)
@@ -8721,7 +8801,7 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 	if (err)
 		goto out;
 
-	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, tb);
+	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, NULL, tb);
 	err = PTR_ERR_OR_ZERO(trig->nd_config);
 	if (err)
 		trig->nd_config = NULL;
-- 
2.1.1

