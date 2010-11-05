Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50735 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab0KEHYq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 03:24:46 -0400
Received: by fxm16 with SMTP id 16so2113298fxm.19
        for <linux-wireless@vger.kernel.org>; Fri, 05 Nov 2010 00:24:45 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Subject: Re: [PATCH 05/13] rt2x00: Add unlikely to skb allocation failure check
Date: Fri, 5 Nov 2010 08:23:48 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
References: <201011042037.00178.IvDoorn@gmail.com> <201011042038.35919.IvDoorn@gmail.com> <AANLkTi=1eHFOX5S6H_ZETWoXz_8nm5Xd+hExrRWX7go8@mail.gmail.com>
In-Reply-To: <AANLkTi=1eHFOX5S6H_ZETWoXz_8nm5Xd+hExrRWX7go8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201011050823.48982.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag 04 November 2010 schrieb Christian Lamparter:
> On Thu, Nov 4, 2010 at 7:38 PM, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > From: Helmut Schaa <helmut.schaa@googlemail.com>
> >
> > The skb allocation should really only fail under high memory pressure
> > or other uncommon situations. Hence, mark the allocation failure check
> > as unlikely.
> >
> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2x00dev.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > index 5ba79b9..a5c7a4f 100644
> > --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> > +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> > @@ -491,7 +491,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry)
> >         * received frame and reuse the existing buffer.
> >         */
> >        skb = rt2x00queue_alloc_rxskb(entry);
> > -       if (!skb)
> > +       if (unlikely(!skb))
> >                goto submit_entry;
> >
> >        /*
> > --
> err, wait a sec, I've been looking for this mail for some time, but:
> 
> http://mail.linux.ie/pipermail/ilug/2004-December/075654.html
> 
> "Note tests for NULL (!something) don't need an unlikely as gcc does
>  that by default itself."
> 
> But there's more, according to http://gcc.gnu.org/news/profiledriven.html:
> (static program profile) gcc expect pointers to be non-null
> 
> (therefore all !skb tests should be unlikely branches by default, or?)

Interesting, didn't know that. I've just given it a try and the MIPS assembly
indeed stays the same with and without the unlikely. Nevertheless, I've found
quite a number of unlikely(!x) checks throughout the net stack ...

But still, this seems unnecessary. John, please drop this patch.

Thanks Christian,
Helmut
