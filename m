Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37618 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752639AbeEKKNj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 06:13:39 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
        Larry Finger <larry.finger@lwfinger.net>,
        Matt Redfearn <matt.redfearn@mips.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH V2 1/2] Revert "ssb: Prevent build of PCI host features in module"
References: <20180511091715.1989-1-zajec5@gmail.com>
        <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
Date: Fri, 11 May 2018 13:13:33 +0300
In-Reply-To: <CACna6ry-91oR1u697NRymLsN28fnnHDp9OQrdiVwA7A3KTV1fg@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 11 May 2018
 11:21:11 +0200")
Message-ID: <87bmdmcxf6.fsf@codeaurora.org> (sfid-20180511_121352_234494_4907E020)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 11 May 2018 at 11:17, Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This reverts commit 882164a4a928bcaa53280940436ca476e6b1db8e.
>>
>> Above commit added "SSB =3D y" dependency to the wrong symbol
>> SSB_DRIVER_PCICORE_POSSIBLE and prevented SSB_DRIVER_PCICORE from being
>> selected when needed. PCI core driver for core running in clienthost
>> mode is important for bus initialization. It's perfectly valid scenario
>> to have ssb built as module and use it with buses on PCI cards.
>>
>> This fixes regression that affected all *module* users with PCI cards.
>>
>> Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=3D1572349
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> As these patches fix regression/build error, I believe both should get
> into 4.17.

How much confidence do we have that we don't need to end up reverting
patch 2 as well? I rather be pushing patch 2 to 4.18 so that there's
more time for testing and waiting for feedback.

--=20
Kalle Valo
