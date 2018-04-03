Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:45014 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754813AbeDCKRO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 06:17:14 -0400
Received: by mail-wr0-f176.google.com with SMTP id u46so18113451wrc.11
        for <linux-wireless@vger.kernel.org>; Tue, 03 Apr 2018 03:17:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5AC339B0.6070408@broadcom.com>
References: <1521734286-16293-1-git-send-email-dan.haab@luxul.com>
 <5AB4C986.1090709@broadcom.com> <CACna6rzfCA3VyiG2bCNY5eHRo9LGsvNa5Tmb23gyDeFBJHcQZg@mail.gmail.com>
 <5AC339B0.6070408@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Apr 2018 12:17:12 +0200
Message-ID: <CACna6rx+2i+P+F2XRNRm7DrxaiXsoABWARR_XV4rdBXBUFO3bw@mail.gmail.com> (sfid-20180403_121718_445598_C9A4DA40)
Subject: Re: [PATCH] brcmfmac: add support for BCM4366E chipset
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Dan Haab <riproute@gmail.com>, Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Double Lo <double.lo@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>,"
        <brcm80211-dev-list@cypress.com>, Dan Haab <dhaab@luxul.com>,
        Dan Haab <dan.haab@luxul.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 April 2018 at 10:22, Arend van Spriel <arend.vanspriel@broadcom.com> w=
rote:
> On 3/30/2018 9:26 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
>>
>> On 23 March 2018 at 10:31, Arend van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>>
>>> On 3/22/2018 4:58 PM, Dan Haab wrote:
>>>>
>>>>
>>>> From: Dan Haab <dhaab@luxul.com>
>>>>
>>>> BCM4366E is a wireless chipset with a BCM43664 ChipCommon. It's
>>>> supported by the same firmware as 4366c0.
>>>
>>>
>>>
>>> Thanks, Dan
>>>
>>> I have a patch for that queued up already. So let me push that instead.
>>
>>
>> Arend: is there some actual problem with this patch? Other than you
>> have a similar one queued?
>>
>> I'd prefer to just accept it as it's already there, it was sent first
>> and it looks alright. It hopefully won't be too hard to rebase your
>> queued work on top of this trivial patch.
>
>
> My first reaction to this email needed to some cooldown time, but managed=
 to
> swallow it.

I'm sorry you keep reacting to my e-mails/patches that way. I can't
see how my e-mail was offensive in any way. I assure I didn't mean it
to be.

I really assumed there could be some extra changes needed to support
4366E properly, that's why I asked. I can remember adding a full
support for 4366b1 wasn't that obvious and you and Hante spent some
time helping me with some specific device. They required changes from
commit 6ac27689b01e2 ("brcmfmac: use device memsize config from fw if
defined").


> I actually had a couple of issues with the patch and did not
> want to waste Dan's time when there was a patch ready. I did not want to =
add
> another device because we are still in the process of releasing the firmw=
are
> for it. Fiddling with radar detection causing the delay of that.

It's something that I think was never a problem in the past. There is
e.g. support for 4366c0 support in the brcmfmac without
brcmfmac4366c-pcie.bin officially released.


> Another
> thing is that there is no separate BRCMF_FW_NVRAM_DEF() needed for this. =
And
> finally, the firmware download code has been reworked so this patch needs
> rebasing.

Thanks for rebasing that! I appreciate your help. I'll work on
backporting that into OpenWrt/LEDE.

--=20
Rafa=C5=82
