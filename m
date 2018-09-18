Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45713 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726768AbeIRQBo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 12:01:44 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk> <13400b5f9bdb5e36c6afabd071cc7b0d@codeaurora.org>
Date: Tue, 18 Sep 2018 12:29:44 +0200
Message-ID: <87o9cvksiv.fsf@toke.dk> (sfid-20180918_122949_701246_BFC89227)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-16 10:42, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> +/**
>> + * ieee80211_return_txq - return a TXQ previously acquired by
>> ieee80211_next_txq()
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @txq: pointer obtained from station or virtual interface
>> + *
>> + * Should only be called between calls to=20
>> ieee80211_txq_schedule_start()
>> + * and ieee80211_txq_schedule_end().
>> + */
>> +void ieee80211_return_txq(struct ieee80211_hw *hw, struct=20
>> ieee80211_txq *txq);
>> +
>>=20
> return_txq() should return a bool to inform the driver that whether
> txq is queued back or not.

What would the driver do with that return value, exactly?

> Otherwise the same txq will be served indefinitely until txq becomes
> empty. This problem occurs when the driver is running out of hw
> descriptors or driver sends only N frames (< backlog_packets).

No, if it's using next_txq(), the API guarantees that the same TXQ will
not be returned more than once between a set of calls to
schedule_start()/schedule_end() (by way of the seqno mechanism). I
didn't add the same check to may_transmit(), because I assumed the
driver would not be looping in this case. Is that not correct?

> Also an option to add the node at head or tail would be preferred. If
> return_txq adds node at head of list, then it is forcing the driver to
> serve same txq until it becomes empty. Also this will not allow the
> driver to send N frames from each txqs.

The whole point of this patch set is to move those kinds of decisions
out of the driver and into mac80211. The airtime scheduler won't achieve
fairness if it allows queues to be queued to the end of the rotation
before its deficit turns negative. And obviously there's some lag in
this since we're using after-the-fact airtime information.

For ath9k this has not really been a problem in my tests; if the lag
turns out to be too great for ath10k (which I suppose is a possibility
since we don't get airtime information on every TX-compl), I figure we
can use the same estimated airtime value that is used for throttling the
queues to adjust the deficit immediately...

>> +/**
>> + * ieee80211_txq_schedule_start - acquire locks for safe scheduling of=
=20
>> an AC
>> + *
>> + * @hw: pointer as obtained from ieee80211_alloc_hw()
>> + * @ac: AC number to acquire locks for
>> + *
>> + * Acquire locks needed to schedule TXQs from the given AC. Should be=20
>> called
>> + * before ieee80211_next_txq() or ieee80211_schedule_txq().
>> + */
> Typo error. s/schedule_txq()/return_txq()/.

Yup, will fix :)

-Toke
