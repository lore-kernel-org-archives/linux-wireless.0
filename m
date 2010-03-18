Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45161 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab0CRRHm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 13:07:42 -0400
Subject: Re: [RFC PATCHv4 1/1] mac80211: Add support connection monitor in
 hardware
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@nokia.com
In-Reply-To: <1268896346-15397-2-git-send-email-juuso.oikarinen@nokia.com>
References: <1268896346-15397-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1268896346-15397-2-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Mar 2010 09:23:57 -0700
Message-ID: <1268929437.4005.10.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-18 at 09:12 +0200, Juuso Oikarinen wrote:
> This patch is based on a RFC patch by Kalle Valo.
> 
> The wl1271 has a feature which handles the connection monitor logic
> in hardware, basically sending periodically nullfunc frames and reporting
> to the host if AP is lost, after attempting to recover by sending
> probe-requests to the AP.
> 
> Add support to mac80211 by adding a new flag IEEE80211_HW_CONNECTION_MONITOR
> which prevents conn_mon_timer from triggering during idle periods, and
> prevents sending probe-requests to the AP if beacon-loss is indicated by the
> hardware.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>


> Cc: Kalle Valo <kalle.valo@nokia.com>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  include/net/mac80211.h     |   24 +++++++++++++++-
>  net/mac80211/ieee80211_i.h |    4 +-
>  net/mac80211/iface.c       |    2 +-
>  net/mac80211/mlme.c        |   64 +++++++++++++++++++++++++++++++++++++++-----
>  4 files changed, 82 insertions(+), 12 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 936bc41..d14226f 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -954,6 +954,11 @@ enum ieee80211_tkip_key_type {
>   *	Hardware can provide ack status reports of Tx frames to
>   *	the stack.
>   *
> + * @IEEE80211_HW_CONNECTION_MONITOR:
> + *      The hardware performs its own connection monitoring, including
> + *      periodic keep-alives to the AP and probing the AP on beacon loss.
> + *      When this flag is set, signaling beacon-loss will cause an immediate
> + *      change to disassociated state.
>   */
>  enum ieee80211_hw_flags {
>  	IEEE80211_HW_HAS_RATE_CONTROL			= 1<<0,
> @@ -975,6 +980,7 @@ enum ieee80211_hw_flags {
>  	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
>  	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
>  	IEEE80211_HW_REPORTS_TX_ACK_STATUS		= 1<<18,
> +	IEEE80211_HW_CONNECTION_MONITOR			= 1<<19,
>  };
>  
>  /**
> @@ -2364,12 +2370,26 @@ void ieee80211_sta_block_awake(struct ieee80211_hw *hw,
>   *
>   * @vif: &struct ieee80211_vif pointer from the add_interface callback.
>   *
> - * When beacon filtering is enabled with IEEE80211_HW_BEACON_FILTERING and
> - * IEEE80211_CONF_PS is set, the driver needs to inform whenever the
> + * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTERING and
> + * %IEEE80211_CONF_PS is set, the driver needs to inform whenever the
>   * hardware is not receiving beacons with this function.
>   */
>  void ieee80211_beacon_loss(struct ieee80211_vif *vif);
>  
> +/**
> + * ieee80211_connection_loss - inform hardware has lost connection to the AP
> + *
> + * @vif: &struct ieee80211_vif pointer from the add_interface callback.
> + *
> + * When beacon filtering is enabled with %IEEE80211_HW_BEACON_FILTERING, and
> + * %IEEE80211_CONF_PS and %IEEE80211_HW_CONNECTION_MONITOR are set, the driver
> + * needs to inform if the connection to the AP has been lost.
> + *
> + * This function will cause immediate change to disassociated state,
> + * without connection recovery attempts.
> + */
> +void ieee80211_connection_loss(struct ieee80211_vif *vif);
> +
>  /* Rate control API */
>  
>  /**
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index b841264..ab369e2 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -327,7 +327,7 @@ struct ieee80211_if_managed {
>  	struct work_struct work;
>  	struct work_struct monitor_work;
>  	struct work_struct chswitch_work;
> -	struct work_struct beacon_loss_work;
> +	struct work_struct beacon_connection_loss_work;
>  
>  	unsigned long probe_timeout;
>  	int probe_send_count;
> @@ -1156,7 +1156,7 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
>  			     int powersave);
>  void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
>  			     struct ieee80211_hdr *hdr);
> -void ieee80211_beacon_loss_work(struct work_struct *work);
> +void ieee80211_beacon_connection_loss_work(struct work_struct *work);
>  
>  void ieee80211_wake_queues_by_reason(struct ieee80211_hw *hw,
>  				     enum queue_stop_reason reason);
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index d5571b9..b4ec59a 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -486,7 +486,7 @@ static int ieee80211_stop(struct net_device *dev)
>  		cancel_work_sync(&sdata->u.mgd.work);
>  		cancel_work_sync(&sdata->u.mgd.chswitch_work);
>  		cancel_work_sync(&sdata->u.mgd.monitor_work);
> -		cancel_work_sync(&sdata->u.mgd.beacon_loss_work);
> +		cancel_work_sync(&sdata->u.mgd.beacon_connection_loss_work);
>  
>  		/*
>  		 * When we get here, the interface is marked down.
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index be5f723..6b43a0a 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -854,6 +854,9 @@ void ieee80211_sta_rx_notify(struct ieee80211_sub_if_data *sdata,
>  	if (is_multicast_ether_addr(hdr->addr1))
>  		return;
>  
> +	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
> +		return;
> +
>  	mod_timer(&sdata->u.mgd.conn_mon_timer,
>  		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
>  }
> @@ -931,23 +934,68 @@ static void ieee80211_mgd_probe_ap(struct ieee80211_sub_if_data *sdata,
>  	mutex_unlock(&ifmgd->mtx);
>  }
>  
> -void ieee80211_beacon_loss_work(struct work_struct *work)
> +static void __ieee80211_connection_loss(struct ieee80211_sub_if_data *sdata)
> +{
> +	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> +	struct ieee80211_local *local = sdata->local;
> +	u8 bssid[ETH_ALEN];
> +
> +	mutex_lock(&ifmgd->mtx);
> +	if (!ifmgd->associated) {
> +		mutex_unlock(&ifmgd->mtx);
> +		return;
> +	}
> +
> +	memcpy(bssid, ifmgd->associated->bssid, ETH_ALEN);
> +
> +	printk(KERN_DEBUG "Connection to AP %pM lost.\n", bssid);
> +
> +	ieee80211_set_disassoc(sdata);
> +	ieee80211_recalc_idle(local);
> +	mutex_unlock(&ifmgd->mtx);
> +	/*
> +	 * must be outside lock due to cfg80211,
> +	 * but that's not a problem.
> +	 */
> +	ieee80211_send_deauth_disassoc(sdata, bssid,
> +				       IEEE80211_STYPE_DEAUTH,
> +				       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
> +				       NULL);
> +}
> +
> +void ieee80211_beacon_connection_loss_work(struct work_struct *work)
>  {
>  	struct ieee80211_sub_if_data *sdata =
>  		container_of(work, struct ieee80211_sub_if_data,
> -			     u.mgd.beacon_loss_work);
> +			     u.mgd.beacon_connection_loss_work);
>  
> -	ieee80211_mgd_probe_ap(sdata, true);
> +	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
> +		__ieee80211_connection_loss(sdata);
> +	else
> +		ieee80211_mgd_probe_ap(sdata, true);
>  }
>  
>  void ieee80211_beacon_loss(struct ieee80211_vif *vif)
>  {
>  	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_hw *hw = &sdata->local->hw;
>  
> -	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
> +	WARN_ON(hw->flags & IEEE80211_HW_CONNECTION_MONITOR);
> +	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
>  }
>  EXPORT_SYMBOL(ieee80211_beacon_loss);
>  
> +void ieee80211_connection_loss(struct ieee80211_vif *vif)
> +{
> +	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
> +	struct ieee80211_hw *hw = &sdata->local->hw;
> +
> +	WARN_ON(!(hw->flags & IEEE80211_HW_CONNECTION_MONITOR));
> +	ieee80211_queue_work(hw, &sdata->u.mgd.beacon_connection_loss_work);
> +}
> +EXPORT_SYMBOL(ieee80211_connection_loss);
> +
> +
>  static enum rx_mgmt_action __must_check
>  ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
>  			 struct ieee80211_mgmt *mgmt, size_t len)
> @@ -1637,7 +1685,8 @@ static void ieee80211_sta_bcn_mon_timer(unsigned long data)
>  	if (local->quiescing)
>  		return;
>  
> -	ieee80211_queue_work(&sdata->local->hw, &sdata->u.mgd.beacon_loss_work);
> +	ieee80211_queue_work(&sdata->local->hw,
> +			     &sdata->u.mgd.beacon_connection_loss_work);
>  }
>  
>  static void ieee80211_sta_conn_mon_timer(unsigned long data)
> @@ -1689,7 +1738,7 @@ void ieee80211_sta_quiesce(struct ieee80211_sub_if_data *sdata)
>  	 */
>  
>  	cancel_work_sync(&ifmgd->work);
> -	cancel_work_sync(&ifmgd->beacon_loss_work);
> +	cancel_work_sync(&ifmgd->beacon_connection_loss_work);
>  	if (del_timer_sync(&ifmgd->timer))
>  		set_bit(TMR_RUNNING_TIMER, &ifmgd->timers_running);
>  
> @@ -1723,7 +1772,8 @@ void ieee80211_sta_setup_sdata(struct ieee80211_sub_if_data *sdata)
>  	INIT_WORK(&ifmgd->work, ieee80211_sta_work);
>  	INIT_WORK(&ifmgd->monitor_work, ieee80211_sta_monitor_work);
>  	INIT_WORK(&ifmgd->chswitch_work, ieee80211_chswitch_work);
> -	INIT_WORK(&ifmgd->beacon_loss_work, ieee80211_beacon_loss_work);
> +	INIT_WORK(&ifmgd->beacon_connection_loss_work,
> +		  ieee80211_beacon_connection_loss_work);
>  	setup_timer(&ifmgd->timer, ieee80211_sta_timer,
>  		    (unsigned long) sdata);
>  	setup_timer(&ifmgd->bcn_mon_timer, ieee80211_sta_bcn_mon_timer,


