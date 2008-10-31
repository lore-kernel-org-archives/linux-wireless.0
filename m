Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49833 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYJaEnd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 00:43:33 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 30 Oct 2008 21:43:33 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [RFC] wireless: Add 802.11d support
Date: Thu, 30 Oct 2008 21:43:31 -0700
Message-ID: <1225428211-17353-1-git-send-email-lrodriguez@atheros.com> (sfid-20081031_054338_414241_747AA340)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds 802.11d support to mac80211 and cfg80211.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

This is not complete, I'm missing the reg.c part, but figured
I'd send it out for review to get comments now. Anyone know what the
country IE extension thing is? A quick glance at 11d gave me nothing.

 include/linux/ieee80211.h |   19 +++++
 include/net/wireless.h    |   11 +++
 net/mac80211/mlme.c       |  174 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/reg.c        |    7 ++
 4 files changed, 211 insertions(+), 0 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index aad9919..40f5e2a 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1032,6 +1032,25 @@ enum ieee80211_spectrum_mgmt_actioncode {
 	WLAN_ACTION_SPCT_CHL_SWITCH = 4,
 };
 
+/* Extension IDs >= this one indicate the Country IE
+ * has extensions */
+#define IEEE80211_COUNTRY_EXTENSION_ID 201
+
+struct ieee80211_country_ie_triplet {
+	union {
+		struct {
+			u8 first_channel;
+			u8 num_channels;
+			u8 max_power;
+		} __attribute__ ((packed)) chans;
+		struct {
+			u8 extension_id;
+			u8 class;
+			u8 coverage;
+		} __attribute__ ((packed)) ext;
+	};
+} __attribute__ ((packed));
+
 /* BACK action code */
 enum ieee80211_back_actioncode {
 	WLAN_ACTION_ADDBA_REQ = 0,
diff --git a/include/net/wireless.h b/include/net/wireless.h
index 41294c5..f148a02 100644
--- a/include/net/wireless.h
+++ b/include/net/wireless.h
@@ -357,4 +357,15 @@ ieee80211_get_channel(struct wiphy *wiphy, int freq)
  * for a regulatory domain structure for the respective country.
  */
 extern void regulatory_hint(struct wiphy *wiphy, const char *alpha2);
+
+/**
+ * regulatory_hint_ie - wireless stack hints a regulatory domain
+ * @wiphy: the wireless device giving the hint (used only for reporting
+ *	conflicts)
+ * @rd: a regulatory domain built from the received country IE
+ *
+ * We will intersect the rd ... etc
+ */
+extern int regulatory_hint_ie(struct wiphy *wiphy,
+	struct ieee80211_regdomain *rd);
 #endif /* __NET_WIRELESS_H */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d5006b2..388d13c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -648,6 +648,169 @@ static void ieee80211_sta_send_apinfo(struct ieee80211_sub_if_data *sdata,
 	wireless_send_event(sdata->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
+/* Converts a country IE to a regulatory domain. A regulatory domain
+ * structure has a lot of information which the IE doesn't yet have,
+ * so for the other values we use upper max values as we will intersect
+ * with our userspace regulaotry agent to get lower bounds. This needs
+ * review for 802.11j considerations, keep in mind the first_channel
+ * cannot be >= 201 as that means its an extension */
+struct ieee80211_regdomain *ieee80211_country_ie_2_rd(
+				u8 *country_ie, u8 country_ie_len)
+{
+	struct ieee80211_regdomain *rd = NULL;
+	u32 flags = 0;
+	u32 num_rules = 0, size_of_regd = 0;
+	u8 *triplets_start = NULL;
+	u8 len_at_triplet = 0;
+	unsigned int i = 0;
+	/* Used too often */
+	int triplet_size = sizeof(struct ieee80211_country_ie_triplet);
+
+	rd->alpha2[0] = country_ie[0];
+	rd->alpha2[1] = country_ie[1];
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
+	/* We need to build a reg rule for each triplet, but first we must
+	 * calculate the number of reg rules we will need. We will need one
+	 * for each channel subband */
+	while (country_ie_len >= triplet_size) {
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) country_ie;
+
+		if (triplet->ext.extension_id >= IEEE80211_COUNTRY_EXTENSION_ID) {
+			country_ie += triplet_size;
+			country_ie_len -= triplet_size;
+			continue;
+		}
+
+		country_ie += triplet_size;
+		country_ie_len -= triplet_size;
+		num_rules++;
+
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
+
+	/* This time around we fill in the rd */
+	while (country_ie_len >= triplet_size) {
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) country_ie;
+		struct ieee80211_reg_rule *reg_rule = NULL;
+		struct ieee80211_freq_range *freq_range = NULL;
+		struct ieee80211_power_rule *power_rule = NULL;
+
+		/* Not sure what these guys are yet, or how to handle them, but
+		 * it means we use the 'ext' part of the union instead
+		 * of 'chan' */
+		if (triplet->ext.extension_id >=
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
+		 * its start and end freqs */
+		freq_range->start_freq_khz =
+			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
+				triplet->chans.first_channel) + 10);
+		freq_range->end_freq_khz =
+			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
+				triplet->chans.first_channel +
+					triplet->chans.num_channels) + 10);
+
+
+#ifdef CONFIG_WIRELESS_OLD_REGULATORY
+		/* We can't expect to have anything to intersect with...
+		 * so use standard low values */
+		freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
+		power_rule->max_antenna_gain = DBI_TO_MBI(6);
+		power_rule->max_eirp = DBM_TO_MBM(20);
+#else
+		/* Large arbitrary values, we intersect later */
+		/* Increment this if we ever support >= 40 MHz channels
+		 * in IEEE 802.11 */
+		freq_range->max_bandwidth_khz = MHZ_TO_KHZ(40);
+		power_rule->max_antenna_gain = DBI_TO_MBI(100);
+		power_rule->max_eirp = DBM_TO_MBM(100);
+#endif
+
+		country_ie += triplet_size;
+		country_ie_len -= triplet_size;
+		i++;
+
+		BUG_ON(i > NL80211_MAX_SUPP_REG_RULES);
+	}
+	return rd;
+}
+
+static int ieee80211_sta_process_country_ie(struct ieee80211_if_sta *ifsta,
+				struct ieee80211_local *local,
+				u8 *country_ie, u8 country_ie_len)
+{
+	struct ieee80211_regdomain *rd = NULL;
+	int r = 0;
+
+	if (country_ie_len < 6)
+		return -EINVAL;
+
+	rd = ieee80211_country_ie_2_rd(country_ie, country_ie_len);
+	if (!rd)
+		return -EINVAL;
+
+	r = regulatory_hint_ie(local->hw.wiphy, rd);
+
+#ifdef CONFIG_WIRELESS_OLD_REGULATORY
+	/* If the userspace regulatory agent is installed when
+	 * OLD_REGULATORY is enabled then great, if not then oh well,
+	 * we'll use low ball values */
+	return 0;
+#endif
+	if (!r) {
+		printk(KERN_ERR "cfg80211: calling CRDA failed - "
+			"unable to get country regulatory information "
+			"for country IE\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static void ieee80211_sta_send_associnfo(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_if_sta *ifsta)
 {
@@ -1686,6 +1849,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 	u32 changed = 0;
 	bool erp_valid;
 	u8 erp_value = 0;
+	int r = 0;
 
 	/* Process beacon from the current BSS */
 	baselen = (u8 *) mgmt->u.beacon.variable - (u8 *) mgmt;
@@ -1745,6 +1909,16 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 					       ap_ht_cap_flags);
 	}
 
+	if (elems.country_elem) {
+		r = ieee80211_sta_process_country_ie(ifsta, local,
+			elems.country_elem, elems.country_elem_len);
+#ifdef CONFIG_MAC80211_VERBOSE_SPECT_MGMT_DEBUG
+		if (!r)
+			printk(KERN_DEBUG "mac80211: Unable to parse "
+				"country IE\n");
+#endif
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 }
 
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4c7e39d..26a11cd 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -740,6 +740,13 @@ void regulatory_hint(struct wiphy *wiphy, const char *alpha2)
 }
 EXPORT_SYMBOL(regulatory_hint);
 
+int regulatory_hint_ie(struct wiphy *wiphy, struct ieee80211_regdomain *rd)
+{
+	/* Intersect rd with cfg80211_regdomain then if that is
+	 * successfull we ... */
+	return 0;
+}
+EXPORT_SYMBOL(regulatory_hint_ie);
 
 static void print_rd_rules(const struct ieee80211_regdomain *rd)
 {
-- 
1.5.6.3

