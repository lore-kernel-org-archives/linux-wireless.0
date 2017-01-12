Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20326 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750969AbdALXMu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 18:12:50 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
        vamsi krishna <vamsin@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v4 2/4] cfg80211: Add support to sched scan to report better BSSs
Date: Fri, 13 Jan 2017 01:12:20 +0200
Message-ID: <1484262742-3927-2-git-send-email-jouni@qca.qualcomm.com> (sfid-20170113_001253_387349_0445FD38)
In-Reply-To: <1484262742-3927-1-git-send-email-jouni@qca.qualcomm.com>
References: <1484262742-3927-1-git-send-email-jouni@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: vamsi krishna <vamsin@qti.qualcomm.com>

Enhance sched scan to support option of finding a better BSS while in
connected state. Firmware scans the medium and reports when it finds a
known BSS which has better RSSI than the current connected BSS. New
attributes to specify the relative RSSI (compared to the current BSS)
are added to the sched scan to implement this.

Signed-off-by: vamsi krishna <vamsin@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 include/net/cfg80211.h       | 36 +++++++++++++++++++++++++-----------
 include/uapi/linux/nl80211.h | 30 ++++++++++++++++++++++++++++++
 net/wireless/nl80211.c       | 44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 11 deletions(-)

v4:
- rebased on top of the random TA patch
- update comments to cover possibility of negative relative_rssi
- use NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST only if
  NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI is present
- remove unnecessary nl80211_send_wowlan_nd() argument change
- remove invalid rssi_adjust.band comparison (different enum)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb13789..4456491 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1620,6 +1620,17 @@ struct cfg80211_sched_scan_plan {
 };
 
 /**
+ * struct cfg80211_bss_select_adjust - BSS selection with RSSI adjustment.
+ *
+ * @band: band of BSS which should match for RSSI level adjustment.
+ * @delta: value of RSSI level adjustment.
+ */
+struct cfg80211_bss_select_adjust {
+	enum nl80211_band band;
+	s8 delta;
+};
+
+/**
  * struct cfg80211_sched_scan_request - scheduled scan request description
  *
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
@@ -1654,6 +1665,16 @@ struct cfg80211_sched_scan_plan {
  *	cycle.  The driver may ignore this parameter and start
  *	immediately (or at any other time), if this feature is not
  *	supported.
+ * @relative_rssi_set: Indicates whether @relative_rssi is set or not.
+ * @relative_rssi: Relative RSSI threshold in dB to restrict scan result
+ *	reporting in connected state to cases where a matching BSS is determined
+ *	to have better or slightly worse RSSI than the current connected BSS.
+ *	The relative RSSI threshold values are ignored in disconnected state.
+ * @rssi_adjust: delta dB of RSSI preference to be given to the BSSs that belong
+ *	to the specified band while deciding whether a better BSS is reported
+ *	using @relative_rssi. If delta is a negative number, the BSSs that
+ *	belong to the specified band will be penalized by delta dB in relative
+ *	comparisions.
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1673,6 +1694,10 @@ struct cfg80211_sched_scan_request {
 	u8 mac_addr[ETH_ALEN] __aligned(2);
 	u8 mac_addr_mask[ETH_ALEN] __aligned(2);
 
+	bool relative_rssi_set;
+	s8 relative_rssi;
+	struct cfg80211_bss_select_adjust rssi_adjust;
+
 	/* internal */
 	struct wiphy *wiphy;
 	struct net_device *dev;
