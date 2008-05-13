Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59698
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751285AbYEMWJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 18:09:31 -0400
Date: Tue, 13 May 2008 15:09:26 -0700 (PDT)
Message-Id: <20080513.150926.114765212.davem@davemloft.net> (sfid-20080514_000937_286997_34D91E50)
To: johannes@sipsolutions.net
Cc: tomasw@gmail.com, linville@tuxdriver.com,
	herbert@gondor.apana.org.au, mb@bu3sch.de, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210714643.4279.27.camel@johannes.berg>
References: <1210712356.4279.22.camel@johannes.berg>
	<1ba2fa240805131412i3bd1756bhb11d31742b326b2f@mail.gmail.com>
	<1210714643.4279.27.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 13 May 2008 23:37:23 +0200

> 
> > >  Most fullmac devices also need some space, whether they do things that
> > >  way or not is a completely different thing, the ieee80211 stack for
> > >  example copies every packet into a new skb anyway.
> > 
> > It's really depends on when is the 802.3 to 802.11 header translation
> > made it doesn't matter whether it's fullmac or softmac. I would say
> > that WLAN is OK.
> 
> True, some devices take 802.3 frames and do the translation and
> everything themselves. I dunno. I guess it would make sense to make it
> mac80211 anyway because ieee80211 doesn't care and the other drivers are
> probably handling this in some other way anyway (if maybe even by using
> different dma descriptors, or just not caring because transfer speeds
> are low enough)

We should fix ieee80211 (it's something I planned to look into today
in fact), and the drivers that copy or do things incorrectly.

It doesn't make sense to make this decision based upon which 80211
stack or which drivers are enabled.  All of them in essence want this
extra space, so let's give it to them.
