Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:55413 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755428Ab1HaNB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 09:01:58 -0400
Received: by mail-ey0-f176.google.com with SMTP id 10so633888eyz.35
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 06:01:56 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] nl80211/cfg80211: add match filtering for sched_scan
Date: Wed, 31 Aug 2011 16:01:48 +0300
Message-Id: <1314795708-8010-1-git-send-email-coelho@ti.com> (sfid-20110831_150202_010727_5E4CB887)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce filtering for scheduled scans to reduce the number of
unnecessary results (which cause useless wake-ups).

Add a new nested attribute where sets of parameters to be matched can
be passed when starting a scheduled scan.  Only scan results that
match any of the sets will be returned.

At this point, the set consists of a single parameter, an SSID.  This
can be easily extended in the future to support more complex matches.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---

This replaces "nl80211/cfg80211: add ssid filtering for sched_scan".
The commit has been renamed to better reflect the new logic.

Changes in v2:
	* changed the concept to use match sets instead of different
	types of filters (as discussed in v1);


 include/linux/nl80211.h |   43 ++++++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |   20 ++++++++++++++++
 net/wireless/nl80211.c  |   59 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 121 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3769303..4267f7b 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -769,6 +769,8 @@ enum nl80211_commands {
  *	that can be added to a scan request
  * @NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN: maximum length of information
  *	elements that can be added to a scheduled scan request
+ * @NL80211_ATTR_MAX_MATCH_SETS: maximum number of sets that can be
+ *	used with @NL80211_ATTR_SCHED_SCAN_MATCH, a wiphy attribute.
  *
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
@@ -1011,6 +1013,24 @@ enum nl80211_commands {
 
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
+
+ * @NL80211_ATTR_SCHED_SCAN_MATCH: Nested attribute with one or more
+ *	sets of attributes to match during scheduled scans.  Only BSSs
+ *	that match any of the sets will be reported.  These are
+ *	pass-thru filter rules.
+ *	For a match to succeed, the BSS must match all attributes of a
+ *	set.  Since not every hardware supports matching all types of
+ *	attributes, there is no guarantee that the reported BSSs are
+ *	fully complying with the match sets and userspace needs to be
+ *	able to ignore them by itself.
+ *	Thus, the implementation is somewhat hardware-dependent, but
+ *	this is only an optimization and the userspace application
+ *	needs to handle all the non-filtered results anyway.
+ *	If the match attributes don't make sense when combined with
+ *	the values passed in @NL80211_ATTR_SCAN_SSIDS (eg. if an SSID
+ *	is included in the probe request, but the match attributes
+ *	will never let it go through), -EINVAL may be returned.
+ *	If ommited, no filtering is done.
  *
  * @NL80211_ATTR_INTERFACE_COMBINATIONS: Nested attribute listing the supported
  *	interface combinations. In each nested item, it contains attributes
@@ -1252,6 +1272,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_SCHED_SCAN_MATCH,
+	NL80211_ATTR_MAX_MATCH_SETS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1711,6 +1734,26 @@ enum nl80211_reg_rule_attr {
 };
 
 /**
+ * enum nl80211_sched_scan_match_attr - scheduled scan match attributes
+ * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
+ * only report BSS with matching SSID.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
+ *	attribute number currently defined
+ * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_sched_scan_match_attr {
+	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
+
+	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+
+	/* keep last */
+	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
+	NL80211_SCHED_SCAN_MATCH_ATTR_MAX =
+		__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
  * @NL80211_RRF_NO_OFDM: OFDM modulation not allowed
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a37f264..df8d76a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -874,6 +874,15 @@ struct cfg80211_scan_request {
 };
 
 /**
+ * struct cfg80211_match_set - sets of attributes to match
+ *
+ * @ssid: SSID to be matched
+ */
+struct cfg80211_match_set {
+	struct cfg80211_ssid ssid;
+};
+
+/**
  * struct cfg80211_sched_scan_request - scheduled scan request description
  *
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
@@ -882,6 +891,11 @@ struct cfg80211_scan_request {
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @match_sets: sets of parameters to be matched for a scan result
+ * 	entry to be considered valid and to be passed to the host
+ * 	(others are filtered out).
+ *	If ommited, all results are passed.
+ * @n_match_sets: number of match sets
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @channels: channels to scan
@@ -893,6 +907,8 @@ struct cfg80211_sched_scan_request {
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
+	struct cfg80211_match_set *match_sets;
+	int n_match_sets;
 
 	/* internal */
 	struct wiphy *wiphy;
@@ -1806,6 +1822,9 @@ struct wiphy_wowlan_support {
  *	any given scan
  * @max_sched_scan_ssids: maximum number of SSIDs the device can scan
  *	for in any given scheduled scan
+ * @max_match_sets: maximum number of match sets the device can handle
+ *	when performing a scheduled scan, 0 if filtering is not
+ *	supported.
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
@@ -1863,6 +1882,7 @@ struct wiphy {
 	int bss_priv_size;
 	u8 max_scan_ssids;
 	u8 max_sched_scan_ssids;
+	u8 max_match_sets;
 	u16 max_scan_ie_len;
 	u16 max_sched_scan_ie_len;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57ecfa4..9c69afd 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_SCHED_SCAN_MATCH] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -231,6 +232,12 @@ nl80211_rekey_policy[NUM_NL80211_REKEY_DATA] = {
 	[NL80211_REKEY_DATA_REPLAY_CTR] = { .len = NL80211_REPLAY_CTR_LEN },
 };
 
+static const struct nla_policy
+nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
+	[NL80211_ATTR_SCHED_SCAN_MATCH_SSID] = { .type = NLA_BINARY,
+						 .len = IEEE80211_MAX_SSID_LEN },
+};
+
 /* ifidx get helper */
 static int nl80211_get_ifidx(struct netlink_callback *cb)
 {
@@ -714,6 +721,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.max_scan_ie_len);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
 		    dev->wiphy.max_sched_scan_ie_len);
+	NLA_PUT_U8(msg, NL80211_ATTR_MAX_MATCH_SETS,
+		   dev->wiphy.max_match_sets);
 
 	if (dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
@@ -3598,10 +3607,11 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct nlattr *attr;
 	struct wiphy *wiphy;
-	int err, tmp, n_ssids = 0, n_channels, i;
+	int err, tmp, n_ssids = 0, n_match_sets = 0, n_channels, i;
 	u32 interval;
 	enum ieee80211_band band;
 	size_t ie_len;
+	struct nlattr *tb[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1];
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_start)
@@ -3640,6 +3650,15 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (n_ssids > wiphy->max_sched_scan_ssids)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH])
+		nla_for_each_nested(attr,
+				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
+				    tmp)
+			n_match_sets++;
+
+	if (n_match_sets > wiphy->max_match_sets)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	else
@@ -3657,6 +3676,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
+			+ sizeof(*request->match_sets) * n_match_sets
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request) {
@@ -3674,6 +3694,18 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 			request->ie = (void *)(request->channels + n_channels);
 	}
 
