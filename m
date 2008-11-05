Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64282 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392AbYKECuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 21:50:18 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2008 18:50:18 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 7/7] cfg80211/mac80211: Add Country IE parsing/802.11d support
Date: Tue, 4 Nov 2008 18:50:06 -0800
Message-ID: <1225853406-16322-8-git-send-email-lrodriguez@atheros.com> (sfid-20081105_035027_308900_EBEAB716)
In-Reply-To: <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
References: <1225853406-16322-1-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-2-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-3-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-4-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-5-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-6-git-send-email-lrodriguez@atheros.com>
 <1225853406-16322-7-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds country IE parsing to mac80211 and enables its usage
within the new regulatory infrastructure in cfg80211. We parse
the country IEs only on management beacons (when your associated)
and disregard the IEs when the country matches the country already
picked up by the device through IEs.

To avoid following misinformed or outdated APs we build and use
a regulatory domain out of the intersection between what the AP
provides us on the country IE and what CRDA is aware is allowed
on the same country.

A secondary device is allowed to follow only the same country IE
as it make no sense for two devices on a system to be in two
different countries.

In the case the AP is using country IEs for an incorrect country
the user may help compliance further by setting the regulatory
domain and in that case another intersection will be performed.

CONFIG_WIRELESS_OLD_REGULATORY is supported but requires CRDA
present.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/linux/ieee80211.h |   62 ++++++++++++
 include/net/wireless.h    |   60 ++++++++++++
 net/mac80211/Kconfig      |    8 ++
 net/mac80211/mlme.c       |  236 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/Kconfig      |   11 ++
 net/wireless/core.c       |   16 +++
 net/wireless/nl80211.c    |    2 +-
 net/wireless/reg.c        |  235 ++++++++++++++++++++++++++++++++++++++++-----
 net/wireless/reg.h        |    4 +-
 9 files changed, 608 insertions(+), 26 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 56b0eb2..5e2bf16 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1042,6 +1042,68 @@ enum ieee80211_spectrum_mgmt_actioncode {
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/*
+ * IEEE 802.11-2007 7.3.2.9 Country information element
+ *
+ * Minimum length is 8 octects, ie len must be evenly
+ * divisible by 2
+ */
+
+/* Although the spec says 8 I'm seeing 6 in practice */
+#define IEEE80211_COUNTRY_IE_MIN_LEN	6
+
+/*
+ * Regulatory extension stuff is for 802.11j, ammeneded to
+ * IEEE 802.11-2007, see Annex I (page 1141) and Annex J
+ * (page 1147). Also review 7.3.2.9.
+ *
+ * When dot11RegulatoryClassesRequired is true and the
+ * first_channel/reg_extension_id is >= 201 then the IE
+ * compromises of the 'ext' struct represented below:
+ *
+ *  - Regulatory extension ID - when generating IE this just needs
+ *    to be monotonically increasing for each triplet passed in
+ *    the IE
+ *  - Regulatory class - index into set of rules
+ *  - Coverage class - index into air propagation time (Table 7-27),
+ *    in microseconds, you can compute the air propagation time from
+ *    the index by multiplying by 3, so index 10 yields a propagation
+ *    of 10 us. Valid values are 0-31, values 32-255 are not defined
+ *    yet. A value of 0 inicates air propagation of <= 1 us.
+ *
+ *  See also Table I.2 for Emission limit sets and table
+ *  I.3 for Behavior limit sets. Table J.1 indicates how to map
+ *  a reg_class to an emission limit set and behavior limit set.
+ */
+#define IEEE80211_COUNTRY_EXTENSION_ID 201
+
+/*
+ *  Channels numbers in the IE must be monntonically increasing
+ *  if dot11RegulatoryClassesRequired is not true.
+ *
+ *  If dot11RegulatoryClassesRequired is true consecutive
+ *  subband triplets following a regulatory triplet shall
+ *  have monotonically increasing first_channel number fields.
+ *
+ *  Channel numbers shall not overlap.
+ *
+ *  Note that max_power is signed.
+ */
+struct ieee80211_country_ie_triplet {
+	union {
+		struct {
+			u8 first_channel;
+			u8 num_channels;
+			s8 max_power;
+		} __attribute__ ((packed)) chans;
+		struct {
+			u8 reg_extension_id;
+			u8 reg_class;
+			u8 coverage_class;
+		} __attribute__ ((packed)) ext;
+	};
+} __attribute__ ((packed));
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 17d4b58..0dcd15c 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -181,6 +181,13 @@ struct ieee80211_supported_band {
  * struct wiphy - wireless hardware description
  * @idx: the wiphy index assigned to this item
  * @class_dev: the class device representing /sys/class/ieee80211/<wiphy-name>
+ * @country_ie_alpha2: ISO / IEC 3166 alpha2 for which this wiphy is receiving
+ * 	country IEs on, this should help drivers and the wireless
+ * 	stack disregard country IEs from APs quickly on the same alpha2.
+ * 	The alpha2 may differ from cfg80211_regdomain's alpha2 when
+ * 	an intersection has occurred. If the AP is reconfigured this
+ * 	can also be used to tell us if the country on the country
+ * 	IE changed.
  * @reg_notifier: the driver's regulatory notification callback
  */
 struct wiphy {
@@ -201,6 +208,8 @@ struct wiphy {
 
 	struct ieee80211_supported_band *bands[IEEE80211_NUM_BANDS];
 
+	char country_ie_alpha2[2];
+
 	/* Lets us get back the wiphy on the callback */
 	int (*reg_notifier)(struct wiphy *wiphy, enum reg_set_by setby);
 
@@ -373,4 +382,55 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
  * for a regulatory domain structure for the respective country.
  */
 extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
+
+/**
+ * regulatory_hint_ie - wireless stack hints a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @rd: a regulatory domain built from the received country IE
+ * @country_ie_checksum: checksum of country IE of fields we are interested in,
+ * 	we can remove this if its determined the IE never should change
+ * 	for an AP, keep in mind dot11RegulatoryClassesRequired.
+ *
+ * We will intersect the rd with the what CRDA tells us should apply
+ * for the alpha2 this country IE belongs to, this prevents APs from
+ * sending us incorrect or outdated information against a country.
+ * If CONFIG_WIRELESS_OLD_REGULATORY is enabled and CRDA is not present
+ * we will intersect immediately against what is currently set in the
+ * wireless core.
+ */
+extern int regulatory_hint_ie(struct wiphy *wiphy,
+	struct ieee80211_regdomain *rd,
+	u32 country_ie_checksum);
+
+/**
+ * cfg80211_is_country_change - tells us if wiphy moves to new country
+ * @wiphy: the wireless device on which the IE was received on
+ * @alpha2: the alpha2 for the country IE the wiphy received
+ *
+ * This can be used to determine if a country IE a wiphy receives
+ * has changed the alpha2. The structure of the IEs generated on
+ * the AP should not change. If the the country changes we should
+ * disassociate and re-associate as the AP was probably reconfigured
+ * and rebooted, hopefully with a correct country setting.
+ *
+ * We don't support two wiphys being present in two different
+ * countries, however it might be possible a different wiphy
+ * already set the current regulatory domain; in that case we
+ * want to process this wiphy's country IE in case it may be
+ * different even if on the same alpha2.
+ */
+extern bool cfg80211_is_country_change(struct wiphy *wiphy,
+	const char *alpha2);
+
+/**
+ * country_ie_integrity_changes - tells us if the country IE has changed
+ * @checksum: checksum of country IE of fields we are interested in
+ *
+ * If the country IE has not changed you can ignore it safely. This is
+ * useful to determine if two wiphys are seeing two different country IEs
+ * even on the same alpha2. Note that this will return false if no IE has
+ * been set on the wireless core yet.
+ */
+extern bool country_ie_integrity_changes(u32 checksum);
 #endif /* __NET_WIRELESS_H */
diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
index 7f710a2..219fb7b 100644
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -203,6 +203,14 @@ config MAC80211_DEBUG_COUNTERS
 
 	  If unsure, say N.
 
+config MAC80211_COUNTRY_IE_DEBUG
+	bool "Country IE parsing debug (IEEE 802.11d) debugging"
+	depends on MAC80211_DEBUG_MENU
+	---help---
+	  Say Y here to print out verbose country IE parsing (IEEE 802.11d)
+	  debug messages. This generates a lot of messages. You should only
+	  enable this option if no regulatory changes are being made.
+
 config MAC80211_VERBOSE_SPECT_MGMT_DEBUG
 	bool "Verbose Spectrum Management (IEEE 802.11h)debugging"
 	depends on MAC80211_DEBUG_MENU
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 12064fb..08675b4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -648,6 +648,211 @@ static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
+/* Converts a country IE to a regulatory domain. A regulatory domain
+ * structure has a lot of information which the IE doesn't yet have,
+ * so for the other values we use upper max values as we will intersect
+ * with our userspace regulatory agent to get lower bounds. */
+static struct ieee80211_regdomain *ieee80211_country_ie_2_rd(
+				u8 *country_ie,
+				u8 country_ie_len,
+				u32 *checksum)
+{
+	struct ieee80211_regdomain *rd = NULL;
+	unsigned int i = 0;
+	char alpha2[2];
+	u32 flags = 0;
+	u32 num_rules = 0, size_of_regd = 0;
+	u8 *triplets_start = NULL;
+	u8 len_at_triplet = 0;
+	/* Used too often */
+	int triplet_size = sizeof(struct ieee80211_country_ie_triplet);
+	/* the last channel we have registered in a subband (triplet) */
+	int last_sub_max_channel = 0;
+
+	*checksum = 0xDEADBEEF;
+
+	/* Country IE requirements */
+	BUG_ON(country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN ||
+		country_ie_len & 0x01);
+
+	alpha2[0] = country_ie[0];
+	alpha2[1] = country_ie[1];
+
+	/*
+	 * Third octet can be:
+	 *    'I' - Indoor
+	 *    'O' - Outdoor
+	 *
+	 *  anything else we assume is no restrictions
+	 */
+	if (country_ie[2] == 'I')
+		flags = NL80211_RRF_NO_OUTDOOR;
+	else if (country_ie[2] == 'O')
+		flags = NL80211_RRF_NO_INDOOR;
+
+	country_ie += 3;
+	country_ie_len -= 3;
+
+	triplets_start = country_ie;
+	len_at_triplet = country_ie_len;
+
+	*checksum ^= flags ^ alpha2[0] ^ alpha2[1];
+
+	/* We need to build a reg rule for each triplet, but first we must
+	 * calculate the number of reg rules we will need. We will need one
+	 * for each channel subband */
+	while (country_ie_len >= triplet_size) {
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) country_ie;
+		int cur_sub_max_channel = 0, cur_channel = 0;
+
+		if (triplet->ext.reg_extension_id >=
+				IEEE80211_COUNTRY_EXTENSION_ID) {
+			country_ie += triplet_size;
+			country_ie_len -= triplet_size;
+			continue;
+		}
+
+		cur_channel = triplet->chans.first_channel;
+		cur_sub_max_channel = ieee80211_channel_to_frequency(
+			cur_channel + triplet->chans.num_channels);
+
+		/* Basic sanity check */
+		if (cur_sub_max_channel < cur_channel)
+			return NULL;
+
+		/* Do not allow overlapping channels. Also channels
+		 * passed in each subband must be monotonically
+		 * increasing */
+		if (last_sub_max_channel) {
+			if (cur_channel <= last_sub_max_channel)
+				return NULL;
+			if (cur_sub_max_channel <= last_sub_max_channel)
+				return NULL;
+		}
+
+		/* When dot11RegulatoryClassesRequired is supported
+		 * we can throw ext triplets as part of this soup,
+		 * for now we don't care when those change as we
+		 * don't support them */
+		*checksum ^= cur_channel ^ cur_sub_max_channel ^
+			triplet->chans.max_power;
+
+		last_sub_max_channel = cur_sub_max_channel;
+
+		country_ie += triplet_size;
+		country_ie_len -= triplet_size;
+		num_rules++;
+
+		/* Note: this is not a IEEE requirement but
+		 * simply a memory requirement */
+		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
+			return NULL;
+	}
+
+	/* This will be true if a second wiphy receives a different
+	 * country IE than the one we last processed and accepted,
+	 * for now we simply disregard these. */
+	if (country_ie_integrity_changes(*checksum))
+		return NULL;
+
+	country_ie = triplets_start;
+	country_ie_len = len_at_triplet;
+
+	size_of_regd = sizeof(struct ieee80211_regdomain) +
+		(num_rules * sizeof(struct ieee80211_reg_rule));
+
+	rd = kzalloc(size_of_regd, GFP_KERNEL);
+	if (!rd)
+		return NULL;
+
+	rd->n_reg_rules = num_rules;
+	rd->alpha2[0] = alpha2[0];
+	rd->alpha2[1] = alpha2[1];
+
+	/* This time around we fill in the rd */
+	while (country_ie_len >= triplet_size) {
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) country_ie;
+		struct ieee80211_reg_rule *reg_rule = NULL;
+		struct ieee80211_freq_range *freq_range = NULL;
+		struct ieee80211_power_rule *power_rule = NULL;
+
+		/* Must parse if dot11RegulatoryClassesRequired is true,
+		 * we don't support this yet */
+		if (triplet->ext.reg_extension_id >=
+				IEEE80211_COUNTRY_EXTENSION_ID) {
+			country_ie += triplet_size;
+			country_ie_len -= triplet_size;
+			continue;
+		}
+
+		reg_rule = &rd->reg_rules[i];
+		freq_range = &reg_rule->freq_range;
+		power_rule = &reg_rule->power_rule;
+
+		reg_rule->flags = flags;
+
+		/* The +10 is since the regulatory domain expects
+		 * the actual band edge, not the center of freq for
+		 * its start and end freqs, assuming 20 MHz bandwidth on
+		 * the channels passed */
+		freq_range->start_freq_khz =
+			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
+				triplet->chans.first_channel) + 10);
+		freq_range->end_freq_khz =
+			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
+				triplet->chans.first_channel +
+					triplet->chans.num_channels) + 10);
+
+		/* Large arbitrary values, we intersect later */
+		/* Increment this if we ever support >= 40 MHz channels
+		 * in IEEE 802.11 */
+		freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
+		power_rule->max_antenna_gain = DBI_TO_MBI(100);
+		power_rule->max_eirp = DBM_TO_MBM(100);
+
+		country_ie += triplet_size;
+		country_ie_len -= triplet_size;
+		i++;
+
+		BUG_ON(i > NL80211_MAX_SUPP_REG_RULES);
+	}
+
+	return rd;
+}
+
+static int ieee80211_sta_process_country_ie(struct ieee80211_local *local,
+				u8 *country_ie, u8 country_ie_len)
+{
+	char alpha2[2];
+	struct ieee80211_regdomain *rd = NULL;
+	u32 checksum = 0;
+
+	/* IE len must be evenly divisible by 2 */
+	if (country_ie_len & 0x01)
+		return -EINVAL;
+
+	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
+		return -EINVAL;
+
+	/* Note if the AP is reconfigured to outdoor this doesn't pick
+	 * that up, but that assumes we can keep the state alive while it
+	 * does that */
+	alpha2[0] = country_ie[0];
+	alpha2[1] = country_ie[1];
+
+	/* Ignore IEs coming in on this wiphy which with the same alpha2 */
+	if (!cfg80211_is_country_change(local->hw.wiphy, alpha2))
+		return -EALREADY;
+
+	rd = ieee80211_country_ie_2_rd(country_ie, country_ie_len, &checksum);
+	if (!rd)
+		return -EINVAL;
+
+	return regulatory_hint_ie(local->hw.wiphy, rd, checksum);
+}
+
 static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_if_sta *ifsta)
 {
@@ -1681,6 +1886,29 @@ static void ieee80211_rx_mgmt_probe_resp(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
+#ifdef CONFIG_MAC80211_COUNTRY_IE_DEBUG
+static void ieee80211_country_ie_results_debug(int r)
+{
+	if (likely(r)) {
+		if (likely(r == -EALREADY)) {
+			printk(KERN_DEBUG "mac80211: disgarding"
+				" already processed country "
+				"IE\n");
+		} else {
+			printk(KERN_DEBUG "mac80211: Unable "
+				"to parse country IE\n");
+		}
+	} else {
+		printk(KERN_DEBUG "mac80211: Parsed "
+			"country IE correctly\n");
+	}
+}
+#else
+static inline void ieee80211_country_ie_results_debug(int r)
+{
+	return;
+}
+#endif
 
 static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_mgmt *mgmt,
@@ -1694,6 +1922,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 	bool erp_valid;
 	u8 erp_value = 0;
+	int r = 0;
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
@@ -1753,6 +1982,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       ap_ht_cap_flags);
 	}
 
