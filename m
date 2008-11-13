Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53368 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYKMPkR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 10:40:17 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "Hin-Tak Leung" <hintak_leung@yahoo.co.uk>
Subject: Re: throughput problem/bisect with rtl8187B
Date: Thu, 13 Nov 2008 13:40:31 -0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <872129.29728.qm@web23105.mail.ird.yahoo.com>
In-Reply-To: <872129.29728.qm@web23105.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200811131340.32000.herton@mandriva.com.br> (sfid-20081113_164020_854881_519B7A9F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 12 November 2008 22:06:16 Hin-Tak Leung wrote:
> --- On Wed, 12/11/08, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> > Herton Ronaldo Krzesinski wrote:
> > > Ok, Looks like sifs or eifs setting then expect values
> > in another format or
> > > have a different meaning may be (or just cause some hw
> > bug), it's strange,
> > > I suspect sifs value is the culprit. In the patch I
> > just reverted to values vendor
> > > driver uses, in it difs remains the same, just eifs
> > isn't changed for short slot
> > > case and kept with a default value (along with what is
> > supposed to be ack
> > > timeout register), and sifs set to 0x22. Please try
> > just the following change
> > > to isolate that the SIFS setting caused the throughput
> > issue:
> > > 
> > > diff --git
> > a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > > index d49f2a7..c0392e4 100644
> > > --- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > > +++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
> > > @@ -924,7 +924,7 @@ static void
> > rtl8187_conf_erp(struct rtl8187_priv *priv, bool
> > use_short_slot,
> > >  			difs = 0x32;
> > >  			eifs = 0x5b;
> > >  		}
> > > -		rtl818x_iowrite8(priv, &priv->map->SIFS,
> > 0xa);
> > > +		rtl818x_iowrite8(priv, &priv->map->SIFS,
> > 0x22);
> > >  		rtl818x_iowrite8(priv, &priv->map->SLOT,
> > slot_time);
> > >  		rtl818x_iowrite8(priv, &priv->map->DIFS,
> > difs);
> > 
> > This patch gives me the best performance yet. I get about
> > 1.0 MB/s download and
> > 580 KB/s upload with a 25 MB file using sftp.
> 
> Yes, confirming this one number fixes the throughput problem I had. And I can also confirm that wireless-testing + this oneliner seems to be better than 2.6.27. 
> 
> I tried it alone on top of wireless-testing, and together with 
> the conf_tx and feedback patches.
> 
> Thanks for putting time into this!

nice, I sent the patch now plus the others pending I had.

> 
> Hin-Tak

-- 
[]'s
Herton
