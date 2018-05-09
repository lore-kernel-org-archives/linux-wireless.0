Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40536 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756003AbeEILB6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 07:01:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        linux-wireless@vger.kernel.org, Maya Erez <merez@codeaurora.org>
Subject: Re: [mac80211-next:master 12/14] drivers/net//wireless/ath/wil6210/debugfs.c:1245:1: warning: the frame size of 1600 bytes is larger than 1024 bytes
References: <201805090154.h4Cokbx2%fengguang.wu@intel.com>
        <87efil2p2o.fsf@purkki.adurom.net>
        <1525855900.6910.5.camel@sipsolutions.net>
        <87tvrhw6kj.fsf@kamboji.qca.qualcomm.com>
        <1525856418.6910.6.camel@sipsolutions.net> <87efil41d4.fsf@toke.dk>
        <1525858618.6910.9.camel@sipsolutions.net>
        <87po25w463.fsf@kamboji.qca.qualcomm.com> <878t8t3zwp.fsf@toke.dk>
        <87h8nhw2yf.fsf@kamboji.qca.qualcomm.com> <8736z13yuo.fsf@toke.dk>
Date: Wed, 09 May 2018 14:01:53 +0300
In-Reply-To: <8736z13yuo.fsf@toke.dk> ("Toke \=\?utf-8\?Q\?H\=C3\=B8iland-J\?\=
 \=\?utf-8\?Q\?\=C3\=B8rgensen\=22's\?\= message of
        "Wed, 09 May 2018 12:30:39 +0200")
Message-ID: <87d0y5w0ri.fsf@kamboji.qca.qualcomm.com> (sfid-20180509_130202_433944_67F510D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>
>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>>
>>>> Johannes Berg <johannes@sipsolutions.net> writes:
>>>>
>>>>> On Wed, 2018-05-09 at 11:36 +0200, Toke H=C3=B8iland-J=C3=B8rgensen w=
rote:
>>>>>> Johannes Berg <johannes@sipsolutions.net> writes:
>>>>>>=20
>>>>>> > On Wed, 2018-05-09 at 11:56 +0300, Kalle Valo wrote:
>>>>>> > > Johannes Berg <johannes@sipsolutions.net> writes:
>>>>>> > >=20
>>>>>> > > > On Wed, 2018-05-09 at 11:47 +0300, Kalle Valo wrote:
>>>>>> > > > >=20
>>>>>> > > > > I guess these warnings come because Toke's patch increased s=
ize of
>>>>>> > > > > struct cfg80211_tid_stats (which is included in struct stati=
on_info) and
>>>>>> > > > > both wil6210 and qtnfmac allocate a struct station_info from=
 stack?=20
>>>>>> > > >=20
>>>>>> > > > Yes.
>>>>>> > > >=20
>>>>>> > > > > Can
>>>>>> > > > > someone send a fix for the drivers?
>>>>>> > > >=20
>>>>>> > > > I guess Toke/I should do that through my tree.
>>>>>> > >=20
>>>>>> > > IMHO the fix could go through my tree as well, less risk of conf=
licts in
>>>>>> > > drivers. AFAICS the fix (allocating station_info dynamically?) w=
ould not
>>>>>> > > depend on Toke's patch and could be applied separately.
>>>>>> >=20
>>>>>> > That's true, if you prefer that it's fine with me.
>>>>>>=20
>>>>>> I'll send a patch.
>>>>>>=20
>>>>>> What's the right tag to put in the commit for this?
>>>>>> Fixes-but-is-independent-from: ? ;)
>>>>>
>>>>> Heh. You can still put Fixes: I think.
>>>>
>>>> Yeah, I think so too.
>>>
>>> Cool. My "git grep 'struct station_info sinfo'" also shows up a driver
>>> in staging; that should be fixed as well, right? In the same commit?
>>
>> Not in the same commit at least, I don't want to touch staging even with
>> a ten foot pole :) I guess either Greg or Johannes would take that
>> patch.
>
> What about batman-adv and wext-compat? Should I split those out as well?

So normally I only take patches touching drivers/net/wireless, anything
else has to go via other trees.

--=20
Kalle Valo
