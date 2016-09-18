Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55072 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756101AbcIRNvJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 09:51:09 -0400
Date: Sun, 18 Sep 2016 21:50:30 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
        tom@herbertland.com
Subject: [PATCH 0/2] rhashtable: rhashtable with duplicate objects
Message-ID: <20160918135030.GA7062@gondor.apana.org.au> (sfid-20160918_155115_106687_67B5137C)
References: <20160804071846.GA773@gondor.apana.org.au>
 <20160804074546.GA996@gondor.apana.org.au>
 <1470377813.2977.14.camel@sipsolutions.net>
 <20160805104858.GA9297@gondor.apana.org.au>
 <1470394233.2977.37.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1470394233.2977.37.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 05, 2016 at 12:50:33PM +0200, Johannes Berg wrote:
> > My plan is to build support for this directly into rhashtable.
> > So I'm adding a struct rhlist_head that would be used in place
> > of rhash_head for these cases and it'll carry an extra pointer
> > for the list of identical entries.
> > 
> > I will then add an additional layer of insert/lookup interfaces
> > for rhlist_head.
> 
> Oh, ok.

OK, it's finally ready now.

This series contains one two patches.  The first adds the rhlist
interface and the second converts mac80211 to use it.  If this works
out I'll then proceed to convert the other insecure_elasticity
users over to this.

I've tested the rhlist code with test_rhashtable but I haven't
tested the mac80211 conversion.  So please give it a go and see
if it still works.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
