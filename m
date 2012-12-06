Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946004Ab2LFQsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2012 11:48:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 24/24] regulatory: use IS_ERR macro family for freq_reg_info
Date: Thu,  6 Dec 2012 17:47:48 +0100
Message-Id: <1354812468-15709-25-git-send-email-johannes@sipsolutions.net> (sfid-20121206_174857_186540_8C514D14)
In-Reply-To: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of returning an error and filling a pointer
return the pointer and an ERR_PTR value in error cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/regd.c                   | 16 ++++------
 drivers/net/wireless/brcm80211/brcmsmac/channel.c |  5 ++-
 drivers/net/wireless/rtlwifi/regd.c               | 14 ++++-----
 include/net/cfg80211.h                            | 18 +++++------
 net/wireless/reg.c                                | 38 ++++++++++-------------
 5 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 8ae58c40..7a6c79e 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -195,7 +195,6 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
-	int r;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 
@@ -213,10 +212,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				r = freq_reg_info(wiphy,
-						  ch->center_freq,
-						  &reg_rule);
-				if (r)
+				reg_rule = freq_reg_info(wiphy, ch->center_freq);
+				if (IS_ERR(reg_rule))
 					continue;
 				/*
 				 * If 11d had a rule for this channel ensure
@@ -252,7 +249,6 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
-	int r;
 
 	sband = wiphy->bands[IEEE80211_BAND_2GHZ];
 	if (!sband)
@@ -280,16 +276,16 @@ ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11]; /* CH 12 */
-	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
-	if (!r) {
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
 	}
 
 	ch = &sband->channels[12]; /* CH 13 */
-	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
-	if (!r) {
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/channel.c b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
index f754efa..e6f6d92 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/channel.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/channel.c
@@ -686,9 +686,8 @@ brcms_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				ret = freq_reg_info(wiphy, ch->center_freq,
-						    &rule);
-				if (ret)
+				rule = freq_reg_info(wiphy, ch->center_freq);
+				if (IS_ERR(rule))
 					continue;
 
 				if (!(rule->flags & NL80211_RRF_NO_IBSS))
diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index be55dc9..7e3ead7 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -158,7 +158,6 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
-	int r;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 
@@ -173,8 +172,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
-				if (r)
+				reg_rule = freq_reg_info(wiphy, ch->center_freq);
+				if (IS_ERR(reg_rule))
 					continue;
 
 				/*
@@ -209,7 +208,6 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *ch;
 	const struct ieee80211_reg_rule *reg_rule;
-	int r;
 
 	if (!wiphy->bands[IEEE80211_BAND_2GHZ])
 		return;
@@ -237,16 +235,16 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11];	/* CH 12 */
-	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
-	if (!r) {
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	r = freq_reg_info(wiphy, ch->center_freq, &reg_rule);
-	if (!r) {
+	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 461d979..acbf5e0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2938,22 +2938,22 @@ extern void wiphy_apply_custom_regulatory(
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
- * @reg_rule: the regulatory rule which we have for this frequency
  *
  * Use this function to get the regulatory rule for a specific frequency on
  * a given wireless device. If the device has a specific regulatory domain
  * it wants to follow we respect that unless a country IE has been received
  * and processed already.
  *
- * Returns 0 if it was able to find a valid regulatory rule which does
- * apply to the given center_freq otherwise it returns non-zero. It will
- * also return -ERANGE if we determine the given center_freq does not even have
- * a regulatory rule for a frequency range in the center_freq's band. See
- * freq_in_rule_band() for our current definition of a band -- this is purely
- * subjective and right now its 802.11 specific.
+ * When an error occurs, for example if no rule can be found, the return value
+ * is encoded using ERR_PTR(). Use IS_ERR() to check and PTR_ERR() to obtain
+ * the numeric return value. The numeric return value will be -ERANGE if we
+ * determine the given center_freq does not even have a regulatory rule for a
+ * frequency range in the center_freq's band. See freq_in_rule_band() for our
+ * current definition of a band -- this is purely subjective and right now it's
+ * 802.11 specific.
  */
-extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
-			 const struct ieee80211_reg_rule **reg_rule);
+const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
+					       u32 center_freq);
 
 /*
  * callbacks for asynchronous cfg80211 methods, notification
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b289131..041f22c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -711,16 +711,16 @@ static u32 map_regdom_flags(u32 rd_flags)
 	return channel_flags;
 }
 
-static int freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
-			      const struct ieee80211_reg_rule **reg_rule,
-			      const struct ieee80211_regdomain *regd)
+static const struct ieee80211_reg_rule *
+freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+		   const struct ieee80211_regdomain *regd)
 {
 	int i;
 	bool band_rule_found = false;
 	bool bw_fits = false;
 
 	if (!regd)
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	for (i = 0; i < regd->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
@@ -739,20 +739,18 @@ static int freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 
 		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
 
-		if (band_rule_found && bw_fits) {
-			*reg_rule = rr;
-			return 0;
-		}
+		if (band_rule_found && bw_fits)
+			return rr;
 	}
 
 	if (!band_rule_found)
-		return -ERANGE;
+		return ERR_PTR(-ERANGE);
 
-	return -EINVAL;
+	return ERR_PTR(-EINVAL);
 }
 
-int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
-		  const struct ieee80211_reg_rule **reg_rule)
+const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
+					       u32 center_freq)
 {
 	const struct ieee80211_regdomain *regd;
 	struct regulatory_request *lr = get_last_request();
@@ -768,7 +766,7 @@ int freq_reg_info(struct wiphy *wiphy, u32 center_freq,
 	else
 		regd = get_cfg80211_regdom();
 
-	return freq_reg_info_regd(wiphy, center_freq, reg_rule, regd);
+	return freq_reg_info_regd(wiphy, center_freq, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -830,7 +828,6 @@ static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
 			   struct ieee80211_channel *chan)
 {
-	int r;
 	u32 flags, bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
@@ -842,8 +839,8 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), &reg_rule);
-	if (r) {
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
+	if (IS_ERR(reg_rule)) {
 		/*
 		 * We will disable all channels that do not match our
 		 * received regulatory rule unless the hint is coming
@@ -855,7 +852,7 @@ static void handle_channel(struct wiphy *wiphy,
 		 * while 5 GHz is still supported.
 		 */
 		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
-		    r == -ERANGE)
+		    PTR_ERR(reg_rule) == -ERANGE)
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
@@ -1238,16 +1235,15 @@ static void handle_channel_custom(struct wiphy *wiphy,
 				  struct ieee80211_channel *chan,
 				  const struct ieee80211_regdomain *regd)
 {
-	int r;
 	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 
-	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-			       &reg_rule, regd);
+	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
+				      regd);
 
-	if (r) {
+	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			      chan->center_freq);
 		chan->flags = IEEE80211_CHAN_DISABLED;
-- 
1.8.0