+	if (elems.country_elem) {
+		/* Note we are only reviewing this on management beacons */
+		r = ieee80211_sta_process_country_ie(local,
+			elems.country_elem, elems.country_elem_len);
+		ieee80211_country_ie_results_debug(r);
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index ae7f226..c40a0f2 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,15 @@
 config CFG80211
         tristate "Improved wireless configuration API"
 
+config CFG80211_REG_DEBUG
+        bool "cfg80211 regulatory debugging"
+	depends on CFG80211
+	default n
+	---help---
+	  You can enable this if you want to debug regulatory changes.
+
+	  If unsure, say N.
+
 config NL80211
 	bool "nl80211 new netlink interface support"
 	depends on CFG80211
@@ -40,6 +49,8 @@ config WIRELESS_OLD_REGULATORY
 	  ieee80211_regdom module parameter. This is being phased out and you
 	  should stop using them ASAP.
 
+	  Note: You will need CRDA if you want 802.11d support
+
 	  Say Y unless you have installed a new userspace application.
 	  Also say Y if have one currently depending on the ieee80211_regdom
 	  module parameter and cannot port it to use the new userspace
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 72825af..a9e40c3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -134,6 +134,22 @@ cfg80211_get_dev_from_ifindex(int ifindex)
 	return drv;
 }
 
