Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17434 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYKGWPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 17:15:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2008 14:15:15 -0800
Date: Fri, 7 Nov 2008 14:15:12 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] cfg80211/mac80211: Add 802.11d support
Message-ID: <20081107221512.GA8344@tesla> (sfid-20081107_231524_851800_CE2A0EC4)
References: <1226005396-10666-1-git-send-email-lrodriguez@atheros.com> <1226093242.11203.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1226093242.11203.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 07, 2008 at 01:27:22PM -0800, Johannes Berg wrote:
> This replaces 3/3, right? Just got confused with the order.

Yes, it does.

> > +/*
> > + * IEEE 802.11-2007 7.3.2.9 Country information element
> > + *
> > + * Minimum length is 8 octects, ie len must be evenly
> 
> typo: octets

I'll fix.

> > +/**
> > + * regulatory_hint_11d - hints a country IE as a regulatory domain
> > + * @wiphy: the wireless device giving the hint (used only for reporting
> > + *	conflicts)
> > + * @country_ie: pointer to the country IE
> > + * @country_ie_len: length of the country IE
> > + *
> > + * We will intersect the rd with the what CRDA tells us should apply
> > + * for the alpha2 this country IE belongs to, this prevents APs from
> > + * sending us incorrect or outdated information against a country.
> > + */
> > +extern void regulatory_hint_11d(struct wiphy *wiphy,
> > +			        u8 *country_ie,
> > +			        u8 country_ie_len);
> 
> that looks good :)
> 
> > +	if (elems.country_elem) {
> > +		/* Note we are only reviewing this on beacons
> > +		 * we are associated to */
> 
> that sounds a little awkward, are we really associated to beacons? :)

I'll fix.

> > diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> > index ae7f226..c40a0f2 100644
> > --- a/net/wireless/Kconfig
> > +++ b/net/wireless/Kconfig
> > @@ -1,6 +1,15 @@
> >  config CFG80211
> >          tristate "Improved wireless configuration API"
> >  
> > +config CFG80211_REG_DEBUG
> > +        bool "cfg80211 regulatory debugging"
> 
> space indentation

I'll fix.

> > index 72825af..e2dda15 100644
> > --- a/net/wireless/core.c
> > +++ b/net/wireless/core.c
> > @@ -19,7 +19,6 @@
> >  #include "nl80211.h"
> >  #include "core.h"
> >  #include "sysfs.h"
> > -#include "reg.h"
> 
> why remove that?

Because core.h adds it now and as you can see core.c includes core.h

> > +/* Converts a country IE to a regulatory domain. A regulatory domain
> > + * structure has a lot of information which the IE doesn't yet have,
> > + * so for the other values we use upper max values as we will intersect
> > + * with our userspace regulatory agent to get lower bounds. */
> > +static struct ieee80211_regdomain *country_ie_2_rd(
> > +				u8 *country_ie,
> > +				u8 country_ie_len,
> > +				u32 *checksum)
> > +{
> > +	struct ieee80211_regdomain *rd = NULL;
> > +	unsigned int i = 0;
> > +	char alpha2[2];
> > +	u32 flags = 0;
> > +	u32 num_rules = 0, size_of_regd = 0;
> > +	u8 *triplets_start = NULL;
> > +	u8 len_at_triplet = 0;
> > +	/* Used too often */
> > +	int triplet_size = sizeof(struct ieee80211_country_ie_triplet);
> 
> It's always like '3', no?

Heh ok.

> > +	int last_sub_max_channel = 0;
> > +
> > +	*checksum = 0xDEADBEEF;
> > +
> > +	/* Country IE requirements */
> > +	BUG_ON(country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN ||
> > +		country_ie_len & 0x01);
> 
> That seems rather dangerous?

Nope, as you discovered below later on.

> > +		/* When dot11RegulatoryClassesRequired is supported
> > +		 * we can throw ext triplets as part of this soup,
> > +		 * for now we don't care when those change as we
> > +		 * don't support them */
> > +		*checksum ^= cur_channel ^ cur_sub_max_channel ^
> > +			triplet->chans.max_power;
> 
> Shouldn't you shift the checksum a bit so that you don't always just use
> the lowest byte of it?

Good point, I'll make use of the 32 bis in the next respin.

> > +		/* Note: this is not a IEEE requirement but
> > +		 * simply a memory requirement */
> > +		if (num_rules > NL80211_MAX_SUPP_REG_RULES)
> > +			return NULL;
> 
> We could set NL80211_MAX_SUPP_REG_RULES to 85 or something, then
> everything would fit. The IE is limited to 255 bytes after all. I don't
> think it matters though.

Good point, but where do  you see the limit is 255 bytes?
If it is I'd rather do this in a separate patch though after this too.

> > +		/* The +10 is since the regulatory domain expects
> > +		 * the actual band edge, not the center of freq for
> > +		 * its start and end freqs, assuming 20 MHz bandwidth on
> > +		 * the channels passed */
> > +		freq_range->start_freq_khz =
> > +			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
> > +				triplet->chans.first_channel) + 10);
> > +		freq_range->end_freq_khz =
> > +			MHZ_TO_KHZ(ieee80211_channel_to_frequency(
> > +				triplet->chans.first_channel +
> > +					triplet->chans.num_channels) + 10);
> 
> Doesn't that have to be -10 in the start freq?

