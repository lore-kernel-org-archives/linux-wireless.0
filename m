Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35801 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631AbcC3ODQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:03:16 -0400
Message-ID: <1459346588.2055.6.camel@sipsolutions.net> (sfid-20160330_160342_741288_39CF511D)
Subject: Re: Question on rhashtable in worst-case scenario.
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ben Greear <greearb@candelatech.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, Thomas Graf <tgraf@suug.ch>
Date: Wed, 30 Mar 2016 16:03:08 +0200
In-Reply-To: <20160330135521.GA19423@gondor.apana.org.au>
References: <56F9941A.3080501@candelatech.com>
	 <56FAAA6D.3070806@candelatech.com>
	 <1459329252.2055.1.camel@sipsolutions.net>
	 <20160330135521.GA19423@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-30 at 21:55 +0800, Herbert Xu wrote:

> Well to start with you should assess whether you really want to
> hash multiple objects with the same key.  In particular, can an
> adversary generate a large number of such objects?

No, the only reason this happens is local - if you take the single
hardware and connect it to the same AP many times. This is what Ben is
doing - he's creating virtual interfaces on top of the same physical
hardware, and then connection all of these to the same AP, mostly for
testing the AP.

> If your conclusion is that yes you really want to do this, then
> we have the parameter insecure_elasticity that you can use to
> disable the rehashing based on chain length.

But we really don't want that either - in the normal case where you
don't create all these virtual interfaces for testing, you have a
certain number of peers that can vary a lot (zero to hundreds, in
theory thousands) where you *don't* have the same key, so we still want
to have the rehashing if the chains get longer in that case.

It's really just the degenerate case that Ben is creating locally
that's causing a problem, afaict, though it's a bit disconcerting that
rhashtable in general can cause strange failures at delete time.

johannes
