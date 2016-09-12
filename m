Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:60984 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751955AbcILQhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 12:37:47 -0400
Subject: Re: [PATCH 2/3] ath10k: Grab rcu_read_lock before the txqs spinlock.
To: Johannes Berg <johannes@sipsolutions.net>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <1471569995-10028-2-git-send-email-greearb@candelatech.com>
 <87k2elp53z.fsf@kamboji.qca.qualcomm.com> <57D2CB92.3020407@candelatech.com>
 <1473662509.4201.0.camel@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <d182bdea-089a-7b44-302c-cedcda1aa1ec@candelatech.com> (sfid-20160912_183751_021530_3358042B)
Date: Mon, 12 Sep 2016 09:37:46 -0700
MIME-Version: 1.0
In-Reply-To: <1473662509.4201.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2016 11:41 PM, Johannes Berg wrote:
>
>>>> -	rcu_read_unlock();
>>>>   	spin_unlock_bh(&ar->txqs_lock);
>>>> +	rcu_read_unlock();
>>>
>>> I'm no RCU expert but this isn't making any sense. Maybe it changes
>>> timings on your kernel so that it hides the real problem?
>>
>> I'm not sure this fixed anything or not, it just seemed weird so I
>> changed it.
>>
>> I was hoping someone that understood rcu locking would comment...
>>
>
> RCU is no "locking". The sooner you get over that notion, the better.
>
> This therefore make no sense whatsoever.
>
> In fact, you want to keep the RCU protected section *small*, so having
> the spinlock inside hurts overall system performance.

Ok, thanks for the review.  I'll drop this patch from my tree.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