Thanks for picking that up.

> > +static bool reg_same_country_ie_hint(struct wiphy *wiphy,
> > +			u32 country_ie_checksum)
> > +{
> > +	if (!last_request->wiphy)
> > +		return false;
> > +	if (likely(last_request->wiphy != wiphy)) {
> > +		if (likely(!country_ie_integrity_changes(country_ie_checksum)))
> > +			return true;
> > +		return false;
> 
> how about just
> 	return !country_ie_integrity_changes(...);

Sure.

> > +	/* IE len must be evenly divisible by 2 */
> > +	if (country_ie_len & 0x01)
> > +		goto out;
> > +
> > +	if (country_ie_len < IEEE80211_COUNTRY_IE_MIN_LEN)
> > +		goto out;
> 
> ok nevermind, the BUG_ON above won't ever happen because of this.

Yeap.

> > +	/* Pending country IE processing, this can happen after we
> > +	 * call CRDA and wait for a response if a beacon was received before
> > +	 * we were able to process the last regulatory_hint_11d() call */
> > +	if (country_ie_regdomain)
> > +		goto out;
> > +
> > +	alpha2[0] = country_ie[0];
> > +	alpha2[1] = country_ie[1];
> > +
> > +	if (country_ie[2] == 'I')
> > +		env = ENVIRON_INDOOR;
> > +	else if (country_ie[2] == 'O')
> > +		env = ENVIRON_OUTDOOR;
> > +
> > +	/* We will run this for *every* beacon processed for the BSSID, so
> > +	 * we optimize an early check to exit out early if we don't have to
> > +	 * do anything */
> 
> hopefully soon we won't be processing that many beacons but only changed
> ones :)

Yeap...

> > +	rd = country_ie_2_rd(country_ie, country_ie_len, &checksum);
> > +	if (!rd)
> > +		goto out;
> > +
> > +	/* This shouldn't happen right now */
> > +	if (likely(reg_same_country_ie_hint(wiphy, checksum)))
> > +		goto out;
> 
> "shouldn't happen"

I meant that since we now check for alpha+env on the secondary devices
we shouldn't run into this.

> doesn't really go with likely()?

But if we do, it would be under some future circumstance like
suspend/resume and going to a different country or moving to
another AP as you had suggested. I'll add a WARN_ON() and also
add a good comment about this.

> Overall looks pretty good to me. Much better than before, don't you
> think? :)

Sure thing, I was just a bit hesitant to move IE handling code to
cfg80211 but in this case it makes sense. Sure makes it easier to follow
I hope.

  Luis
