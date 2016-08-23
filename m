Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35253 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754314AbcHWIwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Aug 2016 04:52:55 -0400
Received: by mail-wm0-f54.google.com with SMTP id f65so153170383wmi.0
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2016 01:52:55 -0700 (PDT)
Subject: Re: [PATCH v4] ath9k: Switch to using mac80211 intermediate software
 queues.
To: Kalle Valo <kvalo@codeaurora.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rg?= =?UTF-8?Q?ensen?=
        <toke@toke.dk>
References: <20160706193417.13080-1-toke@toke.dk>
 <20160805160346.10545-1-toke@toke.dk> <87mvk44xmt.fsf@purkki.adurom.net>
 <87bn0k4w4d.fsf@toke.dk> <87fupwvisn.fsf@kamboji.qca.qualcomm.com>
 <871t1g4thz.fsf@toke.dk> <877fb8ug0x.fsf@kamboji.qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, ath9k-devel@lists.ath9k.org,
        Tim Shepard <shep@alum.mit.edu>, Felix Fietkau <nbd@nbd.name>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <57157bcd-498d-537c-875f-1ff8c7f82b80@broadcom.com> (sfid-20160823_105303_748726_B36E6919)
Date: Tue, 23 Aug 2016 10:52:48 +0200
MIME-Version: 1.0
In-Reply-To: <877fb8ug0x.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 23-08-16 08:59, Kalle Valo wrote:
> Toke Høiland-Jørgensen <toke@toke.dk> writes:
> 
>>>>> This is great work but due to the regressions I'm not sure if this
>>>>> will be ready for 4.9. To get more testing time I wonder if we should
>>>>> wait for 4.10? IMHO applying this in the end of the cycle is too risky
>>>>> and we should try to maximise the time linux-next by applying this
>>>>> just after -rc1 is released.
>>>>>
>>>>> Thoughts?
>>>>
>>>> Well, now that we understand what is causing the throughput regressions,
>>>> fixing them should be fairly straight forward (yeah, famous last words,
>>>> but still...). I already have a patch for the fast path and will go poke
>>>> at the slow path next. It'll probably require another workaround or two,
>>>> so I guess it won't be the architecturally clean ideal solution; but it
>>>> would make it possible to have something that works for 4.9 and then
>>>> iterate for a cleaner design for 4.10.
>>>
>>> But if we try to rush this to 4.9 it won't be in linux-next for long. We
>>> are now in -rc3 and let's say that the patches are ready to apply in two
>>> weeks. That would leave us only two weeks of -next time before the merge
>>> window, which I think is not enough for a controversial patch like this
>>> one. There might be other bugs lurking which haven't been found yet.
>>
>> What, other hidden bugs? Unpossible! :)
> 
> Yeah, right ;)
> 
>> Would it be possible to merge the partial solution (which is ready now,
>> basically) and fix the slow path in a separate patch later?
> 
> What do you mean with partial solution? You mean ath9k users would
> suffer from regressions until they are fixed? We can't do that.
> 
>> (Just spit-balling here; I'm still fairly new to this process. But I am
>> concerned that we'll hit a catch-22 where we can't get wider testing
>> before it's "ready" and we can't prove that it's "ready" until we've had
>> wider testing...)

So could the wider testing be accomplished by working on a branch in the
wireless-testing repo and make its availability known on wireless-list,
ath?k-list, LWN or whatever.

Regards,
Arend

> I understand your point, but I don't want to rush this to 4.9 and then
> start getting lots of bug reports and eventually forced to revert it. If
> we just found a new serious regression the chances are that there are
> more lurking somewhere and this patch is just not ready yet.
