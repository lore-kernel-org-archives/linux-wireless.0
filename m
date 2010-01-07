Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0AGWZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:25:02 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/4] cfg80211: Fix country IE parsing for single channel triplets
Date: Thu,  7 Jan 2010 17:24:57 -0500
Message-Id: <1262903097-2129-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This enhances the way we parse country IEs to minimize
the number of regulatory rules that we create. It also fixes
our current implementation which treated country IE triplets
with only one channel as one independed regulatory rule even
though adjecent rules were also being provided.

Without this patch APs which send country IE information with
a channel triplet for each individual channel will force cfg80211
to deny HT40 operation as a regulatory rule would have been created
independently for each channel and as such configured only for
20 MHz operation.

Although 802.11n APs which send country IEs triplets in this fassion
are likely rare Benoit reports this against the Ubiquity NanoStation M5,
with Country "FR" and HT40 enabled.

Since we now have a helper which parses the triplets in intermediate
steps we now take care extra care to process padding.

Reported-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |  225 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 221 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1695d62..f0859ea 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -485,6 +485,178 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 }
 
 /*
+ * Some APs may send a country IE triplet for each channel they
+ * support and while this is completely overkill and silly we still
+ * need to support it. We avoid making a single rule for each channel
+ * though and to help us with this we use this helper to find the
+ * actual subband end channel. These type of country IE triplet
+ * scenerios are handled then, all yielding two regulaotry rules from
+ * parsing a country IE:
+ *
+ * [1]
+ * [2]
+ * [36]
+ * [40]
+ *
+ * [1]
+ * [2-4]
+ * [5-12]
+ * [36]
+ * [40-44]
+ *
+ * [1-4]
+ * [5-7]
+ * [36-44]
+ * [48-64]
+ *
+ * [36-36]
+ * [40-40]
+ * [44-44]
+ * [48-48]
+ * [52-52]
+ * [56-56]
+ * [60-60]
+ * [64-64]
+ * [100-100]
+ * [104-104]
+ * [108-108]
+ * [112-112]
+ * [116-116]
+ * [120-120]
+ * [124-124]
+ * [128-128]
+ * [132-132]
+ * [136-136]
+ * [140-140]
+ *
+ * Returns 0 if the IE has been found to be invalid in the middle
+ * somewhere.
+ */
+static int max_subband_chan(int orig_cur_chan,
+			    int orig_end_channel,
+			    s8 orig_max_power,
+			    u8 **country_ie,
+			    u8 *country_ie_len)
+{
+	u8 *triplets_start = *country_ie;
+	u8 len_at_triplet = *country_ie_len;
+	int end_subband_chan = orig_end_channel;
+	enum ieee80211_band band;
+
+	/*
+	 * We'll deal with padding for the caller unless
+	 * its not immediate and we don't process any channels
+	 */
+	if (*country_ie_len == 1) {
+		*country_ie += 1;
+		*country_ie_len -= 1;
+		return orig_end_channel;
+	}
+
+	/* Move to the next triplet and then start search */
+	*country_ie += 3;
+	*country_ie_len -= 3;
+
+	if (orig_cur_chan <= 14)
+		band = IEEE80211_BAND_2GHZ;
+	else
+		band = IEEE80211_BAND_5GHZ;
+
+	while (*country_ie_len >= 3) {
+		int end_channel = 0;
+		struct ieee80211_country_ie_triplet *triplet =
+			(struct ieee80211_country_ie_triplet *) *country_ie;
+		int cur_channel = 0, next_expected_chan;
+		enum ieee80211_band next_band = IEEE80211_BAND_2GHZ;
+
+		/* means last triplet is completely unrelated to this one */
+		if (triplet->ext.reg_extension_id >=
+				IEEE80211_COUNTRY_EXTENSION_ID) {
+			*country_ie -= 3;
+			*country_ie_len += 3;
+			break;
+		}
+
+		if (triplet->chans.first_channel == 0) {
+			*country_ie += 1;
+			*country_ie_len -= 1;
+			if (*country_ie_len != 0)
+				return 0;
+			break;
+		}
+
+		/* Monitonically increasing channel order */
+		if (triplet->chans.first_channel <= end_subband_chan)
+			return 0;
+
+		/* 2 GHz */
+		if (triplet->chans.first_channel <= 14) {
+			end_channel = triplet->chans.first_channel +
+				triplet->chans.num_channels - 1;
+		}
+		else {
+			end_channel =  triplet->chans.first_channel +
+				(4 * (triplet->chans.num_channels - 1));
+			next_band = IEEE80211_BAND_5GHZ;
+		}
+
+		if (band != next_band) {
+			*country_ie -= 3;
+			*country_ie_len += 3;
+			break;
+		}
+
+		if (orig_max_power != triplet->chans.max_power) {
+			*country_ie -= 3;
+			*country_ie_len += 3;
+			break;
+		}
+
+		cur_channel = triplet->chans.first_channel;
+
+		/* The key is finding the right next expected channel */
+		if (band == IEEE80211_BAND_2GHZ)
+			next_expected_chan = end_subband_chan + 1;
+		 else
+			next_expected_chan = end_subband_chan + 4;
+
+		if (cur_channel != next_expected_chan) {
+			*country_ie -= 3;
+			*country_ie_len += 3;
+			break;
+		}
+
+		end_subband_chan = end_channel;
+
+		/* Move to the next one */
+		*country_ie += 3;
+		*country_ie_len -= 3;
+
+		/*
+		 * Padding needs to be dealt with if we processed
+		 * some channels.
+		 */
+		if (*country_ie_len == 1) {
+			*country_ie += 1;
+			*country_ie_len -= 1;
+			break;
+		}
+
+		/* If seen, the IE is invalid */
+		if (*country_ie_len == 2)
+			return 0;
+	}
+
+	if (end_subband_chan == orig_end_channel) {
+		*country_ie = triplets_start;
+		*country_ie_len = len_at_triplet;
+		return orig_end_channel;
+	}
+
+	return end_subband_chan;
+}
+
+/*
  * Converts a country IE to a regulatory domain. A regulatory domain
  * structure has a lot of information which the IE doesn't yet have,
  * so for the other values we use upper max values as we will intersect
@@ -552,6 +724,19 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			continue;
 		}
 
+		/*
+		 * APs can add padding to make length divisible
+		 * by two, required by the spec.
+		 */
+		if (triplet->chans.first_channel == 0) {
+			country_ie++;
+			country_ie_len--;
+			/* This is expected to be at the very end only */
+			if (country_ie_len != 0)
+				return NULL;
+			break;
+		}
+
 		/* 2 GHz */
 		if (triplet->chans.first_channel <= 14)
 			end_channel = triplet->chans.first_channel +
