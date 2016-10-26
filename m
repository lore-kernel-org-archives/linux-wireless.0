Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754623AbcJZLLf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 07:11:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        "Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH 19/28] brcmfmac: avoid maybe-uninitialized warning in brcmf_cfg80211_start_ap
References: <20161017220342.1627073-1-arnd@arndb.de>
        <20161017221355.1861551-7-arnd@arndb.de>
        <87zilr61ux.fsf@kamboji.qca.qualcomm.com> <3406231.8mt2808XDi@wuerfel>
Date: Wed, 26 Oct 2016 14:11:23 +0300
In-Reply-To: <3406231.8mt2808XDi@wuerfel> (Arnd Bergmann's message of "Wed, 26
        Oct 2016 11:57:23 +0200")
Message-ID: <87funj5pr8.fsf@kamboji.qca.qualcomm.com> (sfid-20161026_131153_960641_42750D36)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Wednesday, October 26, 2016 9:49:58 AM CEST Kalle Valo wrote:
>> Arnd Bergmann <arnd@arndb.de> writes:
>>=20
>> > A bugfix added a sanity check around the assignment and use of the
>> > 'is_11d' variable, which looks correct to me, but as the function is
>> > rather complex already, this confuses the compiler to the point where
>> > it can no longer figure out if the variable is always initialized
>> > correctly:
>> >
>> > brcm80211/brcmfmac/cfg80211.c: In function =E2=80=98brcmf_cfg80211_sta=
rt_ap=E2=80=99:
>> > brcm80211/brcmfmac/cfg80211.c:4586:10: error: =E2=80=98is_11d=E2=80=99=
 may be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
>> >
>> > This adds an initialization for the newly introduced case in which
>> > the variable should not really be used, in order to make the warning
>> > go away.
>> >
>> > Fixes: b3589dfe0212 ("brcmfmac: ignore 11d configuration errors")
>> > Cc: Hante Meuleman <hante.meuleman@broadcom.com>
>> > Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
>> > Cc: Kalle Valo <kvalo@codeaurora.org>
>> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>=20
>> Via which tree are you planning to submit this? Should I take it?
>
> I'd prefer if you can take it and forward it along with your other
> bugfixes. I'll try to take care of the ones that nobody else
> picked up.

Ok, I'll take it. I'm planning to push this to 4.9.

--=20
Kalle Valo
