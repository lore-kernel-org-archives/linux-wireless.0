Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49496 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932727AbcJQJfX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 05:35:23 -0400
Message-ID: <1476696918.19992.15.camel@sipsolutions.net> (sfid-20161017_113528_868750_DCD5B0F1)
Subject: Re: [PATCH v4] mac80211: move extra crypto data off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date: Mon, 17 Oct 2016 11:35:18 +0200
In-Reply-To: <CAKv+Gu_ZH9hO_xbVfOfk90CxFJ6ZTz3PKWB1v23LRVzpBrb=oQ@mail.gmail.com> (sfid-20161017_113100_410034_F49AAA79)
References: <1476693195-14071-1-git-send-email-johannes@sipsolutions.net>
         <CAKv+Gu-aZhCBvnEQoZUZLDPXCrvgxO1pSd=6EHz+tMB+dFz5hg@mail.gmail.com>
         <1476696226.19992.13.camel@sipsolutions.net>
         <CAKv+Gu_ZH9hO_xbVfOfk90CxFJ6ZTz3PKWB1v23LRVzpBrb=oQ@mail.gmail.com>
         (sfid-20161017_113100_410034_F49AAA79)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-10-17 at 10:30 +0100, Ard Biesheuvel wrote:

> Yes. But as I replied, setting the req size is not supported atm,
> although it is reasonable to demand a way to allocate additional data
> in the request specifically for this issue. So let's proceed with the
> aead_request_alloc/free patch, but I would like to propose something
> on the API side to address this particular issue

Well, if your other patch to make it OK to be on-stack would be applied
instead, this wouldn't make much sense either :)

In this particular patch, we could reduce the size of the struct, but I
don't actually think it'll make a difference to go from 48 to 36 bytes,
given alignment etc., so I think I'll just leave it as is.

johannes
