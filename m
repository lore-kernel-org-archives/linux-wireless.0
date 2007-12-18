Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42398 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750700AbXLRTMi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 14:12:38 -0500
Subject: Re: [patch 1/9] mac80211: Clean up rate selection code
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197983844.4885.128.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012549.932807027@gmx.de> >
	 (sfid-20071217_012727_837272_3B5270C7)  <1197892019.4885.16.camel@johannes.berg>
	 <1197925653.7505.13.camel@localhost>
	 (sfid-20071217_210805_440164_CFCDBD2D)  <1197983844.4885.128.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 20:12:34 +0100
Message-Id: <1198005154.7553.5.camel@localhost> (sfid-20071218_191242_521073_A23C8F55)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Tue, 2007-12-18 at 14:17 +0100, Johannes Berg wrote:
> > > > +	/* If a forced rate is in effect, select it. */
> > > > +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > > > +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> > > > +		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
> > > > +
> > > > +	/* If we haven't found the rate yet, ask the rate control algo. */
> > > > +	if (!sel->rate)
> > > > +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
> > > 
> > > Maybe after this we should insert
> > > 
> > > 	if (unlikely(!sel->rate)) {
> > > 		WARN_ON(1);
> > > 		sel->rate = rate_lowest(...);
> > > 	}
> > > 
> > > Not sure though.
> > 
> > I don't think we need this. Rate control is supposed to select a rate,
> > if it doesn't know it can assign a fallback rate itself.
> 
> Obviously. I just thought we could protect against buggy rate control
> algorithm code that way. Not really necessary though.

If it's buggy, it should be fixed. So it's actually better to fail
dramatically ;-)

Mattias

