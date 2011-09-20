Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35708 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab1ITM2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 08:28:40 -0400
Received: by ywb5 with SMTP id 5so269963ywb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 05:28:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316520830.3953.19.camel@jlt3.sipsolutions.net>
References: <1316347394-21276-1-git-send-email-eliad@wizery.com>
	<1316408970.2157.9.camel@cumari>
	<87aaa0k0a1.fsf@purkki.adurom.net>
	<CAB3XZEdiTRDJGUHWJ5UorQq2w-ZLP+TP0b-qSSVUTzhPG4H2rg@mail.gmail.com>
	<1316450319.5995.33.camel@jlt3.sipsolutions.net>
	<CAB3XZEeMZvv374SBTPDg1W8-E24=K5yVRhDQ0ktpUgxAEJgdzw@mail.gmail.com>
	<1316520830.3953.19.camel@jlt3.sipsolutions.net>
Date: Tue, 20 Sep 2011 15:28:39 +0300
Message-ID: <CAB3XZEcJctM2zeAGiftAnbkNDoOM5qgcnbJzFap1YqENakdsbA@mail.gmail.com> (sfid-20110920_142843_784252_1C61634F)
Subject: Re: [PATCH] mac80211: add ieee80211_set_dyn_ps_timeout()
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <kvalo@adurom.com>, Luciano Coelho <coelho@ti.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 3:13 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2011-09-20 at 15:05 +0300, Eliad Peller wrote:
>
>> > It'd be interesting to see if we can just treat this as a "minimum awake
>> > time", kinda like going back to the range I thought about earlier.
>> >
>> do you mean something like:
>> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
>> index 4274e94..57695e3 100644
>> --- a/net/mac80211/mlme.c
>> +++ b/net/mac80211/mlme.c
>> @@ -702,11 +702,12 @@ void ieee80211_recalc_ps(struct ieee80211_local
>> *local, s32 latency)
>>                         if (latency > (1900 * USEC_PER_MSEC) &&
>>                             latency != (2000 * USEC_PER_SEC))
>>                                 timeout = 0;
>> -                       else if (local->dynamic_ps_driver_timeout >= 0)
>> -                               timeout = local->dynamic_ps_driver_timeout;
>>                         else
>>                                 timeout = 100;
>>                 }
>> +               if (timeout && local->dynamic_ps_driver_timeout > timeout)
>> +                       timeout = local->dynamic_ps_driver_timeout;
>> +
>>                 local->dynamic_ps_user_timeout = timeout;
>>                 if (!local->disable_dynamic_ps)
>>                         conf->dynamic_ps_timeout =
>>
>> ?
>>
>> i don't find it much different.
>
> I did mean something like that, yes, but I was thinking we actually
> calculate the timeout based on latency requirements :)
>
i think that f(max_latency) -> dynamic_ps_timeout is not well defined,
so that's probably why we have to use hardcoded values here.

with the current code, i think the original patch is a bit better, as
the driver (for whatever reason) will also be able to decrease the
timeout.
however, i don't mind for either of them.

hopefully, the whole ps stuff should be redesigned at some point :)

Eliad.
