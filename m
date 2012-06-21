Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65372 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2FUSKG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 14:10:06 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <johannes@sipsolutions.net>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH v4] nl80211: specify RSSI threshold in scheduled scan
Date: Thu, 21 Jun 2012 11:09:54 -0700
Message-ID: <1340302194-3760-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120621_201012_129015_5DC57FA9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support configuring an RSSI threshold in dBm (s32) when requesting
scheduled scan, below which a BSS won't be reported by the cfg80211
driver.

Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
v2:
	naming (Kalle)
	remove WIPHY_FLAG (Kalle)
	use sched_scan_match_attr (Luca)

v3:
	nl80211 API names (Holger)
	misc. / typos (Johannes)

v4:
	Turn off filter by default with really low RSSI value (Johannes)

 include/linux/nl80211.h |    6 ++++++
 include/net/cfg80211.h  |    2 ++
 net/wireless/nl80211.c  |    9 ++++++++-
 3 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 970afdf..4f07c00 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1524,6 +1524,9 @@ enum nl80211_attrs {
 
 #define NL80211_MIN_REMAIN_ON_CHANNEL_TIME	10
 
+/* default RSSI threshold for scan results if none specified. */
+#define NL80211_SCAN_RSSI_THOLD_OFF		-300
+
 /**
  * enum nl80211_iftype - (virtual) interface types
  *
@@ -1956,6 +1959,8 @@ enum nl80211_reg_rule_attr {
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID: attribute number 0 is reserved
  * @NL80211_SCHED_SCAN_MATCH_ATTR_SSID: SSID to be used for matching,
  * only report BSS with matching SSID.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_RSSI: RSSI threshold (in dBm) for reporting a
+ *	BSS in scan results. Filtering is turned off if not specified.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -1964,6 +1969,7 @@ enum nl80211_sched_scan_match_attr {
 	__NL80211_SCHED_SCAN_MATCH_ATTR_INVALID,
 
 	NL80211_ATTR_SCHED_SCAN_MATCH_SSID,
+	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 7319f25..55a9d24 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -975,6 +975,7 @@ struct cfg80211_match_set {
  * @wiphy: the wiphy this was for
  * @dev: the interface
  * @channels: channels to scan
+ * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
  */
 struct cfg80211_sched_scan_request {
 	struct cfg80211_ssid *ssids;
@@ -985,6 +986,7 @@ struct cfg80211_sched_scan_request {
 	size_t ie_len;
 	struct cfg80211_match_set *match_sets;
 	int n_match_sets;
+	s32 rssi_thold;
 
 	/* internal */
 	struct wiphy *wiphy;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7ae54b8..284758b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -252,6 +252,7 @@ static const struct nla_policy
 nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 	[NL80211_ATTR_SCHED_SCAN_MATCH_SSID] = { .type = NLA_BINARY,
 						 .len = IEEE80211_MAX_SSID_LEN },
+	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
 };
 
 /* ifidx get helper */
@@ -4241,7 +4242,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 		nla_for_each_nested(attr,
 				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
 				    tmp) {
-			struct nlattr *ssid;
+			struct nlattr *ssid, *rssi;
 
 			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
 				  nla_data(attr), nla_len(attr),
@@ -4257,6 +4258,12 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 				request->match_sets[i].ssid.ssid_len =
 					nla_len(ssid);
 			}
+			rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
+			if (rssi)
+				request->rssi_thold = nla_get_u32(rssi);
+			else
+				request->rssi_thold =
+						   NL80211_SCAN_RSSI_THOLD_OFF;
 			i++;
 		}
 	}
-- 
1.7.4.1

