Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34788 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab2DBKlc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2012 06:41:32 -0400
Message-ID: <1333363291.3498.4.camel@jlt3.sipsolutions.net> (sfid-20120402_124135_079554_3535DCCB)
Subject: Re: [[PATCH v2 3/4] mac80211: Modify sta_get_rates to give basic
 rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	thomas@cozybit.com, devel@lists.open80211s.org,
	linville@tuxdriver.com
Date: Mon, 02 Apr 2012 12:41:31 +0200
In-Reply-To: <1333363066.3498.2.camel@jlt3.sipsolutions.net> (sfid-20120402_123754_346504_661AD23D)
References: <1333225930-320-1-git-send-email-ashok@cozybit.com>
	 <1333225930-320-3-git-send-email-ashok@cozybit.com>
	 (sfid-20120331_223256_081687_5E78117C) <1333363066.3498.2.camel@jlt3.sipsolutions.net>
	 (sfid-20120402_123754_346504_661AD23D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-02 at 12:37 +0200, Johannes Berg wrote:
> On Sat, 2012-03-31 at 13:32 -0700, Ashok Nagarajan wrote:
> 
> > @@ -1127,15 +1127,25 @@ u32 ieee80211_sta_get_rates(struct ieee80211_local *local,
> >  		     elems->ext_supp_rates_len; i++) {
> >  		u8 rate = 0;
> >  		int own_rate;
> > +		bool is_basic;
> >  		if (i < elems->supp_rates_len)
> >  			rate = elems->supp_rates[i];
> >  		else if (elems->ext_supp_rates)
> >  			rate = elems->ext_supp_rates
> >  				[i - elems->supp_rates_len];
> >  		own_rate = 5 * (rate & 0x7f);
> > -		for (j = 0; j < num_rates; j++)
> > -			if (bitrates[j].bitrate == own_rate)
> > +		is_basic = !!(rate & 0x80);
> > +
> > +		if (is_basic && (rate & 0x7f) == BSS_MEMBERSHIP_SELECTOR_HT_PHY)
> > +			continue;
> > +
> > +		for (j = 0; j < num_rates; j++) {
> > +			if (bitrates[j].bitrate == own_rate) {
> >  				supp_rates |= BIT(j);
> > +				if (basic_rates && is_basic)
> > +					*basic_rates |= BIT(j);
> > +			}
> > +		}
> 
> Seems it'd be worth skipping the entire logic if basic_rates is NULL?

Oh, never mind, got confused.

johannes

