Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18986 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639AbYKGWkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 17:40:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 14:40:37 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v4] cfg80211/mac80211: Add 802.11d support
Date: Fri, 7 Nov 2008 14:40:35 -0800
Message-ID: <1226097635-9555-1-git-send-email-lrodriguez@atheros.com> (sfid-20081107_234042_937611_F871D6C3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds country IE parsing to mac80211 and enables its usage
within the new regulatory infrastructure in cfg80211. We parse
the country IEs only on management beacons for the BSSID you are
associated to and disregard the IEs when the country and environment
(indoor, outdoor, any) matches the already processed country IE.

To avoid following misinformed or outdated APs we build and use
a regulatory domain out of the intersection between what the AP
provides us on the country IE and what CRDA is aware is allowed
on the same country.

A secondary device is allowed to follow only the same country IE
as it make no sense for two devices on a system to be in two
different countries.

In the case the AP is using country IEs for an incorrect country
the user may help compliance further by setting the regulatory
domain before or after the IE is parsed and in that case another
intersection will be performed.

CONFIG_WIRELESS_OLD_REGULATORY is supported but requires CRDA
present.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This addresses Johannes' latest feedback. It replaces 3/3
of my last series.

 include/linux/ieee80211.h |   62 ++++++
 include/net/wireless.h    |   15 ++
 net/mac80211/mlme.c       |    7 +
 net/wireless/Kconfig      |   11 +
 net/wireless/core.c       |    5 +-
 net/wireless/core.h       |   13 ++
 net/wireless/nl80211.c    |    2 +-
 net/wireless/reg.c        |  479 +++++++++++++++++++++++++++++++++++++++++++--
 net/wireless/reg.h        |   21 ++-
 9 files changed, 591 insertions(+), 24 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 56b0eb2..a6ec928 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1042,6 +1042,68 @@ enum ieee80211_spectrum_mgmt_actioncode {
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/*
+ * IEEE 802.11-2007 7.3.2.9 Country information element
+ *
+ * Minimum length is 8 octets, ie len must be evenly
+ * divisible by 2
+ */
+
+/* Although the spec says 8 I'm seeing 6 in practice */
+#define IEEE80211_COUNTRY_IE_MIN_LEN	6
+
+/*
+ * For regulatory extension stuff see IEEE 802.11-2007
+ * Annex I (page 1141) and Annex J (page 1147). Also
+ * review 7.3.2.9.
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
+ *  Channels numbers in the IE must be monotonically increasing
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
index 17d4b58..618b8aa 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -373,4 +373,19 @@ ieee80211_get_response_rate(struct ieee80211_supported_band *sband,
  * for a regulatory domain structure for the respective country.
  */
 extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
+
+/**
+ * regulatory_hint_11d - hints a country IE as a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @country_ie: pointer to the country IE
+ * @country_ie_len: length of the country IE
+ *
+ * We will intersect the rd with the what CRDA tells us should apply
+ * for the alpha2 this country IE belongs to, this prevents APs from
+ * sending us incorrect or outdated information against a country.
+ */
+extern void regulatory_hint_11d(struct wiphy *wiphy,
+				u8 *country_ie,
+				u8 country_ie_len);
 #endif /* __NET_WIRELESS_H */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 12064fb..c22cb02 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1753,6 +1753,13 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       ap_ht_cap_flags);
 	}
 
+	if (elems.country_elem) {
+		/* Note we are only reviewing this on beacons
+		 * for the BSSID we are associated to */
+		regulatory_hint_11d(local->hw.wiphy,
+			elems.country_elem, elems.country_elem_len);
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index ae7f226..19bee77 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -1,6 +1,15 @@
 config CFG80211
         tristate "Improved wireless configuration API"
 
+config CFG80211_REG_DEBUG
+	bool "cfg80211 regulatory debugging"
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
index 72825af..e2dda15 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -19,7 +19,6 @@
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
-#include "reg.h"
 
 /* name for sysfs, %d is appended */
 #define PHY_NAME "phy"
@@ -349,6 +348,10 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
+	/* If this device got a regulatory hint tell core its
+	 * free to listen now to a new shiny device regulatory hint */
+	reg_device_remove(wiphy);
+
 	list_del(&drv->list);
 	device_del(&drv->wiphy.dev);
 	debugfs_remove(drv->wiphy.debugfsdir);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 771cc5c..f7fb9f4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -11,6 +11,7 @@
 #include <net/genetlink.h>
 #include <net/wireless.h>
 #include <net/cfg80211.h>
+#include "reg.h"
 
 struct cfg80211_registered_device {
 	struct cfg80211_ops *ops;
@@ -21,6 +22,18 @@ struct cfg80211_registered_device {
 	 * any call is in progress */
 	struct mutex mtx;
 
+	/* ISO / IEC 3166 alpha2 for which this device is receiving
+	 * country IEs on, this can help disregard country IEs from APs
+	 * on the same alpha2 quickly. The alpha2 may differ from
+	 * cfg80211_regdomain's alpha2 when an intersection has occurred.
+	 * If the AP is reconfigured this can also be used to tell us if
+	 * the country on the country IE changed. */
+	char country_ie_alpha2[2];
+
+	/* If a Country IE has been received this tells us the environment
+	 * which its telling us its in. This defaults to ENVIRON_ANY */
+	enum environment_cap env;
+
 	/* wiphy index, internal only */
 	int idx;
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e3e1494..00121ce 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1760,7 +1760,7 @@ static int nl80211_req_set_reg(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 #endif
 	mutex_lock(&cfg80211_drv_mutex);
-	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data);
+	r = __regulatory_hint(NULL, REGDOM_SET_BY_USER, data, 0, ENVIRON_ANY);
 	mutex_unlock(&cfg80211_drv_mutex);
 	return r;
 }
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f0ff3d1..4dab993 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -60,12 +60,18 @@
  * @intersect: indicates whether the wireless core should intersect
  * 	the requested regulatory domain with the presently set regulatory
  * 	domain.
+ * @country_ie_checksum: checksum of the last processed and accepted
+ * 	country IE
+ * @country_ie_env: lets us know if the AP is telling us we are outdoor,
+ * 	indoor, or if it doesn't matter
  */
 struct regulatory_request {
 	struct wiphy *wiphy;
 	enum reg_set_by initiator;
 	char alpha2[2];
 	bool intersect;
+	u32 country_ie_checksum;
+	enum environment_cap country_ie_env;
 };
 
 /* Receipt of information from last regulatory request */
@@ -85,6 +91,11 @@ static u32 supported_bandwidths[] = {
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
@@ -264,6 +275,18 @@ static bool is_unknown_alpha2(const char *alpha2)
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
@@ -292,6 +315,25 @@ static bool regdom_changed(const char *alpha2)
 	return true;
 }
 
+/**
+ * country_ie_integrity_changes - tells us if the country IE has changed
+ * @checksum: checksum of country IE of fields we are interested in
+ *
+ * If the country IE has not changed you can ignore it safely. This is
+ * useful to determine if two devices are seeing two different country IEs
+ * even on the same alpha2. Note that this will return false if no IE has
+ * been set on the wireless core yet.
+ */
+static bool country_ie_integrity_changes(u32 checksum)
+{
+	/* If no IE has been set then the checksum doesn't change */
+	if (unlikely(!last_request->country_ie_checksum))
+		return false;
+	if (unlikely(last_request->country_ie_checksum != checksum))
+		return true;
+	return false;
+}
+
 /* This lets us keep regulatory code which is updated on a regulatory
  * basis in userspace. */
 static int call_crda(const char *alpha2)
@@ -379,6 +421,174 @@ static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
 	return 0;
 }
 
+/* Converts a country IE to a regulatory domain. A regulatory domain
+ * structure has a lot of information which the IE doesn't yet have,
+ * so for the other values we use upper max values as we will intersect
+ * with our userspace regulatory agent to get lower bounds. */
+static struct ieee80211_regdomain *country_ie_2_rd(
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
+	*checksum ^= ((flags ^ alpha2[0] ^ alpha2[1]) << 8);
+
+	/* We need to build a reg rule for each triplet, but first we must
+	 * calculate the number of reg rules we will need. We will need one
+	 * for each channel subband */
+	while (country_ie_len >= 3) {
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) country_ie;
+		int cur_sub_max_channel = 0, cur_channel = 0;
+
+		if (triplet->ext.reg_extension_id >=
+				IEEE80211_COUNTRY_EXTENSION_ID) {
+			country_ie += 3;
+			country_ie_len -= 3;
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
+		*checksum ^= ((cur_channel ^ cur_sub_max_channel) << 8) |
+		  ((cur_sub_max_channel ^ cur_sub_max_channel) << 16) |
+		  ((triplet->chans.max_power ^ cur_sub_max_channel) << 24);
+
+		last_sub_max_channel = cur_sub_max_channel;
+
+		country_ie += 3;
+		country_ie_len -= 3;
+		num_rules++;
+
+		/* Note: this is not a IEEE requirement but
+		 * simply a memory requirement */
+		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
+			return NULL;
+	}
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
+	while (country_ie_len >= 3) {
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
+			country_ie += 3;
+			country_ie_len -= 3;
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
+				triplet->chans.first_channel) - 10);
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
+		country_ie += 3;
+		country_ie_len -= 3;
+		i++;
+
+		BUG_ON(i > NL80211_MAX_SUPP_REG_RULES);
+	}
+
+	return rd;
+}
+
+
 /* Helper for regdom_intersect(), this does the real
  * mathematical intersection fun */
 static int reg_rules_intersect(
@@ -663,16 +873,14 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 					return -EOPNOTSUPP;
 				return -EALREADY;
 			}
