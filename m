Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36104 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1BAQjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 11:39:33 -0500
Message-ID: <4D483742.8030108@candelatech.com>
Date: Tue, 01 Feb 2011 08:39:30 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v7] mac80211: Optimize scans on current operating channel.
References: <1296502228-32595-1-git-send-email-greearb@candelatech.com> <201102011631.51405.helmut.schaa@googlemail.com>
In-Reply-To: <201102011631.51405.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2011 07:31 AM, Helmut Schaa wrote:
> Hi Ben,
>
> looks as if your special case (only scanning the operating channel) would be
> covered quite well with this patch. However, in cases where we scan multiple
> channels consecutively (including the operating channel) the operating channel
> might get scanned (if the previous scan channel was off channel and we still
> got time left for another channel to scan) without reenabling the interfaces
> (beaconing, waking up etc.). It wasn't like this before your patch, so that
> shouldn't prevent your optimization from being merged :) but might be
> considered in the future.

Yes.  In particular, I think it would be nice to re-order the scan
channels so that the first channel scanned is the operating channel.
That should optimize things to do as few on/off channel operations
as possible, without adding any more complexity to the scan
state machine.

>
> Am Montag, 31. Januar 2011 schrieb greearb@candelatech.com:
>> From: Ben Greear<greearb@candelatech.com>
>>
>> This should decrease un-necessary flushes, on/off channel work,
>> and channel changes in cases where the only scanned channel is
>> the current operating channel.
>>
>> * Removes SCAN_OFF_CHANNEL flag, uses SDATA_STATE_OFFCHANNEL
>>    and is-scanning flags instead.
>
> Nice!
>
>> * Add helper method to determine if we are currently configured
>>    for the operating channel.
>>
>> * Do no blindly go off/on channel in work.c  Instead, only call
>>    appropriate on/off code when we really need to change channels.
>>
>> * Consolidate ieee80211_offchannel_stop_station and
>>    ieee80211_offchannel_stop_beaconing, call it
>>    ieee80211_offchannel_stop_vifs instead.
>>
>> * Accept non-beacon frames when scanning, even if off-channel.
>
> As far as I can see ieee80211_scan_rx will pass the frame up _only_
> if we are on-channel. Is the comment wrong?

I believe I was talking about this particular piece of code, but
the scan_rx is going to purge any pkts that are not scan results
when not on channel, so that comment is wrong about the off-channel
bit.

+++ b/net/mac80211/rx.c
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


>> @@ -293,15 +300,25 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>>   					      bool was_hw_scan)
>>   {
>>   	struct ieee80211_local *local = hw_to_local(hw);
>> +	bool ooc;
>> +
>> +	mutex_lock(&local->mtx);
>> +	ooc = ieee80211_cfg_on_oper_channel(local);
>> +
>> +	if (was_hw_scan || !ooc)
>> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>   	if (!was_hw_scan) {
>> +		bool ooc2;
>>   		ieee80211_configure_filter(local);
>>   		drv_sw_scan_complete(local);
>> -		ieee80211_offchannel_return(local, true);
>> +		ooc2 = ieee80211_cfg_on_oper_channel(local);
>> +		/* We should always be on-channel at this point. */
>> +		WARN_ON(!ooc2);
>> +		if (ooc2&&  (ooc != ooc2))
>> +			ieee80211_offchannel_return(local, true);
>
> Is this additional check necessary? Looks as if that can only happen
> if the call to ieee80211_hw_config failes, right? And in that case we'll hit
> other problems as well I guess.

Yeah, this code looks a bit wrong.  My idea was to make absolutely sure that
we are back on the operating channel and have run the offchannel_return.
In that first bit of code that
does the hw_config(), I need to explicitly clear the scan-channel (and warn
if it is not already cleared).

>>   	/*
>>   	 * What if the nullfunc frames didn't arrive?
>> @@ -617,15 +635,13 @@ static void ieee80211_scan_state_enter_oper_channel(struct ieee80211_local *loca
>>   {
>>   	/* switch back to the operating channel */
>>   	local->scan_channel = NULL;
>> -	ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>> +	if (!ieee80211_cfg_on_oper_channel(local))
>> +		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL);
>>
>>   	/*
>> -	 * Only re-enable station mode interface now; beaconing will be
>> -	 * re-enabled once the full scan has been completed.
>> +	 * Re-enable vifs and beaconing.
>>   	 */
>> -	ieee80211_offchannel_return(local, false);
>> -
>> -	__clear_bit(SCAN_OFF_CHANNEL,&local->scanning);
>> +	ieee80211_offchannel_return(local, true);
>
> In cases where the qos latency is configured to something small
> we'll end up disabling/enabling beaconing for each scanned channel.
> However, as we'll stay at least 200ms on the operating channel
> it shouldn't hurt I guess.

That was my hope....

>
> All in all at least the changes to the scan code look reasonable to me.

Thanks for the review.  I'll work on the issues you brought up
and re-submit.

Thanks,
Ben

>
> Thanks,
> Helmut


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
