Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49453 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933195AbcJQJYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 05:24:23 -0400
Message-ID: <1476696226.19992.13.camel@sipsolutions.net> (sfid-20161017_112429_110402_E04F87FC)
Subject: Re: [PATCH v4] mac80211: move extra crypto data off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 17 Oct 2016 11:23:46 +0200
In-Reply-To: <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com> (sfid-20161017_111430_166768_740CD0F3)
References: <1476693195-14071-1-git-send-email-johannes@sipsolutions.net>
         <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com>
         (sfid-20161017_111430_166768_740CD0F3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Apologies for going back and forth on this, but it appears there may
> be another way to deal with this.
> 
> First of all, we only need this handling for the authenticated data,

Are you sure b_0/j_0 aren't needed? We pass those
to aead_request_set_crypt(), and I wasn't sure what that really did
internally, perhaps like the internal data.

Testing with that on the stack does seem to work, in fact.

Surely we need zero for GMAC though, since we also put that into the sg
list. Thus for GMAC we definitely need 20+16 bytes, and since I round
up to a cacheline (at least on SMP) it doesn't really matter that we
could get 36 instead of the 48 I have now.

> and only for CCM and GCM, not CMAC (which does not use scatterlists
> at all, it simply calls the AES cipher directly)

I didn't modify CMAC, I think, only GMAC, which also uses scatterlists.

> So that leaves a fixed 20 bytes for GCM and fixed 32 bytes for CCM,

and 36 for GMAC :)

johannes
