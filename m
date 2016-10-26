Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52076 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935357AbcJZMpm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 08:45:42 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: use nla_parse_nested() instead of nla_parse()
Date: Wed, 26 Oct 2016 14:45:38 +0200
Message-Id: <1477485938-307-1-git-send-email-johannes@sipsolutions.net> (sfid-20161026_144549_760393_43B2FCBA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It's just an inline doing the same thing, but the code
is nicer with it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 85 ++++++++++++++++++++++----------------------------
 1 file changed, 37 insertions(+), 48 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b0440de82171..ad49a4c43e01 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2318,10 +2318,9 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
-			result = nla_parse(tb, NL80211_TXQ_ATTR_MAX,
-					   nla_data(nl_txq_params),
-					   nla_len(nl_txq_params),
-					   txq_params_policy);
+			result = nla_parse_nested(tb, NL80211_TXQ_ATTR_MAX,
+						  nl_txq_params,
+						  txq_params_policy);
 			if (result)
 				return result;
 			result = parse_txq_params(tb, &txq_params);
@@ -3571,8 +3570,8 @@ static int nl80211_parse_tx_bitrate_mask(struct genl_info *info,
 		sband = rdev->wiphy.bands[band];
 		if (sband == NULL)
 			return -EINVAL;
-		err = nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
-				nla_len(tx_rates), nl80211_txattr_policy);
+		err = nla_parse_nested(tb, NL80211_TXRATE_MAX, tx_rates,
+				       nl80211_txattr_policy);
 		if (err)
 			return err;
 		if (tb[NL80211_TXRATE_LEGACY]) {
@@ -6328,9 +6327,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			    rem_reg_rules) {
-		r = nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
-			      nla_data(nl_reg_rule), nla_len(nl_reg_rule),
-			      reg_rule_policy);
+		r = nla_parse_nested(tb, NL80211_REG_RULE_ATTR_MAX,
+				     nl_reg_rule, reg_rule_policy);
 		if (r)
 			goto bad_reg;
 		r = parse_reg_rule(tb, &rd->reg_rules[rule_idx]);
@@ -6397,8 +6395,8 @@ static int parse_bss_select(struct nlattr *nla, struct wiphy *wiphy,
 	if (!nla_ok(nest, nla_len(nest)))
 		return -EINVAL;
 
-	err = nla_parse(attr, NL80211_BSS_SELECT_ATTR_MAX, nla_data(nest),
-			nla_len(nest), nl80211_bss_select_policy);
+	err = nla_parse_nested(attr, NL80211_BSS_SELECT_ATTR_MAX, nest,
+			       nl80211_bss_select_policy);
 	if (err)
 		return err;
 
@@ -6788,9 +6786,8 @@ nl80211_parse_sched_scan_plans(struct wiphy *wiphy, int n_plans,
 		if (WARN_ON(i >= n_plans))
 			return -EINVAL;
 
-		err = nla_parse(plan, NL80211_SCHED_SCAN_PLAN_MAX,
-				nla_data(attr), nla_len(attr),
-				nl80211_plan_policy);
+		err = nla_parse_nested(plan, NL80211_SCHED_SCAN_PLAN_MAX,
+				       attr, nl80211_plan_policy);
 		if (err)
 			return err;
 
@@ -6879,9 +6876,9 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				    tmp) {
 			struct nlattr *rssi;
 
-			err = nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
-					nla_data(attr), nla_len(attr),
-					nl80211_match_policy);
+			err = nla_parse_nested(tb,
+					       NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+					       attr, nl80211_match_policy);
 			if (err)
 				return ERR_PTR(err);
 			/* add other standalone attributes here */
@@ -7052,9 +7049,9 @@ nl80211_parse_sched_scan(struct wiphy *wiphy, struct wireless_dev *wdev,
 				    tmp) {
 			struct nlattr *ssid, *rssi;
 
-			err = nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
-					nla_data(attr), nla_len(attr),
-					nl80211_match_policy);
+			err = nla_parse_nested(tb,
+					       NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+					       attr, nl80211_match_policy);
 			if (err)
 				goto out_free;
 			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
@@ -9754,9 +9751,8 @@ static int nl80211_parse_wowlan_tcp(struct cfg80211_registered_device *rdev,
 	if (!rdev->wiphy.wowlan->tcp)
 		return -EINVAL;
 
-	err = nla_parse(tb, MAX_NL80211_WOWLAN_TCP,
-			nla_data(attr), nla_len(attr),
-			nl80211_wowlan_tcp_policy);
+	err = nla_parse_nested(tb, MAX_NL80211_WOWLAN_TCP, attr,
+			       nl80211_wowlan_tcp_policy);
 	if (err)
 		return err;
 
@@ -9901,9 +9897,7 @@ static int nl80211_parse_wowlan_nd(struct cfg80211_registered_device *rdev,
 		goto out;
 	}
 
-	err = nla_parse(tb, NL80211_ATTR_MAX,
-			nla_data(attr), nla_len(attr),
-			nl80211_policy);
+	err = nla_parse_nested(tb, NL80211_ATTR_MAX, attr, nl80211_policy);
 	if (err)
 		goto out;
 
@@ -9937,10 +9931,9 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 		goto set_wakeup;
 	}
 
-	err = nla_parse(tb, MAX_NL80211_WOWLAN_TRIG,
-			nla_data(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
-			nla_len(info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS]),
-			nl80211_wowlan_policy);
+	err = nla_parse_nested(tb, MAX_NL80211_WOWLAN_TRIG,
+			       info->attrs[NL80211_ATTR_WOWLAN_TRIGGERS],
+			       nl80211_wowlan_policy);
 	if (err)
 		return err;
 
@@ -10022,8 +10015,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 				    rem) {
 			u8 *mask_pat;
 
-			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
-				  nla_len(pat), NULL);
+			nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
+					 NULL);
 			err = -EINVAL;
 			if (!pat_tb[NL80211_PKTPAT_MASK] ||
 			    !pat_tb[NL80211_PKTPAT_PATTERN])
