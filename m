Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112AbYKCT0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 14:26:07 -0500
Subject: Re: [PATCH] iwlagn: avoid sleep in softirq context
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1225475904-25184-1-git-send-email-linville@tuxdriver.com>
References: <1225399265.1115.356.camel@rc-desk>
	 <1225475904-25184-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:26:36 -0800
Message-Id: <1225740396.1115.453.camel@rc-desk> (sfid-20081103_202612_817138_48F6DB6A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-10-31 at 10:58 -0700, John W. Linville wrote:
> __ieee80211_tasklet_handler -> __ieee80211_rx ->
> 	__ieee80211_rx_handle_packet -> ieee80211_invoke_rx_handlers ->
> 	ieee80211_rx_h_decrypt -> ieee80211_crypto_tkip_decrypt ->
> 	ieee80211_tkip_decrypt_data -> iwl4965_mac_update_tkip_key ->
> 	iwl_scan_cancel_timeout -> msleep
> 
> Ooops!
> 
> Avoid the sleep by changing iwl_scan_cancel_timeout with
> iwl_scan_cancel and simply returning on failure if the scan persists.
> This will cause hardware decryption to fail and we'll handle a few more
> frames with software decryption.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 89450e3..5cca7bf 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3247,7 +3247,12 @@ static void iwl4965_mac_update_tkip_key(struct ieee80211_hw *hw,
>  		return;
>  	}
>  
> -	iwl_scan_cancel_timeout(priv, 100);
> +	if (iwl_scan_cancel(priv)) {
> +		/* cancel scan failed, just live w/ bad key and rely
> +		   briefly on SW decrpyption */
> +		IWL_DEBUG_MAC80211("leave - failed to cancel scan\n");
> +		return;
> +	}

Thanks for adding the debugging. The small typo is still there (in the
comments ... "decrpyption"). Could you please change it when you merge
this patch?

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


