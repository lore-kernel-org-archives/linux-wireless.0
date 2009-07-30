Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:46063 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbZG3S2D (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 14:28:03 -0400
Subject: Re: [PATCH] iwlwifi: don't export symbols not needed in other
 modules
From: reinette chatre <reinette.chatre@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1248947897.8925.13.camel@johannes.local>
References: <1248947897.8925.13.camel@johannes.local>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 11:28:02 -0700
Message-Id: <1248978482.1216.1087.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Thu, 2009-07-30 at 02:58 -0700, Johannes Berg wrote:
> Even with the split into iwlcore/agn/3945 not all symbols
> that cross file boundaries are needed in other modules, a
> few are only used within iwlcore, for example.

I think in this case we need to be explicit when talking about "need"
and "used". Yes, some of these exported symbols are only used within a
module and this needs to be fixed. At the same time, some of these may
be needed outside, but are just not currently used. Examples of the
latter are: iwl_remove_station, iwl_rx_ant_restriction, and
iwl_send_card_state. I think this is especially important for
iwl_remove_station and iwl_rx_ant_restriction because their partners
(iwl_add_station and iwl_tx_ant_restriction) are exported and used and I
think it will be clean if they are also, even if they are not currently
used.

I'm thus ok with the removal of symbols iwl_set_flags_for_band,
iwl_clear_isr_stats, iwl_leds_background, and iwl_rx_queue_reset.


> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    3 ---
>  drivers/net/wireless/iwlwifi/iwl-led.c  |    1 -
>  drivers/net/wireless/iwlwifi/iwl-rx.c   |    1 -
>  drivers/net/wireless/iwlwifi/iwl-sta.c  |    1 -
>  4 files changed, 6 deletions(-)
> 
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-07-30 11:42:11.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-07-30 11:51:28.000000000 +0200
> @@ -1139,7 +1139,6 @@ void iwl_set_flags_for_band(struct iwl_p
>  		priv->staging_rxon.flags &= ~RXON_FLG_CCK_MSK;
>  	}
>  }
> -EXPORT_SYMBOL(iwl_set_flags_for_band);
>  
>  /*
>   * initialize rxon structure with default values from eeprom
> @@ -2289,7 +2288,6 @@ int iwl_send_card_state(struct iwl_priv 
>  
>  	return iwl_send_cmd(priv, &cmd);
>  }
> -EXPORT_SYMBOL(iwl_send_card_state);
>  
>  void iwl_rx_pm_sleep_notif(struct iwl_priv *priv,
>  			   struct iwl_rx_mem_buffer *rxb)
> @@ -2333,7 +2331,6 @@ void iwl_clear_isr_stats(struct iwl_priv
>  {
>  	memset(&priv->isr_stats, 0, sizeof(priv->isr_stats));
>  }
> -EXPORT_SYMBOL(iwl_clear_isr_stats);
>  
>  int iwl_mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
>  			   const struct ieee80211_tx_queue_params *params)
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-led.c	2009-07-30 11:42:11.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-led.c	2009-07-30 11:50:58.000000000 +0200
> @@ -335,7 +335,6 @@ void iwl_leds_background(struct iwl_priv
>  	priv->last_blink_time = jiffies;
>  	priv->last_blink_rate = blink_idx;
>  }
> -EXPORT_SYMBOL(iwl_leds_background);
>  
>  /* Register all led handler */
>  int iwl_leds_register(struct iwl_priv *priv)
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-07-30 11:42:11.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c	2009-07-30 11:51:15.000000000 +0200
> @@ -406,7 +406,6 @@ void iwl_rx_queue_reset(struct iwl_priv 
>  	rxq->free_count = 0;
>  	spin_unlock_irqrestore(&rxq->lock, flags);
>  }
> -EXPORT_SYMBOL(iwl_rx_queue_reset);
>  
>  int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
>  {
> --- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-07-30 11:42:11.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-sta.c	2009-07-30 11:51:07.000000000 +0200
> @@ -464,7 +464,6 @@ out:
>  	spin_unlock_irqrestore(&priv->sta_lock, flags);
>  	return ret;
>  }
> -EXPORT_SYMBOL(iwl_remove_station);
>  
>  /**
>   * iwl_clear_stations_table - Clear the driver's station table
> 
> 

Reinette

