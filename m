Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0178.hostedemail.com ([216.40.44.178]:56637 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751121AbaLQKnV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:43:21 -0500
Message-ID: <1418812995.14140.20.camel@perches.com> (sfid-20141217_114324_989589_7927A4AD)
Subject: Re: [PATCH 3/4] mwifiex: make tx packet 64 byte DMA aligned
From: Joe Perches <joe@perches.com>
To: Avinash Patil <patila@marvell.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	akarwar@marvell.com, cluo@marvell.com, yangyang@marvell.com,
	huxm@marvell.com
Date: Wed, 17 Dec 2014 02:43:15 -0800
In-Reply-To: <1418824621-2102-3-git-send-email-patila@marvell.com>
References: <1418824621-2102-1-git-send-email-patila@marvell.com>
	 <1418824621-2102-3-git-send-email-patila@marvell.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-17 at 19:27 +0530, Avinash Patil wrote:
> From: Xinming Hu <huxm@marvell.com>
[]
> diff --git a/drivers/net/wireless/mwifiex/11n_aggr.c b/drivers/net/wireless/mwifiex/11n_aggr.c
[]
> @@ -101,6 +101,13 @@ mwifiex_11n_form_amsdu_txpd(struct mwifiex_private *priv,
>  {
>  	struct txpd *local_tx_pd;
>  	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
> +	u8 pad;

The u8 gets upcasted to unsigned int for the skb_push
so why use u8 at all?

I think unsigned int makes more sense.


> +	int headroom = (priv->adapter->iface_type ==
> +			MWIFIEX_USB) ? 0 : INTF_HEADER_LEN;
> +
> +	pad = ((void *)skb->data - sizeof(*local_tx_pd) -
> +		headroom - NULL) & (MWIFIEX_DMA_ALIGN_SZ - 1);
> +	skb_push(skb, pad);
>  
>  	skb_push(skb, sizeof(*local_tx_pd));

[]

> diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
[]
> @@ -32,8 +32,10 @@
>  
>  #define MWIFIEX_MAX_BSS_NUM         (3)
>  
> -#define MWIFIEX_MIN_DATA_HEADER_LEN 36	/* sizeof(mwifiex_txpd)
> -					 *   + 4 byte alignment
> +#define MWIFIEX_DMA_ALIGN_SZ	    64
> +#define MWIFIEX_MIN_DATA_HEADER_LEN 100	/* sizeof(mwifiex_txpd)
> +					 *   + 4 byte interface header alignment
> +					 *   + 64 byte dma alignment

Maybe better to use those values in the
#define instead.

> diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
> index b896d73..9796334 100644
> --- a/drivers/net/wireless/mwifiex/sta_tx.c
> +++ b/drivers/net/wireless/mwifiex/sta_tx.c
> @@ -47,8 +47,10 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
>  	struct mwifiex_adapter *adapter = priv->adapter;
>  	struct txpd *local_tx_pd;
>  	struct mwifiex_txinfo *tx_info = MWIFIEX_SKB_TXCB(skb);
> -	u8 pad;
> +	int pad;

here it's int?



