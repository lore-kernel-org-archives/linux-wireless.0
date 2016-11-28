Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42123 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932284AbcK1JeJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 04:34:09 -0500
Subject: Re: [PATCH v2] ath9k: Introduce airtime fairness scheduling between
 stations
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <20160617090929.31606-1-toke@toke.dk>
 <20161124135455.29327-1-toke@toke.dk>
 <87wpfr8u9v.fsf@kamboji.qca.qualcomm.com> <87inr8q5iq.fsf@toke.dk>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <4533523f-deb5-69f6-aeb7-f5312285b49e@nbd.name> (sfid-20161128_103415_849156_18343836)
Date: Mon, 28 Nov 2016 10:34:11 +0100
MIME-Version: 1.0
In-Reply-To: <87inr8q5iq.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-11-27 16:58, Toke Høiland-Jørgensen wrote:
> "Valo, Kalle" <kvalo@qca.qualcomm.com> writes:
> 
>> (The make-wifi-fast list is annoying as it always spams me when it's on
>> CC, so dropped it.)
>>
>> Toke Høiland-Jørgensen <toke@toke.dk> writes:
>>
>>> This reworks the ath9k driver to schedule transmissions to connected
>>> stations in a way that enforces airtime fairness between them. It
>>> accomplishes this by measuring the time spent transmitting to or
>>> receiving from a station at TX and RX completion, and accounting this to
>>> a per-station, per-QoS level airtime deficit. Then, an FQ-CoDel based
>>> deficit scheduler is employed at packet dequeue time, to control which
>>> station gets the next transmission opportunity.
>>>
>>> Airtime fairness can significantly improve the efficiency of the network
>>> when station rates vary. The following throughput values are from a
>>> simple three-station test scenario, where two stations operate at the
>>> highest HT20 rate, and one station at the lowest, and the scheduler is
>>> employed at the access point:
>>>
>>>                   Before   /   After
>>> Fast station 1:    19.17   /   25.09 Mbps
>>> Fast station 2:    19.83   /   25.21 Mbps
>>> Slow station:       2.58   /    1.77 Mbps
>>> Total:             41.58   /   52.07 Mbps
>>>
>>> The benefit of airtime fairness goes up the more stations are present.
>>> In a 30-station test with one station artificially limited to 1 Mbps,
>>> we have seen aggregate throughput go from 2.14 to 17.76 Mbps.
>>>
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>>
>> [...]
>>
>>> +void ath_acq_lock(struct ath_softc *sc, struct ath_acq *acq)
>>> +	__acquires(&acq->lock)
>>> +{
>>> +	spin_lock_bh(&acq->lock);
>>> +}
>>> +
>>> +void ath_acq_unlock(struct ath_softc *sc, struct ath_acq *acq)
>>> +	__releases(&acq->lock)
>>> +{
>>> +	spin_unlock_bh(&acq->lock);
>>> +}
>>
>> Why these? To me it looks like they just add an extra function jump and
>> unneccessary extra layer.
> 
> Well, there's already similar functions for the txq lock (ath_txq_lock()
> and ath_txq_unlock() in xmit.c), so figured I'd be consistent with
> those. And also that the __acquires and __releases macros were probably
> useful.
> 
> Also, won't the compiler automatically inline them?
Not necessarily, these functions are not static. I think it would be a
good idea to turn the ath_txq_lock/unlock functions into static inline
functions as well.

Please don't blindly repeat patterns that are already there, some of
them might just not make any sense at all ;)

- Felix
