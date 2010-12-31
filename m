Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:37183 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0LaIAV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Dec 2010 03:00:21 -0500
Subject: Re: wl1271: how to use without runtime pm
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Sergey Matyukevich <geomatsi@gmail.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20101231010847.79a55fda@lair>
References: <20101230000737.74d30852@lair>
	 <AANLkTim55FJ_cBE1M7HmhVagfphntZZBLSs9NjTmK_F+@mail.gmail.com>
	 <20101231010847.79a55fda@lair>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 31 Dec 2010 10:00:16 +0200
Message-ID: <1293782416.15791.10.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-12-31 at 01:08 +0300, ext Sergey Matyukevich wrote:
> On Wed, 29 Dec 2010 23:22:05 +0200
> Ohad Ben-Cohen <ohad@wizery.com> wrote:
> 
> > On Wed, Dec 29, 2010 at 11:07 PM, Sergey Matyukevich
> > <geomatsi@gmail.com> wrote:
> > > So the question is: what is the proper use of wl1271 driver in the
> > > case when  wl1271 card is powered all the time ?
> > 
> > The wl1271 driver assumes it can control the power of the card.
> > 
> > If your card's power is always on, you will not be able to toggle the
> > interface down and up (as you have experienced).
> > 
> > It might be possible to change the driver around this "limitation",
> > but I'm not sure anyone has ever really tried.
> 
> A simple solution which comes to mind would be to perform some kind of
> 'complete soft reset procedure' for wl1271 card in the beginning of the
> function 'wl1271_op_add_interface'. But I guess such a feature is not
> available for this card. Qtherwise it would be already implemented by
> Luciano and his colleagues.

I don't know about any reset functionality in the wl1271.  Maybe the
hardware recovery mechanism could be used, but I'm not sure.

In any case, the reason why we power the card on only when the interface
is brought up is because of power consumption.  If the interface is
down, there's no reason to keep the chip powered on and consume
unnecessary power.

If the case of cards that really cannot power off the wl1271 chip is
really unavoidable, we could think about a solution to solve the
problem.

PS: Note that this is the last day when this email address
(luciano.coelho@nokia.com) is valid, so please keep the linux-wireless
mailing list in CC so I can still read the messages. ;)


-- 
Cheers,
Luca.

