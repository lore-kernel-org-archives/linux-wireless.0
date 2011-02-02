Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42434 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1BBRnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 12:43:51 -0500
Message-ID: <4D4997D1.5030204@candelatech.com>
Date: Wed, 02 Feb 2011 09:43:45 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8] mac80211: Optimize scans on current operating channel.
References: <1296597556-17431-1-git-send-email-greearb@candelatech.com> <1296652403.5671.17.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296652403.5671.17.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/02/2011 05:13 AM, Johannes Berg wrote:
> Are you asleep now? Good thing I didn't even look at v7 ;-)
>
> I'm kinda afraid of this patch. It's big, but I guess there's nothing we
> can do about that.

>>   int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>>   {
>>   	struct ieee80211_channel *chan, *scan_chan;
>> @@ -110,21 +143,27 @@ int ieee80211_hw_config(struct ieee80211_local *local, u32 changed)
>>
>>   	scan_chan = local->scan_channel;
>>
>> +	/* If this off-channel logic ever changes,  ieee80211_on_oper_channel
>> +	 * may need to change as well.
>> +	 */
>
> Would it make sense to roll this thing into one?
>
> Like "ieee80211_get_desired_channel(local,&chan,&chantype)"
>
> and then this code and on_oper_channel would use that?

As you say, the patch is big and scary already.  I would like to
attempt this change as a small follow-on patch that does just
one thing.  To me, the open-coded logic is a bit more similar
to existing logic and thus easier to review.

>> +	/* If we are scanning on-channel, pass the pkt on up the stack so that
>> +	 * mlme can make use of it
>> +	 */
>> +	if (ieee80211_cfg_on_oper_channel(sdata->local)
>> +	&&  (channel == sdata->local->oper_channel))
>> +		return RX_CONTINUE;
>
> Ah, neat trick, no need to duplicate the packet :-)
> But didn't you say this wasn't necessary since timers were stopped
> anyway during scan? So maybe the comment shouldn't refer to scanning,
> but other work?

Timers are stopped only if we are off-channel for scanning, I think.
And, they are NOT stopped when we go off channel for work_work().
Even if the packets are not currently used by the rest of the
stack, it seems logically sound to pass them up in this case.

>>   	dev_kfree_skb(skb);
>>   	return RX_QUEUED;
>>   }
>> @@ -293,15 +300,28 @@ static void __ieee80211_scan_completed_finish(struct ieee80211_hw *hw,
>>   					      bool was_hw_scan)
>>   {
>>   	struct ieee80211_local *local = hw_to_local(hw);
>> +	bool ooc;
>
> That might be nicer if it was a bit more verbose. Same with ooc2 I
> think. I suppose it's understandable though, so if it really gets messy
> with long lines maybe we shouldn't worry about it.
>
>> -	if (local->scan_channel) {
>> +	next_chan = local->scan_req->channels[local->scan_channel_idx];
>> +
>> +	if (ieee80211_cfg_on_oper_channel(local)) {
>> +		/* We're currently on operating channel. */
>> +		if ((next_chan == local->oper_channel)&&
>> +		    (local->_oper_channel_type == NL80211_CHAN_NO_HT))
>> +			/* We don't need to move off of operating channel. */
>> +			local->next_scan_state = SCAN_SET_CHANNEL;
>> +		else
>> +			/*
>> +			 * We do need to leave operating channel, as next
>> +			 * scan is somewhere else.
>> +			 */
>
> Hmm, is that really "leave"? You aren't sorting (yet) so might this not
> go back onto the operating channel then?

I'm checking next_chan, and it's not operating channel
(or at least the channel_type must change), so yes, I think
we really are leaving here.

>
>> +++ b/net/mac80211/tx.c
>> @@ -257,7 +257,8 @@ ieee80211_tx_h_check_assoc(struct ieee80211_tx_data *tx)
>>   	if (unlikely(info->flags&  IEEE80211_TX_CTL_INJECTED))
>>   		return TX_CONTINUE;
>>
>> -	if (unlikely(test_bit(SCAN_OFF_CHANNEL,&tx->local->scanning))&&
>> +	if (unlikely(test_bit(SCAN_SW_SCANNING,&tx->local->scanning))&&
>> +	    test_bit(SDATA_STATE_OFFCHANNEL,&tx->sdata->state)&&
>
> Shouldn't that be || ? Or only the off-channel check I think?

The old check was for scan-off-channel flag.  That is equiv
to sw-scanning AND state-offchannel.

So, I don't think the logic changes much here...except that we used
to be 'scanning-off-channel' even if we were on-channel.

I think we should be able to do normal tx if scanning on-channel,
so I think this code is correct.

One thing:  If we are normally operating in HT40 mode, we have to
shift to NO_HT for scanning.  But, I think we could probably still
transmit packets even if we are temporarily in NO_HT, right?  So,
follow-on patches might be able to relax the is-on-channel checks
slightly to take channel-type co-existence into account.

>>   			local->tmp_channel = wk->chan;
>>   			local->tmp_channel_type = wk->chan_type;
>> -			ieee80211_hw_config(local, 0);
>> +			/*
>> +			 * Leave the station vifs in awake mode if they
>> +			 * happen to be on the same channel as
>> +			 * the requested channel.
>> +			 */
>> +			ooc2 = ieee80211_cfg_on_oper_channel(local);
>> +			if (ooc != ooc2) {
>> +				if (ooc2) {
>> +					/* went off operating channel */
>> +					ieee80211_offchannel_stop_vifs(local);
>
> "went" is a little misleading, I think it needs to be "will go"? It
> shouldn't be "went" since we need to stop first and then switch
> channels.

We logically went off-channel in mac80211.  We just haven't
told the NIC about it yet...  I'll try to make that more
clear.

v9 coming soon :)

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

