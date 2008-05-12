Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:33093 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbYELQjE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 May 2008 12:39:04 -0400
Subject: Re: [PATCH] [NET] libertas: check for mesh support before trying
	to use it
From: Dan Williams <dcbw@redhat.com>
To: Sebastian Siewior <liber+tas@ml.breakpoint.cc>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
In-Reply-To: <20080510072428.GA1153@Chamillionaire.breakpoint.cc>
References: <1208448814.9212.270.camel@pmac.infradead.org>
	 <1208455363.20193.3.camel@localhost.localdomain>
	 <20080417194437.GA18291@Chamillionaire.breakpoint.cc>
	 <20080510072428.GA1153@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Mon, 12 May 2008 12:34:16 -0400
Message-Id: <1210610056.23717.3.camel@localhost.localdomain> (sfid-20080512_183908_834346_4FEFAD0A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-10 at 09:24 +0200, Sebastian Siewior wrote:
> From: Sebastian Siewior <sebastian@breakpoint.cc>
> 
> This will prevent the execution of lbs_ethtool_get_stats() via ethtool -S
> if there is no mesh support.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
> Dan, this will test prevent the usage of ethtool -S in case there is no
> mesh support. If you fine with this than we could apply my or David's
> other patch to enable the function again and then worry about the error
> path.
> David: I saw your patch that is doing this in a other way but I thing
> that one looks better :)
> 
>  drivers/net/wireless/libertas/ethtool.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index dcfdb40..a79d698 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -113,8 +113,14 @@ static void lbs_ethtool_get_stats(struct net_device * dev,
>  
>  static int lbs_ethtool_get_sset_count(struct net_device * dev, int sset)
>  {
> +	struct lbs_private *priv = dev->priv;
> +
>  	switch (sset) {
>  	case ETH_SS_STATS:
> +
> +		if (!priv->mesh_tlv)
> +

We usually use

if (!priv->mesh_dev)

for checking whether mesh is open or not... Will that not work here?

Dan

> 			return -EOPNOTSUPP;
> +
>  		return MESH_STATS_NUM;
>  	default:
>  		return -EOPNOTSUPP;

