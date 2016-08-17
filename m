Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36906 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbcHQRLe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 13:11:34 -0400
Received: by mail-wm0-f41.google.com with SMTP id i5so245341431wmg.0
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2016 10:11:14 -0700 (PDT)
Date: Wed, 17 Aug 2016 18:11:09 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dinan.gunawardena@netronome.com
Subject: Re: [PATCHv6 1/2] add basic register-field manipulation macros
Message-ID: <20160817181109.080edf7a@jkicinski-Precision-T1700> (sfid-20160817_191155_699752_FB11B1CB)
In-Reply-To: <CA+55aFwSUKorb-jho0eHzdzGNKr4c1UO8d0CRe=fsLPmUheKeg@mail.gmail.com>
References: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
	<1471360704-10507-2-git-send-email-jakub.kicinski@netronome.com>
	<8737m3bsau.fsf@kamboji.qca.qualcomm.com>
	<CA+55aFwSUKorb-jho0eHzdzGNKr4c1UO8d0CRe=fsLPmUheKeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 17 Aug 2016 09:33:26 -0700, Linus Torvalds wrote:
> On Wed, Aug 17, 2016 at 3:31 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Are people ok with this? I think they are useful and I can take these
> > through my tree, but I would prefer to get an ack from other maintainers
> > first. Dave? Andrew?  
> 
> I'm not a huge fan, since the interface fundamentally seems to be
> oddly designed (why pass in the mask rather than "start bit +
> length"?).

Would that not require start and length to have separate defines?

I assume doing:

    #define REG_BLA_FIELD_FOO  3, 4
    val = FIELD_GET(REG_BLA_FIELD_FOO, reg);

is not acceptable.  Attempts to define a single value brought us to the
shifted mask.

> I also don't like how this very much would match the GENMASK() macros
> we have, but then it clashes with them in other ways
> 
>  - it's in a different header file

I'll move to bitops.h.

>  - it has completely different naming (GENMASK_ULL vs FIELD_GET64}.
> 
> I actually think the naming could/should be fixed by just
> automatically doing the right thing based on sizes.  For example,
> GENMASK could just have something like
> 
>   #define GENMASK(end,start) __builtin_choose_expr((end)>31,
> __GENMASK_64(end,start), __GENMASK_32(end,start))
> 
> and doing similar things with the FIELD_GET/SET ops.
> 
> So I'm not entirely happy about this all.

Seems feasible.

> But if people love the interface, and think the above kind of cleanups
> might be possible, I'd just want to make sure that there is also a
> 
>        BUILD_BUG_ON(!__builtin_constant_p(_mask));
> 
> because if the mask isn't a build-time constant, the code ends up
> being *complete* shit. Also preferably something like
> 
>        BUILD_BUG_ON((_mask) > (typeof(_val)~0ull);
> 
> to make sure you can't try to mask bits that don't exist in the value.
> 
> Or something like that to make mis-uses *really* obvious.

OK!

> The FIELD_PUT macro also seems misnamed. It doesn't "put" anything
> (unlike the GET macro). It just prepares the field for inserting
> later. As exemplified by how you actually have to put things:
> 
> First, "GET" - yeah, that looks like a "get" operation:
> 
>  * Get:
>  *  a = FIELD_GET(REG_FIELD_A, reg);
> 
> But then "PUT" isn't actually a PUT operation at all, but the comments
> kind of gloss over it by talking about "Modify" instead:
> 
>  * Modify:
>  *  reg &= ~REG_FIELD_C;
>  *  reg |= FIELD_PUT(REG_FIELD_C, c);
> 
> so I'm not entirely sure about the naming.
> 
> I can live with the FIELD_PUT naming, because I see how it comes
> about, even if I think it's a bit odd. I might have called it
> "FIELD_PREP" instead, but I'm not really sure that's all that much
> better.

Yes, it used to be called FIELD_SET, which was even worse.  I think
PREP sounds good.

Thanks!
