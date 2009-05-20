Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:37522 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbZETWaD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 18:30:03 -0400
Subject: Re: libertas: fix GSPI card event handling
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <45e8e6c40905201528v7d6c2cddld21c4cf4906f3a60@mail.gmail.com>
References: <4a134cbd.1ebc720a.4cee.ffffc1c3@mx.google.com>
	 <1242857890.7048.22.camel@localhost.localdomain>
	 <45e8e6c40905201528v7d6c2cddld21c4cf4906f3a60@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 20 May 2009 18:29:56 -0400
Message-Id: <1242858596.7048.28.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-05-20 at 15:28 -0700, Andrey Yurovsky wrote:
> On Wed, May 20, 2009 at 3:18 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Tue, 2009-05-19 at 17:20 -0700, andrey@cozybit.com wrote:
> >> The GPSI interface driver does not re-enable the Card Event Interrupt, which
> >> causes problems after a card event (for example: link-loss) comes in.  This
> >> can lead, for example, to the card failing to re-associate.  This patch
> >> ensures that we re-enable the Card Event Interrupt when we handle card events.
> >>
> >> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> >
> > Where does that bit ever get disabled?  Is that done by the firmware
> > after it sends the interrupt?  I don't think I quite understand what's
> > going on here...
> 
> That's correct.  The firmware and host communicate by setting or
> clearing bits and forcing an interrupt.  The event mechanism is,
> basically:
> 1) firmware sets that bit and triggers an IRQ
> 2) host handles the IRQ (noticing that it's an Event and reading the
> Event Cause)
> 3) host clears the bit
> 4) host triggers an interrupt (on the card) so that the card notices
> the change (ie: that the bit was cleared)

Ah, step 4 was what I wasn't yet thinking of.  Sounds fine.

Acked-by: Dan Williams <dcbw@redhat.com>

> Steps 3 an 4 were missing in if_spi.c, which caused problems if, for
> example, you associate to an AP and then cut the AP's power.  In this
> case the card will never re-associate subsequently because the Card
> Event bit never gets cleared.
> 
> >> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
> >> index dccd01f..5fa55fe 100644
> >> --- a/drivers/net/wireless/libertas/if_spi.c
> >> +++ b/drivers/net/wireless/libertas/if_spi.c
> >> @@ -814,6 +814,13 @@ static void if_spi_e2h(struct if_spi_card *card)
> >>       if (err)
> >>               goto out;
> >>
> >> +     /* re-enable the card event interrupt */
> >> +     spu_write_u16(card, IF_SPI_HOST_INT_STATUS_REG,
> >> +                     ~IF_SPI_HICU_CARD_EVENT);
> >> +
> >> +     /* generate a card interrupt */
> >> +     spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG, IF_SPI_CIC_HOST_EVENT);
> >> +
> >>       spin_lock_irqsave(&priv->driver_lock, flags);
> >>       lbs_queue_event(priv, cause & 0xff);
> >>       spin_unlock_irqrestore(&priv->driver_lock, flags);
> >>
> >>
> >
> >
> 
> 
> 

