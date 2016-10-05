Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33718 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753741AbcJERyd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 13:54:33 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v4] ath9k: Switch to using mac80211 intermediate software queues.
References: <20160706193417.13080-1-toke@toke.dk>
        <20160805160346.10545-1-toke@toke.dk>
        <87mvk44xmt.fsf@purkki.adurom.net> <87bn0k4w4d.fsf@toke.dk>
        <87fupwvisn.fsf@kamboji.qca.qualcomm.com> <871t1g4thz.fsf@toke.dk>
        <877fb8ug0x.fsf@kamboji.qca.qualcomm.com> <87k2dm6git.fsf@toke.dk>
        <878tu2okv7.fsf@kamboji.qca.qualcomm.com> <87d1jeenwa.fsf@toke.dk>
Date: Wed, 05 Oct 2016 20:54:27 +0300
In-Reply-To: <87d1jeenwa.fsf@toke.dk> ("Toke =?utf-8?Q?H=C3=B8iland-J?=
 =?utf-8?Q?=C3=B8rgensen=22's?= message of
        "Wed, 05 Oct 2016 18:55:33 +0200")
Message-ID: <874m4qof58.fsf@kamboji.qca.qualcomm.com> (sfid-20161005_195436_674665_A1CC25B0)
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
>>>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>>>
>>>> I understand your point, but I don't want to rush this to 4.9 and then
>>>> start getting lots of bug reports and eventually forced to revert it. =
If
>>>> we just found a new serious regression the chances are that there are
>>>> more lurking somewhere and this patch is just not ready yet.
>>>
>>> So, the changes to mac80211 that fixes the known regressions of this
>>> patch have gone in.
>>
>> I guess you mean this commit:
>>
>> bb42f2d13ffc mac80211: Move reorder-sensitive TX handlers to after TXQ d=
equeue
>>
>> (Just making sure that I have the same commit in my tree when I apply
>> this)
>
> Yup, that's the one :)
>
>>> Any chance of seeing this merged during the current merge window? :)
>>
>> I sent last new feature ("-next") patches for 4.9 last week, sorry. So
>> this has to wait for 4.10.
>
> Ah, right, I think I got my merge windows confused. You already said you
> wouldn't take it for 4.9. So I guess what I'm asking is for you to put
> it into the appropriate -next tree so it can get some wider exposure
> ahead of the *next* merge window...

Yeah, we have plenty of time for 4.10 :) So my plan is to apply this
after I open wireless-drivers-next in 2-3 weeks or so. That would mean
that the patch would hit Linus' tree when 4.10-rc1 is released
(estimated to happen on 2017-01-01). The timing is actually perfect as
now we get maximal testing time on -next.

>> And I assume I need to take v5:
>>
>> https://patchwork.kernel.org/patch/9311037/
>
> Yes. Haven't noticed anything that changed since that might conflict
> with it, but let me know if I missed something and you want a refreshed
> version.

Thanks, I'll let you know if there are any problems.

--=20
Kalle Valo
