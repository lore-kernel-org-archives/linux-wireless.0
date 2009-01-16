Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:11001 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932710AbZAPANC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 19:13:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 15 Jan 2009 16:13:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
Date: Thu, 15 Jan 2009 16:12:16 -0800
Message-ID: <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> (sfid-20090116_011328_255277_4B10C4AB)
In-Reply-To: <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds wiphy_apply_custom_regulatory() to be used by drivers
prior to wiphy registration to apply a custom regulatory domain.
This can be used by drivers that do not have a direct 1-1 mapping
between a regulatory domain and a country.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |    4 ++
 include/net/wireless.h |   17 +++++++
 net/wireless/reg.c     |  120 ++++++++++++++++++++++++++++++++++++++----------
 3 files changed, 117 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index df78abc..6bab7a1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -338,6 +338,9 @@ struct bss_parameters {
 
 /**
  * enum reg_set_by - Indicates who is trying to set the regulatory domain
+ * @REGDOM_SET_BY_PROBE: regulatory domain applied came prior to wiphy
+ * 	registration by the driver itself using some custom regulatory
+ * 	information.
  * @REGDOM_SET_BY_INIT: regulatory domain was set by initialization. We will be
  * 	using a static world regulatory domain by default.
  * @REGDOM_SET_BY_CORE: Core queried CRDA for a dynamic world regulatory domain.
@@ -350,6 +353,7 @@ struct bss_parameters {
  *	should consider.
  */
 enum reg_set_by {
+	REGDOM_SET_BY_PROBE,
 	REGDOM_SET_BY_INIT,
 	REGDOM_SET_BY_CORE,
 	REGDOM_SET_BY_USER,
diff --git a/include/net/wireless.h b/include/net/wireless.h
index ea89958..b724519 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -405,4 +405,21 @@ extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
 extern void regulatory_hint_11d(struct wiphy *wiphy,
 				u8 *country_ie,
 				u8 country_ie_len);
+
+/**
+ * wiphy_apply_custom_regulatory - apply a custom driver regulatory domain
+ * @wiphy: the wireless device we want to process the regulatory domain on
+ * @regd: the custom regulatory domain to use for this wiphy
+ *
+ * Drivers can sometimes have custom regulatory domains which do not apply
+ * to a specific country. Drivers can use this to apply such custom regulatory
+ * domains. This routine must be called prior to wiphy registration. The
+ * custom regulatory domain will be trusted completely and as such previous
+ * default channel settings will be disregarded. If no rule is found for a
+ * channel on the regulatory domain the channel will be disabled.
+ */
+extern void wiphy_apply_custom_regulatory(
+	struct wiphy *wiphy,
+	const struct ieee80211_regdomain *regd);
+
 #endif /* __NET_WIRELESS_H */
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 01da946..4793d22 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -796,36 +796,17 @@ static int reg_follow_driver_regd(struct wiphy *wiphy)
 	return false;
 }
 
-/**
- * freq_reg_info - get regulatory information for the given frequency
- * @wiphy: the wiphy for which we want to process this rule for
- * @center_freq: Frequency in KHz for which we want regulatory information for
- * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
- * 	you can set this to 0. If this frequency is allowed we then set
- * 	this value to the maximum allowed bandwidth.
- * @reg_rule: the regulatory rule which we have for this frequency
- *
- * Use this function to get the regulatory rule for a specific frequency on
- * a given wireless device. If the device has a specific regulatory domain
- * it wants to follow we respect that unless a country IE has been received
- * and processed already.
- *
- * Returns 0 if it was able to find a valid regulatory rule which does
- * apply to the given center_freq otherwise it returns non-zero. It will
- * also return -ERANGE if we determine the given center_freq does not even have
- * a regulatory rule for a frequency range in the center_freq's band. See
- * freq_in_rule_band() for our current definition of a band -- this is purely
- * subjective and right now its 802.11 specific.
- */
-static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
-			 const struct ieee80211_reg_rule **reg_rule)
+static int freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+		       u32 *bandwidth,
+		       const struct ieee80211_reg_rule **reg_rule,
+		       const struct ieee80211_regdomain *custom_regd)
 {
 	int i;
 	bool band_rule_found = false;
 	const struct ieee80211_regdomain *regd;
 	u32 max_bandwidth = 0;
 
-	regd = cfg80211_regdomain;
+	regd = custom_regd ? custom_regd : cfg80211_regdomain;
 
 	/* Follow the driver's regulatory domain, if present, unless a country
 	 * IE has been processed */
@@ -866,6 +847,34 @@ static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 	return !max_bandwidth;
 }
 
