Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35031 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbbLaISF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:18:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] bcma: use module_init for the main part of bus initialization
References: <1450382034-3976-1-git-send-email-zajec5@gmail.com>
Date: Thu, 31 Dec 2015 10:17:56 +0200
In-Reply-To: <1450382034-3976-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Thu, 17 Dec 2015
 20:53:54 +0100")
Message-ID: <87vb7fnia3.fsf@kamboji.qca.qualcomm.com> (sfid-20151231_091810_382919_E8AF84F9)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> So far we were using fs_initcall. It was (and still is) needed because
> struct bus_type has to be registered early. However main bus
> initialization has to happen later as it requires SPROM which depends on
> NVRAM which depends on mtd.
> Solve it by using fs_initcall only for bus_register call and module_init
> for the rest. It affects bcma only when built-in obviously.
>
> This was tested with BCM4706 and BCM5357C0 (BCM47XX), BCM4708A0
> (ARCH_BCM_5301X) and BCM43225 (PCIe card with bcma as module).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> This change was already suggested in RFC patch early this year:
> https://patchwork.kernel.org/patch/5802611/
>
> Noone objected / got any better idea, so I'm sending a final version.
>
> V1 (from RFC):
> * Use int bcma_bus_registered to avoid #ifdef MODULE and make code simpler.
> * Document reason for this behavior better.

Applied manually, thanks.

-- 
Kalle Valo
