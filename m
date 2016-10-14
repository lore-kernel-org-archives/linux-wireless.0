Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59067 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754535AbcJNNoJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Oct 2016 09:44:09 -0400
Message-ID: <1476450941.31114.45.camel@sipsolutions.net> (sfid-20161014_154413_600829_D3CA100A)
Subject: Re: [PATCH] mac80211: aes_ccm: move struct aead_req off the stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jouni Malinen <j@w1.fi>
Date: Fri, 14 Oct 2016 15:15:41 +0200
In-Reply-To: <CAKv+Gu_eS-C84rH_MLYy--ivC0a99wwJvNDLhETfrBkYXW-XpA@mail.gmail.com> (sfid-20161014_151311_047575_C7571920)
References: <1476450540-1760-1-git-send-email-ard.biesheuvel@linaro.org>
         <1476450635.31114.42.camel@sipsolutions.net>
         <CAKv+Gu_eS-C84rH_MLYy--ivC0a99wwJvNDLhETfrBkYXW-XpA@mail.gmail.com>
         (sfid-20161014_151311_047575_C7571920)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-10-14 at 14:13 +0100, Ard Biesheuvel wrote:
> 
> > But if we allocate things anyway, is it worth expending per-CPU
> > buffers on these?
> 
> Ehmm, maybe not. I could spin a v2 that allocates a bigger buffer,
> and copies aad[] into it as well

Copies in/out, I guess. Also there's B_0/J_0 for CCM/GCM, and the
'zero' thing that GMAC has.

> That does not help the other algos though

What do you mean?

johannes
