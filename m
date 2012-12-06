Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53236 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946007Ab2LFQsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 19/24] regulatory: remove handling of channel bandwidth
Date: Thu,  6 Dec 2012 17:47:43 +0100
Message-Id: <1354812468-15709-20-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174858_135723_4A8A6194)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The channel bandwidth handling isn't really quite right,
it assumes that a 40 MHz channel is really two 20 MHz
channels, which isn't strictly true. This is the way the
regulatory database handling is defined right now though
so remove the logic to handle other channel widths.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/regd.c                   |  7 ++--
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  2 +-
 drivers/net/wireless/rtlwifi/regd.c               |  9 ++---
 include/net/cfg80211.h                            |  8 +----
 net/wireless/reg.c                                | 44 ++++++++---------------
 5 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index d816980..8ae58c40 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -195,7 +195,6 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
-	u32 bandwidth = 0;
 	int r;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
@@ -216,7 +215,6 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 				r = freq_reg_info(wiphy,
 						  ch->center_freq,
-						  bandwidth,
 						  &reg_rule);
 				if (r)
 					continue;
@@ -254,7 +252,6 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
-	u32 bandwidth = 0;
 	int r;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
@@ -283,7 +280,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11]; /* CH 12 */
-	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -291,7 +288,7 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12]; /* CH 13 */
-	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index 64a48f0..f754efa 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -687,7 +687,7 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 				ret = freq_reg_info(wiphy, ch->center_freq,
-						    0, &rule);
+						    &rule);
 				if (ret)
 					continue;
 
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index c1608cd..be55dc9 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -158,7 +158,6 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
-	u32 bandwidth = 0;
 	int r;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
@@ -174,8 +173,7 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				r = freq_reg_info(wiphy, ch->center_freq,
-						  bandwidth, &reg_rule);
+				r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
 				if (r)
 					continue;
 
@@ -211,7 +209,6 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
-	u32 bandwidth = 0;
 	int r;
 
 	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
@@ -240,7 +237,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11];	/* CH 12 */
-	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -248,7 +245,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3ba1784..84fcb10 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2938,10 +2938,6 @@ extern void wiphy_apply_custom_regulatory(
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
- * @desired_bw_khz: the desired max bandwidth you want to use per
- *	channel. Note that this is still 20 MHz if you want to use HT40
- *	as HT40 makes use of two channels for its 40 MHz width bandwidth.
- *	If set to 0 we'll assume you want the standard 20 MHz.
  * @reg_rule: the regulatory rule which we have for this frequency
  *
  * Use this function to get the regulatory rule for a specific frequency on
@@ -2956,9 +2952,7 @@ extern void wiphy_apply_custom_regulatory(
  * freq_in_rule_band() for our current definition of a band -- this is purely
  * subjective and right now its 802.11 specific.
  */
-extern int freq_reg_info(struct wiphy *wiphy,
-			 u32 center_freq,
-			 u32 desired_bw_khz,
+extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 			 const struct ieee80211_reg_rule **reg_rule);
 
 /*
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 10d8edb..011fab9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -481,8 +481,7 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 }
 
 static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
-			    u32 center_freq_khz,
-			    u32 bw_khz)
+			    u32 center_freq_khz, u32 bw_khz)
 {
 	u32 start_freq_khz, end_freq_khz;
 
@@ -683,9 +682,7 @@ static u32 map_regdom_flags(u32 rd_flags)
 	return channel_flags;
 }
 
-static int freq_reg_info_regd(struct wiphy *wiphy,
-			      u32 center_freq,
-			      u32 desired_bw_khz,
+static int freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 			      const struct ieee80211_reg_rule **reg_rule,
 			      const struct ieee80211_regdomain *regd)
 {
@@ -693,9 +690,6 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	bool band_rule_found = false;
 	bool bw_fits = false;
 
-	if (!desired_bw_khz)
-		desired_bw_khz = MHZ_TO_KHZ(20);
-
 	if (!regd)
 		return -EINVAL;
 
@@ -714,7 +708,7 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, desired_bw_khz);
+		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
 
 		if (band_rule_found && bw_fits) {
 			*reg_rule = rr;
@@ -728,7 +722,7 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 	return -EINVAL;
 }
 
-int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 desired_bw_khz,
+int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 		  const struct ieee80211_reg_rule **reg_rule)
 {
 	const struct ieee80211_regdomain *regd;
@@ -747,8 +741,7 @@ int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 desired_bw_khz,
 	else
 		regd = cfg80211_regdomain;
 
-	return freq_reg_info_regd(wiphy, center_freq, desired_bw_khz,
-				  reg_rule, regd);
+	return freq_reg_info_regd(wiphy, center_freq, reg_rule, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -771,7 +764,6 @@ static const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 }
 
 static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
-				    u32 desired_bw_khz,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	const struct ieee80211_power_rule *power_rule;
@@ -786,8 +778,8 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	else
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
-	REG_DBG_PRINT("Updating information on frequency %d MHz for a %d MHz width channel with regulatory rule:\n",
-		      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
+	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
+		      chan->center_freq);
 
 	REG_DBG_PRINT("%d KHz - %d KHz @ %d KHz), (%s mBi, %d mBm)\n",
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
@@ -796,7 +788,6 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 }
 #else
 static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
-				    u32 desired_bw_khz,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	return;
@@ -806,11 +797,7 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel). To support
- * smaller custom bandwidths such as 5 MHz or 10 MHz we'll need a
- * new ieee80211_channel.target_bw and re run the regulatory check
- * on the wiphy with the target_bw specified. Then we can simply use
- * that below for the desired_bw_khz below.
+ * per channel, the primary and the extension channel).
  */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
@@ -818,7 +805,6 @@ static void handle_channel(struct wiphy *wiphy,
 {
 	int r;
 	u32 flags, bw_flags = 0;
-	u32 desired_bw_khz = MHZ_TO_KHZ(20);
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
@@ -830,8 +816,7 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
-			  desired_bw_khz, &reg_rule);
+	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), &reg_rule);
 	if (r) {
 		/*
 		 * We will disable all channels that do not match our
@@ -852,7 +837,7 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+	chan_reg_rule_print_dbg(chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
@@ -1224,23 +1209,22 @@ static void handle_channel_custom(struct wiphy *wiphy,
 				  const struct ieee80211_regdomain *regd)
 {
 	int r;
-	u32 desired_bw_khz = MHZ_TO_KHZ(20);
 	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 
 	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-			       desired_bw_khz, &reg_rule, regd);
+			       &reg_rule, regd);
 
 	if (r) {
-		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits a %d MHz wide channel\n",
-			      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
+		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
+			      chan->center_freq);
 		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
+	chan_reg_rule_print_dbg(chan, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
-- 
1.8.0

