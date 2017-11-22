Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:41302 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751599AbdKVSmo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 13:42:44 -0500
Message-ID: <1511376145.2841.1.camel@sipsolutions.net> (sfid-20171122_194314_322707_DFE296E5)
Subject: Re: kernel BUG at crypto/asymmetric_keys/public_key.c:80
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 22 Nov 2017 19:42:25 +0100
In-Reply-To: <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com> (sfid-20171122_192904_463452_F66EBF18)
References: <d2b989b6-38cf-a04d-0353-3540fdb891ed@gmail.com>
         <2ef18f35-bb00-2f4b-45fe-1beb3cdd0745@broadcom.com>
         (sfid-20171122_192904_463452_F66EBF18)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-11-22 at 19:29 +0100, Arend van Spriel wrote:
> + Johannes
> 
>  >>>     BUG_ON(!sig->digest);
>          BUG_ON(!sig->s);

I *think* this is the same bug that was reported before, then this
should fix it:

https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=d7be102f2945a626f55e0501e52bb31ba3e77b81

Can you try?

johannes
