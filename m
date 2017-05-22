Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935385AbdEVPbC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 May 2017 11:31:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: p54: allocate enough space for ->used_rxkeys
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170506004835.a5awr4v5rba2pmu5@mwanda>
References: <20170506004835.a5awr4v5rba2pmu5@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Message-Id: <20170522153102.20517607A4@smtp.codeaurora.org> (sfid-20170522_173202_695842_1FCF87A6)
Date: Mon, 22 May 2017 15:31:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> wrote:
> We have the number of longs, but we should be calculating the number of
> bytes needed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
> index 4ac6764f4897..3076f646c829 100644
> --- a/drivers/net/wireless/intersil/p54/fwio.c
> +++ b/drivers/net/wireless/intersil/p54/fwio.c
> @@ -176,8 +176,9 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
>  		 * keeping a extra list for uploaded keys.
>  		 */
>  
> -		priv->used_rxkeys = kzalloc(BITS_TO_LONGS(
> -			priv->rx_keycache_size), GFP_KERNEL);
> +		priv->used_rxkeys = kcalloc(BITS_TO_LONGS(priv->rx_keycache_size),
> +					    sizeof(long),
> +					    GFP_KERNEL);
>  
>  		if (!priv->used_rxkeys)
>  			return -ENOMEM;

Patch applied to wireless-drivers-next.git, thanks.

c239838fbd6d p54: allocate enough space for ->used_rxkeys

-- 
https://patchwork.kernel.org/patch/9714501/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
