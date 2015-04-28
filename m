Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030415AbbD1Rt0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 13:49:26 -0400
Date: Tue, 28 Apr 2015 19:49:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwl4965: Enable checking of format strings
Message-ID: <20150428174929.GA8397@redhat.com> (sfid-20150428_194948_256566_EBEB5CC2)
References: <1423695069-23436-1-git-send-email-linux@rasmusvillemoes.dk>
 <877fsw5iq1.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877fsw5iq1.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 28, 2015 at 07:19:02PM +0300, Kalle Valo wrote:
> Rasmus Villemoes <linux@rasmusvillemoes.dk> writes:
> 
> > Since these fmt_* variables are just const char*, and not const
> > char[], gcc (and smatch) doesn't to type checking of the arguments to
> > the printf functions. Since the linker knows perfectly well to merge
> > identical string constants, there's no point in having three static
> > pointers waste memory and give an extra level of indirection.
> >
> > This removes over 100 "non-constant format argument" warnings from
> > smatch, accounting for about 20% of all such warnings in an
> > allmodconfig.
> >
> > Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> 
> So what's the conclusion, should I commit this patch or not?
> 
> Full discussion here:
> 
> https://patchwork.kernel.org/patch/5814811/

I do not see the point of the patch. If compiler behave not
optimally, fix the compiler. NACK.

Stanislaw
