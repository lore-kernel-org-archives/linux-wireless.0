Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33659 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755810Ab3LDTUi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Dec 2013 14:20:38 -0500
Received: by mail-bk0-f53.google.com with SMTP id na10so6709910bkb.40
        for <linux-wireless@vger.kernel.org>; Wed, 04 Dec 2013 11:20:37 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: p2p@posteo.de, linux-wireless@vger.kernel.org
Subject: Re: RTL8188S
Date: Wed, 04 Dec 2013 20:20:33 +0100
Message-ID: <7500746.DphX02H77Q@blech> (sfid-20131204_202042_106229_EDC101D0)
In-Reply-To: <ca7208642ae7c2ad48c990314f2f03ba@posteo.de>
References: <a3a1cb41444ae8dd89db830ae927491f@posteo.de> <1708062.P25CKJLDQp@blech> <ca7208642ae7c2ad48c990314f2f03ba@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(readded cc)

Hello Peter,

On Wednesday, December 04, 2013 07:10:01 PM p2p@posteo.de wrote:
> >> I don't know yet if I have the time to take part. But as I wrote I 
> >> have a good book which describes in detail driver development for
> >> 2.6 kernel.
> >>
> >> What do you think how many LOC have to been written?
> > Ok?!
> >
> > rtl8192cu has around 8600 LOCs, rtl8192se has around 10700. That 
> > said,
> > realtek's own 8190n driver comes in at 90 000+ LOCs driver [of 
> > course,
> > that driver comes with its own stack, sme and maybe a few other bells
> > and whiles]. I guess the answer here is really: take what ever number
> > you prefer :-D.
> >
> 
> What do you think how many percent can be written by copy and paste?

I think this problem has to be approached from two sides.

1.
In theory (as in CS theory) everything you need is basically a carefully
selected string of 0 and 1s. [That said: it is very hard to develop this way.
but it would be cool - certainly a "one of a kind" approach in these days.
It would be familiar with those who ever had to use punch cards and a 
"one-shot" hole puncher].
=> need to copy & paste just 2 bits

2.
rtlwifi should already provide a decent framework/foundation for such a
driver. So no need to copy anything, you just have to use the API that's
already in place. If you need a function from rtl8192se or rtl8192cu, you
shouldn't copy it, but move it to the shared library code instead.
=> no copy & paste at all.

Summary: 
"A driver can be copied & pasted together from just two bits (that would a
cool "best case")... or it could be: every single line needs to be written
by hand (is this the "worst case"? or is it the other way around)."

[I think these "statistics" only work, if the project is already "done",
or at least at the "almost nearly done" milestone.]

Regards,

Christian
