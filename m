Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36941 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab1A0RRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 12:17:16 -0500
Message-ID: <4D41A895.4060304@candelatech.com>
Date: Thu, 27 Jan 2011 09:17:09 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3] mac80211:  Optimize scans on current operating channel.
References: <1296074238-4012-1-git-send-email-greearb@candelatech.com> <1296136347.3622.55.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296136347.3622.55.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/27/2011 05:52 AM, Johannes Berg wrote:

>> +	if (local->scan_channel) {
>> +		chan = local->scan_channel;
>> +		channel_type = NL80211_CHAN_NO_HT;
>> +	} else if (local->tmp_channel) {
>> +		chan = scan_chan = local->tmp_channel;
>> +		channel_type = local->tmp_channel_type;
>> +	} else {
>> +		chan = local->oper_channel;
>> +		channel_type = local->_oper_channel_type;
>> +	}
>
> Don't understand -- why not return true in the else branch?

Because the hardware might not actually be set to the oper_channel.
The idea is that you configure the mac80211 state as you want it, and then
use this method to figure out if you really need to make hardware
changes.

>> +	if (chan != local->oper_channel ||
>> +	    channel_type != local->_oper_channel_type)
>> +		return false;
>> +
>> +	/* Check current hardware-config against oper_channel. */
>> +	if ((local->oper_channel != local->hw.conf.channel) ||
>> +	    (local->_oper_channel_type != local->hw.conf.channel_type))
>> +		return false;
>
> That's confusing, and kinda racy IIRC?

This method should be locked such that the hardware conf
cannot be changed while it is being called.  I can double
check that this is true.

>
>> diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
>> index b4e5267..0441b16 100644
>> --- a/net/mac80211/offchannel.c
>> +++ b/net/mac80211/offchannel.c
>> @@ -95,57 +95,33 @@ static void ieee80211_offchannel_ps_disable(struct ieee80211_sub_if_data *sdata)
>>   	ieee80211_sta_reset_conn_monitor(sdata);
>>   }
>>
>> -void ieee80211_offchannel_stop_beaconing(struct ieee80211_local *local)
>> +void ieee80211_offchannel_stop_station(struct ieee80211_local *local)
>
> I think you should find a new name for the combined function, like
> "stop_interface".

Maybe stop_vifs() ?
It stops everything but Monitor interfaces...