-			/* Two consecutive Country IE hints on the same wiphy */
-			if (!alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			/* Two consecutive Country IE hints on the same wiphy.
+			 * This should be picked up early by the driver/stack */
+			if (WARN_ON(!alpha2_equal(cfg80211_regdomain->alpha2,
+				  alpha2)))
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
@@ -680,6 +888,11 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
 			return REG_INTERSECT;
+		/* If the user knows better the user should set the regdom
+		 * to their country before the IE is picked up */
+		if (last_request->initiator == REGDOM_SET_BY_USER &&
+			  last_request->intersect)
+			return -EOPNOTSUPP;
 		return 0;
 	}
 
@@ -688,7 +901,9 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 
 /* Caller must hold &cfg80211_drv_mutex */
 int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-		      const char *alpha2)
+			const char *alpha2,
+			u32 country_ie_checksum,
+			enum environment_cap env)
 {
 	struct regulatory_request *request;
 	bool intersect = false;
@@ -711,9 +926,21 @@ int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
 	request->initiator = set_by;
 	request->wiphy = wiphy;
 	request->intersect = intersect;
+	request->country_ie_checksum = country_ie_checksum;
+	request->country_ie_env = env;
 
 	kfree(last_request);
 	last_request = request;
+	/*
+	 * Note: When CONFIG_WIRELESS_OLD_REGULATORY is enabled
+	 * AND if CRDA is NOT present nothing will happen, if someone
+	 * wants to bother with 11d with OLD_REG you can add a timer.
+	 * If after x amount of time nothing happens you can call:
+	 *
+	 * return set_regdom(country_ie_regdomain);
+	 *
+	 * to intersect with the static rd
+	 */
 	return call_crda(alpha2);
 }
 