@@ -10233,8 +10226,8 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 	int rem, pat_len, mask_len, pkt_offset, n_patterns = 0;
 	struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
 
-	err = nla_parse(tb, NL80211_ATTR_COALESCE_RULE_MAX, nla_data(rule),
-			nla_len(rule), nl80211_coalesce_policy);
+	err = nla_parse_nested(tb, NL80211_ATTR_COALESCE_RULE_MAX, rule,
+			       nl80211_coalesce_policy);
 	if (err)
 		return err;
 
@@ -10272,8 +10265,7 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 			    rem) {
 		u8 *mask_pat;
 
-		nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
-			  nla_len(pat), NULL);
+		nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat, NULL);
 		if (!pat_tb[NL80211_PKTPAT_MASK] ||
 		    !pat_tb[NL80211_PKTPAT_PATTERN])
 			return -EINVAL;
@@ -10392,10 +10384,9 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 	if (!info->attrs[NL80211_ATTR_REKEY_DATA])
 		return -EINVAL;
 
-	err = nla_parse(tb, MAX_NL80211_REKEY_DATA,
-			nla_data(info->attrs[NL80211_ATTR_REKEY_DATA]),
-			nla_len(info->attrs[NL80211_ATTR_REKEY_DATA]),
-			nl80211_rekey_policy);
+	err = nla_parse_nested(tb, MAX_NL80211_REKEY_DATA,
+			       info->attrs[NL80211_ATTR_REKEY_DATA],
+			       nl80211_rekey_policy);
 	if (err)
 		return err;
 
@@ -10704,10 +10695,9 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	    wdev->owner_nlportid != info->snd_portid)
 		return -ENOTCONN;
 
-	err = nla_parse(tb, NL80211_NAN_FUNC_ATTR_MAX,
-			nla_data(info->attrs[NL80211_ATTR_NAN_FUNC]),
-			nla_len(info->attrs[NL80211_ATTR_NAN_FUNC]),
-			nl80211_nan_func_policy);
+	err = nla_parse_nested(tb, NL80211_NAN_FUNC_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_NAN_FUNC],
+			       nl80211_nan_func_policy);
 	if (err)
 		return err;
 
@@ -10802,10 +10792,9 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
 	if (tb[NL80211_NAN_FUNC_SRF]) {
 		struct nlattr *srf_tb[NUM_NL80211_NAN_SRF_ATTR];
 
-		err = nla_parse(srf_tb, NL80211_NAN_SRF_ATTR_MAX,
-				nla_data(tb[NL80211_NAN_FUNC_SRF]),
-				nla_len(tb[NL80211_NAN_FUNC_SRF]),
-				nl80211_nan_srf_policy);
+		err = nla_parse_nested(srf_tb, NL80211_NAN_SRF_ATTR_MAX,
+				       tb[NL80211_NAN_FUNC_SRF],
+				       nl80211_nan_srf_policy);
 		if (err)
 			goto out;
 
-- 
2.8.1
