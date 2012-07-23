Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2GWNGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 09:06:16 -0400
Message-ID: <1343048772.4584.18.camel@jlt3.sipsolutions.net> (sfid-20120723_150620_361788_7C2B5F17)
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change
From: Johannes Berg <johannes@sipsolutions.net>
To: Mahesh Palivela <maheshp@posedge.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 23 Jul 2012 15:06:12 +0200
In-Reply-To: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +	IEEE80211_CHAN_NO_VHT80PLUS	= 1<<6,
> +	IEEE80211_CHAN_NO_VHT80MINUS	= 1<<7,
> +	IEEE80211_CHAN_NO_VHT160PLUS	= 1<<8,
> +	IEEE80211_CHAN_NO_VHT160MINUS	= 1<<9,

How are we going to handle 80+80?

Also, I believe there are many more possibilities, since we count from
the control channel -- ie. for HT HT40+ means secondary channel is above
the control channel. For VHT 80, you're going to have 4 possibilities:

|-1-|-2-|-3-|-4-|

the control channel can be any one of these four I believe? So you'd
have configurations like

VHT_CHAN_LAYOUT_0_3
VHT_CHAN_LAYOUT_1_2
VHT_CHAN_LAYOUT_2_1
VHT_CHAN_LAYOUT_3_0

indicating the number of channels below/above control (for control
channel 1,2,3,4 respectively). Similarly, for VHT160 you'd have 8
possibilities:

|-1-|-2-|-3-|-4-|-5-|-6-|-7-|-8-|

(which one could again capture as VHT_CHAN_LAYOUT_0_7 etc.)


> +static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
> +{
> +	if (!chan)
> +		return true;
> +	if (chan->flags & IEEE80211_CHAN_DISABLED)
> +		return true;
> +	/* This would happen when regulatory rules disallow VHT80 completely */
> +	if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
> +		return true;

Is that really right? Need to document what the return value of this
function should be, I guess?


> +static void reg_process_vht_flags_channel(struct wiphy *wiphy,
> +					 unsigned int chan_idx)
> +{
> +	struct ieee80211_supported_band *sband;
> +	struct ieee80211_channel *channel;
> +	struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
> +	unsigned int i;
> +
> +	assert_cfg80211_lock();
> +
> +	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +	BUG_ON(chan_idx >= sband->n_channels);
> +	channel = &sband->channels[chan_idx];
> +
> +	if (is_vht80_not_allowed(channel)) {
> +		channel->flags |= IEEE80211_CHAN_NO_VHT80;
> +		return;
> +	}
> +
> +	/*
> +	 * We need to ensure the extension channels exist to
> +	 * be able to use VHT80- or VHT80+, this finds them (or not)
> +	 */
> +	for (i = 0; i < sband->n_channels; i++) {
> +		struct ieee80211_channel *c = &sband->channels[i];
> +		if (c->center_freq == (channel->center_freq - 40))
> +			channel_before = c;
> +		if (c->center_freq == (channel->center_freq + 40))
> +			channel_after = c;
> +	}
> +
> +	/*
> +	 * Please note that this assumes target bandwidth is 40 MHz,
> +	 * if that ever changes we also need to change the below logic
> +	 * to include that as well.
> +	 */

???

johannes

