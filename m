Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:35734 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725AbZKFV1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 16:27:48 -0500
From: Bing Zhao <bzhao@marvell.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 6 Nov 2009 13:27:50 -0800
Subject: RE: [PATCH] Libertas: Fix issues while configuring host sleep
Message-ID: <477F20668A386D41ADCC57781B1F704306E01F78F3@SC-VEXCH1.marvell.com>
References: <1257383195-951-1-git-send-email-bzhao@marvell.com>
 <20091106201924.GH2782@tuxdriver.com>
In-Reply-To: <20091106201924.GH2782@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Friday, November 06, 2009 12:19 PM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org; Amitkumar Karwar
> Subject: Re: [PATCH] Libertas: Fix issues while configuring host sleep
> 
> On Wed, Nov 04, 2009 at 05:06:35PM -0800, Bing Zhao wrote:
> > From: Amitkumar Karwar <akarwar@marvell.com>
> >
> > Configuration of wake-on-lan for unicast, multicast, broadcast, physical
> > activity was not working. Kernel panic issue was there when user tries to
> > disable WOL. Fixed them.
> >
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > ---
> >  drivers/net/wireless/libertas/ethtool.c |   16 +++++++++++-----
> >  1 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> > index 039b555..eeda6d7 100644
> > --- a/drivers/net/wireless/libertas/ethtool.c
> > +++ b/drivers/net/wireless/libertas/ethtool.c
> > @@ -169,16 +169,22 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
> >  	struct lbs_private *priv = dev->ml_priv;
> >  	uint32_t criteria = 0;
> >
> > -	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
> > +	if (priv->wol_criteria != 0xffffffff && wol->wolopts)
> >  		return -EOPNOTSUPP;
> 
> Are you sure about this?  This makes me think that you won't be able
> to change WoL parameters without going through a disable step first.
> Am I misreading?

I'm not sure if this is the best fix or not. But without this change, "ethtool -s wlan0 wol u" would return "Cannot set new wake-on-lan settings: Operation not supported". Yes, you have to disable it first in order to change the WoL parameters.

> 
> >  	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
> >  		return -EOPNOTSUPP;
> >
> > -	if (wol->wolopts & WAKE_UCAST) criteria |= EHS_WAKE_ON_UNICAST_DATA;
> > -	if (wol->wolopts & WAKE_MCAST) criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> > -	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> > -	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
> > +	if (wol->wolopts & WAKE_UCAST)
> > +		criteria |= EHS_WAKE_ON_UNICAST_DATA;
> > +	if (wol->wolopts & WAKE_MCAST)
> > +		criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> > +	if (wol->wolopts & WAKE_BCAST)
> > +		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> > +	if (wol->wolopts & WAKE_PHY)
> > +		criteria |= EHS_WAKE_ON_MAC_EVENT;
> > +	if (wol->wolopts == 0)
> > +		criteria |= EHS_REMOVE_WAKEUP;
> >
> >  	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
> >  }
> 
> The reformatting is a distraction.  It would be better to do just
> the fix part separately, especially if you are targetting 2.6.32.

Without the reformatting, the change would be like this:

+	if (wol->wolopts == 0)    criteria |= EHS_REMOVE_WAKEUP;

But the "checkpatch.pl" script gave me an error on that:
"ERROR: trailing statements should be on next line"


Thanks,

Bing

> John
> --
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.
