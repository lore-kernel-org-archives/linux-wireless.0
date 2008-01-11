Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1173 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758542AbYAKXBK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jan 2008 18:01:10 -0500
Date: Sat, 12 Jan 2008 10:01:05 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: handing cloned frames to netif_rx()?
Message-ID: <20080111230105.GA32656@gondor.apana.org.au> (sfid-20080111_230116_150714_1DF3C21F)
References: <E1JDSPG-0008Of-00@gondolin.me.apana.org.au> <1200092285.3528.5.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1200092285.3528.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 11, 2008 at 11:58:05PM +0100, Johannes Berg wrote:
>
> Ok. Yes, we will of course adhere to that, but I was wondering whether
> maybe the net stack assumes somewhere that a packet it got from the
> driver can be written to w/o copying.

All parts of the rx stack support clone handling because they can always
run after another handler (e.g., AF_PACKET) which may have cloned the
packet.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
