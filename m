Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:53043 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405Ab0LBJ1U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 04:27:20 -0500
Date: Thu, 2 Dec 2010 10:27:16 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, nbd@openwrt.org,
	ath5k-devel@lists.ath5k.org, mickflemm@gmail.com
Message-ID: <26699788.1501291282032769.JavaMail.wlan@CHBU500181>
In-Reply-To: <513944.1321291281894160.JavaMail.wlan@CHBU500181>
Subject: [PATCH v7 8/9] ath5k: Add AHB bus support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

AHB specific functions are now in ahb.c file. AHB bus is
compiled in when CONFIG_ATHEROS_AR231X is set in kernel.
All other platforms will use PCI bus.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/Kconfig  |   17 +++-
 drivers/net/wireless/ath/ath5k/Makefile |    3 +-
 drivers/net/wireless/ath/ath5k/ahb.c    |  219 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |   40 ++++++
 drivers/net/wireless/ath/ath5k/base.c   |   16 ++-
 drivers/net/wireless/ath/ath5k/led.c    |    6 +
 drivers/net/wireless/ath/ath5k/reg.h    |   25 ++++
 7 files changed, 322 insertions(+), 4 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c

diff --git a/drivers/net/wireless/ath/ath5k/Kconfig b/drivers/net/wireless/ath/ath5k/Kconfig
index 4784457..e079331 100644
--- a/drivers/net/wireless/ath/ath5k/Kconfig
+++ b/drivers/net/wireless/ath/ath5k/Kconfig
@@ -1,10 +1,12 @@
 config ATH5K
 	tristate "Atheros 5xxx wireless cards support"
-	depends on PCI && MAC80211
+	depends on (PCI || ATHEROS_AR231X) && MAC80211
 	select MAC80211_LEDS
 	select LEDS_CLASS
 	select NEW_LEDS
 	select AVERAGE
+	select ATH5K_AHB if (ATHEROS_AR231X && !PCI)
+	select ATH5K_PCI if (!ATHEROS_AR231X && PCI)
 	---help---
 	  This module adds support for wireless adapters based on
 	  Atheros 5xxx chipset.
@@ -38,3 +40,16 @@ config ATH5K_DEBUG
 
 	  modprobe ath5k debug=0x00000400
 
+config ATH5K_AHB
+	bool "Atheros 5xxx AHB bus support"
+	depends on (ATHEROS_AR231X && !PCI)
+	---help---
+	  This adds support for WiSoC type chipsets of the 5xxx Atheros
+	  family.
+
+config ATH5K_PCI
+	bool "Atheros 5xxx PCI bus support"
+	depends on (!ATHEROS_AR231X && PCI)
+	---help---
+	  This adds support for PCI type chipsets of the 5xxx Atheros
+	  family.
diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index dae881c..67dd9fd 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -15,5 +15,6 @@ ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
 ath5k-y				+= sysfs.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
