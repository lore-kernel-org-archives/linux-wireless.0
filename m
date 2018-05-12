Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52676 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750974AbeELHut (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 03:50:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in module"
References: <20180511091715.1989-1-zajec5@gmail.com>
        <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
        <87bmdmcxf6.fsf@codeaurora.org>
        <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net>
Date: Sat, 12 May 2018 10:50:42 +0300
In-Reply-To: <727571cb-5d1f-2d99-b050-979edd02106f@lwfinger.net> (Larry
        Finger's message of "Fri, 11 May 2018 07:08:48 -0500")
Message-ID: <877eo9b9d9.fsf@codeaurora.org> (sfid-20180512_095108_760523_F38016FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

> On 05/11/2018 05:13 AM, Kalle Valo wrote:
>> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>>
>>> On 11 May 2018 at 11:17, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wro=
te:
>>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>>
>>>> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
>>>>
>>>> Above commit added "SSB =3D y" dependency to the wrong symbol
>>>> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
>>>> selected when needed. PCI core driver for core running in clienthost
>>>> mode is important for bus initialization. It's perfectly valid scenario
>>>> to have ssb built as module and use it with buses on PCI cards.
>>>>
>>>> This fixes regression that affected all *module* users with PCI cards.
>>>>
>>>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349
>>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> As these patches fix regression/build error, I believe both should get
>>> into 4.17.
>>
>> How much confidence do we have that we don't need to end up reverting
>> patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
>> more time for testing and waiting for feedback.
>
> Although I do not have the hardware to test the builds, I worked
> closely with the OP in the bug at b.r.c noted above. From that effort,
> it became clear what configuration variables were missing to cause the
> x86 failures. Patch 2 satisfies the requirement, and prevents the
> build problems found by the MIPS users. Both patches are needed in
> 4.17.

And I assume Michael is ok with this approach as well as I haven't heard
from him. I'll then push both of these to 4.17.

--=20
Kalle Valo
