Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:41514 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab2JDEsF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 00:48:05 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Sam Leffler <sleffler@chromium.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v3 1/5] {nl,cfg}80211: add a flags word to scan requests
Date: Wed,  3 Oct 2012 21:47:42 -0700
Message-Id: <1349326066-28501-2-git-send-email-bzhao@marvell.com> (sfid-20121004_064810_282423_9E8DBA24)
In-Reply-To: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
References: <1349326066-28501-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sam Leffler <sleffler@chromium.org>

Add a flags word to direct and scheduled scan requests; it will
be used for control of optional behaviours such as flushing the
bss cache prior to doing a scan.

Signed-off-by: Sam Leffler <sleffler@chromium.org>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v3: Remove unnecessary "enum cfg80211_scan_flags" and add missing
    check for "nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS...".
    (Johannes Berg)

 include/linux/nl80211.h |   14 ++++++++++++++
 include/net/cfg80211.h  |    4 ++++
 net/wireless/nl80211.c  |   12 ++++++++++++
 3 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 179a0c2..bac473a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1276,6 +1276,8 @@ enum nl80211_commands {
  * @NL80211_ATTR_SAE_DATA: SAE elements in Authentication frames. This starts
  *	with the Authentication transaction sequence number field.
  *
+ * @NL80211_ATTR_SCAN_FLAGS: scan request control flags (u32)
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1535,6 +1537,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SAE_DATA,
 
+	NL80211_ATTR_SCAN_FLAGS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3080,4 +3084,14 @@ enum nl80211_connect_failed_reason {
 	NL80211_CONN_FAIL_BLOCKED_CLIENT,
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
index 04df773..7c70e99 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1000,6 +1000,7 @@ struct cfg80211_ssid {
  * @n_channels: total number of channels to scan
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @rates: bitmap of rates to advertise for each band
  * @wiphy: the wiphy this was for
  * @wdev: the wireless device to scan for
@@ -1012,6 +1013,7 @@ struct cfg80211_scan_request {
 	u32 n_channels;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 
 	u32 rates[IEEE80211_NUM_BANDS];
 
@@ -1044,6 +1046,7 @@ struct cfg80211_match_set {
  * @interval: interval between each scheduled scan cycle
  * @ie: optional information element(s) to add into Probe Request or %NULL
  * @ie_len: length of ie in octets
+ * @flags: bit field of flags controlling operation
  * @match_sets: sets of parameters to be matched for a scan result
  * 	entry to be considered valid and to be passed to the host
  * 	(others are filtered out).
@@ -1061,6 +1064,7 @@ struct cfg80211_sched_scan_request {
 	u32 interval;
 	const u8 *ie;
 	size_t ie_len;
+	u32 flags;
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
 	s32 rssi_thold;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 746f649..714e46d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -355,6 +355,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
 	[NL80211_ATTR_USER_REG_HINT_TYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_SAE_DATA] = { .type = NLA_BINARY, },
+	[NL80211_ATTR_SCAN_FLAGS] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -4362,6 +4363,10 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->no_cck =
 		nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
@@ -4593,6 +4598,10 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		       request->ie_len);
 	}
 
+	if (info->attrs[NL80211_ATTR_SCAN_FLAGS])
+		request->flags = nla_get_u32(
+			info->attrs[NL80211_ATTR_SCAN_FLAGS]);
+
 	request->dev = dev;
 	request->wiphy = &rdev->wiphy;
 	request->interval = interval;
@@ -7658,6 +7667,9 @@ static int nl80211_add_scan_req(struct sk_buff *msg,
 	    nla_put(msg, NL80211_ATTR_IE, req->ie_len, req->ie))
 		goto nla_put_failure;
 
+	if (req->flags)
+		nla_put_u32(msg, NL80211_ATTR_SCAN_FLAGS, req->flags);
+
 	return 0;
  nla_put_failure:
 	return -ENOBUFS;
-- 
1.7.0.4

