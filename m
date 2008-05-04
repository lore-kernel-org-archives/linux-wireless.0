Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40719 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753467AbYEDCCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 22:02:15 -0400
Date: Sun, 4 May 2008 10:02:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080504020203.GA30514@gondor.apana.org.au> (sfid-20080504_040145_287236_42F84A30)
References: <1209760731.3608.17.camel@johannes.berg> <20080502.163334.148944203.davem@davemloft.net> <1209815533.3987.21.camel@johannes.berg> <20080503.180300.10562559.davem@davemloft.net> <1209865354.6210.23.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209865354.6210.23.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 04, 2008 at 03:42:34AM +0200, Johannes Berg wrote:
>
> I'm still not sure about the dependencies between LL_MAX_HEADER,
> dev->hard_header_len and similar. Why, for example, does ipip set it to
> LL_MAX_HEADER + sizeof(struct iphdr)? Because it doesn't know better
> since the packets it creates could be routed anywhere?

The difference between LL_MAX_HEADER and hard_header_len is that
the former is a system-wide hint of how big the header can be
and the latter is a device-specific value.

In other words, we use the former when we don't know where we
create a packet since we don't know where it'll end up.  As such
we allocate a generous amount of header space so that hopefully
nobody will have to expand the header later.  However, it would
be OK for someone to expand it but obviously it this happened
for the majority of your traffic then you've done something wrong
since expanding it wastes CPU resources by copying the data.

The value of hard_header_len on the other hand is used for two
purposes at least.  First of all it is a hint of how much free
header space there should be in a packet before it goes into a
device (but don't rely on it).  More importantly it's the length
of the hardware header in the packet.  The definition of the
hardware header varies with each type of device.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
