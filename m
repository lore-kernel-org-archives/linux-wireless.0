Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49388 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755245Ab0EDTpq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 15:45:46 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 12:45:46 -0700
Date: Tue, 4 May 2010 12:45:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
Message-ID: <20100504194544.GE2624@tux>
References: <4BDFD3C1.4000209@openwrt.org>
 <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
 <20100504183613.GC21043@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <20100504183613.GC21043@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 04, 2010 at 11:36:13AM -0700, John W. Linville wrote:
> On Tue, May 04, 2010 at 11:09:32AM -0700, Luis R. Rodriguez wrote:
> > On Tue, May 4, 2010 at 12:58 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > > Atheros hardware supports receiving frames that span multiple
> > > descriptors and buffers. In this case, the rx status of every
> > > descriptor except for the last one is invalid and may contain random
> > > data. Because the driver does not support this, it needs to drop such
> > > frames.
> > >
> > > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > > ---
> > > --- a/drivers/net/wireless/ath/ath9k/common.c
> > > +++ b/drivers/net/wireless/ath/ath9k/common.c
> > > @@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
> > >         * rs_more indicates chained descriptors which can be used
> > >         * to link buffers together for a sort of scatter-gather
> > >         * operation.
> > > -        *
> > > +        * reject the frame, we don't support scatter-gather yet and
> > > +        * the frame is probably corrupt anyway
> > > +        */
> > > +       if (rx_stats->rs_more)
> > > +               return false;
> > 
> > Actually this is required by ath9k_htc, it does process these, but
> > ath9k doesn't so this could be done within ath9k itself.
> 
> I'm sorry, that is a bit unclear to me.  Are you NAKing the patch?

Yes, I am NAK'ing it, I should have been clearer about that, sorry.
The reason is that ath9k_htc *depends* on rs_more stuff because the
USB frames it receives *are* split up and to RX them we decouple
them. With this patch you'd break ath9k_htc considerably.

> Or saying that the patch is fine but another patch is needed on top?

My suggestion is that this change can be made but only on the
ath9k RX path, instead of the comon path so a separate patch would
be needed.

  Luis
