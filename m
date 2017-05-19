Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f41.google.com ([74.125.83.41]:35913 "EHLO
        mail-pg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751055AbdESQ27 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 12:28:59 -0400
Received: by mail-pg0-f41.google.com with SMTP id x64so40382500pgd.3
        for <linux-wireless@vger.kernel.org>; Fri, 19 May 2017 09:28:58 -0700 (PDT)
Date: Fri, 19 May 2017 09:28:55 -0700
From: Brian Norris <briannorris@chromium.org>
To: Xinming Hu <huxinming820@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH v3 6/6] mwifiex: check next packet length for usb tx
 aggregation
Message-ID: <20170519162854.GA125761@google.com> (sfid-20170519_182902_798477_147E223D)
References: <1495184805-6631-1-git-send-email-huxinming820@gmail.com>
 <1495184805-6631-6-git-send-email-huxinming820@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495184805-6631-6-git-send-email-huxinming820@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 19, 2017 at 09:06:45AM +0000, Xinming Hu wrote:
> From: Xinming Hu <huxm@marvell.com>
> 
> The next packet length will be used by interface driver, to check if the
> next packet still could be aggregated.
> 
> Signed-off-by: Xinming Hu <huxm@marvell.com>
> Signed-off-by: Cathy Luo <cluo@marvell.com>
> Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
> ---
> v3: same as v1,v2
> ---
>  drivers/net/wireless/marvell/mwifiex/11n_aggr.c | 8 ++++----
>  drivers/net/wireless/marvell/mwifiex/txrx.c     | 4 ++--
>  drivers/net/wireless/marvell/mwifiex/wmm.c      | 8 ++++----
>  3 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
> index cbf3bc2..8041f2d 100644
> --- a/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
> +++ b/drivers/net/wireless/marvell/mwifiex/11n_aggr.c
> @@ -254,15 +254,15 @@
>  		return 0;
>  	}
>  
> -	if (adapter->iface_type == MWIFIEX_USB) {
> -		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
> -						   skb_aggr, NULL);
> -	} else {
>  		if (skb_src)
>  			tx_param.next_pkt_len =
>  					skb_src->len + sizeof(struct txpd);
>  		else
>  			tx_param.next_pkt_len = 0;

The above if/else is now improperly indented.

> +	if (adapter->iface_type == MWIFIEX_USB) {
> +		ret = adapter->if_ops.host_to_card(adapter, priv->usb_port,
> +						   skb_aggr, &tx_param);
> +	} else {
>  
>  		ret = adapter->if_ops.host_to_card(adapter, MWIFIEX_TYPE_DATA,
>  						   skb_aggr, &tx_param);

[...]

Brian
