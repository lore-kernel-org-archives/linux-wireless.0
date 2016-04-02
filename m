Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57722 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbcDBBrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 21:47:06 -0400
Date: Sat, 2 Apr 2016 09:46:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	David Miller <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, tgraf@suug.ch
Subject: Re: Question on rhashtable in worst-case scenario.
Message-ID: <20160402014653.GA19235@gondor.apana.org.au> (sfid-20160402_034725_837296_50D30CFC)
References: <56F9941A.3080501@candelatech.com>
 <56FAAA6D.3070806@candelatech.com>
 <1459329252.2055.1.camel@sipsolutions.net>
 <20160330.123821.328761526754742195.davem@davemloft.net>
 <56FC0445.6010200@candelatech.com>
 <1459410405.4576.8.camel@sipsolutions.net>
 <20160331075015.GA27716@gondor.apana.org.au>
 <1459438199.4576.26.camel@sipsolutions.net>
 <20160401004627.GA9367@gondor.apana.org.au>
 <1459546450.3342.22.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459546450.3342.22.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 01, 2016 at 11:34:10PM +0200, Johannes Berg wrote:
>
> I was thinking about that one - it's not obvious to me from the code
> how this "explicitly checking for dups" would be done or let's say how
> rhashtable differentiates. But since it seems to work for Ben until
> hitting a certain number of identical keys, surely that's just me not
> understanding the code rather than anything else :)

It's really simple, rhashtable_insert_fast does not check for dups
while rhashtable_lookup_insert_* do.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
