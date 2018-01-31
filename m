Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:60705 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752431AbeAaNhr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 Jan 2018 08:37:47 -0500
Subject: Re: ath9k will not tx packets sometimes.
To: =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <c383b64d-d028-3d83-f1c1-b4e32ca04c26@candelatech.com>
 <87a7wzv43j.fsf@toke.dk>
 <f021a32c-6f12-1cfe-970f-eae7dd334416@candelatech.com>
 <87d11stk0i.fsf@toke.dk>
 <11a30dfe-842a-8b1e-0d7e-d4159bf4b2bb@candelatech.com>
 <871si81eev.fsf@toke.dk> <5A6FA79B.1080206@candelatech.com>
 <87h8r335yz.fsf@toke.dk>
 <712ee959-4e41-f4fd-e765-523d024fa7fc@candelatech.com>
 <87wozzyy5e.fsf@toke.dk> <0e4aa72c-83da-e879-052d-505d8658177d@dd-wrt.com>
 <878tce2qo3.fsf@toke.dk>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <6bb730a0-f67b-b131-59a4-70baea810584@dd-wrt.com> (sfid-20180131_143800_803830_428E763C)
Date: Wed, 31 Jan 2018 14:37:44 +0100
MIME-Version: 1.0
In-Reply-To: <878tce2qo3.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 31.01.2018 um 12:50 schrieb Toke Høiland-Jørgensen:
> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> Am 30.01.2018 um 19:55 schrieb Toke Høiland-Jørgensen:
>>> Ben Greear <greearb@candelatech.com> writes:
>>>
>>>>> I'm actually working on reworking that whole scheduler logic, and move
>>>>> some of it into mac80211. Could you test this (WiP) patch and see if
>>>>> that has the same problem?
>>>> It had some serious conflicts in ath10k, due to my local changes, so
>>>> I did not actually test this.
>>> Can send you a version without the ath10k changes tomorrow if you'd like
>>> to test - but will try to reproduce myself as well...
>>>
>>>> But, a revert of the atf patches (a6e56d749 and 63fefa050) appear to
>>>> have resolved the issue. I'll test more with these reverted, and maybe
>>>> will have time to work more on actually fixing upstream code next time
>>>> I move to a newer kernel (and/or after your pending changes get in).
>>> Ah, that narrows it down some. Well, that is the code I'm hacking on
>>> currently anyway, so let's see if we can't get it fixed as part of that
>>> series :)
>> i have some addition information for you maybe. in the same timeframe i
>> noticed a increased memory usage for ath9k devices.
>> maybe that helps. so i hit memory boundaries on embedded devices with
>> dual interfaces and just 32 mb  ram now which wasnt the case before
>> is this patch worth to try from my side?
> This is probably because of the added queue space. Which is sort of by
> design. In 3ff23cd5654b9c8f4d567caa73439b4c39fbeaae we lowered the
> default limit for non-VHT devices to 4MB. But if you have several PHYs
> on a very memory constrained device you could still run out I guess.
>
> `echo fq_memory_limit 2097152 > /sys/kernel/debug/ieee80211/phy0/aqm`
> would limit it to 2MB for that phy...
what if i tried that already? :-)

Sebastian
>
> -Toke
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
