Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47740 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932203AbcHSNej (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 09:34:39 -0400
Message-ID: <57B70AED.2010200@candelatech.com> (sfid-20160819_153446_739844_BFCBC91A)
Date: Fri, 19 Aug 2016 06:34:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com> <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com>
In-Reply-To: <CA+BoTQn0d1bEB662r-Yivmdk_21LhjCQjJP_GoPaj-WT2wA=1g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/18/2016 11:59 PM, Michal Kazior wrote:
> On 19 August 2016 at 03:26,  <greearb@candelatech.com> wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> I was seeing kernel crashes due to accessing freed memory
>> while debugging a 9984 firmware that was crashing often.
>>
>> This patch fixes the crashes.  I am not certain if there
>> is a better way or not.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 5659ef1..916119c 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4172,8 +4172,10 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
>>   static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>>   {
>>          struct ath10k_txq *artxq = (void *)txq->drv_priv;
>> +       struct ath10k_txq *tmp, *walker;
>>          struct ath10k_skb_cb *cb;
>>          struct sk_buff *msdu;
>> +       struct ieee80211_txq *txq_tmp;
>>          int msdu_id;
>>
>>          if (!txq)
>> @@ -4182,6 +4184,14 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>>          spin_lock_bh(&ar->txqs_lock);
>>          if (!list_empty(&artxq->list))
>>                  list_del_init(&artxq->list);
>> +
>> +       /* Remove from ar->txqs in case it still exists there. */
>> +       list_for_each_entry_safe(walker, tmp, &ar->txqs, list) {
>> +               txq_tmp = container_of((void *)walker, struct ieee80211_txq,
>> +                                      drv_priv);
>> +               if (txq_tmp == txq)
>> +                       list_del(&walker->list);
>> +       }
>
> How could this even happen? All artxq->list accesses (add/del) are
> protected by txqs_lock so this shouldn't happen, no?
>
> Do you perhaps have the logic around txqs reworked in your tree?

I don't have any significant changes as far as I can tell.

I can build you a buggy 9984 firmware to reproduce the problem if you want...

Maybe the upstream patch could WARN_ON in this case to see if anyone else
ever hits it?

I did see a comment in the mac80211 about some assumptions on the driver with
regard to station teardown...I am not 100% sure ath10k meets that assumption,
so maybe that is why I could see this problem.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
