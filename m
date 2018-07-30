Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54141 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730983AbeGaAZR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Jul 2018 20:25:17 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC v2 1/4] mac80211: Add TXQ scheduling API
In-Reply-To: <aaa234780cad834c2ca0a36d7a007571@codeaurora.org>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1> <153115422491.7447.12479559048433925372.stgit@alrua-x1> <361a221dd15e44028fd35440df657a3d@codeaurora.org> <87lgahbisu.fsf@toke.dk> <8d8160cd9c804d1b00ba4e234c8f1520@codeaurora.org> <87k1q09hf1.fsf@toke.dk> <f8038c8ea281b365ec560cae0dd1ec0f@codeaurora.org> <87h8l39rv8.fsf@toke.dk> <01fe0f526e992563e3b1f450f8acc9e4@codeaurora.org> <87wotr2trs.fsf@toke.dk> <25dc507c35c2dff356742626d026989d@codeaurora.org> <877elo48ea.fsf@toke.dk> <9d2d6156f7bfd173ed5098f528d7ed49@codeaurora.org> <87k1pk3n7b.fsf@toke.dk> <aaa234780cad834c2ca0a36d7a007571@codeaurora.org>
Date: Tue, 31 Jul 2018 00:48:06 +0200
Message-ID: <87effkz6ft.fsf@toke.dk> (sfid-20180731_004810_648049_0FAA8BAE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

>>> A simple change in argument may break algo. What would be seqno of
>>> first packet of txq if queue_skb() isn't reset seqno?
>> 
>> It would be 0, which would be less than the current seqno in all cases
>> except just when the seqno counter wraps.
>> 
>
> One point should be mentioned in comment section of next_txq() that
> the driver has to ensure that next_txq() iteration is serialized i.e
> no parallel txq traversal are encouraged. Though txqs_list is maintained
> in mac80211, parallel iteration may change the behavior. For example
> I thought of get rid of txqs_lock in ath10k as txqs_list is moved to 
> mac80211.
> But it is still needed. right?

Hmm, the driver really shouldn't need to do any locking apart from using
the next_txq() API. But I think you are right that the seqno mechanism
doesn't play well with unserialised access to through next_txq() from
multiple CPUs. I'll see what I can do about that, and also incorporate
the other changes we've been discussing into a new RFC series.

> Hmm.. reorder_txq() API may not needed. Calling next_txq() takes care
> of reordering list though the driver is accessing txqs directly.

Right, as long as the next_txq() path is still called even while
fetch_ind() is active, that should be fine.

>>> If we don't handle this case, then ath10k driver can not claim
>>> mac80211 ATF support. Agree that MU-MIMO won't work with DDR
>>> scheduler. and it will impact MU-MIMO performace in ath10k when
>>> mac80211 ATF is claimed by ath10k.
>> 
>> Yeah, so the question is if this is an acceptable tradeoff? Do you have
>> any idea how often MU-MIMO actually provides a benefit in the real
>> world?
>> 
> Hmm.. We have some criteria of ~1.9 gain in Mu-MIMO test cases with 50
> 11ac clients.

Hmm, yeah, that would be a shame to lose; although I do think 50-client
deployments are still relatively rare for many people. So maybe we can
make airtime fairness something that can be switched on and off for
ath10k, depending on whether users think they will be needing MU-MIMO?
Until we come up with a scheduler that can handle it, of course...

-Toke
