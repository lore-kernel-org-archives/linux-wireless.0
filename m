Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:46309 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434Ab0AYSxY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:53:24 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/4] b43: make cordic common (LP-PHY and N-PHY need it)
Date: Mon, 25 Jan 2010 19:53:19 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com> <b170af451001251035t23f3978cga52258722ea29770@mail.gmail.com> <b170af451001251036m8b33f3er9f0a363a03ea21cb@mail.gmail.com>
In-Reply-To: <b170af451001251036m8b33f3er9f0a363a03ea21cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001251953.21692.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 January 2010 19:36:27 Rafał Miłecki wrote:
> W dniu 25 stycznia 2010 19:35 użytkownik Rafał Miłecki
> <zajec5@gmail.com> napisał:
> > 2010/1/25 Michael Buesch <mb@bu3sch.de>:
> >> On Monday 25 January 2010 18:59:59 Rafał Miłecki wrote:
> >>> +/* Complex number using 2 32-bit signed integers */
> >>> +typedef struct { s32 i, q; } b43_c32;
> >>
> >> No typedef. ever.
> >
> > Well, I just copied (Gabor's?) code here. But of course I can fix this
> > by the way, no problem :)

Yeah, I saw that. We can fix it while we're at it. ;)

> > Just read about typedef in Linux Kernel Coding Style, didn't know
> > about this earlier. Thanks for pointing.
> 
> Is this OK to fix this in separated patch? Or should I modify this set
> of patches?

Well, as you touch any reference to the typedef anyway (you renamed it),
you can just put the keyword "struct" in front of the references and no separate patch is needed.
It won't even grow your current patch in the number of changed lines.

-- 
Greetings, Michael.
