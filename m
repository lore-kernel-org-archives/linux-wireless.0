Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34302 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbcHIJho (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 05:37:44 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Date: Tue, 09 Aug 2016 11:37:39 +0200
Message-ID: <1645997.7cVzaEi3NG@tauon.atsec.com> (sfid-20160809_113747_784363_DCADA41B)
In-Reply-To: <20160809091755.GA6370@gondor.apana.org.au>
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org> <2569442.q63FVBJjUH@tauon.atsec.com> <20160809091755.GA6370@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
