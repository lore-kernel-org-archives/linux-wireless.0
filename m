Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.75]:50520 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbcBYU6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2016 15:58:36 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-arm-kernel@lists.infradead.org, Michael Buesch <m@bues.ch>,
	linux-wireless@vger.kernel.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH, RESEND] ssb: host_soc depends on sprom
Date: Thu, 25 Feb 2016 21:57:43 +0100
Message-Id: <1456433869-3919332-1-git-send-email-arnd@arndb.de> (sfid-20160225_215840_288759_94F846FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers that use the SSB sprom functionality typically 'select SSB_SPROM'
from Kconfig, but CONFIG_SSB_HOST_SOC misses this, which results in
a build failure unless at least one of the other drivers that selects
it is enabled:

drivers/built-in.o: In function `ssb_host_soc_get_invariants':
(.text+0x459494): undefined reference to `ssb_fill_sprom_with_fallback'

This adds the same select statement that is used elsewhere.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 541c9a84cd85 ("ssb: pick SoC invariants code from MIPS BCM47xx arch")
---
 drivers/ssb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

I just noticed this hasn't shown up in linux-next yet, so I'm resending
it to ensure it's still on someone's radar. Please ignore the resend
if it's already in a tree that is not part of linux-next but will
be merged eventually.

See https://patchwork.linux-mips.org/patch/12091/ for the original
submission.

diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 0c675861623f..d8e4219c2324 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -83,6 +83,7 @@ config SSB_SDIOHOST
 config SSB_HOST_SOC
 	bool "Support for SSB bus on SoC"
 	depends on SSB && BCM47XX_NVRAM
+	select SSB_SPROM
 	help
 	  Host interface for a SSB directly mapped into memory. This is
 	  for some Broadcom SoCs from the BCM47xx and BCM53xx lines.
-- 
2.7.0

