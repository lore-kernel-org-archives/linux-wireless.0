Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44849 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063AbYLKSQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 13:16:32 -0500
Date: Thu, 11 Dec 2008 20:15:45 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <hrogge@googlemail.com>
Subject: Re: [RFC] mac80211: Add HT rates into RX status reporting
Message-ID: <20081211181545.GB32500@jm.kir.nu> (sfid-20081211_191635_822636_254278D2)
References: <20081211161741.GA27460@jm.kir.nu> <1229015789.8081.40.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229015789.8081.40.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 11, 2008 at 06:16:29PM +0100, Johannes Berg wrote:
> On Thu, 2008-12-11 at 18:17 +0200, Jouni Malinen wrote:
> 
> > Radiotap code gets some of the additional knowledge so that it can
> > determine the used bitrate for HT rates, too (though, the rate field
> > is not large enough to fit all rates). It would be useful to add MCS
> > index, HT20/HT40, and short GI information into radiotap definition at
> > some point, too, and the needed information for filling in those field
> > is now available in mac80211.
> 
> Can we leave the rate calculation out here? I don't think we should do
> that much in this case, and we can extend radiotap later to include HT
> information.

Maybe.. After being pointed to FreeBSD version of ieee80211_radiotap.h,
I think there is a nice solution for this..

> > The ath9k change fixes and cleans up the RX status reporting by
> > getting rid of code that used internal rate tables

> Yay. This is the last step for generic HT rate control with ath9k, I
> think.

Haven't checked whether it is the last part, but it certainly cleaned up
that from recv.c.

> > + * @RX_FLAG_HT20: HT20 MCS was used and rate_idx is MCS index
> > + * @RX_FLAG_HT40: HT40 MCS was used and rate_idx is MCS index
> > + * @RX_FLAG_SHORT_GI: Short guard interval was used
> 
> I think we should do RX_FLAG_HT and RX_FLAG_40MHZ so that 

> > + *	HT rates are use (RX_FLAG_HT20 or RX_FLAG_HT40)
> 
> this becomes just checking for RATE_FLAG_HT instead of both, what do you
> think?

OK, that looks better.

> > --- wireless-testing.orig/net/mac80211/mlme.c	2008-12-11 16:48:40.000000000 +0200
> > @@ -1629,8 +1629,13 @@ static void ieee80211_rx_bss_info(struct
> >  			 * e.g: at 1 MBit that means mactime is 192 usec earlier
> >  			 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.

> > +			if (rx_status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> > +				rate = 65; /* TODO: HT rates */
> >  			rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);

> Ick, ok, I give up, I guess we do need a function to calculate the raw
> bitrate after all. Let's put that into cfg80211 though, and then just
> call it here. Henning's function is nice, although it might be too
> expensive due to divisions...

Yeah.. For now, I'm more than fine with having a hardcoded value for HT
rates here since this is for IBSS.. Once we have a suitable function for
converting into bitrate, this can be fixed.


> > @@ -149,7 +149,41 @@ ieee80211_add_rx_radiotap_header(struct 
> > +			if (status->flag & RX_FLAG_HT40)
> > +				rate = mcs2rate_ht40[mcs_idx];
> > +			else
> > +				rate = mcs2rate[mcs_idx];
..

> Can we just leave off the bitrate for HT for now?

Yes. FreeBSD radiotap definition uses 0x80 as a flag in the rate field
for indicating that it is an MCS index, not bitrate. That works fine
here, too, and I'll update my patch to use the same style. No more
bitrate calculation for HT rates in mac80211 after that..

> > @@ -1863,10 +1897,16 @@ static int prepare_for_handlers(struct i
> > +			if (rx->status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40))
> > +				rate_idx = 0; /* TODO: HT rates */
> > +			else
> > +				rate_idx = rx->status->rate_idx;
> >  			rx->sta = ieee80211_ibss_add_sta(sdata, rx->skb,
> >  						bssid, hdr->addr2,
> > -						BIT(rx->status->rate_idx));
> > +						BIT(rate_idx));

> Ok, that's icky, but you can at least use rate_idx = <mandatory rates>
> if you actually receive an HT frame for an IBSS peer, no? Of course,
> that is expensive to calculate, we might want to precalculate it...

I did not want to think about anything for IBSS.. ;-)  One should just
probe the other STA if you want to learn what it can do..

> > @@ -2072,7 +2112,14 @@ static u8 ieee80211_sta_manage_reorder_b
> >  				__ieee80211_rx_handle_packet(hw,
> >  					tid_agg_rx->reorder_buf[index],
> >  					&status, rate);
> 
> I think we need to change the internal rate representation... Or review
> it and see if we can allow NULL values. I.e. in struct ieee80211_rx_data
> we need to do MCS stuff too instead of using the first rate here.

Agreed.

> > +	if (status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
> > +		/* HT rates are not in the table - use the highest legacy rate
> > +		 * for now since other parts of mac80211 may not yet be fully
> > +		 * MCS aware. */
> > +		rate = &sband->bitrates[sband->n_bitrates - 1];
> 
> That's inconsistent, you're using the highest here but the lowest after
> the reorder buffer, no?

I did not think about this the TODO entries much.. Just left something
in there. This one was the highest one by default (the first one I did),
the others ended up being something easy since I did not bother trying
to figure out how many rates were available ;-)

> 
> > +	} else {
> > +		if (status->rate_idx < 0 ||
> > +		    status->rate_idx >= sband->n_bitrates) {
> > +			WARN_ON(1);
> > +			return;
> > +		}
> 
> Could change to if(WARN_ON(...)) return :)

Sure. I just moved old code around, but I can clean that up at the same
time.

-- 
Jouni Malinen                                            PGP id EFC895FA
