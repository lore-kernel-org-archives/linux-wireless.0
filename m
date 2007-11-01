Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:58658 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759317AbXKASo3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 14:44:29 -0400
Received: by py-out-1112.google.com with SMTP id u77so1095590pyb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 11:44:27 -0700 (PDT)
Message-ID: <43e72e890711011144s34b34c4dtb2831ec32ea6cc12@mail.gmail.com> (sfid-20071101_184439_495187_6693C985)
Date: Thu, 1 Nov 2007 14:44:26 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 2/7] ath5k: Remove opaque pointers from ath5k_hw_attach()
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>,
	"Nick Kossifidis" <mickflemm@gmail.com>,
	"Michael Taylor" <mike.taylor@apprion.com>
In-Reply-To: <20071101172746.GA7033@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20071101043520.GC21987@pogo> <20071101172746.GA7033@infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/1/07, Christoph Hellwig <hch@infradead.org> wrote:
> >  struct ath5k_hw {
> >       u32                     ah_magic;
> >
> > -     void                    *ah_sc;
> > -     void __iomem            *ah_sh;
> > +     struct ath5k_softc      *ah_sc;
> > +     void __iomem            *ah_iobase;
> >
> >       enum ath5k_int          ah_imr;
>
> Why do you need separate ath5k_hw and ath5k_softc structures anyway?

CC'ing Michael Taylor.

I hope we don't need both. This will take a bit to remove though.
Because of the old HAL, things that were MadWIfi driver related could
be written to ath5k_softc and the HAL itself was in charge of only
using ath5k_hw (their respective counterparts in MadWifi).

The only thing that might be useful here is perhaps for locking access
to HW parts, so it is nice to have those parts separate. Recently
there was some effort put into MadWifi by Michael Taylor to ensure A
LOT of HAL access routines were spinlocked before being run. You can
see this in if_ath_hal.h. Essentially a macro which does the
spin_lock_irqsave() was being run before many HAL access routines...
whether we need such extensive locking merits some review. Perhaps
this is where some of our current problems lies in.

  Luis
