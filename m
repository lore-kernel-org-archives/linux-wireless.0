Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:39264 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ1XTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 19:19:08 -0400
Received: by mail-la0-f49.google.com with SMTP id ge10so1523912lab.8
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2014 16:19:06 -0700 (PDT)
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Linux MIPS <linux-mips@linux-mips.org>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: [PATCH v3 11/13] ath5k: revert AHB bus support removing
Date: Wed, 29 Oct 2014 03:18:48 +0400
Message-Id: <1414538330-5548-12-git-send-email-ryazanov.s.a@gmail.com> (sfid-20141029_001914_636895_224666D1)
In-Reply-To: <1414538330-5548-1-git-send-email-ryazanov.s.a@gmail.com>
References: <1414538330-5548-1-git-send-email-ryazanov.s.a@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This reverts commit 093ec3c5337434f40d77c1af06c139da3e5ba6dc.

AHB bus code has been removed, since we did not have support Atheros
AR231x SoC, required for building the AHB version of ath5k. Now that
support WiSoC chips added we can restore functionality back.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Acked-by: John W. Linville <linville@tuxdriver.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org
---

Changes since v1:
  - fresh patch

Changes since v2:
  - fix typo in SoB line

 drivers/net/wireless/ath/ath5k/Kconfig  |  14 +-
 drivers/net/wireless/ath/ath5k/Makefile |   1 +
 drivers/net/wireless/ath/ath5k/ahb.c    | 234 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |  28 ++++
 drivers/net/wireless/ath/ath5k/base.c   |  14 ++
 drivers/net/wireless/ath/ath5k/led.c    |   6 +
 6 files changed, 294 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 93caf8e68..c9f81a3 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,12 +1,13 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
-	depends on PCI && MAC80211
+	depends on (PCI || ATHEROS_AR231X) && MAC80211
 	select ATH_COMMON
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
 	select AVERAGE
-	select ATH5K_PCI
+	select ATH5K_AHB if (ATHEROS_AR231X && !PCI)
+	select ATH5K_PCI if (!ATHEROS_AR231X && PCI)
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
@@ -51,9 +52,16 @@ config ATH5K_TRACER
 
 	  If unsure, say N.
 
+config ATH5K_AHB
+	bool "Atheros 5xxx AHB bus support"
+	depends on (ATHEROS_AR231X && !PCI)
+	---help---
+	  This adds support for WiSoC type chipsets of the 5xxx Atheros
+	  family.
+
 config ATH5K_PCI
 	bool "Atheros 5xxx PCI bus support"
-	depends on PCI
+	depends on (!ATHEROS_AR231X && PCI)
 	---help---
 	  This adds support for PCI type chipsets of the 5xxx Atheros
 	  family.
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 51e2d86..1b3a34f 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -17,5 +17,6 @@ ath5k-y				+= ani.o
 ath5k-y				+= sysfs.o
 ath5k-y				+= mac80211-ops.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
+ath5k-$(CONFIG_ATH5K_AHB)	+= ahb.o
 ath5k-$(CONFIG_ATH5K_PCI)	+= pci.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
