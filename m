Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54733 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbbKWS1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:54 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 3/8] cfg80211: reg: Refactor calculation of bandwidth flags
Date: Mon, 23 Nov 2015 19:27:16 +0100
Message-Id: <1448303241-27747-4-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192815_578111_C2D7CE4F)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same piece of code appears at two places. Make a function from it.

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 net/wireless/reg.c | 91 ++++++++++++++++++++++--------------------------------
 1 file changed, 37 insertions(+), 54 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 43b3e57..0a4f548 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1166,6 +1166,41 @@ static void chan_reg_rule_print_dbg(const struct ieee80211_regdomain *regd,
 #endif
 }
 
+static uint32_t reg_rule_to_chan_bw_flags(const struct ieee80211_regdomain *regd,
+					  const struct ieee80211_reg_rule *reg_rule,
+					  const struct ieee80211_channel *chan)
+{
+	const struct ieee80211_freq_range *freq_range = NULL;
+	u32 max_bandwidth_khz, bw_flags = 0;
+
+	freq_range = &reg_rule->freq_range;
+
+	max_bandwidth_khz = freq_range->max_bandwidth_khz;
+	/* Check if auto calculation requested */
+	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
+		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
+
+	/* If we get a reg_rule we can assume that at least 5Mhz fit */
+	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
+			     MHZ_TO_KHZ(10)))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
+			     MHZ_TO_KHZ(20)))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+
+	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
+		bw_flags |= IEEE80211_CHAN_NO_HT40;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
+		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
+		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
+	return bw_flags;
+}
+
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
@@ -1178,11 +1213,9 @@ static void handle_channel(struct wiphy *wiphy,
 	u32 flags, bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
-	const struct ieee80211_freq_range *freq_range = NULL;
 	struct wiphy *request_wiphy = NULL;
 	struct regulatory_request *lr = get_last_request();
 	const struct ieee80211_regdomain *regd;
-	u32 max_bandwidth_khz;
 
 	request_wiphy = wiphy_idx_to_wiphy(lr->wiphy_idx);
 
@@ -1223,31 +1256,7 @@ static void handle_channel(struct wiphy *wiphy,
 	chan_reg_rule_print_dbg(regd, chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
-	freq_range = &reg_rule->freq_range;
-
-	max_bandwidth_khz = freq_range->max_bandwidth_khz;
-	/* Check if auto calculation requested */
-	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-
-	/* If we get a reg_rule we can assume that at least 5Mhz fit */
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(10)))
-		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(20)))
-		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
-
-	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
-		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
-		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags |= IEEE80211_CHAN_NO_HT40;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
-		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
+	bw_flags = reg_rule_to_chan_bw_flags(regd, reg_rule, chan);
 
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
@@ -1760,8 +1769,6 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
-	const struct ieee80211_freq_range *freq_range = NULL;
-	u32 max_bandwidth_khz;
 	u32 bw;
 
 	for (bw = MHZ_TO_KHZ(20); bw >= MHZ_TO_KHZ(5); bw = bw / 2) {
@@ -1786,31 +1793,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	chan_reg_rule_print_dbg(regd, chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
-	freq_range = &reg_rule->freq_range;
-
-	max_bandwidth_khz = freq_range->max_bandwidth_khz;
-	/* Check if auto calculation requested */
-	if (reg_rule->flags & NL80211_RRF_AUTO_BW)
-		max_bandwidth_khz = reg_get_max_bandwidth(regd, reg_rule);
-
-	/* If we get a reg_rule we can assume that at least 5Mhz fit */
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(10)))
-		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
-	if (!reg_does_bw_fit(freq_range, MHZ_TO_KHZ(chan->center_freq),
-			     MHZ_TO_KHZ(20)))
-		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
-
-	if (max_bandwidth_khz < MHZ_TO_KHZ(10))
-		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(20))
-		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(40))
-		bw_flags |= IEEE80211_CHAN_NO_HT40;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(80))
-		bw_flags |= IEEE80211_CHAN_NO_80MHZ;
-	if (max_bandwidth_khz < MHZ_TO_KHZ(160))
-		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
+	bw_flags = reg_rule_to_chan_bw_flags(regd, reg_rule, chan);
 
 	chan->dfs_state_entered = jiffies;
 	chan->dfs_state = NL80211_DFS_USABLE;
-- 
2.5.3

