Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:52375 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab1H3Mjx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 08:39:53 -0400
Received: by mail-bw0-f46.google.com with SMTP id 11so5004703bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Aug 2011 05:39:52 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: [PATCH] nl80211/cfg80211: add ssid filtering for sched_scan
Date: Tue, 30 Aug 2011 15:39:39 +0300
Message-Id: <1314707979-26484-1-git-send-email-coelho@ti.com> (sfid-20110830_143957_538366_7089A33D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce filtering for scheduled scans to reduce the number of
unnecessary results (which cause useless wake-ups).

This commit adds a new nested attribute for passing generic filters in
scheduled scan requests.  It also adds an implementation for filtering
based on a list of SSIDs.  In the future, more types of filters will
be added.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 include/linux/nl80211.h |   33 ++++++++++++++++++++++++++++++++
 include/net/cfg80211.h  |    8 +++++++
 net/wireless/nl80211.c  |   48 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 87 insertions(+), 2 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 3769303..7d4edb8 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -769,6 +769,8 @@ enum nl80211_commands {
  *	that can be added to a scan request
  * @NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN: maximum length of information
  *	elements that can be added to a scheduled scan request
+ * @NL80211_ATTR_MAX_FILTER_SSIDS: number of SSIDs you can use as
+ *	filters in a scheduled scan request, a wiphy attribute.
  *
  * @NL80211_ATTR_SCAN_FREQUENCIES: nested attribute with frequencies (in MHz)
  * @NL80211_ATTR_SCAN_SSIDS: nested attribute with SSIDs, leave out for passive
@@ -1011,6 +1013,13 @@ enum nl80211_commands {
 
  * @NL80211_ATTR_SCHED_SCAN_INTERVAL: Interval between scheduled scan
  *	cycles, in msecs.
+ * @NL80211_ATTR_SCHED_SCAN_FILTER: Nested attribute with various
+ *	types of filtering to be used with scheduled scans.
+ *	If @NL80211_ATTR_SCAN_SSIDS is passed with values that are not
+ *	included in the filter, the driver may return -EINVAL, since
+ *	it doesn't make sense to send probe requests with SSIDs that
+ *	will be filtered out.  This doesn't apply to the wildcard SSID.
+ *	If ommited, no filtering is done.
  *
  * @NL80211_ATTR_INTERFACE_COMBINATIONS: Nested attribute listing the supported
  *	interface combinations. In each nested item, it contains attributes
@@ -1252,6 +1261,9 @@ enum nl80211_attrs {
 	NL80211_ATTR_IE_PROBE_RESP,
 	NL80211_ATTR_IE_ASSOC_RESP,
 
+	NL80211_ATTR_SCHED_SCAN_FILTER,
+	NL80211_ATTR_MAX_FILTER_SSIDS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -1711,6 +1723,27 @@ enum nl80211_reg_rule_attr {
 };
 
 /**
+ * enum nl80211_sched_scan_filter_attr - scheduled scan filter attributes
+ * @__NL80211_SCHED_SCAN_FILTER_ATTR_INVALID: attribute number 0 is reserved
+ * @NL80211_SCHED_SCAN_FILTER_SSID: A list of SSIDs to be automatically
+ *	filtered by the hardware and passed up to the host.  SSIDs that are
+ *	not present in this list are ignored (without waking up the host).
+ * @NL80211_SCHED_SCAN_FILTER_ATTR_MAX: highest scheduled scan filter
+ *	attribute number currently defined
+ * @__NL80211_SCHED_SCAN_FILTER_ATTR_AFTER_LAST: internal use
+ */
+enum nl80211_sched_scan_filter_attr {
+	__NL80211_SCHED_SCAN_FILTER_ATTR_INVALID,
+
+	NL80211_ATTR_SCHED_SCAN_FILTER_SSID,
+
+	/* keep last */
+	__NL80211_SCHED_SCAN_FILTER_ATTR_AFTER_LAST,
+	NL80211_SCHED_SCAN_FILTER_ATTR_MAX =
+		__NL80211_SCHED_SCAN_FILTER_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_reg_rule_flags - regulatory rule flags
  *
  * @NL80211_RRF_NO_OFDM: OFDM modulation not allowed
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a37f264..a3e58ff 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -882,6 +882,9 @@ struct cfg80211_scan_request {
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @filter_ssids: SSIDs to pass to the host (others are filtered out).
+ * 	If ommited, no filtering is done.
+ * @n_filter_ssids: number of filter SSIDs
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @channels: channels to scan
@@ -893,6 +896,8 @@ struct cfg80211_sched_scan_request {
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
+	struct cfg80211_ssid *filter_ssids;
+	int n_filter_ssids;
 
 	/* internal */
 	struct wiphy *wiphy;
@@ -1806,6 +1811,8 @@ struct wiphy_wowlan_support {
  *	any given scan
  * @max_sched_scan_ssids: maximum number of SSIDs the device can scan
  *	for in any given scheduled scan
+ * @max_filter_ssids: maximum number of SSIDs the device can filter when
+ *	performing a scheduled scan, 0 if filtering is not supported
  * @max_scan_ie_len: maximum length of user-controlled IEs device can
  *	add to probe request frames transmitted during a scan, must not
  *	include fixed IEs like supported rates
@@ -1863,6 +1870,7 @@ struct wiphy {
 	int bss_priv_size;
 	u8 max_scan_ssids;
 	u8 max_sched_scan_ssids;
+	u8 max_filter_ssids;
 	u16 max_scan_ie_len;
 	u16 max_sched_scan_ie_len;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 57ecfa4..cd46a07 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -189,6 +189,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 					 .len = IEEE80211_MAX_DATA_LEN },
 	[NL80211_ATTR_IE_ASSOC_RESP] = { .type = NLA_BINARY,
 					 .len = IEEE80211_MAX_DATA_LEN },
+	[NL80211_ATTR_SCHED_SCAN_FILTER] = { .type = NLA_NESTED },
 };
 
 /* policy for the key attributes */
@@ -714,6 +715,8 @@ static int nl80211_send_wiphy(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 		    dev->wiphy.max_scan_ie_len);
 	NLA_PUT_U16(msg, NL80211_ATTR_MAX_SCHED_SCAN_IE_LEN,
 		    dev->wiphy.max_sched_scan_ie_len);
+	NLA_PUT_U8(msg, NL80211_ATTR_MAX_FILTER_SSIDS,
+		   dev->wiphy.max_filter_ssids);
 
 	if (dev->wiphy.flags & WIPHY_FLAG_IBSS_RSN)
 		NLA_PUT_FLAG(msg, NL80211_ATTR_SUPPORT_IBSS_RSN);
@@ -3596,9 +3599,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct cfg80211_sched_scan_request *request;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net_device *dev = info->user_ptr[1];
-	struct nlattr *attr;
+	struct nlattr *attr, *attr2;
 	struct wiphy *wiphy;
-	int err, tmp, n_ssids = 0, n_channels, i;
+	int err, tmp, n_ssids = 0, n_filter_ssids = 0, n_channels, i;
 	u32 interval;
 	enum ieee80211_band band;
 	size_t ie_len;
@@ -3640,6 +3643,17 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (n_ssids > wiphy->max_sched_scan_ssids)
 		return -EINVAL;
 
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
+		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
+				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
+		if (attr)
+			nla_for_each_nested(attr2, attr, tmp)
+				n_filter_ssids++;
+	}
+
+	if (n_filter_ssids > wiphy->max_filter_ssids)
+		return -EINVAL;
+
 	if (info->attrs[NL80211_ATTR_IE])
 		ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 	else
@@ -3657,6 +3671,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	request = kzalloc(sizeof(*request)
 			+ sizeof(*request->ssids) * n_ssids
+			+ sizeof(*request->filter_ssids) * n_filter_ssids
 			+ sizeof(*request->channels) * n_channels
 			+ ie_len, GFP_KERNEL);
 	if (!request) {
@@ -3674,6 +3689,17 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 			request->ie = (void *)(request->channels + n_channels);
 	}
 
+	if (n_filter_ssids) {
+		if (request->ie)
+			request->filter_ssids = (void *)(request->ie + ie_len);
+		else if (request->ssids)
+			request->filter_ssids =
+				(void *)(request->ssids + n_ssids);
+		else
+			request->filter_ssids =
+				(void *)(request->channels + n_channels);
+	}
+
 	i = 0;
 	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
 		/* user specified, bail out if channel not found */
@@ -3738,6 +3764,24 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		}
 	}
 
+	i = 0;
+	if (info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER]) {
+		struct nlattr *attr2;
+		attr = nla_find_nested(info->attrs[NL80211_ATTR_SCHED_SCAN_FILTER],
+				       NL80211_ATTR_SCHED_SCAN_FILTER_SSID);
+		if (attr)
+			nla_for_each_nested(attr2, attr, tmp) {
+				if (nla_len(attr2) > IEEE80211_MAX_SSID_LEN) {
+					err = -EINVAL;
+					goto out_free;
+				}
+				memcpy(request->filter_ssids[i].ssid, nla_data(attr2),
+				       nla_len(attr2));
+				request->filter_ssids[i].ssid_len = nla_len(attr2);
+				i++;
+			}
+	}
+
 	if (info->attrs[NL80211_ATTR_IE]) {
 		request->ie_len = nla_len(info->attrs[NL80211_ATTR_IE]);
 		memcpy((void *)request->ie,
-- 
1.7.1

