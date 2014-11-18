Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33400 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932577AbaKRQ53 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2014 11:57:29 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/3] [RFC] cfg80211: allow drivers to support random MAC addresses for scan
Date: Tue, 18 Nov 2014 17:57:17 +0100
Message-Id: <1416329839-21648-1-git-send-email-johannes@sipsolutions.net> (sfid-20141118_175736_162934_619B4711)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add the necessary feature flags and a scan flag to support using
random MAC addresses for scan while unassociated.

The configuration for this supports an arbitrary MAC address
value and mask, so that any kind of configuration (e.g. fixed
OUI or full 46-bit random) can be requested. Full 46-bit random
is the default when no other configuration is passed.

Change-Id: Iabc713f6281673e37f783964006163b3404d06eb
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 14 ++++++++
 include/uapi/linux/nl80211.h | 24 +++++++++++++
 net/wireless/nl80211.c       | 84 ++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 119 insertions(+), 3 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4e16e9a6eedc..a1927f3a93bd 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1437,6 +1437,10 @@ struct cfg80211_ssid {
  * @aborted: (internal) scan request was notified as aborted
  * @notified: (internal) scan request was notified as done or aborted
  * @no_cck: used to send probe requests at non CCK rate in 2GHz band
+ * @mac_addr: MAC address used with randomisation
+ * @mac_addr_mask: MAC address mask used with randomisation, bits that
+ *	are 0 in the mask should be randomized, bits that are 1 should
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
@@ -1494,6 +1501,10 @@ struct cfg80211_match_set {
  * @channels: channels to scan
  * @min_rssi_thold: for drivers only supporting a single threshold, this
  *	contains the minimum over all matchsets
+ * @mac_addr: MAC address used with randomisation
+ * @mac_addr_mask: MAC address mask used with randomisation, bits that
+ *	are 0 in the mask should be randomized, bits that are 1 should
+ *	be taken from the @mac_addr
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1508,6 +1519,9 @@ struct cfg80211_sched_scan_request {
 	int n_match_sets;
 	s32 min_rssi_thold;
 
+	u8 mac_addr[ETH_ALEN] __aligned(2);
+	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9e081b0d5a89..3dd4798a045f 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1686,6 +1686,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_MAC_MASK: MAC address mask
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2043,6 +2045,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_OPER_CLASS,
 
+	NL80211_ATTR_MAC_MASK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4141,6 +4145,14 @@ enum nl80211_ap_sme_features {
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
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -4172,6 +4184,8 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_SUPPORTS_WMM_ADMISSION		= 1 << 26,
 	NL80211_FEATURE_MAC_ON_CREATE			= 1 << 27,
 	NL80211_FEATURE_TDLS_CHANNEL_SWITCH		= 1 << 28,
+	NL80211_FEATURE_SCAN_RANDOM_MAC_ADDR		= 1 << 29,
+	NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR	= 1 << 30,
 };
 
 /**
@@ -4220,11 +4234,21 @@ enum nl80211_connect_failed_reason {
  *	dangerous because will destroy stations performance as a lot of frames
  *	will be lost while scanning off-channel, therefore it must be used only
  *	when really needed
+ * @NL80211_SCAN_FLAG_RANDOM_ADDR: use a random MAC address for this scan (or
+ *	for scheduled scan: a different one for every scan iteration). When the
+ *	flag is set, depending on device capabilities the @NL80211_ATTR_MAC and
+ *	@NL80211_ATTR_MAC_MASK attributes may also be given in which case only
+ *	the masked bits will be preserved from the MAC address and the remainder
+ *	be randomized. If the attributes are not given, full randomisation (46
+ *	bits, locally administered 1, multicast 0) is assumed.
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
index 48e62e77bd2d..dd394971622b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -403,6 +403,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_REG_INDOOR] = { .type = NLA_FLAG },
+	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 };
 
 /* policy for the key attributes */
@@ -5691,6 +5692,44 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
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
+			if (!info->attrs[NL80211_ATTR_MAC] &&
+			    !info->attrs[NL80211_ATTR_MAC_MASK]) {
+				request->mac_addr[0] = 0x2;
+				request->mac_addr_mask[0] = 0x3;
+			} else if (!info->attrs[NL80211_ATTR_MAC] ||
+				   !info->attrs[NL80211_ATTR_MAC_MASK]) {
+				/* need both or none */
+				err = -EINVAL;
+				goto out_free;
+			} else {
+				memcpy(request->mac_addr,
+				       nla_data(info->attrs[NL80211_ATTR_MAC]),
+				       ETH_ALEN);
+				memcpy(request->mac_addr_mask,
+				       nla_data(info->attrs[NL80211_ATTR_MAC_MASK]),
+				       ETH_ALEN);
+			}
+
+			if (!is_multicast_ether_addr(request->mac_addr_mask) ||
+			    is_multicast_ether_addr(request->mac_addr)) {
+				/* don't allow or configure a broadcast address */
+				err = -EINVAL;
+				goto out_free;
+			}
+		}
 	}
 
 	request->no_cck =
@@ -5718,7 +5757,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 }
 
 static struct cfg80211_sched_scan_request *
-nl80211_parse_sched_scan(struct wiphy *wiphy,
+nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct nlattr **attrs)
 {
 	struct cfg80211_sched_scan_request *request;
@@ -5967,6 +6006,44 @@ nl80211_parse_sched_scan(struct wiphy *wiphy,
 			err = -EOPNOTSUPP;
 			goto out_free;
 		}
+
+		if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
+			if (!(wiphy->features &
+			      NL80211_FEATURE_SCHED_SCAN_RANDOM_MAC_ADDR)) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			if (wdev && wdev->current_bss) {
+				err = -EOPNOTSUPP;
+				goto out_free;
+			}
+
+			if (!attrs[NL80211_ATTR_MAC] &&
+			    !attrs[NL80211_ATTR_MAC_MASK]) {
+				request->mac_addr[0] = 0x2;
+				request->mac_addr_mask[0] = 0x3;
+			} else if (!attrs[NL80211_ATTR_MAC] ||
+				   !attrs[NL80211_ATTR_MAC_MASK]) {
+				/* need both or none */
+				err = -EINVAL;
+				goto out_free;
+			} else {
+				memcpy(request->mac_addr,
+				       nla_data(attrs[NL80211_ATTR_MAC]),
+				       ETH_ALEN);
+				memcpy(request->mac_addr_mask,
+				       nla_data(attrs[NL80211_ATTR_MAC_MASK]),
+				       ETH_ALEN);
+			}
+
+			if (!is_multicast_ether_addr(request->mac_addr_mask) ||
+			    is_multicast_ether_addr(request->mac_addr)) {
+				/* don't allow or configure a broadcast address */
+				err = -EINVAL;
+				goto out_free;
+			}
+		}
 	}
 
 	request->interval = interval;
@@ -5984,6 +6061,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
@@ -5993,7 +6071,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (rdev->sched_scan_req)
 		return -EINPROGRESS;
 
-	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy,
+	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
 							info->attrs);
 	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
 	if (err)
@@ -8766,7 +8844,7 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 	if (err)
 		goto out;
 
-	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, tb);
+	trig->nd_config = nl80211_parse_sched_scan(&rdev->wiphy, NULL, tb);
 	err = PTR_ERR_OR_ZERO(trig->nd_config);
 	if (err)
 		trig->nd_config = NULL;
-- 
2.1.1

