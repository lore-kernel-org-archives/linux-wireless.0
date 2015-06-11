Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:34359 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbbFKPMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 11:12:50 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 7EAC3A06CBB
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 17:12:47 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCH v3] cfg80211: Handle minimum bandwidth for quarter and half rates
Date: Thu, 11 Jun 2015 17:12:33 +0200
Message-Id: <1434035553-6621-1-git-send-email-matthias.may@neratec.com> (sfid-20150611_171301_187773_8C09D939)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The goal of this patch is to improve regd handling of quarter and half rates.

The original assumption of 20MHz wide channels is with the introduction of
quarter and half rates no longer true.
With this patch we no longer disable all channels that don't fit into the
20MHz grid, but instead set the appropriate flags to disable operation on
specific bandwidths.

v2: Changes based on feedback by Johannes Berg.
v3: Changes based on feedback by Johannes Berg and Zefir Kurtisi.

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 net/wireless/reg.c | 51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 11 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d359e06..4ab1b67 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1004,7 +1004,7 @@ static u32 map_regdom_flags(u32 rd_flags)
 
 static const struct ieee80211_reg_rule *
 freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
-		   const struct ieee80211_regdomain *regd)
+		   const struct ieee80211_regdomain *regd, u32 bw)
 {
 	int i;
 	bool band_rule_found = false;
@@ -1028,7 +1028,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, bw);
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -1040,14 +1040,26 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 	return ERR_PTR(-EINVAL);
 }
 
-const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq)
+const struct ieee80211_reg_rule *__freq_reg_info(struct wiphy *wiphy,
+						 u32 center_freq, u32 min_bw)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd = reg_get_regdomain(wiphy);
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	u32 bw;
 
-	regd = reg_get_regdomain(wiphy);
+	for (bw = MHZ_TO_KHZ(20); bw >= min_bw; bw = bw / 2) {
+		reg_rule = freq_reg_info_regd(wiphy, center_freq, regd, bw);
+		if (!IS_ERR(reg_rule))
+			return reg_rule;
+	}
 
-	return freq_reg_info_regd(wiphy, center_freq, regd);
+	return reg_rule;
+}
+
+const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
+					       u32 center_freq)
+{
+	return __freq_reg_info(wiphy, center_freq, MHZ_TO_KHZ(20));
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -1176,8 +1188,14 @@ static void handle_channel(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	/* If we get a reg_rule we can assume that at least 5Mhz fitted */
+	if (!reg_does_bw_fit(freq_range, chan->center_freq, 10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (!reg_does_bw_fit(freq_range, chan->center_freq, 20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
@@ -1695,9 +1713,14 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	u32 max_bandwidth_khz;
+	u32 bw;
 
-	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-				      regd);
+	for (bw = MHZ_TO_KHZ(20); bw >= MHZ_TO_KHZ(5); bw = bw / 2) {
+		reg_rule = freq_reg_info_regd(wiphy, chan->center_freq,
+					      regd, bw);
+		if (!IS_ERR(reg_rule))
+			break;
+	}
 
 	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
@@ -1721,8 +1744,14 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	/* If we get a reg_rule we can assume that at least 5Mhz fitted */
+	if (!reg_does_bw_fit(freq_range, chan->center_freq, 10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (!reg_does_bw_fit(freq_range, chan->center_freq, 20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-- 
2.1.4

