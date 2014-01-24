Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49305 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbaAXKBz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 05:01:55 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Raja Mani <rmani@qti.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: fix scheduled scan RSSI matchset attribute confusion
Date: Fri, 24 Jan 2014 11:01:51 +0100
Message-Id: <1390557711-11596-1-git-send-email-johannes@sipsolutions.net> (sfid-20140124_110223_127568_DD01E3EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The scheduled scan matchsets were intended to be a list of filters,
with the found BSS having to pass at least one of them to be passed
to the host. When the RSSI attribute was added, however, this was
broken and currently wpa_supplicant adds that attribute in its own
matchset; however, it doesn't intend that to mean that anything
that passes the RSSI filter should be passed to the host, instead
it wants it to mean that everything needs to also have higher RSSI.

This is semantically problematic because we have a list of filters
like [ SSID1, SSID2, SSID3, RSSI ] with no real indication which
one should be OR'ed and which one AND'ed.

To fix this, move the RSSI filter attribute into each matchset. As
we need to stay backward compatible, treat a matchset with only the
RSSI attribute as a "default RSSI filter" for all other matchsets.

To make driver implementation easier, keep a global min_rssi_thold
for the entire request as well. The only affected driver is ath6kl.

I found this when I looked into the code after Raja Mani submitted
a patch fixing the n_match_sets calculation to disregard the RSSI,
but that patch didn't address the semantic issue.

Reported-by: Raja Mani <rmani@qti.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  6 +--
 include/net/cfg80211.h                     |  7 +++-
 include/uapi/linux/nl80211.h               | 10 ++++-
 net/wireless/nl80211.c                     | 62 +++++++++++++++++++++++++-----
 4 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index fd4c89d..ce287e3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3286,12 +3286,12 @@ static int ath6kl_cfg80211_sscan_start(struct wiphy *wiphy,
 
 	if (test_bit(ATH6KL_FW_CAPABILITY_RSSI_SCAN_THOLD,
 		     ar->fw_capabilities)) {
-		if (request->rssi_thold <= NL80211_SCAN_RSSI_THOLD_OFF)
+		if (request->min_rssi_thold <= NL80211_SCAN_RSSI_THOLD_OFF)
 			rssi_thold = 0;
-		else if (request->rssi_thold < -127)
+		else if (request->min_rssi_thold < -127)
 			rssi_thold = -127;
 		else
-			rssi_thold = request->rssi_thold;
+			rssi_thold = request->min_rssi_thold;
 
 		ret = ath6kl_wmi_set_rssi_filter_cmd(ar->wmi, vif->fw_vif_idx,
 						     rssi_thold);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d5e57bf..459700e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1395,9 +1395,11 @@ struct cfg80211_scan_request {
  * struct cfg80211_match_set - sets of attributes to match
  *
  * @ssid: SSID to be matched
+ * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
  */
 struct cfg80211_match_set {
 	struct cfg80211_ssid ssid;
+	s32 rssi_thold;
 };
 
 /**
@@ -1420,7 +1422,8 @@ struct cfg80211_match_set {
  * @dev: the interface
  * @scan_start: start time of the scheduled scan
  * @channels: channels to scan
- * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
+ * @min_rssi_thold: for drivers only supporting a single threshold, this
+ *	contains the minimum over all matchsets
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -1433,7 +1436,7 @@ struct cfg80211_sched_scan_request {
 	u32 flags;
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
-	s32 rssi_thold;
+	s32 min_rssi_thold;
 
 	/* internal */
 	struct wiphy *wiphy;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 53e56cf..11b0aef 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2467,9 +2467,15 @@ enum nl80211_reg_rule_attr {
  * enum nl80211_sched_scan_match_attr - scheduled scan match attributes
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
- * only report BSS with matching SSID.
+ *	only report BSS with matching SSID.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI: RSSI threshold (in dBm) for reporting a
- *	BSS in scan results. Filtering is turned off if not specified.
+ *	BSS in scan results. Filtering is turned off if not specified. Note that
+ *	if this attribute is in a match set of its own, then it is treated as
+ *	the default value for all matchsets with an SSID, rather than being a
+ *	matchset of its own without an RSSI filter. This is due to problems with
+ *	how this API was implemented in the past. Also, due to the same problem,
+ *	there's no way to actually create a matchset with only an RSSI filter
+ *	(with this attribute.)
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ffbab17..cca2d77 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5495,6 +5495,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	enum ieee80211_band band;
 	size_t ie_len;
 	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
+	s32 default_match_rssi = NL80211_SCAN_RSSI_THOLD_OFF;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_start)
@@ -5529,11 +5530,36 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (n_ssids > wiphy->max_sched_scan_ssids)
 		return -EINVAL;
 
-	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH])
+	/*
+	 * First, count the number of 'real' matchsets. Due to an issue with
+	 * the old implementation, matchsets containing only the RSSI attribute
+	 * (NL80211_SCHED_SCAN_MATCH_ATTR_RSSI) are considered as the 'default'
+	 * RSSI for all matchsets, rather than their own matchset for reporting
+	 * all APs with a strong RSSI. This is needed to be compatible with
+	 * older userspace that treated a matchset with only the RSSI as the
+	 * global RSSI for all other matchsets.
+	 */
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
 		nla_for_each_nested(attr,
 				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
-				    tmp)
-			n_match_sets++;
+				    tmp) {
+			struct nlattr *rssi;
+
+			err = nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+					nla_data(attr), nla_len(attr),
+					nl80211_match_policy);
+			if (err)
+				return err;
+			/* add other standalone attributes here */
+			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID]) {
+				n_match_sets++;
+				continue;
+			}
+			rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
+			if (rssi)
+				default_match_rssi = nla_get_s32(rssi);
+		}
+	}
 
 	if (n_match_sets > wiphy->max_match_sets)
 		return -EINVAL;
@@ -5661,6 +5687,15 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 				goto out_free;
 			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
 			if (ssid) {
+				if (WARN_ON(i >= n_match_sets)) {
+					/* this indicates a programming error,
+					 * the loop above should have verified
+					 * things properly
+					 */
+					err = -EINVAL;
+					goto out_free;
+				}
+
 				if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
 					err = -EINVAL;
 					goto out_free;
@@ -5669,15 +5704,24 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 				       nla_data(ssid), nla_len(ssid));
 				request->match_sets[i].ssid.ssid_len =
 					nla_len(ssid);
+				/* special attribute - old implemenation w/a */
+				request->match_sets[i].rssi_thold =
+					default_match_rssi;
+				rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
+				if (rssi)
+					request->match_sets[i].rssi_thold =
+						nla_get_s32(rssi);
 			}
-			rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
-			if (rssi)
-				request->rssi_thold = nla_get_u32(rssi);
-			else
-				request->rssi_thold =
-						   NL80211_SCAN_RSSI_THOLD_OFF;
 			i++;
 		}
+
+		request->min_rssi_thold = INT_MAX;
+		for (i = 0; i < n_match_sets; i++)
+			request->min_rssi_thold =
+				min(request->match_sets[i].rssi_thold,
+				    request->min_rssi_thold);
+	} else {
+		request->min_rssi_thold = NL80211_SCAN_RSSI_THOLD_OFF;
 	}
 
 	if (info->attrs[NL80211_ATTR_IE]) {
-- 
1.8.5.2

