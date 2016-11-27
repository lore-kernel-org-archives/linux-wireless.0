Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:45711 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751934AbcK0P6N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2016 10:58:13 -0500
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: "Valo\, Kalle" <kvalo@qca.qualcomm.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k: Introduce airtime fairness scheduling between stations
References: <20160617090929.31606-1-toke@toke.dk>
        <20161124135455.29327-1-toke@toke.dk>
        <87wpfr8u9v.fsf@kamboji.qca.qualcomm.com>
Date: Sun, 27 Nov 2016 16:58:05 +0100
In-Reply-To: <87wpfr8u9v.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 25 Nov 2016 15:16:13 +0000")
Message-ID: <87inr8q5iq.fsf@toke.dk> (sfid-20161127_165825_883342_E96F38E4)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Valo, Kalle" <kvalo@qca.qualcomm.com> writes:

> (The make-wifi-fast list is annoying as it always spams me when it's on
> CC, so dropped it.)
>
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>
>> This reworks the ath9k driver to schedule transmissions to connected
>> stations in a way that enforces airtime fairness between them. It
>> accomplishes this by measuring the time spent transmitting to or
>> receiving from a station at TX and RX completion, and accounting this to
>> a per-station, per-QoS level airtime deficit. Then, an FQ-CoDel based
>> deficit scheduler is employed at packet dequeue time, to control which
>> station gets the next transmission opportunity.
>>
>> Airtime fairness can significantly improve the efficiency of the network
>> when station rates vary. The following throughput values are from a
>> simple three-station test scenario, where two stations operate at the
>> highest HT20 rate, and one station at the lowest, and the scheduler is
>> employed at the access point:
>>
>>                   Before   /   After
>> Fast station 1:    19.17   /   25.09 Mbps
>> Fast station 2:    19.83   /   25.21 Mbps
>> Slow station:       2.58   /    1.77 Mbps
>> Total:             41.58   /   52.07 Mbps
>>
>> The benefit of airtime fairness goes up the more stations are present.
>> In a 30-station test with one station artificially limited to 1 Mbps,
>> we have seen aggregate throughput go from 2.14 to 17.76 Mbps.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> [...]
>
>> +void ath_acq_lock(struct ath_softc *sc, struct ath_acq *acq)
>> +	__acquires(&acq->lock)
>> +{
>> +	spin_lock_bh(&acq->lock);
>> +}
>> +
>> +void ath_acq_unlock(struct ath_softc *sc, struct ath_acq *acq)
>> +	__releases(&acq->lock)
>> +{
>> +	spin_unlock_bh(&acq->lock);
>> +}
>
> Why these? To me it looks like they just add an extra function jump and
> unneccessary extra layer.

Well, there's already similar functions for the txq lock (ath_txq_lock()
and ath_txq_unlock() in xmit.c), so figured I'd be consistent with
those. And also that the __acquires and __releases macros were probably
useful.

Also, won't the compiler automatically inline them?

-Toke
