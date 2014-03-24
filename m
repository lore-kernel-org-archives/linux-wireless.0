Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:35215 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaCXM6u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 08:58:50 -0400
Received: by mail-oa0-f53.google.com with SMTP id j17so5814491oag.12
        for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 05:58:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395663944.4515.45.camel@dubbel>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-2-git-send-email-michal.kazior@tieto.com>
	<1395663944.4515.45.camel@dubbel>
Date: Mon, 24 Mar 2014 13:58:50 +0100
Message-ID: <CA+BoTQmuUK5DDv5p7OTnvQQaL7hPV459w=UhaBu1HgMeavmZBA@mail.gmail.com> (sfid-20140324_135855_920517_2685F937)
Subject: Re: [PATCH v2 1/4] mac80211: fix CSA tx queue locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 13:25, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
>> It was possible for tx queues to be stuck locked
>> if AP CSA finalization failed.
>
> I think it's clearer if you say "tx queue stopping" or something to
> avoid confusion with the word "locking".  Same applies to the commit
> subject.
>
> [...]
>> It is still possible to have tx queues stopped
>> after CSA failure but as soon as offending
>> interfaces are stopped from userspace (stop_ap or
>> ifdown) tx queues are woken up properly.
>
> Isn't there any way to avoid this? I mean, if you have identified some
> cases, why not fix them too? :)
>
> [...]
>> @@ -3092,8 +3122,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>>               goto unlock;
>>
>>       ieee80211_csa_finalize(sdata);
>> +     if (!ieee80211_csa_needs_block_tx(local))
>> +             ieee80211_wake_queues_by_reason(&local->hw,
>> +                                     IEEE80211_MAX_QUEUE_MAP,
>> +                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>
> This should remain inside ieee80211_csa_finalize() as it was before,
> because otherwise you won't wake up the queues in case of an immediate
> switch.  Look at the bottom of your new  __ieee80211_channel_switch(),
> we call ieee80211_csa_finalize() directly if the beacon didn't change.

Good point. I''l fix it.


> Actually, in the beacon-didn't-change case, we should probably not even
> stop the queues?

I think we should stop the queues. Take this for example:

2 ap vifs. ap1 starts csa cs_count=100 block_tx=0, ap2 starts csa
cs_count=0 block_tx=1.

In this case ap2 won't switch immediately but will stay around until
ap1 interface is done.


>
> [...]
>> @@ -3271,15 +3307,15 @@ int ieee80211_channel_switch(struct wiphy *wiphy, struct net_device *dev,
>>               return err;
>>
>>       sdata->csa_radar_required = params->radar_required;
>> -
>> -     if (params->block_tx)
>> -             ieee80211_stop_queues_by_reason(&local->hw,
>> -                             IEEE80211_MAX_QUEUE_MAP,
>> -                             IEEE80211_QUEUE_STOP_REASON_CSA);
>> -
>>       sdata->csa_chandef = params->chandef;
>> +     sdata->csa_block_tx = params->block_tx;
>>       sdata->vif.csa_active = true;
>>
>> +     if (sdata->csa_block_tx)
>> +             ieee80211_wake_queues_by_reason(&local->hw,
>> +                                     IEEE80211_MAX_QUEUE_MAP,
>> +                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>
> Shouldn't this be *stop* queues?

Oops.. :-)


> You can call ieee80211_stop_queues_by_reason() even if it is already
> stopped for this reason, but maybe you could call
> ieee80211_csa_needs_block_tx() here to avoid eventually calling it
> multiple times.  I think this is also a bit more consistent.
>
>         if(ieee80211_csa_needs_block_tx(...))
>                 ieee80211_stop_queues_by_reason(...)

I fail to see how this would avoid calling it multiple times, or
rather, where is it being called multiple number of times now that it
can be prevented?

If you call ieee80211_csa_needs_block_tx() you check the block_tx
anyway. Since csa_active is guaranteed to be true here already you
just need to check block_tx.


> [...]
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index bbc2175..2ca1472 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -952,15 +952,18 @@ static void ieee80211_chswitch_work(struct work_struct *work)
>>       /* XXX: shouldn't really modify cfg80211-owned data! */
>>       ifmgd->associated->channel = sdata->csa_chandef.chan;
>>
>> -     /* XXX: wait for a beacon first? */
>> -     ieee80211_wake_queues_by_reason(&local->hw,
>> -                                     IEEE80211_MAX_QUEUE_MAP,
>> -                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>> -
>>       ieee80211_bss_info_change_notify(sdata, changed);
>>
>>   out:
>> +     mutex_lock(&local->mtx);
>>       sdata->vif.csa_active = false;
>> +     /* XXX: wait for a beacon first? */
>> +     if (!ieee80211_csa_needs_block_tx(local))
>> +             ieee80211_wake_queues_by_reason(&local->hw,
>> +                                     IEEE80211_MAX_QUEUE_MAP,
>> +                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>> +     mutex_unlock(&local->mtx);
>
> Instead of moving this to the out label, I guess the right place for it
> would be in ieee80211_set_disassoc().  Then we would catch the
> csa_connection_drop_work cases plus a few other cases that seem to be
> missing(?).

Good point. Will do.


Michał
