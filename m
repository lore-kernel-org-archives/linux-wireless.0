Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:57891 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753066AbdLNOea (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 09:34:30 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Felix Fietkau <nbd@nbd.name>, make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] mac80211: Add TXQ scheduling API
In-Reply-To: <78c2f69c-fafa-6270-33b5-fbce57f4a278@nbd.name>
References: <20171027141451.22768-1-toke@toke.dk> <20171031112747.5778-1-toke@toke.dk> <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name> <87lgi5jyka.fsf@toke.dk> <78c2f69c-fafa-6270-33b5-fbce57f4a278@nbd.name>
Date: Thu, 14 Dec 2017 15:34:26 +0100
Message-ID: <874lotqsy5.fsf@toke.dk> (sfid-20171214_153453_303603_3397A96E)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> On 2017-12-14 13:15, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Felix Fietkau <nbd@nbd.name> writes:
>>=20
>>> On 2017-10-31 12:27, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> This adds an API to mac80211 to handle scheduling of TXQs and changes =
the
>>>> interface between driver and mac80211 for TXQ handling as follows:
>>>>=20
>>>> - The wake_tx_queue callback interface no longer includes the TXQ. Ins=
tead,
>>>>   the driver is expected to retrieve that from ieee80211_next_txq()
>>>>=20
>>>> - Two new mac80211 functions are added: ieee80211_next_txq() and
>>>>   ieee80211_schedule_txq(). The former returns the next TXQ that shoul=
d be
>>>>   scheduled, and is how the driver gets a queue to pull packets from. =
The
>>>>   latter is called internally by mac80211 to start scheduling a queue,=
 and
>>>>   the driver is supposed to call it to re-schedule the TXQ after it is
>>>>   finished pulling packets from it (unless the queue emptied).
>>>>=20
>>>> The ath9k and ath10k drivers are changed to use the new API.
>>>>=20
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>>> Sorry that I didn't have time to give this a thorough review earlier,
>>> since I was pretty busy with other projects. Now that I'm working on
>>> porting mt76 to this new API, some things in this patch strike me as
>>> rather odd, and there might be some bugs and nasty limitations here:
>>>
>>> In the new API you can no longer select txq entries by hardware queue.
>>> When using multiple WMM queues, this could lead to station entries being
>>> requeued unnecessarily (because there is no room in the hw queue for the
>>> txq entry that ieee80211_next_txq happens to return).
>>=20
>> Yeah, there's some tension between enforcing fairness (which is a per
>> station thing) and the WMM queueing stuff (which gives priority based on
>> WMM levels and ignores stations). There are basically two ways to
>> resolve this: Prioritising fairness or prioritising WMM levels. In the
>> former case, we first select which station to transmit to, and then
>> select the highest WMM priority level queued *for that station* (the
>> last part of this is missing from the code as it is now). In the latter
>> case, we keep scheduling per-WMM, then enforce fairness within that.
>>=20
>> The former case has the potential to lead to starved hardware queues,
>> while the latter leads to unfairness. We had a bit of discussion of
>> which is better at netdev, but did not resolve it. Personally, I think
>> prioritising fairness is better, but I'm willing to be convinced
>> otherwise by data :). So my plan is to implement that fully and try it
>> out, then evaluate based on actual experiments...
>
> I don't really see how the approach taken in the current code is
> actually prioritising fairness by starving hardware queues, since any
> txq that can't be serviced in the current call because of queue depth
> will be requeued. So based on the traffic pattern this might actually
> lead to *more* unfairness.

Yeah, I'm not quite happy with the current state of the code as far as
that is concerned. I thought I would have had time to revisit this, but
then a bunch of other stuff came up and I never got around to it... Will
come back to this soon I hope... :/

>>> Since ieee80211_next_txq also refills the airtime fairness quantum, this
>>> might lead to some minor fairness issues.
>>=20
>> I'm planning to change the way the scheduler works anyway, so this issue
>> should go away. Haven't had time to do that yet, unfortunately.
>
> Well, the problem is that the new code inside ath9k is a lot harder to
> verify for correct behavior (regarding the queue starvation issue), and
> I would really like to avoid nasty regressions that will be a nightmare
> to debug.

Fair point, avoiding that would be good of course :)

>>> In ath9k the code used to have a loop that goes through all pending txq
>>> entries until it has filled the hw queues again. You replaced that with
>>> some calls to ath_txq_schedule which now only considers one single txq.
>>> There are several reasons why this queue could potentially not be servi=
ced:
>>> - ieee80211_tx_dequeue returned no frame
>>> - frame does not fit within BA window
>>> - txq was for another queue which is already filled
>>> Depending on the exact circumstances with enough stations this might
>>> lead to hardware queues getting starved.
>>=20
>> Well, that loop was already removed when I implemented the in-driver
>> fairness scheduler.
> Now that's not true. I'm looking at the diff for "mac80211: Add TXQ
> scheduling API", and it removes these lines:
>
> -       /*
> -        * If we succeed in scheduling something, immediately restart to
> make
> -        * sure we keep the HW busy.
> -        */
> -       if(ath_tx_sched_aggr(sc, txq, tid)) {
> -               if (!active) {
> -                       spin_lock_bh(&acq->lock);
> -                       list_move_tail(&tid->list, &acq->acq_old);
> -                       spin_unlock_bh(&acq->lock);
> -               }
> -               goto begin;
> -       }

Yeah, that is removed (which I suppose you are right could be
problematic in itself), but it was only being called when
ath_tx_sched_aggr() succeeds. Before (pre-airtime fairness) it did a
full loop through all scheduled tids until the hwq was full, which is
what I thought you were referring to.

>> We can't really avoid those cases entirely if we
>> want to enforce fairness (the BAW case in particular; if the only
>> eligible station from an airtime PoW has a full BAW, you have to
>> throttle and can potentially starve hwqs). However, don't think this
>> happens much in practice (or we would have seen performance regressions
>> by now).
> I think so far you simply haven't had enough users hammering on the
> new code yet.

Heh. Guess that could also be the case... ;)

>> The 'txq was for another queue' case is new with this patch, but that
>> goes back to the WMM/fairness tention above.
> I agree that this is something we need to figure out. One aspect that I
> have a major problem with is the fact that this *really* intrusive patch
> that completely changes the way that ath9k schedules tx queues is hidden
> behind this "API change" patch.
>
> The way the API stands now, mt76 would require an equally big rework to
> a different scheduling model which I'm not comfortable with at this
> point.

That is a fair point. I suppose that I was thinking too far ahead to
what I wanted to do next and didn't pay enough attention to splitting
things up into incremental changes. Of course this becomes more
important when there are more drivers affected.

> I would like to suggest the following to resolve these issues:
>
> First we should revert these patches.
> We can respin them shortly after in a modified form where
> ieee80211_next_txq takes a 'queue' argument.

By 'queue' you mean 'wmm hardware queue', right?

> I'm almost done with the incremental change for that, and it also
> supports passing -1 for queue so incrementally switching to the
> scheduling that you're proposing will also work.
>
> With that in place we can replace the ath9k change with a much smaller
> patch that is easier to verify for correctness and won't introduce the
> potential regressions that I pointed out.
>
> I will take care of the mt76 porting today and I'll also help with
> sorting out the ath10k issues.
>
> Is that acceptable to you?

Yup, sounds quite reasonable. And help with ath10k will be much
appreciated, thanks :)

-Toke
