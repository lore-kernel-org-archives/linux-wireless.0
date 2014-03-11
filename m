Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:51093 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaCKHU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 03:20:26 -0400
Received: by mail-ob0-f171.google.com with SMTP id wn1so8128007obc.16
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 00:20:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1394468854.24115.3.camel@jlt4.sipsolutions.net>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	<1394029623-21894-2-git-send-email-michal.kazior@tieto.com>
	<1394468854.24115.3.camel@jlt4.sipsolutions.net>
Date: Tue, 11 Mar 2014 08:20:26 +0100
Message-ID: <CA+BoTQkJd0g7t-ZMC6TDF0FbcAFH_BVRUJUCSq6w9dUz-RqLHw@mail.gmail.com> (sfid-20140311_082043_971014_76FD2379)
Subject: Re: [PATCH 1/4] mac80211: fix CSA tx queue locking
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 March 2014 17:27, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-03-05 at 15:27 +0100, Michal Kazior wrote:
>
>> +void ieee80211_recalc_csa_block_tx(struct ieee80211_local *local)
>> +{
>> +     lockdep_assert_held(&local->mtx);
>> +
>> +     if (ieee80211_csa_needs_block_tx(local))
>> +             ieee80211_stop_queues_by_reason(&local->hw,
>> +                                     IEEE80211_MAX_QUEUE_MAP,
>> +                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>> +     else
>> +             ieee80211_wake_queues_by_reason(&local->hw,
>> +                                     IEEE80211_MAX_QUEUE_MAP,
>> +                                     IEEE80211_QUEUE_STOP_REASON_CSA);
>> +}
>
> I don't like this function, even if technically stop is idempotent, it
> still seems strange to call this "recalc".
>
>> @@ -1092,7 +1131,11 @@ static int ieee80211_stop_ap(struct wiphy *wiphy, struct net_device *dev)
>>       old_probe_resp = sdata_dereference(sdata->u.ap.probe_resp, sdata);
>>
>>       /* abort any running channel switch */
>> +     mutex_lock(&local->mtx);
>>       sdata->vif.csa_active = false;
>> +     ieee80211_recalc_csa_block_tx(local);
>> +     mutex_unlock(&local->mtx);
>
> In fact, here you don't care about the stop queues part at all, afaict.

I wanted to make the stop/wake code decision in one place. I
understand you prefer to have:

 if (can_wake)
  wake()

and

 if (!can_wake)
  stop()

calls explicitly instead of the "recalc" function?


>>       sdata->csa_chandef = params->chandef;
>> +     sdata->csa_block_tx = params->block_tx;
>
> doesn't that more belong to the previous patch?

It belongs here.

CSA tx queue blocking is global. If you want to support multi- CSA
then you need to keep queues blocked until last CSA that requires tx
being blocked is completed. To do that you need to store which
interface CSA requested block_tx.

I should probably include this note in the commit message.


Michał
