Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21162 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbYJPB4o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Oct 2008 21:56:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 15 Oct 2008 18:56:43 -0700
Date: Wed, 15 Oct 2008 11:56:36 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081015185636.GH15902@tesla> (sfid-20081016_035648_652055_885998FC)
References: <43e72e890810151039s34ad8d79nd2744847dd254b4e@mail.gmail.com> <1224092868.28173.21.camel@californication> <20081015112517.GF6509@tesla> <1224098748.28173.32.camel@californication> <20081015131622.GH6509@tesla> <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com> <20081015170830.GA15902@tesla> <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com> <20081015174447.GF15902@tesla> <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 05:57:20PM -0700, Tomas Winkler wrote:
> On Wed, Oct 15, 2008 at 7:44 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > Anyway since you only have 3 this should be very simple to resolve...
> > Just add the 5 GHz frequency ranges you always support. Obviously the BG
> > card will not be able to make use of them :)
> 
> It's ugly but possible w/a but we still have 3945 and 4965 where it is
> not so simple.

Ah. I see. Ok then please try this patch. What do you guys think?

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 626dbb6..703382a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -469,6 +469,31 @@ static u32 freq_max_bandwidth(const struct ieee80211_freq_range *freq_range,
 	return 0;
 }
 
+/**
+ * freq_in_rule_band - tells us if a frequency rule is in freqs band
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
+#define ONE_GHZ_IN_HZ	1000000000
+	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_HZ))
+		return true;
+	if (abs(freq_khz - freq_range->end_freq_khz) <= (2 * ONE_GHZ_IN_HZ))
+		return true;
+	return false;
+#undef ONE_GHZ_IN_HZ
+}
+
 /* XXX: add support for the rest of enum nl80211_reg_rule_flags, we may
  * want to just have the channel structure use these */
 static u32 map_regdom_flags(u32 rd_flags)
@@ -492,11 +517,17 @@ static u32 map_regdom_flags(u32 rd_flags)
  * @reg_rule: the regulatory rule which we have for this frequency
  *
  * Use this function to get the regulatory rule for a specific frequency.
+ * It returns 0 if it was able to find a valid regulatory rule which does
+ * apply to the given center_freq otherwise it returns non-zero. It will
+ * also -ERANGE if we determine the given center_freq does not even have
+ * a regulatory rule for a frequency range in the center_freq's band. See
+ * freq_in_rule_band() for our current definition of a band.
  */
 static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 			 const struct ieee80211_reg_rule **reg_rule)
 {
 	int i;
+	bool band_rule_found = false;
 	u32 max_bandwidth = 0;
 
 	if (!cfg80211_regdomain)
@@ -510,6 +541,9 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 		rr = &cfg80211_regdomain->reg_rules[i];
 		fr = &rr->freq_range;
 		pr = &rr->power_rule;
+
+		band_rule_found = freq_in_rule_band(fr, center_freq);
+
 		max_bandwidth = freq_max_bandwidth(fr, center_freq);
 		if (max_bandwidth && *bandwidth <= max_bandwidth) {
 			*reg_rule = rr;
@@ -518,6 +552,9 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 		}
 	}
 
+	if (!band_rule_found)
+		return -ERANGE;
+
 	return !max_bandwidth;
 }
 
@@ -533,8 +570,15 @@ static void handle_channel(struct ieee80211_channel *chan)
 		&max_bandwidth, &reg_rule);
 
 	if (r) {
-		flags |= IEEE80211_CHAN_DISABLED;
-		chan->flags = flags;
+		/* This means a regulatory rule was found with a frequency
+		 * range in center_freq's band. In this case we know the
+		 * regulatory rule has at least *one* regulatory rule for
+		 * the band so we must respect its band definitions. Otherwise
+		 * we assume it may not even know anything about our band */
+		if (r != -ERANGE) {
+			flags |= IEEE80211_CHAN_DISABLED;
+			chan->flags = flags;
+		}
 		return;
 	}
 
