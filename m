Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1453 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab2FUJdu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 05:33:50 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] brcmfmac: make inclusion of vmalloc.h explicit fixing
 linux-next build
Date: Thu, 21 Jun 2012 11:33:32 +0200
Message-ID: <1340271212-12860-1-git-send-email-arend@broadcom.com> (sfid-20120621_113353_677121_5F188610)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes problem detected in linux-next build for powerpc
allyesconfig. The error message below is no longer observed:

  CC      drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.o
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c: In function 'brcmf_sdio_dump_console':
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085: error: implicit declaration of function 'vzalloc'
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3085: warning: assignment makes pointer from integer without a cast
drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c:3113: error: implicit declaration of function 'vfree'
make[2]: *** [drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.o] Error 1

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 9971e13..076b772 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/bcma/bcma.h>
 #include <linux/debugfs.h>
+#include <linux/vmalloc.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
-- 
1.7.9.5


