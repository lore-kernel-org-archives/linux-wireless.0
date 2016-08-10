Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19097 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbcHJCgG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 22:36:06 -0400
From: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
CC: Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Wed, 10 Aug 2016 02:35:04 +0000
Message-ID: <1470796501856.53342@qti.qualcomm.com> (sfid-20160810_043610_989335_78A0FD8F)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <2569442.q63FVBJjUH@tauon.atsec.com>
 <20160809091755.GA6370@gondor.apana.org.au>,<1645997.7cVzaEi3NG@tauon.atsec.com>
In-Reply-To: <1645997.7cVzaEi3NG@tauon.atsec.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephan,

For those less perfect noise source, can't pass the FIPS test.

static int update_kernel_random(int random_step,
        unsigned char *buf, fips_ctx_t *fipsctx_in)
{
        unsigned char *p; 
        int fips;

        fips = fips_run_rng_test(fipsctx_in, buf);
        if (fips)
                return 1;

        for (p = buf; p + random_step <= &buf[FIPS_RNG_BUFFER_SIZE];
                 p += random_step) {
                random_add_entropy(p, random_step);
                random_sleep();
        }
        return 0;
}

--
Miaoqing
________________________________________
From: Stephan Mueller <smueller@chronox.de>
Sent: Tuesday, August 9, 2016 5:37 PM
To: Herbert Xu
Cc: Pan, Miaoqing; Matt Mackall; miaoqing@codeaurora.org; Valo, Kalle; linux-wireless@vger.kernel.org; ath9k-devel; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Dienstag, 9. August 2016, 17:17:55 CEST schrieb Herbert Xu:

Hi Herbert,

> On Tue, Aug 09, 2016 at 11:02:58AM +0200, Stephan Mueller wrote:
> > But shouldn't the default of the rngd then be adjusted a bit?
>
> Please elaborate.

in rngd_linux.c:random_add_entropy(void *buf, size_t size):

        entropy.ent_count = size * 8;
        entropy.size = size;
        memcpy(entropy.data, buf, size);

        if (ioctl(random_fd, RNDADDENTROPY, &entropy) != 0) {

...


in rngd.c:do_loop():

                        retval = iter->xread(buf, sizeof buf, iter);
...
                        rc = update_kernel_random(random_step,
                                             buf, iter->fipsctx);

where update_kernel_random simply invokes random_add_entropy in chunks.

Hence, the rngd reads some bytes from /dev/hwrand and injects it into /dev/
random with an entropy estimate that is equal to the read bytes.

With less than perfect noise sources, entropy.ent_count should be much
smaller.
>
> Thanks,



Ciao
Stephan
