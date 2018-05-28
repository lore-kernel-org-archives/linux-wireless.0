Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56642 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753302AbeE1HTp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 03:19:45 -0400
Subject: Re: [RFC] mac80211: add stop/start logic for software TXQs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgens?= =?UTF-8?Q?en?=
        <toke@toke.dk>
References: <1526672192-3873-1-git-send-email-mpubbise@codeaurora.org>
 <1527068760.3759.13.camel@sipsolutions.net>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <af87d35a-f5d8-0766-b650-0ba3e941e839@codeaurora.org> (sfid-20180528_092027_886670_6C08BBFB)
Date: Mon, 28 May 2018 12:49:38 +0530
MIME-Version: 1.0
In-Reply-To: <1527068760.3759.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> +++ b/net/mac80211/agg-tx.c
>> @@ -213,11 +213,15 @@ static void
>>   ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
>>   {
>>   	struct ieee80211_txq *txq = sta->sta.txq[tid];
>> +	struct ieee80211_local *local = sta->local;
>>   	struct txq_info *txqi;
>>   
>>   	if (!txq)
>>   		return;
>>   
>> +	if (local->txqs_stopped)
>> +		return;
>> +
>>   	txqi = to_txq_info(txq);
> This doesn't seem right, all the logic that clears the TXQ_STOP etc.
> still needs to be invoked, otherwise your TXQ will get stuck completely
> since you'll never run this code again.

If the queues are blocked more than the block ack timeout then the 
traffic should be sent only in the next BA session.
I am not really sure whether the queues will be blocked more than the 
block ack timeout value unless the queues are stopped because of 
multiple reasons.
In any case, traffic will be pushed out in subsequent BA sessions, no?


[snip]

> +++ b/net/mac80211/sta_info.c
> @@ -1244,6 +1244,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
>   			if (!txq_has_queue(sta->sta.txq[i]))
>   				continue;
>   
> +			if (local->txqs_stopped)
> +				continue;
> +
>   			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
>   		}
> That seems like it's in an odd place, why bother going through all the
> logic first?
>
> Also, you have the same problem as above - you never re-run this code so
>   you'd get stuck completely.

I didn't get your point here. By the time the queues gets started again, 
there could be possibility that the station might have been back to 
sleep. In this case, it is better not to send the traffic, no?
Anyways, station would receive the traffic in the next cycle when it is 
out of sleep. Considering codel logic, there could be frame drops 
though; maybe I am missing something?

>> +++ b/net/mac80211/tx.c
>> @@ -1559,6 +1559,9 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
>>   	    sdata->vif.type == NL80211_IFTYPE_MONITOR)
>>   		return false;
>>   
>> +	if (local->txqs_stopped)
>> +		return false;
>> +
>>   	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>>   		sdata = container_of(sdata->bss,
>>   				     struct ieee80211_sub_if_data, u.ap);
> That also seems too early.
>
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> index 2d82c88..da7ae8b 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -298,6 +298,9 @@ static void __ieee80211_wake_queue(struct ieee80211_hw *hw, int queue,
>>   	if (local->q_stop_reasons[queue][reason] == 0)
>>   		__clear_bit(reason, &local->queue_stop_reasons[queue]);
>>   
>> +	if (local->ops->wake_tx_queue)
>> +		__clear_bit(reason, &local->txqs_stopped);
> Ah, never mind, you do use it as a bitmap.
>
> But I think your approach is wrong, somehow you have to make sure you
> restart.
>
> Perhaps a good approach would be to have a check when the driver pulls
> an SKB, and then record the queue it was pulled. Then, when the stop
> bitmap goes to 0, you can drv_wake_tx_queue() all the queues that were
> marked as "pulled while stopped" to recover.
Good idea!!
A much better way to handle this, I will try out this and see how it fares.

Thanks,
Manikanta
