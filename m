Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:40569
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbXHFV6O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 17:58:14 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC] bcm43xx-mac80211: Hack to turn automatic pctl off
Date: Mon, 6 Aug 2007 23:56:58 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <46b792a0.FdNEyH1qMrUgo6oh%Larry.Finger@lwfinger.net> <200708062335.48546.mb@bu3sch.de>
In-Reply-To: <200708062335.48546.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200708062356.58782.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 06 August 2007 23:35:48 Michael Buesch wrote:
> On Monday 06 August 2007 23:29:04 Larry Finger wrote:
> > Michael,
> > 
> > I sent the wrong message under this subject before.
> > 
> > This hack disabled hardware power control. With this installed and the
> > desired power set to 10 dBm using the previous patch, I get much, much
> > better performance from bcm43xx-mac80211 on my BCM4311. I have not yet
> > tested it on the BCM4306 or the BCM4318.
> > 
> > The new iperf readings for transmit/receive with the computer about 2 m
> > from the AP are as follows:
> > 
> > Bit Rate	xmit/receive (Mbs)
> > 
> > 1M		1.11/8.70
> > 2M		1.44/11.0
> > 5.5M		4.15/13.3
> > 6M		4.76/17.4
> > 9M		6.55/18.2
> > 11M		6.54/14.3
> > 18M		10.7/18.5
> > 24M		12.8/19.5
> > 36M		16.1/19.7
> > 48M		18.0/19.5
> > 54M		18.6/19.0
> > 
> > These numbers are comparable with what I'm getting with the PHY port from
> > softmac. I don't understand the dip in received rate at 11M, but it is real.
> > On Richard Jonsson's 4311, he isn't able to measure the transfer rate at
> > 11M.
> > 
> > With these settings, the rate adjustment proces bumps the rate to 54M
> > automatically.
> > 
> > Larry
> > 
> > 
> > 
> > Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> > ===================================================================
> > --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> > +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
> > @@ -471,6 +471,7 @@ void bcm43xx_phy_early_init(struct bcm43
> >  	struct bcm43xx_phy *phy = &dev->phy;
> >  	struct bcm43xx_txpower_lo_control *lo = phy->lo_control;
> >  
> > +	phy->hw_pctl_off = 1;
> >  	default_baseband_attenuation(dev, &phy->bbatt);
> >  	default_radio_attenuation(dev, &phy->rfatt);
> >  	phy->tx_control = (default_tx_control(dev) << 4);
> > Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
> > ===================================================================
> > --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
> > +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.h
> > @@ -219,8 +219,9 @@ void bcm43xx_gphy_dc_lt_init(struct bcm4
> >  
> >  /* Returns the boolean whether the board has HardwarePowerControl */
> >  #define has_hardware_pctl(phy) \
> > +	(!((phy)->hw_pctl_off) &&				\
> >  	(((phy)->type == BCM43xx_PHYTYPE_A && (phy)->rev >= 5) ||	\
> > -	 ((phy)->type == BCM43xx_PHYTYPE_G && (phy)->rev >= 6))
> > +	 ((phy)->type == BCM43xx_PHYTYPE_G && (phy)->rev >= 6)))
> >  /* Returns the boolean whether "TX Magnification" is enabled. */
> >  #define has_tx_magnification(phy) \
> >  	(((phy)->rev >= 2) &&			\
> > Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> > ===================================================================
> > --- wireless-dev.orig/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> > +++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx.h
> > @@ -534,6 +534,7 @@ struct bcm43xx_phy {
> >  	struct bcm43xx_bbatt bbatt;
> >  	struct bcm43xx_rfatt rfatt;
> >  	u8 tx_control; /* BCM43xx_TXCTL_XXX */
> > +	bool hw_pctl_off;
> >  #ifdef CONFIG_BCM43XX_MAC80211_DEBUG
> >  	bool manual_txpower_control; /* Manual TX-power control enabled? */
> >  #endif
> > 
> > ---
> > _______________________________________________
> > Bcm43xx-dev mailing list
> > Bcm43xx-dev@lists.berlios.de
> > https://lists.berlios.de/mailman/listinfo/bcm43xx-dev
> > 
> > 
> 
> I am currently doing a patch for this.
> 

That's it
http://bu3sch.de/patches/wireless-dev/20070806-1186437386/patches/bcm43xx-mac80211-hwpctl-optional.patch

-- 
Greetings Michael.
