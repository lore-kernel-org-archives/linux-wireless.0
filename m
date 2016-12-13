Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932979AbcLMLft (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 06:35:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, Eric Biggers <ebiggers3@gmail.com>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] orinoco: Use shash instead of ahash for MIC calculations
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
        <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
Date: Tue, 13 Dec 2016 13:35:39 +0200
In-Reply-To: <8818c45b9ec6a04d85fabf9bb437cf119fd23659.1481575835.git.luto@kernel.org>
        (Andy Lutomirski's message of "Mon, 12 Dec 2016 12:55:55 -0800")
Message-ID: <87mvg0kqno.fsf@purkki.adurom.net> (sfid-20161213_123611_495857_FBCDF017)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Lutomirski <luto@kernel.org> writes:

> Eric Biggers pointed out that the orinoco driver pointed scatterlists
> at the stack.
>
> Fix it by switching from ahash to shash.  The result should be
> simpler, faster, and more correct.
>
> Cc: stable@vger.kernel.org # 4.9 only
> Reported-by: Eric Biggers <ebiggers3@gmail.com>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

"more correct"? Does this fix a real user visible bug or what? And why
just stable 4.9, does this maybe have something to do with
CONFIG_VMAP_STACK?

I'm just wondering should I push this to 4.10 or -next. This is a driver
for ancient hardware so I'm starting to lean for -next.

-- 
Kalle Valo
