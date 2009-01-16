Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:47194 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbZAPQhP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 11:37:15 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2009 08:37:15 -0800
Date: Fri, 16 Jan 2009 08:36:46 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
Message-ID: <20090116163646.GG29609@tesla> (sfid-20090116_173722_645253_E8613A24)
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com> <1232064746-17134-2-git-send-email-lrodriguez@atheros.com> <1232064746-17134-3-git-send-email-lrodriguez@atheros.com> <1232064746-17134-4-git-send-email-lrodriguez@atheros.com> <1232097659.3854.20.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232097659.3854.20.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 16, 2009 at 01:20:59AM -0800, Johannes Berg wrote:
> On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> 
> >  /**
> >   * enum reg_set_by - Indicates who is trying to set the regulatory domain
> > + * @REGDOM_SET_BY_PROBE: regulatory domain applied came prior to wiphy
> > + * 	registration by the driver itself using some custom regulatory
> > + * 	information.
> 
> This is unnecessary, I think.

I'll make note of it below.

> > +/**
> > + * freq_reg_info - get regulatory information for the given frequency
> > + * @wiphy: the wiphy for which we want to process this rule for
> > + * @center_freq: Frequency in KHz for which we want regulatory information for
> > + * @bandwidth: the bandwidth requirement you have in KHz, if you do not have one
> > + * 	you can set this to 0. If this frequency is allowed we then set
> > + * 	this value to the maximum allowed bandwidth.
> > + * @reg_rule: the regulatory rule which we have for this frequency
> > + *
> > + * Use this function to get the regulatory rule for a specific frequency on
> > + * a given wireless device. If the device has a specific regulatory domain
> > + * it wants to follow we respect that unless a country IE has been received
> > + * and processed already.
> > + *
> > + * Returns 0 if it was able to find a valid regulatory rule which does
> > + * apply to the given center_freq otherwise it returns non-zero. It will
> > + * also return -ERANGE if we determine the given center_freq does not even have
> > + * a regulatory rule for a frequency range in the center_freq's band. See
> > + * freq_in_rule_band() for our current definition of a band -- this is purely
> > + * subjective and right now its 802.11 specific.
> > + */
> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 *bandwidth,
> > +			 const struct ieee80211_reg_rule **reg_rule)
> > +{
> > +	return freq_reg_info_regd(wiphy, center_freq,
> > +		bandwidth, reg_rule, NULL);
> > +}
> 
> Are you not using this or am I just not seeing the user?

Yeah -- good catch, its just cruft left over from my previous work.

> > +static void handle_channel_custom(struct wiphy *wiphy,
> > +				  enum ieee80211_band band,
> > +				  unsigned int chan_idx,
> > +				  const struct ieee80211_regdomain *regd)
> > +{
> > +	int r;
> > +	u32 max_bandwidth = 0;
> > +	const struct ieee80211_reg_rule *reg_rule = NULL;
> > +	const struct ieee80211_power_rule *power_rule = NULL;
> > +	struct ieee80211_supported_band *sband;
> > +	struct ieee80211_channel *chan;
> > +
> > +	sband = wiphy->bands[band];
> > +	BUG_ON(chan_idx >= sband->n_channels);
> > +	chan = &sband->channels[chan_idx];
> > +
> > +	r = freq_reg_info_regd(wiphy, MHZ_TO_KHZ(chan->center_freq),
> > +		&max_bandwidth, &reg_rule, regd);
> > +
> > +	if (r) {
> > +		chan->flags = IEEE80211_CHAN_DISABLED;
> > +		return;
> > +	}
> > +
> > +	power_rule = &reg_rule->power_rule;
> > +
> > +	chan->flags |= map_regdom_flags(reg_rule->flags);
> > +	chan->max_antenna_gain = (int) MBI_TO_DBI(power_rule->max_antenna_gain);
> > +	chan->max_bandwidth = KHZ_TO_MHZ(max_bandwidth);
> > +	chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
> > +}
> > +
> > +
> >  static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
> >  {
> >  	unsigned int i;
> > @@ -947,6 +989,19 @@ static void handle_band(struct wiphy *wiphy, enum ieee80211_band band)
> >  		handle_channel(wiphy, band, i);
> >  }
> >  
> > +static void handle_band_custom(struct wiphy *wiphy, enum ieee80211_band band,
> > +			       const struct ieee80211_regdomain *regd)
> > +{
> > +	unsigned int i;
> > +	struct ieee80211_supported_band *sband;
> > +
> > +	BUG_ON(!wiphy->bands[band]);
> > +	sband = wiphy->bands[band];
> > +
> > +	for (i = 0; i < sband->n_channels; i++)
> > +		handle_channel_custom(wiphy, band, i, regd);
> > +}
> > +
> >  static bool ignore_reg_update(struct wiphy *wiphy, enum reg_set_by setby)
> >  {
> >  	if (!last_request)
> > @@ -977,6 +1032,20 @@ void wiphy_update_regulatory(struct wiphy *wiphy, enum reg_set_by setby)
> >  		wiphy->reg_notifier(wiphy, setby);
> >  }
> >  
> > +/* Used by drivers prior to wiphy registration */
> > +void wiphy_apply_custom_regulatory(struct wiphy *wiphy,
> > +				   const struct ieee80211_regdomain *regd)
> > +{
> > +	enum ieee80211_band band;
> > +	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
> > +		if (wiphy->bands[band])
> > +			handle_band_custom(wiphy, band, regd);
> > +	}
> > +	if (wiphy->reg_notifier)
> > +		wiphy->reg_notifier(wiphy, REGDOM_SET_BY_PROBE);
> > +}
> > +EXPORT_SYMBOL(wiphy_apply_custom_regulatory);
> 
> Can you group all these functions together, rather than interspersing
> them with the others?

Yeah sure.

> Also, I don't think calling the notifier is
> appropriate since the driver just called this function.

Calling the notifier is why we want REGDOM_SET_BY_PROBE. We also technically
do not need to call the notifier unless we want to allow for tricks like the
one I am using in ath9k to condense the regulatory domains to 5 based on frequency
and to let a helper sort out the flags. Without this I believe we'd be forced to
use 12 full blown regds.

  Luis