>> -		if (sdata->vif.type == NL80211_IFTYPE_STATION) {
>> +		if (sdata->vif.type != NL80211_IFTYPE_MONITOR) {
>>   			set_bit(SDATA_STATE_OFFCHANNEL,&sdata->state);
>>   			netif_tx_stop_all_queues(sdata->dev);
>> -			if (sdata->u.mgd.associated)
>> +			if ((sdata->vif.type == NL80211_IFTYPE_STATION)&&
>> +			    sdata->u.mgd.associated)
>>   				ieee80211_offchannel_ps_enable(sdata);
>
> what's the difference between sdata_state_offchannel and
> scan_off_channel?

No idea, will have to take a look.  Was just coping existing code...

>> -		/* re-enable beaconing */
>> +		/* Check to see if we should re-enable beaconing */
>>   		if (enable_beaconing&&
>>   		(sdata->vif.type == NL80211_IFTYPE_AP ||
>>   		     sdata->vif.type == NL80211_IFTYPE_ADHOC ||
>
> How does scan_off_channel get cleared before this?

Will check.

>
>> @@ -396,10 +397,14 @@ ieee80211_rx_h_passive_scan(struct ieee80211_rx_data *rx)
>>   		return ieee80211_scan_rx(rx->sdata, skb);
>>
>>   	if (test_bit(SCAN_SW_SCANNING,&local->scanning)) {
>> -		/* drop all the other packets during a software scan anyway */
>> -		if (ieee80211_scan_rx(rx->sdata, skb) != RX_QUEUED)
>> +		ret = ieee80211_scan_rx(rx->sdata, skb);
>> +		/* drop all the other packets while scanning off channel */
>> +		if (ret != RX_QUEUED&&
>> +		    test_bit(SCAN_OFF_CHANNEL,&local->scanning)) {
>>   			dev_kfree_skb(skb);
>> -		return RX_QUEUED;
>> +			return RX_QUEUED;
>> +		}
>> +		return ret;
>
> Alright -- but does the mlme.c code know not to expect beacons during an
> on-channel scan?

I think that code is just supposed to let regular packets through if
we are scanning on the operating channel?  I don't see how anything gets
less beacons?

>
>> @@ -2749,7 +2754,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
>>   		local->dot11ReceivedFragmentCount++;
>>
>>   	if (unlikely(test_bit(SCAN_HW_SCANNING,&local->scanning) ||
>> -		     test_bit(SCAN_OFF_CHANNEL,&local->scanning)))
>> +		     test_bit(SCAN_SW_SCANNING,&local->scanning)))
>>   		status->rx_flags |= IEEE80211_RX_IN_SCAN;
>
> Not sure I understand this change?

Otherwise, scan results are not gathered while we are scanning on channel.
This was the root cause of me not seeing scan results while scanning on
channel.  (There is other code that will ignore beacons if the RX_IN_SCAN
bit isn't set).


>> @@ -544,7 +544,18 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>>   	}
>>   	mutex_unlock(&local->iflist_mtx);
>>
>> -	if (local->scan_channel) {
>> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
>> +
>> +	if (local->oper_channel == local->hw.conf.channel) {
>
> what's that for?
>
>> +		if (next_chan == local->oper_channel)
>> +			local->next_scan_state = SCAN_SET_CHANNEL;
>
> channel type?

Yes, will add checks for channel type.  That first bit is to try to
avoid changes if we're already on the right channel, but it could
be wrong.  I'll review all of that.

>
>> @@ -592,9 +596,12 @@ static void ieee80211_scan_state_decision(struct ieee80211_local *local,
>>   static void ieee80211_scan_state_leave_oper_channel(struct ieee80211_local *local,
>>   						    unsigned long *next_delay)
>>   {
>> +	/* This must be set before we do the stop_station logic. */
>> +	__set_bit(SCAN_OFF_CHANNEL,&local->scanning);
>> +
>>   	ieee80211_offchannel_stop_station(local);
>>
>> -	__set_bit(SCAN_OFF_CHANNEL,&local->scanning);
>> +	__set_bit(SCAN_LEFT_OPER_CHANNEL,&local->scanning);
>
>
>
>> @@ -641,8 +648,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
>>   	chan = local->scan_req->channels[local->scan_channel_idx];
>>
>>   	local->scan_channel = chan;
>> -	if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
>> -		skip = 1;
>> +
>> +	if (chan != local->hw.conf.channel)
>> +		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
>> +			skip = 1;
>
> Why doesn't that test the bit? Or does this only cause setting it?

Which bit?

Either way, at the least I need to check for channel-type as well.

>
>> diff --git a/net/mac80211/work.c b/net/mac80211/work.c
>> index 36305e0..62ffc8e 100644
>> --- a/net/mac80211/work.c
>> +++ b/net/mac80211/work.c
>> @@ -924,18 +924,17 @@ static void ieee80211_work_work(struct work_struct *work)
>>   		}
>>
>>   		if (!started&&  !local->tmp_channel) {
>> -			/*
>> -			 * TODO: could optimize this by leaving the
>> -			 *	 station vifs in awake mode if they
>> -			 *	 happen to be on the same channel as
>> -			 *	 the requested channel
>> -			 */
>> -			ieee80211_offchannel_stop_beaconing(local);
>> -			ieee80211_offchannel_stop_station(local);
>> -
>>   			local->tmp_channel = wk->chan;
>>   			local->tmp_channel_type = wk->chan_type;
>> -			ieee80211_hw_config(local, 0);
>> +			if (!ieee80211_on_oper_channel(local)) {
>> +				/*
>> +				 * Leave the station vifs in awake mode if they
>> +				 * happen to be on the same channel as
>> +				 * the requested channel
>> +				 */
>> +				ieee80211_offchannel_stop_station(local);
>> +				ieee80211_hw_config(local, 0);
>> +			}
>
> Now I think ieee80211_on_oper_channel() is a confusing name -- should it
> be "_already_on_target_channel" or something?

That does sound better.

>
> Also, won't this do some weird things like not stop, but try to start
> stations again?

I was thinking that should be harmless.  As far as I can tell, current
code would never actually stop beaconing in this method but might try
to start it later, so it must not cause too much trouble.

Thanks for the review...I'll go over everything and try to repost
something that incorporates your ideas.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
