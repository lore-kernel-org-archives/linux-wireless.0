Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:11051 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751353AbeDWGUR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 02:20:17 -0400
Message-ID: <4777fb12da0a71e030cc7b0cf47d5391be2a3efd.camel@intel.com> (sfid-20180423_082032_345398_EC117856)
Subject: Re: New sparse warning from min_t(): expression using sizeof(void)
From: Luciano Coelho <luciano.coelho@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Joey Pabalinas <joeypabalinas@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Mon, 23 Apr 2018 09:20:14 +0300
In-Reply-To: <87604ley7t.fsf@kamboji.qca.qualcomm.com>
References: <87a7txf15w.fsf@kamboji.qca.qualcomm.com>
         <20180421082444.i4eyw2zxl6tipt6i@gmail.com>
         <87604ley7t.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-04-21 at 11:54 +0300, Kalle Valo wrote:
> Joey Pabalinas <joeypabalinas@gmail.com> writes:
> 
> > On Sat, Apr 21, 2018 at 10:50:51AM +0300, Kalle Valo wrote:
> > > Is there any way to fix it? With ath10k I use sparse a lot and
> > > because
> > > of these warnings sparse is now very annoying to use.
> > 
> > I submitted a sparse patch [1] for this not too long ago, but in
> > the
> > meantime you can still curl the patch [2] and apply it directly to
> > the v0.5.2 release to suppress the deluge of warnings (-Wpointer-
> > arith
> > is off by defaultl so no need to change any of you configurations).
> > 
> > [1] https://lkml.org/lkml/2018/4/10/923
> > [2] https://patchwork.kernel.org/patch/10334353/raw/
> 
> Perfect, thanks. Unfortunatelly I need to catch a boat and I can't
> test
> it right now, but I'll do that on Monday.

Thanks, this solves the problem for me, but I'm still getting a lot of
this:

./include/linux/mm.h:533:24: warning: constant 0xffffc90000000000 is so big it is unsigned long

Is there a patch in sparse to solve this one as well? Or is this an
actual error that must be fixed in mm.h?

--
Cheers,
Luca.
