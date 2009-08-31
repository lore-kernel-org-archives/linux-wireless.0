Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41202 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbZHaTR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2009 15:17:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2] b43: LP-PHY: Begin implementing calibration & software RFKILL support
Date: Mon, 31 Aug 2009 21:17:25 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A99C4BB.7080806@gmail.com> <200908301755.40557.mb@bu3sch.de> <20090831175331.GB5631@tuxdriver.com>
In-Reply-To: <20090831175331.GB5631@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908312117.26915.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 31 August 2009 19:53:31 John W. Linville wrote:
> On Sun, Aug 30, 2009 at 05:55:40PM +0200, Michael Buesch wrote:
> > On Sunday 30 August 2009 17:10:23 Larry Finger wrote:
> > > Michael Buesch wrote:
> > > > On Sunday 30 August 2009 02:15:55 Gábor Stefanik wrote:
> > > >>  static void lpphy_pr41573_workaround(struct b43_wldev *dev)
> > > >>  {
> > > >>  	struct b43_phy_lp *lpphy = dev->phy.lp;
> > > >> @@ -1357,28 +1488,440 @@ static void lpphy_pr41573_workaround(struct b43_wldev *dev)
> > > >>  		b43_lptab_read_bulk(dev, B43_LPTAB32(7, 0x140),
> > > >>  				    saved_tab_size, saved_tab);
> > > >>  	}
> > > >> +	b43_put_phy_into_reset(dev);
> > > > 
> > > > Are you sure you really want this?
> > > > This function completely disables the PHY on the backplane and keeps the physical
> > > > PHY reset pin asserted (even after return from the function).
> > > > So the PHY will physically be powered down from this point on. The following
> > > > PHY accesses could even hang the machine, because the PHY won't respond to
> > > > register accesses anymore.
> > > > 
> > > > We currently only use this function on A/G Multi-PHY devices to permanently
> > > > hard-disable the PHY that's not used.
> > > 
> > > The PHY reset routine in
> > > http://bcm-v4.sipsolutions.net/802.11/PHY/Reset, which I just updated
> > > for the latest N PHY changes, appears to be a different routine than
> > > b43_put_phy_into_reset(). The names are confusing.
> > 
> > b43_put_phy_into_reset() is opencoded in the specifications in various init
> > routines. There's no separate specs page for that function.
> > But I think the code is straightforward and easy to understand.
> 
> So is this patch right or not?  Should I hold onto it for 2.6.33
> (i.e. after the 2.6.32 merge window)?

I'm pretty sure it's incorrect.

-- 
Greetings, Michael.