+bool cfg80211_is_country_change(struct wiphy *wiphy,
+	const char *alpha2)
+{
+	if (!wiphy->country_ie_alpha2) {
+		if (alpha2)
+			return true;
+		else
+			return false;
+	}
+	if (wiphy->country_ie_alpha2[0] == alpha2[0] &&
+			wiphy->country_ie_alpha2[1] == alpha2[1])
+		return false;
+	return true;
+}
+EXPORT_SYMBOL(cfg80211_is_country_change);
+
 void cfg80211_put_dev(struct cfg80211_registered_device *drv)
 {
 	BUG_ON(IS_ERR(drv));
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e3e1494..a7edd1e 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1760,7 +1760,7 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 #endif
 	mutex_lock(&cfg80211_drv_mutex);
-	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data);
+	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0);
 	mutex_unlock(&cfg80211_drv_mutex);
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3754d0d..6d32684 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -60,12 +60,15 @@
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
+ * @country_ie_checksum: checksum of the last processed and accepted
+ * 	country IE
  */
 struct regulatory_request {
 	struct wiphy *wiphy;
 	enum reg_set_by initiator;
 	char alpha2[2];
 	bool intersect;
+	u32 country_ie_checksum;
 };
 
 /* Receipt of information from last regulatory request */
@@ -85,6 +88,11 @@ static u32 supported_bandwidths[] = {
  * information to give us an alpha2 */
 static const struct ieee80211_regdomain *cfg80211_regdomain;
 
+/* We use this as a place for the rd structure built from the
+ * last parsed country IE to rest until CRDA gets back to us with
+ * what it thinks should apply for the same country */
+static const struct ieee80211_regdomain *country_ie_regdomain;
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
@@ -264,6 +272,18 @@ static bool is_unknown_alpha2(const char *alpha2)
 	return false;
 }
 
