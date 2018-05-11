Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35889 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750852AbeEKKZg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 06:25:36 -0400
MIME-Version: 1.0
In-Reply-To: <87bmdmcxf6.fsf@codeaurora.org>
References: <20180511091715.1989-1-zajec5@gmail.com> <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
 <87bmdmcxf6.fsf@codeaurora.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 11 May 2018 12:25:33 +0200
Message-ID: <CACna6rxY16UzVPpMy+kKpun8ZVY+b5THBuCjvCG9tF0t9hcNBA@mail.gmail.com> (sfid-20180511_122547_268065_23985671)
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in module"
To: Kalle Valo <kvalo@codeaurora.org>
Cc: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 May 2018 at 12:13, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>
>> On 11 May 2018 at 11:17, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrot=
e:
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
>>>
>>> Above commit added "SSB =3D y" dependency to the wrong symbol
>>> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
>>> selected when needed. PCI core driver for core running in clienthost
>>> mode is important for bus initialization. It's perfectly valid scenario
>>> to have ssb built as module and use it with buses on PCI cards.
>>>
>>> This fixes regression that affected all *module* users with PCI cards.
>>>
>>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349
>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> As these patches fix regression/build error, I believe both should get
>> into 4.17.
>
> How much confidence do we have that we don't need to end up reverting
> patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
> more time for testing and waiting for feedback.

Solution from 2/2 seems pretty obvious.

1) Enabling SSB_PCICORE_HOSTMODE compiles code that requires
non-exported symbols. Requiring "SSB =3D y" seems pretty obvious.
2) As pointed in another e-mail bcma has pretty identical solution
that seems to be working well, see commit 79ca239a68f8f ("bcma:
Prevent build of PCI host features in module").

That's just my opinion though, I shared since you asked.

If you prefer to queue that for 4.18, I'm OK. After all:
1) This problem affects MIPS arch only
2) It can be fixed by not selecting BCMA_DRIVER_PCI_HOSTMODE for SSB =3D m

--=20
Rafa=C5=82
