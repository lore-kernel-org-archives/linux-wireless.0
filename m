Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:36652 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757698AbdACOOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 09:14:16 -0500
Received: by mail-oi0-f43.google.com with SMTP id v84so508187433oie.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2017 06:14:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0c0c9680-2cc8-ad0a-3aa0-ba406a838ab8@broadcom.com>
References: <20170103083858.6981-1-zajec5@gmail.com> <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
 <CACna6rzGRHLCdzxS_+MHXeZwF=BW4S52pDb9g9MuanNGyToEOw@mail.gmail.com> <0c0c9680-2cc8-ad0a-3aa0-ba406a838ab8@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Tue, 3 Jan 2017 15:14:15 +0100
Message-ID: <CACna6rzBr0Co2o4Ym-7coVk1v5g1nvgDv6099oJVFr9drgU_Rw@mail.gmail.com> (sfid-20170103_151454_987730_025BC282)
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

On 3 January 2017 at 14:19, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 3-1-2017 12:31, Rafa=C5=82 Mi=C5=82ecki wrote:
>>>> +             if (!channel) {
>>>> +                     brcmf_err("Firmware reported unexpected channel =
%d\n",
>>>> +                               ch.control_ch_num);
>>>> +                     continue;
>>>> +             }
>>> As stated above something is really off when this happens so should we
>>> continue and try to make sense of what firmware provides or simply fail=
.
>> Well, I could image something like this happening and not being critical=
.
>> The simplest case: Broadcom team releases a new firmware which
>> supports extra 5 GHz channels (e.g. due to the IEEE standard change).
>> Why should we refuse to run & support all "old" channel just because of =
that?
>
> Fair enough. I was assuming we keep __wl_{2,5}ghz_channels up to date
> with IEEE standard.
>
>> What do you mean by "make sense of what firmware provides"? Would kind
>> of solution would you suggest?
>
> When the above assumption can be assured (by us) the only other scenario
> would be a change in the firmware API where we wrongly interpret the
> information retrieved. In this case all subsequent channels will likely
> result in bogus or accidental matches hence it seems better to bail out
> early.

Good point, this actually gave me an idea for a small nice
improvement. I remember I saw something like WL_VER in wl ioctl
protocol, it was already bumped at some point by Broadcom, when
chanspec format has changed. We should probably read this number from
firmware and maybe refuse to run if version is newer than the one we
know.

--=20
Rafa=C5=82
