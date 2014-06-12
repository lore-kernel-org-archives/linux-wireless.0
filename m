Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44883 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaFLDYC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 23:24:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jun 2014 20:22:11 -0700
Subject: RE: [patch 11/13] wireless: mwifiex: Use the proper interfaces
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com> (sfid-20140612_052407_424717_C7019E4C)
References: <20140611234024.103571777@linutronix.de>
 <20140611234607.607201623@linutronix.de>
In-Reply-To: <20140611234607.607201623@linutronix.de>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Thomas,

Thanks for your patch.

> Why is converting time formats so desired if there are proper
> interfaces for this?
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org

[...]

> Index: linux/drivers/net/wireless/mwifiex/main.c
> ===================================================================
> --- linux.orig/drivers/net/wireless/mwifiex/main.c
> +++ linux/drivers/net/wireless/mwifiex/main.c
> @@ -611,7 +611,6 @@ mwifiex_hard_start_xmit(struct sk_buff *
>  	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
>  	struct sk_buff *new_skb;
>  	struct mwifiex_txinfo *tx_info;
> -	struct timeval tv;
> 
>  	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
>  		jiffies, priv->bss_type, priv->bss_num);
> @@ -658,8 +657,7 @@ mwifiex_hard_start_xmit(struct sk_buff *
>  	 * firmware for aggregate delay calculation for stats and
>  	 * MSDU lifetime expiry.
>  	 */
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);
> 
>  	mwifiex_queue_tx_pkt(priv, skb);
> 
> Index: linux/drivers/net/wireless/mwifiex/tdls.c
> ===================================================================
> --- linux.orig/drivers/net/wireless/mwifiex/tdls.c
> +++ linux/drivers/net/wireless/mwifiex/tdls.c
> @@ -552,8 +552,7 @@ int mwifiex_send_tdls_data_frame(struct
>  	tx_info->bss_num = priv->bss_num;
>  	tx_info->bss_type = priv->bss_type;
> 
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);

I guess we need to remove "struct timeval tv" local variable too.

>  	mwifiex_queue_tx_pkt(priv, skb);
> 
>  	return 0;
> @@ -710,8 +709,7 @@ int mwifiex_send_tdls_action_frame(struc
>  	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
>  	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
>  	       sizeof(pkt_len));
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);

And here too.

Could you please remove these two "struct timeval tv" and send v2 with my ACK?

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

>  	mwifiex_queue_tx_pkt(priv, skb);
> 
>  	return 0;

