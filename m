Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52233 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112Ab1F2WMr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 18:12:47 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	linux-mips@linux-mips.org
Cc: mb@bu3sch.de, george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [RFC v3 13/13] bcm47xx: fix irq assignment for new SoCs.
Date: Thu, 30 Jun 2011 00:11:58 +0200
Message-Id: <1309385518-12097-14-git-send-email-hauke@hauke-m.de> (sfid-20110630_001249_706638_49B748F3)
In-Reply-To: <1309385518-12097-1-git-send-email-hauke@hauke-m.de>
References: <1309385518-12097-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 arch/mips/bcm47xx/irq.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/mips/bcm47xx/irq.c b/arch/mips/bcm47xx/irq.c
index 325757a..70bdcf0 100644
--- a/arch/mips/bcm47xx/irq.c
+++ b/arch/mips/bcm47xx/irq.c
@@ -26,6 +26,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <asm/irq_cpu.h>
+#include <bcm47xx.h>
 
 void plat_irq_dispatch(void)
 {
@@ -51,5 +52,16 @@ void plat_irq_dispatch(void)
 
 void __init arch_init_irq(void)
 {
+#ifdef CONFIG_BCM47XX_BCMA
+	if (bcm47xx_active_bus_type == BCM47XX_BUS_TYPE_BCMA) {
+		bcma_write32(bcm47xx_bus.bcma.bus.drv_mips.core,
+			     BCMA_MIPS_MIPS74K_INTMASK(5), 1 << 31);
+		/*
+		 * the kernel reads the timer irq from some register and thinks
+		 * it's #5, but we offset it by 2 and route to #7
+		 */
+		cp0_compare_irq = 7;
+	}
+#endif
 	mips_cpu_irq_init();
 }
-- 
1.7.4.1

