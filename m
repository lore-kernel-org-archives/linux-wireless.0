Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34726 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934982AbcHJS2l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:28:41 -0400
From: Stephan Mueller <smueller@chronox.de>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 07:29:26 +0200
Message-ID: <1543667.vXsZDTRgbm@positron.chronox.de> (sfid-20160810_221349_518653_E56645A6)
In-Reply-To: <1470796501856.53342@qti.qualcomm.com>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <1645997.7cVzaEi3NG@tauon.atsec.com> <1470796501856.53342@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 10. August 2016, 02:35:04 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> For those less perfect noise source, can't pass the FIPS test.
> 
> static int update_kernel_random(int random_step,
>         unsigned char *buf, fips_ctx_t *fipsctx_in)
> {
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

I guess the only sensible solution is what Ted suggested to use 
add_device_randomness.

Ciao
Stephan
