Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZCSFyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 01:54:46 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 1/6] cfg80211: Process regulatory max bandwidth checks for HT40
Date: Thu, 19 Mar 2009 01:54:35 -0400
Message-Id: <1237442080-27509-2-git-send-email-lrodriguez@atheros.com> (sfid-20090319_065455_171413_0CF85590)
In-Reply-To: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
References: <1237442080-27509-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are not correctly listening to the regulatory max bandwidth
settings. To actually make use of it we need to redesign things
a bit. This patch does the work for that. We do this to so we
can obey to regulatory rules accordingly for use of HT40.

We end up dealing with HT40 by having two passes for each channel.

The first check will see if a 20 MHz channel fits into the channel's
center freq on a given frequency range. We check for a 20 MHz
banwidth channel as that is the maximum an individual channel
will use, at least for now. The first pass will go ahead and
check if the regulatory rule for that given center of frequency
allows 40 MHz bandwidths and we use this to determine whether
or not the channel supports HT40 or not. So to support HT40 you'll
need at a regulatory rule that allows you to use 40 MHz channels
but you're channel must also be enabled and support 20 MHz by itself.

The second pass is done after we do the regulatory checks over
an device's supported channel list. On each channel we'll check
if the control channel and the extension both:

 o exist
 o are enabled
 o regulatory allows 40 MHz bandwidth on its frequency range

