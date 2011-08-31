Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39484 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1HaGlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 02:41:39 -0400
Subject: Re: [patch -next 1/2] iwlwifi: fix double assign in
 iwl_start_tx_ba_trans_ready()
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: emmanuel.grumbach@intel.com, Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"open list:INTEL WIRELESS WI..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
In-Reply-To: <20110831063742.GC3705@shale.localdomain> (sfid-20110831_084010_132544_82772E48)
References: <20110831063742.GC3705@shale.localdomain>
	 (sfid-20110831_084010_132544_82772E48)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 08:41:27 +0200
Message-ID: <1314772887.4161.17.camel@jlt3.sipsolutions.net> (sfid-20110831_084143_735025_D1D9180E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-31 at 09:37 +0300, Dan Carpenter wrote:
> "vif" is assigned twice.  We can remove the first one.
> 
> This silences a Smatch warning that "ctx" could be one step past the
> end of the priv->contexts[] array.

Good catch.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 20dd1a5..72b9203 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -1842,7 +1842,7 @@ void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
>  				 enum iwl_rxon_context_id ctx,
>  				 u8 sta_id, u8 tid)
>  {
> -	struct ieee80211_vif *vif = priv->contexts[ctx].vif;
> +	struct ieee80211_vif *vif;
>  	u8 *addr = priv->stations[sta_id].sta.sta.addr;
>  
>  	if (ctx == NUM_IWL_RXON_CTX)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


