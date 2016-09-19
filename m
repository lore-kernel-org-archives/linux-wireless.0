Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50501 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752255AbcISK6o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 06:58:44 -0400
Message-ID: <1474282717.4469.33.camel@sipsolutions.net> (sfid-20160919_125847_784045_8E46D67F)
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Date: Mon, 19 Sep 2016 12:58:37 +0200
In-Reply-To: <20160919104801.GA12774@gondor.apana.org.au>
References: <20160919084056.GA11875@gondor.apana.org.au>
         <1474276530.4469.16.camel@sipsolutions.net>
         <20160919091721.GA12235@gondor.apana.org.au>
         <1474277244.4469.21.camel@sipsolutions.net>
         <20160919093434.GA12378@gondor.apana.org.au>
         <1474278634.4469.25.camel@sipsolutions.net>
         <1474278896.4469.26.camel@sipsolutions.net>
         <1474279330.4469.28.camel@sipsolutions.net>
         <1474279492.4469.29.camel@sipsolutions.net>
         <1474279827.4469.30.camel@sipsolutions.net>
         <20160919104801.GA12774@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-19 at 18:48 +0800, Herbert Xu wrote:
> On Mon, Sep 19, 2016 at 12:10:27PM +0200, Johannes Berg wrote:
> > 
> > Btw, for debug I put
> > 
> > BUG_ON(atomic_read(&ht->nelems) < 0);
> > 
> > after the atomic_dec() in __rhashtable_remove_fast_one(). That
> > makes
> > the kernel crash instantly on the buggy code, and I just have to
> > run a
> > single test ("wpas_ctrl_interface_add_many") to get there.
> 
> Aha I see the problem now.  The nelems logic on remove is broken.

I looked at it for a long time, but didn't see it :) But yeah, I've
come to the same conclusion by adding debugging of the chains etc.

> I'll send out a v3.

I'll test it when I have it :)

johannes
