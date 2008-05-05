Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45756
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752928AbYEEXjR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 19:39:17 -0400
Date: Mon, 05 May 2008 16:39:16 -0700 (PDT)
Message-Id: <20080505.163916.239187195.davem@davemloft.net> (sfid-20080506_013832_875309_5BDF7775)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, herbert@gondor.apana.org.au
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210029835.8012.30.camel@johannes.berg>
References: <1210027447.8012.15.camel@johannes.berg>
	<20080505.161458.46071527.davem@davemloft.net>
	<1210029835.8012.30.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 06 May 2008 01:23:55 +0200

[ Herbert CC:'d ]

> On Mon, 2008-05-05 at 16:14 -0700, David Miller wrote:
> 
> > If it is cloned, it makes sure the data reference count allows
> > for modification of the buffer.
> 
> Which buffer? skb->data..skb->tail? And isn't that, in mac80211's case,
> at least currently all the buffer anyway?

Right.

For TSO or cases using frag lists of frag page vectors, it gets
more complicated.

Basically, skb_header_cloned()==false means that you can modify
anything covered by skb->data..skb->tail

> Interesting point. I'll have to see when socket filters are run,
> wpa_supplicant could have a tap open I think. Maybe that's why I'm
> seeing so many cloned packets. I think I'll stacktrace skb_clone and
> print that out.

Note that we can even optimize that case even further if we really
have to.

But try to see why the filter used by WPA Supplicant is not effective.
If the filter fails to match, the packet is free'd immediately using
kfree_skb() which should undo clone'age.

Actually, I think I see a potential problem with how the
->dataref bit fields are managed in this situation.  This is
Herbert's creation, so let's ask him :-)

It seems that if we have a TCP packet for which skb_header_cloned()
is false, and this enters dev_hard_start_xmit(), if any network
taps take the packet, we'll never return to skb_header_cloned()==false
state even if every tap immediately kfree_skb(skb)'s the packet.

When we clone, we'll increment only the low 16-bit part of ->dataref.

On free, since skb->nohdr is set, we'll decrement both of (1 <<
SKB_DATAREF_SHIFT) and the low 16-bit counter.

Therefore the packet never becomes re-writable, right?  Is there some
easy way to cure this Herbert?  Apparently having a tap registered
constantly merely to watch for filtered traffic is quite common. :-/

