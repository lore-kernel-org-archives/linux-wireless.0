Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49881 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab0LGPoo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 10:44:44 -0500
Received: by iwn9 with SMTP id 9so34103iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 07:44:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291714709.3607.2.camel@jlt3.sipsolutions.net>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com> <1291714709.3607.2.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Dec 2010 07:44:22 -0800
Message-ID: <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	amod.bodas@atheros.com, pstew@google.com, stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 1:38 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2010-12-06 at 18:48 -0800, Luis R. Rodriguez wrote:
>> There are a few places where mac80211 may issue a hw config
>> but the hw config will be ignored and got into a black hole if
>> the device count is already 0. Further hw config calls will also
>> be discarded as the device is already marked as idle, in these
>> cases mac80211 assumes the radio is idle but the driver never
>> really got the notification. We need to ensure that places that
>> will call a hw reconfig with open_count set to 0 will send the
>> notification to the driver. This forces these checks in a few
>> other key missing places.
>>
>> Without this suspend and resume is broken on devices which require
>> notifying the driver to become idle once the open_count already
>> has reached 0. This fixes suspend/resume when using new DBus APIs
>> are used which idle the device in places which had not yet gotten
>> widely tested.
>>
>> Cc: stable@kernel.org
>> Cc: Paul Stewart <pstew@google.com>
>> Cc: Amod Bodas <amod.bodas@atheros.com>
>> Cc: Johannes Berg <johannes.berg@intel.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  net/mac80211/ieee80211_i.h |    1 +
>>  net/mac80211/iface.c       |   16 ++++++++++++++--
>>  net/mac80211/pm.c          |    2 ++
>>  net/mac80211/scan.c        |    2 +-
>>  net/mac80211/util.c        |    1 +
>>  5 files changed, 19 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index ae32349..78ab6ff 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -1211,6 +1211,7 @@ void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
>>
>>  /* Suspend/resume and hw reconfiguration */
>>  int ieee80211_reconfig(struct ieee80211_local *local);
>> +void ieee80211_recalc_idle_force(struct ieee80211_local *local);
>>  void ieee80211_stop_device(struct ieee80211_local *local);
>>
>>  #ifdef CONFIG_PM
>> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
>> index 36b7000..a590bae 100644
>> --- a/net/mac80211/iface.c
>> +++ b/net/mac80211/iface.c
>> @@ -1320,7 +1320,8 @@ u32 __ieee80211_recalc_idle(struct ieee80211_local *local)
>>       return 0;
>>  }
>>
>> -void ieee80211_recalc_idle(struct ieee80211_local *local)
>> +static void ieee80211_recalc_idle_check(struct ieee80211_local *local,
>> +                                     bool force)
>>  {
>>       u32 chg;
>>
>> @@ -1328,7 +1329,18 @@ void ieee80211_recalc_idle(struct ieee80211_local *local)
>>       chg = __ieee80211_recalc_idle(local);
>>       mutex_unlock(&local->iflist_mtx);
>>       if (chg)
>> -             ieee80211_hw_config(local, chg);
>> +             __ieee80211_hw_config(local, chg, force);
>> +}
>> +
>> +void ieee80211_recalc_idle(struct ieee80211_local *local)
>> +{
>> +     ieee80211_recalc_idle_check(local, false);
>> +}
>
> I think I'd probably prefer an inline too.

OK

>> --- a/net/mac80211/pm.c
>> +++ b/net/mac80211/pm.c
>> @@ -98,6 +98,8 @@ int __ieee80211_suspend(struct ieee80211_hw *hw)
>>       if (local->open_count)
>>               ieee80211_stop_device(local);
>>
>> +     ieee80211_recalc_idle_force(local);
>
> Err? You just added a call to stop_device() too,

What if open_count is 0?

> and at the wrong place as well...

I'll fix thanks.


>> @@ -1121,6 +1121,7 @@ void ieee80211_stop_device(struct ieee80211_local *local)
>>
>>       flush_workqueue(local->workqueue);
>>       drv_stop(local);
>> +     ieee80211_recalc_idle_force(local);
>
> That one definitely can't be after drv_stop().

OK why though?

 Luis