This work allows allows us to idependently check for HT40- and
HT40+.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |   10 +-
 include/net/wireless.h            |   15 ++-
 net/wireless/reg.c                |  194 +++++++++++++++++++++++++++++--------
 3 files changed, 169 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 4ca6251..db42198 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -196,8 +196,10 @@ static void ath9k_reg_apply_beaconing_flags(
 				continue;
 
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				r = freq_reg_info(wiphy, ch->center_freq,
-					&bandwidth, &reg_rule);
+				r = freq_reg_info(wiphy,
+						  ch->center_freq,
+						  bandwidth,
+						  &reg_rule);
 				if (r)
 					continue;
 				/*
@@ -261,7 +263,7 @@ static void ath9k_reg_apply_active_scan_flags(
 	 */
 
 	ch = &sband->channels[11]; /* CH 12 */
-	r = freq_reg_info(wiphy, ch->center_freq, &bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -269,7 +271,7 @@ static void ath9k_reg_apply_active_scan_flags(
 	}
 
 	ch = &sband->channels[12]; /* CH 13 */
-	r = freq_reg_info(wiphy, ch->center_freq, &bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy, ch->center_freq, bandwidth, &reg_rule);
 	if (!r) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 64a7620..e3077e1 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -44,6 +44,9 @@ enum ieee80211_band {
  * 	is not permitted.
  * @IEEE80211_CHAN_NO_FAT_BELOW: extension channel below this channel
  * 	is not permitted.
+ * @IEEE80211_CHAN_NO_HT40: indicates no HT40 is allowed at all,
+ * 	when this is set %IEEE80211_CHAN_NO_FAT_ABOVE and
+ * 	%IEEE80211_CHAN_NO_FAT_BELOW will also be set.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -52,6 +55,7 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_RADAR		= 1<<3,
 	IEEE80211_CHAN_NO_FAT_ABOVE	= 1<<4,
 	IEEE80211_CHAN_NO_FAT_BELOW	= 1<<5,
+	IEEE80211_CHAN_NO_HT40		= 1<<6,
 };
 
 /**
@@ -449,9 +453,10 @@ extern void wiphy_apply_custom_regulatory(
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
- * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
- * 	you can set this to 0. If this frequency is allowed we then set
- * 	this value to the maximum allowed bandwidth.
+ * @desired_bw_khz: the desired max bandwidth you want to use per
+ * 	channel. Note that this is still 20 MHz if you want to use HT40
+ * 	as HT40 makes use of two channels for its 40 MHz width bandwidth.
+ * 	If set to 0 we'll assume you want the standard 20 MHz.
  * @reg_rule: the regulatory rule which we have for this frequency
  *
  * Use this function to get the regulatory rule for a specific frequency on
@@ -466,7 +471,9 @@ extern void wiphy_apply_custom_regulatory(
  * freq_in_rule_band() for our current definition of a band -- this is purely
  * subjective and right now its 802.11 specific.
  */
-extern int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
+extern int freq_reg_info(struct wiphy *wiphy,
+			 u32 center_freq,
+			 u32 desired_bw_khz,
 			 const struct ieee80211_reg_rule **reg_rule);
 
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index eb8b8ed..29646b6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -49,12 +49,6 @@ static struct regulatory_request *last_request;
 /* To trigger userspace events */
 static struct platform_device *reg_pdev;
 
-/* Keep the ordering from large to small */
-static u32 supported_bandwidths[] = {
-	MHZ_TO_KHZ(40),
-	MHZ_TO_KHZ(20),
-};
-
 /*
  * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
@@ -431,19 +425,20 @@ static bool is_valid_rd(const struct ieee80211_regdomain *rd)
 	return true;
 }
 
-/* Returns value in KHz */
-static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
-	u32 freq)
+static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
+			    u32 center_freq_khz,
+			    u32 bw_khz)
 {
-	unsigned int i;
-	for (i = 0; i < ARRAY_SIZE(supported_bandwidths); i++) {
-		u32 start_freq_khz = freq - supported_bandwidths[i]/2;
-		u32 end_freq_khz = freq + supported_bandwidths[i]/2;
-		if (start_freq_khz >= freq_range->start_freq_khz &&
-			end_freq_khz <= freq_range->end_freq_khz)
-			return supported_bandwidths[i];
-	}
-	return 0;
+	u32 start_freq_khz, end_freq_khz;
+
+	start_freq_khz = center_freq_khz - (bw_khz/2);
+	end_freq_khz = center_freq_khz + (bw_khz/2);
+
+	if (start_freq_khz >= freq_range->start_freq_khz &&
+	    end_freq_khz <= freq_range->end_freq_khz)
+		return true;
+
+	return false;
 }
 
 /**
@@ -843,14 +838,17 @@ static u32 map_regdom_flags(u32 rd_flags)
 
 static int freq_reg_info_regd(struct wiphy *wiphy,
 			      u32 center_freq,
-			      u32 *bandwidth,
+			      u32 desired_bw_khz,
 			      const struct ieee80211_reg_rule **reg_rule,
 			      const struct ieee80211_regdomain *custom_regd)
 {
 	int i;
 	bool band_rule_found = false;
 	const struct ieee80211_regdomain *regd;
-	u32 max_bandwidth = 0;
+	bool bw_fits = false;
+
+	if (!desired_bw_khz)
+		desired_bw_khz = MHZ_TO_KHZ(20);
 
 	regd = custom_regd ? custom_regd : cfg80211_regdomain;
 
@@ -883,37 +881,53 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		max_bandwidth = freq_max_bandwidth(fr, center_freq);
+		bw_fits = reg_does_bw_fit(fr,
+					  center_freq,
+					  desired_bw_khz);
 
-		if (max_bandwidth && *bandwidth <= max_bandwidth) {
+		if (band_rule_found && bw_fits) {
 			*reg_rule = rr;
-			*bandwidth = max_bandwidth;
-			break;
+			return 0;
 		}
 	}
 
 	if (!band_rule_found)
 		return -ERANGE;
 
-	return !max_bandwidth;
+	return -EINVAL;
 }
 EXPORT_SYMBOL(freq_reg_info);
 
-int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
-			 const struct ieee80211_reg_rule **reg_rule)
+int freq_reg_info(struct wiphy *wiphy,
+		  u32 center_freq,
+		  u32 desired_bw_khz,
+		  const struct ieee80211_reg_rule **reg_rule)
 {
-	return freq_reg_info_regd(wiphy, center_freq,
-		bandwidth, reg_rule, NULL);
+	return freq_reg_info_regd(wiphy,
+				  center_freq,
+				  desired_bw_khz,
+				  reg_rule,
+				  NULL);
 }
 
+/*
+ * Note that right now we assume the desired channel bandwidth
+ * is always 20 MHz for each individual channel (HT40 uses 20 MHz
+ * per channel, the primary and the extension channel). To support
+ * smaller custom bandwidths such as 5 MHz or 10 MHz we'll need a
+ * new ieee80211_channel.target_bw and re run the regulatory check
+ * on the wiphy with the target_bw specified. Then we can simply use
+ * that below for the desired_bw_khz below.
+ */
 static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 			   unsigned int chan_idx)
 {
 	int r;
-	u32 flags;
-	u32 max_bandwidth = 0;
+	u32 flags, bw_flags = 0;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	const struct ieee80211_freq_range *freq_range = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 	struct wiphy *request_wiphy = NULL;
@@ -928,8 +942,10 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 
 	flags = chan->orig_flags;
 
-	r = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq),
-		&max_bandwidth, &reg_rule);
+	r = freq_reg_info(wiphy,
+			  MHZ_TO_KHZ(chan->center_freq),
+			  desired_bw_khz,
+			  &reg_rule);
 
 	if (r) {
 		/*
@@ -972,6 +988,10 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	}
 
 	power_rule = &reg_rule->power_rule;
+	freq_range = &reg_rule->freq_range;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+		bw_flags = IEEE80211_CHAN_NO_HT40;
 
 	if (last_request->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
@@ -982,19 +1002,19 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		 * settings
 		 */
 		chan->flags = chan->orig_flags =
-			map_regdom_flags(reg_rule->flags);
+			map_regdom_flags(reg_rule->flags) | bw_flags;
 		chan->max_antenna_gain = chan->orig_mag =
 			(int) MBI_TO_DBI(power_rule->max_antenna_gain);
-		chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
+		chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 		chan->max_power = chan->orig_mpwr =
 			(int) MBM_TO_DBM(power_rule->max_eirp);
 		return;
 	}
 
