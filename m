Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40982 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab2LCRmy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:42:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 8/8] regulatory: remove BUG_ON
Date: Mon,  3 Dec 2012 18:43:13 +0100
Message-Id: <1354556593-2363-9-git-send-email-johannes@sipsolutions.net> (sfid-20121203_184306_216043_6B3A40F3)
In-Reply-To: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
References: <1354556593-2363-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This code is a bit too BUG_ON happy, remove all
instances and while doing so make some code a bit
smarter by passing the right pointer instead of
indices into arrays.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c |  2 --
 net/wireless/reg.c     | 95 ++++++++++++++++++++------------------------------
 2 files changed, 37 insertions(+), 60 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index fb81208..260b5d8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4333,8 +4333,6 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	BUG_ON(rule_idx != num_rules);
-
 	r = set_regdom(rd);
 	rd = NULL;
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4b00083..b5be7ef 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -214,7 +214,7 @@ static void reset_regdomains(bool full_reset)
  */
 static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
-	BUG_ON(!last_request);
+	WARN_ON(!last_request);
 
 	reset_regdomains(false);
 
@@ -813,8 +813,7 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
  */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
-			   enum ieee80211_band band,
-			   unsigned int chan_idx)
+			   struct ieee80211_channel *chan)
 {
 	int r;
 	u32 flags, bw_flags = 0;
@@ -822,18 +821,12 @@ static void handle_channel(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan;
 	struct wiphy *request_wiphy = NULL;
 
 	assert_cfg80211_lock();
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 
-	sband = wiphy->bands[band];
-	BUG_ON(chan_idx >= sband->n_channels);
-	chan = &sband->channels[chan_idx];
-
 	flags = chan->orig_flags;
 
 	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
@@ -906,17 +899,17 @@ static void handle_channel(struct wiphy *wiphy,
 		chan->max_power = chan->max_reg_power;
 }
 
-static void handle_band(struct wiphy *wiphy, enum ieee80211_band band,
-			enum nl80211_reg_initiator initiator)
+static void handle_band(struct wiphy *wiphy,
+			enum nl80211_reg_initiator initiator,
+			struct ieee80211_supported_band *sband)
 {
 	unsigned int i;
-	struct ieee80211_supported_band *sband;
 
-	BUG_ON(!wiphy->bands[band]);
-	sband = wiphy->bands[band];
+	if (!sband)
+		return;
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel(wiphy, initiator, band, i);
+		handle_channel(wiphy, initiator, &sband->channels[i]);
 }
 
 static bool reg_request_cell_base(struct regulatory_request *request)
@@ -1128,20 +1121,14 @@ static bool is_ht40_allowed(struct ieee80211_channel *chan)
 }
 
 static void reg_process_ht_flags_channel(struct wiphy *wiphy,
-					 enum ieee80211_band band,
-					 unsigned int chan_idx)
+					 struct ieee80211_channel *channel)
 {
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *channel;
+	struct ieee80211_supported_band *sband = wiphy->bands[channel->band];
 	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
 	unsigned int i;
 
 	assert_cfg80211_lock();
 
-	sband = wiphy->bands[band];
-	BUG_ON(chan_idx >= sband->n_channels);
-	channel = &sband->channels[chan_idx];
-
 	if (!is_ht40_allowed(channel)) {
 		channel->flags |= IEEE80211_CHAN_NO_HT40;
 		return;
@@ -1177,16 +1164,15 @@ static void reg_process_ht_flags_channel(struct wiphy *wiphy,
 }
 
 static void reg_process_ht_flags_band(struct wiphy *wiphy,
-				      enum ieee80211_band band)
+				      struct ieee80211_supported_band *sband)
 {
 	unsigned int i;
-	struct ieee80211_supported_band *sband;
 
-	BUG_ON(!wiphy->bands[band]);
-	sband = wiphy->bands[band];
+	if (!sband)
+		return;
 
 	for (i = 0; i < sband->n_channels; i++)
-		reg_process_ht_flags_channel(wiphy, band, i);
+		reg_process_ht_flags_channel(wiphy, &sband->channels[i]);
 }
 
 static void reg_process_ht_flags(struct wiphy *wiphy)
@@ -1196,11 +1182,8 @@ static void reg_process_ht_flags(struct wiphy *wiphy)
 	if (!wiphy)
 		return;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (wiphy->bands[band])
-			reg_process_ht_flags_band(wiphy, band);
-	}
-
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		reg_process_ht_flags_band(wiphy, wiphy->bands[band]);
 }
 
 static void wiphy_update_regulatory(struct wiphy *wiphy,
@@ -1215,10 +1198,8 @@ static void wiphy_update_regulatory(struct wiphy *wiphy,
 
 	last_request->dfs_region = cfg80211_regdomain->dfs_region;
 
-	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-		if (wiphy->bands[band])
-			handle_band(wiphy, band, initiator);
-	}
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++)
+		handle_band(wiphy, initiator, wiphy->bands[band]);
 
 	reg_process_beacons(wiphy);
 	reg_process_ht_flags(wiphy);