+	if (n_match_sets) {
+		if (request->ie)
+			request->match_sets = (void *)(request->ie + ie_len);
+		else if (request->ssids)
+			request->match_sets =
+				(void *)(request->ssids + n_ssids);
+		else
+			request->match_sets =
+				(void *)(request->channels + n_channels);
+	}
+	request->n_match_sets = n_match_sets;
+
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		/* user specified, bail out if channel not found */
@@ -3738,6 +3770,31 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		}
 	}
 
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH]) {
+		nla_for_each_nested(attr,
+				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
+				    tmp) {
+			struct nlattr *ssid;
+
+			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+				  nla_data(attr), nla_len(attr),
+				  nl80211_match_policy);
+			ssid = tb[NL80211_ATTR_SCHED_SCAN_MATCH_SSID];
+			if (ssid) {
+				if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
+					err = -EINVAL;
+					goto out_free;
+				}
+				memcpy(request->match_sets[i].ssid.ssid,
+				       nla_data(ssid), nla_len(ssid));
+				request->match_sets[i].ssid.ssid_len =
+					nla_len(ssid);
+			}
+			i++;
+		}
+	}
+
 	if (info->attrs[NL80211_ATTR_IE]) {
 		request->ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 		memcpy((void *)request->ie,
-- 
1.7.1

