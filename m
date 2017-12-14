Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:54365 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751729AbdLNMPF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:15:05 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name>
References: <20171027141451.22768-1-toke@toke.dk> <20171031112747.5778-1-toke@toke.dk> <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name>
Date: Thu, 14 Dec 2017 13:15:01 +0100
Message-ID: <87lgi5jyka.fsf@toke.dk> (sfid-20171214_131510_346490_E671C283)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-10-31 12:27, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds an API to mac80211 to handle scheduling of TXQs and changes the
>> interface between driver and mac80211 for TXQ handling as follows:
>>=20
>> - The wake_tx_queue callback interface no longer includes the TXQ. Inste=
ad,
>>   the driver is expected to retrieve that from ieee80211_next_txq()
>>=20
>> - Two new mac80211 functions are added: ieee80211_next_txq() and
>>   ieee80211_schedule_txq(). The former returns the next TXQ that should =
be
>>   scheduled, and is how the driver gets a queue to pull packets from. The
>>   latter is called internally by mac80211 to start scheduling a queue, a=
nd
>>   the driver is supposed to call it to re-schedule the TXQ after it is
>>   finished pulling packets from it (unless the queue emptied).
>>=20
>> The ath9k and ath10k drivers are changed to use the new API.
>>=20
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Sorry that I didn't have time to give this a thorough review earlier,
> since I was pretty busy with other projects. Now that I'm working on
> porting mt76 to this new API, some things in this patch strike me as
> rather odd, and there might be some bugs and nasty limitations here:
>
> In the new API you can no longer select txq entries by hardware queue.
> When using multiple WMM queues, this could lead to station entries being
> requeued unnecessarily (because there is no room in the hw queue for the
> txq entry that ieee80211_next_txq happens to return).

Yeah, there's some tension between enforcing fairness (which is a per
station thing) and the WMM queueing stuff (which gives priority based on
WMM levels and ignores stations). There are basically two ways to
resolve this: Prioritising fairness or prioritising WMM levels. In the
former case, we first select which station to transmit to, and then
select the highest WMM priority level queued *for that station* (the
last part of this is missing from the code as it is now). In the latter
case, we keep scheduling per-WMM, then enforce fairness within that.

The former case has the potential to lead to starved hardware queues,
while the latter leads to unfairness. We had a bit of discussion of
which is better at netdev, but did not resolve it. Personally, I think
prioritising fairness is better, but I'm willing to be convinced
otherwise by data :). So my plan is to implement that fully and try it
out, then evaluate based on actual experiments...

> Since ieee80211_next_txq also refills the airtime fairness quantum, this
> might lead to some minor fairness issues.

I'm planning to change the way the scheduler works anyway, so this issue
should go away. Haven't had time to do that yet, unfortunately.

> In ath9k the code used to have a loop that goes through all pending txq
> entries until it has filled the hw queues again. You replaced that with
> some calls to ath_txq_schedule which now only considers one single txq.
> There are several reasons why this queue could potentially not be service=
d:
> - ieee80211_tx_dequeue returned no frame
> - frame does not fit within BA window
> - txq was for another queue which is already filled
> Depending on the exact circumstances with enough stations this might
> lead to hardware queues getting starved.

Well, that loop was already removed when I implemented the in-driver
fairness scheduler. We can't really avoid those cases entirely if we
want to enforce fairness (the BAW case in particular; if the only
eligible station from an airtime PoW has a full BAW, you have to
throttle and can potentially starve hwqs). However, don't think this
happens much in practice (or we would have seen performance regressions
by now).

The 'txq was for another queue' case is new with this patch, but that
goes back to the WMM/fairness tention above.

> In ath10k the issues are different. You left a loop to service queues in
> place, and if I'm reading it correctly, you could be facing an infinite
> loop here:
> Let's assume that ath10k_mac_tx_push_pending gets called and there are
> multiple txqs pending.
> The first txq has 16 frames pending, gets serviced, requeued.
> Second txq has lots of frames pending, 16 frames are pushed out, the txq
> is requeued.
> Back to the first one, ath10k_mac_tx_push_txq returns -ENOENT, so no
> requeue.
> Back to the second one, hardware queues are filled,
> ath10k_mac_tx_can_push returns false, so ret stays 0, txq gets requeued.
> By now first =3D=3D txq can never happen anymore because the first txq is
> not scheduled anymore.
> Seems like an infinite loop to me.

Hmm, you may be right here. I don't have the hardware to test this on
ath10k :/

> I think dealing with these corner cases will be easier if we support
> filtering by queue in ieee80211_next_txq, so I will send a patch for
> that.

Not necessarily opposed to a flag (or however you end up implementing
this). We may have to ignore it if we want to prioritise fairness, as
noted above. However, having the flag could potentially make this user
configurable. I guess I'll have a look at your patch :)

-Toke
