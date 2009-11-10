Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:49161 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919AbZKJAGL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 19:06:11 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>
Date: Mon, 9 Nov 2009 16:06:14 -0800
Subject: RE: [PATCH] Libertas: Fix issues while configuring host sleep
Message-ID: <477F20668A386D41ADCC57781B1F704306E249DDDC@SC-VEXCH1.marvell.com>
References: <1257383195-951-1-git-send-email-bzhao@marvell.com>
	<20091106201924.GH2782@tuxdriver.com>
 <477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: libertas-dev-bounces@lists.infradead.org [mailto:libertas-dev-bounces@lists.infradead.org] On
> Behalf Of Bing Zhao
> Sent: Friday, November 06, 2009 1:28 PM
> To: John W. Linville
> Cc: Amitkumar Karwar; linux-wireless@vger.kernel.org; libertas-dev@lists.infradead.org
> Subject: RE: [PATCH] Libertas: Fix issues while configuring host sleep
> 
> Hi John,
> 
> > -----Original Message-----
> > From: John W. Linville [mailto:linville@tuxdriver.com]
> > Sent: Friday, November 06, 2009 12:19 PM
> > To: Bing Zhao
> > Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar Karwar
> > Subject: Re: [PATCH] Libertas: Fix issues while configuring host sleep
> >
> > On Wed, Nov 04, 2009 at 05:06:35PM -0800, Bing Zhao wrote:
> > > From: Amitkumar Karwar <akarwar@marvell.com>
> > >
> > > Configuration of wake-on-lan for unicast, multicast, broadcast, physical
> > > activity was not working. Kernel panic issue was there when user tries to
> > > disable WOL. Fixed them.
> > >
> > > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > > ---
> > >  drivers/net/wireless/libertas/ethtool.c |   16 +++++++++++-----
> > >  1 files changed, 11 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> > > index 039b555..eeda6d7 100644
> > > --- a/drivers/net/wireless/libertas/ethtool.c
> > > +++ b/drivers/net/wireless/libertas/ethtool.c
> > > @@ -169,16 +169,22 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
> > >  	struct lbs_private *priv = dev->ml_priv;
> > >  	uint32_t criteria = 0;
> > >
> > > -	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
> > > +	if (priv->wol_criteria != 0xffffffff && wol->wolopts)
> > >  		return -EOPNOTSUPP;
> >
> > Are you sure about this?  This makes me think that you won't be able
> > to change WoL parameters without going through a disable step first.
> > Am I misreading?
> 
> I'm not sure if this is the best fix or not. But without this change, "ethtool -s wlan0 wol u" would
> return "Cannot set new wake-on-lan settings: Operation not supported". Yes, you have to disable it
> first in order to change the WoL parameters.
> 

We can probably just remove the check so that we can change the WoL settings without disabling first.

-	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
-  		return -EOPNOTSUPP;

I will re-send the patch.

Thanks,

Bing

