Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:48973 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727391AbeIUSaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Sep 2018 14:30:00 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH RFC v4 0/4] Move TXQ scheduling into mac80211
In-Reply-To: <6f97d6300d514c0b6577c9c9376b98a8@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1> <6f97d6300d514c0b6577c9c9376b98a8@codeaurora.org>
Date: Fri, 21 Sep 2018 14:41:15 +0200
Message-ID: <87tvmjhvkk.fsf@toke.dk> (sfid-20180921_144120_805495_FB394210)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-09-16 10:42, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Another update, addressing most of the concerns raised in the last=20
>> round:
>>=20
>> - Added schedule_start()/end() functions that adds locking around the
>>   whole scheduling operation, which means we can get rid of the 'first'
>>   parameter to ieee80211_next_txq().
>>=20
> Toke,
>
> Wouldn't this start()/end() APIs cause deadlock if mac80211 tries to=20
> acquire
> active_txq_lock[ac] again? Or am I missing?
>
> schedule_start()
> while (next_txq()) {
>    push_txq -> tx_dequeue()
>    return_txq()
> }
> schedule_end()
>
> tx_dequeue()
>   ieee80211_free_txskb
>    -> ieee80211_report_used_skb
>     -> ieee80211_tdls_td_tx_handle
>      -> ieee80211_subif_start_xmit
>      -> __ieee80211_subif_start_xmit
>        -> ieee80211_xmit_fast
>          -> ieee80211_queue_skb
>           -> schedule_and_wake_txq

Hmm, yeah, that call sequence would certainly deadlock. But earlier, I
think; ieee80211_queue_skb() already takes fq->lock, which is being held
by tx_dequeue(), so this would deadlock on that?

I guess retransmits of TDLS teardown packets don't happen so often?
Otherwise someone would have run into this by now? Or are those frames
not being transmitted through the TXQs at all?

In any case it does seem a bit dangerous to have a possible path where
ieee80211_free_txskb() will result in a call to
ieee80211_subif_start_xmit(). So we should probably fix that in any
case?

-Toke
