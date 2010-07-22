Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24634 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab0GVThQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 15:37:16 -0400
Subject: Re: [PATCH] iwlwifi: assume vif is NULL for internal scans and
 non-NULL otherwise
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Dan Carpenter <error27@gmail.com>
In-Reply-To: <1279826937-24581-1-git-send-email-linville@tuxdriver.com>
References: <20100721221616.GT17585@bicker>
	 <1279826937-24581-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain
Date: Thu, 22 Jul 2010 12:36:39 -0700
Message-Id: <1279827399.9034.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Thu, 2010-07-22 at 12:28 -0700, John W. Linville wrote:
> The current practice of checking vif for NULL in one place but not
> another seems to confuse some static checkers, smatch in particular.
> Since vif will only be NULL in the case of internal scans, adjust the
> checks accordingly.
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c  |    5 ++++-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    5 ++++-
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> index 74623e0..0ca0df4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
> @@ -1234,7 +1234,10 @@ void iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  
>  		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
>  		spin_lock_irqsave(&priv->lock, flags);
> -		interval = vif ? vif->bss_conf.beacon_int : 0;
> +		if (priv->is_internal_short_scan)
> +			interval = 0;
> +		else
> +			interval = vif->bss_conf.beacon_int;
>  		spin_unlock_irqrestore(&priv->lock, flags);
>  
>  		scan->suspend_time = 0;
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 8eb3471..b102bab 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2883,7 +2883,10 @@ void iwl3945_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
>  		IWL_DEBUG_INFO(priv, "Scanning while associated...\n");
>  
>  		spin_lock_irqsave(&priv->lock, flags);
> -		interval = vif ? vif->bss_conf.beacon_int : 0;
> +		if (priv->is_internal_short_scan)
> +			interval = 0;
> +		else
> +			interval = vif->bss_conf.beacon_int;
>  		spin_unlock_irqrestore(&priv->lock, flags);
>  
>  		scan->suspend_time = 0;

Make sense, Thanks.

Wey

