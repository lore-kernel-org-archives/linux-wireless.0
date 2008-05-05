Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38477
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751431AbYEEXYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:24:24 -0400
Date: Mon, 05 May 2008 16:24:24 -0700 (PDT)
Message-Id: <20080505.162424.176435653.davem@davemloft.net> (sfid-20080506_012341_792174_B31C30AD)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210029435.8012.25.camel@johannes.berg>
References: <1210000923.8245.26.camel@johannes.berg>
	<20080505.160328.203996832.davem@davemloft.net>
	<1210029435.8012.25.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 May 2008 01:17:14 +0200

> Also, should there be some sort of timer that resets the rx_alloc_extra
> again so that when you bridge it once with p54 (needs heaps of headroom)
> you don't suffer forever?

We're talking about, what, up to 128 bytes or something like that?
If you're bridging over your wireless device you've already invested
in assuming those kinds of costs.

I don't think this aspect is really worth worrying about.  The current
behavior is so much incredibly worse. :-)

> > @@ -255,11 +255,12 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> >  		unsigned int length, gfp_t gfp_mask)
> >  {
> >  	int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > +	unsigned int extra = dev->rx_alloc_extra + NET_SKB_PAD;
> >  	struct sk_buff *skb;
> >  
> > -	skb = __alloc_skb(length + NET_SKB_PAD, gfp_mask, 0, node);
> > +	skb = __alloc_skb(length + extra, gfp_mask, 0, node);
> >  	if (likely(skb)) {
> > -		skb_reserve(skb, NET_SKB_PAD);
> > +		skb_reserve(skb, extra);
> 
> Doesn't that break alignment though?

Good catch, we'll have to align the rx_alloc_extra to some modulus or
similar.  Ideally, at the spot where rx_alloc_extra is set instead
of here.

