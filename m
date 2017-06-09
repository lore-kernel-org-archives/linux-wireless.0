Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:59390 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdFIWCY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 18:02:24 -0400
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com>
 <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
 <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com>
 <1496993334.2424.1.camel@sipsolutions.net>
 <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com>
 <1497038480.12088.6.camel@sipsolutions.net>
 <e617e9f9-0a83-cfef-9bb3-127a06ba33e0@candelatech.com>
 <CAFED-jnTNGU-VozW1kLxzHk+Uq3JfR2kTfu-J8gTbrHebzX_2w@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <f5bb406e-0c1d-393c-54f1-97847017a473@candelatech.com> (sfid-20170610_000228_233107_BE61DEE9)
Date: Fri, 9 Jun 2017 15:02:23 -0700
MIME-Version: 1.0
In-Reply-To: <CAFED-jnTNGU-VozW1kLxzHk+Uq3JfR2kTfu-J8gTbrHebzX_2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/09/2017 02:47 PM, Janusz Dziedzic wrote:
> 2017-06-09 22:18 GMT+02:00 Ben Greear <greearb@candelatech.com>:
>> On 06/09/2017 01:01 PM, Johannes Berg wrote:
>>>
>>> On Fri, 2017-06-09 at 06:46 -0700, Ben Greear wrote:
>>>
>>>>> However, the solution is far simpler! Once you have nl80211 PAE
>>>>> transport, you can easily even set the key before transmitting the
>>>>> packet and simply indicate that this particular packet should _not_
>>>>> be encrypted regardless of key presence.
>>>>
>>>>
>>>> My ath10k firmware cannot deal with a case like this:
>>>>
>>>> pkt is enqueued before key is set
>>>> key is set
>>>> pkt is transmitted (incorrectly)
>>>>
>>>> This is because of how the tid's header-length variables are set up
>>>> and modified when the keys are set, and I don't see any good way to
>>>> fix this.
>>>
>>>
>>> That seems awful, and anyway will not work with the mentioned non-IEEE
>>> protocols that require not encrypting the rekeying frames even when
>>> keys have been set up.
>>>
>>> I don't know what to tell you here, I think it'd be best if you fix
>>> that.
>>
>>
>> The case that fails is basically any packet that is currently
>> enqueued in the firmware when the key is set is transmitted incorrectly or
>> not at all.
>> And, maybe this is only for DATA tids.
>>
>> Otherwise, the no-encrypt logic should work fine.  So, it is just the race
>> with the EAPOL 4/4 and set-key that causes issues as far as I can tell.
>>
>> It looks like the EAPOL 4/4 and set-key race is fixable without too much
>> effort,
>> so I think I will focus on that for now instead of further hacking special
>> case logic into the firmware.
>>
> Ben, as I remember correctly there is a flag,
> WMI_PEER_NEED_PTK_4_WAY
>
> This fix race (you describe) in the firmware/hw.
> For 636 firmware, where we tested STA mode really hard (5 years ago),
> that works perfect.
> So, I am not sure why this flag don't work correctly with your firmware.

I removed/ignored this flag/logic to make .11r work (in 10.1.4-mumble),
just possibly .11r worked before in the 636 firmware.

>
> Regarding EAPOL frames I am not sure you will have real/correct ACK. I
> remember in case of mgmt frames FW always return ACK - but probably
> you will check that.

I fixed the rx-status, but really, valid or not, it would at least fix the race
to wait to get the status.

> I also fight with some EAPOL frames, but forgot why ... Seems my brain
> removed this information for some reason :-)

The firmware code was nasty in this regard...I wouldn't try to remember
it if I were you :)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
