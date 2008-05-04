Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:42739 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751108AbYEDDRE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 23:17:04 -0400
Date: Sun, 4 May 2008 11:16:52 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: mac80211 truesize bugs
Message-ID: <20080504031652.GA30993@gondor.apana.org.au> (sfid-20080504_051655_947748_4395920F)
References: <1209760731.3608.17.camel@johannes.berg> <20080502.163334.148944203.davem@davemloft.net> <1209815533.3987.21.camel@johannes.berg> <20080503.180300.10562559.davem@davemloft.net> <1209865354.6210.23.camel@johannes.berg> <20080504020203.GA30514@gondor.apana.org.au> <1209866916.6210.39.camel@johannes.berg> <20080504021213.GA30660@gondor.apana.org.au> <1209867740.6210.46.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1209867740.6210.46.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 04, 2008 at 04:22:20AM +0200, Johannes Berg wrote:
>
> Yes, wireless always needs at least 24 bytes, but more likely 34
> (encryption+QoS). However, I just increased LL_MAX_HEADER to 54 and that
> doesn't seem to have helped.

How did you test it?

> What's wrong with, instead, doing skb_orphan() and then
> pskb_expand_head()? That seems to have the same effect.

If you packet sticks around for long enough then this skews the
accounting.  In any case, thinking too much about optimising this
part is a waste of time because we should be thinking about having
enough head room in the packet so that we don't have to expand
it in the first place except for the odd packet.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
