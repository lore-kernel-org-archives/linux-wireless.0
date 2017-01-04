Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935124AbdADIJC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 03:09:02 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: avoid writing channel out of allocated array
References: <20170103083858.6981-1-zajec5@gmail.com>
        <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com>
Date: Wed, 04 Jan 2017 10:08:55 +0200
In-Reply-To: <f74a07d7-94a6-f9c6-ba12-adec6f708c3a@broadcom.com> (Arend Van
        Spriel's message of "Tue, 3 Jan 2017 12:02:31 +0100")
Message-ID: <87wpebi6w8.fsf@kamboji.qca.qualcomm.com> (sfid-20170104_090907_068385_5B690BD0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> writes:

> On 3-1-2017 9:38, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>=20
>> Our code was assigning number of channels to the index variable by
>> default. If firmware reported channel we didn't predict this would
>> result in using that initial index value and writing out of array.
>>=20
>> Fix this by detecting unexpected channel and ignoring it.
>>=20
>> Fixes: 58de92d2f95e ("brcmfmac: use static superset of channels for wiph=
y bands")
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> I'm not sure what kind of material it is. It fixes possible memory corru=
ption
>> (serious thing?) but this bug was there since Apr 2015, so is it worth f=
ixing
>> in 4.10? Or maybe I should even cc stable?
>> I don't think any released firmware reports any unexpected channel, so I=
 guess
>> noone ever hit this problem. I just noticed this possible problem when w=
orking
>> on another feature.
>
> Looking at the change I was going to ask if you actually hit the issue
> you are addressing here. The channels in __wl_2ghz_channels and
> __wl_5ghz_channels are complete list of channels for the particular band
> so it would mean firmware behaves out-of-spec or firmware api was
> changed. For robustness a change is acceptable I guess.
>
> My general policy is to submit fixes to wireless-drivers (and stable)
> only if it resolves a critical issue found during testing or a reported
> issue.

That's also my preference. And I read somewhere (forgot where) that in
kernel summit there was a discussion about having only regression fixes
in -rc kernels. So the rules are getting stricter, which is a good thing
as then we can make releases in a shorter cycle.

--=20
Kalle Valo
