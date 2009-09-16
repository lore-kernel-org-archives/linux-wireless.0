Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:57809 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbZIPURv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 16:17:51 -0400
Received: by fg-out-1718.google.com with SMTP id 22so1713302fge.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 13:17:53 -0700 (PDT)
Subject: Re: [PATCH 2/2] b43: Add lpphy_clear_tx_power_offsets to improve
 TX Power handling
From: Thomas Ilnseher <illth@gmx.de>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <69e28c910909161240p7739edebi653b5d402a792856@mail.gmail.com>
References: <1253129879.2989.48.camel@note>
	 <69e28c910909161240p7739edebi653b5d402a792856@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 22:17:55 +0200
Message-Id: <1253132275.2989.75.camel@note>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, den 16.09.2009, 21:40 +0200 schrieb Gábor Stefanik:
> You are essentially implementing dead code at this point - this will
> only ever be called if hardware-accelerated TX power control is
> enabled - and HW TX power control is unsupported, even for G-PHYs.
Then the question remains, why this brings my device to 54 MBit/s ?

I did double check again with the old driver:

wlan0     IEEE 802.11bg  ESSID:"tommy"  
          Mode:Managed  Frequency:2.412 GHz  Access Point:    
          Bit Rate=9 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=5 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Patched driver:

wlan0     IEEE 802.11bg  ESSID:"tommy"  
          Mode:Managed  Frequency:2.412 GHz  Access Point: XXX 
          Bit Rate=54 Mb/s   Tx-Power=20 dBm   
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:off
          Link Quality=70/70  Signal level=10 dBm  
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0



> > Signed-off-by: Thomas Ilnseher <illth@gmx.de>
> >
> > ---
> > diff -uNr a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
> > --- a/drivers/net/wireless/b43/phy_lp.c 2009-09-16 20:52:17.501318374 +0200
> > +++ b/drivers/net/wireless/b43/phy_lp.c 2009-09-16 20:53:36.593319452 +0200
> > @@ -1125,6 +1125,18 @@
> >        dev->phy.lp->tssi_idx = (b43_phy_read(dev, B43_LPPHY_TX_PWR_CTL_STAT) & 0x7F00) >> 8;
> >  }
> >
> > +static void lpphy_clear_tx_power_offsets(struct b43_wldev *dev)
> > +{
> > +       int i;
> > +       int id = 7;
> > +       if (dev->phy.rev < 2)
> > +               id = 10;
> > +       for (i = 0; i < 12; i++)
> > +               b43_lptab_write(dev, B43_LPTAB32(id, 0x40 + i), 0);
> > +       for (i = 0; i < 64; i++)
> > +               b43_lptab_write(dev, B43_LPTAB32(id, 0x80 + i), 0);
> > +}
> > +
> >  static void lpphy_set_tx_power_control(struct b43_wldev *dev,
> >                                       enum b43_lpphy_txpctl_mode mode)
> >  {
> > @@ -1139,7 +1151,7 @@
> >
> >        if (oldmode == B43_LPPHY_TXPCTL_HW) {
> >                lpphy_update_tx_power_npt(dev);
> > -               //TODO Clear all TX Power offsets
> > +               lpphy_clear_tx_power_offsets(dev);
> >        } else {
> >                if (mode == B43_LPPHY_TXPCTL_HW) {
> >                        //TODO Recalculate target TX power
> >
> >
> 
> 
> 

