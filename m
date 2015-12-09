Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:33883 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbbLIWhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2015 17:37:03 -0500
Received: by lffu14 with SMTP id u14so44849820lff.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2015 14:37:01 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: pick SoC invariants code from MIPS BCM47xx arch
Date: Wed,  9 Dec 2015 23:36:51 +0100
Message-Id: <1449700611-6952-1-git-send-email-zajec5@gmail.com> (sfid-20151209_233711_763765_D8E45CAA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is code in ssb fetching "invariants" that is basically a set of
board specific data. Every host requires its own implementation of
reading function. In ssb we have support for PCI, PCMCIA & SDIO.
For some (historical?) reason code reading "invariants" for SoC was
placed in arch code and provided by a callback. This is not needed
nowadays, so lets move that into ssb. This way we keep all "invariants"
functions in a single module making code cleaner.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 arch/mips/bcm47xx/setup.c | 39 +--------------------------------------
 drivers/ssb/Kconfig       |  2 +-
 drivers/ssb/host_soc.c    | 37 +++++++++++++++++++++++++++++++++++++
 drivers/ssb/main.c        |  5 ++---
 drivers/ssb/ssb_private.h |  3 +++
 include/linux/ssb/ssb.h   | 10 +++-------
 6 files changed, 47 insertions(+), 49 deletions(-)

diff --git a/arch/mips/bcm47xx/setup.c b/arch/mips/bcm47xx/setup.c
index 6d38948..c807e32 100644
--- a/arch/mips/bcm47xx/setup.c
+++ b/arch/mips/bcm47xx/setup.c
@@ -101,50 +101,13 @@ static void bcm47xx_machine_halt(void)
 }
 
 #ifdef CONFIG_BCM47XX_SSB
