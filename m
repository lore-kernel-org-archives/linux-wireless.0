Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:57430 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754127Ab0KSQlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 11:41:18 -0500
Subject: Re: [PATCH V2] b43: rfkill: use HI enabled bit for all devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
In-Reply-To: <AANLkTikXqg9boY1H_OPAvs7WPd6SXUt8DpykRHuRxB6E@mail.gmail.com> (sfid-20101119_111452_623076_AFFB9E4D)
References: <1290028477-6462-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikXqg9boY1H_OPAvs7WPd6SXUt8DpykRHuRxB6E@mail.gmail.com>
	 (sfid-20101119_111452_623076_AFFB9E4D)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Nov 2010 17:41:13 +0100
Message-ID: <1290184873.23033.3.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 17:12 +0100, Gábor Stefanik wrote: 
> 2010/11/17 Rafał Miłecki <zajec5@gmail.com>:
> > Devices which use LO enabled bit are covered by b43legacy
> >
> > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> > ---
> > V2: Dropped some not needed stuff as pointed by Michael, thanks!
> >
> > John: it's .38 ofc.
> > ---
> >  drivers/net/wireless/b43/rfkill.c |   19 ++-----------------
> >  1 files changed, 2 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> > index 78016ae..86bc0a0 100644
> > --- a/drivers/net/wireless/b43/rfkill.c
> > +++ b/drivers/net/wireless/b43/rfkill.c
> > @@ -28,23 +28,8 @@
> >  /* Returns TRUE, if the radio is enabled in hardware. */
> >  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
> >  {
> > -       if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
> > -               if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
> > -                     & B43_MMIO_RADIO_HWENABLED_HI_MASK))
> > -                       return 1;
> > -       } else {
> > -               /* To prevent CPU fault on PPC, do not read a register
> > -                * unless the interface is started; however, on resume
> > -                * for hibernation, this routine is entered early. When
> > -                * that happens, unconditionally return TRUE.
> > -                */
> > -               if (b43_status(dev) < B43_STAT_STARTED)
> > -                       return 1;
> > -               if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
> > -                   & B43_MMIO_RADIO_HWENABLED_LO_MASK)
> > -                       return 1;
> > -       }
> > -       return 0;
> 
> Is there any reason why this bool originally returned 1 or 0 instead
> of true or false?

There's no difference.
(int)0 implicitly casts to false and anything else to true.

-- 
Greetings Michael.

