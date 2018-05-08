Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47406 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754366AbeEHKGl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 06:06:41 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Joe Perches <joe@perches.com>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: Re: [PATCH 4.17] bcma: fix buffer size caused crash in bcma_core_mips_print_irq()
References: <20180508093104.27018-1-zajec5@gmail.com>
Date: Tue, 08 May 2018 13:06:35 +0300
In-Reply-To: <20180508093104.27018-1-zajec5@gmail.com> (=?utf-8?Q?=22Rafa?=
 =?utf-8?Q?=C5=82_Mi=C5=82ecki=22's?=
        message of "Tue, 8 May 2018 11:31:04 +0200")
Message-ID: <87zi1a1mxg.fsf@kamboji.qca.qualcomm.com> (sfid-20180508_120646_156730_939A06E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> writes:

> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Used buffer wasn't big enough to hold whole strings. Example output of
> this function is:
> [    0.180892] bcma: bus0: core 0x0800, irq: 2(S)* 3  4  5  6  D  I
> [    0.180948] bcma: bus0: core 0x0812, irq: 2(S)  3* 4  5  6  D  I
> [    0.180998] bcma: bus0: core 0x082d, irq: 2(S)  3  4* 5  6  D  I
> [    0.181046] bcma: bus0: core 0x082c, irq: 2(S)  3  4  5  6  D  I*
> which means we need to store up to 24 chars.
>
> Fixes: 758f7e06063a8 ("bcma: Use bcma_debug and not pr_cont in MIPS drive=
r")
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> Cc: stable@vger.kernel.org # v4.15+

I'll queue this for 4.17.

--=20
Kalle Valo
