Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59212 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753783Ab1IUSHf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 14:07:35 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Wed, 21 Sep 2011 11:05:14 -0700
Subject: RE: [patch 2/2] mwifiex: remove unneeded NULL check
Message-ID: <477F20668A386D41ADCC57781B1F704308153E17A1@SC-VEXCH1.marvell.com> (sfid-20110921_200740_131733_675D08C5)
References: <20110921071356.GG4999@elgon.mountain>
In-Reply-To: <20110921071356.GG4999@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the patch.

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, September 21, 2011 12:14 AM
> To: Bing Zhao
> Cc: John W. Linville; linux-wireless@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [patch 2/2] mwifiex: remove unneeded NULL check
> 
> We dereference "rate" on the lines before so the checks here are too
> late to help.  This function is only called from
> mwifiex_dump_station_info() and "rate" is always a non-NULL pointer
> so the check can be removed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> 
> diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
> index 215c65a..1df5ef6 100644
> --- a/drivers/net/wireless/mwifiex/sta_ioctl.c
> +++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
> @@ -868,10 +868,10 @@ int mwifiex_drv_get_data_rate(struct mwifiex_private *priv,
>  	ret = mwifiex_rate_ioctl_cfg(priv, rate);
> 
>  	if (!ret) {
> -		if (rate && rate->is_rate_auto)
> +		if (rate->is_rate_auto)
>  			rate->rate = mwifiex_index_to_data_rate(priv->tx_rate,
>  							priv->tx_htinfo);
> -		else if (rate)
> +		else
>  			rate->rate = priv->data_rate;
>  	} else {
>  		ret = -1;