new file mode 100644
index 0000000..79bffe1
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -0,0 +1,234 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ * Copyright (c) 2009 Gabor Juhos <juhosg@openwrt.org>
+ * Copyright (c) 2009 Imre Kaloz <kaloz@openwrt.org>
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/nl80211.h>
+#include <linux/platform_device.h>
+#include <linux/etherdevice.h>
+#include <linux/export.h>
+#include <ar231x_platform.h>
+#include "ath5k.h"
+#include "debug.h"
+#include "base.h"
+#include "reg.h"
+
+/* return bus cachesize in 4B word units */
+static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
+{
+	*csz = L1_CACHE_BYTES >> 2;
+}
+
+static bool
+ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
+{
+	struct ath5k_hw *ah = common->priv;
+	struct platform_device *pdev = to_platform_device(ah->dev);
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
+	u16 *eeprom, *eeprom_end;
+
+	eeprom = (u16 *) bcfg->radio;
+	eeprom_end = ((void *) bcfg->config) + BOARD_CONFIG_BUFSZ;
+
+	eeprom += off;
+	if (eeprom > eeprom_end)
+		return false;
+
+	*data = *eeprom;
+	return true;
+}
+
+int ath5k_hw_read_srev(struct ath5k_hw *ah)
+{
+	struct platform_device *pdev = to_platform_device(ah->dev);
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
+	ah->ah_mac_srev = bcfg->devid;
+	return 0;
+}
+
+static int ath5k_ahb_eeprom_read_mac(struct ath5k_hw *ah, u8 *mac)
+{
+	struct platform_device *pdev = to_platform_device(ah->dev);
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
+	u8 *cfg_mac;
+
+	if (to_platform_device(ah->dev)->id == 0)
+		cfg_mac = bcfg->config->wlan0_mac;
+	else
+		cfg_mac = bcfg->config->wlan1_mac;
+
+	memcpy(mac, cfg_mac, ETH_ALEN);
+	return 0;
+}
+
+static const struct ath_bus_ops ath_ahb_bus_ops = {
+	.ath_bus_type = ATH_AHB,
+	.read_cachesize = ath5k_ahb_read_cachesize,
+	.eeprom_read = ath5k_ahb_eeprom_read,
+	.eeprom_read_mac = ath5k_ahb_eeprom_read_mac,
+};
+
+/*Initialization*/
+static int ath_ahb_probe(struct platform_device *pdev)
+{
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
+	struct ath5k_hw *ah;
+	struct ieee80211_hw *hw;
+	struct resource *res;
+	void __iomem *mem;
+	int irq;
+	int ret = 0;
+	u32 reg;
+
+	if (!dev_get_platdata(&pdev->dev)) {
+		dev_err(&pdev->dev, "no platform data specified\n");
+		ret = -EINVAL;
+		goto err_out;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no memory resource found\n");
+		ret = -ENXIO;
+		goto err_out;
+	}
+
+	mem = ioremap_nocache(res->start, resource_size(res));
+	if (mem == NULL) {
+		dev_err(&pdev->dev, "ioremap failed\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	if (res == NULL) {
+		dev_err(&pdev->dev, "no IRQ resource found\n");
+		ret = -ENXIO;
+		goto err_iounmap;
+	}
+
+	irq = res->start;
+
+	hw = ieee80211_alloc_hw(sizeof(struct ath5k_hw), &ath5k_hw_ops);
+	if (hw == NULL) {
+		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	ah = hw->priv;
+	ah->hw = hw;
+	ah->dev = &pdev->dev;
+	ah->iobase = mem;
+	ah->irq = irq;
+	ah->devid = bcfg->devid;
+
+	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
+		/* Enable WMAC AHB arbitration */
+		reg = ioread32((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg |= AR5K_AR2315_AHB_ARB_CTL_WLAN;
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+
+		/* Enable global WMAC swapping */
+		reg = ioread32((void __iomem *) AR5K_AR2315_BYTESWAP);
+		reg |= AR5K_AR2315_BYTESWAP_WMAC;
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
+	} else {
+		/* Enable WMAC DMA access (assuming 5312 or 231x*/
+		/* TODO: check other platforms */
+		reg = ioread32((void __iomem *) AR5K_AR5312_ENABLE);
+		if (to_platform_device(ah->dev)->id == 0)
+			reg |= AR5K_AR5312_ENABLE_WLAN0;
+		else
+			reg |= AR5K_AR5312_ENABLE_WLAN1;
+		iowrite32(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+
+		/*
+		 * On a dual-band AR5312, the multiband radio is only
+		 * used as pass-through. Disable 2 GHz support in the
+		 * driver for it
+		 */
+		if (to_platform_device(ah->dev)->id == 0 &&
+		    (bcfg->config->flags & (BD_WLAN0 | BD_WLAN1)) ==
+		     (BD_WLAN1 | BD_WLAN0))
+			ah->ah_capabilities.cap_needs_2GHz_ovr = true;
+		else
+			ah->ah_capabilities.cap_needs_2GHz_ovr = false;
+	}
+
+	ret = ath5k_init_ah(ah, &ath_ahb_bus_ops);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
+		ret = -ENODEV;
+		goto err_free_hw;
+	}
+
+	platform_set_drvdata(pdev, hw);
+
+	return 0;
+
+ err_free_hw:
+	ieee80211_free_hw(hw);
+ err_iounmap:
+        iounmap(mem);
+ err_out:
+	return ret;
+}
+
+static int ath_ahb_remove(struct platform_device *pdev)
+{
+	struct ar231x_board_config *bcfg = dev_get_platdata(&pdev->dev);
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+	struct ath5k_hw *ah;
+	u32 reg;
+
+	if (!hw)
+		return 0;
+
+	ah = hw->priv;
+
+	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
+		/* Disable WMAC AHB arbitration */
+		reg = ioread32((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg &= ~AR5K_AR2315_AHB_ARB_CTL_WLAN;
+		iowrite32(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+	} else {
+		/*Stop DMA access */
+		reg = ioread32((void __iomem *) AR5K_AR5312_ENABLE);
+		if (to_platform_device(ah->dev)->id == 0)
+			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
+		else
+			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
+		iowrite32(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+	}
+
+	ath5k_deinit_ah(ah);
+	iounmap(ah->iobase);
+	ieee80211_free_hw(hw);
+
+	return 0;
+}
+
+static struct platform_driver ath_ahb_driver = {
+	.probe      = ath_ahb_probe,
+	.remove     = ath_ahb_remove,
+	.driver		= {
+		.name	= "ar231x-wmac",
+		.owner	= THIS_MODULE,
+	},
+};
+
+module_platform_driver(ath_ahb_driver);
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ed24682..85316bb 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1647,6 +1647,32 @@ static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
 	return &(ath5k_hw_common(ah)->regulatory);
 }
 
+#ifdef CONFIG_ATHEROS_AR231X
+#define AR5K_AR2315_PCI_BASE	((void __iomem *)0xb0100000)
+
+static inline void __iomem *ath5k_ahb_reg(struct ath5k_hw *ah, u16 reg)
+{
+	/* On AR2315 and AR2317 the PCI clock domain registers
+	 * are outside of the WMAC register space */
+	if (unlikely((reg >= 0x4000) && (reg < 0x5000) &&
+	    (ah->ah_mac_srev >= AR5K_SREV_AR2315_R6)))
+		return AR5K_AR2315_PCI_BASE + reg;
+
+	return ah->iobase + reg;
+}
+
+static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
+{
+	return ioread32(ath5k_ahb_reg(ah, reg));
+}
+
+static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
+{
+	iowrite32(val, ath5k_ahb_reg(ah, reg));
+}
+
+#else
+
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
 	return ioread32(ah->iobase + reg);
@@ -1657,6 +1683,8 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 	iowrite32(val, ah->iobase + reg);
 }
 
+#endif
+
 static inline enum ath_bus_type ath5k_get_bus_type(struct ath5k_hw *ah)
 {
 	return ath5k_hw_common(ah)->bus_ops->ath_bus_type;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4a09bb..59a8724 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -99,6 +99,15 @@ static int ath5k_reset(struct ath5k_hw *ah, struct ieee80211_channel *chan,
 
 /* Known SREVs */
 static const struct ath5k_srev_name srev_names[] = {
+#ifdef CONFIG_ATHEROS_AR231X
+	{ "5312",	AR5K_VERSION_MAC,	AR5K_SREV_AR5312_R2 },
+	{ "5312",	AR5K_VERSION_MAC,	AR5K_SREV_AR5312_R7 },
+	{ "2313",	AR5K_VERSION_MAC,	AR5K_SREV_AR2313_R8 },
+	{ "2315",	AR5K_VERSION_MAC,	AR5K_SREV_AR2315_R6 },
+	{ "2315",	AR5K_VERSION_MAC,	AR5K_SREV_AR2315_R7 },
+	{ "2317",	AR5K_VERSION_MAC,	AR5K_SREV_AR2317_R1 },
+	{ "2317",	AR5K_VERSION_MAC,	AR5K_SREV_AR2317_R2 },
+#else
 	{ "5210",	AR5K_VERSION_MAC,	AR5K_SREV_AR5210 },
 	{ "5311",	AR5K_VERSION_MAC,	AR5K_SREV_AR5311 },
 	{ "5311A",	AR5K_VERSION_MAC,	AR5K_SREV_AR5311A },
@@ -117,6 +126,7 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "5418",	AR5K_VERSION_MAC,	AR5K_SREV_AR5418 },
 	{ "2425",	AR5K_VERSION_MAC,	AR5K_SREV_AR2425 },
 	{ "2417",	AR5K_VERSION_MAC,	AR5K_SREV_AR2417 },
+#endif
 	{ "xxxxx",	AR5K_VERSION_MAC,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
@@ -132,6 +142,10 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "5413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5413 },
 	{ "5424",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5424 },
 	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
+#ifdef CONFIG_ATHEROS_AR231X
+	{ "2316",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2316 },
+	{ "2317",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2317 },
+#endif
 	{ "xxxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },
 };
 
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 0beb7e7..2062d11 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -163,14 +163,20 @@ int ath5k_init_leds(struct ath5k_hw *ah)
 {
 	int ret = 0;
 	struct ieee80211_hw *hw = ah->hw;
+#ifndef CONFIG_ATHEROS_AR231X
 	struct pci_dev *pdev = ah->pdev;
+#endif
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
 	if (!ah->pdev)
 		return 0;
 
+#ifdef CONFIG_ATHEROS_AR231X
+	match = NULL;
+#else
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
+#endif
 	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, ah->status);
 		ah->led_pin = ATH_PIN(match->driver_data);
-- 
1.8.5.5