-static int bcm47xx_get_invariants(struct ssb_bus *bus,
-				  struct ssb_init_invariants *iv)
-{
-	char buf[20];
-	int len, err;
-
-	/* Fill boardinfo structure */
-	memset(&iv->boardinfo, 0 , sizeof(struct ssb_boardinfo));
-
-	len = bcm47xx_nvram_getenv("boardvendor", buf, sizeof(buf));
-	if (len > 0) {
-		err = kstrtou16(strim(buf), 0, &iv->boardinfo.vendor);
-		if (err)
-			pr_warn("Couldn't parse nvram board vendor entry with value \"%s\"\n",
-				buf);
-	}
-	if (!iv->boardinfo.vendor)
-		iv->boardinfo.vendor = SSB_BOARDVENDOR_BCM;
-
-	len = bcm47xx_nvram_getenv("boardtype", buf, sizeof(buf));
-	if (len > 0) {
-		err = kstrtou16(strim(buf), 0, &iv->boardinfo.type);
-		if (err)
-			pr_warn("Couldn't parse nvram board type entry with value \"%s\"\n",
-				buf);
-	}
-
-	memset(&iv->sprom, 0, sizeof(struct ssb_sprom));
-	bcm47xx_fill_sprom(&iv->sprom, NULL, false);
-
-	if (bcm47xx_nvram_getenv("cardbus", buf, sizeof(buf)) >= 0)
-		iv->has_cardbus_slot = !!simple_strtoul(buf, NULL, 10);
-
-	return 0;
-}
-
 static void __init bcm47xx_register_ssb(void)
 {
 	int err;
 	char buf[100];
 	struct ssb_mipscore *mcore;
 
-	err = ssb_bus_ssbbus_register(&bcm47xx_bus.ssb, SSB_ENUM_BASE,
-				      bcm47xx_get_invariants);
+	err = ssb_bus_host_soc_register(&bcm47xx_bus.ssb, SSB_ENUM_BASE);
 	if (err)
 		panic("Failed to initialize SSB bus (err %d)", err);
 
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index 149214b..0c67586 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -82,7 +82,7 @@ config SSB_SDIOHOST
 
 config SSB_HOST_SOC
 	bool "Support for SSB bus on SoC"
-	depends on SSB
+	depends on SSB && BCM47XX_NVRAM
 	help
 	  Host interface for a SSB directly mapped into memory. This is
 	  for some Broadcom SoCs from the BCM47xx and BCM53xx lines.
diff --git a/drivers/ssb/host_soc.c b/drivers/ssb/host_soc.c
index c809f25..d62992d 100644
--- a/drivers/ssb/host_soc.c
+++ b/drivers/ssb/host_soc.c
@@ -8,6 +8,7 @@
  * Licensed under the GNU/GPL. See COPYING for details.
  */
 
+#include <linux/bcm47xx_nvram.h>
 #include <linux/ssb/ssb.h>
 
 #include "ssb_private.h"
@@ -171,3 +172,39 @@ const struct ssb_bus_ops ssb_host_soc_ops = {
 	.block_write	= ssb_host_soc_block_write,
 #endif
 };
+
+int ssb_host_soc_get_invariants(struct ssb_bus *bus,
+				struct ssb_init_invariants *iv)
+{
+	char buf[20];
+	int len, err;
+
+	/* Fill boardinfo structure */
+	memset(&iv->boardinfo, 0, sizeof(struct ssb_boardinfo));
+
+	len = bcm47xx_nvram_getenv("boardvendor", buf, sizeof(buf));
+	if (len > 0) {
+		err = kstrtou16(strim(buf), 0, &iv->boardinfo.vendor);
+		if (err)
+			pr_warn("Couldn't parse nvram board vendor entry with value \"%s\"\n",
+				buf);
+	}
+	if (!iv->boardinfo.vendor)
+		iv->boardinfo.vendor = SSB_BOARDVENDOR_BCM;
+
+	len = bcm47xx_nvram_getenv("boardtype", buf, sizeof(buf));
+	if (len > 0) {
+		err = kstrtou16(strim(buf), 0, &iv->boardinfo.type);
+		if (err)
+			pr_warn("Couldn't parse nvram board type entry with value \"%s\"\n",
+				buf);
+	}
+
+	memset(&iv->sprom, 0, sizeof(struct ssb_sprom));
+	ssb_fill_sprom_with_fallback(bus, &iv->sprom);
+
+	if (bcm47xx_nvram_getenv("cardbus", buf, sizeof(buf)) >= 0)
+		iv->has_cardbus_slot = !!simple_strtoul(buf, NULL, 10);
+
+	return 0;
+}
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index 5d1e9a0..cde5ff7 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -762,15 +762,14 @@ EXPORT_SYMBOL(ssb_bus_sdiobus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
 #ifdef CONFIG_SSB_HOST_SOC
-int ssb_bus_ssbbus_register(struct ssb_bus *bus, unsigned long baseaddr,
-			    ssb_invariants_func_t get_invariants)
+int ssb_bus_host_soc_register(struct ssb_bus *bus, unsigned long baseaddr)
 {
 	int err;
 
 	bus->bustype = SSB_BUSTYPE_SSB;
 	bus->ops = &ssb_host_soc_ops;
 
-	err = ssb_bus_register(bus, get_invariants, baseaddr);
+	err = ssb_bus_register(bus, ssb_host_soc_get_invariants, baseaddr);
 	if (!err) {
 		ssb_info("Sonics Silicon Backplane found at address 0x%08lX\n",
 			 baseaddr);
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 15bfd5c..c2f5d39 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -163,6 +163,9 @@ static inline int ssb_sdio_init(struct ssb_bus *bus)
 
 #ifdef CONFIG_SSB_HOST_SOC
 extern const struct ssb_bus_ops ssb_host_soc_ops;
+
+extern int ssb_host_soc_get_invariants(struct ssb_bus *bus,
+				       struct ssb_init_invariants *iv);
 #endif
 
 /* scan.c */
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index c3d1a52..26a0b3c 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -524,13 +524,9 @@ struct ssb_init_invariants {
 typedef int (*ssb_invariants_func_t)(struct ssb_bus *bus,
 				     struct ssb_init_invariants *iv);
 
-/* Register a SSB system bus. get_invariants() is called after the
- * basic system devices are initialized.
- * The invariants are usually fetched from some NVRAM.
- * Put the invariants into the struct pointed to by iv. */
-extern int ssb_bus_ssbbus_register(struct ssb_bus *bus,
-				   unsigned long baseaddr,
-				   ssb_invariants_func_t get_invariants);
+/* Register SoC bus. */
+extern int ssb_bus_host_soc_register(struct ssb_bus *bus,
+				     unsigned long baseaddr);
 #ifdef CONFIG_SSB_PCIHOST
 extern int ssb_bus_pcibus_register(struct ssb_bus *bus,
 				   struct pci_dev *host_pci);
-- 
1.8.4.5

