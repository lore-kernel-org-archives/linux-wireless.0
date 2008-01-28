Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51715 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751770AbYA1Qo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:44:57 -0500
Subject: Re: [PATCH] libertas: make lbs_sync_channel() static
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200801281726.28434.hs4233@mail.mn-solutions.de>
References: <200801281726.28434.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 28 Jan 2008 11:39:43 -0500
Message-Id: <1201538383.14441.7.camel@localhost.localdomain> (sfid-20080128_164459_666768_6AE2C3D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-01-28 at 17:26 +0100, Holger Schurig wrote:
> ... by moving it into the file where it's sole user resides
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2008-01-18 10:42:26.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2008-01-18 10:43:48.000000000 +0100
> @@ -179,17 +179,6 @@ int lbs_update_channel(struct lbs_privat
>  	return ret;
>  }
>  
> -void lbs_sync_channel(struct work_struct *work)
> -{
> -	struct lbs_private *priv = container_of(work, struct lbs_private,
> -		sync_channel);
> -
> -	lbs_deb_enter(LBS_DEB_ASSOC);
> -	if (lbs_update_channel(priv))
> -		lbs_pr_info("Channel synchronization failed.");
> -	lbs_deb_leave(LBS_DEB_ASSOC);
> -}
> -
>  static int assoc_helper_channel(struct lbs_private *priv,
>                                  struct assoc_request * assoc_req)
>  {
> Index: wireless-2.6/drivers/net/wireless/libertas/assoc.h
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.h	2008-01-18 10:42:26.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/assoc.h	2008-01-18 10:43:49.000000000 +0100
> @@ -7,6 +7,5 @@
>  
>  void lbs_association_worker(struct work_struct *work);
>  struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
> -void lbs_sync_channel(struct work_struct *work);
>  
>  #endif /* _LBS_ASSOC_H */
> Index: wireless-2.6/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2008-01-18 10:42:26.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/main.c	2008-01-18 10:43:48.000000000 +0100
> @@ -985,6 +985,18 @@ out:
>  	lbs_deb_leave(LBS_DEB_CMD);
>  }
>  
> +static void lbs_sync_channel_worker(struct work_struct *work)
> +{
> +	struct lbs_private *priv = container_of(work, struct lbs_private,
> +		sync_channel);
> +
> +	lbs_deb_enter(LBS_DEB_MAIN);
> +	if (lbs_update_channel(priv))
> +		lbs_pr_info("Channel synchronization failed.");
> +	lbs_deb_leave(LBS_DEB_MAIN);
> +}
> +
> +
>  static int lbs_init_adapter(struct lbs_private *priv)
>  {
>  	size_t bufsize;
> @@ -1128,7 +1140,7 @@ struct lbs_private *lbs_add_card(void *c
>  	priv->work_thread = create_singlethread_workqueue("lbs_worker");
>  	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
>  	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
> -	INIT_WORK(&priv->sync_channel, lbs_sync_channel);
> +	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
>  
>  	sprintf(priv->mesh_ssid, "mesh");
>  	priv->mesh_ssid_len = 4;

