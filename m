Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790AbXGFDr3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 23:47:29 -0400
Subject: Re: [PATCH] libertas: remove adapter->TxLockFlag
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <200707031746.47550.hs4233@mail.mn-solutions.de>
References: <200707031746.47550.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 23:52:14 -0400
Message-Id: <1183693934.24555.39.camel@xo-13-A4-25.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-07-03 at 17:46 +0200, Holger Schurig wrote:
> TxLockFlag was only set to 0, to no other value at all. So it's a candiate
> for removing.

Not committing until the radiotap/monitor mode stuff gets sorted out.

Dan

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> ---
>  drivers/net/wireless/libertas/dev.h  |    1 -
>  drivers/net/wireless/libertas/main.c |    2 +-
>  drivers/net/wireless/libertas/tx.c   |    1 -
>  3 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index cfb6d71..125e882 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -285,7 +285,6 @@ struct _wlan_adapter {
>  
>  	/** Tx-related variables (for single packet tx) */
>  	struct sk_buff *currenttxskb;
> -	u16 TxLockFlag;
>  
>  	/** NIC Operation characteristics */
>  	u16 currentpacketfilter;
> diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> index 1548760..af56db6 100644
> --- a/drivers/net/wireless/libertas/main.c
> +++ b/drivers/net/wireless/libertas/main.c
> @@ -448,7 +448,7 @@ static int libertas_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)
>  
>  	lbs_deb_enter(LBS_DEB_NET);
>  
> -	if (priv->dnld_sent || priv->adapter->TxLockFlag) {
> +	if (priv->dnld_sent) {
>  		priv->stats.tx_dropped++;
>  		goto done;
>  	}
> diff --git a/drivers/net/wireless/libertas/tx.c b/drivers/net/wireless/libertas/tx.c
> index 85f7bfb..3100d30 100644
> --- a/drivers/net/wireless/libertas/tx.c
> +++ b/drivers/net/wireless/libertas/tx.c
> @@ -198,7 +198,6 @@ void libertas_send_tx_feedback(wlan_private * priv)
>  	    (1 + adapter->txretrycount - try_count) : 0;
>  	libertas_upload_rx_packet(priv, adapter->currenttxskb);
>  	adapter->currenttxskb = NULL;
> -	priv->adapter->TxLockFlag = 0;
>  	if (priv->adapter->connect_status == LIBERTAS_CONNECTED) {
>  		netif_wake_queue(priv->dev);
>  		if (priv->mesh_dev)

