Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59762 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752495AbcIIOrr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 10:47:47 -0400
Message-ID: <57D2CB92.3020407@candelatech.com> (sfid-20160909_164754_211937_A51918C3)
Date: Fri, 09 Sep 2016 07:47:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs spinlock.
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com> <1471569995-10028-2-git-send-email-greearb@candelatech.com> <87k2elp53z.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87k2elp53z.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 09/09/2016 06:36 AM, Valo, Kalle wrote:
> greearb@candelatech.com writes:
>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> I was seeing some spin-lock hangs in this area of the code,
>> and it seems more proper to do the rcu-read-lock outside of
>> the spin lock.  I am not sure how much this matters, however.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 916119c..d96c06e 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4307,8 +4307,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
>>   	int max;
>>   	int loop_max = 2000;
>>
>> -	spin_lock_bh(&ar->txqs_lock);
>>   	rcu_read_lock();
>> +	spin_lock_bh(&ar->txqs_lock);
>>
>>   	last = list_last_entry(&ar->txqs, struct ath10k_txq, list);
>>   	while (!list_empty(&ar->txqs)) {
>> @@ -4342,8 +4342,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
>>   			break;
>>   	}
>>
>> -	rcu_read_unlock();
>>   	spin_unlock_bh(&ar->txqs_lock);
>> +	rcu_read_unlock();
>
> I'm no RCU expert but this isn't making any sense. Maybe it changes
> timings on your kernel so that it hides the real problem?

I'm not sure this fixed anything or not, it just seemed weird so I changed it.

I was hoping someone that understood rcu locking would comment...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
