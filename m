Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35336 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753962AbcKUQ7P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 11:59:15 -0500
Received: by mail-qk0-f195.google.com with SMTP id n204so48337699qke.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Nov 2016 08:59:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1479740918.2517.28.camel@coelho.fi>
References: <bc071499-a8ef-2b0b-bfb7-42c96f1d369c@broadcom.com>
 <dffc5408-3337-32e7-0998-3ae8a5199fa9@broadcom.com> <e176de78-6ab3-ad83-5e9d-082ceb85d786@broadcom.com>
 <1479740918.2517.28.camel@coelho.fi>
From: Dave Taht <dave.taht@gmail.com>
Date: Mon, 21 Nov 2016 08:59:13 -0800
Message-ID: <CAA93jw5hkLWCCKdabEyKWTF_kFs8xWKC-kjUeFNh9os+zEuxJw@mail.gmail.com> (sfid-20161121_175945_351164_72012065)
Subject: Re: scheduled scan interval
To: Luca Coelho <luca@coelho.fi>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2016 at 7:08 AM, Luca Coelho <luca@coelho.fi> wrote:
> Hi Arend,
>
> On Mon, 2016-11-21 at 13:03 +0100, Arend Van Spriel wrote:
>> On 21-11-2016 12:30, Arend Van Spriel wrote:
>> > On 21-11-2016 12:19, Arend Van Spriel wrote:
>> > > Hi Johannes, Luca,
>> > >
>> > > The gscan work made me look at scheduled scan and the implementation=
 of
>> > > it in brcmfmac. The driver ignored the interval parameter from
>> > > user-space. Now I am fixing that. One thing is that our firmware has=
 a
>> > > minimum interval which can not be indicated in struct wiphy. The oth=
er
>> > > issue is how the maximum interval is used in the nl80211.c.
>> > >
>> > > In nl80211_parse_sched_scan_plans() it is used against value passed =
in
>> > > NL80211_ATTR_SCHED_SCAN_INTERVAL and NL80211_SCHED_SCAN_PLAN_INTERVA=
L.
>> > > For the first one it caps the value to the maximum, but for the seco=
nd
>> > > one it returns -EINVAL. I suspect this is done because maximum inter=
val
>> > > was introduced with schedule scan plans, but it feels inconsistent.
>> >
>> > It also maybe simply wrong to cap. At least brcmfmac does not set the
>> > maximum so it will always get interval being zero. Maybe better to do:
>> >
>> >             if (wiphy->max_sched_scan_plan_interval &&
>> >                 request->scan_plans[0].interval >
>> >                 wiphy->max_sched_scan_plan_interval)
>> >                     return -EINVAL;
>> >
>> > > Thoughts?
>>
>> Digging deeper. Looking at v4.3 before introduction of sched_scan_plans.
>> struct sched_scan_request::interval was specified in milliseconds! Below
>> the drivers that I see having scheduled scan support:
>>
>> iwlmvm: cap interval, convert to seconds.
>> ath6kl: cap to 1sec minimum, no max check, convert to seconds.
>> wl12xx: no checking in driver, fw need milliseconds.
>> wl18xx: no checking in driver, fw need milliseconds.
>>
>> The milliseconds conversion seems to be taken care of by multiplying
>> with MSEC_PER_SEC in wl{12,18}xx drivers.
>>
>> It seems in 4.8 only iwlmvm set wiphy->max_sched_scan_plan_interval so
>> other drivers will get interval of zero which only ath6kl handles.
>
> With the introduction of scheduled scan plans, we sort of deprecated
> the "generic" scheduled scan interval.  It doesn't make sense to have
> both passed at the same time, so nl80211 forbids
> NL80211_ATTR_SCHED_SCAN_INTERVAL if we pass
> NL80211_ATTR_SCHED_SCAN_PLANS.
>
> The original NL80211_ATTR_SCHED_SCAN_INTERVAL was specified in msecs,
> which is silly because we can never get millisecond accuracy in this.
> Thus, in the plans API, we decided to use seconds instead (because it
> makes much more sense).  Additionally, the interval is considered
> "advisory", because the FW may not be able guarantee the exact
> intervals (for instance, the iwlwifi driver actually starts the
> interval timer after scan completion, so if you specify 10 seconds
> intervals, in practice they'll be 13-14 seconds).
>
> I'm not sure I'm answering your question, because I'm also not sure I
> understood the question. :)

I'm not sure if I understand the discussion and hooks myself, but
recently fixes for doing channel scans saner from userspace ended up
here, after some discussion.

https://bugzilla.gnome.org/show_bug.cgi?id=3D766482

Anything that can reduce the impact of this behavior, I'm for!

http://www.taht.net/~d/channel_scans_destroying_latency_under_load_for_10s.=
png



>
> --
> Cheers,
> Luca.



--=20
Dave T=C3=A4ht
Let's go make home routers and wifi faster! With better software!
http://blog.cerowrt.org
