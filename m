Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44837 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753763AbXLQVHg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 16:07:36 -0500
Subject: Re: [patch 1/9] mac80211: Clean up rate selection code
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1197892019.4885.16.camel@johannes.berg>
References: <20071217012517.882216322@gmx.de> >
	 <20071217012549.932807027@gmx.de> >
	 (sfid-20071217_012727_837272_3B5270C7)  <1197892019.4885.16.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 22:07:33 +0100
Message-Id: <1197925653.7505.13.camel@localhost> (sfid-20071217_210739_000582_761D4603)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-17 at 12:46 +0100, Johannes Berg wrote:
> Looks good, minor comment below.
> 
> > +void rate_control_get_rate(struct net_device *dev,
> > +			   struct ieee80211_hw_mode *mode, struct sk_buff *skb,
> > +			   struct rate_selection *sel)
> 
> > +	fc = le16_to_cpu(hdr->frame_control);
> > +	if ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA ||
> > +	    (hdr->addr1[0] & 0x01))
> 
> Please use is_multicast_ether_addr()

Sure, we had that before. Seems Stefano gave me an old patch. Sorry
about this.

> 
> > +	/* If a forced rate is in effect, select it. */
> > +	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> > +	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1)
> > +		sel->rate = &mode->rates[sdata->bss->force_unicast_rateidx];
> > +
> > +	/* If we haven't found the rate yet, ask the rate control algo. */
> > +	if (!sel->rate)
> > +		ref->ops->get_rate(ref->priv, dev, mode, skb, sel);
> 
> Maybe after this we should insert
> 
> 	if (unlikely(!sel->rate)) {
> 		WARN_ON(1);
> 		sel->rate = rate_lowest(...);
> 	}
> 
> Not sure though.

I don't think we need this. Rate control is supposed to select a rate,
if it doesn't know it can assign a fallback rate itself.

Mattas

