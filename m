Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36354
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S932521AbYEBXde (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 19:33:34 -0400
Date: Fri, 02 May 2008 16:33:34 -0700 (PDT)
Message-Id: <20080502.163334.148944203.davem@davemloft.net> (sfid-20080503_013312_280160_9C7AC784)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209760731.3608.17.camel@johannes.berg>
References: <1209639500.7067.0.camel@johannes.berg>
	<20080501110341.GD7490@gondor.apana.org.au>
	<1209760731.3608.17.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Fri, 02 May 2008 22:38:51 +0200

> I'm confused. The area should be used say with encryption when it's
> actually necessary. Maybe there's always enough headroom for some
> reason now?

That's possible.

There are paths, that, although they could take advantage of the
fact that all of the non-header packet data is going to come from
pages, they don't and allocate a full MTU skb->data area anyways.

> On another note, why is this truesize mismatch a bug anyway? I mean, the
> field could just be called "socket_charged_size" and simply be required
> to have the same value throughout the skb lifetime, the slight mismatch
> between charged bytes and actually used bytes wouldn't usually matter
> too much, would it?

Sure the name could change, but the problem wouldn't.

We can't update skb->truesize during arbitray skb->data reallocations,
because it could corrupt the socket accounting.

On the other hand, if we provide ways for users to subvert the socket
buffer limits, we might as well not try to limit anything.

Take a look at some ethernet drivers that implement TSO in a way that
requires munging the IP headers for whatever reason.  If they need to
COW the packet data in order to modify it, they always do this with
pskb_expand_head(skb, 0, 0, GFP_*) exactly so that they don't modify
the SKB data size, and exactly so that the skb->truesize value stays
accurate.

Try to find out exactly what's going wrong here, you seem to be
close.  Once we know the precise issue we can talk about real
changes to make this easier to cope with and debug in the future.
