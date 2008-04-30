Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbYD3U0P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 16:26:15 -0400
Subject: Re: [PATCH] libertas: debug output tweaks for lbs_thread
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200804301050.07808.hs4233@mail.mn-solutions.de>
References: <200804301050.07808.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 30 Apr 2008 16:22:05 -0400
Message-Id: <1209586925.16194.10.camel@localhost.localdomain> (sfid-20080430_222611_278207_EFD41A16)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-30 at 10:50 +0200, Holger Schurig wrote:
> * make debug output match the variable name
> * always report that lbs_remove_rtap() has has been exited
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 09:21:45.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:24:05.000000000 +0200
> @@ -703,7 +703,7 @@ static int lbs_thread(void *data)
>  
>  		if (shouldsleep) {
>  			lbs_deb_thread("sleeping, connect_status %d, "
> -				"ps_mode %d, ps_state %d\n",
> +				"psmode %d, psstate %d\n",
>  				priv->connect_status,
>  				priv->psmode, priv->psstate);
>  			spin_unlock_irq(&priv->driver_lock);
> @@ -1532,10 +1532,11 @@ static void lbs_remove_rtap(struct lbs_p
>  {
>  	lbs_deb_enter(LBS_DEB_MAIN);
>  	if (priv->rtap_net_dev == NULL)
> -		return;
> +		goto out;
>  	unregister_netdev(priv->rtap_net_dev);
>  	free_netdev(priv->rtap_net_dev);
>  	priv->rtap_net_dev = NULL;
> +out:
>  	lbs_deb_leave(LBS_DEB_MAIN);
>  }
>  

