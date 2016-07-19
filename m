Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:45108 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320AbcGSGIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 02:08:34 -0400
Date: Tue, 19 Jul 2016 16:08:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kalle Valo <kvalo@codeaurora.org>, <linux-wireless@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: linux-next: build failure after merge of the wireless-drivers-next
 tree
Message-ID: <20160719160831.79c0303f@canb.auug.org.au> (sfid-20160719_080859_719462_482582D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After merging the wireless-drivers-next tree, today's linux-next build
(powerpc allyesconfig) failed like this:

drivers/mtd/devices/bcm47xxsflash.c: In function 'bcm47xxsflash_bcma_probe':
drivers/mtd/devices/bcm47xxsflash.c:299:17: error: implicit declaration of function 'ioremap_cache' [-Werror=implicit-function-declaration]
  b47s->window = ioremap_cache(res->start, resource_size(res));
                 ^
drivers/mtd/devices/bcm47xxsflash.c:299:15: warning: assignment makes pointer from integer without a cast [-Wint-conversion]
  b47s->window = ioremap_cache(res->start, resource_size(res));
               ^

Caused by commit

  57d8f7dd2132 ("bcma: allow enabling serial flash support on non-MIPS SoCs")

I have reverted that commit for today.

-- 
Cheers,
Stephen Rothwell
