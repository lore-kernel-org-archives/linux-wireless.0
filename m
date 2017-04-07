Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:58611 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756340AbdDGJX0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Apr 2017 05:23:26 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 03/10] nl80211: add support for BSSIDs in scheduled scan matchsets
Date: Fri,  7 Apr 2017 10:23:03 +0100
Message-Id: <1491556990-25143-4-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170407_112338_398265_1DE9773F)
In-Reply-To: <1491556990-25143-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1491556990-25143-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows for the scheduled scan request to specify matchsets
for specific BSSIDs.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       |  6 +++++-
 include/uapi/linux/nl80211.h |  2 ++
 net/wireless/nl80211.c       | 41 +++++++++++++++++++++++++++++++----------
 3 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 4d9d49a..0736aea 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1605,11 +1605,15 @@ static inline void get_random_mask_addr(u8 *buf, const u8 *addr, const u8 *mask)
 /**
  * struct cfg80211_match_set - sets of attributes to match
  *
- * @ssid: SSID to be matched; may be zero-length for no match (RSSI only)
+ * @ssid: SSID to be matched; may be zero-length in case of BSSID match
+ *	or no match (RSSI only)
+ * @bssid: BSSID to be matched; may be all-zero BSSID in case of SSID match
+ *	or no match (RSSI only)
  * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
  */
 struct cfg80211_match_set {
 	struct cfg80211_ssid ssid;
+	u8 bssid[ETH_ALEN];
 	s32 rssi_thold;
 };
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f34127d..925eb38 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -3209,6 +3209,7 @@ enum nl80211_reg_rule_attr {
  *	BSS-es in the specified band is to be adjusted before doing
  *	RSSI-based BSS selection. The attribute value is a packed structure
  *	value as specified by &struct nl80211_bss_select_rssi_adjust.
+ * @NL80211_SCHED_SCAN_MATCH_ATTR_BSSID: BSSID to be used for matching.
  * @NL80211_SCHED_SCAN_MATCH_ATTR_MAX: highest scheduled scan filter
  *	attribute number currently defined
  * @__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST: internal use
@@ -3220,6 +3221,7 @@ enum nl80211_sched_scan_match_attr {
 	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI,
 	NL80211_SCHED_SCAN_MATCH_ATTR_RELATIVE_RSSI,
 	NL80211_SCHED_SCAN_MATCH_ATTR_RSSI_ADJUST,
+	NL80211_SCHED_SCAN_MATCH_ATTR_BSSID,
 
 	/* keep last */
 	__NL80211_SCHED_SCAN_MATCH_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2150cfe..611d92c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -497,6 +497,8 @@ enum nl80211_multicast_groups {
 nl80211_match_policy[NL80211_SCHED_SCAN_MATCH_ATTR_MAX + 1] = {
 	[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] = { .type = NLA_BINARY,
 						 .len = IEEE80211_MAX_SSID_LEN },
+	[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID] = { .type = NLA_BINARY,
+						  .len = ETH_ALEN },
 	[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI] = { .type = NLA_U32 },
 };
 
@@ -7027,8 +7029,15 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 					       attr, nl80211_match_policy);
 			if (err)
 				return ERR_PTR(err);
+
+			/* SSID and BSSID are mutually exclusive */
+			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] &&
+			    tb[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID])
+				return ERR_PTR(-EINVAL);
+
 			/* add other standalone attributes here */
-			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID]) {
+			if (tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID] ||
+			    tb[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID]) {
 				n_match_sets++;
 				continue;
 			}
@@ -7199,7 +7208,7 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(attr,
 				    attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
 				    tmp) {
-			struct nlattr *ssid, *rssi;
+			struct nlattr *ssid, *bssid, *rssi;
 
 			err = nla_parse_nested(tb,
 					       NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
@@ -7207,7 +7216,8 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 			if (err)
 				goto out_free;
 			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
-			if (ssid) {
+			bssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_BSSID];
+			if (ssid || bssid) {
 				if (WARN_ON(i >= n_match_sets)) {
 					/* this indicates a programming error,
 					 * the loop above should have verified
@@ -7217,14 +7227,25 @@ static int nl80211_abort_scan(struct sk_buff *skb, struct genl_info *info)
 					goto out_free;
 				}
 
-				if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
-					err = -EINVAL;
-					goto out_free;
+				if (ssid) {
+					if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
+						err = -EINVAL;
+						goto out_free;
+					}
+					memcpy(request->match_sets[i].ssid.ssid,
+					       nla_data(ssid), nla_len(ssid));
+					request->match_sets[i].ssid.ssid_len =
+						nla_len(ssid);
+				}
+				if (bssid) {
+					if (nla_len(bssid) != ETH_ALEN) {
+						err = -EINVAL;
+						goto out_free;
+					}
+					memcpy(request->match_sets[i].bssid,
+					       nla_data(bssid), ETH_ALEN);
 				}
-				memcpy(request->match_sets[i].ssid.ssid,
-				       nla_data(ssid), nla_len(ssid));
-				request->match_sets[i].ssid.ssid_len =
-					nla_len(ssid);
+
 				/* special attribute - old implementation w/a */
 				request->match_sets[i].rssi_thold =
 					default_match_rssi;
-- 
1.9.1
