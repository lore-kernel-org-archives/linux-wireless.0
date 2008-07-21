Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:49347 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759430AbYGUCeD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2008 22:34:03 -0400
Received: by py-out-1112.google.com with SMTP id p76so911280pyb.10
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2008 19:34:01 -0700 (PDT)
Subject: Re: [PATCH 20/31]: pkt_sched: Perform bulk of qdisc destruction
	in	RCU.
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kaber@trash.net, davem@davemloft.net, netdev@vger.kernel.org,
	johannes@sipsolutions.net, linux-wireless@vger.kernel.org
In-Reply-To: <20080721001119.GA6515@gondor.apana.org.au>
References: <E1KKZmE-0000ty-00@gondolin.me.apana.org.au>
	 <1216568119.4847.101.camel@localhost>
	 <20080721001119.GA6515@gondor.apana.org.au>
Content-Type: text/plain
Date: Sun, 20 Jul 2008 22:33:57 -0400
Message-Id: <1216607637.4847.172.camel@localhost> (sfid-20080721_043411_008194_5F14D587)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-21-07 at 08:11 +0800, Herbert Xu wrote:

> This is exactly what I want to get rid of because otherwise even
> if no index was specified we'll still do a hash insertion which
> simply falls apart with a small hash table.  Using a large hash
> table on the other is bad for people who only have a few rules.

True. 
But note: this is only during rule creation - once you create the
rule (user space to kernel path), then no more hash table reference.
Fast path has already a filter with actions attached, and is a mere
pointer dereference.

> We could do a dynamic table but so far I'm not convinced that
> it's worth anybody's effort to implement :)

If user<->kernel performance insertion/deletion is important, it is
worth it.
For example:
Dave implemented dynamic hash tables on xfrm (voip setup time with ipsec
is a metric used in the industry in that case) . The only operational
problem i had with xfrm was lack of an upper bound of how large a table
can grow; i would rather user space be told ENOMEM than continuing to
grow in some cases (I actually implemented a patch which put a stop
after a certain number of sad/spd - but i dont expect hugs if i was to
post it;->).

cheers,
jamal

