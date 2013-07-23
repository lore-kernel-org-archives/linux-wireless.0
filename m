Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58327 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589Ab3GWCpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 22:45:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] Make BCMA_HOST_SOC depend on BCM47XX
Date: Mon, 22 Jul 2013 22:31:15 -0400
Message-Id: <1374546675-384-1-git-send-email-linville@tuxdriver.com> (sfid-20130723_044517_701469_F7961658)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>

Otherwise, 'make allyesconfig' generates this:

  CC [M]  drivers/net/ethernet/broadcom/bgmac.o
drivers/net/ethernet/broadcom/bgmac.c:19:27: fatal error:
bcm47xx_nvram.h: No such file or directory
compilation terminated.
make[4]: *** [drivers/net/ethernet/broadcom/bgmac.o] Error 1
make[3]: *** [drivers/net/ethernet/broadcom] Error 2
make[2]: *** [drivers/net/ethernet] Error 2
make[1]: *** [drivers/net] Error 2
make: *** [drivers] Error 2

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/bcma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 7c081b3..a2bdab1 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -36,7 +36,7 @@ config BCMA_DRIVER_PCI_HOSTMODE
 
 config BCMA_HOST_SOC
 	bool "Support for BCMA in a SoC"
-	depends on BCMA
+	depends on BCMA && BCM47XX
 	help
 	  Host interface for a Broadcom AIX bus directly mapped into
 	  the memory. This only works with the Broadcom SoCs from the
-- 
1.8.1.4

