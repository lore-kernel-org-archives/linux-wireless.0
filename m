Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:33583 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdFIVrL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 17:47:11 -0400
Received: by mail-oi0-f49.google.com with SMTP id s3so35670629oia.0
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jun 2017 14:47:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <e617e9f9-0a83-cfef-9bb3-127a06ba33e0@candelatech.com>
References: <4982156c-5325-8021-dcd3-f13e02c63c72@candelatech.com>
 <11de85e9-6028-e2f8-376b-3188ff1b95a5@gmail.com> <2cfd1160-f9b4-5f04-e20f-8d7f9be54f95@candelatech.com>
 <a0e8bd3f-ac25-9619-3f83-1b1debb36a4f@gmail.com> <1496993334.2424.1.camel@sipsolutions.net>
 <de7611e7-c34d-26e2-4083-b7e01b657426@candelatech.com> <1497038480.12088.6.camel@sipsolutions.net>
 <e617e9f9-0a83-cfef-9bb3-127a06ba33e0@candelatech.com>
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Date: Fri, 9 Jun 2017 23:47:09 +0200
Message-ID: <CAFED-jnTNGU-VozW1kLxzHk+Uq3JfR2kTfu-J8gTbrHebzX_2w@mail.gmail.com> (sfid-20170609_234715_372053_487AE74F)
Subject: Re: Question on setting key right after the EAPOL 4/4 is sent.
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2017-06-09 22:18 GMT+02:00 Ben Greear <greearb@candelatech.com>:
> On 06/09/2017 01:01 PM, Johannes Berg wrote:
>>
>> On Fri, 2017-06-09 at 06:46 -0700, Ben Greear wrote:
>>
>>>> However, the solution is far simpler! Once you have nl80211 PAE
>>>> transport, you can easily even set the key before transmitting the
>>>> packet and simply indicate that this particular packet should _not_
>>>> be encrypted regardless of key presence.
>>>
>>>
>>> My ath10k firmware cannot deal with a case like this:
>>>
>>> pkt is enqueued before key is set
>>> key is set
>>> pkt is transmitted (incorrectly)
>>>
>>> This is because of how the tid's header-length variables are set up
>>> and modified when the keys are set, and I don't see any good way to
>>> fix this.
>>
>>
>> That seems awful, and anyway will not work with the mentioned non-IEEE
>> protocols that require not encrypting the rekeying frames even when
>> keys have been set up.
>>
>> I don't know what to tell you here, I think it'd be best if you fix
>> that.
>
>
> The case that fails is basically any packet that is currently
> enqueued in the firmware when the key is set is transmitted incorrectly or
> not at all.
> And, maybe this is only for DATA tids.
>
> Otherwise, the no-encrypt logic should work fine.  So, it is just the race
> with the EAPOL 4/4 and set-key that causes issues as far as I can tell.
>
> It looks like the EAPOL 4/4 and set-key race is fixable without too much
> effort,
> so I think I will focus on that for now instead of further hacking special
> case logic into the firmware.
>
Ben, as I remember correctly there is a flag,
WMI_PEER_NEED_PTK_4_WAY

This fix race (you describe) in the firmware/hw.
For 636 firmware, where we tested STA mode really hard (5 years ago),
that works perfect.
So, I am not sure why this flag don't work correctly with your firmware.

Regarding EAPOL frames I am not sure you will have real/correct ACK. I
remember in case of mgmt frames FW always return ACK - but probably
you will check that.
I also fight with some EAPOL frames, but forgot why ... Seems my brain
removed this information for some reason :-)

BR
Janusz

>>> Stock ath10k firmware goes to great lengths to parse EAPOL frames and
>>> try to work around it in that manner, but that breaks .11r (or used
>>> to, I haven't tried stock firmware lately) and adds more complexity
>>> to the code.
>>
>>
>> It just has to be a single flag saying "don't encrypt this frame" -
>> nothing super complicated about that?
>>
>> In ath10k it looks like HTT_DATA_TX_DESC_FLAGS0_NO_ENCRYPT gets set for
>> this, seems easy enough?
>>
>>>  From a patch someone sent to hostapd list last night, it seems we
>>> could get the tx-status for the EAPOL 4/4, and in that case, we
>>> *know* the pkt has been transmitted, so we can then set the key
>>> safely it would seem?
>>
>>
>> I think so, and I don't remember why we dismissed this solution. Could
>> be that we just decided solving the bridging issue at the same time,
>> while not introducing more latency, was better.
>>
>> Also, the other way can possibly solve some PTK rekeying issues, so
>> overall the solution to go all the way seems better.
>
>
> I guess I don't fully understand the PAE thing, but if you all like it,
> then sounds good to me.
>
> For kernels not supporting this new feature, it seems that having supplicant
> wait for tx-status would be a good interim fix?
>
> Thanks,
> Ben
>
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>
>
> _______________________________________________
> Hostap mailing list
> Hostap@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/hostap



-- 
Janusz Dziedzic
