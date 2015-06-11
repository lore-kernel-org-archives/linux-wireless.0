Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:24482 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbbFKLGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:06:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id 06BD28E4A7A
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 13:06:37 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCHv2 1/4] cfg80211: handle minimum bandwidth for quarter and half rates
Date: Thu, 11 Jun 2015 13:06:28 +0200
Message-Id: <1434020791-16291-2-git-send-email-matthias.may@neratec.com> (sfid-20150611_130650_868019_E29B6AA4)
In-Reply-To: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch changes the API of freq_freq_info() to take as additional argument
the minimum bandwidth the caller can handle.
If multiple rules match, the match with the widest bandwidth is returned.

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 include/net/cfg80211.h |  3 ++-
 net/wireless/reg.c     | 46 +++++++++++++++++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a741678..ac5d8e8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3876,6 +3876,7 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @min_bw: The minimum bandwidth in KHz the caller can handle
  *
  * Use this function to get the regulatory rule for a specific frequency on
  * a given wireless device. If the device has a specific regulatory domain
@@ -3891,7 +3892,7 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * purely subjective and right now it's 802.11 specific.
  */
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq);
+					       u32 center_freq, u32 min_bw);
 
 /**
  * reg_initiator_name - map regulatory request initiator enum to name
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d359e06..c4f85bb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1003,7 +1003,7 @@ static u32 map_regdom_flags(u32 rd_flags)
 }
 
 static const struct ieee80211_reg_rule *
-freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq, u32 bw,
 		   const struct ieee80211_regdomain *regd)
 {
 	int i;
@@ -1028,7 +1028,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, bw);
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -1041,13 +1041,22 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 }
 
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq)
+					       u32 center_freq, u32 min_bw)
 {
 	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_reg_rule *rr_tmp = NULL;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	u32 bw;
 
 	regd = reg_get_regdomain(wiphy);
 
-	return freq_reg_info_regd(wiphy, center_freq, regd);
+	for(bw=min_bw; bw <= MHZ_TO_KHZ(20); bw=bw*2) {
+		rr_tmp = freq_reg_info_regd(wiphy, center_freq, bw, regd);
+		if(!reg_rule || !IS_ERR(rr_tmp))
+			reg_rule = rr_tmp;
+	}
+
+	return reg_rule;
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -1134,7 +1143,8 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
+				 MHZ_TO_KHZ(20));
 	if (IS_ERR(reg_rule)) {
 		/*
 		 * We will disable all channels that do not match our
@@ -1176,8 +1186,12 @@ static void handle_channel(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags = IEEE80211_CHAN_NO_10MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
@@ -1692,12 +1706,22 @@ static void handle_channel_custom(struct wiphy *wiphy,
 {
 	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_reg_rule *rr_tmp = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 	u32 max_bandwidth_khz;
+	u32 bw;
 
-	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-				      regd);
+	/* Check if a frequency fits a rule for 5, 10 and 20MHz in that order.
+	 * Use the rule with the widest bandwidth that fits.
+	 */
+	for(bw=MHZ_TO_KHZ(5); bw <= MHZ_TO_KHZ(20); bw=bw*2) {
+		rr_tmp = freq_reg_info_regd(wiphy,
+					    MHZ_TO_KHZ(chan->center_freq), bw,
+					    regd);
+		if(!reg_rule || !IS_ERR(rr_tmp))
+			reg_rule = rr_tmp;
+	}
 
 	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
@@ -1721,8 +1745,12 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
 		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
 
+	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags = IEEE80211_CHAN_NO_10MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags = IEEE80211_CHAN_NO_HT40;
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
 		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
 	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-- 
2.1.4

