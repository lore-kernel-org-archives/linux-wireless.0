Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:60037 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaBQNXM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Feb 2014 08:23:12 -0500
Received: by mail-ee0-f45.google.com with SMTP id b15so6968284eek.18
        for <linux-wireless@vger.kernel.org>; Mon, 17 Feb 2014 05:23:10 -0800 (PST)
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
	jan-niklas.meier@volkswagen.de, Rostislav Lisovy <lisovy@gmail.com>
Subject: [RFC 1/4] mac80211: Allow 5/10 MHz channel setting (for OCB)
Date: Mon, 17 Feb 2014 14:22:51 +0100
Message-Id: <1392643374-3545-2-git-send-email-lisovy@gmail.com> (sfid-20140217_142318_427065_0BC0F308)
In-Reply-To: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
References: <1392643374-3545-1-git-send-email-lisovy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
---
 include/net/cfg80211.h       |  19 ++++++-
 include/net/mac80211.h       |   4 +-
 include/uapi/linux/nl80211.h |  17 ++++++-
 net/wireless/chan.c          |   8 +++
 net/wireless/core.c          |   3 --
 net/wireless/nl80211.c       |  14 ++++++
 net/wireless/reg.c           | 115 ++++++++++++++++++++++++++++++++++++++-----
 7 files changed, 161 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 3eae46c..14f8cc1 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -110,6 +110,11 @@ enum ieee80211_band {
  *	channel as the control or any of the secondary channels.
  *	This may be due to the driver or due to regulatory bandwidth
  *	restrictions.
+ * @IEEE80211_CHAN_NO_20MHZ: 20 MHz bandwidth is not permitted
+ *     on this channel.
+ * @IEEE80211_CHAN_NO_10MHZ: 10 MHz bandwidth is not permitted
+ *     on this channel.
+ * @IEEE80211_CHAN_OCB_ONLY: only OCB is allowed on this channel.
  */
 enum ieee80211_channel_flags {
 	IEEE80211_CHAN_DISABLED		= 1<<0,
@@ -121,6 +126,9 @@ enum ieee80211_channel_flags {
 	IEEE80211_CHAN_NO_OFDM		= 1<<6,
 	IEEE80211_CHAN_NO_80MHZ		= 1<<7,
 	IEEE80211_CHAN_NO_160MHZ	= 1<<8,
+	IEEE80211_CHAN_NO_20MHZ		= 1<<9,
+	IEEE80211_CHAN_NO_10MHZ		= 1<<10,
+	IEEE80211_CHAN_OCB_ONLY		= 1<<11,
 };
 
 #define IEEE80211_CHAN_NO_HT40 \
@@ -362,6 +370,10 @@ static inline enum nl80211_channel_type
 cfg80211_get_chandef_type(const struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+		return NL80211_CHAN_5MHZ;
+	case NL80211_CHAN_WIDTH_10:
+		return NL80211_CHAN_10MHZ;
 	case NL80211_CHAN_WIDTH_20_NOHT:
 		return NL80211_CHAN_NO_HT;
 	case NL80211_CHAN_WIDTH_20:
@@ -3480,6 +3492,10 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * freq_reg_info - get regulatory information for the given frequency
  * @wiphy: the wiphy for which we want to process this rule for
  * @center_freq: Frequency in KHz for which we want regulatory information for
+ * @desired_bw_khz: the desired max bandwidth you want to use per
+ *	channel. Note that this is still 20 MHz if you want to use HT40
+ *	as HT40 makes use of two channels for its 40 MHz width bandwidth.
+ *	If set to 0 we'll assume you want the standard 20 MHz.
  *
  * Use this function to get the regulatory rule for a specific frequency on
  * a given wireless device. If the device has a specific regulatory domain
@@ -3495,7 +3511,8 @@ void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
  * purely subjective and right now it's 802.11 specific.
  */
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq);
+					       u32 center_freq,
+					       u32 desired_bw_khz);
 
 /**
  * reg_initiator_name - map regulatory request initiator enum to name
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 7ceed99..01c8a1f 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -517,6 +517,8 @@ enum mac80211_tx_info_flags {
  */
 enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_PORT_CTRL_PROTO	= BIT(0),
+	IEEE80211_TX_CTL_10MHZ			= BIT(1),
+	IEEE80211_TX_CTL_5MHZ			= BIT(2),
 };
 
 /*
@@ -4516,7 +4518,7 @@ conf_is_ht40(struct ieee80211_conf *conf)
 static inline bool
 conf_is_ht(struct ieee80211_conf *conf)
 {
-	return conf->chandef.width != NL80211_CHAN_WIDTH_20_NOHT;
+	return conf_is_ht20(conf) || conf_is_ht40(conf);
 }
 
 static inline enum nl80211_iftype
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f752e98..f2d3f67 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2246,6 +2246,14 @@ enum nl80211_band_attr {
  * @NL80211_FREQUENCY_ATTR_NO_160MHZ: any 160 MHz (but not 80+80) channel
  *	using this channel as the primary or any of the secondary channels
  *	isn't possible
+ * @NL80211_FREQUENCY_ATTR_NO_20MHZ: 20 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ *     - this still allows 10 MHz and 5 MHz operation
+ * @NL80211_FREQUENCY_ATTR_NO_10MHZ: 10 MHz operation is not allowed
+ *     on this channel in current regulatory domain.
+ *     - this still allows 20 MHz and 5 MHz operation
+ * @NL80211_FREQUENCY_ATTR_OCB_ONLY: no other than OCB networks are
+ *	permitted on this channel in current regulatory domain.
  * @NL80211_FREQUENCY_ATTR_MAX: highest frequency attribute number
  *	currently defined
  * @__NL80211_FREQUENCY_ATTR_AFTER_LAST: internal use
@@ -2264,6 +2272,9 @@ enum nl80211_frequency_attr {
 	NL80211_FREQUENCY_ATTR_NO_HT40_PLUS,
 	NL80211_FREQUENCY_ATTR_NO_80MHZ,
 	NL80211_FREQUENCY_ATTR_NO_160MHZ,
+	NL80211_FREQUENCY_ATTR_NO_20MHZ,
+	NL80211_FREQUENCY_ATTR_NO_10MHZ,
+	NL80211_FREQUENCY_ATTR_OCB_ONLY,
 
 	/* keep last */
 	__NL80211_FREQUENCY_ATTR_AFTER_LAST,
