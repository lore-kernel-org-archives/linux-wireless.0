Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57892 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935695AbeFOPPV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Jun 2018 11:15:21 -0400
Date: Fri, 15 Jun 2018 23:15:03 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>
Cc: mpm@selenic.com, spam@lukas-wirz.de, linux-crypto@vger.kernel.org,
        b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        prasannatsmkumar@gmail.com, freude@linux.vnet.ibm.com
Subject: Re: [PATCH] hw_random: Always drop the RNG in hwrng_unregister()
Message-ID: <20180615151503.ryml5ixzv66stwge@gondor.apana.org.au> (sfid-20180615_171524_370280_DBA1820C)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20180614200811.76401d95@wiggum>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Büsch <m@bues.ch> wrote:
> [-- text/plain, encoding quoted-printable, charset: UTF-8, 57 lines --]
> 
> enable_best_rng() is used in hwrng_unregister() to switch away from the
> currently active RNG, if that is the one currently being removed.
> However enable_best_rng() might fail, if the next RNG's init routine
> fails. In that case enable_best_rng() will return an error code and
> the currently active RNG will remain active.
> After unregistering this might lead to crashes due to use-after-free.
> 
> Fix this by dropping the currently active RNG, if enable_best_rng()
> failed. This will result in no RNG to be active, if the next-best
> one failed to initialize.
> 
> This problem was introduced by 142a27f0a731ddcf467546960a5585970ca98e21
> 
> 
> Reported-by: Wirz <spam@lukas-wirz.de>
> Tested-by: Wirz <spam@lukas-wirz.de>
> Signed-off-by: Michael Büsch <m@bues.ch>
> Cc: stable@vger.kernel.org

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