+static bool is_intersected_alpha2(const char *alpha2)
+{
+	if (!alpha2)
+		return false;
+	/* Special case where regulatory domain is the
+	 * result of an intersection between two regulatory domain
+	 * structures */
+	if (alpha2[0] == '9' && alpha2[1] == '8')
+		return true;
+	return false;
+}
+
 static bool is_an_alpha2(const char *alpha2)
 {
 	if (!alpha2)
@@ -660,16 +680,14 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
-			/* Two consecutive Country IE hints on the same wiphy */
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			/* Two consecutive Country IE hints on the same wiphy.
+			 * This should be picked up early by the driver/stack */
+			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
+					alpha2)))
 				return 0;
 			return -EALREADY;
 		}
-		/*
-		 * Ignore Country IE hints for now, need to think about
-		 * what we need to do to support multi-domain operation.
-		 */
-		return -EOPNOTSUPP;
+		return REG_INTERSECT;
 	case REGDOM_SET_BY_DRIVER:
 		if (last_request->initiator == REGDOM_SET_BY_DRIVER)
 			return -EALREADY;
@@ -677,6 +695,11 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
+		/* If the user knows better the user should set the regdom
+		 * to their country before the IE is picked up */
+		if (last_request->initiator == REGDOM_SET_BY_USER &&
+				last_request->intersect)
+			return -EOPNOTSUPP;
 		return 0;
 	}
 
