Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39954 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0A0CPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2010 21:15:34 -0500
Date: Tue, 26 Jan 2010 21:10:40 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?iso-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8180: implement get_tsf op for mac80211
Message-ID: <20100127021040.GA15520@tuxdriver.com>
References: <1264540940-30813-1-git-send-email-linville@tuxdriver.com> <69e28c911001261453r12a687eay3eac8669d3f0bfad@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c911001261453r12a687eay3eac8669d3f0bfad@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 26, 2010 at 11:53:38PM +0100, Gábor Stefanik wrote:
> On Tue, Jan 26, 2010 at 10:22 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/rtl818x/rtl8180_dev.c |   15 +++++++++++++++
> >  1 files changed, 15 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/net/wireless/rtl818x/rtl8180_dev.c b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> > index 5a2b719..8dbb504 100644
> > --- a/drivers/net/wireless/rtl818x/rtl8180_dev.c
> > +++ b/drivers/net/wireless/rtl818x/rtl8180_dev.c
> > @@ -761,6 +761,20 @@ static void rtl8180_configure_filter(struct ieee80211_hw *dev,
> >        rtl818x_iowrite32(priv, &priv->map->RX_CONF, priv->rx_conf);
> >  }
> >
> > +static u64 rtl8180_get_tsf(struct ieee80211_hw *dev)
> > +{
> > +       struct rtl8180_priv *priv = dev->priv;
> > +       u32 tsftl;
> > +       u64 tsft;
> > +
> > +       tsftl = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
> > +       tsft = rtl818x_ioread32(priv, &priv->map->TSFT[1]);
> > +       tsft <<= 32;
> > +       tsft |= tsftl;
> > +
> > +       return tsft;
> > +}
> 
> Why not:
> 
> struct rtl8180_priv *priv = dev->priv;
> u64 tsft;
> 
> tsft = rtl818x_ioread32(priv, &priv->map->TSFT[0]);
> tfst |= rtl818x_ioread32(priv, &priv->map->TSFT[1]) << 32;
> 
> return tsft;

What difference does it make?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
