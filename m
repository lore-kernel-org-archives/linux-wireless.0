Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:19462 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZBXCaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:30:08 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2009 18:30:07 -0800
Date: Mon, 23 Feb 2009 18:29:23 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 3/5] cfg80211: Add AP beacon regulatory hints
Message-ID: <20090224022923.GK4264@tesla> (sfid-20090224_033012_237692_905323BC)
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com> <1235193641-17993-4-git-send-email-lrodriguez@atheros.com> <1235440730.4455.51.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1235440730.4455.51.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 23, 2009 at 05:58:50PM -0800, Johannes Berg wrote:
> On Sat, 2009-02-21 at 00:20 -0500, Luis R. Rodriguez wrote:
> 
> > +static bool freq_is_chan_12_13_14(u16 freq)
> > +{
> > +	if (freq == ieee80211_channel_to_frequency(12) ||
> > +	    freq == ieee80211_channel_to_frequency(13) ||
> > +	    freq == ieee80211_channel_to_frequency(14))
> > +		return true;
> > +	return false;
> > +}
> > +
> > +int regulatory_hint_found_beacon(struct wiphy *wiphy,
> > +				 struct ieee80211_channel *beacon_chan,
> > +				 gfp_t gfp)
> > +{
> > +	struct reg_beacon *reg_beacon;
> > +
> > +	if (likely((beacon_chan->beacon_found ||
> > +	    (beacon_chan->flags & IEEE80211_CHAN_RADAR) ||
> > +	    (beacon_chan->band == IEEE80211_BAND_2GHZ &&
> > +	     !freq_is_chan_12_13_14(beacon_chan->center_freq)))))
> > +		return 0;
> 
> This doesn't seem right, shouldn't it use the world regulatory domain to
> check against rather than hardcoding it?

I'm not sure I understand, can you elaborate on what you mean.

  Luis
