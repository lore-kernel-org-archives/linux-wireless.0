Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54681 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965916AbbD1QTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 12:19:10 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwl4965: Enable checking of format strings
References: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>
Date: Tue, 28 Apr 2015 19:19:02 +0300
In-Reply-To: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>
	(Rasmus Villemoes's message of "Wed, 11 Feb 2015 23:51:08 +0100")
Message-ID: <877fsw5iq1.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_181932_266507_7DCC0D24)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:

> Since these fmt_* variables are just const char*, and not const
> char[], gcc (and smatch) doesn't to type checking of the arguments to
> the printf functions. Since the linker knows perfectly well to merge
> identical string constants, there's no point in having three static
> pointers waste memory and give an extra level of indirection.
>
> This removes over 100 "non-constant format argument" warnings from
> smatch, accounting for about 20% of all such warnings in an
> allmodconfig.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

So what's the conclusion, should I commit this patch or not?

Full discussion here:

https://patchwork.kernel.org/patch/5814811/

-- 
Kalle Valo