@@ -685,7 +708,8 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 
 /* Caller must hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-		      const char *alpha2)
+			const char *alpha2,
+			u32 country_ie_checksum)
 {
 	struct regulatory_request *request;
 	bool intersect = false;
@@ -708,15 +732,22 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	request->initiator = set_by;
 	request->wiphy = wiphy;
 	request->intersect = intersect;
+	request->country_ie_checksum = country_ie_checksum;
 
 	kfree(last_request);
-	last_request = request;
-	r = call_crda(alpha2);
 
-#ifndef CONFIG_WIRELESS_OLD_REGULATORY
-	if (r)
-		printk(KERN_ERR "cfg80211: Failed calling CRDA\n");
-#endif
+	last_request = request;
+	call_crda(alpha2);
+
+	/* Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
+	 * AND if CRDA is NOT present nothing will happen, if someone
+	 * wants to bother with 11d with OLD_REG you can add a timer.
+	 * If after x amount of time nothing happens you can call:
+	 *
+	 * return set_regdom(country_ie_regdomain);
+	 *
+	 * to intersect with the static rd
+	 */
 
 	return r;
 }
@@ -726,11 +757,72 @@ void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	BUG_ON(!alpha2);
 
 	mutex_lock(&cfg80211_drv_mutex);
-	__regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2);
+	__regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, 0);
 	mutex_unlock(&cfg80211_drv_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+bool country_ie_integrity_changes(u32 checksum)
+{
+	/* If no IE has been set then the checksum doesn't change */
+	if (unlikely(!last_request->country_ie_checksum))
+		return false;
+	if (unlikely(last_request->country_ie_checksum != checksum))
+		return true;
+	return false;
+}
+EXPORT_SYMBOL(country_ie_integrity_changes);
+
+/* The only thing this should allow through without a complaint
+ * is the case where a second device received a country IE
+ * with a different checksum. We provide helpers to avoid
+ * the other cases very early on to not waste resources */
+static bool reg_same_country_ie_hint(struct wiphy *wiphy,
+			u32 country_ie_checksum)
+{
+	if (!last_request->wiphy)
+		return false;
+	if (last_request->wiphy != wiphy) {
+		/* The stack/drivers should check for this earlier and
+		 * not let these through */
+		if (WARN_ON(!country_ie_integrity_changes(country_ie_checksum)))
+			return true;
+		return false;
+	}
+	/* The stack/drivers should not let these through */
+	if (WARN_ON(!country_ie_integrity_changes(country_ie_checksum)))
+		return true;
+	return false;
+}
+
+int regulatory_hint_ie(struct wiphy *wiphy, struct ieee80211_regdomain *rd,
+			u32 country_ie_checksum)
+{
+	int r = -EINVAL;
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	/* Pending country IE processing, this can happen after we
+	 * call CRDA and wait for a response if a beacon was received before
+	 * we were able to process the last regulatory_hint_ie() call */
+	if (country_ie_regdomain)
+		goto out;
+
+	if (unlikely(reg_same_country_ie_hint(wiphy, country_ie_checksum)))
+		goto out;
+
+	/* We keep this around for when CRDA comes back with
+	 * a response, so we can interesct with that */
+	country_ie_regdomain = rd;
+
+	r = __regulatory_hint(wiphy, REGDOM_SET_BY_COUNTRY_IE,
+		country_ie_regdomain->alpha2, country_ie_checksum);
+
+out:
+	mutex_unlock(&cfg80211_drv_mutex);
+	return r;
+}
+EXPORT_SYMBOL(regulatory_hint_ie);
 
 static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
@@ -770,7 +862,24 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
-	if (is_world_regdom(rd->alpha2))
+	if (is_intersected_alpha2(rd->alpha2)) {
+		struct wiphy *wiphy = NULL;
+
+
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+			if (last_request->wiphy) {
+				wiphy = last_request->wiphy;
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"domain updated by AP to: %c%c\n",
+					wiphy->country_ie_alpha2[0],
+					wiphy->country_ie_alpha2[1]);
+			} else
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"intersected: \n");
+		} else
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"intersected: \n");
+	} else if (is_world_regdom(rd->alpha2))
 		printk(KERN_INFO "cfg80211: World regulatory "
 			"domain updated:\n");
 	else {
@@ -793,10 +902,39 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
 	print_rd_rules(rd);
 }
 
