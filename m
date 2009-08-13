Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52084 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845AbZHMSFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 14:05:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC/RFT] b43: LP-PHY: Implement channel switching for  rev2+/B2063 radio
Date: Thu, 13 Aug 2009 20:05:37 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A842AFD.1020903@gmail.com> <200908131955.32283.mb@bu3sch.de> <69e28c910908131100h7d403196y3f8be4809fc61d0f@mail.gmail.com>
In-Reply-To: <69e28c910908131100h7d403196y3f8be4809fc61d0f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908132005.37769.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 13 August 2009 20:00:47 Gábor Stefanik wrote:
> (List re-CC-ed.)
> 
> 2009/8/13 Michael Buesch <mb@bu3sch.de>:
> > On Thursday 13 August 2009 19:50:16 Gábor Stefanik wrote:
> >> 2009/8/13 Michael Buesch <mb@bu3sch.de>:
> >> > On Thursday 13 August 2009 17:02:21 Gábor Stefanik wrote:
> >> >> Rev.2+/B2063 will now hopefully show some signs of life, though
> >> >> it won't work at full performance, as calibration is still missing.
> >> >>
> >> >> Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
> >> >
> >> >>  static void lpphy_baseband_rev0_1_init(struct b43_wldev *dev)
> >> >> @@ -1369,7 +1370,7 @@ static int b43_lpphy_op_init(struct b43_wldev *dev)
> >> >>       lpphy_baseband_init(dev);
> >> >>       lpphy_radio_init(dev);
> >> >>       lpphy_calibrate_rc(dev);
> >> >> -     //TODO set channel
> >> >> +     b43_switch_channel(dev, dev->wl->hw->conf.channel->hw_value);
> >> >
> >> > Does dev->wl->hw->conf.channel->hw_value already have a sane value here?
> >>
> >> I think it should - hw->conf.channel was handed to us by mac80211.
> >> http://bcm-v4.sipsolutions.net/802.11/PHY/LP/Init says "Set channel
> >> with current chanspec as argument", and hw->conf.channel is our
> >> equivalent of chanspec.
> >
> > hw->conf.channel was not handed to us at all. You simply pick it
> > from mac80211's conf structure and _assume_ that it is initialized.
> > In the other PHY implementations we use phyop_default_channel (or mandatory
> > hardcoded channel values) in the PHY init only. I think you should do the
> > same here. Mac80211 will make sure to select the correct channel later.
> 
> OK, I will use the default channel (though that's not exactly what the
> spec says - Larry, is using the default channel correct?)

What on earth could be incorrect about it? It's an as arbitrary value as
dev->wl->hw->conf.channel->hw_value would be.

> 
> >
> >> > Also please call b43_lpphy_op_switch_channel() instead of b43_switch_channel().
> >>
> >> No, that would be wrong; the generic parts of b43_switch_channel also
> >> need to be executed. See
> >
> > I don't see why. The generic parts are nothing that should be done at the PHY init.
> 
> Well, the spec says that the generic parts need to be run, so I
> implemented it as such.

We do understand what the generic stuff does and it is not required at this point.

> Larry, is this part of the spec correct?

I'm pretty sure it is. But that does not mean we have to implement the same
bullshit broadcom does ;)

-- 
Greetings, Michael.
