Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:46232 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753849Ab1HYXpL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 19:45:11 -0400
Subject: Re: [PATCH v2] mwifiex: replace kmalloc & memcpy sequence with
 kmemdup
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Walter Harms <wharms@bfs.de>
In-Reply-To: <1314301042-15021-1-git-send-email-bzhao@marvell.com>
References: <1314301042-15021-1-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 16:45:08 -0700
Message-ID: <1314315908.4637.23.camel@Joe-Laptop> (sfid-20110826_014523_994905_DC457978)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 12:37 -0700, Bing Zhao wrote:
> Sequence of kmalloc/kzalloc and memcpy is replaced with
> kmemdup.
> diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
[]
> @@ -1986,17 +1986,20 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
>  		priv->curr_bcn_size = curr_bss->beacon_buf_size;
>  
>  		kfree(priv->curr_bcn_buf);
> -		priv->curr_bcn_buf = kzalloc(curr_bss->beacon_buf_size,
> +
> +		priv->curr_bcn_buf = kmemdup(curr_bss->beacon_buf,
> +						curr_bss->beacon_buf_size,
>  						GFP_KERNEL);

I think this block, because of the new else below it,
isn't an improvement.

This kfree/kzalloc should probably just be krealloc with
the memset unchanged.

>  		if (!priv->curr_bcn_buf) {
>  			dev_err(priv->adapter->dev,
>  					"failed to alloc curr_bcn_buf\n");
>  			return;
>  		}
> +	} else {
> +		memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
> +			curr_bss->beacon_buf_size);
>  	}
>  
> -	memcpy(priv->curr_bcn_buf, curr_bss->beacon_buf,
> -		curr_bss->beacon_buf_size);
>  	dev_dbg(priv->adapter->dev, "info: current beacon saved %d\n",
>  		priv->curr_bcn_size);


