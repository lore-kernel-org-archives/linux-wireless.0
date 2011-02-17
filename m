Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41905 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab1BQAvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 19:51:25 -0500
Received: by yib18 with SMTP id 18so891445yib.19
        for <linux-wireless@vger.kernel.org>; Wed, 16 Feb 2011 16:51:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297678190.3785.13.camel@jlt3.sipsolutions.net>
References: <1297183399-2296-1-git-send-email-eliad@wizery.com>
	<1297678190.3785.13.camel@jlt3.sipsolutions.net>
Date: Thu, 17 Feb 2011 02:51:23 +0200
Message-ID: <AANLkTincDtRH=uq9H16W4Lyx-Z4WK9+YOZBYf6GEXjJ-@mail.gmail.com>
Subject: Re: [PATCH v2] mac80211: add missing locking in ieee80211_reconfig
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 12:09 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-02-08 at 18:43 +0200, Eliad Peller wrote:
>> When suspending an associated system, and then resuming,
>> the station vif is being reconfigured without taking the
>> sdata->u.mgd.mtx lock, which results in the following warning:
>
> ...
>
>>  net/mac80211/util.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> index cf68700..d036597 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -1210,7 +1210,9 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>>               switch (sdata->vif.type) {
>>               case NL80211_IFTYPE_STATION:
>>                       changed |= BSS_CHANGED_ASSOC;
>> +                     mutex_lock(&sdata->u.mgd.mtx);
>>                       ieee80211_bss_info_change_notify(sdata, changed);
>> +                     mutex_unlock(&sdata->u.mgd.mtx);
>>                       break;
>>               case NL80211_IFTYPE_ADHOC:
>>                       changed |= BSS_CHANGED_IBSS;
>
> Oi, this is a complicated locking rule.
>
> Can you please stick a
>
> lockdep_assert_held(...)
>
> in the right place to make sure we catch it even on drivers that don't
> use the probe_req function?
>
well, i'm not sure what is the right place / when this mutex should be taken.
when doing something like:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 1c507c6..ab1843d 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -191,6 +191,7 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
                return;

        if (sdata->vif.type == NL80211_IFTYPE_STATION) {
+               lockdep_assert_held(&sdata->u.mgd.mtx);
                /*
                 * While not associated, claim a BSSID of all-zeroes
                 * so that drivers don't do any weird things with the

i got several warnings from ieee80211_open, ieee80211_recalc_idle, etc.
should this mutex be taken if the psm has been changed (for example)?
or should we check the mutex only if certain flags has been changed?

Eliad.
