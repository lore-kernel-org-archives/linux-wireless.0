Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:54077 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbZAMNly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:41:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v3 06/11] ath9k: introduce platform driver for AHB bus support
Date: Tue, 13 Jan 2009 14:40:24 +0100
Message-Id: <1231854029-26810-7-git-send-email-juhosg@openwrt.org> (sfid-20090113_144203_032521_834E4E8B)
In-Reply-To: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
References: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds the platform_driver itself, and modifies the main driver
to register it.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/Makefile |    1 +
 drivers/net/wireless/ath9k/ahb.c    |  160 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath9k/core.h   |    8 ++
 drivers/net/wireless/ath9k/main.c   |   10 ++
 4 files changed, 179 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath9k/ahb.c

diff --git a/drivers/net/wireless/ath9k/Makefile b/drivers/net/wireless/ath9k/Makefile
index af3f39b..0062958 100644
--- a/drivers/net/wireless/ath9k/Makefile
+++ b/drivers/net/wireless/ath9k/Makefile
@@ -12,6 +12,7 @@ ath9k-y +=	hw.o \
 		rc.o
 
 ath9k-$(CONFIG_PCI) += pci.o
+ath9k-$(CONFIG_ATHEROS_AR71XX) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUG) += debug.o
 
 obj-$(CONFIG_ATH9K) += ath9k.o
diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
new file mode 100644
index 0000000..8cbd4c2
--- /dev/null
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -0,0 +1,160 @@
+/*
+ * Copyright (c) 2008 Atheros Communications Inc.
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
+#include "core.h"
+#include "reg.h"
+#include "hw.h"
+
+/* return bus cachesize in 4B word units */
+static void ath_ahb_read_cachesize(struct ath_softc *sc, int *csz)
+{
+	*csz = L1_CACHE_BYTES >> 2;
+}
+
+static void ath_ahb_cleanup(struct ath_softc *sc)
+{
+	iounmap(sc->mem);
+}
+
+static struct ath_bus_ops ath_ahb_bus_ops  = {
+	.read_cachesize = ath_ahb_read_cachesize,
+	.cleanup = ath_ahb_cleanup,
+};
+
+static int ath_ahb_probe(struct platform_device *pdev)
+{
+	void __iomem *mem;
+	struct ath_softc *sc;
+	struct ieee80211_hw *hw;
+	struct resource *res;
+	int irq;
+	int ret = 0;
+	struct ath_hal *ah;
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
+		goto err_iounmap;
+	}
+
+	irq = res->start;
+
+	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
+	if (hw == NULL) {
+		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
+		ret = -ENOMEM;
+		goto err_iounmap;
+	}
+
+	SET_IEEE80211_DEV(hw, &pdev->dev);
+	platform_set_drvdata(pdev, hw);
+
+	sc = hw->priv;
+	sc->hw = hw;
+	sc->dev = &pdev->dev;
+	sc->mem = mem;
+	sc->bus_ops = &ath_ahb_bus_ops;
+	sc->irq = irq;
+
+	ret = ath_attach(AR5416_AR9100_DEVID, sc);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "failed to attach device, err=%d\n", ret);
+		ret = -ENODEV;
+		goto err_free_hw;
+	}
+
+	ret = request_irq(irq, ath_isr, IRQF_SHARED, "ath9k", sc);
+	if (ret) {
+		dev_err(&pdev->dev, "request_irq failed, err=%d\n", ret);
+		ret = -EIO;
+		goto err_detach;
+	}
+
+	ah = sc->sc_ah;
+	printk(KERN_INFO
+	       "%s: Atheros AR%s MAC/BB Rev:%x, "
+	       "AR%s RF Rev:%x, mem=0x%lx, irq=%d\n",
+	       wiphy_name(hw->wiphy),
+	       ath_mac_bb_name(ah->ah_macVersion),
+	       ah->ah_macRev,
+	       ath_rf_name((ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ah->ah_phyRev,
+	       (unsigned long)mem, irq);
+
+	return 0;
+
+ err_detach:
+	ath_detach(sc);
+ err_free_hw:
+	ieee80211_free_hw(hw);
+	platform_set_drvdata(pdev, NULL);
+ err_iounmap:
+	iounmap(mem);
+ err_out:
+	return ret;
+}
+
+static int ath_ahb_remove(struct platform_device *pdev)
+{
+	struct ieee80211_hw *hw = platform_get_drvdata(pdev);
+
+	if (hw) {
+		struct ath_softc *sc = hw->priv;
+
+		ath_cleanup(sc);
+		platform_set_drvdata(pdev, NULL);
+	}
+
+	return 0;
+}
+
+static struct platform_driver ath_ahb_driver = {
+	.probe      = ath_ahb_probe,
+	.remove     = ath_ahb_remove,
+	.driver		= {
+		.name	= "ath9k",
+		.owner	= THIS_MODULE,
+	},
+};
+
+int ath_ahb_init(void)
+{
+	return platform_driver_register(&ath_ahb_driver);
+}
+
+void ath_ahb_exit(void)
+{
+	platform_driver_unregister(&ath_ahb_driver);
+}
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 1e86a9c..c5dae11 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -784,4 +784,12 @@ static inline int ath_pci_init(void) { return 0; };
 static inline void ath_pci_exit(void) {};
 #endif
 
+#ifdef CONFIG_ATHEROS_AR71XX
+int ath_ahb_init(void);
+void ath_ahb_exit(void);
+#else
+static inline int ath_ahb_init(void) { return 0; };
+static inline void ath_ahb_exit(void) {};
+#endif
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 6257790..7f4d1bb 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2527,8 +2527,17 @@ static int __init ath9k_init(void)
 		goto err_rate_unregister;
 	}
 
+	error = ath_ahb_init();
+	if (error < 0) {
+		error = -ENODEV;
+		goto err_pci_exit;
+	}
+
 	return 0;
 
+ err_pci_exit:
+	ath_pci_exit();
+
  err_rate_unregister:
 	ath_rate_control_unregister();
  err_out:
@@ -2538,6 +2547,7 @@ module_init(ath9k_init);
 
 static void __exit ath9k_exit(void)
 {
+	ath_ahb_exit();
 	ath_pci_exit();
 	ath_rate_control_unregister();
 	printk(KERN_INFO "%s: Driver unloaded\n", dev_info);
-- 
1.5.3.2

