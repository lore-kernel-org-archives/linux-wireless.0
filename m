Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47279 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab2LERqu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:46:50 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, wim@iguana.be
Cc: linux-wireless@vger.kernel.org, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v3 01/11] ssb/bcma: add common header for watchdog
Date: Wed,  5 Dec 2012 18:45:58 +0100
Message-Id: <1354729568-19993-2-git-send-email-hauke@hauke-m.de> (sfid-20121205_184654_624089_1244185B)
In-Reply-To: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
References: <1354729568-19993-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a common header for watchdog functions, so a watchdog driver
just needs to use this and could provide watchdog functionality for ssb
and bcma based SoCs. Patches for a watchdog driver using this interface
will be send later.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/bcm47xx_wdt.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
 create mode 100644 include/linux/bcm47xx_wdt.h

diff --git a/include/linux/bcm47xx_wdt.h b/include/linux/bcm47xx_wdt.h
new file mode 100644
index 0000000..e5dfc25
--- /dev/null
+++ b/include/linux/bcm47xx_wdt.h
@@ -0,0 +1,19 @@
+#ifndef LINUX_BCM47XX_WDT_H_
+#define LINUX_BCM47XX_WDT_H_
+
+#include <linux/types.h>
+
+
+struct bcm47xx_wdt {
+	u32 (*timer_set)(struct bcm47xx_wdt *, u32);
+	u32 (*timer_set_ms)(struct bcm47xx_wdt *, u32);
+	u32 max_timer_ms;
+
+	void *driver_data;
+};
+
+static inline void *bcm47xx_wdt_get_drvdata(struct bcm47xx_wdt *wdt)
+{
+	return wdt->driver_data;
+}
+#endif /* LINUX_BCM47XX_WDT_H_ */
-- 
1.7.10.4

