Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab1HOWuR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 18:50:17 -0400
Subject: Re: [patch -next] libertas: handle mesh networks in
 lbs_iface_active()
From: Dan Williams <dcbw@redhat.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Daniel Drake <dsd@laptop.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:MARVELL LIBERTAS..." <libertas-dev@lists.infradead.org>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Date: Mon, 15 Aug 2011 17:52:29 -0500
In-Reply-To: <20110815112535.GC10560@shale.localdomain>
References: <20110815112535.GC10560@shale.localdomain>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1313448751.6103.15.camel@dcbw.foobar.com> (sfid-20110816_005029_589937_C40A7D7C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-15 at 14:25 +0300, Dan Carpenter wrote:
> There was an extra semicolon so the if condition wasn't used.  We
> checked "priv->dev" twice instead of "priv->mesh_dev".
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> Compile tested only.
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 8148389..b9ff0dc 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -190,8 +190,8 @@ static inline int lbs_iface_active(struct lbs_private *priv)
>  	int r;
>  
>  	r = netif_running(priv->dev);
> -	if (priv->mesh_dev);
> -		r |= netif_running(priv->dev);
> +	if (priv->mesh_dev)
> +		r |= netif_running(priv->mesh_dev);
>  
>  	return r;
>  }


