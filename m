Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50769 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932883AbcLMNxC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 08:53:02 -0500
Subject: Re: [PATCH] ath9k: unlock rcu read when returning early
To: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        kvalo@codeaurora.org, helgaas@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        marc.zyngier@arm.com, Janusz.Dziedzic@tieto.com,
        rmanohar@qti.qualcomm.com, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, rmanohar@qca.qualcomm.com,
        bharat.kumar.gogada@xilinx.com
References: <1cFMHb-00BdWd-Ks>
 <20161212185001.3857-1-tobias.johannes.klausmann@mni.thm.de>
 <e15c5efc-d548-8b32-ca86-5ec26506ff7c@nbd.name>
 <7b4b7748-06d6-92d4-228c-e7ebf00f8699@mni.thm.de>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <25aebea3-f954-6bef-f17f-162c9c8b6559@nbd.name> (sfid-20161213_145325_303332_15D79B7F)
Date: Tue, 13 Dec 2016 14:52:49 +0100
MIME-Version: 1.0
In-Reply-To: <7b4b7748-06d6-92d4-228c-e7ebf00f8699@mni.thm.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-12-13 14:41, Tobias Klausmann wrote:
> On 13.12.2016 11:41, Felix Fietkau wrote:
>> On 2016-12-12 19:50, Tobias Klausmann wrote:
>>> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
>>> index 52bfbb988611..857d5ae09a1d 100644
>>> --- a/drivers/net/wireless/ath/ath9k/xmit.c
>>> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
>>> @@ -2787,6 +2787,7 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
>>>   		fifo_list = &txq->txq_fifo[txq->txq_tailidx];
>>>   		if (list_empty(fifo_list)) {
>>>   			ath_txq_unlock(sc, txq);
>>> +			rcu_read_unlock();
>> Technically this is fine as well, but I'd prefer a fix where you replace
>> the 'return' with 'break', thus avoiding the duplication of
>> rcu_read_unlock()
> 
> Actually if you want to avoid it, maybe skipping over the rest is better 
> (as originally intended):
> 
> ...
> 
> ath_txq_unlock(sc, txq);
> 
> 
> goto unlock;
> }
> ...
> 
> unlock:
> rcu_read_unlock();
There are already other places that skip to the rcu_read_unlock() part
by using 'break'. I don't see how adding an unnecessary goto makes
things any better.

- Felix
