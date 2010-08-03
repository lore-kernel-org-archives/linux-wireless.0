Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39501 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755950Ab0HCKZn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Aug 2010 06:25:43 -0400
Subject: Re: [PATCH] wireless: ipw2100: check result of kzalloc()
From: Christoph Fritz <chf.fritz@googlemail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	kernel-janitors <kernel-janitors@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20100803081701.GP26313@bicker>
References: <1280797822.11158.55.camel@lovely.krouter>
	 <20100803081701.GP26313@bicker>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 03 Aug 2010 12:28:42 +0200
Message-ID: <1280831322.3034.7.camel@lovely.krouter>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-03 at 10:17 +0200, Dan Carpenter wrote:
> On Tue, Aug 03, 2010 at 03:10:22AM +0200, Christoph Fritz wrote:
> > If kzalloc() fails return with -ENOMEM from ipw2100_net_init() which is
> > called by register_netdev.
> > 
> > Signed-off-by: Christoph Fritz <chf.fritz@googlemail.com>
> > ---
> >  drivers/net/wireless/ipw2x00/ipw2100.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/ipw2x00/ipw2100.c b/drivers/net/wireless/ipw2x00/ipw2100.c
> > index 0bd4dfa..908c176 100644
> > --- a/drivers/net/wireless/ipw2x00/ipw2100.c
> > +++ b/drivers/net/wireless/ipw2x00/ipw2100.c
> > @@ -1924,6 +1924,8 @@ static int ipw2100_net_init(struct net_device *dev)
> >  		bg_band->channels =
> >  			kzalloc(geo->bg_channels *
> >  				sizeof(struct ieee80211_channel), GFP_KERNEL);
> > +		if (!bg_band->channels)
> 
> There should be an "ipw2100_down(priv);" on the error path here.

thanks for pointing this out, I'll add this.

> 
> > +			return -ENOMEM;
> >  		/* translate geo->bg to bg_band.channels */
> 


