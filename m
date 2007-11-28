Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbXK1PBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 10:01:44 -0500
Subject: Re: [PATCH] libertas: tweak tx path debugging
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <200711281408.13037.hs4233@mail.mn-solutions.de>
References: <200711281408.13037.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 09:56:03 -0500
Message-Id: <1196261763.28264.3.camel@localhost.localdomain> (sfid-20071128_150149_916999_ED5532ED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-11-28 at 14:08 +0100, Holger Schurig wrote:
> Make two functions in the TX packet path emit
> their debug messages with LBS_DEB_TX, not LBS_DEB_MAIN.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
> Before this, any TXed packed did emit some messages with
> "lbsdebug +enter +main", which was a bit annoying.
> 
> Index: wireless-2.6/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2007-11-28 14:35:45.000000000 +0100
> +++ wireless-2.6/drivers/net/wireless/libertas/main.c	2007-11-28 14:37:13.000000000 +0100
> @@ -514,7 +514,7 @@ static int lbs_hard_start_xmit(struct sk
>  	int ret = 0;
>  	struct lbs_private *priv = dev->priv;
>  
> -	lbs_deb_enter(LBS_DEB_NET);
> +	lbs_deb_enter(LBS_DEB_TX);
>  
>  	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
>  		priv->stats.tx_dropped++;
> @@ -528,7 +528,7 @@ static int lbs_hard_start_xmit(struct sk
>  	if (lbs_process_tx(priv, skb) == 0)
>  		dev->trans_start = jiffies;
>  done:
> -	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
> +	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
>  	return ret;
>  }
>  
> @@ -564,7 +564,7 @@ static int lbs_pre_start_xmit(struct sk_
>  	struct lbs_private *priv = dev->priv;
>  	int ret;
>  
> -	lbs_deb_enter(LBS_DEB_NET);
> +	lbs_deb_enter(LBS_DEB_TX);
>  
>  	if (priv->adapter->monitormode != LBS_MONITOR_OFF) {
>  		netif_stop_queue(dev);
> @@ -574,7 +574,7 @@ static int lbs_pre_start_xmit(struct sk_
>  	UNSET_MESH_FRAME(skb);
>  
>  	ret = lbs_hard_start_xmit(skb, dev);
> -	lbs_deb_leave_args(LBS_DEB_NET, "ret %d", ret);
> +	lbs_deb_leave_args(LBS_DEB_TX, "ret %d", ret);
>  	return ret;
>  }
>  

