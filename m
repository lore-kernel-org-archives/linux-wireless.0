Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37666 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYJDIsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 04:48:21 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 2/8] b43: remove remaining b43_radio_{read|write}16 from main.c
Date: Sat, 4 Oct 2008 10:47:57 +0200
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1223066926.6512.27.camel@brick> <48E6C8A1.1060404@lwfinger.net>
In-Reply-To: <48E6C8A1.1060404@lwfinger.net>
MIME-Version: 1.0
Message-Id: <200810041047.58066.mb@bu3sch.de> (sfid-20081004_104834_461206_D9B48AAC)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 04 October 2008 03:36:33 Larry Finger wrote:
> Harvey Harrison wrote:
> > The 16 is not necessary anymore and is defnined to read/write.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  drivers/net/wireless/b43/main.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
> > index 6df9b65..cc1f4a9 100644
> > --- a/drivers/net/wireless/b43/main.c
> > +++ b/drivers/net/wireless/b43/main.c
> > @@ -789,7 +789,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
> >  	b43_write16(dev, 0x0502, 0x0030);
> >  
> >  	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
> > -		b43_radio_write16(dev, 0x0051, 0x0017);
> > +		b43_radio_write(dev, 0x0051, 0x0017);
> >  	for (i = 0x00; i < max_loop; i++) {
> >  		value = b43_read16(dev, 0x050E);
> >  		if (value & 0x0080)
> > @@ -809,7 +809,7 @@ void b43_dummy_transmission(struct b43_wldev *dev)
> >  		udelay(10);
> >  	}
> >  	if (phy->radio_ver == 0x2050 && phy->radio_rev <= 0x5)
> > -		b43_radio_write16(dev, 0x0051, 0x0037);
> > +		b43_radio_write(dev, 0x0051, 0x0037);
> >  
> >  	write_unlock(&wl->tx_lock);
> >  	spin_unlock_irq(&wl->irq_lock);
> 
> NACK. The two extra characters are absolutely harmless, but they do
> contain useful information. In addition, who knows if a future
> Broadcom device starts using 32-bit read/writes.

Ok, there are valid reasons for it, there are valid reasons against it...

Can we just agree now that we're not going to apply _any_ cleanups to the
PHY code, please? (So I revoke my mail from Sat Oct  4 00:35:35 2008)

Actual bugfixes are welcome, of course.

-- 
Greetings Michael.
