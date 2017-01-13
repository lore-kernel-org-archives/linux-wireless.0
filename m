Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:33750 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdAMKXu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:23:50 -0500
Received: by mail-ot0-f196.google.com with SMTP id f9so998345otd.0
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 02:23:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87fuknl0x9.fsf@codeaurora.org>
References: <20170112174451.7124-1-zajec5@gmail.com> <87fuknl0x9.fsf@codeaurora.org>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Fri, 13 Jan 2017 11:23:48 +0100
Message-ID: <CACna6rwupQ68meKJNRLcHdXEg+sQXvP5mH-C4fqofNQg0Y2hTQ@mail.gmail.com> (sfid-20170113_112353_751159_9D45F2BE)
Subject: Re: [PATCH] Revert "bcma: init serial console directly from
 ChipCommon code"
To: Kalle Valo <kvalo@codeaurora.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 January 2017 at 11:16, Kalle Valo <kvalo@codeaurora.org> wrote:
> Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:
>
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> This reverts commit 4c81acab3816 ("bcma: init serial console directly
>> from ChipCommon code") as it broke IRQ assignment. Getting IRQ with
>> bcma_core_irq helper on SoC requires MIPS core to be set. It happens
>> *after* ChipCommon initialization so we can't do this so early.
>>
>> This fixes a regression but it seems noone noticed it for about a year.
>> It could be it was because serial was still somehow working, just
>> without IRQs. It doesn't look like a critical patch / fix.
>>
>> Reported-by: Felix Fietkau <nbd@nbd.name>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> So this is for 4.11? What about CC stable?
>
> I'll add a Fixes line:
>
> Fixes: 4c81acab3816 ("bcma: init serial console directly from ChipCommon =
code")

After hearing about policy for fixes getting more strict, I thought we
can get it for next only.

Thanks for "Fixes:", I wasn't sure if we need that for reverts.

--=20
Rafa=C5=82
