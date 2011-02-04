Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55270 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab1BDT4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 14:56:52 -0500
Subject: Re: [PATCH v10] mac80211: Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296849257-10260-1-git-send-email-greearb@candelatech.com>
References: <1296849257-10260-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Feb 2011 20:56:50 +0100
Message-ID: <1296849410.3671.15.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm not going to be able to review this properly until I get back -- so
maybe we should just merge it and fix fallout, if any, later?

johannes

On Fri, 2011-02-04 at 11:54 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> This should decrease un-necessary flushes, on/off channel work,
> and channel changes in cases where the only scanned channel is
> the current operating channel.
> 
> * Removes SCAN_OFF_CHANNEL flag, uses SDATA_STATE_OFFCHANNEL
>   and is-scanning flags instead.
> 
> * Add helper method to determine if we are currently configured
>   for the operating channel.
> 
> * Do no blindly go off/on channel in work.c  Instead, only call
>   appropriate on/off code when we really need to change channels.
>   Always enable offchannel-ps mode when starting work,
>   and disable it when we are done.
> 
> * Consolidate ieee80211_offchannel_stop_station and
>   ieee80211_offchannel_stop_beaconing, call it
>   ieee80211_offchannel_stop_vifs instead.
> 
> * Accept non-beacon frames when scanning on operating channel.
> 
> * Scan state machine optimized to minimize on/off channel
>   transitions.  Also, when going on-channel, go ahead and
>   re-enable beaconing.  We're going to be there for 200ms,
>   so seems like some useful beaconing could happen.
>   Always enable offchannel-ps mode when starting software
>   scan, and disable it when we are done.
> 
> * Grab local->mtx earlier in __ieee80211_scan_completed_finish
>   so that we are protected when calling hw_config(), etc.
> 
> * Pass probe-responses up the stack if scanning on local
>   channel, so that mlme can take a look.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> v10:  Make sure NIC is awake when scanning, and allowed to go
>   back to sleep when done scanning.
>   Make sure offchannel-ps mode is enabled for work_work items
>   regardless of whether work is on the operating channel or not.
>   And always disable offchannel-ps mode when done with work.
> 
> :100644 100644 533fd32... ea14d73... M	net/mac80211/ieee80211_i.h
> :100644 100644 09a2744... c155c0b... M	net/mac80211/main.c
> :100644 100644 b4e5267... 13427b1... M	net/mac80211/offchannel.c
> :100644 100644 c08b8e9... a448856... M	net/mac80211/rx.c
> :100644 100644 f246d8a... 93da164... M	net/mac80211/scan.c
> :100644 100644 8fbbc7a... 7b7a503... M	net/mac80211/tx.c
> :100644 100644 36305e0... 6bf787a... M	net/mac80211/work.c
>  net/mac80211/ieee80211_i.h |   13 +++---
>  net/mac80211/main.c        |   53 +++++++++++++++++++++++---
>  net/mac80211/offchannel.c  |   68 ++++++++++++++++++---------------
>  net/mac80211/rx.c          |   12 +----
>  net/mac80211/scan.c        |   88 +++++++++++++++++++++++++++++++------------
>  net/mac80211/tx.c          |    3 +-
>  net/mac80211/work.c        |   66 +++++++++++++++++++++++++++-----
>  7 files changed, 214 insertions(+), 89 deletions(-)
> 
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index 533fd32..ea14d73 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -654,8 +654,6 @@ struct tpt_led_trigger {
>   *	well be on the operating channel
>   * @SCAN_HW_SCANNING: The hardware is scanning for us, we have no way to
>   *	determine if we are on the operating channel or not
> - * @SCAN_OFF_CHANNEL: We're off our operating channel for scanning,
> - *	gets only set in conjunction with SCAN_SW_SCANNING
>   * @SCAN_COMPLETED: Set for our scan work function when the driver reported
>   *	that the scan completed.
>   * @SCAN_ABORTED: Set for our scan work function when the driver reported
> @@ -664,7 +662,6 @@ struct tpt_led_trigger {
>  enum {
>  	SCAN_SW_SCANNING,
>  	SCAN_HW_SCANNING,
> -	SCAN_OFF_CHANNEL,
>  	SCAN_COMPLETED,
>  	SCAN_ABORTED,
>  };
> @@ -1147,10 +1144,14 @@ void ieee80211_rx_bss_put(struct ieee80211_local *local,
>  			  struct ieee80211_bss *bss);
>  
>  /* off-channel helpers */
> -void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local);
> -void ieee80211_offchannel_stop_station(struct ieee80211_local *local);
> +bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local);
> +void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
> +					bool tell_ap);
> +void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
> +				    bool offchannel_ps_enable);
>  void ieee80211_offchannel_return(struct ieee80211_local *local,
> -				 bool enable_beaconing);
> +				 bool enable_beaconing,
> +				 bool offchannel_ps_disable);
>  void ieee80211_hw_roc_setup(struct ieee80211_local *local);
>  
>  /* interface handling */
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index 09a2744..c155c0b 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -98,6 +98,41 @@ static void ieee80211_reconfig_filter(struct work_struct *work)
>  	ieee80211_configure_filter(local);
>  }
>  
> +/*
> + * Returns true if we are logically configured to be on
> + * the operating channel AND the hardware-conf is currently
> + * configured on the operating channel.  Compares channel-type
> + * as well.
> + */
> +bool ieee80211_cfg_on_oper_channel(struct ieee80211_local *local)
> +{
> +	struct ieee80211_channel *chan, *scan_chan;
> +	enum nl80211_channel_type channel_type;
> +
> +	/* This logic needs to match logic in ieee80211_hw_config */
> +	if (local->scan_channel) {
> +		chan = local->scan_channel;
> +		channel_type = NL80211_CHAN_NO_HT;
> +	} else if (local->tmp_channel) {
> +		chan = scan_chan = local->tmp_channel;
> +		channel_type = local->tmp_channel_type;
> +	} else {
> +		chan = local->oper_channel;
> +		channel_type = local->_oper_channel_type;
> +	}
> +
> +	if (chan != local->oper_channel ||
> +	    channel_type != local->_oper_channel_type)
> +		return false;
> +
> +	/* Check current hardware-config against oper_channel. */
> +	if ((local->oper_channel != local->hw.conf.channel) ||
> +	    (local->_oper_channel_type != local->hw.conf.channel_type))
> +		return false;
> +
> +	return true;
> +}
> +
>  int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>  {
>  	struct ieee80211_channel *chan, *scan_chan;
> @@ -110,21 +145,27 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>  
>  	scan_chan = local->scan_channel;
>  
> +	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
> +	 * may need to change as well.
> +	 */
>  	offchannel_flag = local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
>  	if (scan_chan) {
>  		chan = scan_chan;
>  		channel_type = NL80211_CHAN_NO_HT;
> -		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
> -	} else if (local->tmp_channel &&
> -		   local->oper_channel != local->tmp_channel) {
> +	} else if (local->tmp_channel) {
>  		chan = scan_chan = local->tmp_channel;
>  		channel_type = local->tmp_channel_type;
> -		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
>  	} else {
>  		chan = local->oper_channel;
>  		channel_type = local->_oper_channel_type;
> -		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
>  	}
> +
> +	if (chan != local->oper_channel ||
> +	    channel_type != local->_oper_channel_type)
> +		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
> +	else
> +		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
> +
>  	offchannel_flag ^= local->hw.conf.flags & IEEE80211_CONF_OFFCHANNEL;
>  
>  	if (offchannel_flag || chan != local->hw.conf.channel ||
> @@ -231,7 +272,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  
>  	if (changed & BSS_CHANGED_BEACON_ENABLED) {
>  		if (local->quiescing || !ieee80211_sdata_running(sdata) ||
> -		    test_bit(SCAN_SW_SCANNING, &local->scanning)) {
> +		    test_bit(SDATA_STATE_OFFCHANNEL, &sdata->state)) {
>  			sdata->vif.bss_conf.enable_beacon = false;
>  		} else {
>  			/*
> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
> index b4e5267..13427b1 100644
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -17,10 +17,14 @@
>  #include "driver-trace.h"
>  
>  /*
> - * inform AP that we will go to sleep so that it will buffer the frames
> - * while we scan
> + * Tell our hardware to disable PS.
> + * Optionally inform AP that we will go to sleep so that it will buffer
> + * the frames while we are doing off-channel work.  This is optional
> + * because we *may* be doing work on-operating channel, and want our
> + * hardware unconditionally awake, but still let the AP send us normal frames.
>   */
> -static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
> +static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata,
> +					   bool tell_ap)
>  {
>  	struct ieee80211_local *local = sdata->local;
>  	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
> @@ -41,8 +45,8 @@ static void ieee80211_offchannel_ps_enable(struct ieee80211_sub_if_data *sdata)
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>  	}
>  
> -	if (!(local->offchannel_ps_enabled) ||
> -	    !(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK))
> +	if (tell_ap && (!local->offchannel_ps_enabled ||
> +			!(local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)))
>  		/*
>  		 * If power save was enabled, no need to send a nullfunc
>  		 * frame because AP knows that we are sleeping. But if the
> @@ -77,6 +81,9 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
>  		 * we are sleeping, let's just enable power save mode in
>  		 * hardware.
>  		 */
> +		/* TODO:  Only set hardware if CONF_PS changed?
> +		 * TODO:  Should we set offchannel_ps_enabled to false?
> +		 */
>  		local->hw.conf.flags |= IEEE80211_CONF_PS;
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>  	} else if (local->hw.conf.dynamic_ps_timeout > 0) {
> @@ -95,63 +102,61 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
>  	ieee80211_sta_reset_conn_monitor(sdata);
>  }
>  
> -void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
> +void ieee80211_offchannel_stop_vifs(struct ieee80211_local *local,
> +				    bool offchannel_ps_enable)
>  {
>  	struct ieee80211_sub_if_data *sdata;
>  
> +	/*
> +	 * notify the AP about us leaving the channel and stop all
> +	 * STA interfaces.
> +	 */
>  	mutex_lock(&local->iflist_mtx);
>  	list_for_each_entry(sdata, &local->interfaces, list) {
>  		if (!ieee80211_sdata_running(sdata))
>  			continue;
>  
> -		/* disable beaconing */
> +		if (sdata->vif.type != NL80211_IFTYPE_MONITOR)
> +			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
> +
> +		/* Check to see if we should disable beaconing. */
>  		if (sdata->vif.type == NL80211_IFTYPE_AP ||
>  		    sdata->vif.type == NL80211_IFTYPE_ADHOC ||
>  		    sdata->vif.type == NL80211_IFTYPE_MESH_POINT)
>  			ieee80211_bss_info_change_notify(
>  				sdata, BSS_CHANGED_BEACON_ENABLED);
>  
> -		/*
> -		 * only handle non-STA interfaces here, STA interfaces
> -		 * are handled in ieee80211_offchannel_stop_station(),
> -		 * e.g., from the background scan state machine.
> -		 *
> -		 * In addition, do not stop monitor interface to allow it to be
> -		 * used from user space controlled off-channel operations.
> -		 */
> -		if (sdata->vif.type != NL80211_IFTYPE_STATION &&
> -		    sdata->vif.type != NL80211_IFTYPE_MONITOR) {
> -			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
> +		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
>  			netif_tx_stop_all_queues(sdata->dev);
> +			if (offchannel_ps_enable &&
> +			    (sdata->vif.type == NL80211_IFTYPE_STATION) &&
> +			    sdata->u.mgd.associated)
> +				ieee80211_offchannel_ps_enable(sdata, true);
>  		}
>  	}
>  	mutex_unlock(&local->iflist_mtx);
>  }
>  
> -void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
> +void ieee80211_offchannel_enable_all_ps(struct ieee80211_local *local,
> +					bool tell_ap)
>  {
>  	struct ieee80211_sub_if_data *sdata;
>  
> -	/*
> -	 * notify the AP about us leaving the channel and stop all STA interfaces
> -	 */
>  	mutex_lock(&local->iflist_mtx);
>  	list_for_each_entry(sdata, &local->interfaces, list) {
>  		if (!ieee80211_sdata_running(sdata))
>  			continue;
>  
> -		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> -			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
> -			netif_tx_stop_all_queues(sdata->dev);
> -			if (sdata->u.mgd.associated)
> -				ieee80211_offchannel_ps_enable(sdata);
> -		}
> +		if (sdata->vif.type == NL80211_IFTYPE_STATION &&
> +		    sdata->u.mgd.associated)
> +			ieee80211_offchannel_ps_enable(sdata, tell_ap);
>  	}
>  	mutex_unlock(&local->iflist_mtx);
>  }
>  
>  void ieee80211_offchannel_return(struct ieee80211_local *local,
> -				 bool enable_beaconing)
> +				 bool enable_beaconing,
> +				 bool offchannel_ps_disable)
>  {
>  	struct ieee80211_sub_if_data *sdata;
>  
> @@ -161,7 +166,8 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
>  			continue;
>  
>  		/* Tell AP we're back */
> -		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +		if (offchannel_ps_disable &&
> +		    sdata->vif.type == NL80211_IFTYPE_STATION) {
>  			if (sdata->u.mgd.associated)
>  				ieee80211_offchannel_ps_disable(sdata);
>  		}
> @@ -181,7 +187,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
>  			netif_tx_wake_all_queues(sdata->dev);
>  		}
>  
> -		/* re-enable beaconing */
> +		/* Check to see if we should re-enable beaconing */
>  		if (enable_beaconing &&
>  		    (sdata->vif.type == NL80211_IFTYPE_AP ||
>  		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index c08b8e9..a448856 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -409,16 +409,10 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>  	if (likely(!(status->rx_flags & IEEE80211_RX_IN_SCAN)))
>  		return RX_CONTINUE;
>  
> -	if (test_bit(SCAN_HW_SCANNING, &local->scanning))
> +	if (test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> +	    test_bit(SCAN_SW_SCANNING, &local->scanning))
>  		return ieee80211_scan_rx(rx->sdata, skb);
>  
> -	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
> -		/* drop all the other packets during a software scan anyway */
> -		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
> -			dev_kfree_skb(skb);
> -		return RX_QUEUED;
> -	}
> -
>  	/* scanning finished during invoking of handlers */
>  	I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
>  	return RX_DROP_UNUSABLE;
> @@ -2790,7 +2784,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
>  		local->dot11ReceivedFragmentCount++;
>  
>  	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> -		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
> +		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
>  		status->rx_flags |= IEEE80211_RX_IN_SCAN;
>  
>  	if (ieee80211_is_mgmt(fc))
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index f246d8a..93da164 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -212,6 +212,14 @@ ieee80211_scan_rx(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>  	if (bss)
>  		ieee80211_rx_bss_put(sdata->local, bss);
>  
> +	/* If we are on-operating-channel, and this packet is for the
> +	 * current channel, pass the pkt on up the stack so that
> +	 * the rest of the stack can make use of it.
> +	 */
> +	if (ieee80211_cfg_on_oper_channel(sdata->local)
> +	    && (channel == sdata->local->oper_channel))
> +		return RX_CONTINUE;
> +
>  	dev_kfree_skb(skb);
>  	return RX_QUEUED;
>  }
> @@ -293,15 +301,31 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>  					      bool was_hw_scan)
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
> +	bool on_oper_chan;
> +	bool enable_beacons = false;
> +
> +	mutex_lock(&local->mtx);
> +	on_oper_chan = ieee80211_cfg_on_oper_channel(local);
> +
> +	if (was_hw_scan || !on_oper_chan) {
> +		if (WARN_ON(local->scan_channel))
> +			local->scan_channel = NULL;
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +	}
>  
> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>  	if (!was_hw_scan) {
> +		bool on_oper_chan2;
>  		ieee80211_configure_filter(local);
>  		drv_sw_scan_complete(local);
> -		ieee80211_offchannel_return(local, true);
> +		on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
> +		/* We should always be on-channel at this point. */
> +		WARN_ON(!on_oper_chan2);
> +		if (on_oper_chan2 && (on_oper_chan != on_oper_chan2))
> +			enable_beacons = true;
> +
> +		ieee80211_offchannel_return(local, enable_beacons, true);
>  	}
>  
> -	mutex_lock(&local->mtx);
>  	ieee80211_recalc_idle(local);
>  	mutex_unlock(&local->mtx);
>  
> @@ -398,13 +422,15 @@ static int ieee80211_start_sw_scan(struct ieee80211_local *local)
>  
>  	drv_sw_scan_start(local);
>  
> -	ieee80211_offchannel_stop_beaconing(local);
> -
>  	local->leave_oper_channel_time = 0;
>  	local->next_scan_state = SCAN_DECISION;
>  	local->scan_channel_idx = 0;
>  
> -	drv_flush(local, false);
> +	/* We always want to use off-channel PS, even if we
> +	 * are not really leaving oper-channel.  Don't
> +	 * tell the AP though, as long as we are on-channel.
> +	 */
> +	ieee80211_offchannel_enable_all_ps(local, false);
>  
>  	ieee80211_configure_filter(local);
>  
> @@ -544,7 +570,21 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  	}
>  	mutex_unlock(&local->iflist_mtx);
>  
> -	if (local->scan_channel) {
> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
> +
> +	if (ieee80211_cfg_on_oper_channel(local)) {
> +		/* We're currently on operating channel. */
> +		if ((next_chan == local->oper_channel) &&
> +		    (local->_oper_channel_type == NL80211_CHAN_NO_HT))
> +			/* We don't need to move off of operating channel. */
> +			local->next_scan_state = SCAN_SET_CHANNEL;
> +		else
> +			/*
> +			 * We do need to leave operating channel, as next
> +			 * scan is somewhere else.
> +			 */
> +			local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
> +	} else {
>  		/*
>  		 * we're currently scanning a different channel, let's
>  		 * see if we can scan another channel without interfering
> @@ -560,7 +600,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  		 *
>  		 * Otherwise switch back to the operating channel.
>  		 */
> -		next_chan = local->scan_req->channels[local->scan_channel_idx];
>  
>  		bad_latency = time_after(jiffies +
>  				ieee80211_scan_get_channel_time(next_chan),
> @@ -578,12 +617,6 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  			local->next_scan_state = SCAN_ENTER_OPER_CHANNEL;
>  		else
>  			local->next_scan_state = SCAN_SET_CHANNEL;
> -	} else {
> -		/*
> -		 * we're on the operating channel currently, let's
> -		 * leave that channel now to scan another one
> -		 */
> -		local->next_scan_state = SCAN_LEAVE_OPER_CHANNEL;
>  	}
>  
>  	*next_delay = 0;
> @@ -592,9 +625,10 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>  						    unsigned long *next_delay)
>  {
> -	ieee80211_offchannel_stop_station(local);
> -
> -	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
> +	/* PS will already be in off-channel mode,
> +	 * we do that once at the beginning of scanning.
> +	 */
> +	ieee80211_offchannel_stop_vifs(local, false);
>  
>  	/*
>  	 * What if the nullfunc frames didn't arrive?
> @@ -617,15 +651,15 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
>  {
>  	/* switch back to the operating channel */
>  	local->scan_channel = NULL;
> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +	if (!ieee80211_cfg_on_oper_channel(local))
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>  
>  	/*
> -	 * Only re-enable station mode interface now; beaconing will be
> -	 * re-enabled once the full scan has been completed.
> +	 * Re-enable vifs and beaconing.  Leave PS
> +	 * in off-channel state..will put that back
> +	 * on-channel at the end of scanning.
>  	 */
> -	ieee80211_offchannel_return(local, false);
> -
> -	__clear_bit(SCAN_OFF_CHANNEL, &local->scanning);
> +	ieee80211_offchannel_return(local, true, false);
>  
>  	*next_delay = HZ / 5;
>  	local->next_scan_state = SCAN_DECISION;
> @@ -641,8 +675,12 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
>  	chan = local->scan_req->channels[local->scan_channel_idx];
>  
>  	local->scan_channel = chan;
> -	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> -		skip = 1;
> +
> +	/* Only call hw-config if we really need to change channels. */
> +	if ((chan != local->hw.conf.channel) ||
> +	    (local->hw.conf.channel_type != NL80211_CHAN_NO_HT))
> +		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> +			skip = 1;
>  
>  	/* advance state machine to next channel/band */
>  	local->scan_channel_idx++;
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 8fbbc7a..7b7a503 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -257,7 +257,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>  	if (unlikely(info->flags & IEEE80211_TX_CTL_INJECTED))
>  		return TX_CONTINUE;
>  
> -	if (unlikely(test_bit(SCAN_OFF_CHANNEL, &tx->local->scanning)) &&
> +	if (unlikely(test_bit(SCAN_SW_SCANNING, &tx->local->scanning)) &&
> +	    test_bit(SDATA_STATE_OFFCHANNEL, &tx->sdata->state) &&
>  	    !ieee80211_is_probe_req(hdr->frame_control) &&
>  	    !ieee80211_is_nullfunc(hdr->frame_control))
>  		/*
> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 36305e0..6bf787a 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -924,18 +924,44 @@ static void ieee80211_work_work(struct work_struct *work)
>  		}
>  
>  		if (!started && !local->tmp_channel) {
> -			/*
> -			 * TODO: could optimize this by leaving the
> -			 *	 station vifs in awake mode if they
> -			 *	 happen to be on the same channel as
> -			 *	 the requested channel
> -			 */
> -			ieee80211_offchannel_stop_beaconing(local);
> -			ieee80211_offchannel_stop_station(local);
> +			bool on_oper_chan;
> +			bool tmp_chan_changed = false;
> +			bool on_oper_chan2;
> +			on_oper_chan = ieee80211_cfg_on_oper_channel(local);
> +			if (local->tmp_channel)
> +				if ((local->tmp_channel != wk->chan) ||
> +				    (local->tmp_channel_type != wk->chan_type))
> +					tmp_chan_changed = true;
>  
>  			local->tmp_channel = wk->chan;
>  			local->tmp_channel_type = wk->chan_type;
> -			ieee80211_hw_config(local, 0);
> +			/*
> +			 * Leave the station vifs in awake mode if they
> +			 * happen to be on the same channel as
> +			 * the requested channel.
> +			 */
> +			on_oper_chan2 = ieee80211_cfg_on_oper_channel(local);
> +			if (on_oper_chan != on_oper_chan2) {
> +				if (on_oper_chan2) {
> +					/* going off oper channel, PS too */
> +					ieee80211_offchannel_stop_vifs(local,
> +								       true);
> +					ieee80211_hw_config(local, 0);
> +				} else {
> +					/* going on channel, but leave PS
> +					 * off-channel. */
> +					ieee80211_hw_config(local, 0);
> +					ieee80211_offchannel_return(local,
> +								    true,
> +								    false);
> +				}
> +			} else if (tmp_chan_changed)
> +				/* Still off-channel, but on some other
> +				 * channel, so update hardware.
> +				 * PS should already be off-channel.
> +				 */
> +				ieee80211_hw_config(local, 0);
> +
>  			started = true;
>  			wk->timeout = jiffies;
>  		}
> @@ -1011,9 +1037,27 @@ static void ieee80211_work_work(struct work_struct *work)
>  	}
>  
>  	if (!remain_off_channel && local->tmp_channel) {
> +		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
>  		local->tmp_channel = NULL;
> -		ieee80211_hw_config(local, 0);
> -		ieee80211_offchannel_return(local, true);
> +		/* If tmp_channel wasn't operating channel, then
> +		 * we need to go back on-channel.
> +		 * NOTE:  If we can ever be here while scannning,
> +		 * or if the hw_config() channel config logic changes,
> +		 * then we may need to do a more thorough check to see if
> +		 * we still need to do a hardware config.  Currently,
> +		 * we cannot be here while scanning, however.
> +		 */
> +		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
> +			ieee80211_hw_config(local, 0);
> +
> +		/* At the least, we need to disable offchannel_ps,
> +		 * so just go ahead and run the entire offchannel
> +		 * return logic here.  We *could* skip enabling
> +		 * beaconing if we were already on-oper-channel
> +		 * as a future optimization.
> +		 */
> +		ieee80211_offchannel_return(local, true, true);
> +
>  		/* give connection some time to breathe */
>  		run_again(local, jiffies + HZ/2);
>  	}


