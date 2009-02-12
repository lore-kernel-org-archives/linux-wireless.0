Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21237 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbZBLEvt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:51:49 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:51:49 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.43521.702609.790269@gargle.gargle.HOWL> (sfid-20090212_055153_022803_7EA2603A)
Date: Thu, 12 Feb 2009 10:18:01 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH 4/8] ath9k: Enable TSF Out of Range Interrupt
In-Reply-To: <43e72e890902112048r2569a008pe1b8a0ea1457cd4d@mail.gmail.com>
References: <18835.42847.358511.204936@gargle.gargle.HOWL>
	<43e72e890902112048r2569a008pe1b8a0ea1457cd4d@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Wed, Feb 11, 2009 at 8:36 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> > This patch lays the groundwork for handling TSF Out of Range
> > interrupt, which will be used for power save later on.
> >
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> 
> > --- a/drivers/net/wireless/ath9k/main.c
> > +++ b/drivers/net/wireless/ath9k/main.c
> > @@ -574,6 +574,10 @@ irqreturn_t ath_isr(int irq, void *dev)
> >                                        sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
> >                                }
> >                        }
> > +                       if (status & ATH9K_INT_TSFOOR) {
> > +                               /* FIXME: Handle this interrupt for power save */
> > +                               sched = true;
> > +                       }
> 
> Since this is not handled yet is there a need to sched then?

Will post patches to handle this.

Sujith
