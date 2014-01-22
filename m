Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:56039 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaAVJkp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:40:45 -0500
Received: by mail-ee0-f51.google.com with SMTP id b57so4691909eek.38
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 01:40:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390381261.4334.12.camel@jlt4.sipsolutions.net>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	<1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	<1390318236.6199.45.camel@jlt4.sipsolutions.net>
	<CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com>
	<1390381261.4334.12.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 10:40:42 +0100
Message-ID: <CA+BoTQmE3TdT=oQbAjzUi5vGo0FA0opz1S9Z6-9UEQ_miSEpXQ@mail.gmail.com> (sfid-20140122_104053_959095_1B1C3520)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 January 2014 10:01, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-22 at 09:54 +0100, Michal Kazior wrote:
>
>> >> A new worker is introduced: csa_complete_work
>> >> which is used to account per-interface countdowns
>> >> and issue the actual channel switch after last
>> >> interface completes its CSA.
>> >
>> > Not sure I understand this part, don't they all have the same countdown,
>> > and should finish at the same time?
>>
>> Keep in mind you get cfg80211_csa_settings array for the channel
>> switch each having it's own csa beacon count. I can try to refactor
>> the code a little bit though.
>
> Can't we just prohibit that though? That seems pretty much useless,
> although if the interfaces actually have different beacon intervals (if
> such a thing is permitted?) then it would be necessary to do more
> difficult calculations ...

Not really sure what extra calculation would be necessary here beyond
just waiting until last interfaces finishes sending CSA beacons?


>> >> +static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)
>> >
>> > I'm beginning to think it's time to create a new file
>> > net/mac80211/ap.c :-)
>> >
>> > What's the backup/restore used for anyway?
>>
>> Hmm.. Now that I think about it this might not be really worth it. The
>> fact is, if you're in CSA it means you don't want to remain on a given
>> channel so there's actually little to no point restoring old beacon
>> for that channel.
>>
>> Can I just bss_conf->enable_beacon=false && notify_bss_info_changed()?
>> That would just stop beaconing and avoid TXing on the old channel.
>
> I can't really comment on that. I guess you don't want to stick to the
> old channel either way, although if you're doing CSA for a non-radar
> reason (e.g. P2P) you might be OK with that? But it seems like a rare
> corner case that maybe doesn't need all that much attention?
>
>> Maybe nl80211 should have a csa-completed event (like scan), so it can
>> return success/failure/status so userspace can actually take action if
>> CSA fails for some reason in mid-way?
>
> Maybe? Not sure what it would do? The error case would be more like this
> "oops, AP stopped" event that we've been discussing, no? I still need to
> do that ...

Right. "AP stopped" seems nice. My worry here is it might be tricky to
be practical with CSA wrt locking/races.


>> >>       lockdep_assert_held(&local->mtx);
>> >> +     lockdep_assert_held(&local->chanctx_mtx);
>> >>
>> >> -     /* should never be called if not performing a channel switch. */
>> >> -     if (WARN_ON(!sdata->vif.csa_active))
>> >> -             return -EINVAL;
>> >> +     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>> >
>> > _rcu doesn't seem right.
>>
>> Hmm. Taking iflist_mtx right here is impossible (deadlock). Some
>> refactoring would need to be done here so that it is taken before
>> chanctx_mtx, but after local->mtx at the same time.
>
> Isn't it under RTNL anyway though?

No, it isn't. This is eventually called from a worker. I don't think
you can use RTNL in a per-interface worker, can you?


>> > But then again this whole function, iterating interfaces rather than
>> > channel contexts etc. is terrible IMHO. This seems to pretty much turn
>> > chanctx support upside down, making the channel context structures not
>> > be the first-class citizens I think we want them to be.
>>
>> chanctx aren't aware what interfaces they are assigned to now.
>
> That's true, so maybe you just need to explain this chandef thing
> better? I don't really see the utility (admittedly without actually
> checking carefully in the code where you need it)

Since you can CSA multiple interfaces you can have different chandefs
for those interfaces. This means you need to know the chandef for the
final channel switch.

You could probably cache this to local->csa_chandef when processing
the channel switch request itself, but that means you explicitly limit
yourself to single CSA against a given hw/driver.

At one point I was contemplating having a dedicated structure for
channel switches, and have a list of channel switch structures in
ieee80211_local, but perhaps that's just an overkill.


>> > I'd say Luca's approach has more future, as it makes channel context
>> > support native. With this, I don't even see how you *could* later add
>> > real channel context support. A function like this, that essentially
>> > assumes exactly a single chanctx that might be doing CSA and similar
>> > seems to make that rather difficult.
>>
>> I'm not really aware of Luca's work.
>
> I guess he should post it :)
>
>> >> -     sdata->vif.bss_conf.chandef = *chandef;
>> >> -     ctx->conf.def = *chandef;
>> >> +     /* multi-channel is not supported, multi-vif is */
>> >> +     if (num_chanctx > 1)
>> >> +             return NULL;
>> >
>> > This is essentially the same thing, but written as a chanctx function?
>>
>> I'm not following. Same thing as what?
>
> It's rather similar to the chandef function above and I'm not sure I
> understand where the differences are needed.

The function is basically used to verify if channel switch is allowed
when processing CSA request and right before doing the actual channel
switch as a sanity check.

The request is validated against the assumption that there is only 1
chanctx and chanctx->refcount matches the number of CSA interface
requests. Without multi-channel it doesn't make much sense to move 2
interfaces from a channel context that has 5 interfaces bound to it as
that would mean you drag 3 unsuspecting interfaces to a different
channel (at least with the current code). I assume this will be
obsolete with Luca's patches as it changes how channel switching
interacts with chanctx?


Michał
