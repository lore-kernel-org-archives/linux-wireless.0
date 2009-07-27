Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:15654 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463AbZG0Blr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jul 2009 21:41:47 -0400
Subject: Re: [PATCH] iwlwifi: Read outside array bounds
From: Zhu Yi <yi.zhu@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4A6B7A67.9070906@gmail.com>
References: <4A6B7A67.9070906@gmail.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 09:41:45 +0800
Message-Id: <1248658905.3747.97.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2009-07-26 at 05:34 +0800, Roel Kluin wrote:
> tid is bounded (above) by the size of default_tid_to_tx_fifo (17 elements), but
> the size of priv->stations[].tid[] is MAX_TID_COUNT (9) elements.

I think MAX_TID_COUNT should be defined as 16 or 17. Tomas?

Thanks,
-yi

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 85ae7a6..e9441c6 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -1170,6 +1170,8 @@ int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn)
>  		IWL_ERR(priv, "Start AGG on invalid station
> ");
>  		return -ENXIO;
>  	}
> +	if (unlikely(tid >= MAX_TID_COUNT))
> +		return -EINVAL;
>  
>  	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
>  		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !
> ");

