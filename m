Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39660 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934986AbdADIMf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 03:12:35 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list\:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
References: <20170103083858.6981-1-zajec5@gmail.com>
        <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
        <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com>
        <0c0c9680-2cc8-ad0a-3aa0-ba406a838ab8@broadcom.com>
        <CACna6rzBr0Co2o4Ym-7coVk1v5g1nvgDv6099oJVFr9drgU_Rw@mail.gmail.com>
        <CACna6rxYPFWfvA4TyQTjGCrduefiCU-j4vR8PrfbCnN3P8-iyg@mail.gmail.com>
Date: Wed, 04 Jan 2017 10:12:28 +0200
In-Reply-To: <CACna6rxYPFWfvA4TyQTjGCrduefiCU-j4vR8PrfbCnN3P8-iyg@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Tue, 3 Jan 2017
 16:49:17 +0100")
Message-ID: <87shozi6qb.fsf@kamboji.qca.qualcomm.com> (sfid-20170104_091239_569438_C2291246)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 3 January 2017 at 15:14, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wr=
ote:
>> On 3 January 2017 at 14:19, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 3-1-2017 12:31, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>>>> +             if (!channel) {
>>>>>> +                     brcmf_err("Firmware reported unexpected channe=
l %d\n",
>>>>>> +                               ch.control_ch_num);
>>>>>> +                     continue;
>>>>>> +             }
>>>>> As stated above something is really off when this happens so should we
>>>>> continue and try to make sense of what firmware provides or simply fa=
il.
>>>> Well, I could image something like this happening and not being critic=
al.
>>>> The simplest case: Broadcom team releases a new firmware which
>>>> supports extra 5 GHz channels (e.g. due to the IEEE standard change).
>>>> Why should we refuse to run & support all "old" channel just because o=
f that?
>>>
>>> Fair enough. I was assuming we keep __wl_{2,5}ghz_channels up to date
>>> with IEEE standard.
>>>
>>>> What do you mean by "make sense of what firmware provides"? Would kind
>>>> of solution would you suggest?
>>>
>>> When the above assumption can be assured (by us) the only other scenario
>>> would be a change in the firmware API where we wrongly interpret the
>>> information retrieved. In this case all subsequent channels will likely
>>> result in bogus or accidental matches hence it seems better to bail out
>>> early.
>>
>> Good point, this actually gave me an idea for a small nice
>> improvement. I remember I saw something like WL_VER in wl ioctl
>> protocol, it was already bumped at some point by Broadcom, when
>> chanspec format has changed. We should probably read this number from
>> firmware and maybe refuse to run if version is newer than the one we
>> know.
>
> I was thinking about WLC_GET_VERSION and you seem to already have it
> in brcmfmac under nam BRCMF_C_GET_VERSION. If you wish to be prepared
> for firmware API change, I guess you should check version. It seems
> brcmfmac supports 1 and 2.
>
> On the other hand if adding firmware with incompatible API you may
> want to have different directory or file names. I think this is what
> Intel does. This allows one to have multiple firmwares in
> /lib/firmware/ and switching between kernels freely.

ath10k does something similar. IIRC we currently support four different,
and incompatible, firmware releases now.

--=20
Kalle Valo
