Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932503AbYD3U2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:28:03 -0400
Subject: Re: [PATCH] libertas: allow removal of card at any time
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804301051.15420.hs4233@mail.mn-solutions.de>
References: <200804301051.15420.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 16:23:55 -0400
Message-Id: <1209587035.16194.14.camel@localhost.localdomain> (sfid-20080430_222804_317496_7BED8CCA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-30 at 10:51 +0200, Holger Schurig wrote:
> This fixes several problems I had:
> 
> * when removing the card while the card was scanning or associtating,
>   it could happen that destroy_workqueue() stuck and didn't return.
> * make sure the command function doesn't run while we remove the list
>   of pending commands
> * for still unknown reason, I had calls to lbs_stop_card() with
>   priv==NULL
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 09:28:50.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:33:56.000000000 +0200
> @@ -1166,8 +1166,8 @@ void lbs_remove_card(struct lbs_private 
>  
>  	dev = priv->dev;
>  
> -	cancel_delayed_work(&priv->scan_work);
> -	cancel_delayed_work(&priv->assoc_work);
> +	cancel_delayed_work_sync(&priv->scan_work);
> +	cancel_delayed_work_sync(&priv->assoc_work);
>  	destroy_workqueue(priv->work_thread);
>  
>  	if (priv->psmode == LBS802_11POWERMODEMAX_PSP) {
> @@ -1267,6 +1267,9 @@ void lbs_stop_card(struct lbs_private *p
>  
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  
> +	if (!priv)
> +		goto out;
> +
>  	netif_stop_queue(priv->dev);
>  	netif_carrier_off(priv->dev);
>  
> @@ -1276,6 +1279,7 @@ void lbs_stop_card(struct lbs_private *p
>  		device_remove_file(&dev->dev, &dev_attr_lbs_mesh);
>  
>  	/* Flush pending command nodes */
> +	del_timer_sync(&priv->command_timer);
>  	spin_lock_irqsave(&priv->driver_lock, flags);
>  	list_for_each_entry(cmdnode, &priv->cmdpendingq, list) {
>  		cmdnode->result = -ENOENT;
> @@ -1286,6 +1290,7 @@ void lbs_stop_card(struct lbs_private *p
>  
>  	unregister_netdev(dev);
>  
> +out:
>  	lbs_deb_leave(LBS_DEB_MAIN);
>  }
>  EXPORT_SYMBOL_GPL(lbs_stop_card);

