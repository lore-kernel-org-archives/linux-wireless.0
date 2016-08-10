Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5445 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934423AbcHJTfa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 15:35:30 -0400
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
Date: Wed, 10 Aug 2016 06:46:31 +0000
Message-ID: <82844e4b56c9475fabf22b3fe12b53bb@aptaiexm02f.ap.qualcomm.com> (sfid-20160810_213610_039916_3CBF1314)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1543667.vXsZDTRgbm@positron.chronox.de>
 <866e31b50f364a87aabe94d2af03ecb8@aptaiexm02f.ap.qualcomm.com>
 <14565196.xaXq375WQg@tauon.atsec.com>
In-Reply-To: <14565196.xaXq375WQg@tauon.atsec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stephan,

Would you please provide a recent NIST document which asks the entropy source to pass the NIST randomness tests ?

Thanks,
Miaoqing

-----Original Message-----
From: Stephan Mueller [mailto:smueller@chronox.de] 
Sent: Wednesday, August 10, 2016 2:25 PM
To: Pan, Miaoqing <miaoqing@qti.qualcomm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>; Matt Mackall <mpm@selenic.com>; miaoqing@codeaurora.org; Valo, Kalle <kvalo@qca.qualcomm.com>; linux-wireless@vger.kernel.org; ath9k-devel <ath9k-devel@qca.qualcomm.com>; linux-crypto@vger.kernel.org; jason@lakedaemon.net; Sepehrdad, Pouyan <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default

Am Mittwoch, 10. August 2016, 06:04:32 CEST schrieb Pan, Miaoqing:

Hi Miaoqing,

> Hi Stephan,
> 
> FIPS RNG test is supposed to be run on the output of an RNG, and not 
> on the RNG entropy source. It is not surprising that the RNG input 
> fails the entropy tests from NIST. Check the following example.
> 
> Imagine you have a perfectly random sequence, a_1, a_2, .., a_n, where 
> each a_i is a byte. And imagine, this sequence passes all randomness tests.
> 
> Now, let's say I create a new sequence a_1, 0, a_2, 0, a_3, 0, ..., 0, 
> a_n, where each zero is a byte
> 
> If you give this sequence (as an entropy source) to a randomness test, 
> it will fail most of the tests, if not all. This does not mean this 
> sequence is not appropriate as an entropy source, it just means we 
> need twice more bytes to gain the same amount of entropy.

Agreed. But that is a very simplistic view.
> 
> I can give this 2n byte sequence to an RNG as an entropy source and it 
> provides the same amount of security as if I give the n byte stream.

Well, I am working with standards bodies like NIST and BSI on RNG assessments. They all require that the noise source (pre-whitening, of
course) pass statistical tests like the AIS20 tests, SP800-22 and similar. If you fail, you better have a good argument.

And the only argument that is kind of allowed is that you oversample your noise source to seed a DRNG from (i.e. have an entropy to data ratio of significantly below 1). And the argument for the oversampling rate is always a very interesting discussion. You apply 10/32. In private, I am wondering about that ratio, but this should not be discussed here as I hope you have a valid argument for that.

As we are talking about the current rngd, we have to consider that it does
*not* perform an oversampling (yet) as mentioned in the previous emails.

Do not get me wrong on my initial patch: your RNG may provide some entropy. 
But there are quite some folks who want to understand and audit a noise source before using it. Your current implementation simply does not allow switching the noise source off to feed the input_pool with data that increases the entropy estimator (at runtime).

Ciao
Stephan
