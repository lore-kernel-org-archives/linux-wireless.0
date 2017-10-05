Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60712 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750756AbdJEEiC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Oct 2017 00:38:02 -0400
Date: Wed, 04 Oct 2017 21:37:58 -0700 (PDT)
Message-Id: <20171004.213758.2210486785503998906.davem@davemloft.net> (sfid-20171005_063806_626682_505FC3AE)
To: herbert@gondor.apana.org.au
Cc: marcelo.leitner@gmail.com, luto@kernel.org, baijiaju1990@163.com,
        nhorman@tuxdriver.com, vyasevich@gmail.com, kvalo@codeaurora.org,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
From: David Miller <davem@davemloft.net>
In-Reply-To: <20171005034054.GB31996@gondor.apana.org.au>
References: <20171003052643.GB22750@gondor.apana.org.au>
        <20171003224505.GE19750@localhost.localdomain>
        <20171005034054.GB31996@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Herbert Xu <herbert@gondor.apana.org.au>
Date: Thu, 5 Oct 2017 11:40:54 +0800

> On Tue, Oct 03, 2017 at 07:45:06PM -0300, Marcelo Ricardo Leitner wrote:
>>
>> > Usually if you're invoking setkey from a non-sleeping code-path
>> > you're probably doing something wrong.
>> 
>> Usually but not always. There are 3 calls to that function on SCTP
>> code:
>> - pack a cookie, which is sent on an INIT_ACK packet to the client
>> - unpack the cookie above, after it is sent back by the client on a
>>   COOKIE_ECHO packet
>> - send a chunk authenticated by a hash
> 
> I'm not talking about the code-path in question.  I'm talking
> about the function which generates the secret key in the first
> place.  AFAICS that's only called in GFP_KERNEL context.  What
> am I missing?

The setkey happens in functions like sctp_pack_cookie() and
sctp_unpack_cookie(), which seems to run from software interrupts.