@@ -722,11 +949,120 @@ void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 	BUG_ON(!alpha2);
 
 	mutex_lock(&cfg80211_drv_mutex);
-	__regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2);
+	__regulatory_hint(wiphy, REGDOM_SET_BY_DRIVER, alpha2, 0, ENVIRON_ANY);
 	mutex_unlock(&cfg80211_drv_mutex);
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+static bool reg_same_country_ie_hint(struct wiphy *wiphy,
+			u32 country_ie_checksum)
+{
+	if (!last_request->wiphy)
+		return false;
+	if (likely(last_request->wiphy != wiphy))
+		return !country_ie_integrity_changes(country_ie_checksum);
+	/* We should not have let these through at this point, they
+	 * should have been picked up earlier by the first alpha2 check
+	 * on the device */
+	if (WARN_ON(!country_ie_integrity_changes(country_ie_checksum)))
+		return true;
+	return false;
+}
+
+void regulatory_hint_11d(struct wiphy *wiphy,
+			u8 *country_ie,
+			u8 country_ie_len)
+{
+	struct ieee80211_regdomain *rd = NULL;
+	char alpha2[2];
+	u32 checksum = 0;
+	enum environment_cap env = ENVIRON_ANY;
+
+	mutex_lock(&cfg80211_drv_mutex);
+
+	/* IE len must be evenly divisible by 2 */
+	if (country_ie_len & 0x01)
+		goto out;
+
+	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
+		goto out;
+
+	/* Pending country IE processing, this can happen after we
+	 * call CRDA and wait for a response if a beacon was received before
+	 * we were able to process the last regulatory_hint_11d() call */
+	if (country_ie_regdomain)
+		goto out;
+
+	alpha2[0] = country_ie[0];
+	alpha2[1] = country_ie[1];
+
+	if (country_ie[2] == 'I')
+		env = ENVIRON_INDOOR;
+	else if (country_ie[2] == 'O')
+		env = ENVIRON_OUTDOOR;
+
+	/* We will run this for *every* beacon processed for the BSSID, so
+	 * we optimize an early check to exit out early if we don't have to
+	 * do anything */
+	if (likely(last_request->wiphy)) {
+		struct cfg80211_registered_device *drv_last_ie;
+
+		drv_last_ie = wiphy_to_dev(last_request->wiphy);
+
+		/* Lets keep this simple -- we trust the first AP
+		 * after we intersect with CRDA */
+		if (likely(last_request->wiphy == wiphy)) {
+			/* Ignore IEs coming in on this wiphy with
+			 * the same alpha2 and environment cap */
+			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
+				  alpha2) &&
+				  env == drv_last_ie->env)) {
+				goto out;
+			}
+			/* the wiphy moved on to another BSSID or the AP
+			 * was reconfigured. XXX: We need to deal with the
+			 * case where the user suspends and goes to goes
+			 * to another country, and then gets IEs from an
+			 * AP with different settings */
+			goto out;
+		} else {
+			/* Ignore IEs coming in on two separate wiphys with
+			 * the same alpha2 and environment cap */
+			if (likely(alpha2_equal(drv_last_ie->country_ie_alpha2,
+				  alpha2) &&
+				  env == drv_last_ie->env)) {
+				goto out;
+			}
+			/* We could potentially intersect though */
+			goto out;
+		}
+	}
+
+	rd = country_ie_2_rd(country_ie, country_ie_len, &checksum);
+	if (!rd)
+		goto out;
+
+	/* This will not happen right now but we leave it here for the
+	 * the future when we want to add suspend/resume support and having
+	 * the user move to another country after doing so, or having the user
+	 * move to another AP. Right now we just trust the first AP. This is why
+	 * this is marked as likley(). If we hit this before we add this support
+	 * we want to be informed of it as it would indicate a mistake in the
+	 * current design  */
+	if (likely(WARN_ON(reg_same_country_ie_hint(wiphy, checksum))))
+		goto out;
+
+	/* We keep this around for when CRDA comes back with a response so
+	 * we can intersect with that */
+	country_ie_regdomain = rd;
+
+	__regulatory_hint(wiphy, REGDOM_SET_BY_COUNTRY_IE,
+		country_ie_regdomain->alpha2, checksum, env);
+
+out:
+	mutex_unlock(&cfg80211_drv_mutex);
+}
+EXPORT_SYMBOL(regulatory_hint_11d);
 
 static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
