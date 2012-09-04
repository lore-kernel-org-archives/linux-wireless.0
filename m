Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40252 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2IDIY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 04:24:56 -0400
Message-ID: <1346747134.3737.10.camel@jlt4.sipsolutions.net> (sfid-20120904_102501_159627_DCB05000)
Subject: Re: [RFC] cfg80211: VHT regulatory
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Tue, 04 Sep 2012 10:25:34 +0200
In-Reply-To: <50457491.9020604@posedge.com>
References: <50457491.9020604@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 08:55 +0530, Mahesh Palivela wrote:

>   include/net/cfg80211.h |   36 ++++++++++++++++
>   net/wireless/reg.c     |  104 
> ++++++++++++++++++++++++++++++++++++++++++++++++

Even for an RFC patch it'd be nice to not mangle it :)

>   /**
> + * struct ieee80211_channel_config - channel config definition
> + *
> + * This structure describes channel configuration
> + *
> + * @chan_width1: channel bandwidth
> + * @center_freq1: center frequency of 1 st frequency segment
> + * @center_freq2: center frequency of 2 nd frequency segment

I'd add a note here that the 2nd is only used for 80+80

> + * @prim_chan_freq: primary channel frequency

You said you wanted to change it to be like the standard, that's not how
it works though, the standard says (copying from your email)

dot11CurrentPrimaryChannel
       Denotes the location of the primary 20 MHz channel.
       Valid range is 1 to 200.


> +static bool reg_sec_chans_permitted(struct wiphy *wiphy,
> +				    u32 center_freq,
> +				    u32 bw_khz)
> +{
> +	struct ieee80211_channel *chan;
> +	u32 left_end_freq, right_end_freq;
> +
> +	if (center_freq == 0 || bw_khz == 0)
> +		return false;
> +
> +	/* find left and right arms of center freq */
> +	left_end_freq = center_freq - (bw_khz/2);
> +	right_end_freq = center_freq + (bw_khz/2);
> +
> +	/* left_end_freq and right_end_freq are edge of left and right
> +	 * channels. Get center freq of left and right channels
> +	 * by subtracting 10 MHZ from each of them.
> +	 */
> +	left_end_freq -= MHZ_TO_KHZ(10);
> +	right_end_freq -= MHZ_TO_KHZ(10);

Hmm? Shouldn't you add 10 MHz to the lower end, if anything?

> +	/* find out all possible secondary channels */
> +	while (left_end_freq < right_end_freq) {
> +		chan = ieee80211_get_channel(wiphy, left_end_freq);
> +		if (chan == NULL ||
> +		    chan->flags & IEEE80211_CHAN_DISABLED) {
> +			return false;
> +		}
> +		left_end_freq -= MHZ_TO_KHZ(20);
> +	}
> +
> +	return true;
> +}

Overall I'm not sure I'd go to the channel structs for this function at
all though, I'd rather go to the regulatory definition, I think that
would make more sense.

OTOH, this may be needed to keep the ability for the driver to disable
certain channels etc.

> +bool reg_chan_use_permitted(struct wiphy *wiphy,
> +			    struct ieee80211_channel_config *chan_config,
> +			    const struct ieee80211_regdomain *regd)
> +{
> +	int r;
> +	u32 desired_bw_khz = MHZ_TO_KHZ(20);
> +	const struct ieee80211_reg_rule *reg_rule = NULL;
> +	const struct ieee80211_freq_range *freq_range = NULL;

Don't initialize to values you don't need.

> +	bool ret;
> +
> +	assert_reg_lock();
> +
> +	// get chan BW from config
> +	switch (chan_config->chan_width) {
> +	case IEEE80211_CHAN_WIDTH_20MHZ_NOHT:
> +	case IEEE80211_CHAN_WIDTH_20MHZ:
> ...

> +	case IEEE80211_CHAN_WIDTH_80P80MHZ:
> +		desired_bw_khz = MHZ_TO_KHZ(160);

This is not true at all.

> +		break;
> +	}

Missing a default case with a warning/error return?

> +	r = freq_reg_info_regd(wiphy,
> +			       chan_config->prim_chan_freq,
> +			       desired_bw_khz,
> +			       &reg_rule,
> +			       regd);
> +
> +	if (r) {
> +		REG_DBG_PRINT("Disabling freq %d MHz as custom "
> +			      "regd has no rule that fits a %d MHz "
> +			      "wide channel\n",
> +			      chan_config->prim_chan_freq,
> +			      KHZ_TO_MHZ(desired_bw_khz));

That's not a good message in this context now. Clearly it came from the
channel flag settings, but now we don't do that so ...

johannes

