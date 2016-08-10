Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outbound1a.ore.mailhop.org ([54.213.22.21]:52466 "EHLO
	outbound1a.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbcHJXmY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 19:42:24 -0400
Date: Wed, 10 Aug 2016 13:24:49 +0000
From: Jason Cooper <jason@lakedaemon.net>
To: "Pan, Miaoqing" <miaoqing@qti.qualcomm.com>
Cc: Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Message-ID: <20160810132449.GH2013@io.lakedaemon.net> (sfid-20160811_014358_967631_A328AACD)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <1526134.1iUazSISyZ@positron.chronox.de>
 <c0951e085764481d8d85637734e2e14b@aptaiexm02f.ap.qualcomm.com>
 <4321952.1nMxxDi7Wz@positron.chronox.de>
 <1e8e88ad7de64c528f08c75ff9176ab8@aptaiexm02f.ap.qualcomm.com>
 <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <389c3c1fdde2447aacf31a8b4aadfc08@aptaiexm02f.ap.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Miaoqing Pan, Stephen,

*gentle reminder: others are reading which may not be directly included
in the conversation.  Including the archives.  Please avoid top posting.
:)

On Wed, Aug 10, 2016 at 07:43:45AM +0000, Pan, Miaoqing wrote:
> The problem with using the add_device_randomness is that we do not
> know when to call that API, and we have to make our solution either
> timer-based or interrupt based, which is not really the correct way of
> implementing this feature.

Exactly.  I think we're dancing around the problem by discussing the
quality of what the ath9k adc provides.

The fact is, barring userspace expectations of /dev/hwrng, hw_random is
the appropriate place for it.  It's not a devicetree blob, mac address,
or pci config space.  Which are things we feed in once for the heck of
it.  This is a *continuous* source or questionable quality.

I'm seriously considering putting this and timeriomem-rng into a
subdirectory under hw_random/, maybe environ/.  Anything in there gets
quality=0 for default, and *doesn't* contribute to /dev/hwrng.

Regardless which path we take, I think we should include 'adc' in the
name.  I've heard countless times about "Atheros cards come with an rng
on board". :-/

thx,

Jason.
