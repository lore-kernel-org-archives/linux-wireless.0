Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32810 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZHQUAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 16:00:15 -0400
Date: Mon, 17 Aug 2009 15:57:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: LP-PHY: Fix setting TX power control mode during
	RC calibration
Message-ID: <20090817195718.GK5500@tuxdriver.com>
References: <4A85B8DE.3000704@gmail.com> <69e28c910908171232i6828d42bh3aac1d236f789c91@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910908171232i6828d42bh3aac1d236f789c91@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 09:32:42PM +0200, Gábor Stefanik wrote:
> 2009/8/14 Gábor Stefanik <netrolller.3d@gmail.com>:
> > Call set_tx_power_control with a LPPHY_TXPCTL rather than an
> > LPPHY_TX_PWR_CTL_CMD_MODE.
> >
> > Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> > ---
> > This should fix the WARN_ON testers were seeing during init.
> >
> > drivers/net/wireless/b43/phy_lp.c |    2 +-
> > 1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/net/wireless/b43/phy_lp.c
> > b/drivers/net/wireless/b43/phy_lp.c
> > index adfa7bf..558224b 100644
> > --- a/drivers/net/wireless/b43/phy_lp.c
> > +++ b/drivers/net/wireless/b43/phy_lp.c
> > @@ -1080,7 +1080,7 @@ static void lpphy_rev0_1_rc_calib(struct b43_wldev
> > *dev)
> >        old_txpctl = b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_CMD) &
> >                                        B43_LPPHY_TX_PWR_CTL_CMD_MODE;
> >
> > -       lpphy_set_tx_power_control(dev, B43_LPPHY_TX_PWR_CTL_CMD_MODE_OFF);
> > +       lpphy_set_tx_power_control(dev, B43_LPPHY_TXPCTL_OFF);
> >        lpphy_disable_crs(dev);
> >        loopback = lpphy_loopback(dev);
> >        if (loopback == -1)
> > --
> > 1.6.2.4
> >
> 
> John, any news on this one? I can't see it in wireless testing.

Larry said:

With this one, I still get WARNING: at
drivers/net/wireless/b43/phy_lp.c:1006
lpphy_set_tx_power_control+0xbf/0xdd [b43]().

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
