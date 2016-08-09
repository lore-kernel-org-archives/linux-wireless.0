Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:41680 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020AbcHIKZC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2016 06:25:02 -0400
Date: Tue, 9 Aug 2016 07:24:58 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Stephan Mueller <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	Matt Mackall <mpm@selenic.com>,
	"miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@qca.qualcomm.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"jason@lakedaemon.net" <jason@lakedaemon.net>,
	"Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>
Subject: Re: [PATCH 2/2] ath9k: disable RNG by default
Message-ID: <20160809102458.GA20214@khazad-dum.debian.net> (sfid-20160809_122507_251384_C80662FB)
References: <1470726147-30095-1-git-send-email-miaoqing@codeaurora.org>
 <12791731.pG3fmEhvyp@tauon.atsec.com>
 <20160809095657.GB6618@gondor.apana.org.au>
 <11316081.S4pPZmZMrt@tauon.atsec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <11316081.S4pPZmZMrt@tauon.atsec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 09 Aug 2016, Stephan Mueller wrote:
> RHEL 7 and Fedora do not adjust it. So, shall we consider those rng-tools then 
> broken (at least in those large distros)?

Might I humbly suggest that the kernel start providing some metatada
about the quality of the random source that userspace can consume?
Preferably by a new ioctl, so that it will fit naturally if we ever
extend /dev/hwrng to support more than one source?

That would allow for auto tunning to be implemented in userspace...

-- 
  Henrique Holschuh
