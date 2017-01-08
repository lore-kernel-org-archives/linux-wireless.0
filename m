Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33862 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751863AbdAHPDT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Jan 2017 10:03:19 -0500
Received: by mail-oi0-f66.google.com with SMTP id 3so61205579oih.1
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2017 07:03:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <117c6355-a612-1797-a1ae-225f68543568@broadcom.com>
References: <20170107203605.24866-1-zajec5@gmail.com> <20170107203605.24866-2-zajec5@gmail.com>
 <117c6355-a612-1797-a1ae-225f68543568@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Sun, 8 Jan 2017 16:03:18 +0100
Message-ID: <CACna6rxaTRhzvdhnQsSWdjUFxBTEObcD85SBb60Ng+iSMUPs9A@mail.gmail.com> (sfid-20170108_160323_743125_DFA4D84E)
Subject: Re: [PATCH 2/2] brcmfmac: setup wiphy bands after registering it first
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

On 8 January 2017 at 14:00, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 7-1-2017 21:36, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> During bands setup we disable all channels that firmware doesn't support
>> in the current regulatory setup. If we do this before wiphy_register
>> it will result in copying set flags (including IEEE80211_CHAN_DISABLED)
>> to the orig_flags which is supposed to be persistent. We don't want this
>> as regulatory change may result in enabling some channels. We shouldn't
>> mess with orig_flags then (by changing them or ignoring them) so it's
>> better to just take care of their proper values.
>>
>> This patch cleanups code a bit (by taking orig_flags more seriously) and
>> allows further improvements like disabling really unavailable channels.
>> We will need that e.g. if some frequencies should be disabled for good
>> due to hardware setup (design).
>
> I think this and previous patch are too dependent and prefer to have
> them in a single patch. Despite that for both:
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

This time to make sure I can be easily understood I decided to use two
smaller patches & describe each of them with all the details that came
to my mind. I also made sure (and described that) that applying only
1/2 won't break anything (we never wan't to break potential bisecting
process).

I can work on merging (squashing) these 2 patches but then I need to
rework commit messages & I'll risk someone will say my description
isn't clear enough or my patch is too complex...

If there isn't a real problem (and maybe having 2 patches makes
following changes more easily) maybe let's stick to this patchset?

--=20
Rafa=C5=82
