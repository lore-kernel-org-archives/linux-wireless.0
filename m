Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdAMK0B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 05:26:01 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH] Revert "bcma: init serial console directly from ChipCommon code"
References: <20170112174451.7124-1-zajec5@gmail.com>
Date: Fri, 13 Jan 2017 12:16:50 +0200
In-Reply-To: <20170112174451.7124-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Thu, 12 Jan 2017 18:44:51 +0100")
Message-ID: <87fuknl0x9.fsf@codeaurora.org> (sfid-20170113_112604_481666_A4FAB8F8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> This reverts commit 4c81acab3816 ("bcma: init serial console directly
> from ChipCommon code") as it broke IRQ assignment. Getting IRQ with
> bcma_core_irq helper on SoC requires MIPS core to be set. It happens
> *after* ChipCommon initialization so we can't do this so early.
>
> This fixes a regression but it seems noone noticed it for about a year.
> It could be it was because serial was still somehow working, just
> without IRQs. It doesn't look like a critical patch / fix.
>
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>

So this is for 4.11? What about CC stable?

I'll add a Fixes line:

Fixes: 4c81acab3816 ("bcma: init serial console directly from ChipCommon co=
de")

--=20
Kalle Valo
