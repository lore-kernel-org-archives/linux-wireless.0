Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29757 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab1COJUm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 05:20:42 -0400
Subject: Re: [patch 1/2] iwlwifi: missing unlock on error path
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dan Carpenter <error27@gmail.com>
Cc: "Berg, Johannes" <johannes.berg@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
In-Reply-To: <20110315070158.GQ2008@bicker>
References: <20110315070158.GQ2008@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 02:04:17 -0700
Message-ID: <1300179857.5082.213.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-15 at 00:01 -0700, Dan Carpenter wrote:
> We should unlock here instead of returning -EINVAL directly.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 581dc9f..321b18b 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3009,14 +3009,17 @@ static int iwl_mac_offchannel_tx_cancel_wait(struct ieee80211_hw *hw)
>  
>  	mutex_lock(&priv->mutex);
>  
> -	if (!priv->_agn.offchan_tx_skb)
> -		return -EINVAL;
> +	if (!priv->_agn.offchan_tx_skb) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
>  
>  	priv->_agn.offchan_tx_skb = NULL;
>  
>  	ret = iwl_scan_cancel_timeout(priv, 200);
>  	if (ret)
>  		ret = -EIO;
> +unlock:
>  	mutex_unlock(&priv->mutex);
>  
>  	return ret;
great catch

Thanks
Wey

