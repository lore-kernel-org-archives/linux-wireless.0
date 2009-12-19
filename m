Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZLSIlW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Dec 2009 03:41:22 -0500
Subject: Re: [PATCH] libertas: Remove carrier signaling from the scan code
From: Dan Williams <dcbw@redhat.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@gmail.com>
In-Reply-To: <20091218103649.GA3568@sortiz.org>
References: <20091218103649.GA3568@sortiz.org>
Content-Type: text/plain
Date: Sat, 19 Dec 2009 00:41:14 -0800
Message-Id: <1261212074.23392.10.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-12-18 at 11:36 +0100, Samuel Ortiz wrote:
> There is no reason to signal a carrier off when doing a 802.11 scan.
> 
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Holger Schurig <holgerschurig@gmail.com>
> Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/scan.c |   22 ++++++++--------------
>  1 files changed, 8 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
> index c6a6c04..b0b1c78 100644
> --- a/drivers/net/wireless/libertas/scan.c
> +++ b/drivers/net/wireless/libertas/scan.c
> @@ -567,11 +567,8 @@ int lbs_scan_networks(struct lbs_private *priv, int full_scan)
>  	chan_count = lbs_scan_create_channel_list(priv, chan_list);
>  
>  	netif_stop_queue(priv->dev);
> -	netif_carrier_off(priv->dev);
> -	if (priv->mesh_dev) {
> +	if (priv->mesh_dev)
>  		netif_stop_queue(priv->mesh_dev);
> -		netif_carrier_off(priv->mesh_dev);
> -	}
>  
>  	/* Prepare to continue an interrupted scan */
>  	lbs_deb_scan("chan_count %d, scan_channel %d\n",
> @@ -635,16 +632,13 @@ out2:
>  	priv->scan_channel = 0;
>  
>  out:
> -	if (priv->connect_status == LBS_CONNECTED) {
> -		netif_carrier_on(priv->dev);
> -		if (!priv->tx_pending_len)
> -			netif_wake_queue(priv->dev);
> -	}
> -	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
> -		netif_carrier_on(priv->mesh_dev);
> -		if (!priv->tx_pending_len)
> -			netif_wake_queue(priv->mesh_dev);
> -	}
> +	if (priv->connect_status == LBS_CONNECTED && !priv->tx_pending_len)
> +		netif_wake_queue(priv->dev);
> +
> +	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED) &&
> +	    !priv->tx_pending_len)
> +		netif_wake_queue(priv->mesh_dev);
> +
>  	kfree(chan_list);
>  
>  	lbs_deb_leave_args(LBS_DEB_SCAN, "ret %d", ret);

