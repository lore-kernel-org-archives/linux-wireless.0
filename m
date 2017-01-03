Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36822 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752702AbdACPtS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 10:49:18 -0500
Received: by mail-oi0-f68.google.com with SMTP id u15so70728279oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 07:49:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CACna6rzBr0Co2o4Ym-7coVk1v5g1nvgDv6099oJVFr9drgU_Rw@mail.gmail.com>
References: <20170103083858.6981-1-zajec5@gmail.com> <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
 <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com>
 <0c0c9680-2cc8-ad0a-3aa0-ba406a838ab8@broadcom.com> <CACna6rzBr0Co2o4Ym-7coVk1v5g1nvgDv6099oJVFr9drgU_Rw@mail.gmail.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Jan 2017 16:49:17 +0100
Message-ID: <CACna6rxYPFWfvA4TyQTjGCrduefiCU-j4vR8PrfbCnN3P8-iyg@mail.gmail.com> (sfid-20170103_164958_164865_2D993ABA)
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3 January 2017 at 15:14, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrot=
e:
> On 3 January 2017 at 14:19, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 3-1-2017 12:31, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>>> +             if (!channel) {
>>>>> +                     brcmf_err("Firmware reported unexpected channel=
 %d\n",
>>>>> +                               ch.control_ch_num);
>>>>> +                     continue;
>>>>> +             }
>>>> As stated above something is really off when this happens so should we
>>>> continue and try to make sense of what firmware provides or simply fai=
l.
>>> Well, I could image something like this happening and not being critica=
l.
>>> The simplest case: Broadcom team releases a new firmware which
>>> supports extra 5 GHz channels (e.g. due to the IEEE standard change).
>>> Why should we refuse to run & support all "old" channel just because of=
 that?
>>
>> Fair enough. I was assuming we keep __wl_{2,5}ghz_channels up to date
>> with IEEE standard.
>>
>>> What do you mean by "make sense of what firmware provides"? Would kind
>>> of solution would you suggest?
>>
>> When the above assumption can be assured (by us) the only other scenario
>> would be a change in the firmware API where we wrongly interpret the
>> information retrieved. In this case all subsequent channels will likely
>> result in bogus or accidental matches hence it seems better to bail out
>> early.
>
> Good point, this actually gave me an idea for a small nice
> improvement. I remember I saw something like WL_VER in wl ioctl
> protocol, it was already bumped at some point by Broadcom, when
> chanspec format has changed. We should probably read this number from
> firmware and maybe refuse to run if version is newer than the one we
> know.

I was thinking about WLC_GET_VERSION and you seem to already have it
in brcmfmac under nam BRCMF_C_GET_VERSION. If you wish to be prepared
for firmware API change, I guess you should check version. It seems
brcmfmac supports 1 and 2.

On the other hand if adding firmware with incompatible API you may
want to have different directory or file names. I think this is what
Intel does. This allows one to have multiple firmwares in
/lib/firmware/ and switching between kernels freely.

--=20
Rafa=C5=82
