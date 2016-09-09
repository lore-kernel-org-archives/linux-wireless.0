Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38350 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754006AbcIIRqj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 13:46:39 -0400
Subject: Re: [PATCH 1/3] ath10k: Ensure there are no stale ar->txqs entries.
To: Felix Fietkau <nbd@nbd.name>, ath10k@lists.infradead.org
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>
 <a9add01b-4d5a-0e1c-d856-64dcf71bdb1c@nbd.name>
Cc: linux-wireless@vger.kernel.org
From: Ben Greear <greearb@candelatech.com>
Message-ID: <86ebec61-7fd7-dac2-d3da-c008899c138e@candelatech.com> (sfid-20160909_194656_397257_35180584)
Date: Fri, 9 Sep 2016 10:46:36 -0700
MIME-Version: 1.0
In-Reply-To: <a9add01b-4d5a-0e1c-d856-64dcf71bdb1c@nbd.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/2016 10:25 AM, Felix Fietkau wrote:
> On 2016-08-19 03:26, greearb@candelatech.com wrote:
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
>>  drivers/net/wireless/ath/ath10k/mac.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index 5659ef1..916119c 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -4172,8 +4172,10 @@ static void ath10k_mac_txq_init(struct ieee80211_txq *txq)
>>  static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>>  {
>>  	struct ath10k_txq *artxq = (void *)txq->drv_priv;
>> +	struct ath10k_txq *tmp, *walker;
>>  	struct ath10k_skb_cb *cb;
>>  	struct sk_buff *msdu;
>> +	struct ieee80211_txq *txq_tmp;
>>  	int msdu_id;
>>
>>  	if (!txq)
>> @@ -4182,6 +4184,14 @@ static void ath10k_mac_txq_unref(struct ath10k *ar, struct ieee80211_txq *txq)
>>  	spin_lock_bh(&ar->txqs_lock);
>>  	if (!list_empty(&artxq->list))
>>  		list_del_init(&artxq->list);
>> +
>> +	/* Remove from ar->txqs in case it still exists there. */
>> +	list_for_each_entry_safe(walker, tmp, &ar->txqs, list) {
>> +		txq_tmp = container_of((void *)walker, struct ieee80211_txq,
>> +				       drv_priv);
>> +		if (txq_tmp == txq)
>> +			list_del(&walker->list);
>> +	}
> This makes no sense at all. From txq_tmp == txq we can deduce that
> walker == artxq. In the context above, it already does a
> list_del_init(&artxq->list).

This fixed my problem, so something about this matters.

Possibly it works around some other race, just possibly it
is because of some other regression/bug in my driver/kernel.

I thought maybe the issue was that flushing doesn't really work
for ath10k, so when the upper stack tried to flush and delete
a station there were still skbs in the driver that were referencing
the txqs up in mac80211.

Also, this bug was triggered by firmware that crashed very often on
transmit of an skb, so in general there were skbs that were not properly
transmitted and maybe that also triggers some other bug/race in the
driver.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
