Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:56320 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487AbYLCEMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 23:12:35 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1374117yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 20:12:33 -0800 (PST)
Message-ID: <43e72e890812022012o7759400mf002f51c0a3f0eb@mail.gmail.com> (sfid-20081203_051241_197898_45D77BEB)
Date: Tue, 2 Dec 2008 20:12:33 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [ath9k-devel] [PATCH v2 2/2] ath9k: Use GFP_ATOMIC when allocating TX private area
Cc: "Senthil Balasubramanian" <senthilkumar@atheros.com>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <18742.299.281327.259785@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1228274124-25140-1-git-send-email-lrodriguez@atheros.com>
	 <1228274124-25140-2-git-send-email-lrodriguez@atheros.com>
	 <1228274124-25140-3-git-send-email-lrodriguez@atheros.com>
	 <18742.299.281327.259785@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 7:46 PM, Sujith <m.sujith@gmail.com> wrote:
> Luis R. Rodriguez wrote:
>> @@ -1813,10 +1815,30 @@ int ath_tx_start(struct ath_softc *sc, struct sk_buff *skb,
>>
>>       r = ath_tx_setup_buffer(sc, bf, skb, txctl);
>>       if (r) {
>> -             spin_lock_bh(&sc->sc_txbuflock);
>> +             struct ath_txq *txq = NULL;
>> +             int qnum;
>> +
>> +             qnum = ath_get_hal_qnum(skb_get_queue_mapping(skb), sc);
>> +             txq = &sc->sc_txq[qnum];
>> +
>>               DPRINTF(sc, ATH_DBG_FATAL, "TX mem alloc failure\n");
>> +
>> +             /* upon ath_tx_processq() this TX queue will be resumed, we
>> +              * guarantee this will happen by knowing beforehand that
>> +              * we will at least have to run TX completionon one buffer
>> +              * on the queue */
>> +             spin_lock_bh(&txq->axq_lock);
>> +             if (ath_txq_depth(sc, txq->axq_qnum) > 1) {
>> +                     ieee80211_stop_queue(sc->hw,
>> +                             skb_get_queue_mapping(skb));
>> +                     txq->stopped = 1;
>> +             }
>> +             spin_unlock_bh(&txq->axq_lock);
>> +
>> +             spin_lock_bh(&sc->sc_txbuflock);
>>               list_add_tail(&bf->list, &sc->sc_txbuf);
>>               spin_unlock_bh(&sc->sc_txbuflock);
>> +
>
> The queue is already available, we make sure of that before calling ath_tx_start().
> And the queue is sent through txctl.txq, you don't have to calculate the queue number again.
>
> So, just stopping the queue and moving the buffer back to the free list would be enough.

ath_test_get_txq() will not return the queue only if the queue is
getting full. What the check above guarantees is we have at least one
buffer to run through procesq before disabling the TX queue, otherwise
the queue won't be be woken up. Or am I missing something? That is,
say you just have to TX one skb and we hit -ENOMEM on
ath_tx_setup_buffer() and you disable the queue. How will this queue
be awoken if this is true in ath_tx_processq():

list_empty(&txq->axq_q)

  Luis
