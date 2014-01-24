Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49197 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaAXJSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 04:18:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] nl80211: check nla_parse() return values
Date: Fri, 24 Jan 2014 10:18:33 +0100
Message-Id: <1390555113-9231-1-git-send-email-johannes@sipsolutions.net> (sfid-20140124_101846_035486_1FA517D8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there's a policy, then nla_parse() return values must be
checked, otherwise the policy is useless and there's nothing
that ensures the attributes are actually what we expect them
to be.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fdd4cae..ffbab17 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2066,10 +2066,12 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		nla_for_each_nested(nl_txq_params,
 				    info->attrs[NL80211_ATTR_WIPHY_TXQ_PARAMS],
 				    rem_txq_params) {
-			nla_parse(tb, NL80211_TXQ_ATTR_MAX,
-				  nla_data(nl_txq_params),
-				  nla_len(nl_txq_params),
-				  txq_params_policy);
+			result = nla_parse(tb, NL80211_TXQ_ATTR_MAX,
+					   nla_data(nl_txq_params),
+					   nla_len(nl_txq_params),
+					   txq_params_policy);
+			if (result)
+				goto bad_res;
 			result = parse_txq_params(tb, &txq_params);
 			if (result)
 				goto bad_res;
@@ -5226,9 +5228,11 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 
 	nla_for_each_nested(nl_reg_rule, info->attrs[NL80211_ATTR_REG_RULES],
 			    rem_reg_rules) {
-		nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
-			  nla_data(nl_reg_rule), nla_len(nl_reg_rule),
-			  reg_rule_policy);
+		r = nla_parse(tb, NL80211_REG_RULE_ATTR_MAX,
+			      nla_data(nl_reg_rule), nla_len(nl_reg_rule),
+			      reg_rule_policy);
+		if (r)
+			goto bad_reg;
 		r = parse_reg_rule(tb, &rd->reg_rules[rule_idx]);
 		if (r)
 			goto bad_reg;
@@ -5650,9 +5654,11 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 				    tmp) {
 			struct nlattr *ssid, *rssi;
 
-			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
-				  nla_data(attr), nla_len(attr),
-				  nl80211_match_policy);
+			err = nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
+					nla_data(attr), nla_len(attr),
+					nl80211_match_policy);
+			if (err)
+				goto out_free;
 			ssid = tb[NL80211_SCHED_SCAN_MATCH_ATTR_SSID];
 			if (ssid) {
 				if (nla_len(ssid) > IEEE80211_MAX_SSID_LEN) {
@@ -7527,16 +7533,19 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 	 * directly to the enum ieee80211_band values used in cfg80211.
 	 */
 	BUILD_BUG_ON(NL80211_MAX_SUPP_HT_RATES > IEEE80211_HT_MCS_MASK_LEN * 8);
-	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
-	{
+	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem) {
 		enum ieee80211_band band = nla_type(tx_rates);
+		int err;
+
 		if (band < 0 || band >= IEEE80211_NUM_BANDS)
 			return -EINVAL;
 		sband = rdev->wiphy.bands[band];
 		if (sband == NULL)
 			return -EINVAL;
-		nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
-			  nla_len(tx_rates), nl80211_txattr_policy);
+		err = nla_parse(tb, NL80211_TXRATE_MAX, nla_data(tx_rates),
+				nla_len(tx_rates), nl80211_txattr_policy);
+		if (err)
+			return err;
 		if (tb[NL80211_TXRATE_LEGACY]) {
 			mask.control[band].legacy = rateset_to_mask(
 				sband,
-- 
1.8.5.2

