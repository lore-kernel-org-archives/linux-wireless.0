Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34928 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeIUAbl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 20:31:41 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Sep 2018 11:46:48 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>
Subject: Re: [RFC] mac80211: budget outstanding airtime for transmission
In-Reply-To: <875zz08tah.fsf@toke.dk>
References: <1537430613-16849-1-git-send-email-rmanohar@codeaurora.org>
 <875zz08tah.fsf@toke.dk>
Message-ID: <3d06a48a76b2dc5905d8c5e76579b3cb@codeaurora.org> (sfid-20180920_204654_947623_66637E1B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-20 01:30, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> Per frame airtime estimation could be used to track outstanding 
>> airtime
>> of each txq and can be used to throttle ieee80211_tx_dequeue(). This
>> mechanism on its own will get us the queue limiting and latency
>> reduction goodness for firmwares with deep queues. And for that it can
>> be completely independent of the airtime fairness scheduler, which can
>> use the after-tx-compl airtime information to presumably get more
>> accurate fairness which includes retransmissions etc.
> 
> Very nice! This is pretty much what I would have done as well :)
> 

Thanks. :)

[...]

>> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
>> index b1b0fd6a2e21..ddc2c882c91c 100644
>> --- a/net/mac80211/sta_info.h
>> +++ b/net/mac80211/sta_info.h
>> @@ -135,6 +135,7 @@ struct airtime_info {
>>  	u64 rx_airtime;
>>  	u64 tx_airtime;
>>  	s64 deficit;
>> +	s32 budget;
> 
> Why signed? This should never become negative unless something is wrong
> with the accounting somewhere?
> 
> Related, are we sure there are no "leaks", i.e., packets that increase
> the budget on dequeue, but are never tx_completed?
> 
Just to avoid wraparound issue. Yeah... Irrespective of signedness if 
there
is mismatch in tx and tx-compl, it may stall tx. no? I was worrying what 
if
the driver is freeing skb silently instead of free_txskb().

Will change it to unsigned and add WARN_ON statement upon adjustment. is 
it OK?

>>  struct sta_info;
>> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
>> index 664379797c46..529f13cf7b2a 100644
>> --- a/net/mac80211/status.c
>> +++ b/net/mac80211/status.c
>> @@ -718,6 +718,7 @@ static void __ieee80211_tx_status(struct 
>> ieee80211_hw *hw,
>>  	struct ieee80211_bar *bar;
>>  	int shift = 0;
>>  	int tid = IEEE80211_NUM_TIDS;
>> +	u32 ac = IEEE80211_AC_BE;
>> 
>>  	rates_idx = ieee80211_tx_get_rates(hw, info, &retry_count);
>> 
>> @@ -733,6 +734,16 @@ static void __ieee80211_tx_status(struct 
>> ieee80211_hw *hw,
>> 
>>  		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
>> 
>> +		if (ieee80211_is_data_qos(fc)) {
>> +			u8 *qc = ieee80211_get_qos_ctl(hdr);
>> +
>> +			tid = qc[0] & 0xf;
>> +			ac = ieee80211_ac_from_tid(tid);
>> +		}
>> +		spin_lock_bh(&local->fq.lock);
>> +		sta->airtime[ac].budget -= info->control.airtime_est;
>> +		spin_unlock_bh(&local->fq.lock);
> 
> What is the argument for accounting non-data frames to the BE AC? And
> will this ever happen? Aren't we only putting data frames on the TXQs?
> 
I just aligned towards existing code flow. I see that non-data always 
defaults
to AC_BE. tid is considered only for qos-data otherwise it would be 
NUM_TIDS. no?

> Also, with this locking, we have one field of the airtime struct that 
> is
> protected by a different lock than the rest. That is probably going to
> become a problem at some point down the line when someone forgets this.
> Can we use the active_txq_lock[ac] instead (should probably be renamed
> in that case)?
> 
> The problem with using the other lock is that we'll need to ensure it 
> is
> taken in tx_dequeue(); but if we required schedule_{start,end}() around
> all calls to tx_dequeue() it should be fine? (famous last words...)
> 

Good point. The drive would have taken active_txq_lock before calling 
tx_dequeue.
In that case, this estimation logic is applicable only for the drivers 
that
support AIRTIME_FAIRNESS. I think it make sense too.. Otherwise queue 
limiting
will be applicable for all drivers. Will add feature check in 
calc_airtime().

schedule_start() --> lock acquired
while (next_txq()) {
    push txq()-> tx_dequeue()
}
schedule_end() --> lock released

[...]
>> 
>> +/* The estimated airtime (in microseconds), which is calculated using 
>> last
>> + * reported TX rate is stored in info context buffer. The budget will 
>> be
>> + * adjusted upon tx completion.
>> + */
>> +#define IEEE80211_AIRTIME_BUDGET_MAX    4000 /* txq airtime limit: 
>> 4ms */
>> +#define IEEE80211_AIRTIME_OVERHEAD      100  /* IFS + some slot time 
>> */
>> +#define IEEE80211_AIRTIME_OVERHEAD_IFS  16   /* IFS only */
> 
> Did you do any tuning of these values?
> 

I didn't but these values are taken from Kan's change.

>> +static void ieee80211_recalc_airtime_budget(struct ieee80211_local 
>> *local,
>> +					    struct sta_info *sta,
>> +					    struct sk_buff *skb, u8 ac)
>> +{
> 
> "recalc" implies that it is re-calculating something that was already
> calculated. So maybe s/recalc/calc/?
> 
>> +	struct ieee80211_tx_info *info;
>> +	struct ieee80211_hdr *hdr;
>> +	struct rate_info rinfo;
>> +	u32 pktlen, overhead, bitrate;
>> +	u16 airtime = 0;
>> +
>> +	lockdep_assert_held(&local->fq.lock);
>> +
>> +	hdr = (struct ieee80211_hdr *)skb->data;
>> +	info = IEEE80211_SKB_CB(skb);
>> +
>> +	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
>> +	bitrate = cfg80211_calculate_bitrate(&rinfo);
>> +
>> +	pktlen = skb->len + 38; /* Assume MAC header 30, SNAP 8 for most 
>> case */
>> +	if (!is_multicast_ether_addr(hdr->addr1)) {
>> +		/* overhead for media access time and IFS */
>> +		overhead = IEEE80211_AIRTIME_OVERHEAD_IFS;
>> +		/* airtime in us, last tx bitrate in 100kbps */
>> +		airtime = (pktlen * 8 * (1000 / 100)) / bitrate;
>> +	} else {
>> +		overhead = IEEE80211_AIRTIME_OVERHEAD;
>> +		/* This is mostly for throttle excessive BC/MC frames, and the
>> +		 * airtime/rate doesn't need be exact. Airtime of BC/MC frames
>> +		 * in 2G get some discount, which helps prevent very low rate
>> +		 * frames from being blocked for too long.
>> +		 */
>> +		airtime = (pktlen * 8 * (1000 / 100)) / 60; /* 6M */
>> +	}
>> +
>> +	airtime += overhead;
> 
> Mostly a matter of taste, I guess, but I found it a bit confusing that
> the overhead is assigned to a variable and added later instead of just
> being part of the calculations above...
> 
I am fine with both.. will change it accordingly.

-Rajkumar