@@ -1981,17 +2006,6 @@ struct cfg80211_ibss_params {
 };
 
 /**
- * struct cfg80211_bss_select_adjust - BSS selection with RSSI adjustment.
- *
- * @band: band of BSS which should match for RSSI level adjustment.
- * @delta: value of RSSI level adjustment.
- */
-struct cfg80211_bss_select_adjust {
-	enum nl80211_band band;
-	s8 delta;
-};
-
-/**
  * struct cfg80211_bss_selection - connection parameters for BSS selection.
  *
  * @behaviour: requested BSS selection behaviour.
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 908886c..6b17feb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1982,6 +1982,20 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSSID: The BSSID of the AP. Note that %NL80211_ATTR_MAC is also
  *	used in various commands/events for specifying the BSSID.
  *
+ * @NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI: Relative RSSI threshold by which
+ *	other BSSs has to be better or slightly worse than the current
+ *	connected BSS so that they get reported to user space.
+ *	This will give an opportunity to userspace to consider connecting to
+ *	other matching BSSs which have better or slightly worse RSSI than
+ *	the current connected BSS by using an offloaded operation to avoid
+ *	unnecessary wakeups.
+ *
+ * @NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST: When present the RSSI level for BSSs in
+ *	the specified band is to be adjusted before doing
+ *	%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI based comparision to figure out
+ *	better BSSs. The attribute value is a packed structure
+ *	value as specified by &struct nl80211_bss_select_rssi_adjust.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2388,6 +2402,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSSID,
 
+	NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
+	NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3080,6 +3097,13 @@ enum nl80211_reg_rule_attr {
  *	how this API was implemented in the past. Also, due to the same problem,
  *	the only way to create a matchset with only an RSSI filter (with this
  *	attribute) is if there's only a single matchset with the RSSI attribute.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_RELATIVE_RSSI: Flag indicating whether
+ *	%NL80211_SCHED_SCAN_MATCH_ATTR_RSSI to be used as absolute RSSI or
+ *	relative to current bss's RSSI.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI_ADJUST: When present the RSSI level for
+ *	BSS-es in the specified band is to be adjusted before doing
+ *	RSSI-based BSS selection. The attribute value is a packed structure
+ *	value as specified by &struct nl80211_bss_select_rssi_adjust.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -3089,6 +3113,8 @@ enum nl80211_sched_scan_match_attr {
 
 	NL80211_SCHED_SCAN_MATCH_ATTR_SSID,
 	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI,
+	NL80211_SCHED_SCAN_MATCH_ATTR_RELATIVE_RSSI,
+	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI_ADJUST,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
@@ -4703,6 +4729,9 @@ enum nl80211_feature_flags {
  *	in @NL80211_CMD_FRAME while not associated.
  * @NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED: This driver supports
  *	randomized TA in @NL80211_CMD_FRAME while associated.
+ * @NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI: The driver supports sched_scan
+ *	for reporting BSSs with better RSSI than the current connected BSS
+ *	(%NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI).
  *
  * @NUM_NL80211_EXT_FEATURES: number of extended features.
  * @MAX_NL80211_EXT_FEATURES: highest extended feature index.
@@ -4720,6 +4749,7 @@ enum nl80211_ext_feature_index {
 	NL80211_EXT_FEATURE_FILS_STA,
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA,
 	NL80211_EXT_FEATURE_MGMT_TX_RANDOM_TA_CONNECTED,
+	NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI,
 
 	/* add new features before the definition below */
 	NUM_NL80211_EXT_FEATURES,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b378d0a..71c66ff 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] = { .type = NLA_S8 },
+	[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST] = {
+		.len = sizeof(struct nl80211_bss_select_rssi_adjust)
+	},
 };
 
 /* policy for the key attributes */
@@ -6950,6 +6954,12 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!n_plans || n_plans > wiphy->max_sched_scan_plans)
 		return ERR_PTR(-EINVAL);
 
+	if (!wiphy_ext_feature_isset(
+		    wiphy, NL80211_EXT_FEATURE_SCHED_SCAN_RELATIVE_RSSI) &&
+	    (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI] ||
+	     attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]))
+		return ERR_PTR(-EINVAL);
+
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
 			+ sizeof(*request->match_sets) * n_match_sets
@@ -7156,6 +7166,26 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 		request->delay =
 			nla_get_u32(attrs[NL80211_ATTR_SCHED_SCAN_DELAY]);
 
+	if (attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]) {
+		request->relative_rssi = nla_get_s8(
+			attrs[NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI]);
+		request->relative_rssi_set = true;
+	}
+
+	if (request->relative_rssi_set &&
+	    attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]) {
+		struct nl80211_bss_select_rssi_adjust *rssi_adjust;
+
+		rssi_adjust = nla_data(
+			attrs[NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST]);
+		request->rssi_adjust.band = rssi_adjust->band;
+		request->rssi_adjust.delta = rssi_adjust->delta;
+		if (!is_band_valid(wiphy, request->rssi_adjust.band)) {
+			err = -EINVAL;
+			goto out_free;
+		}
+	}
+
 	err = nl80211_parse_sched_scan_plans(wiphy, n_plans, request, attrs);
 	if (err)
 		goto out_free;
@@ -9692,6 +9722,20 @@ static int nl80211_send_wowlan_nd(struct sk_buff *msg,
 	if (nla_put_u32(msg, NL80211_ATTR_SCHED_SCAN_DELAY, req->delay))
 		return -ENOBUFS;
 
+	if (req->relative_rssi_set) {
+		struct nl80211_bss_select_rssi_adjust rssi_adjust;
+
+		if (nla_put_s8(msg, NL80211_ATTR_SCHED_SCAN_RELATIVE_RSSI,
+			       req->relative_rssi))
+			return -ENOBUFS;
+
+		rssi_adjust.band = req->rssi_adjust.band;
+		rssi_adjust.delta = req->rssi_adjust.delta;
+		if (nla_put(msg, NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST,
+			    sizeof(rssi_adjust), &rssi_adjust))
+			return -ENOBUFS;
+	}
+
 	freqs = nla_nest_start(msg, NL80211_ATTR_SCAN_FREQUENCIES);
 	if (!freqs)
 		return -ENOBUFS;
-- 
2.7.4
