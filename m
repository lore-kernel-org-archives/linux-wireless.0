Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:52053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYD3UeN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:34:13 -0400
Subject: Re: [PATCH] libertas: rename thread names
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804301051.47028.hs4233@mail.mn-solutions.de>
References: <200804301051.47028.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 16:30:01 -0400
Message-Id: <1209587401.16194.20.camel@localhost.localdomain> (sfid-20080430_223409_304014_EC8F4EE0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-30 at 10:51 +0200, Holger Schurig wrote:
> * Most thread names start with "k", so we can do the same
> * the module is named "libertas", so a "klibertas_XXX" thread
>   name more self-describing
> * one thread is a "struct task_struct", the other a workqueue,
>   let this be reflected in the name

It appears that of the other drivers that do something like this:

airo: uses device name
ipw2200: uses driver name (ipw2200)
iwlwifi: uses driver name (iwl3945)

I guess I'd rather go with those, seems odd to put a 'k' in front when
it's a driver thread and not too many other drivers put a 'k' in front.

Dan

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 08:48:04.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:01:22.000000000 +0200
> @@ -1122,15 +1122,14 @@ struct lbs_private *lbs_add_card(void *c
>  
>  	priv->rtap_net_dev = NULL;
>  
> -	lbs_deb_thread("Starting main thread...\n");
>  	init_waitqueue_head(&priv->waitq);
> -	priv->main_thread = kthread_run(lbs_thread, dev, "lbs_main");
> +	priv->main_thread = kthread_run(lbs_thread, dev, "klibertasd");
>  	if (IS_ERR(priv->main_thread)) {
>  		lbs_deb_thread("Error creating main thread.\n");
>  		goto err_init_adapter;
>  	}
>  
> -	priv->work_thread = create_singlethread_workqueue("lbs_worker");
> +	priv->work_thread = create_singlethread_workqueue("klibertasq");
>  	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
>  	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
>  	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);

