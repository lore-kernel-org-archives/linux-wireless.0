Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3171 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934991AbcHJS2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:28:40 -0400
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
Date: Wed, 10 Aug 2016 07:40:54 +0000
Message-ID: <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com> (sfid-20160810_221400_011401_113337DA)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
In-Reply-To: <4321952.1nMxxDi7Wz@positron.chronox.de>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephan,

That is set as "optional but highly recommended" in the FIPS doc, plus the fact that we do not have a requirement to have a FIP-approved RNG in our case. Although FIPS might impose higher and stronger requirements on the source of entropy, but not passing those tests does not mean the source of entropy is of bad quality. As I mentioned earlier, we just need to evaluate the amount of entropy it provides correctly and use it accordingly. If we are dealing with a chip which has a HW RNG, we expect extremely high entropy close to full from our source, but this patch is for chips which do not have a dedicated HW RNG in place to improve the quality of random number generation on the platform.

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, August 10, 2016 3:27 PM
To: Pan, Miaoqing <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>; Matt Mackall <mpm@selenic.com>; miaoqing@codeaurora.org; Valo, Kalle <kvalo@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 07:15:49 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> NIST SP 800-22-rev1a and NIST SP 800-90B are used together to evaluate 
> the amount of min entropy the source provides, and not to decide if 
> the source has passed the tests or failed. See
> 
> https://github.com/usnistgov/SP800-90B_EntropyAssessment
> 
> The goal is often to make sure the input entropy is more than the 
> entropy we expect from the output.

You are correct on the SP800-90B tests (hence I did not refer to them for the binary decision). Yet, SP800-22 with the associated tool delivers a binary decision.

Ciao
Stephan
