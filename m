Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbZKJGeH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 01:34:07 -0500
Subject: Re: [PATCH 2/2] Libertas: fix issues while configuring host sleep
 using ethtool wol
From: Dan Williams <dcbw@redhat.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: libertas-dev@lists.infradead.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1257818653-13460-2-git-send-email-bzhao@marvell.com>
References: <1257818653-13460-1-git-send-email-bzhao@marvell.com>
	 <1257818653-13460-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain
Date: Mon, 09 Nov 2009 22:33:53 -0800
Message-Id: <1257834833.15493.36.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-09 at 18:04 -0800, Bing Zhao wrote:
> Configuration of wake-on-lan for unicast, multicast, broadcast, physical
> activity was not working. Kernel panic issue was there when user tries to
> disable WOL. Fixed them.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/ethtool.c |    5 ++---
>  1 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 6efa388..53d56ab 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -169,9 +169,6 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
>  	struct lbs_private *priv = dev->ml_priv;
>  	uint32_t criteria = 0;
>  
> -	if (priv->wol_criteria == 0xffffffff && wol->wolopts)
> -		return -EOPNOTSUPP;
> -
>  	if (wol->wolopts & ~(WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY))
>  		return -EOPNOTSUPP;
>  
> @@ -183,6 +180,8 @@ static int lbs_ethtool_set_wol(struct net_device *dev,
>  		criteria |= EHS_WAKE_ON_BROADCAST_DATA;
>  	if (wol->wolopts & WAKE_PHY)
>  		criteria |= EHS_WAKE_ON_MAC_EVENT;
> +	if (wol->wolopts == 0)
> +		criteria |= EHS_REMOVE_WAKEUP;
>  
>  	return lbs_host_sleep_cfg(priv, criteria, (struct wol_config *)NULL);
>  }

