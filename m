Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50621 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbcGSGaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 02:30:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: <linux-wireless@vger.kernel.org>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: linux-next: build failure after merge of the wireless-drivers-next tree
References: <20160719160831.79c0303f@canb.auug.org.au>
Date: Tue, 19 Jul 2016 09:30:06 +0300
In-Reply-To: <20160719160831.79c0303f@canb.auug.org.au> (Stephen Rothwell's
	message of "Tue, 19 Jul 2016 16:08:31 +1000")
Message-ID: <8760s2w369.fsf@kamboji.qca.qualcomm.com> (sfid-20160719_083053_123867_E517C478)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-drivers-next tree, today's linux-next build
> (powerpc allyesconfig) failed like this:
>
> drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_bcma_probe':
> drivers/mtd/devices/bcm47xxsflash.c:299:17: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
>   b47s->window = ioremap_cache(res->start, resource_size(res));
>                  ^
> drivers/mtd/devices/bcm47xxsflash.c:299:15: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
>   b47s->window = ioremap_cache(res->start, resource_size(res));
>                ^
>
> Caused by commit
>
>   57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")
>
> I have reverted that commit for today.

Thanks, kbuild bot also notified about this.

Rafał, as the merge window is getting really close I would like to
revert this for now and we can reapply it once we the problem is fully
solved. And we can use my pending branch for build testing the patch
with kbuild bot. What do you think?

-- 
Kalle Valo
