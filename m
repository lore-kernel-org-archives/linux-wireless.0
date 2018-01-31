Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44697 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932080AbeAaNqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 08:46:08 -0500
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k will not tx packets sometimes.
In-Reply-To: <6bb730a0-f67b-b131-59a4-70baea810584@dd-wrt.com>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com> <87a7wzv43j.fsf@toke.dk> <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com> <87d11stk0i.fsf@toke.dk> <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com> <871si81eev.fsf@toke.dk> <5A6FA79B.1080206@candelatech.com> <87h8r335yz.fsf@toke.dk> <712ee959-4e41-f4fd-e765-523d024fa7fc@candelatech.com> <87wozzyy5e.fsf@toke.dk> <0e4aa72c-83da-e879-052d-505d8658177d@dd-wrt.com> <878tce2qo3.fsf@toke.dk> <6bb730a0-f67b-b131-59a4-70baea810584@dd-wrt.com>
Date: Wed, 31 Jan 2018 14:46:06 +0100
Message-ID: <87zi4u16qp.fsf@toke.dk> (sfid-20180131_144701_102822_E3811084)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 31.01.2018 um 12:50 schrieb Toke H=C3=B8iland-J=C3=B8rgensen:
>> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>>
>>> Am 30.01.2018 um 19:55 schrieb Toke H=C3=B8iland-J=C3=B8rgensen:
>>>> Ben Greear <greearb@candelatech.com> writes:
>>>>
>>>>>> I'm actually working on reworking that whole scheduler logic, and mo=
ve
>>>>>> some of it into mac80211. Could you test this (WiP) patch and see if
>>>>>> that has the same problem?
>>>>> It had some serious conflicts in ath10k, due to my local changes, so
>>>>> I did not actually test this.
>>>> Can send you a version without the ath10k changes tomorrow if you'd li=
ke
>>>> to test - but will try to reproduce myself as well...
>>>>
>>>>> But, a revert of the atf patches (a6e56d749 and 63fefa050) appear to
>>>>> have resolved the issue. I'll test more with these reverted, and maybe
>>>>> will have time to work more on actually fixing upstream code next time
>>>>> I move to a newer kernel (and/or after your pending changes get in).
>>>> Ah, that narrows it down some. Well, that is the code I'm hacking on
>>>> currently anyway, so let's see if we can't get it fixed as part of that
>>>> series :)
>>> i have some addition information for you maybe. in the same timeframe i
>>> noticed a increased memory usage for ath9k devices.
>>> maybe that helps. so i hit memory boundaries on embedded devices with
>>> dual interfaces and just 32 mb=C2=A0 ram now which wasnt the case before
>>> is this patch worth to try from my side?
>> This is probably because of the added queue space. Which is sort of by
>> design. In 3ff23cd5654b9c8f4d567caa73439b4c39fbeaae we lowered the
>> default limit for non-VHT devices to 4MB. But if you have several PHYs
>> on a very memory constrained device you could still run out I guess.
>>
>> `echo fq_memory_limit 2097152 > /sys/kernel/debug/ieee80211/phy0/aqm`
>> would limit it to 2MB for that phy...
> what if i tried that already? :-)

Hmm, then it's maybe a bug? Changing the limit makes no difference at
all? Does your build include 0bfe649fbb133? What are values of the
counters in /sys/kernel/debug/ieee80211/phy0/aqm ?

-Toke
