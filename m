Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43637 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753283Ab1BHP4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:56:41 -0500
Subject: Re: [RFC/RFT] iwlwifi: module parameters for health check
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297172303-17487-1-git-send-email-sgruszka@redhat.com>
References: <1297172303-17487-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:54:57 -0800
Message-ID: <1297180497.20613.45.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, 2011-02-08 at 05:38 -0800, Stanislaw Gruszka wrote:
> Currently we unconditionally check "health" and reset radio or whole
> device when bad state is detected.
> 
> However that not always work correctly. Particularly plcp check is
> causing very low speed problems on 3945 and low ack check make 5xxx
> devices randomly stop working.
> 
> Patch module option to allow to disable this checks. Actually it
> make checks disabled by default, since IMHO they are causing more
> troubles than give help, but that need to be tested.
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c  |    7 +++++++
>  drivers/net/wireless/iwlwifi/iwl-core.h |    2 ++
>  drivers/net/wireless/iwlwifi/iwl-rx.c   |    6 ++++--
>  3 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 2d83f9f..65cfe12 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -4795,3 +4795,10 @@ MODULE_PARM_DESC(antenna_coupling,
>  module_param_named(bt_ch_inhibition, iwlagn_bt_ch_announce, bool, S_IRUGO);
>  MODULE_PARM_DESC(bt_ch_inhibition,
>  		 "Disable BT channel inhibition (default: enable)");
> +
> +module_param_named(plcp_check, iwlagn_mod_params.plcp_check, bool, S_IRUGO);
> +MODULE_PARM_DESC(plcp_check, "Check plcp health (default: 0 [disabled])");
> +
> +module_param_named(ack_check, iwlagn_mod_params.ack_check, bool, S_IRUGO);
> +MODULE_PARM_DESC(ack_check, "Check ack health (default: 0 [disabled])");
> +
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
> index 9e7a6d1..96f07d4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.h
> @@ -261,6 +261,8 @@ struct iwl_mod_params {
>  	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
>  	int antenna;  		/* def: 0 = both antennas (use diversity) */
>  	int restart_fw;		/* def: 1 = restart firmware */
> +	bool plcp_check;	/* def: false = disable plcp health check */
> +	bool ack_check;		/* def: false = disable ack health check */
>  };
>  
>  /*
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
> index b9c2591..8a1a483 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
> @@ -238,14 +238,16 @@ void iwl_recover_from_statistics(struct iwl_priv *priv,
>  	    !iwl_is_any_associated(priv))
>  		return;
>  
> -	if (priv->cfg->ops->lib->check_ack_health &&
> +	if (priv->cfg->mod_params->ack_check &&
> +	    priv->cfg->ops->lib->check_ack_health &&
>  	    !priv->cfg->ops->lib->check_ack_health(priv, pkt)) {
>  		IWL_ERR(priv, "low ack count detected, restart firmware\n");
>  		if (!iwl_force_reset(priv, IWL_FW_RESET, false))
>  			return;
>  	}
>  
> -	if (priv->cfg->ops->lib->check_plcp_health &&
> +	if (priv->cfg->mod_params->plcp_check &&
> +	    priv->cfg->ops->lib->check_plcp_health &&
>  	    !priv->cfg->ops->lib->check_plcp_health(priv, pkt, msecs))
>  		iwl_force_reset(priv, IWL_RF_RESET, false);
>  }

I am even thinking remove it for 3945 all together.

for agn device, I agree disable "low_ack_check" by default, not so sure
about plcp_health

Wey 