@@ -766,7 +1102,25 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
 static void print_regdomain(const struct ieee80211_regdomain *rd)
 {
 
-	if (is_world_regdom(rd->alpha2))
+	if (is_intersected_alpha2(rd->alpha2)) {
+		struct wiphy *wiphy = NULL;
+		struct cfg80211_registered_device *drv;
+
+		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+			if (last_request->wiphy) {
+				wiphy = last_request->wiphy;
+				drv = wiphy_to_dev(wiphy);
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"domain updated by AP to: %c%c\n",
+					drv->country_ie_alpha2[0],
+					drv->country_ie_alpha2[1]);
+			} else
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"domain intersected: \n");
+		} else
+				printk(KERN_INFO "cfg80211: Current regulatory "
+					"intersected: \n");
+	} else if (is_world_regdom(rd->alpha2))
 		printk(KERN_INFO "cfg80211: World regulatory "
 			"domain updated:\n");
 	else {
@@ -789,10 +1143,39 @@ static void print_regdomain_info(const struct ieee80211_regdomain *rd)
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
+}
+#endif
+
 /* Takes ownership of rd only if it doesn't fail */
 static int __set_regdom(const struct ieee80211_regdomain *rd)
 {
 	const struct ieee80211_regdomain *intersected_rd = NULL;
+	struct cfg80211_registered_device *drv = NULL;
+	struct wiphy *wiphy = NULL;
 	/* Some basic sanity checks first */
 
 	if (is_world_regdom(rd->alpha2)) {
@@ -809,10 +1192,18 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
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
@@ -853,9 +1244,47 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 		return 0;
 	}
 
-	/* Country IE parsing coming soon */
+	/*
+	 * Country IE requests are handled a bit differently, we intersect
+	 * the country IE rd with what CRDA believes that country should have
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
+	drv = wiphy_to_dev(wiphy);
+
+	drv->country_ie_alpha2[0] = rd->alpha2[0];
+	drv->country_ie_alpha2[1] = rd->alpha2[1];
+	drv->env = last_request->country_ie_env;
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
@@ -887,6 +1316,17 @@ int set_regdom(const struct ieee80211_regdomain *rd)
 	return r;
 }
 
+/* Caller must hold cfg80211_drv_mutex */
+void reg_device_remove(struct wiphy *wiphy)
+{
+	if (!last_request->wiphy)
+		return;
+	if (last_request->wiphy != wiphy)
+		return;
+	last_request->wiphy = NULL;
+	last_request->country_ie_env = ENVIRON_ANY;
+}
+
 int regulatory_init(void)
 {
 	int err;
@@ -906,11 +1346,11 @@ int regulatory_init(void)
 	 * that is not a valid ISO / IEC 3166 alpha2 */
 	if (ieee80211_regdom[0] != 'E' || ieee80211_regdom[1] != 'U')
 		err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE,
-					ieee80211_regdom);
+					ieee80211_regdom, 0, ENVIRON_ANY);
 #else
 	cfg80211_regdomain = cfg80211_world_regdom;
 
