Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53473 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759356Ab0JFTpa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 15:45:30 -0400
Subject: RE: [PATCH v2 03/03] wl1271: 11n Support, functionality and
 configuration ability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Levi, Shahar" <shahar_levi@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE660011378562B@dnce02.ent.ti.com>
References: <1286388491-28752-1-git-send-email-shahar_levi@ti.com>
	 <1286388491-28752-5-git-send-email-shahar_levi@ti.com>
	 <1286389287.3655.398.camel@jlt3.sipsolutions.net>
	 <AC090B9732AB2B4DB7FF476E907FE660011378562B@dnce02.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 21:45:30 +0200
Message-ID: <1286394330.3655.429.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-06 at 21:38 +0200, Levi, Shahar wrote:

> > >  	/* peek into the rates configured in the STA entry */
> > >  	spin_lock_irqsave(&wl->wl_lock, flags);
> > > -	if (sta && sta->supp_rates[conf->channel->band] != wl->sta_rate_set) {
> > > +	if (sta &&
> > > +	    (sta->supp_rates[conf->channel->band] !=
> > > +	    (wl->sta_rate_set & HW_BG_RATES_MASK))) {
> > >  		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
> > >  		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
> > >  	}
> > 
> > ???
> > 
> > How can non-BG rates ever show up there? Is this really an 11a change?
> > 
> > johannes
> 
> 
> Thanks for the review.
> Non BG rates set in the next if:
> +	if (sta &&
> +	    sta->ht_cap.ht_supported &&
> +	    ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
> +	      sta->ht_cap.mcs.rx_mask[0])) {
> +		wl->sta_rate_set |=
> +		(sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
> +		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
> sta_rate_set bits are: bits0-15 BG, bits 16-23 MCS.
> Did you meant 11n change?

Never mind, I misread the patch.

johannes