@@ -1248,8 +1229,7 @@ static void update_all_wiphy_regulatory(enum nl80211_reg_initiator initiator)
 }
 
 static void handle_channel_custom(struct wiphy *wiphy,
-				  enum ieee80211_band band,
-				  unsigned int chan_idx,
+				  struct ieee80211_channel *chan,
 				  const struct ieee80211_regdomain *regd)
 {
 	int r;
@@ -1258,15 +1238,9 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_channel *chan;
 
 	assert_reg_lock();
 
-	sband = wiphy->bands[band];
-	BUG_ON(chan_idx >= sband->n_channels);
-	chan = &sband->channels[chan_idx];
-
 	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
 			       desired_bw_khz, &reg_rule, regd);
 
@@ -1291,17 +1265,17 @@ static void handle_channel_custom(struct wiphy *wiphy,
 		(int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
+static void handle_band_custom(struct wiphy *wiphy,
+			       struct ieee80211_supported_band *sband,
 			       const struct ieee80211_regdomain *regd)
 {
 	unsigned int i;
-	struct ieee80211_supported_band *sband;
 
-	BUG_ON(!wiphy->bands[band]);
-	sband = wiphy->bands[band];
+	if (!sband)
+		return;
 
 	for (i = 0; i < sband->n_channels; i++)
-		handle_channel_custom(wiphy, band, i, regd);
+		handle_channel_custom(wiphy, &sband->channels[i], regd);
 }
 
 /* Used by drivers prior to wiphy registration */
@@ -1315,7 +1289,7 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
 		if (!wiphy->bands[band])
 			continue;
-		handle_band_custom(wiphy, band, regd);
+		handle_band_custom(wiphy, wiphy->bands[band], regd);
 		bands_set++;
 	}
 	mutex_unlock(&reg_mutex);
@@ -1549,7 +1523,8 @@ static void reg_process_hint(struct regulatory_request *reg_request,
 {
 	struct wiphy *wiphy = NULL;
 
-	BUG_ON(!reg_request->alpha2);
+	if (WARN_ON(!reg_request->alpha2))
+		return;
 
 	if (reg_request->wiphy_idx != WIPHY_IDX_INVALID)
 		wiphy = wiphy_idx_to_wiphy(reg_request->wiphy_idx);
@@ -1697,7 +1672,8 @@ int regulatory_hint_user(const char *alpha2,
 {
 	struct regulatory_request *request;
 
-	BUG_ON(!alpha2);
+	if (WARN_ON(!alpha2))
+		return -EINVAL;
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
@@ -1719,8 +1695,8 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 {
 	struct regulatory_request *request;
 
-	BUG_ON(!alpha2);
-	BUG_ON(!wiphy);
+	if (WARN_ON(!alpha2 || !wiphy))
+		return -EINVAL;
 
 	request = kzalloc(sizeof(struct regulatory_request), GFP_KERNEL);
 	if (!request)
@@ -2263,12 +2239,14 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 			reg_set_request_processed();
 
 		kfree(rd);
-		mutex_unlock(&reg_mutex);
-		return r;
+		goto out;
 	}
 
 	/* This would make this whole thing pointless */
-	BUG_ON(!last_request->intersect && rd != cfg80211_regdomain);
+	if (WARN_ON(!last_request->intersect && rd != cfg80211_regdomain)) {
+		r = -EINVAL;
+		goto out;
+	}
 
 	/* update all wiphys now with the new established regulatory domain */
 	update_all_wiphy_regulatory(last_request->initiator);
@@ -2279,6 +2257,7 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 
 	reg_set_request_processed();
 
+ out:
 	mutex_unlock(&reg_mutex);
 
 	return r;
-- 
1.8.0