-ath5k-y				+= pci.o
+ath5k-$(CONFIG_ATH5K_AHB)	+= ahb.o
+ath5k-$(CONFIG_ATH5K_PCI)	+= pci.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
new file mode 100644
index 0000000..707cde1
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -0,0 +1,219 @@
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
+#include <ar231x_platform.h>
+#include "ath5k.h"
+#include "debug.h"
+#include "base.h"
+#include "reg.h"
+#include "debug.h"
+
+/* return bus cachesize in 4B word units */
+static void ath5k_ahb_read_cachesize(struct ath_common *common, int *csz)
+{
+	*csz = L1_CACHE_BYTES >> 2;
+}
+
+bool ath5k_ahb_eeprom_read(struct ath_common *common, u32 off, u16 *data)
+{
+	struct ath5k_softc *sc = common->priv;
+	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	u16 *eeprom, *eeprom_end;
+
+
+
+	bcfg = pdev->dev.platform_data;
+	eeprom = (u16 *) bcfg->radio;
+	eeprom_end = ((void *) bcfg->config) + BOARD_CONFIG_BUFSZ;
+
+	eeprom += off;
+	if (eeprom > eeprom_end)
+		return -EINVAL;
+
+	*data = *eeprom;
+	return 0;
+}
+
+int ath5k_hw_read_srev(struct ath5k_hw *ah)
+{
+	struct ath5k_softc *sc = ah->ah_sc;
+	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	ah->ah_mac_srev = bcfg->devid;
+	return 0;
+}
+
+static const struct ath_bus_ops ath_ahb_bus_ops = {
+	.ath_bus_type = ATH_AHB,
+	.read_cachesize = ath5k_ahb_read_cachesize,
+	.eeprom_read = ath5k_ahb_eeprom_read,
+};
+
+/*Initialization*/
+static int ath_ahb_probe(struct platform_device *pdev)
+{
+	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ath5k_softc *sc;
+	struct ieee80211_hw *hw;
+	struct resource *res;
+	void __iomem *mem;
+	int irq;
+	int ret = 0;
+	u32 reg;
+
+	if (!pdev->dev.platform_data) {
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
+	mem = ioremap_nocache(res->start, res->end - res->start + 1);
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
+		goto err_out;
+	}
+
+	irq = res->start;
+
+	hw = ieee80211_alloc_hw(sizeof(struct ath5k_softc), &ath5k_hw_ops);
+	if (hw == NULL) {
+		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
+		ret = -ENOMEM;
+		goto err_out;
+	}
+
+	sc = hw->priv;
+	sc->hw = hw;
+	sc->dev = &pdev->dev;
+	sc->iobase = mem;
+	sc->irq = irq;
+	sc->devid = bcfg->devid;
+
+	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
+		/* Enable WMAC AHB arbitration */
+		reg = __raw_readl((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg |= AR5K_AR2315_AHB_ARB_CTL_WLAN;
+		__raw_writel(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+
+		/* Enable global WMAC swapping */
+		reg = __raw_readl((void __iomem *) AR5K_AR2315_BYTESWAP);
+		reg |= AR5K_AR2315_BYTESWAP_WMAC;
+		__raw_writel(reg, (void __iomem *) AR5K_AR2315_BYTESWAP);
+	} else {
+		/* Enable WMAC DMA access (assuming 5312 or 231x*/
+		/* TODO: check other platforms */
+		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
+		if (to_platform_device(sc->dev)->id == 0)
+			reg |= AR5K_AR5312_ENABLE_WLAN0;
+		else
+			reg |= AR5K_AR5312_ENABLE_WLAN1;
+		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+	}
+
+	ret = ath5k_init_softc(sc, &ath_ahb_bus_ops);
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
+	platform_set_drvdata(pdev, NULL);
+ err_out:
+	return ret;
+}
+
+static int ath_ahb_remove(struct platform_device *pdev)
+{
+	struct ar231x_board_config *bcfg = pdev->dev.platform_data;
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+	struct ath5k_softc *sc;
+	u32 reg;
+
+	if (!hw)
+		return 0;
+
+	sc = hw->priv;
+
+	if (bcfg->devid >= AR5K_SREV_AR2315_R6) {
+		/* Disable WMAC AHB arbitration */
+		reg = __raw_readl((void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+		reg &= ~AR5K_AR2315_AHB_ARB_CTL_WLAN;
+		__raw_writel(reg, (void __iomem *) AR5K_AR2315_AHB_ARB_CTL);
+	} else {
+		/*Stop DMA access */
+		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
+		if (to_platform_device(sc->dev)->id == 0)
+			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
+		else
+			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
+		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+	}
+
+	ath5k_deinit_softc(sc);
+	platform_set_drvdata(pdev, NULL);
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
+static int __init
+ath5k_ahb_init(void)
+{
+	return platform_driver_register(&ath_ahb_driver);
+}
+
+static void __exit
+ath5k_ahb_exit(void)
+{
+	platform_driver_unregister(&ath_ahb_driver);
+}
+
+module_init(ath5k_ahb_init);
+module_exit(ath5k_ahb_exit);
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 5e525eb..d6e7440 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -319,12 +319,19 @@ struct ath5k_srev_name {
 #define AR5K_SREV_AR5311B	0x30 /* Spirit */
 #define AR5K_SREV_AR5211	0x40 /* Oahu */
 #define AR5K_SREV_AR5212	0x50 /* Venice */
+#define AR5K_SREV_AR5312_R2	0x52 /* AP31 */
 #define AR5K_SREV_AR5212_V4	0x54 /* ??? */
 #define AR5K_SREV_AR5213	0x55 /* ??? */
+#define AR5K_SREV_AR5312_R7	0x57 /* AP30 */
+#define AR5K_SREV_AR2313_R8	0x58 /* AP43 */
 #define AR5K_SREV_AR5213A	0x59 /* Hainan */
 #define AR5K_SREV_AR2413	0x78 /* Griffin lite */
 #define AR5K_SREV_AR2414	0x70 /* Griffin */
+#define AR5K_SREV_AR2315_R6 0x86 /* AP51-Light */
+#define AR5K_SREV_AR2315_R7 0x87 /* AP51-Full */
 #define AR5K_SREV_AR5424	0x90 /* Condor */
+#define AR5K_SREV_AR2317_R1 0x90 /* AP61-Light */
+#define AR5K_SREV_AR2317_R2 0x91 /* AP61-Full */
 #define AR5K_SREV_AR5413	0xa4 /* Eagle lite */
 #define AR5K_SREV_AR5414	0xa0 /* Eagle */
 #define AR5K_SREV_AR2415	0xb0 /* Talon */
@@ -1329,6 +1336,32 @@ static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
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
+		(ah->ah_mac_srev >= AR5K_SREV_AR2315_R6)))
+		return AR5K_AR2315_PCI_BASE + reg;
+
+	return ah->ah_iobase + reg;
+}
+
+static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
+{
+	return __raw_readl(ath5k_ahb_reg(ah, reg));
+}
+
+static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
+{
+	__raw_writel(val, ath5k_ahb_reg(ah, reg));
+}
+
+#else
+
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
 	return ioread32(ah->ah_iobase + reg);
@@ -1339,6 +1372,13 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 	iowrite32(val, ah->ah_iobase + reg);
 }
 
+#endif
+
+static inline enum ath_bus_type ath5k_get_bus_type(struct ath5k_hw *ah)
+{
+	return ath5k_hw_common(ah)->bus_ops->ath_bus_type;
+}
+
 static inline void ath5k_read_cachesize(struct ath_common *common, int *csz)
 {
 	common->bus_ops->read_cachesize(common, csz);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9fcc4e1..685de2d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -87,6 +87,15 @@ static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 
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
@@ -105,6 +114,7 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "5418",	AR5K_VERSION_MAC,	AR5K_SREV_AR5418 },
 	{ "2425",	AR5K_VERSION_MAC,	AR5K_SREV_AR2425 },
 	{ "2417",	AR5K_VERSION_MAC,	AR5K_SREV_AR2417 },
+#endif
 	{ "xxxxx",	AR5K_VERSION_MAC,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
@@ -118,10 +128,12 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "2112B",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112B },
 	{ "2413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2413 },
 	{ "5413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5413 },
-	{ "2316",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2316 },
-	{ "2317",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2317 },
 	{ "5424",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5424 },
 	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
+#ifdef CONFIG_ATHEROS_AR231X
+	{ "2316",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2316 },
+	{ "2317",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2317 },
+#endif
 	{ "xxxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },
 };
 
diff --git a/drivers/net/wireless/ath/ath5k/led.c b/drivers/net/wireless/ath/ath5k/led.c
index 1f5a991..576edf2 100644
--- a/drivers/net/wireless/ath/ath5k/led.c
+++ b/drivers/net/wireless/ath/ath5k/led.c
@@ -161,14 +161,20 @@ int ath5k_init_leds(struct ath5k_softc *sc)
 {
 	int ret = 0;
 	struct ieee80211_hw *hw = sc->hw;
+#ifndef CONFIG_ATHEROS_AR231X
 	struct pci_dev *pdev = sc->pdev;
+#endif
 	char name[ATH5K_LED_MAX_NAME_LEN + 1];
 	const struct pci_device_id *match;
 
 	if (!sc->pdev)
 		return 0;
 
+#ifdef CONFIG_ATHEROS_AR231X
+	match = NULL;
+#else
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
+#endif
 	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
 		sc->led_pin = ATH_PIN(match->driver_data);
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 8516728..7ad05d4 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2562,3 +2562,28 @@
  */
 #define AR5K_PHY_PDADC_TXPOWER_BASE	0xa280
 #define	AR5K_PHY_PDADC_TXPOWER(_n)	(AR5K_PHY_PDADC_TXPOWER_BASE + ((_n) << 2))
+
+/*
+ * Platform registers for WiSoC
+ */
+#define AR5K_AR5312_RESET		0xbc003020
+#define AR5K_AR5312_RESET_BB0_COLD	0x00000004
+#define AR5K_AR5312_RESET_BB1_COLD	0x00000200
+#define AR5K_AR5312_RESET_WMAC0		0x00002000
+#define AR5K_AR5312_RESET_BB0_WARM	0x00004000
+#define AR5K_AR5312_RESET_WMAC1		0x00020000
+#define AR5K_AR5312_RESET_BB1_WARM	0x00040000
+
+#define AR5K_AR5312_ENABLE		0xbc003080
+#define AR5K_AR5312_ENABLE_WLAN0    0x00000001
+#define AR5K_AR5312_ENABLE_WLAN1    0x00000008
+
+#define AR5K_AR2315_RESET		0xb1000004
+#define AR5K_AR2315_RESET_WMAC		0x00000001
+#define AR5K_AR2315_RESET_BB_WARM	0x00000002
+
+#define AR5K_AR2315_AHB_ARB_CTL		0xb1000008
+#define AR5K_AR2315_AHB_ARB_CTL_WLAN	0x00000002
+
+#define AR5K_AR2315_BYTESWAP	0xb100000c
+#define AR5K_AR2315_BYTESWAP_WMAC	0x00000002
-- 
1.7.1

