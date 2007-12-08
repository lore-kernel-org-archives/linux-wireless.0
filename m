Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:53906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751652AbXLHLdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:33:38 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197113375.4171.50.camel@johannes.berg>
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost>
	 (sfid-20071208_112222_400278_02DE29F9)  <1197113375.4171.50.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 08 Dec 2007 12:33:35 +0100
Message-Id: <1197113615.7472.56.camel@localhost> (sfid-20071208_113342_706705_D04BD8B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sat, 2007-12-08 at 12:29 +0100, Johannes Berg wrote:
> > +	/* Send management frames and broadcast/multicast data using lowest
> > +	 * rate. */
> > +	fc = le16_to_cpu(hdr->frame_control);
> > +	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
> > +	    (hdr->addr1[0] & 0x01))
> > +		sel->rate = rate_lowest(local, mode, sta);
> 
> I'm not sure but I don't think we want this. And you should use
> is_multicast_addr() or whatever it's called.

This piece comes directly from the old "simple" algo. You're right about
is_multicast_addr. I agree this is something we might to get rid of, but
I leave that decision to you.

> 
> > +	/* If a forced rate is in effect, select it. */
> > +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> > +		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
> 
> That's good.
> 
> > +	/* If we haven't found the rate yet, ask the rate control algo. */
> > +	if (!sel->rate)
> > +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
> 
> > +	/* Select a non-ERP backup rate. */
> > +	if (!sel->nonerp) {
> > +		for (i = 0; i < mode->num_rates - 1; i++) {
> > +			struct ieee80211_rate *rate = &mode->rates[i];
> > +			if (sel->rate->rate < rate->rate)
> > +				break;
> > +
> > +			if (rate_supported(sta, mode, i) &&
> > +			    !(rate->flags & IEEE80211_RATE_ERP))
> > +				sel->nonerp = rate;
> > +		}
> > +	}
> 
> That I'm not sure about. This is the fallback rate?

Yes. It's after the get_rate() call so the algorithm can override it.
But if it doesn't we compute it ourselves.

Mattias

