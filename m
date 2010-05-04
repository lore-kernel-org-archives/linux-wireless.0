Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48820 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742Ab0EDSpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:45:11 -0400
Date: Tue, 4 May 2010 14:36:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: fix another source of corrupt frames
Message-ID: <20100504183613.GC21043@tuxdriver.com>
References: <4BDFD3C1.4000209@openwrt.org>
 <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <u2q43e72e891005041109i5106ba24ma7345c4f4c4fde21@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 04, 2010 at 11:09:32AM -0700, Luis R. Rodriguez wrote:
> On Tue, May 4, 2010 at 12:58 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> > Atheros hardware supports receiving frames that span multiple
> > descriptors and buffers. In this case, the rx status of every
> > descriptor except for the last one is invalid and may contain random
> > data. Because the driver does not support this, it needs to drop such
> > frames.
> >
> > Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> > ---
> > --- a/drivers/net/wireless/ath/ath9k/common.c
> > +++ b/drivers/net/wireless/ath/ath9k/common.c
> > @@ -57,13 +57,19 @@ static bool ath9k_rx_accept(struct ath_c
> >         * rs_more indicates chained descriptors which can be used
> >         * to link buffers together for a sort of scatter-gather
> >         * operation.
> > -        *
> > +        * reject the frame, we don't support scatter-gather yet and
> > +        * the frame is probably corrupt anyway
> > +        */
> > +       if (rx_stats->rs_more)
> > +               return false;
> 
> Actually this is required by ath9k_htc, it does process these, but
> ath9k doesn't so this could be done within ath9k itself.

I'm sorry, that is a bit unclear to me.  Are you NAKing the patch?
Or saying that the patch is fine but another patch is needed on top?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