-	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00");
+	err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0, ENVIRON_ANY);
 	if (err)
 		printk(KERN_ERR "cfg80211: calling CRDA failed - "
 		       "unable to update world regulatory domain, "
@@ -926,6 +1366,9 @@ void regulatory_exit(void)
 
 	reset_regdomains();
 
+	kfree(country_ie_regdomain);
+	country_ie_regdomain = NULL;
+
 	kfree(last_request);
 
 	platform_device_unregister(reg_pdev);
diff --git a/net/wireless/reg.h b/net/wireless/reg.h
index c9b6b63..a76ea3f 100644
--- a/net/wireless/reg.h
+++ b/net/wireless/reg.h
@@ -4,28 +4,41 @@
 bool is_world_regdom(const char *alpha2);
 bool reg_is_valid_request(const char *alpha2);
 
+void reg_device_remove(struct wiphy *wiphy);
+
 int regulatory_init(void);
 void regulatory_exit(void);
 
 int set_regdom(const struct ieee80211_regdomain *rd);
 
+enum environment_cap {
+	ENVIRON_ANY,
+	ENVIRON_INDOOR,
+	ENVIRON_OUTDOOR,
+};
+
+
 /**
  * __regulatory_hint - hint to the wireless core a regulatory domain
  * @wiphy: if the hint comes from country information from an AP, this
  *	is required to be set to the wiphy that received the information
  * @alpha2: the ISO/IEC 3166 alpha2 being claimed the regulatory domain
  *	should be in.
+ * @country_ie_checksum: checksum of processed country IE, set this to 0
+ * 	if the hint did not come from a country IE
+ * @country_ie_env: the environment the IE told us we are in, %ENVIRON_*
  *
  * The Wireless subsystem can use this function to hint to the wireless core
- * what it believes should be the current regulatory domain by
- * giving it an ISO/IEC 3166 alpha2 country code it knows its regulatory
- * domain should be in.
+ * what it believes should be the current regulatory domain by giving it an
+ * ISO/IEC 3166 alpha2 country code it knows its regulatory domain should be
+ * in.
  *
  * Returns zero if all went fine, %-EALREADY if a regulatory domain had
  * already been set or other standard error codes.
  *
  */
 extern int __regulatory_hint(struct wiphy *wiphy, enum reg_set_by set_by,
-			     const char *alpha2);
+			     const char *alpha2, u32 country_ie_checksum,
+			     enum environment_cap country_ie_env);
 
 #endif  /* __NET_WIRELESS_REG_H */
-- 
1.5.6.3

