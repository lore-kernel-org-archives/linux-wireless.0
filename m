Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:37082 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbeBAXV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 18:21:59 -0500
Subject: Re: lockdep warning in mac80211/tx.c, 4.13.16+ kernel, ath9k related
To: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <d4632910-7dd9-b066-0c10-b21dd7cbfc61@candelatech.com>
 <1517523817.28814.10.camel@sipsolutions.net>
 <e8f8b910-ffa8-fbc7-3152-58ccf70b1ace@candelatech.com>
 <1517524837.28814.14.camel@sipsolutions.net>
 <1517525226.28814.15.camel@sipsolutions.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <488be568-d9c1-0697-9fa4-e1a623b4bed5@candelatech.com> (sfid-20180202_002204_563482_F1EAB9A9)
Date: Thu, 1 Feb 2018 15:21:57 -0800
MIME-Version: 1.0
In-Reply-To: <1517525226.28814.15.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2018 02:47 PM, Johannes Berg wrote:
> On Thu, 2018-02-01 at 23:40 +0100, Johannes Berg wrote:
>>
>> The code does a plain rcu_dereference(), no locking other than
>> rcu_read_lock() involved.
>>
>> On second thought though, I'm not convinced that your modifications
>> caused the problem.
>>
>> Given your call stack, we'd expect rcu_read_lock() somewhere around
>> ath_tid_dequeue (or its caller(s)), since ieee80211_tx_dequeue clearly
>> requires it.
>>
>> Normally, ieee80211_tx_dequeue() is called from various places that
>> probably come from mac80211 and already hold the rcu_read_lock(), e.g.
>> the wake_tx_queue op.
>>
>> In this case, you're coming from drv_sta_state, so not sure why the
>> driver thinks it's OK to call the dequeue there.
>
> Just to clarify - it could just be that in the "normal" case, when a
> station dies, there's nothing on the queues - so the dequeue just
> doesn't do anything and never goes into the code path where the
> rcu_dereference() is, hence it might be a bug in mainline that just
> never triggers in ordinary scenarios.

It looks like the code in ath9k has not been changed in that area for
some time.

Would adding rcu_read_lock in drv_sta_state() be a possibility?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
