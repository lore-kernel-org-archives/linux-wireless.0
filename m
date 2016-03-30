Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60965 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbcC3Nza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 09:55:30 -0400
Date: Wed, 30 Mar 2016 21:55:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ben Greear <greearb@candelatech.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, Thomas Graf <tgraf@suug.ch>
Subject: Re: Question on rhashtable in worst-case scenario.
Message-ID: <20160330135521.GA19423@gondor.apana.org.au> (sfid-20160330_155548_535213_3C043091)
References: <56F9941A.3080501@candelatech.com>
 <56FAAA6D.3070806@candelatech.com>
 <1459329252.2055.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459329252.2055.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 30, 2016 at 11:14:12AM +0200, Johannes Berg wrote:
> On Tue, 2016-03-29 at 09:16 -0700, Ben Greear wrote:
> > Looks like rhashtable has too much policy in it to properly deal with
> > cases where there are too many hash collisions, so I am going to work
> > on reverting it's use in mac80211.
> 
> I'm not really all that happy with that approach - can't we fix the
> rhashtable? It's a pretty rare corner case that many keys really are
> identical and no kind of hash algorithm, but it seems much better to
> still deal with it than to remove the rhashtable usage and go back to
> hand-rolling something.

Well to start with you should assess whether you really want to
hash multiple objects with the same key.  In particular, can an
adversary generate a large number of such objects?

If your conclusion is that yes you really want to do this, then
we have the parameter insecure_elasticity that you can use to
disable the rehashing based on chain length.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
