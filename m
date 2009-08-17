Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32808 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZHQUAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:00:15 -0400
Date: Mon, 17 Aug 2009 15:56:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: LP-PHY: Fix reading old mode in the set TX power
	control routine
Message-ID: <20090817195607.GJ5500@tuxdriver.com>
References: <4A85AD1B.1060008@gmail.com> <69e28c910908171233l75b4f72cq8981fb048ad8ffbb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910908171233l75b4f72cq8981fb048ad8ffbb@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 09:33:06PM +0200, Gábor Stefanik wrote:
> 2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
> > Check the mode the hardware is in, not the mode we used the last time.
> >
> > Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> > ---
> > Mark, please test if this fixes the TX power control WARN_ON you were
> > seeing.
> >
> > drivers/net/wireless/b43/phy_lp.c |    4 ++--
> > 1 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/wireless/b43/phy_lp.c
> > b/drivers/net/wireless/b43/phy_lp.c
> > index 292ee51..76457f7 100644
> > --- a/drivers/net/wireless/b43/phy_lp.c
> > +++ b/drivers/net/wireless/b43/phy_lp.c
> > @@ -1015,9 +1015,9 @@ static void lpphy_set_tx_power_control(struct
> > b43_wldev *dev,
> >        struct b43_phy_lp *lpphy = dev->phy.lp;
> >        enum b43_lpphy_txpctl_mode oldmode;
> >
> > -       oldmode = lpphy->txpctl_mode;
> >        lpphy_read_tx_pctl_mode_from_hardware(dev);
> > -       if (lpphy->txpctl_mode == mode)
> > +       oldmode = lpphy->txpctl_mode;
> > +       if (oldmode == mode)
> >                return;
> >        lpphy->txpctl_mode = mode;
> >
> > --
> > 1.6.2.4
> >
> 
> John, any news on this one? I can't see it in wireless testing.

Larry said "It does not fix it here. I'll take a look at the specs"...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
