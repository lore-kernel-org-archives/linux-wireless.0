Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab2DPVnV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:43:21 -0400
Message-ID: <1334612599.5455.1.camel@dcbw.foobar.com> (sfid-20120416_234324_523652_FA14F9D1)
Subject: Re: [RFC 2/4] libertas: harden-up exit paths
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 16 Apr 2012 16:43:19 -0500
In-Reply-To: <20120403160154.401D39D401E@zog.reactivated.net>
References: <20120403160154.401D39D401E@zog.reactivated.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-04-03 at 17:01 +0100, Daniel Drake wrote:
> These simple sanity check avoids extra complexity in error paths when
> moving to asynchronous firmware loading (which means the device may fail to
> init some time after its creation).

Looks fine to me.

Dan

> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  drivers/net/wireless/libertas/main.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index fa09585..7eaf992 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -1033,7 +1033,9 @@ void lbs_remove_card(struct lbs_private *priv)
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
>  	lbs_remove_mesh(priv);
> -	lbs_scan_deinit(priv);
> +
> +	if (priv->wiphy_registered)
> +		lbs_scan_deinit(priv);
>  
>  	/* worker thread destruction blocks on the in-flight command which
>  	 * should have been cleared already in lbs_stop_card().
> @@ -1128,6 +1130,11 @@ void lbs_stop_card(struct lbs_private *priv)
>  		goto out;
>  	dev = priv->dev;
>  
> +	/* If the netdev isn't registered, it means that lbs_start_card() was
> +	 * never called so we have nothing to do here. */
> +	if (dev->reg_state != NETREG_REGISTERED)
> +		goto out;
> +
>  	netif_stop_queue(dev);
>  	netif_carrier_off(dev);
>  


