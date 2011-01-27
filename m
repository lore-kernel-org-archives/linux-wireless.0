Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40511 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab1A0Nw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:52:29 -0500
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating
 channel.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Jan 2011 14:52:27 +0100
Message-ID: <1296136347.3622.55.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-26 at 12:37 -0800, greearb@candelatech.com wrote:


> +/* Returns true if hardware is currently configured for the operating channel
> + * and if the logical configured state is to be on the operating channel.
> + */
> +bool ieee80211_on_oper_channel(struct ieee80211_local *local);

Maybe use proper kernel-doc


> +/** If we are configured to be off the operating channel,
> + * or if we are already off the operating channel, return
> + * false.
> + */

But that clearly isn't kernel-doc, so no /**

> +bool ieee80211_on_oper_channel(struct ieee80211_local *local)
> +{
> +	struct ieee80211_channel *chan, *scan_chan;
> +	enum nl80211_channel_type channel_type;
> +
> +	/** This logic needs to match logic in ieee80211_hw_config */

ditto.

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

Don't understand -- why not return true in the else branch?

> +	if (chan != local->oper_channel ||
> +	    channel_type != local->_oper_channel_type)
> +		return false;
> +
> +	/* Check current hardware-config against oper_channel. */
> +	if ((local->oper_channel != local->hw.conf.channel) ||
> +	    (local->_oper_channel_type != local->hw.conf.channel_type))
> +		return false;

That's confusing, and kinda racy IIRC?

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

> +
> +	if (chan != local->oper_channel ||
> +	    channel_type != local->_oper_channel_type)
> +		local->hw.conf.flags |= IEEE80211_CONF_OFFCHANNEL;
> +	else
> +		local->hw.conf.flags &= ~IEEE80211_CONF_OFFCHANNEL;
> +	$

whitespace damage ($ inserted by me)


> @@ -183,6 +222,7 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>  	return ret;
>  }
>  
> +
>  void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
>  				      u32 changed)
>  {

pointless

> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
> index b4e5267..0441b16 100644
> --- a/net/mac80211/offchannel.c
> +++ b/net/mac80211/offchannel.c
> @@ -95,57 +95,33 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
>  	ieee80211_sta_reset_conn_monitor(sdata);
>  }
>  
> -void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
> +void ieee80211_offchannel_stop_station(struct ieee80211_local *local)

I think you should find a new name for the combined function, like
"stop_interface".



> -		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
> +		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
>  			set_bit(SDATA_STATE_OFFCHANNEL, &sdata->state);
>  			netif_tx_stop_all_queues(sdata->dev);
> -			if (sdata->u.mgd.associated)
> +			if ((sdata->vif.type == NL80211_IFTYPE_STATION) &&
> +			    sdata->u.mgd.associated)
>  				ieee80211_offchannel_ps_enable(sdata);

what's the difference between sdata_state_offchannel and
scan_off_channel?

>  		}
> +
>  	}

spurious whitespace

>  	mutex_unlock(&local->iflist_mtx);
>  }
> @@ -181,7 +157,7 @@ void ieee80211_offchannel_return(struct ieee80211_local *local,
>  			netif_tx_wake_all_queues(sdata->dev);
>  		}
>  
> -		/* re-enable beaconing */
> +		/* Check to see if we should re-enable beaconing */
>  		if (enable_beaconing &&
>  		    (sdata->vif.type == NL80211_IFTYPE_AP ||
>  		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||

How does scan_off_channel get cleared before this?

> @@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>  		return ieee80211_scan_rx(rx->sdata, skb);
>  
>  	if (test_bit(SCAN_SW_SCANNING, &local->scanning)) {
> -		/* drop all the other packets during a software scan anyway */
> -		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
> +		ret = ieee80211_scan_rx(rx->sdata, skb);
> +		/* drop all the other packets while scanning off channel */
> +		if (ret != RX_QUEUED &&
> +		    test_bit(SCAN_OFF_CHANNEL, &local->scanning)) {
>  			dev_kfree_skb(skb);
> -		return RX_QUEUED;
> +			return RX_QUEUED;
> +		}
> +		return ret;

Alright -- but does the mlme.c code know not to expect beacons during an
on-channel scan?

> @@ -2749,7 +2754,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
>  		local->dot11ReceivedFragmentCount++;
>  
>  	if (unlikely(test_bit(SCAN_HW_SCANNING, &local->scanning) ||
> -		     test_bit(SCAN_OFF_CHANNEL, &local->scanning)))
> +		     test_bit(SCAN_SW_SCANNING, &local->scanning)))
>  		status->rx_flags |= IEEE80211_RX_IN_SCAN;

Not sure I understand this change?

> +++ b/net/mac80211/scan.c
> @@ -294,11 +294,14 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>  {
>  	struct ieee80211_local *local = hw_to_local(hw);
>  
> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +	if ((local->oper_channel != local->hw.conf.channel) || was_hw_scan)
> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
> +
>  	if (!was_hw_scan) {
>  		ieee80211_configure_filter(local);
>  		drv_sw_scan_complete(local);
> -		ieee80211_offchannel_return(local, true);
> +		if (test_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning))
> +			ieee80211_offchannel_return(local, true);

test_and_clear_bit ? Actually it's locked, no? So no need for atomic
ops.

> @@ -544,7 +544,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  	}
>  	mutex_unlock(&local->iflist_mtx);
>  
> -	if (local->scan_channel) {
> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
> +
> +	if (local->oper_channel == local->hw.conf.channel) {

what's that for?

> +		if (next_chan == local->oper_channel)
> +			local->next_scan_state = SCAN_SET_CHANNEL;

channel type?

> @@ -592,9 +596,12 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>  static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>  						    unsigned long *next_delay)
>  {
> +	/* This must be set before we do the stop_station logic. */
> +	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
> +
>  	ieee80211_offchannel_stop_station(local);
>  
> -	__set_bit(SCAN_OFF_CHANNEL, &local->scanning);
> +	__set_bit(SCAN_LEFT_OPER_CHANNEL, &local->scanning);



> @@ -641,8 +648,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
>  	chan = local->scan_req->channels[local->scan_channel_idx];
>  
>  	local->scan_channel = chan;
> -	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> -		skip = 1;
> +
> +	if (chan != local->hw.conf.channel)
> +		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
> +			skip = 1;

Why doesn't that test the bit? Or does this only cause setting it?

> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
> index 36305e0..62ffc8e 100644
> --- a/net/mac80211/work.c
> +++ b/net/mac80211/work.c
> @@ -924,18 +924,17 @@ static void ieee80211_work_work(struct work_struct *work)
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
> -
>  			local->tmp_channel = wk->chan;
>  			local->tmp_channel_type = wk->chan_type;
> -			ieee80211_hw_config(local, 0);
> +			if (!ieee80211_on_oper_channel(local)) {
> +				/*
> +				 * Leave the station vifs in awake mode if they
> +				 * happen to be on the same channel as
> +				 * the requested channel
> +				 */
> +				ieee80211_offchannel_stop_station(local);
> +				ieee80211_hw_config(local, 0);
> +			}

Now I think ieee80211_on_oper_channel() is a confusing name -- should it
be "_already_on_target_channel" or something?

Also, won't this do some weird things like not stop, but try to start
stations again?

johannes

