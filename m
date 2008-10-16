Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49192 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYJPSiz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 14:38:55 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2008 11:38:55 -0700
Date: Thu, 16 Oct 2008 04:38:48 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Zhu Yi <yi.zhu@intel.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: New Regulatory Domain Api.
Message-ID: <20081016113848.GB5899@tesla> (sfid-20081016_203859_641374_7ED62E05)
References: <20081015112517.GF6509@tesla> <1224098748.28173.32.camel@californication> <20081015131622.GH6509@tesla> <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com> <20081015170830.GA15902@tesla> <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com> <20081015174447.GF15902@tesla> <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com> <20081015185636.GH15902@tesla> <1224126030.24677.78.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1224126030.24677.78.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2008 at 08:00:30PM -0700, Zhu Yi wrote:
> On Wed, 2008-10-15 at 12:56 -0600, Luis R. Rodriguez wrote:
> > On Wed, Oct 15, 2008 at 05:57:20PM -0700, Tomas Winkler wrote:
> > > On Wed, Oct 15, 2008 at 7:44 PM, Luis R. Rodriguez
> > > <lrodriguez@atheros.com> wrote:
> > > > Anyway since you only have 3 this should be very simple to resolve...
> > > > Just add the 5 GHz frequency ranges you always support. Obviously the BG
> > > > card will not be able to make use of them :)
> > >
> > > It's ugly but possible w/a but we still have 3945 and 4965 where it is
> > > not so simple.
> >
> > Ah. I see. Ok then please try this patch. What do you guys think?
> 
> With this patch, the second card own A band reg_rules are not enforced
> for itself. (Still use the first card BG, second card ABG example.)
> Think about the second card is not Intel like card which enforces the
> regulatory in the firmware. The second card uses alpha2 hint. But the
> regdomain allows ALL A band channels.

So.. you didn't look at the code to check where it may have failed...

Anyway try this one. This changes two lines, it checks if the band check
was already true, if so it doesn't overwrite it. If I get a chance I'll
test it.

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 626dbb6..25b6f19 100644
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
@@ -510,6 +541,13 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 		rr = &cfg80211_regdomain->reg_rules[i];
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
 		if (max_bandwidth && *bandwidth <= max_bandwidth) {
 			*reg_rule = rr;
@@ -518,6 +556,9 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 		}
 	}
 
+	if (!band_rule_found)
+		return -ERANGE;
+
 	return !max_bandwidth;
 }
 
@@ -533,8 +574,15 @@ static void handle_channel(struct ieee80211_channel *chan)
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
 
