Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:48018 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759396Ab3E2Szw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 14:55:52 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 29 May 2013 11:55:44 -0700
Subject: RE: [PATCH] mwifiex: dump small buffers with help of %*ph
Message-ID: <477F20668A386D41ADCC57781B1F70430E805C5682@SC-VEXCH1.marvell.com> (sfid-20130529_205555_039183_94933E89)
References: <1369821860-3004-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1369821860-3004-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

Thanks for the patch.

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/join.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
> index 6bcb66e..122175a 100644
> --- a/drivers/net/wireless/mwifiex/join.c
> +++ b/drivers/net/wireless/mwifiex/join.c
> @@ -919,9 +919,8 @@ mwifiex_cmd_802_11_ad_hoc_start(struct mwifiex_private *priv,
>  	memcpy(&priv->curr_bss_params.data_rates,
>  	       &adhoc_start->data_rate, priv->curr_bss_params.num_of_rates);
> 
> -	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%02x %02x %02x %02x\n",
> -		adhoc_start->data_rate[0], adhoc_start->data_rate[1],
> -		adhoc_start->data_rate[2], adhoc_start->data_rate[3]);
> +	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: rates=%4ph\n",
> +		adhoc_start->data_rate);
> 
>  	dev_dbg(adapter->dev, "info: ADHOC_S_CMD: AD-HOC Start command is ready\n");
> 
> --
> 1.8.2.rc0.22.gb3600c3

