Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:42573 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaCYHqB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Mar 2014 03:46:01 -0400
Received: by mail-ve0-f176.google.com with SMTP id cz12so89895veb.35
        for <linux-wireless@vger.kernel.org>; Tue, 25 Mar 2014 00:46:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395672943.4515.66.camel@dubbel>
References: <1394029623-21894-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-1-git-send-email-michal.kazior@tieto.com>
	<1395408675-26013-5-git-send-email-michal.kazior@tieto.com>
	<1395672943.4515.66.camel@dubbel>
Date: Tue, 25 Mar 2014 08:46:00 +0100
Message-ID: <CA+BoTQkGmasogUWDrE5J0p+Wu7o8KyJZhvxiMf+2gu90rJjOuw@mail.gmail.com> (sfid-20140325_084627_758248_AC21AF42)
Subject: Re: [PATCH v2 4/4] mac80211: disconnect iface if CSA unexpectedly fails
From: Michal Kazior <michal.kazior@tieto.com>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 March 2014 15:55, Luca Coelho <luca@coelho.fi> wrote:
> On Fri, 2014-03-21 at 14:31 +0100, Michal Kazior wrote:
>> It doesn't make much sense to leave a cripled
>> interface running.
>>
>> As a side effect this will unblock tx queues with
>> CSA reason immediately after failure instead of
>> until after userspace requests interface to stop.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>>  net/mac80211/cfg.c | 17 +++++++++++++----
>>  1 file changed, 13 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 65768ef..64e152d 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -3088,7 +3088,7 @@ static int ieee80211_set_after_csa_beacon(struct ieee80211_sub_if_data *sdata,
>>       return 0;
>>  }
>>
>> -static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>> +static int ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>>  {
>>       struct ieee80211_local *local = sdata->local;
>>       u32 changed = 0;
>> @@ -3100,7 +3100,7 @@ static void ieee80211_csa_finalize(struct ieee80211_sub_if_data *sdata)
>>       sdata->radar_required = sdata->csa_radar_required;
>>       err = ieee80211_vif_change_channel(sdata, &changed);
>>       if (WARN_ON(err < 0))
>> -             return;
>> +             return err;
>
> Now you propagate the error up, do we still need the WARN_ON here?

Good point.


> [...]
>> @@ -3123,6 +3125,7 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>>               container_of(work, struct ieee80211_sub_if_data,
>>                            csa_finalize_work);
>>       struct ieee80211_local *local = sdata->local;
>> +     int err;
>>
>>       sdata_lock(sdata);
>>       mutex_lock(&local->mtx);
>> @@ -3134,7 +3137,13 @@ void ieee80211_csa_finalize_work(struct work_struct *work)
>>       if (!ieee80211_sdata_running(sdata))
>>               goto unlock;
>>
>> -     ieee80211_csa_finalize(sdata);
>> +     err = ieee80211_csa_finalize(sdata);
>> +     if (err) {
>> +             sdata_info(sdata, "failed to finalize CSA, disconnecting\n");
>> +             cfg80211_stop_iface(local->hw.wiphy, &sdata->wdev);
>> +             goto unlock;
>> +     }
>> +
>
> This is neat. :) Maybe it's possible to do the same thing in mlme.c and
> get rid of the connection_drop_work?

I don't think it's necessary now.


Michał
