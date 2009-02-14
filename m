Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:27455 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213AbZBNFep (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 00:34:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 21:34:45 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 10/10] cfg80211: comments style cleanup
Date: Fri, 13 Feb 2009 21:33:47 -0800
Message-ID: <1234589627-16977-11-git-send-email-lrodriguez@atheros.com> (sfid-20090214_065318_952387_021C1C75)
In-Reply-To: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
References: <1234589627-16977-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |  299 ++++++++++++++++++++++++++++++++++-----------------
 1 files changed, 199 insertions(+), 100 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6c8c719..9dce86a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -54,14 +54,18 @@ static u32 supported_bandwidths[] = {
 	MHZ_TO_KHZ(20),
 };
 
-/* Central wireless core regulatory domains, we only need two,
+/*
+ * Central wireless core regulatory domains, we only need two,
  * the current one and a world regulatory domain in case we have no
- * information to give us an alpha2 */
+ * information to give us an alpha2
+ */
 const struct ieee80211_regdomain *cfg80211_regdomain;
 
-/* We use this as a place for the rd structure built from the
+/*
+ * We use this as a place for the rd structure built from the
  * last parsed country IE to rest until CRDA gets back to us with
- * what it thinks should apply for the same country */
+ * what it thinks should apply for the same country
+ */
 static const struct ieee80211_regdomain *country_ie_regdomain;
 
 static LIST_HEAD(reg_requests_list);
@@ -95,9 +99,11 @@ static char *ieee80211_regdom = "US";
 module_param(ieee80211_regdom, charp, 0444);
 MODULE_PARM_DESC(ieee80211_regdom, "IEEE 802.11 regulatory domain code");
 
