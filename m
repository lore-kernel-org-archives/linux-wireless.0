Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:39299 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbYGJX60 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 19:58:26 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: [RFC] Try to improve RTL8187B initialization time
Date: Thu, 10 Jul 2008 20:58:31 -0300
Cc: linux-wireless@vger.kernel.org,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	Larry Finger <Larry.Finger@lwfinger.net>, proski@gnu.org
References: <200807101851.31985.herton@mandriva.com.br> <48769266.4090407@yahoo.co.uk>
In-Reply-To: <48769266.4090407@yahoo.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807102058.32220.herton@mandriva.com.br> (sfid-20080711_015830_250284_2E666B0C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Thursday 10 July 2008 19:51:18 Hin-Tak Leung escreveu:
> Herton Ronaldo Krzesinski wrote:
> > As reported before, we know that the initialization of rtl8187b interfaces is
> > slow. There were some strange sleeps from vendor driver that were imported too
> > just to be sure, but they don't seem to be needed. After looking at r8180 code,
> > I think they really aren't needed, and using it as reference, I did a similar
> > initialization now for rtl8187b, on quick tests seems to work well.
> 
> Most of the change is minor - mainly 6 secs is removed in 3 big chunks, but
> a fraction of a sec here and there is added back elsewhere, so the net effect
> is probably 4-5 sec, or less, since you also added some new code.
> How about just removing the 3 chunks as below?
> 
> I am wondering also if some of the delays is simply that some of the init
> numbers is wrong and the firmware gets thrown into some mini-recovery over-ride
> routine.

I think it's something needed for hardware/RF chip to "settle down" or have
time to save the rf parameter after the given command. Removing the msleeps is
another option, testing here it worked (in fact I think it lowered the net
traffic quality a bit but nothing much noticeable, could be some noise), but
this could hide something or introduce random bug due to timing issue (like
lower tx/rx quality or interface not working sometimes). Doing something
similar like RTL8180/R8185 was the idea to avoid some problem basing on a known
to work code for the same radio chip (although risking to have something
specific to 8185/8180 brought in...).

> 
> I also have another "theory" - the windows driver is sensitive to the hardware 
> switch and the linux driver not, so obviously the effect of the hardware switch
> can be overrided in software. To give the *appearance* of fast initialization,
> maybe the windows driver simply initialize everything on load (i.e. when windows 
> starts), then switch the radio on and off when the user asks to shut off the
> interface, etc. I have never got ndiswrapper to work on x86_64 (ifconfig up
> stuck) - how does timing of ifconfig up/down with ndiswrapper compare?

I didn't written down the full time, but it's much faster, ie. not this huge
delay compared to the linux driver.

> 
> BTW, ndiswrapper won't even build with 2.6.26-rc9.

On a 2.6.26-rc9 builds ok here (i386), I don't remember to have any extra patch
needed.

> 
> > diff --git a/drivers/net/wireless/rtl8187_dev.c b/drivers/net/wireless/rtl8187_dev.c
> > index f981fdb..25d9a0e 100644
> > --- a/drivers/net/wireless/rtl8187_dev.c
> > +++ b/drivers/net/wireless/rtl8187_dev.c
> 
> > @@ -643,14 +641,13 @@ static int rtl8187b_init_hw(struct ieee80211_hw *dev)
> 
> > -	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
> > -	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
> > -	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
> > -	msleep(1100);
> > -
> 
> 1st one.
> 
> > diff --git a/drivers/net/wireless/rtl8187_rtl8225.c b/drivers/net/wireless/rtl8187_rtl8225.c
> > index 1bae899..9549e33 100644
> > --- a/drivers/net/wireless/rtl8187_rtl8225.c
> > +++ b/drivers/net/wireless/rtl8187_rtl8225.c
> 
> > @@ -850,25 +859,36 @@ static void rtl8225z2_b_rf_init(struct ieee80211_hw *dev)
> 
> > -	rtl8225_write(dev, 0x3, 0x080); msleep(1);
> > -	rtl8225_write(dev, 0x5, 0x004); msleep(1);
> > -	rtl8225_write(dev, 0x0, 0x0B7); msleep(1);
> > -	msleep(3000);
> 
> 2nd
> 
> 
> > +	rtl8225_write(dev, 0x0, 0x0B7);
> > +	msleep(100);
> > +	rtl8225_write(dev, 0x2, 0xC4D);
> > +	msleep(200);
> > +	rtl8225_write(dev, 0x2, 0x44D);
> > +	msleep(100);
> >  
> > -	rtl8225_write(dev, 0x2, 0xC4D); msleep(1);
> > -	msleep(2000);
> 
> 3rd, but some are added as above.
> 
> 

-- 
[]'s
Herton
