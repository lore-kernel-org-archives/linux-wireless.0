Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:51254 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759643Ab3FCS01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 14:26:27 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Huawei Yang <harvey.huawei.yang@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Mon, 3 Jun 2013 11:24:15 -0700
Subject: RE: [RFC PATCH 1/1] mwifiex: Remove stop_net_dev_queue operation
 when uap handling packets forwarding.
Message-ID: <477F20668A386D41ADCC57781B1F70430E805C627A@SC-VEXCH1.marvell.com> (sfid-20130603_202650_947291_F47B44F9)
References: <1370246060-9087-1-git-send-email-harvey.huawei.yang@gmail.com>
In-Reply-To: <1370246060-9087-1-git-send-email-harvey.huawei.yang@gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Huawei,

Thanks for the patch.

> Under uap mode mwifiex may stop all net tx queues on forwarding packets. This may stop some tx queues
> and they never have chance to be waked up... There is also no need to check tx_pending and stop
> queues here. Because local host has such kind of check when transmitting packets and it's not proper
> to have forwarding affect local transmitting.
> 
> Signed-off-by: Huawei Yang <harvey.huawei.yang@gmail.com>

Reviewed-by: Avinash Patil <patila@marvell.com>
Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/uap_txrx.c |    4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/uap_txrx.c b/drivers/net/wireless/mwifiex/uap_txrx.c
> index a018e42..11df2b2 100644
> --- a/drivers/net/wireless/mwifiex/uap_txrx.c
> +++ b/drivers/net/wireless/mwifiex/uap_txrx.c
> @@ -95,10 +95,6 @@ static void mwifiex_uap_queue_bridged_pkt(struct mwifiex_private *priv,
>  	atomic_inc(&adapter->tx_pending);
>  	atomic_inc(&adapter->pending_bridged_pkts);
> 
> -	if ((atomic_read(&adapter->tx_pending) >= MAX_TX_PENDING)) {
> -		mwifiex_set_trans_start(priv->netdev);
> -		mwifiex_stop_net_dev_queue(priv->netdev, priv->adapter);
> -	}
>  	return;
>  }
> 
> --
> 1.7.10.4

