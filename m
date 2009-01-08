Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41668 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756912AbZAHBoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2009 20:44:08 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jan 2009 17:44:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 5/6] cfg80211: Fix regression with 11d on bands
Date: Wed, 7 Jan 2009 17:43:36 -0800
Message-ID: <1231379017-28363-6-git-send-email-lrodriguez@atheros.com> (sfid-20090108_024414_721844_A3AACB29)
In-Reply-To: <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
References: <1231379017-28363-1-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-2-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-3-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-4-git-send-email-lrodriguez@atheros.com>
 <1231379017-28363-5-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a regression on disallowing bands introduced with the new
802.11d support. The issue is that IEEE-802.11 allows APs to send
a subset of what a country regulatory domain defines. This was clarified
in this document:

http://tinyurl.com/11d-clarification

As such it is possible, and this is what is done in practice, that a
single band 2.4 GHz AP will only send 2.4 GHz band regulatory information
through the 802.11 country information element and then the current
intersection with what CRDA provided yields a regulatory domain with
no 5 GHz information -- even though that country may actually allow
5 GHz operation. We correct this by only applying the intersection rules
on a channel if the the intersection yields a regulatory rule on the
same band the channel is on.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   77 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3d56a1d..bea98ed 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -421,6 +421,31 @@ static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
 	return 0;
 }
 
+/**
+ * freq_in_rule_band - tells us if a frequency is in a frequency band
+ * @freq_range: frequency rule we want to query
+ * @freq_khz: frequency we are inquiring about
+ *
+ * This lets us know if a specific frequency rule is or is not relevant to
+ * a specific frequency's band. Bands are device specific and artificial
+ * definitions (the "2.4 GHz band" and the "5 GHz band"), however it is
+ * safe for now to assume that a frequency rule should not be part of a
+ * frequency's band if the start freq or end freq are off by more than 2 GHz.
+ * This resolution can be lowered and should be considered as we add
+ * regulatory rule support for other "bands".
+ **/
+static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
+	u32 freq_khz)
+{
+#define ONE_GHZ_IN_KHZ	1000000
+	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
+		return true;
+	if (abs(freq_khz - freq_range->end_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
+		return true;
+	return false;
+#undef ONE_GHZ_IN_KHZ
+}
+
 /* Converts a country IE to a regulatory domain. A regulatory domain
  * structure has a lot of information which the IE doesn't yet have,
  * so for the other values we use upper max values as we will intersect
@@ -753,11 +778,19 @@ static u32 map_regdom_flags(u32 rd_flags)
  * a given wireless device. If the device has a specific regulatory domain
  * it wants to follow we respect that unless a country IE has been received
  * and processed already.
+ *
+ * Returns 0 if it was able to find a valid regulatory rule which does
+ * apply to the given center_freq otherwise it returns non-zero. It will
+ * also return -ERANGE if we determine the given center_freq does not even have
+ * a regulatory rule for a frequency range in the center_freq's band. See
+ * freq_in_rule_band() for our current definition of a band -- this is purely
+ * subjective and right now its 802.11 specific.
  */
 static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 			 const struct ieee80211_reg_rule **reg_rule)
 {
 	int i;
+	bool band_rule_found = false;
 	const struct ieee80211_regdomain *regd;
 	u32 max_bandwidth = 0;
 
@@ -780,7 +813,15 @@ static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 		rr = &regd->reg_rules[i];
 		fr = &rr->freq_range;
 		pr = &rr->power_rule;
+
+		/* We only need to know if one frequency rule was
+		 * was in center_freq's band, that's enough, so lets
+		 * not overwrite it once found */
+		if (!band_rule_found)
+			band_rule_found = freq_in_rule_band(fr, center_freq);
+
 		max_bandwidth = freq_max_bandwidth(fr, center_freq);
+
 		if (max_bandwidth && *bandwidth <= max_bandwidth) {
 			*reg_rule = rr;
 			*bandwidth = max_bandwidth;
@@ -788,6 +829,9 @@ static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
 		}
 	}
 
+	if (!band_rule_found)
+		return -ERANGE;
+
 	return !max_bandwidth;
 }
 
@@ -812,8 +856,37 @@ static void handle_channel(struct wiphy *wiphy, enum ieee80211_band band,
 		&max_bandwidth, &reg_rule);
 
 	if (r) {
-		flags |= IEEE80211_CHAN_DISABLED;
-		chan->flags = flags;
+		/* This means no regulatory rule was found in the country IE
+		 * with a frequency range on the center_freq's band, since
+		 * IEEE-802.11 allows for a country IE to have a subset of the
+		 * regulatory information provided in a country we ignore
+		 * disabling the channel unless at least one reg rule was
+		 * found on the center_freq's band. For details see this
+		 * clarification:
+		 *
+		 * http://tinyurl.com/11d-clarification
+		 */
+		if (r == -ERANGE &&
+		    last_request->initiator == REGDOM_SET_BY_COUNTRY_IE) {
+#ifdef CONFIG_CFG80211_REG_DEBUG
+			printk(KERN_DEBUG "cfg80211: Leaving channel %d MHz "
+				"intact on %s - no rule found in band on "
+				"Country IE\n",
+				chan->center_freq, wiphy_name(wiphy));
+#endif
+		} else {
+		/* In this case we know the country IE has at least one reg rule
+		 * for the band so we respect its band definitions */
+#ifdef CONFIG_CFG80211_REG_DEBUG
+			if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
+				printk(KERN_DEBUG "cfg80211: Disabling "
+					"channel %d MHz on %s due to "
+					"Country IE\n",
+					chan->center_freq, wiphy_name(wiphy));
+#endif
+			flags |= IEEE80211_CHAN_DISABLED;
+			chan->flags = flags;
+		}
 		return;
 	}
 
-- 
1.6.1.rc3.51.g5832d

