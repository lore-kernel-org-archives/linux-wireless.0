Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:52815 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaAQIcS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 03:32:18 -0500
Received: by mail-ea0-f175.google.com with SMTP id z10so1579432ead.20
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 00:32:17 -0800 (PST)
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>
Subject: [PATCH 3/5] cfg80211: fix maximum bandwidth calculation
Date: Fri, 17 Jan 2014 09:32:02 +0100
Message-Id: <1389947524-6102-4-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140117_093224_568872_80B1FF86)
In-Reply-To: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1389947524-6102-1-git-send-email-janusz.dziedzic@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculate maximum bandwidth base on all contiguous
regulatory rules, instead of single rule.
Base on this calculation mark channel BW flags
correctly.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 net/wireless/reg.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 71d360c..8165303 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -541,6 +541,55 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
 	return regd;
 }
 
+static unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
+					  const struct ieee80211_reg_rule *rule)
+{
+	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
+	const struct ieee80211_freq_range *freq_range_tmp;
+	const struct ieee80211_reg_rule *tmp;
+	u32 start_freq, end_freq, idx, no;
+
+	for (idx = 0; idx < rd->n_reg_rules; idx++)
+		if (rule == &rd->reg_rules[idx])
+			break;
+
+	if (idx == rd->n_reg_rules)
+		return 0;
+
+	/* get start_freq */
+	no = idx;
+
+	while (no) {
+		tmp = &rd->reg_rules[--no];
+		freq_range_tmp = &tmp->freq_range;
+
+		if (freq_range_tmp->end_freq_khz < freq_range->start_freq_khz)
+			break;
+
+		freq_range = freq_range_tmp;
+	};
+
+	start_freq = freq_range->start_freq_khz;
+
+	/* get end_freq */
+	freq_range = &rule->freq_range;
+	no = idx;
+
+	while (no < rd->n_reg_rules - 1) {
+		tmp = &rd->reg_rules[++no];
+		freq_range_tmp = &tmp->freq_range;
+
+		if (freq_range_tmp->start_freq_khz > freq_range->end_freq_khz)
+			break;
+
+		freq_range = freq_range_tmp;
+	}
+
+	end_freq = freq_range->end_freq_khz;
+
+	return end_freq - start_freq;
+}
+
 /* Sanity check on a regulatory rule */
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
@@ -908,6 +957,8 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
+	const struct ieee80211_regdomain *regd;
+	u32 max_bandwidth_khz;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
@@ -949,11 +1000,14 @@ static void handle_channel(struct wiphy *wiphy,
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+	regd = reg_get_regdomain(wiphy);
+	max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
+
+	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
+	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
-- 
1.7.9.5

