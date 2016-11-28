Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:41649 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754289AbcK1KAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 05:00:22 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>
Cc: "Valo\, Kalle" <kvalo@qca.qualcomm.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: Introduce airtime fairness scheduling between stations
References: <20160617090929.31606-1-toke@toke.dk>
        <20161124135455.29327-1-toke@toke.dk>
        <87wpfr8u9v.fsf@kamboji.qca.qualcomm.com> <87inr8q5iq.fsf@toke.dk>
        <4533523f-deb5-69f6-aeb7-f5312285b49e@nbd.name>
Date: Mon, 28 Nov 2016 11:00:17 +0100
In-Reply-To: <4533523f-deb5-69f6-aeb7-f5312285b49e@nbd.name> (Felix Fietkau's
        message of "Mon, 28 Nov 2016 10:34:11 +0100")
Message-ID: <87mvgjvs9a.fsf@toke.dk> (sfid-20161128_110026_822035_B9F4FF7B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2016-11-27 16:58, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> "Valo, Kalle" <kvalo@qca.qualcomm.com> writes:
>>=20
>>> (The make-wifi-fast list is annoying as it always spams me when it's on
>>> CC, so dropped it.)
>>>
>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>>
>>>> This reworks the ath9k driver to schedule transmissions to connected
>>>> stations in a way that enforces airtime fairness between them. It
>>>> accomplishes this by measuring the time spent transmitting to or
>>>> receiving from a station at TX and RX completion, and accounting this =
to
>>>> a per-station, per-QoS level airtime deficit. Then, an FQ-CoDel based
>>>> deficit scheduler is employed at packet dequeue time, to control which
>>>> station gets the next transmission opportunity.
>>>>
>>>> Airtime fairness can significantly improve the efficiency of the netwo=
rk
>>>> when station rates vary. The following throughput values are from a
>>>> simple three-station test scenario, where two stations operate at the
>>>> highest HT20 rate, and one station at the lowest, and the scheduler is
>>>> employed at the access point:
>>>>
>>>>                   Before   /   After
>>>> Fast station 1:    19.17   /   25.09 Mbps
>>>> Fast station 2:    19.83   /   25.21 Mbps
>>>> Slow station:       2.58   /    1.77 Mbps
>>>> Total:             41.58   /   52.07 Mbps
>>>>
>>>> The benefit of airtime fairness goes up the more stations are present.
>>>> In a 30-station test with one station artificially limited to 1 Mbps,
>>>> we have seen aggregate throughput go from 2.14 to 17.76 Mbps.
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>>
>>> [...]
>>>
>>>> +void ath_acq_lock(struct ath_softc *sc, struct ath_acq *acq)
>>>> +	__acquires(&acq->lock)
>>>> +{
>>>> +	spin_lock_bh(&acq->lock);
>>>> +}
>>>> +
>>>> +void ath_acq_unlock(struct ath_softc *sc, struct ath_acq *acq)
>>>> +	__releases(&acq->lock)
>>>> +{
>>>> +	spin_unlock_bh(&acq->lock);
>>>> +}
>>>
>>> Why these? To me it looks like they just add an extra function jump and
>>> unneccessary extra layer.
>>=20
>> Well, there's already similar functions for the txq lock (ath_txq_lock()
>> and ath_txq_unlock() in xmit.c), so figured I'd be consistent with
>> those. And also that the __acquires and __releases macros were probably
>> useful.
>>=20
>> Also, won't the compiler automatically inline them?
> Not necessarily, these functions are not static. I think it would be a
> good idea to turn the ath_txq_lock/unlock functions into static inline
> functions as well.

Right, I'll re-send with these functions fixed, and send a separate
patch to fix ath_txq_lock*

> Please don't blindly repeat patterns that are already there, some of
> them might just not make any sense at all ;)

But that would imply that kernel developers are not infallible. Surely
that can't be right? ;)

-Toke
