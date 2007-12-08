Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60949 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752924AbXLHLgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:36:13 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197113615.7472.56.camel@localhost>
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost>
	 (sfid-20071208_112222_400278_02DE29F9)  <1197113375.4171.50.camel@johannes.berg>
	 <1197113615.7472.56.camel@localhost>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:36:10 +0100
Message-Id: <1197113770.7472.59.camel@localhost> (sfid-20071208_113616_056249_E470BECB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-12-08 at 12:33 +0100, Mattias Nissler wrote:
> > 
> > > +	/* If we haven't found the rate yet, ask the rate control algo. */
> > > +	if (!sel->rate)
> > > +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
> > 
> > > +	/* Select a non-ERP backup rate. */
> > > +	if (!sel->nonerp) {
> > > +		for (i = 0; i < mode->num_rates - 1; i++) {
> > > +			struct ieee80211_rate *rate = &mode->rates[i];
> > > +			if (sel->rate->rate < rate->rate)
> > > +				break;
> > > +
> > > +			if (rate_supported(sta, mode, i) &&
> > > +			    !(rate->flags & IEEE80211_RATE_ERP))
> > > +				sel->nonerp = rate;
> > > +		}
> > > +	}
> > 
> > That I'm not sure about. This is the fallback rate?
> 
> Yes. It's after the get_rate() call so the algorithm can override it.
> But if it doesn't we compute it ourselves.

To be a little more specific, it's the non-extended-rate-set rate. So
the code falls back to this one e.g. if it's an AP has 80211.g but
stations that are only 80211.b

Mattias

