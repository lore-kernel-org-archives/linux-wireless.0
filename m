Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391686AbeIVGRV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Sep 2018 02:17:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 21 Sep 2018 17:26:00 -0700
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2] mac80211: budget outstanding airtime for transmission
In-Reply-To: <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name>
References: <1537470331-6270-1-git-send-email-rmanohar@codeaurora.org>
 <8d8e3775-4504-7b37-19b0-4a7fae054d12@nbd.name>
Message-ID: <ece4e4dcd2776413c8b297731df3c02c@codeaurora.org> (sfid-20180922_022646_214348_A64D67FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-09-21 04:13, Felix Fietkau wrote:
> On 2018-09-20 21:05, Rajkumar Manoharan wrote:
>> Per frame airtime estimation could be used to track outstanding 
>> airtime
>> of each txq and can be used to throttle ieee80211_tx_dequeue(). This
>> mechanism on its own will get us the queue limiting and latency
>> reduction goodness for firmwares with deep queues. And for that it can
>> be completely independent of the airtime fairness scheduler, which can
>> use the after-tx-compl airtime information to presumably get more
>> accurate fairness which includes retransmissions etc.
> What about packets that get dequeued from the txq, but get freed by
> ieee80211_free_txskb?
> I think this may be a bit fragile, since if for any reason accounting
> isn't perfect here, tx queues might stall.
> 
Good point. As Johannes mentioned, I will also handle free_txskb().

>> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
>> index e4bc43904a8e..c9997a63e5cf 100644
>> --- a/net/mac80211/tx.c
>> +++ b/net/mac80211/tx.c
>> @@ -3485,6 +3485,54 @@ static bool ieee80211_xmit_fast(struct 
>> ieee80211_sub_if_data *sdata,
>>  	return true;
>>  }
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
>> +static void ieee80211_calc_airtime_budget(struct ieee80211_local 
>> *local,
>> +					  struct sta_info *sta,
>> +					  struct sk_buff *skb, u8 ac)
>> +{
>> +	struct ieee80211_tx_info *info;
>> +	struct ieee80211_hdr *hdr;
>> +	struct rate_info rinfo;
>> +	u32 pktlen, bitrate;
>> +	u16 airtime = 0;
>> +
>> +	if (!wiphy_ext_feature_isset(local->hw.wiphy,
>> +				     NL80211_EXT_FEATURE_AIRTIME_FAIRNESS))
>> +		return;
>> +
>> +	lockdep_assert_held(&local->active_txq_lock[ac]);
>> +
>> +	hdr = (struct ieee80211_hdr *)skb->data;
>> +	info = IEEE80211_SKB_CB(skb);
>> +
>> +	sta_set_rate_info_tx(sta, &sta->tx_stats.last_rate, &rinfo);
>> +	bitrate = cfg80211_calculate_bitrate(&rinfo);
> I think for drivers using software rate control, we should use the
> primary rate from the last rate_control_set_rates() call.
> In that case, we should calculate the bitrate value inside
> rate_control_set_rates itself in order to avoid re-calculating it for
> every single dequeued packet.
> It might make sense to use similar caching on changes to
> tx_stats.last_rate.
> 
I thought of having common place for calculating bitrate for both
software based and offloaded rate control. let me explore caching 
option.

-Rajkumar
