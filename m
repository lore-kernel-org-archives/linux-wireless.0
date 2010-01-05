Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48643 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754377Ab0AER7J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 12:59:09 -0500
Date: Tue, 5 Jan 2010 19:58:49 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/3] cfg80211/mac80211: Use more generic bitrate mask
 for rate control
Message-ID: <20100105175849.GB12811@jm.kir.nu>
References: <20091229105932.GC18493@jm.kir.nu>
 <1262684199.20098.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1262684199.20098.19.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 05, 2010 at 10:36:39AM +0100, Johannes Berg wrote:
> On Tue, 2009-12-29 at 12:59 +0200, Jouni Malinen wrote:
> >  	/*
> > -	 * try to enforce the maximum rate the user wanted
> > +	 * try to enforce the rateidx mask the user wanted
> >  	 */
> > -	if (sdata->max_ratectrl_rateidx > -1)
> > +	mask = sdata->rc_rateidx_mask[info->band];
> > +	if (mask != (1 << txrc->sband->n_bitrates) - 1) {
> > +		if (sta)
> > +			mask &= sta->sta.supp_rates[info->band];
> >  		for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
> >  			if (info->control.rates[i].flags & IEEE80211_TX_RC_MCS)
> >  				continue;
> > -			info->control.rates[i].idx =
> > -				min_t(s8, info->control.rates[i].idx,
> > -				      sdata->max_ratectrl_rateidx);
> > +			for (j = info->control.rates[i].idx;
> > +			     j < txrc->sband->n_bitrates; j++) {
> > +				if (mask & (1 << j)) {
> > +					info->control.rates[i].idx = j;
> > +					break;
> > +				}
> > +			}
> 
> This could benefit from some comments :) I'm having trouble to see that
> it's correct, but the min_t probably makes it correct?

min_t? The one that was removed? ;-) In theory, this was supposed to be
trivial replacement of max-idx with idx-mask. However, the current
version is only able to increase the rate which was the direction I
really needed to get working. It could be worth considering another loop
after this to decrease the rate if no match was found before..


> > -	txrc.max_rate_idx = tx->sdata->max_ratectrl_rateidx;
> > +	txrc.rate_idx_mask = tx->sdata->rc_rateidx_mask[tx->channel->band];
> > +	if (txrc.rate_idx_mask == (1 << sband->n_bitrates) - 1)
> > +		txrc.max_rate_idx = -1;
> > +	else
> > +		txrc.max_rate_idx = fls(txrc.rate_idx_mask) - 1;
> 
> I wonder if we should maintain the rate_idx_mask separately, so it's
> outside the hotpath, or will we be removing all remaining uses of it
> very soon?

I would assume you are talking about max_rate_idx and yes, I would hope
that we can get rid of it soon. I actually already removed it in the
first iteration of the patch, but had to bring it back after noticing
that iwl-{agn,3945}-rs.c were using it and I did not want to change
the drivers with the same patch. I would expect it to be relatively
simple change to the drivers to handle the rate mask as well as they can
(which may mean just figure out the max idx and use it if the firmware
does not allow rate mask configuration).

-- 
Jouni Malinen                                            PGP id EFC895FA
