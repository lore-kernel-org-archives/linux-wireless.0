Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750739AbeELIhg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 May 2018 04:37:36 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [4.17] bcma: fix buffer size caused crash in
 bcma_core_mips_print_irq()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180508093104.27018-1-zajec5@gmail.com>
References: <20180508093104.27018-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
        Joe Perches <joe@perches.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Message-Id: <20180512083735.D82496085F@smtp.codeaurora.org> (sfid-20180512_103740_107991_1C74EA72)
Date: Sat, 12 May 2018 08:37:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Used buffer wasn't big enough to hold whole strings. Example output of
> this function is:
> [    0.180892] bcma: bus0: core 0x0800, irq: 2(S)* 3  4  5  6  D  I
> [    0.180948] bcma: bus0: core 0x0812, irq: 2(S)  3* 4  5  6  D  I
> [    0.180998] bcma: bus0: core 0x082d, irq: 2(S)  3  4* 5  6  D  I
> [    0.181046] bcma: bus0: core 0x082c, irq: 2(S)  3  4  5  6  D  I*
> which means we need to store up to 24 chars.
> 
> Fixes: 758f7e06063a8 ("bcma: Use bcma_debug and not pr_cont in MIPS driver")
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Cc: stable@vger.kernel.org # v4.15+

Patch applied to wireless-drivers.git, thanks.

361de091a4b9 bcma: fix buffer size caused crash in bcma_core_mips_print_irq()

-- 
https://patchwork.kernel.org/patch/10385861/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
