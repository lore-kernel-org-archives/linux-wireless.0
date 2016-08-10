Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4973 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915AbcHJSxB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:53:01 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: RE: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 06:04:32 +0000
Message-ID: <866e31b50f364a87aabe94d2af03ecb8@aptaiexm02f.ap.qualcomm.com> (sfid-20160810_213856_602830_F245086D)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1645997.7cVzaEi3NG@tauon.atsec.com> <1470796501856.53342@qti.qualcomm.com>
 <1543667.vXsZDTRgbm@positron.chronox.de>
In-Reply-To: <1543667.vXsZDTRgbm@positron.chronox.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephan,

FIPS RNG test is supposed to be run on the output of an RNG, and not on the RNG entropy source. It is not surprising that the RNG input fails the entropy tests from NIST. Check the following example.

Imagine you have a perfectly random sequence, a_1, a_2, .., a_n, where each a_i is a byte. And imagine, this sequence passes all randomness tests.

Now, let's say I create a new sequence a_1, 0, a_2, 0, a_3, 0, ..., 0, a_n, where each zero is a byte

If you give this sequence (as an entropy source) to a randomness test, it will fail most of the tests, if not all. This does not mean this sequence is not appropriate as an entropy source, it just means we need twice more bytes to gain the same amount of entropy.

I can give this 2n byte sequence to an RNG as an entropy source and it provides the same amount of security as if I give the n byte stream.

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, August 10, 2016 1:29 PM
To: Pan, Miaoqing <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>; Matt Mackall <mpm@selenic.com>; miaoqing@codeaurora.org; Valo, Kalle <kvalo@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 02:35:04 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> For those less perfect noise source, can't pass the FIPS test.
> 
> static int update_kernel_random(int random_step,
>         unsigned char *buf, fips_ctx_t *fipsctx_in) {
>         unsigned char *p;
>         int fips;
> 
>         fips = fips_run_rng_test(fipsctx_in, buf);
>         if (fips)
>                 return 1;
> 
>         for (p = buf; p + random_step <= &buf[FIPS_RNG_BUFFER_SIZE];
>                  p += random_step) {
>                 random_add_entropy(p, random_step);
>                 random_sleep();
>         }
>         return 0;
> }

Not even the poor cheap AIS20 statistical tests from rngd pass?

I guess the only sensible solution is what Ted suggested to use add_device_randomness.

Ciao
Stephan
