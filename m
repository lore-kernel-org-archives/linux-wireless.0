Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38805 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbZKFUaH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 15:30:07 -0500
Date: Fri, 6 Nov 2009 15:19:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: Re: [PATCH] Libertas: Fix issues while configuring host sleep
Message-ID: <20091106201924.GH2782@tuxdriver.com>
References: <1257383195-951-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257383195-951-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 04, 2009 at 05:06:35PM -0800, Bing Zhao wrote:
> From: Amitkumar Karwar <akarwar@marvell.com>
> 
> Configuration of wake-on-lan for unicast, multicast, broadcast, physical
> activity was not working. Kernel panic issue was there when user tries to
> disable WOL. Fixed them.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> ---
>  drivers/net/wireless/libertas/ethtool.c |   16 +++++++++++-----
>  1 files changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 039b555..eeda6d7 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -169,16 +169,22 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
>  	struct lbs_private *priv = dev->ml_priv;
>  	uint32_t criteria = 0;
>  
> -	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
> +	if (priv->wol_criteria != 0xffffffff && wol->wolopts)
>  		return -EOPNOTSUPP;
  
Are you sure about this?  This makes me think that you won't be able
to change WoL parameters without going through a disable step first.
Am I misreading?

>  	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
>  		return -EOPNOTSUPP;
>  
> -	if (wol->wolopts & WAKE_UCAST) criteria |= EHS_WAKE_ON_UNICAST_DATA;
> -	if (wol->wolopts & WAKE_MCAST) criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> -	if (wol->wolopts & WAKE_BCAST) criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> -	if (wol->wolopts & WAKE_PHY)   criteria |= EHS_WAKE_ON_MAC_EVENT;
> +	if (wol->wolopts & WAKE_UCAST)
> +		criteria |= EHS_WAKE_ON_UNICAST_DATA;
> +	if (wol->wolopts & WAKE_MCAST)
> +		criteria |= EHS_WAKE_ON_MULTICAST_DATA;
> +	if (wol->wolopts & WAKE_BCAST)
> +		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
> +	if (wol->wolopts & WAKE_PHY)
> +		criteria |= EHS_WAKE_ON_MAC_EVENT;
> +	if (wol->wolopts == 0)
> +		criteria |= EHS_REMOVE_WAKEUP;
>  
>  	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
>  }

The reformatting is a distraction.  It would be better to do just
the fix part separately, especially if you are targetting 2.6.32.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