+#ifdef CONFIG_CFG80211_REG_DEBUG
+static void reg_country_ie_process_debug(
+	const struct ieee80211_regdomain *rd,
+	const struct ieee80211_regdomain *country_ie_regdomain,
+	const struct ieee80211_regdomain *intersected_rd)
+{
+	printk(KERN_DEBUG "cfg80211: Received country IE:\n");
+	print_regdomain_info(country_ie_regdomain);
+	printk(KERN_DEBUG "cfg80211: CRDA thinks this should applied:\n");
+	print_regdomain_info(rd);
+	if (intersected_rd) {
+		printk(KERN_DEBUG "cfg80211: We intersect both of these "
+			"and get:\n");
+		print_regdomain_info(rd);
+		return;
+	}
+	printk(KERN_DEBUG "cfg80211: Intersection between both failed\n");
+}
+#else
+static inline void reg_country_ie_process_debug(
+	const struct ieee80211_regdomain *rd,
+	const struct ieee80211_regdomain *country_ie_regdomain,
+	const struct ieee80211_regdomain *intersected_rd)
+{
+	return;
+}
+#endif
+
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
+	struct wiphy *wiphy = NULL;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -813,10 +951,18 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 	if (!last_request)
 		return -EINVAL;
 
-	/* allow overriding the static definitions if CRDA is present */
-	if (!is_old_static_regdom(cfg80211_regdomain) &&
-	    !regdom_changed(rd->alpha2))
-		return -EINVAL;
+	/* Lets only bother proceeding on the same alpha2 if the current
+	 * rd is non static (it means CRDA was present and was used last)
+	 * and the pending request came in from a country IE */
+	if (last_request->initiator != REGDOM_SET_BY_COUNTRY_IE) {
+		/* If someone else asked us to change the rd lets only bother
+		 * checking if the alpha2 changes if CRDA was already called */
+		if (!is_old_static_regdom(cfg80211_regdomain) &&
+		    !regdom_changed(rd->alpha2))
+			return -EINVAL;
+	}
+
+	wiphy = last_request->wiphy;
 
 	/* Now lets set the regulatory domain, update all driver channels
 	 * and finally inform them of what we have done, in case they want
@@ -857,9 +1003,44 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return 0;
 	}
 
-	/* Country IE parsing coming soon */
+	/*
+	 * Country IE requests are handled a bit differently, we intersect
+	 * the country IE rd and what CRDA believes that country should have
+	 */
+
+	BUG_ON(!country_ie_regdomain);
+
+	if (rd != country_ie_regdomain) {
+		/* Intersect what CRDA returned and our what we
+		 * had built from the Country IE received */
+
+		intersected_rd = regdom_intersect(rd, country_ie_regdomain);
+
+		reg_country_ie_process_debug(rd, country_ie_regdomain,
+			intersected_rd);
+
+		kfree(country_ie_regdomain);
+		country_ie_regdomain = NULL;
+	} else {
+		/* This would happen when CRDA was not present and
+		 * OLD_REGULATORY was enabled. We intersect our Country
+		 * IE rd and what was set on cfg80211 originally */
+		intersected_rd = regdom_intersect(rd, cfg80211_regdomain);
+	}
+
+	if (!intersected_rd)
+		return -EINVAL;
+
+	wiphy->country_ie_alpha2[0] = rd->alpha2[0];
+	wiphy->country_ie_alpha2[1] = rd->alpha2[1];
+
+	BUG_ON(intersected_rd == rd);
+
+	kfree(rd);
+	rd = NULL;
+
 	reset_regdomains();
