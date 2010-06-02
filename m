Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0FBFgn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jun 2010 01:36:43 -0400
Subject: Re: [PATCH] libertas: Fix ethtool reporting no WOL options
 supported if WOL is not already active
From: Dan Williams <dcbw@redhat.com>
To: Sascha Silbe <sascha-ml-reply-to-2010-2@silbe.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1274806808-24185-1-git-send-email-sascha-pgp@silbe.org>
References: <1274806808-24185-1-git-send-email-sascha-pgp@silbe.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 22:36:45 -0700
Message-ID: <1275457005.18302.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-05-23 at 10:03 +0200, Sascha Silbe wrote:
> This patch fixes the libertas driver incorrectly reporting that Wake-on-LAN
> is not supported if Wake-on-LAN is currently disabled.

Acked-by: Dan Williams <dcbw@redhat.com>

but note that this patch submission isn't correctly formatted, you'll
need to add your Signed-off-by tag as described here:

http://lxr.linux.no/#linux+v2.6.34/Documentation/SubmittingPatches

around line 286 or so.  I doubt John will pick the patch up until you've
done that.

> ---
>  drivers/net/wireless/libertas/ethtool.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> Without patch:
> 
> root@xo15-minimal:~# ethtool wlan0
> Settings for wlan0:
>         Supports Wake-on: d
>         Wake-on: d
> root@xo15-minimal:~# ethtool -s wlan0 wol pum
> root@xo15-minimal:~# ethtool wlan0
> Settings for wlan0:
>         Supports Wake-on: pumb
>         Wake-on: pum
> root@xo15-minimal:~# ethtool -s wlan0 wol d
> root@xo15-minimal:~# ethtool wlan0
> Settings for wlan0:
>         Supports Wake-on: d
>         Wake-on: d
> root@xo15-minimal:~# 
> 
> 
> With patch:
> 
> xo-sascha:~# ethtool eth0
> Settings for eth0:
>         Supports Wake-on: pumb
>         Wake-on: d
> xo-sascha:~# ethtool -s eth0 wol pum
> xo-sascha:~# ethtool eth0
> Settings for eth0:
>         Supports Wake-on: pumb
>         Wake-on: pum
> xo-sascha:~# ethtool -s eth0 wol d
> xo-sascha:~# ethtool eth0
> Settings for eth0:
>         Supports Wake-on: pumb
>         Wake-on: d
> 
> diff --git a/drivers/net/wireless/libertas/ethtool.c b/drivers/net/wireless/libertas/ethtool.c
> index 6eb9a88..4a337b7 100644
> --- a/drivers/net/wireless/libertas/ethtool.c
> +++ b/drivers/net/wireless/libertas/ethtool.c
> @@ -145,14 +145,11 @@ static void lbs_ethtool_get_wol(struct net_device *dev,
>  {
>  	struct lbs_private *priv = dev->ml_priv;
>  
> -	if (priv->wol_criteria == 0xffffffff) {
> -		/* Interface driver didn't configure wake */
> -		wol->supported = wol->wolopts = 0;
> -		return;
> -	}
> -
>  	wol->supported = WAKE_UCAST|WAKE_MCAST|WAKE_BCAST|WAKE_PHY;
>  
> +	if (priv->wol_criteria == EHS_REMOVE_WAKEUP)
> +		return;
> +
>  	if (priv->wol_criteria & EHS_WAKE_ON_UNICAST_DATA)
>  		wol->wolopts |= WAKE_UCAST;
>  	if (priv->wol_criteria & EHS_WAKE_ON_MULTICAST_DATA)