-	chan->flags = flags | map_regdom_flags(reg_rule->flags);
+	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
+	chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 	if (chan->orig_mpwr)
 		chan->max_power = min(chan->orig_mpwr,
 			(int) MBM_TO_DBM(power_rule->max_eirp));
@@ -1142,6 +1162,84 @@ static void reg_process_beacons(struct wiphy *wiphy)
 	wiphy_update_beacon_reg(wiphy);
 }
 
+static void reg_process_ht_flags_channel(struct wiphy *wiphy,
+					 enum ieee80211_band band,
+					 unsigned int chan_idx)
+{
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *channel, *channel_before, *channel_after;
+	unsigned int i;
+
+	assert_cfg80211_lock();
+
+	sband = wiphy->bands[band];
+	BUG_ON(chan_idx >= sband->n_channels);
+	channel = &sband->channels[chan_idx];
+
+	if (channel->flags &
+	    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_HT40)) {
+		channel->flags |= IEEE80211_CHAN_NO_FAT_ABOVE |
+				  IEEE80211_CHAN_NO_FAT_BELOW;
+		return;
+	}
+
+	/*
+	 * We need to ensure the extension channels exist to
+	 * be able to use HT40- or HT40+, this finds them (or not)
+	 */
+	for (i = 0; i < sband->n_channels; i++) {
+		struct ieee80211_channel *c = &sband->channels[i];
+		if (c->center_freq == (channel->center_freq - 20))
+			channel_before = c;
+		if (c->center_freq == (channel->center_freq + 20))
+			channel_after = c;
+	}
+
+	/*
+	 * Please note that this assumes target bandwidth is 20 MHz,
+	 * if that ever changes we also need to change the below logic
+	 * to include that as well.
+	 */
+	if (!channel_before || (channel_before->flags &
+	    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_HT40)))
+		channel->flags |= IEEE80211_CHAN_NO_FAT_BELOW;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_FAT_BELOW;
+
+	if (!channel_after || (channel_after->flags &
+	    (IEEE80211_CHAN_DISABLED | IEEE80211_CHAN_NO_HT40)))
+		channel->flags |= IEEE80211_CHAN_NO_FAT_ABOVE;
+	else
+		channel->flags &= ~IEEE80211_CHAN_NO_FAT_ABOVE;
+}
+
+static void reg_process_ht_flags_band(struct wiphy *wiphy,
+				      enum ieee80211_band band)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	BUG_ON(!wiphy->bands[band]);
+	sband = wiphy->bands[band];
+
+	for (i = 0; i < sband->n_channels; i++)
+		reg_process_ht_flags_channel(wiphy, band, i);
+}
+
+static void reg_process_ht_flags(struct wiphy *wiphy)
+{
+	enum ieee80211_band band;
+
+	if (!wiphy)
+		return;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (wiphy->bands[band])
+			reg_process_ht_flags_band(wiphy, band);
+	}
+
+}
+
 void wiphy_update_regulatory(struct wiphy *wiphy,
 			     enum nl80211_reg_initiator initiator)
 {
@@ -1155,6 +1253,7 @@ void wiphy_update_regulatory(struct wiphy *wiphy,
 	}
 out:
 	reg_process_beacons(wiphy);
+	reg_process_ht_flags(wiphy);
 	if (wiphy->reg_notifier)
 		wiphy->reg_notifier(wiphy, last_request);
 }
@@ -1165,9 +1264,11 @@ static void handle_channel_custom(struct wiphy *wiphy,
 				  const struct ieee80211_regdomain *regd)
 {
 	int r;
-	u32 max_bandwidth = 0;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
+	u32 bw_flags = 0;
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
+	const struct ieee80211_freq_range *freq_range = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
 
@@ -1175,8 +1276,11 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	BUG_ON(chan_idx >= sband->n_channels);
 	chan = &sband->channels[chan_idx];
 
-	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-		&max_bandwidth, &reg_rule, regd);
+	r = freq_reg_info_regd(wiphy,
+			       MHZ_TO_KHZ(chan->center_freq),
+			       desired_bw_khz,
+			       &reg_rule,
+			       regd);
 
 	if (r) {
 		chan->flags = IEEE80211_CHAN_DISABLED;
@@ -1184,10 +1288,16 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	}
 
 	power_rule = &reg_rule->power_rule;
+	freq_range = &reg_rule->freq_range;
+
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
+		bw_flags = IEEE80211_CHAN_NO_HT40 |
+			   IEEE80211_CHAN_NO_FAT_BELOW |
+			   IEEE80211_CHAN_NO_FAT_ABOVE;
 
-	chan->flags |= map_regdom_flags(reg_rule->flags);
+	chan->flags |= map_regdom_flags(reg_rule->flags) | bw_flags;
 	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
-	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
+	chan->max_bandwidth = KHZ_TO_MHZ(desired_bw_khz);
 	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-- 
1.6.0.6

