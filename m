Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752226AbeGBJSk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 05:18:40 -0400
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
 <1530263375.3481.23.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <87345305-94d2-7c5e-379e-757670b7e59f@codeaurora.org> (sfid-20180702_111844_460470_3E617F78)
Date: Mon, 2 Jul 2018 14:48:35 +0530
MIME-Version: 1.0
In-Reply-To: <1530263375.3481.23.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>> +		if (txq->sta) {
>> +			sta = container_of(txq->sta, struct sta_info, sta);
>> +			atomic_set(&sta->txqs_paused, 1);
>> +		}
> It seems to me you could remove this - possibly at the expense of doing
> a little more work in ieee80211_wake_txqs()?

Atomic set on txqs_paused is done to avoid checking each txq for pause 
condition in ieee80211_wake_txqs; In other words, we will walk through 
the STA iTXQs only if sta->txqs_paused is set.
This minor optimization might be helpful when the sta_list is huge, no?

> Have you measured it and found it to be a problem?
>
> The atomic stuff here doesn't work the way you want it to though. In
> fact, even the lazy propagation doesn't work the way you want it to, I
> think!
>
> Thinking about it:
>
> CPU 1                           CPU 2
>   * you're disabling TX
>     -> local->txqs_stopped = 1
>                                   * check local->txqs_stopped
>   * re-enable TX
>     -> local->txqs_stopped = 0
>   * call ieee80211_wake_txqs()
>     check sta->txqs_paused
>                                   * set txq->flags |= PAUSED
>                                   * set sta->txqs_paused
>
> I don't see how you can prevent this right now? In
> ieee80211_tx_dequeue() you have the fq lock, but you're not taking it on
> the other side (in __ieee80211_stop_queue/__ieee80211_wake_queue).
>

You are right, we should take care of locking.

>> +		for (i = 0; i < ARRAY_SIZE(sta->sta.txq); i++) {
>> +			txqi = to_txq_info(sta->sta.txq[i]);
>> +
>> +			if (!test_and_clear_bit(IEEE80211_TXQ_PAUSED,
>> +						&txqi->flags))
>> +				continue;
>> +
>> +			drv_wake_tx_queue(local, txqi);
> Maybe that should be conditional on there being packets? Actually, no
> ... ok, the lazy setting helps you with this because it means that the
> driver wanted a packet but didn't get one, so now you should wake it. If
> it never wanted a packet, then you don't care about the state.
>
> Ok - so that means we need to keep the lazy setting, but fix the locking
> :-)

Correct!!

>> +		/* Software interfaces like AP_VLAN, monitor do not have
>> +		 * vif specific queues.
>> +		 */
>> +		if (!sdata->dev || !vif->txq)
>> +			continue;
> Is there any way you can have vif->txq && !sdata->dev? It seems to me
> that no, and then you only need the vif->txq check?

Makes sense; we need not check for sdata->dev.

>> @@ -298,10 +354,15 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>>   	if (local->q_stop_reasons[queue][reason] == 0)
>>   		__clear_bit(reason, &local->queue_stop_reasons[queue]);
>>   
>> +	if (local->ops->wake_tx_queue)
>> +		__clear_bit(reason, &local->txqs_stopped);
>> +
>>   	if (local->queue_stop_reasons[queue] != 0)
>>   		/* someone still has this queue stopped */
>>   		return;
>>   
>> +	ieee80211_wake_txqs(local);
> I'm not sure this is the right place to hook in?
>
> This might interact really strangely with drivers - which also get here.
> Perhaps we should make this conditional on reason != DRIVER?

Good point!  IMO the condition (reason != DRIVER) does not fit well; if 
the reason for stop queues is DRIVER then we don't get a chance to wake 
them again. May be deferring the wake_txqs by scheduling a tasklet 
should help?

>
> Also, your bitmap setting should be different - it should be per queue?
> But then since "queue" here should basically be an AC for iTXQ drivers,
> I think you need to handle that properly.
>
> Right now you get bugs if you do
>
> stop_queue(0, reason=aggregation)
> stop_queue(1, reason=aggregation)
> wake_queue(0, reason=aggregation)
>
> -> TXQs will wake up because local->txqs_stopped is only stopping the
> reason, not the queue number.
>

Makes sense!!

> So to summarize:
>   * overall the approach seems fine, and the lazy disabling is probably
>     for the better, but
>   * need to address locking issues with that, and
>   * need to address the refcounting issues.

Sure Johannes!!

Thanks,
Manikanta
