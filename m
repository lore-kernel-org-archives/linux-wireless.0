Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62350 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190AbcCRIuT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2016 04:50:19 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Marty Faltesek <mfaltesek@google.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mwifiex: bridged packets cause wmm_tx_pending counter to
 go negative
Date: Fri, 18 Mar 2016 08:50:15 +0000
Message-ID: <df2281ad1cff49c1a2cf6cc0281c219c@SC-EXCH04.marvell.com> (sfid-20160318_095052_315287_606F73F3)
References: <1457997683-14553-1-git-send-email-mfaltesek@google.com>
In-Reply-To: <1457997683-14553-1-git-send-email-mfaltesek@google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Marty Faltesek [mailto:mfaltesek@google.com]
> Sent: Tuesday, March 15, 2016 4:51 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org
> Subject: [PATCH] mwifiex: bridged packets cause wmm_tx_pending counter
> to go negative
> 
> When a packet is queued from the bridge, wmm_tx_pending is not
> incremented, but when the packet is dequeued the counter is decremented.
> 
> ---
>  drivers/net/wireless/marvell/mwifiex/uap_txrx.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> index 52f7981..193a809 100644
> --- a/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> +++ b/drivers/net/wireless/marvell/mwifiex/uap_txrx.c
> @@ -102,6 +102,7 @@ static void mwifiex_uap_queue_bridged_pkt(struct
> mwifiex_private *priv,
>  	int hdr_chop;
>  	struct ethhdr *p_ethhdr;
>  	struct mwifiex_sta_node *src_node;
> +	int index;
> 
>  	uap_rx_pd = (struct uap_rxpd *)(skb->data);
>  	rx_pkt_hdr = (void *)uap_rx_pd + le16_to_cpu(uap_rx_pd-
> >rx_pkt_offset);
> @@ -208,6 +209,9 @@ static void mwifiex_uap_queue_bridged_pkt(struct
> mwifiex_private *priv,
>  	}
> 
>  	__net_timestamp(skb);
> +
> +	index = mwifiex_1d_to_wmm_queue[skb->priority];
> +	atomic_inc(&priv->wmm_tx_pending[index]);
>  	mwifiex_wmm_add_buf_txqueue(priv, skb);
>  	atomic_inc(&adapter->tx_pending);
>  	atomic_inc(&adapter->pending_bridged_pkts);
> --
> 2.7.0.rc3.207.g0ac5344

Looks fine.

Acked-by: Amitkumar Karwar <akarwar@marvell.com>

Regards,
Amitkumar
