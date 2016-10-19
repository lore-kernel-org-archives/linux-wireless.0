Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35882 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945969AbcJSQAc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 12:00:32 -0400
Message-ID: <1476892822.10092.15.camel@sipsolutions.net> (sfid-20161019_180250_786132_326FC139)
Subject: Re: [PATCH] crypto: ccm - avoid scatterlist for MAC encryption
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Andy Lutomirski <luto@amacapital.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Date: Wed, 19 Oct 2016 18:00:22 +0200
In-Reply-To: <5807984D.4050307@candelatech.com>
References: <1476551776-8099-1-git-send-email-ard.biesheuvel@linaro.org>
         <1476689310.19992.1.camel@sipsolutions.net>
         <CAKv+Gu_P-6sHW3t7tp1N+3v9ZGqWcQrzMZkASY5g=QR76KN4wg@mail.gmail.com>
         <CALCETrUWW2A1XK7BzcajTcBzg58SDUCTE35Hj1vmbywTLCe2vQ@mail.gmail.com>
         <CAKv+Gu-25OvTSbyE06Ln8N+HsqNyV1T6oOudK2tyAAOmmXXqgA@mail.gmail.com>
         <20161019033157.GA1457@gondor.apana.org.au>
         <1476862995.5927.3.camel@sipsolutions.net>
         <CAKv+Gu9CppR+AN5_RdDJ6ZBRr1EDDLB+nABPddyaj5TKb5=j_Q@mail.gmail.com>
         <5807984D.4050307@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-19 at 08:59 -0700, Ben Greear wrote:
> 
> Do you actually expect performance regressions?  I'll be complaining
> if so, but will test first :)

I think we can expect this to use a bit more CPU time, but unless
you're very tight on that you probably shouldn't expect any throughput
difference.

johannes
