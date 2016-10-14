Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57616 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750822AbcJNIzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 04:55:10 -0400
Message-ID: <1476435303.31114.14.camel@sipsolutions.net> (sfid-20161014_105515_027520_CA9B87D7)
Subject: Re: [mac80211] BUG_ON with current -git (4.8.0-11417-g24532f7)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Date: Fri, 14 Oct 2016 10:55:03 +0200
In-Reply-To: <CAKv+Gu896xme5sd5i8hs7tA=Xt=qQKCiAx7fQg1ZECn50NttbQ@mail.gmail.com> (sfid-20161014_104721_667479_4407E3F4)
References: <20161010150358.GA514@swordfish>
         <20161010153050.GA836@swordfish>
         <1476263106.5271.23.camel@sipsolutions.net>
         <20161012141245.GA436@swordfish>
         <1476282127.5271.30.camel@sipsolutions.net>
         <CALCETrXg9-OpJx5Rqz8afyaug+0DjzxvpdbOV9q6i01=zCZbcQ@mail.gmail.com>
         <1476338524.4904.1.camel@sipsolutions.net> <20161013134252.GA583@swordfish>
         <1476366354.4904.31.camel@sipsolutions.net>
         <CALCETrW8imkGTtR9-mFB=e=Gdr1QXVuhXN3GRs2B6wbmPaaGhA@mail.gmail.com>
         <1476429916.4382.12.camel@sipsolutions.net>
         <1476433699.31114.6.camel@sipsolutions.net>
         <CAKv+Gu8hTy8U7FcA58P1YWt2rHU09xP9v1UU0KcnD4uuaK8How@mail.gmail.com>
         <CAKv+Gu_v+4D_7EvRkrSrStheuP1L-oPh=o7Ub+NU7-wgLYks4w@mail.gmail.com>
         <1476434561.31114.7.camel@sipsolutions.net>
         <CAKv+Gu896xme5sd5i8hs7tA=Xt=qQKCiAx7fQg1ZECn50NttbQ@mail.gmail.com>
         (sfid-20161014_104721_667479_4407E3F4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-14 at 09:47 +0100, Ard Biesheuvel wrote:
> 
> Do you have a reference for the sg_set_buf() call on odata?
> crypto/ccm.c does not seem to have it (afaict), 

It's indirect - crypto_ccm_encrypt() calls crypto_ccm_init_crypt()
which does it.

> and the same problem
> does not exist in the accelerated arm64 implementation. In the mean
> time, I will try and see if we can move aad[] off the stack in the
> WPA code.

I had that with per-CPU buffers, just sent the patch upthread.

johannes
