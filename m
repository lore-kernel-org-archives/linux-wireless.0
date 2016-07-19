Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34212 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbcGSSRS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 14:17:18 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mtd: add arch dependency for MTD_BCM47XXSFLASH symbol
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468912123-14899-1-git-send-email-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Brian Norris <computersforpeace@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	linux-mtd@lists.infradead.org (open list:MEMORY TECHNOLOGY DEVICES
	(MTD)), linux-kernel@vger.kernel.org (open list)
Message-Id: <20160719181717.DFF5161267@smtp.codeaurora.org> (sfid-20160719_201737_867612_DE755A17)
Date: Tue, 19 Jul 2016 18:17:17 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:
> We dropped strict MIPS dependency for bcm47xxsflash driver in:
> commit 5651d6aaf489 ("mtd: bcm47xxsflash: use ioremap_cache() instead of
> KSEG0ADDR()") but using ioremap_cache still limits building it to few
> selected architectures only.
> 
> A recent commit 57d8f7dd2132 ("bcma: allow enabling serial flash support
> on non-MIPS SoCs") automatically dropped MIPS dependency for
> MTD_BCM47XXSFLASH which broke building e.g. on powerpc and cris.
> 
> The bcma change is alright as it doesn't break building bcma code in any
> way. MTD_BCM47XXSFLASH on the other hand should be limited to archs
> which need it and can build it (by providing ioremap_cache).
> 
> Fixes: 57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: Brian Norris <computersforpeace@gmail.com>
> Acked-by: Brian Norris <computersforpeace@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

efacc699139e mtd: add arch dependency for MTD_BCM47XXSFLASH symbol

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9236053/

