Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:36109 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaFFH4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jun 2014 03:56:38 -0400
Received: by mail-we0-f182.google.com with SMTP id t60so2319698wes.41
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jun 2014 00:56:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1402040251.2004.20.camel@dubbel>
References: <1401985567-27336-3-git-send-email-emmanuel.grumbach@intel.com>
	<CA+BoTQn7H7808DFhAmfBtNsO+o0CEsy3_=4QMnxU4eML7JUCQQ@mail.gmail.com>
	<1402036258.2004.10.camel@dubbel>
	<CA+BoTQ=wZV8dviGE8HAFC1j=XNqJDkxUaHV5HFkiLMs2arCVHQ@mail.gmail.com>
	<1402040251.2004.20.camel@dubbel>
Date: Fri, 6 Jun 2014 09:56:36 +0200
Message-ID: <CA+BoTQ=X9Vg+=PvdRuFTcL+1hA6Yg6Vne3_NfBx_A6yS91b0PA@mail.gmail.com> (sfid-20140606_095641_774056_FA38EBE1)
Subject: Re: [PATCH 3/3] mac80211: stop only the queues assigned to the vif
 during channel switch
From: Michal Kazior <michal.kazior@tieto.com>
To: "Coelho, Luciano" <luciano.coelho@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 June 2014 09:37, Coelho, Luciano <luciano.coelho@intel.com> wrote:
> On Fri, 2014-06-06 at 08:44 +0200, Michal Kazior wrote:
>> On 6 June 2014 08:31, Coelho, Luciano <luciano.coelho@intel.com> wrote:
>> > On Fri, 2014-06-06 at 07:51 +0200, Michal Kazior wrote:
>> >> On 5 June 2014 18:26, Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:
>> [...]
>> >> > @@ -3146,9 +3145,8 @@ static int __ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>> >> >         cfg80211_ch_switch_notify(sdata->dev, &sdata->csa_chandef);
>> >> >
>> >> >         if (!ieee80211_csa_needs_block_tx(local))
>> >> > -               ieee80211_wake_queues_by_reason(&local->hw,
>> >> > -                                       IEEE80211_MAX_QUEUE_MAP,
>> >> > -                                       IEEE80211_QUEUE_STOP_REASON_CSA);
>> >> > +               ieee80211_wake_vif_queues(local, sdata,
>> >> > +                                         IEEE80211_QUEUE_STOP_REASON_CSA);
>> >>
>> >> I don't think this is going to work with the upcomming multi-vif
>> >> channel switching.
>> >>
>> >> The ieee80211_csa_needs_block_tx() will become false upon *last*
>> >> interface switch completion. This means preceeding interface csa
>> >> finalizations won't call ieee80211_wake_vif_queues() so you actually
>> >> end up not waking all of the queues when you finish csa.
>> >
>> > I think the right way to do it would be to traverse the vifs that
>> > switched and wake up their queues when the switch is finished.
>> >
>> >
>> >> I think this can be solved with:
>> >>
>> >>  if (!ieee80211_csa_needs_block_tx(local))
>> >>    list_for_each(sdata, &local->interfaces, list)
>> >>      ieee80211_wake_vif_queues(local, sdata, REASON_CSA);
>> >>
>> >> But then I guess it's just a convoluted way of saying:
>> >>
>> >>  if (!ieee80211_csa_needs_block_tx(local))
>> >>    ieee80211_wake_queues_by_reason(hw, REASON_CSA);
>> >>
>> >> IOW waking should remain as it was while stopping can be done per-vif.
>> >>
>> >> This goes for all instances calling wake_vif_queues() in the patch.
>> >
>> > Actually I had it like this in my first version, I had only added the
>> > stop part, leaving the wake as it was.  But then I thought that we would
>> > be restarting queues from other vifs that we don't know about.  If
>> > another vif is switching separately, we would restart its queues at the
>> > wrong time.  I think we shouldn't assume that all vifs are part of the
>> > same switch.
>>
>> Well, not really.
>>
>> There is no "vif switching separately" when it comes to block_tx. The
>> condition checks if ANY interface still needs queues to be locked for
>> the *REASON_CSA*. If the condition is false (i.e. "no interface needs
>> block_tx") then you are safe to wake *all* queues for *REASON_CSA* on
>> all interfaces because channel switches that don't need block_tx don't
>> stop their queues for REASON_CSA in the first place.
>
> Right, and this used to make sense when we were stopping *all* hw_queues
> when we had block_tx.
>
> Maybe we should make a new function that returns all the queues that our
> vif was blocking but that are not blocked by any other vifs.  Maybe
> something like this:
>
> static u32 ieee80211_vif_queues_to_wake(struct ieee80211_local *local,
>                                         struct ieee80211_sub_if_data *sdata,
>                                         enum queue_stop_reason reason)
> {
>         struct ieee80211_sub_if_data *sdata_iter;
>         unsigned long queues, queues_iter, q;
>         int i;
>
>         lockdep_assert_held(&local->mtx);
>
>         queues = ieee80211_get_vif_queues(local, sdata);
>
>         rcu_read_lock();
>         list_for_each_entry_rcu(sdata_iter, &local->interfaces, list) {
>                 if (!ieee80211_sdata_running(sdata_iter))
>                         continue;
>
>                 queues_iter = ieee80211_get_vif_queues(local, sdata_iter);
>                 for_each_set_bit(i, &queues_iter, local->hw.queues) {
>                         q = sdata->vif.hw_queue[i];
>
>                         if (test_bit(reason, &local->queue_stop_reasons[q]))
>                                 queues &= ~q;
>                 }
>         }
>         rcu_read_unlock();
>
>         return queues;
> }
>
> void ieee80211_wake_vif_queues(struct ieee80211_local *local,
>                                struct ieee80211_sub_if_data *sdata,
>                                enum queue_stop_reason reason)
> {
>         unsigned int queues = ieee80211_vif_queues_to_wake(local, sdata, reason);
>
>         ieee80211_wake_queues_by_reason(&local->hw, queues, reason);
> }

Once you set local->queue_stop_reasons[] for an overlapping queue you
won't be able to wake it with ieee80211_wake_vif_queues() alone.
You'll need to call ieee80211_wake_queues() to do that. Is that what
you intended?


>> You could argue current queue locking for CSA is not efficient and
>> you'd be right. It was a simplification I came up with to get things
>> at least work correctly not efficiently.
>>
>>
>> >> Generally I don't think having wake_vif_queues() is a good idea. It's
>> >> really tricky. Sure, you can have a stop_vif_queues() which will
>> >> behave as you might expect (i.e. first call stops queues and
>> >> overlapping vif-queue mappings are not a concern). But
>> >> wake_vif_queues() seems to have little practical use to me without any
>> >> kind of per-queue reference counting.
>> >
>> > Yeah, this could be a problem for vifs that are sharing the same queues.
>> > But that case would be really tricky with channel-switch anyway. because
>> > if the channel of one vif is changed but not the other, the queue would
>> > probably have to be split...
>>
>> Hmm. That's a very good point. Can we even re-map this during the switch now?
>>
>> If we can't then doesn't it imply that if there are shared vif-queue
>> mappings then channel switching should be limited/prevented? I.e. it
>> might be okay if you have 2 vifs sharing a queue to switch to the
>> exact same channel but it won't work if you try to switch them to
>> separate channels. Single-channel devices won't have to worry about it
>> (single-channel combination cases for that matter).
>
> Yeah, it should probably be prevented for such drivers.  But then, at
> what point? Prevent the channel switch to occur completely if another
> vif shares the same queue? Or fail the switch if the other vif doesn't
> join the switch?

That's a good question too. I would prefer to leave it until the last
second, e.g. give the opportunity to re-map in
drv_switch_vif_chanctx() maybe so driver can fail if it's unable to
comply?


Michał
