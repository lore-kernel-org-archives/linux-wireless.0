Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60911 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753794AbYEHNdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 May 2008 09:33:03 -0400
Date: Thu, 8 May 2008 21:32:54 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH] mac80211: rewrite fragmentation code
Message-ID: <20080508133254.GA3968@gondor.apana.org.au> (sfid-20080508_153208_970460_374557C2)
References: <20080430124055.091382000@sipsolutions.net> <200805081500.00682.mb@bu3sch.de> <20080508130846.GA3769@gondor.apana.org.au> <200805081513.56521.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200805081513.56521.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 08, 2008 at 03:13:56PM +0200, Michael Buesch wrote:
>
> Ok, why is nobody actually answering my _question_? :)
> So I'll try to answer it by myself: the hard_start_xmit callback
> is actually supposed to return "void", but it returns "int" just
> for historical reasons. So there is no way to fail in a TX handler.

Pretty much.  When lockless drivers were the vogue the return
value was useful but as we've since found better ways to scale
NICs in an SMP environment (first the tg3 model, and then multi-
queue TX) that don't have the problems associated with requeueing
the packet, any non-zero return value should only be used by
existing code.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
