Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:40717 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758218AbZHQXdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 19:33:21 -0400
Received: by ewy10 with SMTP id 10so3395889ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 16:33:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/7] rt2x00: Set SKBDESC_L2_PADDED in RX path
Date: Tue, 18 Aug 2009 01:33:19 +0200
Cc: Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908171853.24256.IvDoorn@gmail.com> <200908171854.50790.IvDoorn@gmail.com> <4A89C19E.6080906@free.fr>
In-Reply-To: <4A89C19E.6080906@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908180133.19541.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 17 August 2009, Benoit PAPILLAULT wrote:
> Ivo van Doorn a écrit :
> > When the RX descriptor indicates the frame was L2 padded,
> > the SKBDESC_L2_PADDED flag should be set to make sure the
> > L2 padding is removed before it is send to mac80211.
> >
> > Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
> > ---
> >  drivers/net/wireless/rt2x00/rt2800usb.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c
> b/drivers/net/wireless/rt2x00/rt2800usb.c
> > index c82474e..6de2eda 100644
> > --- a/drivers/net/wireless/rt2x00/rt2800usb.c
> > +++ b/drivers/net/wireless/rt2x00/rt2800usb.c
> > @@ -2163,8 +2163,10 @@ static void rt2800usb_fill_rxdone(struct
> queue_entry *entry,
> >      if (rt2x00_get_field32(rxd0, RXD_W0_MY_BSS))
> >          rxdesc->dev_flags |= RXDONE_MY_BSS;
> >
> > -    if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD))
> > +    if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD)) {
> >          rxdesc->dev_flags |= RXDONE_L2PAD;
> > +        skbdesc->flags |= SKBDESC_L2_PADDED;
> > +    }
> >
> >      if (rt2x00_get_field32(rxwi1, RXWI_W1_SHORT_GI))
> >          rxdesc->flags |= RX_FLAG_SHORT_GI;
> I have tested this patch as well and it looks correct. However, during
> my test, the hardware does not set L2PAD flag, even if padding is
> present (for some frames). I did the same test with the rt2870sta
> driver from Ralink and the L2PAD was indeed set.

But when the flag is set, it is being set correctly?
Perhaps we can just set the flag at all times, because rt2x00lib
checks how much padding is required anyway. Unless of course
the device doesn't always add L2 padding when it actually should have.

> Ivo : what happens during your tests?

Tests?

I don't really have time to perform any testing, so all patches are
only checked by me for 'code correctness'.
