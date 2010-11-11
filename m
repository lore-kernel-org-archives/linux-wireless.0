Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56700 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752618Ab0KKO60 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:58:26 -0500
Date: Thu, 11 Nov 2010 15:58:21 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <13896234.1151289487498939.JavaMail.wlan@CHBU500181>
In-Reply-To: <22942120.791289486697022.JavaMail.wlan@CHBU500181>
Subject: [PATCH 8/9] ath5k: AHB port. Add AHB bus support.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


AHB specific functions are now in ahb.c file. There is no common
init functions which tries first pci and then ahb becasue on some
wisoc's PCI is not present. AHB bus is compiled in when
CONFIG_ATHEROS_AR231X is set in kernel.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/Makefile |    2 +-
 drivers/net/wireless/ath/ath5k/ahb.c    |  221 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/ath5k.h  |   12 ++
 drivers/net/wireless/ath/ath5k/base.c   |   16 ++-
 drivers/net/wireless/ath/ath5k/led.c    |    6 +
 drivers/net/wireless/ath/ath5k/reg.h    |   25 ++++
 6 files changed, 279 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/ahb.c

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index dae881c..50d5e08 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -15,5 +15,5 @@ ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
 ath5k-y				+= sysfs.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
-ath5k-y				+= pci.o
+ath5k-y				+= $(if $(CONFIG_ATHEROS_AR231X),ahb,pci).o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ahb.c b/drivers/net/wireless/ath/ath5k/ahb.c
new file mode 100644
index 0000000..6e1aa65
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/ahb.c
@@ -0,0 +1,221 @@
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
+int ath5k_bus_read_srev(struct ath5k_hw *ah)
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
+	} else 	{
+		/* Enable WMAC DMA access (assuming 5312 or 231x*/
+		/* TODO: check other platforms */
+		reg = __raw_readl((void __iomem *) AR5K_AR5312_ENABLE);
+		if( to_platform_device(sc->dev)->id == 0) {
+			reg |= AR5K_AR5312_ENABLE_WLAN0;
+		} else {
+			reg |= AR5K_AR5312_ENABLE_WLAN1;
+		}
+		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+	}
+
+	ret = ath5k_attach(sc, &ath_ahb_bus_ops);
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
+		if( to_platform_device(sc->dev)->id == 0) {
+			reg &= ~AR5K_AR5312_ENABLE_WLAN0;
+		} else {
+			reg &= ~AR5K_AR5312_ENABLE_WLAN1;
+		}
+		__raw_writel(reg, (void __iomem *) AR5K_AR5312_ENABLE);
+	}
+	
+	ath5k_detach(sc);
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
index a13243a..1c46a63 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -303,12 +303,19 @@ struct ath5k_srev_name {
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
@@ -1311,6 +1318,11 @@ static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 	iowrite32(val, ah->ah_iobase + reg);
 }
 
+static inline enum ath_bus_type ath5k_get_bus_type(struct ath5k_hw *ah)
+{
+	return ath5k_hw_common(ah)->bus_ops->ath_bus_type;
+}
+
 static inline void ath5k_read_cachesize(struct ath_common *common, int *csz)
 {
 	common->bus_ops->read_cachesize(common, csz);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 22464e2..13d5da5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -86,6 +86,15 @@ static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 
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
@@ -104,6 +113,7 @@ static const struct ath5k_srev_name srev_names[] = {
 	{ "5418",	AR5K_VERSION_MAC,	AR5K_SREV_AR5418 },
 	{ "2425",	AR5K_VERSION_MAC,	AR5K_SREV_AR2425 },
 	{ "2417",	AR5K_VERSION_MAC,	AR5K_SREV_AR2417 },
+#endif
 	{ "xxxxx",	AR5K_VERSION_MAC,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
@@ -117,10 +127,12 @@ static const struct ath5k_srev_name srev_names[] = {
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
index 1f5a991..be43158 100644
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
+	match=NULL;
+#else
 	match = pci_match_id(&ath5k_led_devices[0], pdev);
+#endif
 	if (match) {
 		__set_bit(ATH_STAT_LEDSOFT, sc->status);
 		sc->led_pin = ATH_PIN(match->driver_data);
diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index ca79ecd..2ed6b43 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -2558,3 +2558,28 @@
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

