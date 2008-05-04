Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51542
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbYEDBDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 21:03:00 -0400
Date: Sat, 03 May 2008 18:03:00 -0700 (PDT)
Message-Id: <20080503.180300.10562559.davem@davemloft.net> (sfid-20080504_030232_462272_82C67C49)
To: johannes@sipsolutions.net
Cc: herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209815533.3987.21.camel@johannes.berg>
References: <1209760731.3608.17.camel@johannes.berg>
	<20080502.163334.148944203.davem@davemloft.net>
	<1209815533.3987.21.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 03 May 2008 13:52:13 +0200

> 
> > We can't update skb->truesize during arbitray skb->data reallocations,
> > because it could corrupt the socket accounting.
> > 
> > On the other hand, if we provide ways for users to subvert the socket
> > buffer limits, we might as well not try to limit anything.
> 
> Why don't we update the socket allocation when doing pskb_expand_head()?
> Sure, it could become negative, but is that so bad?

The socket locked state at this time is variable and unknown.

The socket must be locked in order to modify these values.
And such locks cannot be taken, for example, from HW interrupt
context, amongst other restrictions.

> We need more space though. Should we then just increase the built-in
> headroom?

I simply don't know what to suggest at this point, that's why
we are having this discussion :-)
