Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:35463 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209Ab2IZQ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 12:59:54 -0400
Received: by ghbz15 with SMTP id z15so90433ghb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 09:59:53 -0700 (PDT)
From: Sam Leffler <sleffler@chromium.org>
Date: Fri, 21 Sep 2012 10:52:57 -0700
Subject: [PATCH 1/3] {nl,cfg}80211: add a flags word to scan requests
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20120926165952.A54C41E0040@sleffler.sfo.corp.google.com> (sfid-20120926_185959_525154_6CE87D1D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a flags word to direct and scheduled scan requests; it will be used
for control of optional behaviours such as flushing the bss cache prior
to doing a scan.

Change-Id: Ib7478fd6eea62effc21b5fb508ec51c075956de2
Signed-off-by: Sam Leffler <sleffler@chromium.org>
---
 include/linux/nl80211.h |   14 ++++++++++++++
 include/net/cfg80211.h  |   10 ++++++++++
 net/mac80211/scan.c     |    1 +
 net/wireless/nl80211.c  |   11 +++++++++++
 4 files changed, 36 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 4584162..5f2d9ae 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1262,6 +1262,8 @@ enum nl80211_commands {
  *	was used to provide the hint. For the different types of
  *	allowed user regulatory hints see nl80211_user_reg_hint_type.
  *
+ * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1517,6 +1519,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_USER_REG_HINT_TYPE,
 
+	NL80211_ATTR_SCAN_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3045,4 +3049,14 @@ enum nl80211_probe_resp_offload_support_attr {
 	NL80211_PROBE_RESP_OFFLOAD_SUPPORT_80211U =	1<<3,
 };
 
+/**
+ * enum nl80211_scan_flags -  scan request control flags
+ *
+ * Scan request control flags are used to control the handling
+ * of NL80211_CMD_TRIGGER_SCAN and NL80211_CMD_START_SCHED_SCAN
+ * requests.
+ */
+enum nl80211_scan_flags {
+};
+
 #endif /* __LINUX_NL80211_H */
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 903683b1..aac20e3 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -992,6 +992,12 @@ struct cfg80211_ssid {
 };
 
 /**
+ * enum cfg80211_scan_flags -  scan request control flags
+ */
+enum cfg80211_scan_flags {
+};
+
+/**
  * struct cfg80211_scan_request - scan request description
  *
  * @ssids: SSIDs to scan for (active scan only)
@@ -1000,6 +1006,7 @@ struct cfg80211_ssid {
  * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @wdev: the wireless device to scan for
@@ -1012,6 +1019,7 @@ struct cfg80211_scan_request {
 	u32 n_channels;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
@@ -1044,6 +1052,7 @@ struct cfg80211_match_set {
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @match_sets: sets of parameters to be matched for a scan result
  * 	entry to be considered valid and to be passed to the host
  * 	(others are filtered out).
@@ -1061,6 +1070,7 @@ struct cfg80211_sched_scan_request {
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
 	s32 rssi_thold;
diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c4cdbde..2535418 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -462,6 +462,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 			sizeof(*local->hw_scan_req) +
 			req->n_channels * sizeof(req->channels[0]);
 		local->hw_scan_req->ie = ies;
+		local->hw_scan_req->flags = req->flags;
 
 		local->hw_scan_band = 0;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 222189b6..cbd2904 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
+	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -4337,6 +4338,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
@@ -4568,6 +4573,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
@@ -7622,6 +7631,8 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put(msg, NL80211_ATTR_IE, req->ie_len, req->ie))
 		goto nla_put_failure;
 
+	nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
-- 
1.7.7.3

