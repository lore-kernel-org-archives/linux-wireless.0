Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:33187 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbJYScz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 14:32:55 -0400
Received: by lffv3 with SMTP id v3so126605489lff.0
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2015 11:32:54 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Michael=20B=C3=BCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] ssb: add Kconfig entry for compiling SoC related code
Date: Sun, 25 Oct 2015 19:32:43 +0100
Message-Id: <1445797963-5968-2-git-send-email-zajec5@gmail.com> (sfid-20151025_193325_975410_BC3CABCC)
In-Reply-To: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
References: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows saving a little of space when not using ssb on Broadcom SoC.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 arch/mips/bcm47xx/Kconfig | 1 +
 drivers/ssb/Kconfig       | 9 +++++++++
 drivers/ssb/Makefile      | 2 +-
 drivers/ssb/main.c        | 2 ++
 drivers/ssb/ssb_private.h | 2 ++
 5 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/mips/bcm47xx/Kconfig b/arch/mips/bcm47xx/Kconfig
index 51ed599..e970fd9 100644
--- a/arch/mips/bcm47xx/Kconfig
+++ b/arch/mips/bcm47xx/Kconfig
@@ -4,6 +4,7 @@ config BCM47XX_SSB
 	bool "SSB Support for Broadcom BCM47XX"
 	select SYS_HAS_CPU_BMIPS32_3300
 	select SSB
+	select SSB_HOST_SOC
 	select SSB_DRIVER_MIPS
 	select SSB_DRIVER_EXTIF
 	select SSB_EMBEDDED
diff --git a/drivers/ssb/Kconfig b/drivers/ssb/Kconfig
index f0d22cd..149214b 100644
--- a/drivers/ssb/Kconfig
+++ b/drivers/ssb/Kconfig
@@ -80,6 +80,15 @@ config SSB_SDIOHOST
 
 	  If unsure, say N
 
+config SSB_HOST_SOC
+	bool "Support for SSB bus on SoC"
+	depends on SSB
+	help
+	  Host interface for a SSB directly mapped into memory. This is
+	  for some Broadcom SoCs from the BCM47xx and BCM53xx lines.
+
+	  If unsure, say N
+
 config SSB_SILENT
 	bool "No SSB kernel messages"
 	depends on SSB && EXPERT
diff --git a/drivers/ssb/Makefile b/drivers/ssb/Makefile
index 30194c5..64a0968 100644
--- a/drivers/ssb/Makefile
+++ b/drivers/ssb/Makefile
@@ -7,7 +7,7 @@ ssb-$(CONFIG_SSB_SPROM)			+= sprom.o
 ssb-$(CONFIG_SSB_PCIHOST)		+= pci.o pcihost_wrapper.o
 ssb-$(CONFIG_SSB_PCMCIAHOST)		+= pcmcia.o bridge_pcmcia_80211.o
 ssb-$(CONFIG_SSB_SDIOHOST)		+= sdio.o
-ssb-y					+= host_soc.o
+ssb-$(CONFIG_SSB_HOST_SOC)		+= host_soc.o
 
 # built-in drivers
 ssb-y					+= driver_chipcommon.o
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index bea823e..5d1e9a0 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -761,6 +761,7 @@ int ssb_bus_sdiobus_register(struct ssb_bus *bus, struct sdio_func *func,
 EXPORT_SYMBOL(ssb_bus_sdiobus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
+#ifdef CONFIG_SSB_HOST_SOC
 int ssb_bus_ssbbus_register(struct ssb_bus *bus, unsigned long baseaddr,
 			    ssb_invariants_func_t get_invariants)
 {
@@ -777,6 +778,7 @@ int ssb_bus_ssbbus_register(struct ssb_bus *bus, unsigned long baseaddr,
 
 	return err;
 }
+#endif
 
 int __ssb_driver_register(struct ssb_driver *drv, struct module *owner)
 {
diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index 0a756c2..15bfd5c 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -161,7 +161,9 @@ static inline int ssb_sdio_init(struct ssb_bus *bus)
  * host_soc.c
  **************************************************/
 
+#ifdef CONFIG_SSB_HOST_SOC
 extern const struct ssb_bus_ops ssb_host_soc_ops;
+#endif
 
 /* scan.c */
 extern const char *ssb_core_name(u16 coreid);
-- 
1.8.4.5

