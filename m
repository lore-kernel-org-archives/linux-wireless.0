Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60690 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbeHLXoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 12 Aug 2018 19:44:11 -0400
Message-ID: <5B70A1A6.3010906@candelatech.com> (sfid-20180812_230522_966017_5C1F5087)
Date: Sun, 12 Aug 2018 14:07:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: use-after free bug in hacked 4.16 kernel, related to fq_flow_dequeue
References: <a5e579a2-5c20-5438-83c6-1eb5ae3e5630@candelatech.com> <87in4sy2ks.fsf@toke.dk> <cbfd3c11-6896-ff43-2434-7c29b04f8a79@candelatech.com> <877el8y0yo.fsf@toke.dk>
In-Reply-To: <877el8y0yo.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2018 01:20 PM, Toke Høiland-Jørgensen wrote:
> Ben Greear <greearb@candelatech.com> writes:
>
>> On 08/02/2018 12:45 PM, Toke Høiland-Jørgensen wrote:
>>> Ben Greear <greearb@candelatech.com> writes:
>>>
>>>> This is from my hacked kernel, could be my fault. I thought the fq
>>>> guys might want to know however...
>>>
>>> Hmm, nothing obvious comes to mind; fq_flow_dequeue() just dequeues a
>>> packet from the queue; it only has two memory derefs, to fq->lock and
>>> flow->queue. Don't see why either of those should be freed at this
>>> point.
>>>
>>> Unless fq_adjust_removal() is being inlined, perhaps? Then I suppose the
>>> flow->tin reference could be the problem, if the txq_info struct was
>>> already freed; did you change anything around the handling of TXQs?
>>
>> I have worked on some stuff to fix other leaks and corruptions in ath10k related
>> to txqs, maybe that is part of this problem.  My full tree is here:
>>
>> https://github.com/greearb/linux-ct-4.16
>>
>> This bug in question is fairly repeatable on my current setup, which
>> is high speed tx + rx on a 9984 NIC, with buggy firmware that crashes
>> often in the tx path. I think the crash only happens when I rmmod the
>> driver under load, but possibly some of the fw crash cleanup logic
>> that ran previously is also involved.
>
> Yeah, if it happens under load that is consistent with packets being
> queued.
>
> It seems that mac80211 frees the netdevs of an interface before flushing
> the TXQs, which may be the cause of the bug you are seeing. Could you
> try the patch below and see if that fixes the issue?

I've run with this for a few days, and it seems to at least not cause
any extra problems.  I mostly fixed the firmware crashing I was seeing
before, so not certain it fixes the root cause of the crashes I
saw before.  I'm going to roll this into my 4.16 ct kernel for wider
testing.

Thanks,
Ben

>
> -Toke
>
>
> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
> index e65c2abb2a54..d21ef14d327d 100644
> --- a/net/mac80211/main.c
> +++ b/net/mac80211/main.c
> @@ -1213,6 +1213,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>   #if IS_ENABLED(CONFIG_IPV6)
>   	unregister_inet6addr_notifier(&local->ifa6_notifier);
>   #endif
> +	ieee80211_txq_teardown_flows(local);
>
>   	rtnl_lock();
>
> @@ -1241,7 +1242,6 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
>   	skb_queue_purge(&local->skb_queue);
>   	skb_queue_purge(&local->skb_queue_unreliable);
>   	skb_queue_purge(&local->skb_queue_tdls_chsw);
> -	ieee80211_txq_teardown_flows(local);
>
>   	destroy_workqueue(local->workqueue);
>   	wiphy_unregister(local->hw.wiphy);
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
