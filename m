Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:37568 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754103Ab1HWV5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 17:57:01 -0400
Date: Tue, 23 Aug 2011 14:56:59 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: driverdevel <devel@driverdev.osuosl.org>,
	linux-wireless@vger.kernel.org
Cc: gregkh@suse.de, Arend van Spriel <arend@broadcom.com>
Subject: [PATCH] staging: brcmsmac, fix build for SMP disabled
Message-Id: <20110823145659.a22e1860.rdunlap@xenotime.net> (sfid-20110823_235704_960097_919DB354)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build when CONFIG_SMP is not enabled.
Fixes many build errors (subset listed here):

drivers/staging/brcm80211/brcmsmac/ampdu.c: In function 'brcms_c_ampdu_dotxstatus':
drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readb'
drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readw'
drivers/staging/brcm80211/brcmsmac/ampdu.c:833: error: implicit declaration of function 'readl'
drivers/staging/brcm80211/brcmsmac/main.c: In function 'brcms_c_init':
drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writeb'
drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writew'
drivers/staging/brcm80211/brcmsmac/main.c:494: error: implicit declaration of function 'writel'
drivers/staging/brcm80211/brcmsmac/main.c:529: error: implicit declaration of function 'readb'
drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c: In function 'wlc_radioreg_exit':
drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c:208: error: implicit declaration of function 'readb'
drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c:208: error: implicit declaration of function 'readw'
drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c: In function 'wlc_lcnphy_idle_tssi_est':
drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c:2080: error: implicit declaration of function 'readb'
drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c: In function 'wlc_lcnphy_samp_cap':
drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c:3837: error: implicit declaration of function 'writeb'
vers/staging/brcm80211/brcmsmac/phy/phy_n.c: In function 'wlc_phy_init_nphy':
drivers/staging/brcm80211/brcmsmac/phy/phy_n.c:14561: error: implicit declaration of function 'readb'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/brcm80211/brcmsmac/types.h |    1 +
 1 file changed, 1 insertion(+)

--- lnx-31-rc3.orig/drivers/staging/brcm80211/brcmsmac/types.h
+++ lnx-31-rc3/drivers/staging/brcm80211/brcmsmac/types.h
@@ -18,6 +18,7 @@
 #define _BRCM_TYPES_H_
 
 #include <linux/types.h>
+#include <asm/io.h>
 
 /* Bus types */
 #define	SI_BUS			0	/* SOC Interconnect */
