Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49599 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933755AbcJQJyE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 05:54:04 -0400
Message-ID: <1476698041.19992.19.camel@sipsolutions.net> (sfid-20161017_115423_423242_8D2E2ECC)
Subject: Re: [PATCH v4] mac80211: move extra crypto data off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 17 Oct 2016 11:54:01 +0200
In-Reply-To: <67161BCC-596E-4DDE-A58E-9195BB5570C2@linaro.org> (sfid-20161017_115245_275022_941CE721)
References: <1476693195-14071-1-git-send-email-johannes@sipsolutions.net>
         <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com>
         <1476696226.19992.13.camel@sipsolutions.net>
         <CAKv+Gu_ZH9hO_xbVfOfk90CxFJ6ZTz3PKWB1v23LRVzpBrb=oQ@mail.gmail.com>
         <1476696918.19992.15.camel@sipsolutions.net>
         <67161BCC-596E-4DDE-A58E-9195BB5570C2@linaro.org>
         (sfid-20161017_115245_275022_941CE721)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > Well, if your other patch to make it OK to be on-stack would be
> > applied instead, this wouldn't make much sense either :)
> > 
> 
> Yes but that one only fixes ccm not gcm

Yes, but we can do the same for GCM, no?

> > In this particular patch, we could reduce the size of the struct,
> > but I
> > don't actually think it'll make a difference to go from 48 to 36
> > bytes,
> > given alignment etc., so I think I'll just leave it as is.
> > 
> 
> I understand you are in a hurry, but this is unlikely to be the only
> such issue. I will propose an 'auxdata' feature for the crypto api
> that can be used here, but also for any other occurrence where client
> data assoiciated with the request can no longer be allocated on the
> stack

No objections. I'll merge this anyway today I think, reverting is easy
later.

johannes
