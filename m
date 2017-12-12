Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:32937 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752126AbdLLJAU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 04:00:20 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wireless <linux-wireless@vger.kernel.org>
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mac80211-next tree
In-Reply-To: <1513068419.26976.86.camel@sipsolutions.net>
References: <20171212125805.5f7813fd@canb.auug.org.au> <1513068419.26976.86.camel@sipsolutions.net>
Date: Tue, 12 Dec 2017 09:59:45 +0100
Message-ID: <87r2s0uxry.fsf@toke.dk> (sfid-20171212_100033_179616_CDDAFE8E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Hi Stephen,
>
> Thanks!
>
> Felix made me aware of this yesterday evening and said he's going to
> work out the required changes to mt76.
>
> Kalle and I will make sure to submit the trees to Dave one by one so he
> doesn't have to deal with it :)
>
> Unfortunately, this might take a few days to resolve.
>
>> -void mt76_wake_tx_queue(struct ieee80211_hw *hw, struct ieee80211_txq *txq)
>> +void mt76_wake_tx_queue(struct ieee80211_hw *hw)
>>  {
>> +	struct ieee80211_txq *txq;
>>  	struct mt76_dev *dev = hw->priv;
>> -	struct mt76_txq *mtxq = (struct mt76_txq *) txq->drv_priv;
>> -	struct mt76_queue *hwq = mtxq->hwq;
>> +	struct mt76_txq *mtxq;
>> +	struct mt76_queue *hwq;
>>  
>> +	txq = ieee80211_next_txq(hw);
>> +	mtxq = (struct mt76_txq *) txq->drv_priv;
>> +	hwq = mtxq->hwq;
>
> Looks pretty much right to me - perhaps for safety there should be a
> NULL check on txq, but OTOH when you get here it should be non-NULL.

Note that while this will fix compilation it probably won't work right.
next_txq() is not guaranteed to return the same txq as was previously
passed in the wake_tx_queue() argument, so if this is the only place the
driver calls next_txq(), things are likely going to break.

Rather, the driver should call next_txq() whenever it schedules queues
instead of doing its own internal scheduling.

> Sorry for the inconvenience, I hadn't realized mt76 went in now.

Yeah, hadn't expected these streams to cross either. If Felix is looking
into this that is great; let me know if you need me to do anything else
on the mac80211 side. :)

-Toke
