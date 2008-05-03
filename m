Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36077
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbYECXcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 19:32:02 -0400
Date: Sat, 03 May 2008 16:32:02 -0700 (PDT)
Message-Id: <20080503.163202.48704621.davem@davemloft.net> (sfid-20080504_013138_181838_BDA62F7B)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209857088.3920.4.camel@johannes.berg>
References: <20080501.034950.261408566.davem@davemloft.net>
	<1209641914.3904.0.camel@johannes.berg>
	<1209857088.3920.4.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sun, 04 May 2008 01:24:48 +0200

> 
> > > @@ -699,6 +699,12 @@ int pskb_expand_head(struct sk_buff *skb, int nhead, int ntail,
> > >  	if (skb_shared(skb))
> > >  		BUG();
> > >  
> > > +	if (unlikely((nhead || ntail) && skb->sk)) {
> > > +		printk(KERN_ERR "SKB BUG: Illegal pskb expand (%d:%d) "
> > > +		       "with socket attached\n",
> > > +		       nhead, ntail);
> > > +	}
> > > +
> > >  	size = SKB_DATA_ALIGN(size);
> > 
> > Ok I think I'm starting to understand this a little better. However,
> > shouldn't this function update skb->truesize so if the skb is later
> > attached to a different socket again it has the right size?
> 
> Judging from some of the callers, the caller should. Why?!

Relax :-)

We certainly could check that there is no socket attached here,
and make the truesize adjustment right at this spot.

It just never happened before in practice in a way that matters.

That's why we have the truesize assertion, to discover situations
like this and thus be able to fix it.