@@ -570,6 +755,20 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 				(4 * (triplet->chans.num_channels - 1));
 
 		cur_channel = triplet->chans.first_channel;
+
+		/*
+		 * Enhancement for APs that send a triplet for every channel
+		 * or for whatever reason sends triplets with multiple channels
+		 * separated when in fact they should be together.
+		 */
+		end_channel = max_subband_chan(cur_channel,
+					       end_channel,
+					       triplet->chans.max_power,
+					       &country_ie,
+					       &country_ie_len);
+		if (!end_channel)
+			return NULL;
+
 		cur_sub_max_channel = end_channel;
 
 		/* Basic sanity check */
@@ -600,10 +799,13 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 
 		last_sub_max_channel = cur_sub_max_channel;
 
-		country_ie += 3;
-		country_ie_len -= 3;
 		num_rules++;
 
+		if (country_ie_len >= 3) {
+			country_ie += 3;
+			country_ie_len -= 3;
+		}
+
 		/*
 		 * Note: this is not a IEEE requirement but
 		 * simply a memory requirement
@@ -646,6 +848,12 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			continue;
 		}
 
+		if (triplet->chans.first_channel == 0) {
+			country_ie++;
+			country_ie_len--;
+			break;
+		}
+
 		reg_rule = &rd->reg_rules[i];
 		freq_range = &reg_rule->freq_range;
 		power_rule = &reg_rule->power_rule;
@@ -660,6 +868,12 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			end_channel =  triplet->chans.first_channel +
 				(4 * (triplet->chans.num_channels - 1));
 
+		end_channel = max_subband_chan(triplet->chans.first_channel,
+					       end_channel,
+					       triplet->chans.max_power,
+					       &country_ie,
+					       &country_ie_len);
+
 		/*
 		 * The +10 is since the regulatory domain expects
 		 * the actual band edge, not the center of freq for
@@ -682,10 +896,13 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		power_rule->max_antenna_gain = DBI_TO_MBI(100);
 		power_rule->max_eirp = DBM_TO_MBM(triplet->chans.max_power);
 
-		country_ie += 3;
-		country_ie_len -= 3;
 		i++;
 
+		if (country_ie_len >= 3) {
+			country_ie += 3;
+			country_ie_len -= 3;
+		}
+
 		BUG_ON(i > NL80211_MAX_SUPP_REG_RULES);
 	}
 
-- 
1.6.3.3

