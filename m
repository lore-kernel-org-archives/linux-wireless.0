Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33924 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726349AbeHQLii (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 07:38:38 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Ajay Singh <ajay.kathat@microchip.com>, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        nicolas.ferre@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@microchip.com, aditya.shankar@microchip.com
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net> <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
        <8736vdv3f5.fsf@kamboji.qca.qualcomm.com>
        <5B768574.6060009@broadcom.com>
Date: Fri, 17 Aug 2018 11:36:02 +0300
In-Reply-To: <5B768574.6060009@broadcom.com> (Arend van Spriel's message of
        "Fri, 17 Aug 2018 10:21:08 +0200")
Message-ID: <87y3d5tmod.fsf@kamboji.qca.qualcomm.com> (sfid-20180817_103615_978316_8CCFB271)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 8/17/2018 9:49 AM, Kalle Valo wrote:
>> Ajay Singh <ajay.kathat@microchip.com> writes:
>>
>>> On Thu, 16 Aug 2018 13:53:50 +0300
>>> Kalle Valo <kvalo@codeaurora.org> wrote:
>>>
>>>> Kalle Valo <kvalo@codeaurora.org> writes:
>>>>
>>>>>  From wireless point of view: if I see wext mentioned anywhere in the
>>>>> driver I stop right there. cfg80211 is a hard requirement for us
>>>>> nowadays.
>>>>
>>>> Clarification: Depending on the hardware design either cfg80211 or
>>>> mac80211 is a hard requirement. I haven't checked wilc1000 at all so I
>>>> don't know what design it has but if it's a "softmac" design then it
>>>> has to use mac80211, we do not want to support multiple 802.11 UMAC
>>>> stacks.
>>>>
>>>
>>> The TODO item to make use of wext-core is obsolete. Previously wilc1000
>>> driver also had few wext ioctl use but now it=E2=80=99s completely remo=
ved and
>>> cfg80211 operation callbacks are used.
>>>
>>> wilc1000 driver make use of cfg80211 and isn=E2=80=99t a "softmac".
>>
>> Good.
>>
>>> We need help to review and identify if there are any pending items
>>> for wilc1000 driver, so we can address those issues and make it ready
>>> to move to the wireless subsystem.
>>
>> I think the best way to get that forward is to submit a patch (or
>> patchset) to linux-wireless, that's the easiest for reviewers.
>
> For brcm80211 drivers we used a single patch introducing it under the
> wireless drivers folder. Because it was quite a sizable patch we
> parked it on the wireless wiki page. Had a few iterations doing it
> like that.

Another option is to split it so that there's one patch per file, should
be even pretty easy to automate that. It's just so much easier to
comment on a patch submitted by email compared to the reviewer manually
copying code and then commenting it, yuck.

--=20
Kalle Valo
