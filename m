Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:35764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYCZOSB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Mar 2008 10:18:01 -0400
Subject: Re: [PATCH] libertas: kill useless #define LBS_MONITOR_OFF 0
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803260957.14966.hs4233@mail.mn-solutions.de>
References: <200803260957.14966.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 10:16:57 -0400
Message-Id: <1206541017.30998.9.camel@localhost.localdomain> (sfid-20080326_141807_223332_8854E5C7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-26 at 09:57 +0100, Holger Schurig wrote:
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> --- wireless-testing.orig/drivers/net/wireless/libertas/wext.h
> +++ wireless-testing/drivers/net/wireless/libertas/wext.h
> @@ -15,8 +15,6 @@
>  	u32 value;
>  };
>  
> -#define LBS_MONITOR_OFF			0
> -
>  extern struct iw_handler_def lbs_handler_def;
>  extern struct iw_handler_def mesh_handler_def;
>  
> --- wireless-testing.orig/drivers/net/wireless/libertas/main.c
> +++ wireless-testing/drivers/net/wireless/libertas/main.c
> @@ -277,10 +277,10 @@
>  	struct lbs_private *priv = to_net_dev(dev)->priv;
>  
>  	sscanf(buf, "%x", &monitor_mode);
> -	if (monitor_mode != LBS_MONITOR_OFF) {
> -		if(priv->monitormode == monitor_mode)
> +	if (monitor_mode) {
> +		if (priv->monitormode == monitor_mode)
>  			return strlen(buf);
> -		if (priv->monitormode == LBS_MONITOR_OFF) {
> +		if (!priv->monitormode) {
>  			if (priv->infra_open || priv->mesh_open)
>  				return -EBUSY;
>  			if (priv->mode == IW_MODE_INFRA)
> @@ -293,9 +293,9 @@
>  	}
>  
>  	else {
> -		if (priv->monitormode == LBS_MONITOR_OFF)
> +		if (!priv->monitormode)
>  			return strlen(buf);
> -		priv->monitormode = LBS_MONITOR_OFF;
> +		priv->monitormode = 0;
>  		lbs_remove_rtap(priv);
>  
>  		if (priv->currenttxskb) {
> @@ -392,7 +392,7 @@
>  
>  	spin_lock_irq(&priv->driver_lock);
>  
> -	if (priv->monitormode != LBS_MONITOR_OFF) {
> +	if (priv->monitormode) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
> --- wireless-testing.orig/drivers/net/wireless/libertas/rx.c
> +++ wireless-testing/drivers/net/wireless/libertas/rx.c
> @@ -155,7 +155,7 @@
>  
>  	skb->ip_summed = CHECKSUM_NONE;
>  
> -	if (priv->monitormode != LBS_MONITOR_OFF)
> +	if (priv->monitormode)
>  		return process_rxed_802_11_packet(priv, skb);
>  
>  	p_rx_pkt = (struct rxpackethdr *) skb->data;
> --- wireless-testing.orig/drivers/net/wireless/libertas/tx.c
> +++ wireless-testing/drivers/net/wireless/libertas/tx.c
> @@ -151,7 +151,7 @@
>  
>  	dev->trans_start = jiffies;
>  
> -	if (priv->monitormode != LBS_MONITOR_OFF) {
> +	if (priv->monitormode) {
>  		/* Keep the skb to echo it back once Tx feedback is
>  		   received from FW */
>  		skb_orphan(skb);
> @@ -186,8 +186,7 @@
>  	int txfail;
>  	int try_count;
>  
> -	if (priv->monitormode == LBS_MONITOR_OFF ||
> -	    priv->currenttxskb == NULL)
> +	if (!priv->monitormode || priv->currenttxskb == NULL)
>  		return;
>  
>  	radiotap_hdr = (struct tx_radiotap_hdr *)priv->currenttxskb->data;

