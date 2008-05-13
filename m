Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3684 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbYEMA3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 20:29:47 -0400
Date: Mon, 12 May 2008 20:09:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH] [NET] libertas: check for mesh support before trying
	to use it
Message-ID: <20080513000914.GA26418@tuxdriver.com> (sfid-20080513_022950_515180_D8938356)
References: <1208448814.9212.270.camel@pmac.infradead.org> <1208455363.20193.3.camel@localhost.localdomain> <20080417194437.GA18291@Chamillionaire.breakpoint.cc> <20080510072428.GA1153@Chamillionaire.breakpoint.cc> <1210610056.23717.3.camel@localhost.localdomain> <20080512205136.GA27705@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080512205136.GA27705@Chamillionaire.breakpoint.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 10:51:36PM +0200, Sebastian Siewior wrote:
> * Dan Williams | 2008-05-12 12:34:16 [-0400]:
> 
> >> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> >> index dcfdb40..a79d698 100644
> >> --- a/drivers/net/wireless/libertas/ethtool.c
> >> +++ b/drivers/net/wireless/libertas/ethtool.c
> >> @@ -113,8 +113,14 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
> >>  
> >>  static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
> >>  {
> >> +	struct lbs_private *priv = dev->priv;
> >> +
> >>  	switch (sset) {
> >>  	case ETH_SS_STATS:
> >> +
> >> +		if (!priv->mesh_tlv)
> >> +
> >
> >We usually use
> >
> >if (!priv->mesh_dev)
> >
> >for checking whether mesh is open or not... Will that not work here?
> >
> Well, if this is the case than you can pick David's patch which does
> this [1]. If you fine with this than I could add a patch description and
> things like that :)
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/13707

These competing patches have been under discussion for a month.
Can we get some consensus on which patch or patches we want?

John
-- 
John W. Linville
linville@tuxdriver.com