-	WARN_ON(1);
+	cfg80211_regdomain = intersected_rd;
 
 	return 0;
 }
@@ -900,6 +1081,7 @@ int regulatory_init(void)
 		return PTR_ERR(reg_pdev);
 
 	last_request = NULL;
+	country_ie_regdomain = NULL;
 
 #ifdef CONFIG_WIRELESS_OLD_REGULATORY
 	cfg80211_regdomain = static_regdom(ieee80211_regdom);
@@ -912,11 +1094,11 @@ int regulatory_init(void)
 	 * that is not a valid ISO / IEC 3166 alpha2 */
 	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
 		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom);
+					ieee80211_regdom, 0);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00");
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0);
 	if (err)
 		printk(KERN_ERR "cfg80211: calling CRDA failed - "
 		       "unable to update world regulatory domain, "
@@ -932,6 +1114,11 @@ void regulatory_exit(void)
 
 	reset_regdomains();
 
+	if (unlikely(country_ie_regdomain)) {
+		kfree(country_ie_regdomain);
+		country_ie_regdomain = NULL;
+	}
+
 	kfree(last_request);
 
 	platform_device_unregister(reg_pdev);
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index c9b6b63..b10d88c 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -15,6 +15,8 @@ int set_regdom(const struct ieee80211_regdomain *rd);
  *	is required to be set to the wiphy that received the information
  * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
  *	should be in.
+ * @country_ie_checksum: checksum of processed country IE, set this to 0
+ * 	if the hint did not come from a country IE
  *
  * The Wireless subsystem can use this function to hint to the wireless core
  * what it believes should be the current regulatory domain by
@@ -26,6 +28,6 @@ int set_regdom(const struct ieee80211_regdomain *rd);
  *
  */
 extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-			     const char *alpha2);
+			     const char *alpha2, u32 country_ie_checksum);
 
 #endif  /* __NET_WIRELESS_REG_H */
-- 
1.5.6.3

