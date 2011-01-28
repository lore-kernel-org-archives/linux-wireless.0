Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35989 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1A1QWW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jan 2011 11:22:22 -0500
Subject: Re: [PATCH 6/8] iwl3945: do not use agn specific IWL_RATE_COUNT
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1296229671-3041-6-git-send-email-sgruszka@redhat.com>
References: <1296229671-3041-1-git-send-email-sgruszka@redhat.com>
	 <1296229671-3041-6-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jan 2011 08:20:48 -0800
Message-ID: <1296231648.7388.16.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

On Fri, 2011-01-28 at 07:47 -0800, Stanislaw Gruszka wrote:
> Only use IWL_RATE_COUNT_3945 in 3945 code.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |    5 ++---
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.h   |    1 +
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index 294221b..58213e7 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -762,8 +762,7 @@ void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
>  
>  	/* We need to figure out how to get the sta->supp_rates while
>  	 * in this running context */
> -	rate_mask = IWL_RATES_MASK;
> -
> +	rate_mask = IWL_RATES_MASK_3945;
>  
>  	/* Set retry limit on DATA packets and Probe Responses*/
>  	if (ieee80211_is_probe_resp(fc))
> @@ -1650,7 +1649,7 @@ static int iwl3945_hw_reg_comp_txpower_temp(struct iwl_priv *priv)
>  							      ref_temp);
>  
>  		/* set tx power value for all rates, OFDM and CCK */
> -		for (rate_index = 0; rate_index < IWL_RATE_COUNT;
> +		for (rate_index = 0; rate_index < IWL_RATE_COUNT_3945;
>  		     rate_index++) {
>  			int power_idx =
>  			    ch_info->power_info[rate_index].base_power_index;
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> index 75e50d3..184828c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.h
> @@ -213,6 +213,7 @@ enum {
>  	 IWL_CCK_BASIC_RATES_MASK)
>  
>  #define IWL_RATES_MASK ((1 << IWL_RATE_COUNT) - 1)
> +#define IWL_RATES_MASK_3945 ((1 << IWL_RATE_COUNT_3945) - 1)
>  

Why define 3945 in agn header file?
I understand iwl-agn-rs.h is include in iwl-dev.h, which is not the
right thing to do. but specify 3945 in agn header file make it even more
confuse.


Wey

