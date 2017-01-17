Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdAQMYW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 07:24:22 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.10, fix,
 V2] Revert "bcma: init serial console directly from ChipCommon code"
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170113112335.23730-1-zajec5@gmail.com>
References: <20170113112335.23730-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20170117122421.4DDCC607C9@smtp.codeaurora.org> (sfid-20170117_132425_584188_600EE50A)
Date: Tue, 17 Jan 2017 12:24:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> This reverts commit 4c81acab3816 ("bcma: init serial console directly
> from ChipCommon code") as it broke IRQ assignment. Getting IRQ with
> bcma_core_irq helper on SoC requires MIPS core to be set. It happens
> *after* ChipCommon initialization so we can't do this so early.
> 
> This fixes a user reported regression. It wasn't critical as serial was
> still somehow working but lack of IRQs was making in unreliable.
> 
> Fixes: 4c81acab3816 ("bcma: init serial console directly from ChipCommon code")
> Reported-by: Felix Fietkau <nbd@nbd.name>
> Cc: stable@vger.kernel.org # 4.6+
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Patch applied to wireless-drivers.git, thanks.

7195439d1d71 Revert "bcma: init serial console directly from ChipCommon code"

-- 
https://patchwork.kernel.org/patch/9515267/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
