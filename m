Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19964 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933810AbcKWWIK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 17:08:10 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH 2/2] cfg80211: Add support to sched scan to report better BSSs
Date: Thu, 24 Nov 2016 00:07:37 +0200
Message-ID: <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20161123_230815_997826_4BF8F899)
In-Reply-To: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: vamsi krishna <vamsin@qti.qualcomm.com>

Enhance sched scan to support option of finding a better BSS while in
connected state. Firmware scans the medium and reports when it finds a
known BSS which has a significantly better RSSI than the current
connected BSS.

Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 17 +++++++++++++++++
 include/uapi/linux/nl80211.h | 17 +++++++++++++++++
 net/wireless/nl80211.c       | 32 ++++++++++++++++++++++++++++++--
 3 files changed, 64 insertions(+), 2 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ef42749..c62c42a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1626,6 +1626,20 @@ struct cfg80211_sched_scan_plan {
  *	cycle.  The driver may ignore this parameter and start
  *	immediately (or at any other time), if this feature is not
  *	supported.
+ * @relative_rssi: Relative RSSI threshold to restrict scan result reporting in
+ *	connected state to cases where a matching BSS is determined to have a
+ *	significantly better RSSI than the current connected BSS.
+ * @relative_rssi_5g_pref: The amount of RSSI preference that is given to a
+ *	5 GHz BSS over 2.4 GHz BSS while looking for better BSSs in connected
+ *	state.
+ *	If the current connected BSS is in the 2.4 GHz band, other BSSs in the
+ *	2.4 GHz band to be reported should have better RSSI by @relative_rssi
+ *	and other BSSs in the 5 GHz band to be reported should have better RSSI
+ *	by (@relative_rssi - @relative_rssi_5g_pref).
+ *	If the current connected BSS is in the 5 GHz band, other BSSs in the
+ *	2.4 GHz band to be reported should have better RSSI by
+ *	(@relative_rssi + @relative_rssi_5g_pref) and other BSSs in the 5 GHz
+ *	band to be reported should have better RSSI by by @relative_rssi.
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1645,6 +1659,9 @@ struct cfg80211_sched_scan_request {
 	u8 mac_addr[ETH_ALEN] __aligned(2);
 	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
 
+	int relative_rssi;
+	int relative_rssi_5g_pref;
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 984a35ac..34b16a4 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1981,6 +1981,16 @@ enum nl80211_commands {
  *	%NL80211_ATTR_MAC has also been used in various commands/events for
  *	specifying the BSSID.
  *
+ * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI: Relative RSSI threshold by which
+ *	other BSSs has to be better than the current connected BSS so that they
+ *	get reported to user space. This will give an opportunity to userspace
+ *	to consider connecting to other matching BSSs which have better RSSI
+ *	than the current connected BSS.
+ *
+ * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF: The amount of RSSI preference
+ *	to be given to 5 GHz APs over 2.4 GHz APs while searching for better
+ *	BSSs than the current connected BSS.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2387,6 +2397,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSSID,
 
+	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
+	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -4698,6 +4711,9 @@ enum nl80211_feature_flags {
  *	configuration (AP/mesh) with VHT rates.
  * @NL80211_EXT_FEATURE_FILS_STA: This driver supports Fast Initial Link Setup
  *	with user space SME (NL80211_CMD_AUTHENTICATE) in station mode.
+ * @NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS: The driver supports sched_scan
+ *	for reporting BSSs with better RSSI than the current connected BSS
+ *	(%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4713,6 +4729,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_BEACON_RATE_HT,
 	NL80211_EXT_FEATURE_BEACON_RATE_VHT,
 	NL80211_EXT_FEATURE_FILS_STA,
+	NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8db5cb1..af018a5 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,8 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -6856,6 +6858,7 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	size_t ie_len;
 	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
 	s32 default_match_rssi = NL80211_SCAN_RSSI_THOLD_OFF;
+	int bbr;
 
 	if (!is_valid_ie_attr(attrs[NL80211_ATTR_IE]))
 		return ERR_PTR(-EINVAL);
@@ -6950,6 +6953,13 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 	if (!n_plans || n_plans > wiphy->max_sched_scan_plans)
 		return ERR_PTR(-EINVAL);
 
+	bbr = wiphy_ext_feature_isset(
+		wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS);
+	if (!bbr &&
+	    (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] ||
+	     attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF]))
+		return ERR_PTR(-EINVAL);
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->match_sets) * n_match_sets
@@ -7156,6 +7166,14 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		request->delay =
 			nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_DELAY]);
 
+	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI])
+		request->relative_rssi = nla_get_s32(
+			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]);
+
+	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF])
+		request->relative_rssi_5g_pref = nla_get_s32(
+			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF]);
+
 	err = nl80211_parse_sched_scan_plans(wiphy, n_plans, request, attrs);
 	if (err)
 		goto out_free;
@@ -9649,7 +9667,8 @@ static int nl80211_send_wowlan_tcp(struct sk_buff *msg,
 	return 0;
 }
 
-static int nl80211_send_wowlan_nd(struct sk_buff *msg,
+static int nl80211_send_wowlan_nd(struct wiphy *wiphy,
+				  struct sk_buff *msg,
 				  struct cfg80211_sched_scan_request *req)
 {
 	struct nlattr *nd, *freqs, *matches, *match, *scan_plans, *scan_plan;
@@ -9670,6 +9689,15 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
 		return -ENOBUFS;
 
+	if (wiphy_ext_feature_isset(
+		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_BETTER_BSS) &&
+	    (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
+			 req->relative_rssi) ||
+	     nla_put_u32(msg,
+			 NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI_5G_PREF,
+			 req->relative_rssi_5g_pref)))
+		return -ENOBUFS;
+
 	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
 	if (!freqs)
 		return -ENOBUFS;
@@ -9783,7 +9811,7 @@ static int nl80211_get_wowlan(struct sk_buff *skb, struct genl_info *info)
 			goto nla_put_failure;
 
 		if (nl80211_send_wowlan_nd(
-			    msg,
+			    &rdev->wiphy, msg,
 			    rdev->wiphy.wowlan_config->nd_config))
 			goto nla_put_failure;
 
-- 
1.9.1