+/**
+ * freq_reg_info - get regulatory information for the given frequency
+ * @wiphy: the wiphy for which we want to process this rule for
+ * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
+ * 	you can set this to 0. If this frequency is allowed we then set
+ * 	this value to the maximum allowed bandwidth.
+ * @reg_rule: the regulatory rule which we have for this frequency
+ *
+ * Use this function to get the regulatory rule for a specific frequency on
+ * a given wireless device. If the device has a specific regulatory domain
+ * it wants to follow we respect that unless a country IE has been received
+ * and processed already.
+ *
+ * Returns 0 if it was able to find a valid regulatory rule which does
+ * apply to the given center_freq otherwise it returns non-zero. It will
+ * also return -ERANGE if we determine the given center_freq does not even have
+ * a regulatory rule for a frequency range in the center_freq's band. See
+ * freq_in_rule_band() for our current definition of a band -- this is purely
+ * subjective and right now its 802.11 specific.
+ */
+static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
+			 const struct ieee80211_reg_rule **reg_rule)
+{
+	return freq_reg_info_regd(wiphy, center_freq,
+		bandwidth, reg_rule, NULL);
+}
+
 static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 			   unsigned int chan_idx)
 {
@@ -935,6 +944,39 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
+static void handle_channel_custom(struct wiphy *wiphy,
+				  enum ieee80211_band band,
+				  unsigned int chan_idx,
+				  const struct ieee80211_regdomain *regd)
+{
+	int r;
+	u32 max_bandwidth = 0;
+	const struct ieee80211_reg_rule *reg_rule = NULL;
+	const struct ieee80211_power_rule *power_rule = NULL;
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+
+	sband = wiphy->bands[band];
+	BUG_ON(chan_idx >= sband->n_channels);
+	chan = &sband->channels[chan_idx];
+
+	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
+		&max_bandwidth, &reg_rule, regd);
+
+	if (r) {
+		chan->flags = IEEE80211_CHAN_DISABLED;
+		return;
+	}
+
+	power_rule = &reg_rule->power_rule;
+
+	chan->flags |= map_regdom_flags(reg_rule->flags);
+	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
+	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
+	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
+}
+
+
 static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
 {
 	unsigned int i;
@@ -947,6 +989,19 @@ static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
 		handle_channel(wiphy, band, i);
 }
 
+static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
+			       const struct ieee80211_regdomain *regd)
+{
+	unsigned int i;
+	struct ieee80211_supported_band *sband;
+
+	BUG_ON(!wiphy->bands[band]);
+	sband = wiphy->bands[band];
+
+	for (i = 0; i < sband->n_channels; i++)
+		handle_channel_custom(wiphy, band, i, regd);
+}
+
 static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 {
 	if (!last_request)
@@ -977,6 +1032,20 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
 		wiphy->reg_notifier(wiphy, setby);
 }
 
+/* Used by drivers prior to wiphy registration */
+void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
+				   const struct ieee80211_regdomain *regd)
+{
+	enum ieee80211_band band;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (wiphy->bands[band])
+			handle_band_custom(wiphy, band, regd);
+	}
+	if (wiphy->reg_notifier)
+		wiphy->reg_notifier(wiphy, REGDOM_SET_BY_PROBE);
+}
+EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
+
 static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 			 const struct ieee80211_regdomain *src_regd)
 {
@@ -1015,6 +1084,9 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 		return 0;
 
 	switch (set_by) {
+	case REGDOM_SET_BY_PROBE:
+		BUG_ON(1);
+		return -EINVAL;
 	case REGDOM_SET_BY_INIT:
 		return -EINVAL;
 	case REGDOM_SET_BY_CORE:
-- 
1.6.1.rc3.51.g5832d

