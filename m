Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:25446 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620Ab1CaQST (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:18:19 -0400
Subject: Re: [PATCH 2/3] iwlwifi: more priv->mutex serialization
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1301585788-7331-2-git-send-email-sgruszka@redhat.com>
References: <1301585788-7331-1-git-send-email-sgruszka@redhat.com>
	 <1301585788-7331-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 31 Mar 2011 09:15:50 -0700
Message-ID: <1301588150.22383.9.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-31 at 08:36 -0700, Stanislaw Gruszka wrote:
> Check status bits with mutex taken, because when we wait for mutex
> unlock, status can change. Patch should also make remaining sync
> commands be send with priv->mutex taken. That will prevent execute
> these commands when we are currently reset firmware, what could
> possibly cause troubles.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |   34 ++++++++++++++++++-------------
>  1 files changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 7adc60e..0c49d1a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -483,12 +483,14 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
>  		container_of(work, struct iwl_priv, bt_full_concurrency);
>  	struct iwl_rxon_context *ctx;
>  
> +	mutex_lock(&priv->mutex);
> +
>  	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> -		return;
> +		goto out;
>  
>  	/* dont send host command if rf-kill is on */
>  	if (!iwl_is_ready_rf(priv))
> -		return;
> +		goto out;
>  
>  	IWL_DEBUG_INFO(priv, "BT coex in %s mode\n",
>  		       priv->bt_full_concurrent ?
> @@ -498,15 +500,15 @@ static void iwl_bg_bt_full_concurrency(struct work_struct *work)
>  	 * LQ & RXON updated cmds must be sent before BT Config cmd
>  	 * to avoid 3-wire collisions
>  	 */
> -	mutex_lock(&priv->mutex);
>  	for_each_context(priv, ctx) {
>  		if (priv->cfg->ops->hcmd->set_rxon_chain)
>  			priv->cfg->ops->hcmd->set_rxon_chain(priv, ctx);
>  		iwlcore_commit_rxon(priv, ctx);
>  	}
> -	mutex_unlock(&priv->mutex);
>  
>  	priv->cfg->ops->hcmd->send_bt_config(priv);
> +out:
> +	mutex_unlock(&priv->mutex);
>  }
>  
>  /**
> @@ -2814,10 +2816,13 @@ static void iwl_bg_init_alive_start(struct work_struct *data)
>  	struct iwl_priv *priv =
>  	    container_of(data, struct iwl_priv, init_alive_start.work);
>  
> -	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> +	mutex_lock(&priv->mutex);
> +
> +	if (test_bit(STATUS_EXIT_PENDING, &priv->status)) {
> +		mutex_unlock(&priv->mutex);
>  		return;
> +	}
>  
> -	mutex_lock(&priv->mutex);
>  	priv->cfg->ops->lib->init_alive_start(priv);
>  	mutex_unlock(&priv->mutex);
>  }
> @@ -2827,15 +2832,16 @@ static void iwl_bg_alive_start(struct work_struct *data)
>  	struct iwl_priv *priv =
>  	    container_of(data, struct iwl_priv, alive_start.work);
>  
> +	mutex_lock(&priv->mutex);
>  	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> -		return;
> +		goto unlock;
>  
>  	/* enable dram interrupt */
>  	if (priv->cfg->ops->lib->isr_ops.reset)
>  		priv->cfg->ops->lib->isr_ops.reset(priv);
>  
> -	mutex_lock(&priv->mutex);
>  	iwl_alive_start(priv);
> +unlock:
>  	mutex_unlock(&priv->mutex);
>  }
>  
> @@ -3457,21 +3463,22 @@ void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
>  
>  	IWL_DEBUG_MAC80211(priv, "enter\n");
>  
> +	mutex_lock(&priv->mutex);
> +
>  	if (iwl_is_rfkill(priv))
> -		goto out_exit;
> +		goto out;
>  
>  	if (test_bit(STATUS_EXIT_PENDING, &priv->status) ||
>  	    test_bit(STATUS_SCANNING, &priv->status))
> -		goto out_exit;
> +		goto out;
>  
>  	if (!iwl_is_associated_ctx(ctx))
> -		goto out_exit;
> +		goto out;
>  
>  	/* channel switch in progress */
>  	if (priv->switch_rxon.switch_in_progress == true)
> -		goto out_exit;
> +		goto out;
>  
> -	mutex_lock(&priv->mutex);
>  	if (priv->cfg->ops->lib->set_channel_switch) {
>  
>  		ch = channel->hw_value;
> @@ -3527,7 +3534,6 @@ void iwlagn_mac_channel_switch(struct ieee80211_hw *hw,
>  	}
>  out:
>  	mutex_unlock(&priv->mutex);
> -out_exit:
>  	if (!priv->switch_rxon.switch_in_progress)
>  		ieee80211_chswitch_done(ctx->vif, false);
>  	IWL_DEBUG_MAC80211(priv, "leave\n");


