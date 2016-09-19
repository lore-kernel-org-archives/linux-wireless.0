Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50136 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753120AbcISJiP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 05:38:15 -0400
Message-ID: <1474277889.4469.24.camel@sipsolutions.net> (sfid-20160919_113821_033868_CF1F749A)
Subject: Re: [v2 PATCH 0/2] rhashtable: rhashtable with duplicate objects
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com, Ben Greear <greearb@candelatech.com>
Date: Mon, 19 Sep 2016 11:38:09 +0200
In-Reply-To: <20160919093434.GA12378@gondor.apana.org.au> (sfid-20160919_113440_719977_971CE718)
References: <20160804071846.GA773@gondor.apana.org.au>
         <20160804074546.GA996@gondor.apana.org.au>
         <1470377813.2977.14.camel@sipsolutions.net>
         <20160805104858.GA9297@gondor.apana.org.au>
         <1470394233.2977.37.camel@sipsolutions.net>
         <20160918135030.GA7062@gondor.apana.org.au>
         <20160919084056.GA11875@gondor.apana.org.au>
         <1474276530.4469.16.camel@sipsolutions.net>
         <20160919091721.GA12235@gondor.apana.org.au>
         <1474277244.4469.21.camel@sipsolutions.net>
         <20160919093434.GA12378@gondor.apana.org.au>
         (sfid-20160919_113440_719977_971CE718)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-09-19 at 17:34 +0800, Herbert Xu wrote:
> On Mon, Sep 19, 2016 at 11:27:24AM +0200, Johannes Berg wrote:
> > 
> > 
> > I have a feeling there's a bug with ht->nelems, since the crash is
> > always in the grow worker, but I haven't quite put my finger on it
> > yet.
> 
> Can you show me a stack trace?

Oops, just deleted the old ones to reproduce with some debug printks :)

It's always while trying to grow a table from the worker; it kills
processes, but eventually no process are left and the kernel panics.

I'll send you a trace when I have one again - I'm running a new
reproduction now.

johannes
