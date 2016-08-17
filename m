Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32941 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbcHQQd1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2016 12:33:27 -0400
MIME-Version: 1.0
In-Reply-To: <8737m3bsau.fsf@kamboji.qca.qualcomm.com>
References: <1471360704-10507-1-git-send-email-jakub.kicinski@netronome.com>
 <1471360704-10507-2-git-send-email-jakub.kicinski@netronome.com> <8737m3bsau.fsf@kamboji.qca.qualcomm.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Aug 2016 09:33:26 -0700
Message-ID: <CA+55aFwSUKorb-jho0eHzdzGNKr4c1UO8d0CRe=fsLPmUheKeg@mail.gmail.com> (sfid-20160817_183345_608714_BE9ABB9D)
Subject: Re: [PATCHv6 1/2] add basic register-field manipulation macros
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dinan.gunawardena@netronome.com,
	Jakub Kicinski <jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 17, 2016 at 3:31 AM, Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Are people ok with this? I think they are useful and I can take these
> through my tree, but I would prefer to get an ack from other maintainers
> first. Dave? Andrew?

I'm not a huge fan, since the interface fundamentally seems to be
oddly designed (why pass in the mask rather than "start bit +
length"?).

I also don't like how this very much would match the GENMASK() macros
we have, but then it clashes with them in other ways

 - it's in a different header file

 - it has completely different naming (GENMASK_ULL vs FIELD_GET64}.

I actually think the naming could/should be fixed by just
automatically doing the right thing based on sizes.  For example,
GENMASK could just have something like

  #define GENMASK(end,start) __builtin_choose_expr((end)>31,
__GENMASK_64(end,start), __GENMASK_32(end,start))

and doing similar things with the FIELD_GET/SET ops.

So I'm not entirely happy about this all.

But if people love the interface, and think the above kind of cleanups
might be possible, I'd just want to make sure that there is also a

       BUILD_BUG_ON(!__builtin_constant_p(_mask));

because if the mask isn't a build-time constant, the code ends up
being *complete* shit. Also preferably something like

       BUILD_BUG_ON((_mask) > (typeof(_val)~0ull);

to make sure you can't try to mask bits that don't exist in the value.

Or something like that to make mis-uses *really* obvious.

The FIELD_PUT macro also seems misnamed. It doesn't "put" anything
(unlike the GET macro). It just prepares the field for inserting
later. As exemplified by how you actually have to put things:

First, "GET" - yeah, that looks like a "get" operation:

 * Get:
 *  a = FIELD_GET(REG_FIELD_A, reg);

But then "PUT" isn't actually a PUT operation at all, but the comments
kind of gloss over it by talking about "Modify" instead:

 * Modify:
 *  reg &= ~REG_FIELD_C;
 *  reg |= FIELD_PUT(REG_FIELD_C, c);

so I'm not entirely sure about the naming.

I can live with the FIELD_PUT naming, because I see how it comes
about, even if I think it's a bit odd. I might have called it
"FIELD_PREP" instead, but I'm not really sure that's all that much
better.

Am I being a bit anal? Yeah. But when we add whole new abstractions
that we haven't used historically, I'd really like those to be obvious
and easy to use (or rather, really _hard_ to get wrong by mistake).

Hmm?

                  Linus
