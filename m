Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50918 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaAVIyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 03:54:15 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so3555079ead.27
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 00:54:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390318236.6199.45.camel@jlt4.sipsolutions.net>
References: <1390228033-19162-1-git-send-email-michal.kazior@tieto.com>
	<1390228033-19162-3-git-send-email-michal.kazior@tieto.com>
	<1390318236.6199.45.camel@jlt4.sipsolutions.net>
Date: Wed, 22 Jan 2014 09:54:13 +0100
Message-ID: <CA+BoTQ==WJPJV=t8=_CZAD5qyW3igAtaOcUz9hNCcvUPYH+jdA@mail.gmail.com> (sfid-20140122_095418_134563_F3A6EE62)
Subject: Re: [PATCH 2/2] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 January 2014 16:30, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-01-20 at 15:27 +0100, Michal Kazior wrote:
>
>> This implements a fairly simple multi-interface
>> CSA. It doesn't support multiple channel
>> contexts so it doesn't support multi-channel.
>
> For not implementing chanctx support, I think it changes an awful lot in
> the implementation there...
>
>> A new worker is introduced: csa_complete_work
>> which is used to account per-interface countdowns
>> and issue the actual channel switch after last
>> interface completes its CSA.
>
> Not sure I understand this part, don't they all have the same countdown,
> and should finish at the same time?

Keep in mind you get cfg80211_csa_settings array for the channel
switch each having it's own csa beacon count. I can try to refactor
the code a little bit though.


>>       /* abort any running channel switch */
>>       mutex_lock(&local->mtx);
>> -     sdata->vif.csa_active = false;
>> -     kfree(sdata->u.ap.next_beacon);
>> -     sdata->u.ap.next_beacon = NULL;
>> +     ieee80211_csa_clear(sdata);
>> +     ieee80211_csa_free(sdata);
>>       mutex_unlock(&local->mtx);
>
> Maybe that kind of refactoring would be better in a separate patch?

Good point. I'll get that done.


>> +static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)
>
> I'm beginning to think it's time to create a new file
> net/mac80211/ap.c :-)
>
> What's the backup/restore used for anyway?

Hmm.. Now that I think about it this might not be really worth it. The
fact is, if you're in CSA it means you don't want to remain on a given
channel so there's actually little to no point restoring old beacon
for that channel.

Can I just bss_conf->enable_beacon=false && notify_bss_info_changed()?
That would just stop beaconing and avoid TXing on the old channel.

Maybe nl80211 should have a csa-completed event (like scan), so it can
return success/failure/status so userspace can actually take action if
CSA fails for some reason in mid-way?


>> -int ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
>> -                              u32 *changed)
>> +const struct cfg80211_chan_def *
>> +ieee80211_get_csa_chandef(struct ieee80211_local *local)
>>  {
>> -     struct ieee80211_local *local = sdata->local;
>> -     struct ieee80211_chanctx_conf *conf;
>> -     struct ieee80211_chanctx *ctx;
>> -     const struct cfg80211_chan_def *chandef = &sdata->csa_chandef;
>> -     int ret;
>> -     u32 chanctx_changed = 0;
>> +     struct ieee80211_sub_if_data *sdata;
>> +     const struct cfg80211_chan_def *chandef = NULL;
>>
>>       lockdep_assert_held(&local->mtx);
>> +     lockdep_assert_held(&local->chanctx_mtx);
>>
>> -     /* should never be called if not performing a channel switch. */
>> -     if (WARN_ON(!sdata->vif.csa_active))
>> -             return -EINVAL;
>> +     list_for_each_entry_rcu(sdata, &local->interfaces, list) {
>
> _rcu doesn't seem right.

Hmm. Taking iflist_mtx right here is impossible (deadlock). Some
refactoring would need to be done here so that it is taken before
chanctx_mtx, but after local->mtx at the same time.


> But then again this whole function, iterating interfaces rather than
> channel contexts etc. is terrible IMHO. This seems to pretty much turn
> chanctx support upside down, making the channel context structures not
> be the first-class citizens I think we want them to be.

chanctx aren't aware what interfaces they are assigned to now.


> I'd say Luca's approach has more future, as it makes channel context
> support native. With this, I don't even see how you *could* later add
> real channel context support. A function like this, that essentially
> assumes exactly a single chanctx that might be doing CSA and similar
> seems to make that rather difficult.

I'm not really aware of Luca's work.


>> +struct ieee80211_chanctx *
>> +ieee80211_get_csa_chanctx(struct ieee80211_local *local)
>> +{
>> +     struct ieee80211_chanctx *chanctx = NULL, *ctx;
>> +     int num_chanctx = 0;
>> +
>> +     lockdep_assert_held(&local->chanctx_mtx);
>> +
>> +     list_for_each_entry(ctx, &local->chanctx_list, list) {
>> +             chanctx = ctx;
>> +             num_chanctx++;
>>       }
>>
>> -     sdata->vif.bss_conf.chandef = *chandef;
>> -     ctx->conf.def = *chandef;
>> +     /* multi-channel is not supported, multi-vif is */
>> +     if (num_chanctx > 1)
>> +             return NULL;
>
> This is essentially the same thing, but written as a chanctx function?

I'm not following. Same thing as what?


>> +     if (!chandef) {
>> +             rcu_read_unlock();
>> +             return -EINVAL;
>> +     }
>> +
>> +     if (!cfg80211_chandef_usable(local->hw.wiphy, chandef,
>> +                                  IEEE80211_CHAN_DISABLED)) {
>> +             rcu_read_unlock();
>> +             return -EINVAL;
>> +     }
>> +
>> +     ieee80211_use_csa_chandef(local);
>> +     rcu_read_unlock();
>
> A function that changes something but is under rcu_read_lock()? can't
> this call into the driver, which is likely not allowed?

True. This needs to be fixed along with the get_csa_chandef().


>> +++ b/net/mac80211/tx.c
>> @@ -2427,13 +2427,16 @@ static void ieee80211_update_csa(struct ieee80211_sub_if_data *sdata,
>>       if (WARN_ON(counter_offset_beacon >= beacon_data_len))
>>               return;
>>
>> -     /* Warn if the driver did not check for/react to csa
>> -      * completeness.  A beacon with CSA counter set to 0 should
>> -      * never occur, because a counter of 1 means switch just
>> -      * before the next beacon.
>> -      */
>> -     if (WARN_ON(beacon_data[counter_offset_beacon] == 1))
>> +     if (beacon_data[counter_offset_beacon] == 1) {
>> +             /* Warn if the driver did not check for/react to csa
>> +              * completeness. A beacon with CSA counter set to 0 should
>> +              * never occur, because a counter of 1 means switch just before
>> +              * the next beacon. Multi-interface CSA may need to wait for
>> +              * other interfaces to complete their counter so don't warn
>> +              * unless driver actually didn't notify us. */
>
> Err, that doesn't seem right either ... multi-interface CSA should all
> be switching at the same time, so you *still* shouldn't be running into
> this and transmitting beacons with CSA count==1. If you do, your driver
> is likely not behaving as it should.

Hmm. You're right. I'll get rid of this. But still, keep in mind you
could actually get different CSA count values for different
interfaces.


> In any case, unless I'm missing some bigger picture this seems like a
> really hacky way to add things, basically ignoring all the channel
> context work. Since I care more about channel contexts, maybe we should
> merge support for channel context CSA before we try to do the multi
> thing.

This is, I assume, Luca's work you're talking about here again. What's
the progress on this? Any time estimates?


Michał