@@ -2822,12 +2833,16 @@ enum nl80211_ac {
  *	below the control channel
  * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
  *	above the control channel
+ * @NL80211_CHAN_5MHZ: normal, 5 MHz bandwidth
+ * @NL80211_CHAN_10MHZ: normal, 10 MHz bandwidth
  */
 enum nl80211_channel_type {
 	NL80211_CHAN_NO_HT,
 	NL80211_CHAN_HT20,
 	NL80211_CHAN_HT40MINUS,
-	NL80211_CHAN_HT40PLUS
+	NL80211_CHAN_HT40PLUS,
+	NL80211_CHAN_5MHZ,
+	NL80211_CHAN_10MHZ,
 };
 
 /**
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 9b8cc87..729a30c 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -22,6 +22,14 @@ void cfg80211_chandef_create(struct cfg80211_chan_def *chandef,
 	chandef->center_freq2 = 0;
 
 	switch (chan_type) {
+	case NL80211_CHAN_5MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_5;
+		chandef->center_freq1 = chan->center_freq;
+		break;
+	case NL80211_CHAN_10MHZ:
+		chandef->width = NL80211_CHAN_WIDTH_10;
+		chandef->center_freq1 = chan->center_freq;
+		break;
 	case NL80211_CHAN_NO_HT:
 		chandef->width = NL80211_CHAN_WIDTH_20_NOHT;
 		chandef->center_freq1 = chan->center_freq;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 52b865f..507e71f 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -451,9 +451,6 @@ int wiphy_register(struct wiphy *wiphy)
 	int i;
 	u16 ifmodes = wiphy->interface_modes;
 
-	/* support for 5/10 MHz is broken due to nl80211 API mess - disable */
-	wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_5_10_MHZ;
-
 	/*
 	 * There are major locking problems in nl80211/mac80211 for CSA,
 	 * disable for all drivers until this has been reworked.
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 138dc3b..a62d716 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -570,6 +570,16 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 	if ((chan->flags & IEEE80211_CHAN_NO_IBSS) &&
 	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_IBSS))
 		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
+		goto nla_put_failure;
+	if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
+		goto nla_put_failure;
+
+	if ((chan->flags & IEEE80211_CHAN_OCB_ONLY) &&
+	    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_OCB_ONLY))
+		goto nla_put_failure;
 	if (chan->flags & IEEE80211_CHAN_RADAR) {
 		if (nla_put_flag(msg, NL80211_FREQUENCY_ATTR_RADAR))
 			goto nla_put_failure;
@@ -1800,6 +1810,8 @@ static int nl80211_parse_chandef(struct cfg80211_registered_device *rdev,
 				info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]);
 
 		switch (chantype) {
+		case NL80211_CHAN_5MHZ:
+		case NL80211_CHAN_10MHZ:
 		case NL80211_CHAN_NO_HT:
 		case NL80211_CHAN_HT20:
 		case NL80211_CHAN_HT40PLUS:
@@ -2195,6 +2207,8 @@ static int nl80211_send_chandef(struct sk_buff *msg,
 			chandef->chan->center_freq))
 		return -ENOBUFS;
 	switch (chandef->width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
 	case NL80211_CHAN_WIDTH_20_NOHT:
 	case NL80211_CHAN_WIDTH_20:
 	case NL80211_CHAN_WIDTH_40:
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7da67fd..992432c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -710,13 +710,17 @@ static u32 map_regdom_flags(u32 rd_flags)
 }
 
 static const struct ieee80211_reg_rule *
-freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+freq_reg_info_regd(struct wiphy *wiphy,
+		   u32 center_freq, u32 desired_bw_khz,
 		   const struct ieee80211_regdomain *regd)
 {
 	int i;
 	bool band_rule_found = false;
 	bool bw_fits = false;
 
+	if (!desired_bw_khz)
+		desired_bw_khz = MHZ_TO_KHZ(20);
+
 	if (!regd)
 		return ERR_PTR(-EINVAL);
 
@@ -735,7 +739,16 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, desired_bw_khz);
+
+		if (band_rule_found && bw_fits) {
+			u32 allowed_bw = regd->reg_rules[i].freq_range.max_bandwidth_khz;
+			if (desired_bw_khz > allowed_bw) {
+				return ERR_PTR(-ENOENT);
+			} else {
+				return rr;
+			}
+		}
 
 		if (band_rule_found && bw_fits)
 			return rr;
@@ -748,7 +761,8 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 }
 
 const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
-					       u32 center_freq)
+					       u32 center_freq,
+					       u32 desired_bw_khz)
 {
 	const struct ieee80211_regdomain *regd;
 	struct regulatory_request *lr = get_last_request();
@@ -764,7 +778,7 @@ const struct ieee80211_reg_rule *freq_reg_info(struct wiphy *wiphy,
 	else
 		regd = get_cfg80211_regdom();
 
-	return freq_reg_info_regd(wiphy, center_freq, regd);
+	return freq_reg_info_regd(wiphy, center_freq, desired_bw_khz, regd);
 }
 EXPORT_SYMBOL(freq_reg_info);
 
@@ -788,6 +802,7 @@ EXPORT_SYMBOL(reg_initiator_name);
 
 #ifdef CONFIG_CFG80211_REG_DEBUG
 static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+				    u32 desired_bw_khz,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	const struct ieee80211_power_rule *power_rule;
@@ -802,8 +817,8 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 	else
 		snprintf(max_antenna_gain, 32, "%d", power_rule->max_antenna_gain);
 
-	REG_DBG_PRINT("Updating information on frequency %d MHz with regulatory rule:\n",
-		      chan->center_freq);
+	REG_DBG_PRINT("Updating information on frequency %d MHz for a %d MHz width channel with regulatory rule:\n",
+		      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
 
 	REG_DBG_PRINT("%d KHz - %d KHz @ %d KHz), (%s mBi, %d mBm)\n",
 		      freq_range->start_freq_khz, freq_range->end_freq_khz,
@@ -812,6 +827,7 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 }
 #else
 static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
+				    u32 desired_bw_khz,
 				    const struct ieee80211_reg_rule *reg_rule)
 {
 	return;
@@ -821,13 +837,18 @@ static void chan_reg_rule_print_dbg(struct ieee80211_channel *chan,
 /*
  * Note that right now we assume the desired channel bandwidth
  * is always 20 MHz for each individual channel (HT40 uses 20 MHz
- * per channel, the primary and the extension channel).
+ * per channel, the primary and the extension channel). To support
+ * smaller custom bandwidths such as 5 MHz or 10 MHz we'll need a
+ * new ieee80211_channel.target_bw and re run the regulatory check
+ * on the wiphy with the target_bw specified. Then we can simply use
+ * that below for the desired_bw_khz below.
  */
 static void handle_channel(struct wiphy *wiphy,
 			   enum nl80211_reg_initiator initiator,
 			   struct ieee80211_channel *chan)
 {
 	u32 flags, bw_flags = 0;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
@@ -838,7 +859,33 @@ static void handle_channel(struct wiphy *wiphy,
 
 	flags = chan->orig_flags;
 
-	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq));
+	do {
+		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
+		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
+			bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+		} else {
+			break;
+		}
+
+		/* check for 10 MHz BW */
+		desired_bw_khz = MHZ_TO_KHZ(10);
+		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
+		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
+			bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+		} else {
+			break;
+		}
+
+		/* check for 5 MHz BW */
+		desired_bw_khz = MHZ_TO_KHZ(5);
+		reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(chan->center_freq), desired_bw_khz);
+		if ((IS_ERR(reg_rule)) && ((u32)reg_rule == -ENOENT)) {
+
+		} else {
+			break;
+		}
+	} while (0);
+
 	if (IS_ERR(reg_rule)) {
 		/*
 		 * We will disable all channels that do not match our
@@ -859,11 +906,15 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, reg_rule);
+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
@@ -871,9 +922,18 @@ static void handle_channel(struct wiphy *wiphy,
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(160))
 		bw_flags |= IEEE80211_CHAN_NO_160MHZ;
 
+#if 0
 	if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
+#else
+	/*
+	 * FIXME FIXME FIXME
+	 * we always want to use the last requested reg domain
+	 * do NOT use old values as a base
+	 */
+	if (1) {
+#endif
 		/*
 		 * This guarantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
@@ -1253,25 +1313,54 @@ static void handle_channel_custom(struct wiphy *wiphy,
 				  const struct ieee80211_regdomain *regd)
 {
 	u32 bw_flags = 0;
+	u32 desired_bw_khz = MHZ_TO_KHZ(20);
 	const struct ieee80211_reg_rule *reg_rule = NULL;
 	const struct ieee80211_power_rule *power_rule = NULL;
 	const struct ieee80211_freq_range *freq_range = NULL;
 
 	reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
-				      regd);
+				      desired_bw_khz, regd);
+
+	if ((IS_ERR(reg_rule)) && !(PTR_ERR(reg_rule) == -ERANGE &&
+		    last_request->initiator ==
+		    NL80211_REGDOM_SET_BY_COUNTRY_IE)) { /* FFIXME Wat? */
+		/*
+		 * if 20 MHz BW is not ok apply further tests
+		 * avoid catching the below exception (-ERANGE...) to exhibit
+		 * exactly the same behaviour (not disable anything in this case)
+		 * "bw_flags" have to be used to impose restrictions because "flags"
+		 * is only applied in case of disabling the whole channel!
+		 */
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
+
+		/* check for 10 MHz BW */
+		reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
+					      MHZ_TO_KHZ(10), regd);
+		if (IS_ERR(reg_rule)) {
+			bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+		}
+
+		/* check for 5 MHz BW */
+		reg_rule = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
+					      MHZ_TO_KHZ(5), regd);
+	}
 
 	if (IS_ERR(reg_rule)) {
-		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
-			      chan->center_freq);
+		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits a %d MHz wide channel\n",
+			      chan->center_freq, KHZ_TO_MHZ(desired_bw_khz));
 		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
-	chan_reg_rule_print_dbg(chan, reg_rule);
+	chan_reg_rule_print_dbg(chan, desired_bw_khz, reg_rule);
 
 	power_rule = &reg_rule->power_rule;
 	freq_range = &reg_rule->freq_range;
 
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(10))
+		bw_flags |= IEEE80211_CHAN_NO_10MHZ;
+	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(20))
+		bw_flags |= IEEE80211_CHAN_NO_20MHZ;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
 		bw_flags = IEEE80211_CHAN_NO_HT40;
 	if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(80))
-- 
1.8.5.1

