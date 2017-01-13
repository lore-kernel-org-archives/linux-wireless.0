Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37822 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751356AbdAMKmJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:42:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] Revert "bcma: init serial console directly from ChipCommon code"
References: <20170112174451.7124-1-zajec5@gmail.com>
        <87fuknl0x9.fsf@codeaurora.org>
        <CACna6rwupQ68meKJNRLcHdXEg+sQXvP5mH-C4fqofNQg0Y2hTQ@mail.gmail.com>
Date: Fri, 13 Jan 2017 12:42:05 +0200
In-Reply-To: <CACna6rwupQ68meKJNRLcHdXEg+sQXvP5mH-C4fqofNQg0Y2hTQ@mail.gmail.com>
        (=?utf-8?Q?=22Rafa=C5=82_Mi=C5=82ecki=22's?= message of "Fri, 13 Jan 2017
 11:23:48 +0100")
Message-ID: <878tqfkzr6.fsf@codeaurora.org> (sfid-20170113_114212_941767_C776DB96)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> On 13 January 2017 at 11:16, Kalle Valo <kvalo@codeaurora.org> wrote:
>> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>>
>>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>>
>>> This reverts commit 4c81acab3816 ("bcma: init serial console directly
>>> from ChipCommon code") as it broke IRQ assignment. Getting IRQ with
>>> bcma_core_irq helper on SoC requires MIPS core to be set. It happens
>>> *after* ChipCommon initialization so we can't do this so early.
>>>
>>> This fixes a regression but it seems noone noticed it for about a year.
>>> It could be it was because serial was still somehow working, just
>>> without IRQs. It doesn't look like a critical patch / fix.
>>>
>>> Reported-by: Felix Fietkau <nbd@nbd.name>
>>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> So this is for 4.11? What about CC stable?
>>
>> I'll add a Fixes line:
>>
>> Fixes: 4c81acab3816 ("bcma: init serial console directly from ChipCommon=
 code")
>
> After hearing about policy for fixes getting more strict, I thought we
> can get it for next only.

As this is a user reported regression it would qualify for 4.10, but on
the other hand quite old regression so can easily wait for 4.11 as well.
Up to you really.

But I would like to add CC stable so that this gets backported to older
releases. Is that ok?

> Thanks for "Fixes:", I wasn't sure if we need that for reverts.

If you are fixing a regression it's always a good idea to add the Fixes
line. Makes it easier to backport the fix.

--=20
Kalle Valo
