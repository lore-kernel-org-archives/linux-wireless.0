Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38392 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752904AbcHSDe0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 23:34:26 -0400
Message-ID: <57B67CD8.5040009@candelatech.com> (sfid-20160819_053429_498678_54B7EF4C)
Date: Thu, 18 Aug 2016 20:28:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs spinlock.
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>,<1471569995-10028-2-git-send-email-greearb@candelatech.com> <1471575674214.65791@qti.qualcomm.com>
In-Reply-To: <1471575674214.65791@qti.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/18/2016 08:01 PM, Manoharan, Rajkumar wrote:
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 916119c..d96c06e 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4307,8 +4307,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
>>          int max;
>>          int loop_max = 2000;
>>
>> -       spin_lock_bh(&ar->txqs_lock);
>>          rcu_read_lock();
>> +       spin_lock_bh(&ar->txqs_lock);
>>
> Ben,
>
> It is quite possible that push_pending can be preempted after acquiring rcu_lock which
> may lead to deadlock. no? I assume to prevent that spin_lock is taken first.
>
> Could you please explain how this reordering is fixing dead lock?

It did not obviously fix the spin lock issue, but the issue went away.  Maybe it
was because I fixed the stale memory access issues at around the same time.

But, I don't think you can deadlock by taking rcu lock first and then the spinlock.

I checked all places where the spinlock is held, and I do not see any way for any of
them to block forever (In my kernel, I have a 2000 time limit on spinning in the push pending
method, which can help make sure we don't spin forever).

http://dmz2.candelatech.com/?p=linux-4.7.dev.y/.git;a=commitdiff;h=5d192657269d8e20fce733f894bb1b68df71db00

I was also worried that some calls from mac80211 might be holding rcu_read_lock while calling into
ath10k code that would grab the spinlock.  If that is the case (and I didn't verify it was), then
you could have a lock inversion by taking spinlock before rcu read lock in the push-pending method.

Anyway, someone that understands locking subtleties better might have more clue about this code
than I do.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