-/* We assume 40 MHz bandwidth for the old regulatory work.
+/*
+ * We assume 40 MHz bandwidth for the old regulatory work.
  * We make emphasis we are using the exact same frequencies
- * as before */
+ * as before
+ */
 
 static const struct ieee80211_regdomain us_regdom = {
 	.n_reg_rules = 6,
@@ -136,8 +142,10 @@ static const struct ieee80211_regdomain jp_regdom = {
 
 static const struct ieee80211_regdomain eu_regdom = {
 	.n_reg_rules = 6,
-	/* This alpha2 is bogus, we leave it here just for stupid
-	 * backward compatibility */
+	/*
+	 * This alpha2 is bogus, we leave it here just for stupid
+	 * backward compatibility
+	 */
 	.alpha2 =  "EU",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..13 */
@@ -206,8 +214,10 @@ static void reset_regdomains(void)
 	cfg80211_regdomain = NULL;
 }
 
-/* Dynamic world regulatory domain requested by the wireless
- * core upon initialization */
+/*
+ * Dynamic world regulatory domain requested by the wireless
+ * core upon initialization
+ */
 static void update_world_regdomain(const struct ieee80211_regdomain *rd)
 {
 	BUG_ON(!last_request);
@@ -248,8 +258,10 @@ static bool is_unknown_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	/* Special case where regulatory domain was built by driver
-	 * but a specific alpha2 cannot be determined */
+	/*
+	 * Special case where regulatory domain was built by driver
+	 * but a specific alpha2 cannot be determined
+	 */
 	if (alpha2[0] == '9' && alpha2[1] == '9')
 		return true;
 	return false;
@@ -259,9 +271,11 @@ static bool is_intersected_alpha2(const char *alpha2)
 {
 	if (!alpha2)
 		return false;
-	/* Special case where regulatory domain is the
+	/*
+	 * Special case where regulatory domain is the
 	 * result of an intersection between two regulatory domain
-	 * structures */
+	 * structures
+	 */
 	if (alpha2[0] == '9' && alpha2[1] == '8')
 		return true;
 	return false;
@@ -314,8 +328,10 @@ static bool country_ie_integrity_changes(u32 checksum)
 	return false;
 }
 
-/* This lets us keep regulatory code which is updated on a regulatory
- * basis in userspace. */
+/*
+ * This lets us keep regulatory code which is updated on a regulatory
+ * basis in userspace.
+ */
 static int call_crda(const char *alpha2)
 {
 	char country_env[9 + 2] = "COUNTRY=";
@@ -426,10 +442,12 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 #undef ONE_GHZ_IN_KHZ
 }
 
-/* Converts a country IE to a regulatory domain. A regulatory domain
+/*
+ * Converts a country IE to a regulatory domain. A regulatory domain
  * structure has a lot of information which the IE doesn't yet have,
  * so for the other values we use upper max values as we will intersect
- * with our userspace regulatory agent to get lower bounds. */
+ * with our userspace regulatory agent to get lower bounds.
+ */
 static struct ieee80211_regdomain *country_ie_2_rd(
 				u8 *country_ie,
 				u8 country_ie_len,
@@ -474,9 +492,11 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 
 	*checksum ^= ((flags ^ alpha2[0] ^ alpha2[1]) << 8);
 
-	/* We need to build a reg rule for each triplet, but first we must
+	/*
+	 * We need to build a reg rule for each triplet, but first we must
 	 * calculate the number of reg rules we will need. We will need one
-	 * for each channel subband */
+	 * for each channel subband
+	 */
 	while (country_ie_len >= 3) {
 		int end_channel = 0;
 		struct ieee80211_country_ie_triplet *triplet =
@@ -514,9 +534,11 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		if (cur_sub_max_channel < cur_channel)
 			return NULL;
 
-		/* Do not allow overlapping channels. Also channels
+		/*
+		 * Do not allow overlapping channels. Also channels
 		 * passed in each subband must be monotonically
-		 * increasing */
+		 * increasing
+		 */
 		if (last_sub_max_channel) {
 			if (cur_channel <= last_sub_max_channel)
 				return NULL;
@@ -524,10 +546,12 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 				return NULL;
 		}
 
-		/* When dot11RegulatoryClassesRequired is supported
+		/*
+		 * When dot11RegulatoryClassesRequired is supported
 		 * we can throw ext triplets as part of this soup,
 		 * for now we don't care when those change as we
-		 * don't support them */
+		 * don't support them
+		 */
 		*checksum ^= ((cur_channel ^ cur_sub_max_channel) << 8) |
 		  ((cur_sub_max_channel ^ cur_sub_max_channel) << 16) |
 		  ((triplet->chans.max_power ^ cur_sub_max_channel) << 24);
@@ -538,8 +562,10 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		country_ie_len -= 3;
 		num_rules++;
 
-		/* Note: this is not a IEEE requirement but
-		 * simply a memory requirement */
+		/*
+		 * Note: this is not a IEEE requirement but
+		 * simply a memory requirement
+		 */
 		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
 			return NULL;
 	}
@@ -567,8 +593,10 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		struct ieee80211_freq_range *freq_range = NULL;
 		struct ieee80211_power_rule *power_rule = NULL;
 
-		/* Must parse if dot11RegulatoryClassesRequired is true,
-		 * we don't support this yet */
+		/*
+		 * Must parse if dot11RegulatoryClassesRequired is true,
+		 * we don't support this yet
+		 */
 		if (triplet->ext.reg_extension_id >=
 				IEEE80211_COUNTRY_EXTENSION_ID) {
 			country_ie += 3;
@@ -590,10 +618,12 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			end_channel =  triplet->chans.first_channel +
 				(4 * (triplet->chans.num_channels - 1));
 
-		/* The +10 is since the regulatory domain expects
+		/*
+		 * The +10 is since the regulatory domain expects
 		 * the actual band edge, not the center of freq for
 		 * its start and end freqs, assuming 20 MHz bandwidth on
-		 * the channels passed */
+		 * the channels passed
+		 */
 		freq_range->start_freq_khz =
 			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
 				triplet->chans.first_channel) - 10);
@@ -601,9 +631,11 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
 				end_channel) + 10);
 
-		/* Large arbitrary values, we intersect later */
-		/* Increment this if we ever support >= 40 MHz channels
-		 * in IEEE 802.11 */
+		/*
+		 * These are large arbitrary values we use to intersect later.
+		 * Increment this if we ever support >= 40 MHz channels
+		 * in IEEE 802.11
+		 */
 		freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
 		power_rule->max_antenna_gain = DBI_TO_MBI(100);
 		power_rule->max_eirp = DBM_TO_MBM(100);
@@ -619,8 +651,10 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 }
 
 
-/* Helper for regdom_intersect(), this does the real
- * mathematical intersection fun */
+/*
+ * Helper for regdom_intersect(), this does the real
+ * mathematical intersection fun
+ */
 static int reg_rules_intersect(
 	const struct ieee80211_reg_rule *rule1,
 	const struct ieee80211_reg_rule *rule2,
@@ -698,11 +732,13 @@ static struct ieee80211_regdomain *regdom_intersect(
 	if (!rd1 || !rd2)
 		return NULL;
 
-	/* First we get a count of the rules we'll need, then we actually
+	/*
+	 * First we get a count of the rules we'll need, then we actually
 	 * build them. This is to so we can malloc() and free() a
 	 * regdomain once. The reason we use reg_rules_intersect() here
 	 * is it will return -EINVAL if the rule computed makes no sense.
-	 * All rules that do check out OK are valid. */
+	 * All rules that do check out OK are valid.
+	 */
 
 	for (x = 0; x < rd1->n_reg_rules; x++) {
 		rule1 = &rd1->reg_rules[x];
@@ -730,14 +766,18 @@ static struct ieee80211_regdomain *regdom_intersect(
 		rule1 = &rd1->reg_rules[x];
 		for (y = 0; y < rd2->n_reg_rules; y++) {
 			rule2 = &rd2->reg_rules[y];
-			/* This time around instead of using the stack lets
+			/*
+			 * This time around instead of using the stack lets
 			 * write to the target rule directly saving ourselves
-			 * a memcpy() */
+			 * a memcpy()
+			 */
 			intersected_rule = &rd->reg_rules[rule_idx];
 			r = reg_rules_intersect(rule1, rule2,
 				intersected_rule);
-			/* No need to memset here the intersected rule here as
-			 * we're not using the stack anymore */
+			/*
+			 * No need to memset here the intersected rule here as
+			 * we're not using the stack anymore
+			 */
 			if (r)
 				continue;
 			rule_idx++;
@@ -756,8 +796,10 @@ static struct ieee80211_regdomain *regdom_intersect(
 	return rd;
 }
 
-/* XXX: add support for the rest of enum nl80211_reg_rule_flags, we may
- * want to just have the channel structure use these */
+/*
+ * XXX: add support for the rest of enum nl80211_reg_rule_flags, we may
+ * want to just have the channel structure use these
+ */
 static u32 map_regdom_flags(u32 rd_flags)
 {
 	u32 channel_flags = 0;
@@ -783,8 +825,10 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 
 	regd = custom_regd ? custom_regd : cfg80211_regdomain;
 
-	/* Follow the driver's regulatory domain, if present, unless a country
-	 * IE has been processed or a user wants to help complaince further */
+	/*
+	 * Follow the driver's regulatory domain, if present, unless a country
+	 * IE has been processed or a user wants to help complaince further
+	 */
 	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE &&
 	    last_request->initiator != REGDOM_SET_BY_USER &&
 	    wiphy->regd)
@@ -802,9 +846,11 @@ static int freq_reg_info_regd(struct wiphy *wiphy,
 		fr = &rr->freq_range;
 		pr = &rr->power_rule;
 
-		/* We only need to know if one frequency rule was
+		/*
+		 * We only need to know if one frequency rule was
 		 * was in center_freq's band, that's enough, so lets
-		 * not overwrite it once found */
+		 * not overwrite it once found
+		 */
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
 
@@ -857,7 +903,8 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		&max_bandwidth, &reg_rule);
 
 	if (r) {
-		/* This means no regulatory rule was found in the country IE
+		/*
+		 * This means no regulatory rule was found in the country IE
 		 * with a frequency range on the center_freq's band, since
 		 * IEEE-802.11 allows for a country IE to have a subset of the
 		 * regulatory information provided in a country we ignore
@@ -876,8 +923,10 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 				chan->center_freq, wiphy_name(wiphy));
 #endif
 		} else {
-		/* In this case we know the country IE has at least one reg rule
-		 * for the band so we respect its band definitions */
+		/*
+		 * In this case we know the country IE has at least one reg rule
+		 * for the band so we respect its band definitions
+		 */
 #ifdef CONFIG_CFG80211_REG_DEBUG
 			if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 				printk(KERN_DEBUG "cfg80211: Disabling "
@@ -896,9 +945,11 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 	if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
 	    request_wiphy && request_wiphy == wiphy &&
 	    request_wiphy->strict_regulatory) {
-		/* This gaurantees the driver's requested regulatory domain
+		/*
+		 * This gaurantees the driver's requested regulatory domain
 		 * will always be used as a base for further regulatory
-		 * settings */
+		 * settings
+		 */
 		chan->flags = chan->orig_flags =
 			map_regdom_flags(reg_rule->flags);
 		chan->max_antenna_gain = chan->orig_mag =
@@ -939,8 +990,10 @@ static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
 	if (setby == REGDOM_SET_BY_CORE &&
 		  wiphy->custom_regulatory)
 		return true;
-	/* wiphy->regd will be set once the device has its own
-	 * desired regulatory domain set */
+	/*
+	 * wiphy->regd will be set once the device has its own
+	 * desired regulatory domain set
+	 */
 	if (wiphy->strict_regulatory && !wiphy->regd &&
 	    !is_world_regdom(last_request->alpha2))
 		return true;
@@ -1050,8 +1103,10 @@ static int reg_copy_regd(const struct ieee80211_regdomain **dst_regd,
 	return 0;
 }
 
-/* Return value which can be used by ignore_request() to indicate
- * it has been determined we should intersect two regulatory domains */
+/*
+ * Return value which can be used by ignore_request() to indicate
+ * it has been determined we should intersect two regulatory domains
+ */
 #define REG_INTERSECT	1
 
 /* This has the logic which determines when a new request
@@ -1091,8 +1146,10 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
-			/* Two consecutive Country IE hints on the same wiphy.
-			 * This should be picked up early by the driver/stack */
+			/*
+			 * Two consecutive Country IE hints on the same wiphy.
+			 * This should be picked up early by the driver/stack
+			 */
 			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
 				  alpha2)))
 				return 0;
@@ -1111,13 +1168,17 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
-		/* If the user knows better the user should set the regdom
-		 * to their country before the IE is picked up */
+		/*
+		 * If the user knows better the user should set the regdom
+		 * to their country before the IE is picked up
+		 */
 		if (last_request->initiator == REGDOM_SET_BY_USER &&
 			  last_request->intersect)
 			return -EOPNOTSUPP;
-		/* Process user requests only after previous user/driver/core
-		 * requests have been processed */
+		/*
+		 * Process user requests only after previous user/driver/core
+		 * requests have been processed
+		 */
 		if (last_request->initiator == REGDOM_SET_BY_CORE ||
 		    last_request->initiator == REGDOM_SET_BY_DRIVER ||
 		    last_request->initiator == REGDOM_SET_BY_USER) {
@@ -1158,9 +1219,11 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 		}
 		intersect = true;
 	} else if (r) {
-		/* If the regulatory domain being requested by the
+		/*
+		 * If the regulatory domain being requested by the
 		 * driver has already been set just copy it to the
-		 * wiphy */
+		 * wiphy
+		 */
 		if (r == -EALREADY && set_by == REGDOM_SET_BY_DRIVER) {
 			r = reg_copy_regd(&wiphy->regd, cfg80211_regdomain);
 			if (r)
@@ -1297,9 +1360,11 @@ static bool reg_same_country_ie_hint(struct wiphy *wiphy,
 
 	if (likely(request_wiphy != wiphy))
 		return !country_ie_integrity_changes(country_ie_checksum);
-	/* We should not have let these through at this point, they
+	/*
+	 * We should not have let these through at this point, they
 	 * should have been picked up earlier by the first alpha2 check
-	 * on the device */
+	 * on the device
+	 */
 	if (WARN_ON(!country_ie_integrity_changes(country_ie_checksum)))
 		return true;
 	return false;
@@ -1326,9 +1391,11 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
 		goto out;
 
-	/* Pending country IE processing, this can happen after we
+	/*
+	 * Pending country IE processing, this can happen after we
 	 * call CRDA and wait for a response if a beacon was received before
-	 * we were able to process the last regulatory_hint_11d() call */
+	 * we were able to process the last regulatory_hint_11d() call
+	 */
 	if (country_ie_regdomain)
 		goto out;
 
@@ -1340,34 +1407,44 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	else if (country_ie[2] == 'O')
 		env = ENVIRON_OUTDOOR;
 
-	/* We will run this for *every* beacon processed for the BSSID, so
+	/*
+	 * We will run this for *every* beacon processed for the BSSID, so
 	 * we optimize an early check to exit out early if we don't have to
-	 * do anything */
+	 * do anything
+	 */
 	if (likely(wiphy_idx_valid(last_request->wiphy_idx))) {
 		struct cfg80211_registered_device *drv_last_ie;
 
 		drv_last_ie =
 			cfg80211_drv_by_wiphy_idx(last_request->wiphy_idx);
 
-		/* Lets keep this simple -- we trust the first AP
-		 * after we intersect with CRDA */
+		/*
+		 * Lets keep this simple -- we trust the first AP
+		 * after we intersect with CRDA
+		 */
 		if (likely(&drv_last_ie->wiphy == wiphy)) {
-			/* Ignore IEs coming in on this wiphy with
-			 * the same alpha2 and environment cap */
+			/*
+			 * Ignore IEs coming in on this wiphy with
+			 * the same alpha2 and environment cap
+			 */
 			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
 				  alpha2) &&
 				  env == drv_last_ie->env)) {
 				goto out;
 			}
-			/* the wiphy moved on to another BSSID or the AP
+			/*
+			 * the wiphy moved on to another BSSID or the AP
 			 * was reconfigured. XXX: We need to deal with the
 			 * case where the user suspends and goes to goes
 			 * to another country, and then gets IEs from an
-			 * AP with different settings */
+			 * AP with different settings
+			 */
 			goto out;
 		} else {
-			/* Ignore IEs coming in on two separate wiphys with
-			 * the same alpha2 and environment cap */
+			/*
+			 * Ignore IEs coming in on two separate wiphys with
+			 * the same alpha2 and environment cap
+			 */
 			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
 				  alpha2) &&
 				  env == drv_last_ie->env)) {
@@ -1382,18 +1459,22 @@ void regulatory_hint_11d(struct wiphy *wiphy,
 	if (!rd)
 		goto out;
 
-	/* This will not happen right now but we leave it here for the
+	/*
+	 * This will not happen right now but we leave it here for the
 	 * the future when we want to add suspend/resume support and having
 	 * the user move to another country after doing so, or having the user
 	 * move to another AP. Right now we just trust the first AP. This is why
 	 * this is marked as likley(). If we hit this before we add this support
 	 * we want to be informed of it as it would indicate a mistake in the
-	 * current design  */
+	 * current design
+	 */
 	if (likely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
 		goto out;
 
-	/* We keep this around for when CRDA comes back with a response so
-	 * we can intersect with that */
+	/*
+	 * We keep this around for when CRDA comes back with a response so
+	 * we can intersect with that
+	 */
 	country_ie_regdomain = rd;
 
 	__regulatory_hint(wiphy, REGDOM_SET_BY_COUNTRY_IE,
@@ -1419,8 +1500,10 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
 
-		/* There may not be documentation for max antenna gain
-		 * in certain regions */
+		/*
+		 * There may not be documentation for max antenna gain
+		 * in certain regions
+		 */
 		if (power_rule->max_antenna_gain)
 			printk(KERN_INFO "\t(%d KHz - %d KHz @ %d KHz), "
 				"(%d mBi, %d mBm)\n",
@@ -1531,9 +1614,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!last_request)
 		return -EINVAL;
 
-	/* Lets only bother proceeding on the same alpha2 if the current
+	/*
+	 * Lets only bother proceeding on the same alpha2 if the current
 	 * rd is non static (it means CRDA was present and was used last)
-	 * and the pending request came in from a country IE */
+	 * and the pending request came in from a country IE
+	 */
 	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
 		/* If someone else asked us to change the rd lets only bother
 		 * checking if the alpha2 changes if CRDA was already called */
@@ -1542,10 +1627,12 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return -EINVAL;
 	}
 
-	/* Now lets set the regulatory domain, update all driver channels
+	/*
+	 * Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
 	 * to review or adjust their own settings based on their own
-	 * internal EEPROM data */
+	 * internal EEPROM data
+	 */
 
 	if (WARN_ON(!reg_is_valid_request(rd->alpha2)))
 		return -EINVAL;
@@ -1568,8 +1655,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 			return 0;
 		}
 
-		/* For a driver hint, lets copy the regulatory domain the
-		 * driver wanted to the wiphy to deal with conflicts */
+		/*
+		 * For a driver hint, lets copy the regulatory domain the
+		 * driver wanted to the wiphy to deal with conflicts
+		 */
 
 		BUG_ON(request_wiphy->regd);
 
@@ -1590,9 +1679,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		if (!intersected_rd)
 			return -EINVAL;
 
-		/* We can trash what CRDA provided now.
+		/*
+		 * We can trash what CRDA provided now.
 		 * However if a driver requested this specific regulatory
-		 * domain we keep it for its private use */
+		 * domain we keep it for its private use
+		 */
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
 			request_wiphy->regd = rd;
 		else
@@ -1614,8 +1705,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	BUG_ON(!country_ie_regdomain);
 
 	if (rd != country_ie_regdomain) {
-		/* Intersect what CRDA returned and our what we
-		 * had built from the Country IE received */
+		/*
+		 * Intersect what CRDA returned and our what we
+		 * had built from the Country IE received
+		 */
 
 		intersected_rd = regdom_intersect(rd, country_ie_regdomain);
 
@@ -1625,9 +1718,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		kfree(country_ie_regdomain);
 		country_ie_regdomain = NULL;
 	} else {
-		/* This would happen when CRDA was not present and
+		/*
+		 * This would happen when CRDA was not present and
 		 * OLD_REGULATORY was enabled. We intersect our Country
-		 * IE rd and what was set on cfg80211 originally */
+		 * IE rd and what was set on cfg80211 originally
+		 */
 		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
 	}
 
@@ -1652,9 +1747,11 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 }
 
 
-/* Use this call to set the current regulatory domain. Conflicts with
+/*
+ * Use this call to set the current regulatory domain. Conflicts with
  * multiple drivers can be ironed out later. Caller must've already
- * kmalloc'd the rd structure. Caller must hold cfg80211_mutex */
+ * kmalloc'd the rd structure. Caller must hold cfg80211_mutex
+ */
 int set_regdom(const struct ieee80211_regdomain *rd)
 {
 	int r;
@@ -1763,10 +1860,12 @@ int regulatory_init(void)
 
 	printk(KERN_INFO "cfg80211: Using static regulatory domain info\n");
 	print_regdomain_info(cfg80211_regdomain);
-	/* The old code still requests for a new regdomain and if
+	/*
+	 * The old code still requests for a new regdomain and if
 	 * you have CRDA you get it updated, otherwise you get
 	 * stuck with the static values. We ignore "EU" code as
-	 * that is not a valid ISO / IEC 3166 alpha2 */
+	 * that is not a valid ISO / IEC 3166 alpha2
+	 */
 	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
 		err = regulatory_hint_core(ieee80211_regdom);
 #else
-- 
1.6.1.2.253.ga34a

