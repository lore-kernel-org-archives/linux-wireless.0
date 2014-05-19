Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33945 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaESQHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2014 12:07:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: constify wowlan/coalesce mask/pattern pointers
Date: Mon, 19 May 2014 18:07:08 +0200
Message-Id: <1400515628-10107-1-git-send-email-johannes@sipsolutions.net> (sfid-20140519_180722_070674_DF1D5264)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This requires changing the nl80211 parsing code a bit to use
intermediate pointers for the allocation, but clarifies the
API towards the drivers.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |  2 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h |  4 ++--
 include/net/cfg80211.h                    |  2 +-
 net/wireless/nl80211.c                    | 39 +++++++++++++++++--------------
 4 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 077eb5b9cd74..02c91d6db753 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1416,7 +1416,7 @@ void wl1271_rx_filter_free(struct wl12xx_rx_filter *filter)
 
 int wl1271_rx_filter_alloc_field(struct wl12xx_rx_filter *filter,
 				 u16 offset, u8 flags,
-				 u8 *pattern, u8 len)
+				 const u8 *pattern, u8 len)
 {
 	struct wl12xx_rx_filter_field *field;
 
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 756e890bc5ee..c2c34a84ff3d 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -512,8 +512,8 @@ int wl1271_recalc_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 void wl12xx_queue_recovery_work(struct wl1271 *wl);
 size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 int wl1271_rx_filter_alloc_field(struct wl12xx_rx_filter *filter,
-					u16 offset, u8 flags,
-					u8 *pattern, u8 len);
+				 u16 offset, u8 flags,
+				 const u8 *pattern, u8 len);
 void wl1271_rx_filter_free(struct wl12xx_rx_filter *filter);
 struct wl12xx_rx_filter *wl1271_rx_filter_alloc(void);
 int wl1271_rx_filter_get_fields_size(struct wl12xx_rx_filter *filter);
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3299d1b731ef..fe4fa287f788 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1827,7 +1827,7 @@ struct cfg80211_pmksa {
  * memory, free @mask only!
  */
 struct cfg80211_pkt_pattern {
-	u8 *mask, *pattern;
+	const u8 *mask, *pattern;
 	int pattern_len;
 	int pkt_offset;
 };
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ca19b1520389..49adf58646e6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -8554,6 +8554,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 
 		nla_for_each_nested(pat, tb[NL80211_WOWLAN_TRIG_PKT_PATTERN],
 				    rem) {
+			u8 *mask_pat;
+
 			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
 				  nla_len(pat), NULL);
 			err = -EINVAL;
@@ -8577,19 +8579,18 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 				goto error;
 			new_triggers.patterns[i].pkt_offset = pkt_offset;
 
-			new_triggers.patterns[i].mask =
-				kmalloc(mask_len + pat_len, GFP_KERNEL);
-			if (!new_triggers.patterns[i].mask) {
+			mask_pat = kmalloc(mask_len + pat_len, GFP_KERNEL);
+			if (!mask_pat) {
 				err = -ENOMEM;
 				goto error;
 			}
-			new_triggers.patterns[i].pattern =
-				new_triggers.patterns[i].mask + mask_len;
-			memcpy(new_triggers.patterns[i].mask,
-			       nla_data(pat_tb[NL80211_PKTPAT_MASK]),
+			new_triggers.patterns[i].mask = mask_pat;
+			memcpy(mask_pat, nla_data(pat_tb[NL80211_PKTPAT_MASK]),
 			       mask_len);
+			mask_pat += mask_len;
+			new_triggers.patterns[i].pattern = mask_pat;
 			new_triggers.patterns[i].pattern_len = pat_len;
-			memcpy(new_triggers.patterns[i].pattern,
+			memcpy(mask_pat,
 			       nla_data(pat_tb[NL80211_PKTPAT_PATTERN]),
 			       pat_len);
 			i++;
@@ -8781,6 +8782,8 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 
 	nla_for_each_nested(pat, tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
 			    rem) {
+		u8 *mask_pat;
+
 		nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
 			  nla_len(pat), NULL);
 		if (!pat_tb[NL80211_PKTPAT_MASK] ||
@@ -8802,17 +8805,19 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 		new_rule->patterns[i].pkt_offset = pkt_offset;
 
-		new_rule->patterns[i].mask =
-			kmalloc(mask_len + pat_len, GFP_KERNEL);
-		if (!new_rule->patterns[i].mask)
+		mask_pat = kmalloc(mask_len + pat_len, GFP_KERNEL);
+		if (!mask_pat)
 			return -ENOMEM;
-		new_rule->patterns[i].pattern =
-			new_rule->patterns[i].mask + mask_len;
-		memcpy(new_rule->patterns[i].mask,
-		       nla_data(pat_tb[NL80211_PKTPAT_MASK]), mask_len);
+
+		new_rule->patterns[i].mask = mask_pat;
+		memcpy(mask_pat, nla_data(pat_tb[NL80211_PKTPAT_MASK]),
+		       mask_len);
+
+		mask_pat += mask_len;
+		new_rule->patterns[i].pattern = mask_pat;
 		new_rule->patterns[i].pattern_len = pat_len;
-		memcpy(new_rule->patterns[i].pattern,
-		       nla_data(pat_tb[NL80211_PKTPAT_PATTERN]), pat_len);
+		memcpy(mask_pat, nla_data(pat_tb[NL80211_PKTPAT_PATTERN]),
+		       pat_len);
 		i++;
 	}
 
-- 
2.0.0.rc0

