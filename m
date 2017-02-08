Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:32997 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753478AbdBHHYe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 02:24:34 -0500
Received: by mail-ot0-f196.google.com with SMTP id f9so17118099otd.0
        for <linux-wireless@vger.kernel.org>; Tue, 07 Feb 2017 23:23:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <def0e631e44d4b44a87124a5b530d6ec@SC-EXCH02.marvell.com>
References: <260962939eeb4dbbb6e462cc010aac21@SC-EXCH02.marvell.com>
 <CALLGbRLXa5m+eRhZpvWKyXkemB0qAkB=eoQKwns-vP29+izV+Q@mail.gmail.com>
 <CACna6rzKWAz_xxi=ehKijGtM4XEcioSjwmb=V0rq_vKioiS=Ew@mail.gmail.com>
 <3e57f30c29254db4a906e3e71ac36da5@SC-EXCH02.marvell.com> <CALLGbRJ9h5fvS+DLOBGTcejW8yiwFW-xey+TaubauH2rZuVWwQ@mail.gmail.com>
 <def0e631e44d4b44a87124a5b530d6ec@SC-EXCH02.marvell.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 8 Feb 2017 08:23:39 +0100
Message-ID: <CACna6rz8chrPU+yZC0xakKVeLFm8fgpDoSFP_Vyo8mH1C+DCzQ@mail.gmail.com> (sfid-20170208_082440_866973_0F98A7F3)
Subject: Re: [PATCH v9] Add new mac80211 driver mwlwifi.
To: David Lin <dlin@marvell.com>
Cc: Steve deRosier <derosier@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Chor Teck Law <ctlaw@marvell.com>,
        James Lin <jamesl@marvell.com>, Pete Hsieh <peteh@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8 February 2017 at 07:30, David Lin <dlin@marvell.com> wrote:
> steve.derosier@gmail.com [mailto:steve.derosier@gmail.com] wrote:
>> On Tue, Feb 7, 2017 at 10:15 PM, David Lin <dlin@marvell.com> wrote:
>> >> Rafa=C5=82 Mi=C5=82ecki [mailto:zajec5@gmail.com] wrote:
>> >> Please use ieee80211-freq-limit:
>> >> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commi
>> >> t/?id=3Db3
>> >> 30b25eaabda00d74e47566d9200907da381896
>> >>
>> >> Most likely with wiphy_read_of_freq_limits helper:
>> >> https://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/commi
>> >> t/?id=3De6
>> >> 91ac2f75b69bee743f0370d79454ba4429b175
>> >
>> > I already replied meaning of these parameters:
>> > <marvell,2ghz> is used to disable 2g band.
>> > <marvell,5ghz> is used to disable 5g band.
>> > <marvell, chainmask> is used to specify antenna number (if default num=
ber
>> is suitable for you, there is no need to use this parameter).
>> > <marvell,powertable> should not be used for chip with device power tab=
le.
>> In fact, this parameter should not be used any more.
>> >
>>
>> David, I think you're not understanding the comment, or at least that's =
what it
>> looks like to me. Yes, you did reply as to the meaning.
>> And, your reply, while informative, didn't tell us you understood and we=
re
>> willing to fix the problem. I doubt you meant it this way, but it feels =
defensive
>> and like a brush-off.
>>
>> First off, you will still have to document any DT bindings you're adding=
. Just
>> because you answer the question in the review doesn't mean you're not
>> responsible for doing so.
>>
>> And second off, I think that Rafal (and sorry about my spelling, looks l=
ike
>> there's some sort of accent on the l that I don't know how to make my
>> keyboard do) is saying: there's already some generic bindings that can b=
e used
>> to disable the 2g or 5g bands. Granted they're even newer than your patc=
h,
>> but I do think if said bindings exist and are appropriate, you should us=
e them.
>>
>> - Steve
>
> These parameters are marvell proprietary parameters, I don't think it sho=
uld be added to DT bindings.

Steve is correct.

You have to document new properties, just because they are Marvell
specific doesn't change anything. You just document them in a proper
place.


> BTW, <marvell,2ghz> and <marvell,5ghz> are only used for mwlwifi to repor=
t supported bands, it is not related to limitation of frequency.

How reporting a single band doesn't limit reported frequencies? You
can achieve exactly the same using generic property, so there is no
place for Marvell specific ones.

In fact there were drivers of 3 vendors requiring band/freq-related
description in DT: Broadcom, Marvell & Mediatek. This property was
discussed & designed to support all limitation cases we found possible
to make it usable with (hopefully) all drivers.

--=20
Rafa=C5=82
