Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-6.exch022.serverdata.net ([206.225.164.189]:31931
	"EHLO HUB022-nj-6.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754552Ab2GXGqP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 02:46:15 -0400
From: Mahesh Palivela <maheshp@posedge.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] cfg80211: 80MHz (11ac) regulatory change
Date: Tue, 24 Jul 2012 06:46:14 +0000
Message-ID: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC704B@mbx022-e1-nj-10.exch022.domain.local> (sfid-20120724_084619_570707_42EB2142)
References: <952C5D5D0470AE4FB7D8A75C6ADC71CA0FCC5E3B@mbx022-e1-nj-10.exch022.domain.local>,<1343048772.4584.18.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343048772.4584.18.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

________________________________________
From: Johannes Berg [johannes@sipsolutions.net]
Sent: Monday, July 23, 2012 6:36 PM
To: Mahesh Palivela
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: 80MHz (11ac) regulatory change

> +     IEEE80211_CHAN_NO_VHT80PLUS     = 1<<6,
> +     IEEE80211_CHAN_NO_VHT80MINUS    = 1<<7,
> +     IEEE80211_CHAN_NO_VHT160PLUS    = 1<<8,
> +     IEEE80211_CHAN_NO_VHT160MINUS   = 1<<9,

How are we going to handle 80+80?

[MP] This is a future item. Get to this at a later time.

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

[MP] I see your point. But according to 11ac spec, AP will use primary chan as specified in HT operation IE chan num. Secondary channel is center freq specified in VHT Operation IE. So I am thinking secondary channel is not relative offset to primary channel. Hope I am not mistaken here.

> +static bool is_vht80_not_allowed(struct ieee80211_channel *chan)
> +{
> +     if (!chan)
> +             return true;
> +     if (chan->flags & IEEE80211_CHAN_DISABLED)
> +             return true;
> +     /* This would happen when regulatory rules disallow VHT80 completely */
> +     if (IEEE80211_CHAN_NO_VHT80 == (chan->flags & (IEEE80211_CHAN_NO_VHT80)))
> +             return true;

Is that really right? Need to document what the return value of this
function should be, I guess?

[MP] I guess, it's possible for a channel not allowed for 80Mhz operation.

> +static void reg_process_vht_flags_channel(struct wiphy *wiphy,
> +                                      unsigned int chan_idx)
> +{
> +     struct ieee80211_supported_band *sband;
> +     struct ieee80211_channel *channel;
> +     struct ieee80211_channel *channel_before = NULL, *channel_after = NULL;
> +     unsigned int i;
> +
> +     assert_cfg80211_lock();
> +
> +     sband = wiphy->bands[IEEE80211_BAND_5GHZ];
> +     BUG_ON(chan_idx >= sband->n_channels);
> +     channel = &sband->channels[chan_idx];
> +
> +     if (is_vht80_not_allowed(channel)) {
> +             channel->flags |= IEEE80211_CHAN_NO_VHT80;
> +             return;
> +     }
> +
> +     /*
> +      * We need to ensure the extension channels exist to
> +      * be able to use VHT80- or VHT80+, this finds them (or not)
> +      */
> +     for (i = 0; i < sband->n_channels; i++) {
> +             struct ieee80211_channel *c = &sband->channels[i];
> +             if (c->center_freq == (channel->center_freq - 40))
> +                     channel_before = c;
> +             if (c->center_freq == (channel->center_freq + 40))
> +                     channel_after = c;
> +     }
> +
> +     /*
> +      * Please note that this assumes target bandwidth is 40 MHz,
> +      * if that ever changes we also need to change the below logic
> +      * to include that as well.
> +      */

???

[MP] Can you explain? This function doesn't make any sense?

johannes

