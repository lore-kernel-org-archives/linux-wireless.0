Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41508 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752299AbdLNMoX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:44:23 -0500
Subject: Re: [PATCH v3 1/3] mac80211: Add TXQ scheduling API
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <20171027141451.22768-1-toke@toke.dk>
 <20171031112747.5778-1-toke@toke.dk>
 <b2ed2696-db3d-4797-b5e2-161172fd2413@nbd.name> <87lgi5jyka.fsf@toke.dk>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <78c2f69c-fafa-6270-33b5-fbce57f4a278@nbd.name> (sfid-20171214_134427_061879_147A12E8)
Date: Thu, 14 Dec 2017 13:44:20 +0100
MIME-Version: 1.0
In-Reply-To: <87lgi5jyka.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-12-14 13:15, Toke Høiland-Jørgensen wrote:
> Felix Fietkau <nbd@nbd.name> writes:
> 
>> On 2017-10-31 12:27, Toke Høiland-Jørgensen wrote:
>>> This adds an API to mac80211 to handle scheduling of TXQs and changes the
>>> interface between driver and mac80211 for TXQ handling as follows:
>>> 
>>> - The wake_tx_queue callback interface no longer includes the TXQ. Instead,
>>>   the driver is expected to retrieve that from ieee80211_next_txq()
>>> 
>>> - Two new mac80211 functions are added: ieee80211_next_txq() and
>>>   ieee80211_schedule_txq(). The former returns the next TXQ that should be
>>>   scheduled, and is how the driver gets a queue to pull packets from. The
>>>   latter is called internally by mac80211 to start scheduling a queue, and
>>>   the driver is supposed to call it to re-schedule the TXQ after it is
>>>   finished pulling packets from it (unless the queue emptied).
>>> 
>>> The ath9k and ath10k drivers are changed to use the new API.
>>> 
>>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>> Sorry that I didn't have time to give this a thorough review earlier,
>> since I was pretty busy with other projects. Now that I'm working on
>> porting mt76 to this new API, some things in this patch strike me as
>> rather odd, and there might be some bugs and nasty limitations here:
>>
>> In the new API you can no longer select txq entries by hardware queue.
>> When using multiple WMM queues, this could lead to station entries being
>> requeued unnecessarily (because there is no room in the hw queue for the
>> txq entry that ieee80211_next_txq happens to return).
> 
> Yeah, there's some tension between enforcing fairness (which is a per
> station thing) and the WMM queueing stuff (which gives priority based on
> WMM levels and ignores stations). There are basically two ways to
> resolve this: Prioritising fairness or prioritising WMM levels. In the
> former case, we first select which station to transmit to, and then
> select the highest WMM priority level queued *for that station* (the
> last part of this is missing from the code as it is now). In the latter
> case, we keep scheduling per-WMM, then enforce fairness within that.
> 
> The former case has the potential to lead to starved hardware queues,
> while the latter leads to unfairness. We had a bit of discussion of
> which is better at netdev, but did not resolve it. Personally, I think
> prioritising fairness is better, but I'm willing to be convinced
> otherwise by data :). So my plan is to implement that fully and try it
> out, then evaluate based on actual experiments...
I don't really see how the approach taken in the current code is
actually prioritising fairness by starving hardware queues, since any
txq that can't be serviced in the current call because of queue depth
will be requeued. So based on the traffic pattern this might actually
lead to *more* unfairness.

>> Since ieee80211_next_txq also refills the airtime fairness quantum, this
>> might lead to some minor fairness issues.
> 
> I'm planning to change the way the scheduler works anyway, so this issue
> should go away. Haven't had time to do that yet, unfortunately.Well, the problem is that the new code inside ath9k is a lot harder to
verify for correct behavior (regarding the queue starvation issue), and
I would really like to avoid nasty regressions that will be a nightmare
to debug.

>> In ath9k the code used to have a loop that goes through all pending txq
>> entries until it has filled the hw queues again. You replaced that with
>> some calls to ath_txq_schedule which now only considers one single txq.
>> There are several reasons why this queue could potentially not be serviced:
>> - ieee80211_tx_dequeue returned no frame
>> - frame does not fit within BA window
>> - txq was for another queue which is already filled
>> Depending on the exact circumstances with enough stations this might
>> lead to hardware queues getting starved.
> 
> Well, that loop was already removed when I implemented the in-driver
> fairness scheduler.
Now that's not true. I'm looking at the diff for "mac80211: Add TXQ
scheduling API", and it removes these lines:

-       /*
-        * If we succeed in scheduling something, immediately restart to
make
-        * sure we keep the HW busy.
-        */
-       if(ath_tx_sched_aggr(sc, txq, tid)) {
-               if (!active) {
-                       spin_lock_bh(&acq->lock);
-                       list_move_tail(&tid->list, &acq->acq_old);
-                       spin_unlock_bh(&acq->lock);
-               }
-               goto begin;
-       }


> We can't really avoid those cases entirely if we
> want to enforce fairness (the BAW case in particular; if the only
> eligible station from an airtime PoW has a full BAW, you have to
> throttle and can potentially starve hwqs). However, don't think this
> happens much in practice (or we would have seen performance regressions
> by now).I think so far you simply haven't had enough users hammering on the new
code yet.

> The 'txq was for another queue' case is new with this patch, but that
> goes back to the WMM/fairness tention above.
I agree that this is something we need to figure out. One aspect that I
have a major problem with is the fact that this *really* intrusive patch
that completely changes the way that ath9k schedules tx queues is hidden
behind this "API change" patch.

The way the API stands now, mt76 would require an equally big rework to
a different scheduling model which I'm not comfortable with at this point.

I would like to suggest the following to resolve these issues:

First we should revert these patches.
We can respin them shortly after in a modified form where
ieee80211_next_txq takes a 'queue' argument.
I'm almost done with the incremental change for that, and it also
supports passing -1 for queue so incrementally switching to the
scheduling that you're proposing will also work.

With that in place we can replace the ath9k change with a much smaller
patch that is easier to verify for correctness and won't introduce the
potential regressions that I pointed out.

I will take care of the mt76 porting today and I'll also help with
sorting out the ath10k issues.

Is that acceptable to you?

- Felix
