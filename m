Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:50512 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753594AbbFBJPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 05:15:48 -0400
Date: Tue, 2 Jun 2015 12:15:43 +0300
From: Jouni Malinen <j@w1.fi>
To: Stephan Mueller <smueller@chronox.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 7/7] mac80211: Switch to new AEAD interface
Message-ID: <20150602091543.GA3140@w1.fi> (sfid-20150602_111552_807528_7A2165DB)
References: <20150521103938.GA23035@gondor.apana.org.au>
 <1433167519.3505.11.camel@sipsolutions.net>
 <1433169326.3505.12.camel@sipsolutions.net>
 <2613062.1qx4rgqk9F@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2613062.1qx4rgqk9F@tauon>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 01, 2015 at 05:36:58PM +0200, Stephan Mueller wrote:
> Am Montag, 1. Juni 2015, 16:35:26 schrieb Johannes Berg:
> >IOW, I think something like this would make sense:
> 
> That looks definitely cleaner :-)

Indeed.. That AAD length-in-the-buffer design came from the over ten
year old code that was optimized to cover the CCM construction with the
same buffer and that was not cleaned up when this was converted to use
cryptoapi couple of years ago.

> Though, my main concern was just to ensure that the aad length value is not 
> zero.

It won't be in IEEE 802.11 use cases. The exact length depends on the
IEEE 802.11 frame type, but AAD is constructed in a way that it is
normally a bit over 20 octets while allowing CCM to fit the related
operations into two AES blocks.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
