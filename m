Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33730 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752547AbeF2Hdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:33:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: check nla_parse_nested() return values
Date: Fri, 29 Jun 2018 09:33:39 +0200
Message-Id: <20180629073339.11625-1-johannes@sipsolutions.net> (sfid-20180629_093348_347293_D095258B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

At the very least we should check the return value if
nla_parse_nested() is called with a non-NULL policy.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 07514ca011b2..d406e5165778 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10962,9 +10962,12 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 				    rem) {
 			u8 *mask_pat;
 
-			nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
-					 nl80211_packet_pattern_policy,
-					 info->extack);
+			err = nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
+					       nl80211_packet_pattern_policy,
+					       info->extack);
+			if (err)
+				goto error;
+
 			err = -EINVAL;
 			if (!pat_tb[NL80211_PKTPAT_MASK] ||
 			    !pat_tb[NL80211_PKTPAT_PATTERN])
@@ -11213,8 +11216,11 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 			    rem) {
 		u8 *mask_pat;
 
-		nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
-				 nl80211_packet_pattern_policy, NULL);
+		err = nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
+				       nl80211_packet_pattern_policy, NULL);
+		if (err)
+			return err;
+
 		if (!pat_tb[NL80211_PKTPAT_MASK] ||
 		    !pat_tb[NL80211_PKTPAT_PATTERN])
 			return -EINVAL;
-- 
2.14.4
