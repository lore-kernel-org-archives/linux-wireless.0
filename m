Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41874 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbeHQKv2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Aug 2018 06:51:28 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net> <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
Date: Fri, 17 Aug 2018 10:49:02 +0300
In-Reply-To: <20180817100233.7f1c00d9@ajaysk-VirtualBox> (Ajay Singh's message
        of "Fri, 17 Aug 2018 10:02:33 +0530")
Message-ID: <8736vdv3f5.fsf@kamboji.qca.qualcomm.com> (sfid-20180817_094910_789979_9B02FB34)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ajay Singh <ajay.kathat@microchip.com> writes:

> On Thu, 16 Aug 2018 13:53:50 +0300
> Kalle Valo <kvalo@codeaurora.org> wrote:
>
>> Kalle Valo <kvalo@codeaurora.org> writes:
>>=20
>> > Ajay Singh <ajay.kathat@microchip.com> writes:
>> >=20=20
>> >> Hi Greg,
>> >>
>> >> We all are working on submitting and reviewing patches for
>> >> wilc1000 in staging driver for quite some time.=20
>> >>
>> >> We would like to have feedback on the next steps to bring wilc1000
>> >> driver closer to move into the wireless subsystem tree.=20
>> >>
>> >> In summary, the following major things from TODO have been
>> >> addressed in staging:
>> >> -remove the defined feature as kernel versions
>> >> -remove OS wrapper functions
>> >> -remove custom debug and tracing functions
>> >> -rework comments and function headers(also coding style)
>> >> -remove build warnings
>> >> -replace all semaphores with mutexes or completions
>> >> -make spi and sdio components coexist in one build
>> >> -turn compile-time platform configuration (BEAGLE_BOARD,
>> >> PANDA_BOARD, PLAT_WMS8304, PLAT_RKXXXX, CUSTOMER_PLATFORM, ...)
>> >> into run-time options that are read from DT
>> >> -replace SIOCDEVPRIVATE commands with generic API functions
>> >> -use wext-core handling instead of private SIOCSIWPRIV
>> >> implementation=20=20
>> >
>> > From wireless point of view: if I see wext mentioned anywhere in the
>> > driver I stop right there. cfg80211 is a hard requirement for us
>> > nowadays.=20=20
>>=20
>> Clarification: Depending on the hardware design either cfg80211 or
>> mac80211 is a hard requirement. I haven't checked wilc1000 at all so I
>> don't know what design it has but if it's a "softmac" design then it
>> has to use mac80211, we do not want to support multiple 802.11 UMAC
>> stacks.
>>=20
>
> The TODO item to make use of wext-core is obsolete. Previously wilc1000
> driver also had few wext ioctl use but now it=E2=80=99s completely remove=
d and
> cfg80211 operation callbacks are used.
>
> wilc1000 driver make use of cfg80211 and isn=E2=80=99t a "softmac".

Good.

> We need help to review and identify if there are any pending items
> for wilc1000 driver, so we can address those issues and make it ready
> to move to the wireless subsystem.

I think the best way to get that forward is to submit a patch (or
patchset) to linux-wireless, that's the easiest for reviewers.

--=20
Kalle Valo
