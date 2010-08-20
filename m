Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:43572 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab0HTOoM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 10:44:12 -0400
Subject: Re: [PATCH w-t] iwlwifi: fix canceling monitor_recover timer
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100820132346.GA4725@redhat.com>
References: <20100820132346.GA4725@redhat.com>
Content-Type: text/plain
Date: Fri, 20 Aug 2010 07:43:38 -0700
Message-Id: <1282315418.2405.5.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-20 at 06:23 -0700, Stanislaw Gruszka wrote:
> To make del_timer_sync() works we have to assure that timer function
> does not rearm the timer. To achieve that we cancel timer with
> STATUS_EXIT_PENDING bit set in __iwl{3945,}_down function.
> 
> Patch also fix priv->txq memory usage after free for iwl3945, because
> it move timer cancellation before iwl3945_hw_txq_ctx_free(priv) is called.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 +++++--
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 +++++--
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 3ced9ea..26bc048 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -2764,6 +2764,11 @@ static void __iwl_down(struct iwl_priv *priv)
>  	if (!exit_pending)
>  		set_bit(STATUS_EXIT_PENDING, &priv->status);
>  
> +	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
> +	 * to prevent rearm timer */
> +	if (priv->cfg->ops->lib->recover_from_tx_stall)
> +		del_timer_sync(&priv->monitor_recover);
> +
>  	iwl_clear_ucode_stations(priv);
>  	iwl_dealloc_bcast_station(priv);
>  	iwl_clear_driver_stations(priv);
> @@ -3870,8 +3875,6 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
>  	cancel_work_sync(&priv->beacon_update);
>  	del_timer_sync(&priv->statistics_periodic);
>  	del_timer_sync(&priv->ucode_trace);
> -	if (priv->cfg->ops->lib->recover_from_tx_stall)
> -		del_timer_sync(&priv->monitor_recover);
>  }
>  
>  static void iwl_init_hw_rates(struct iwl_priv *priv,
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 94d7e6e..53e6cbb 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -2571,6 +2571,11 @@ static void __iwl3945_down(struct iwl_priv *priv)
>  	if (!exit_pending)
>  		set_bit(STATUS_EXIT_PENDING, &priv->status);
>  
> +	/* Stop TX queues watchdog. We need to have STATUS_EXIT_PENDING bit set
> +	 * to prevent rearm timer */
> +	if (priv->cfg->ops->lib->recover_from_tx_stall)
> +		del_timer_sync(&priv->monitor_recover);
> +
>  	/* Station information will now be cleared in device */
>  	iwl_clear_ucode_stations(priv);
>  	iwl_dealloc_bcast_station(priv);
> @@ -3811,8 +3816,6 @@ static void iwl3945_cancel_deferred_work(struct iwl_priv *priv)
>  	cancel_delayed_work(&priv->alive_start);
>  	cancel_work_sync(&priv->start_internal_scan);
>  	cancel_work_sync(&priv->beacon_update);
> -	if (priv->cfg->ops->lib->recover_from_tx_stall)
> -		del_timer_sync(&priv->monitor_recover);
>  }
>  
>  static struct attribute *iwl3945_sysfs_entries[] = {

Make sense, Thanks for catching this

Wey

