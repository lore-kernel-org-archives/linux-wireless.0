Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60255 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751706Ab0I3XwK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 19:52:10 -0400
Subject: Re: [PATCH] iwlwifi: change WARN_ON to IWL_WARN in
 iwl_mac_add_interface
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100930142734.GA2368@redhat.com>
References: <20100930142734.GA2368@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 16:52:07 -0700
Message-ID: <1285890728.12056.50.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-09-30 at 07:27 -0700, Stanislaw Gruszka wrote:
> We can start restarting firmware or RF kill switch can be turned on
> during call to iwl_mac_add_interface(). That are normal working
> conditions, so do not print call trace, just print simple message
> instead.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
> index 5c56893..b7adcf8 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -2003,7 +2003,8 @@ int iwl_mac_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
>  
>  	mutex_lock(&priv->mutex);
>  
> -	if (WARN_ON(!iwl_is_ready_rf(priv))) {
> +	if (!iwl_is_ready_rf(priv)) {
> +		IWL_WARN(priv, "Try to add interface when device not ready\n");
>  		err = -EINVAL;
>  		goto out;
>  	}


