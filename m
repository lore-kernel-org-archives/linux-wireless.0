Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:54064 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZAMNlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 08:41:53 -0500
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
Subject: [PATCH v3 07/11] ath9k: get EEPROM contents from platform data on AHB bus
Date: Tue, 13 Jan 2009 14:40:25 +0100
Message-Id: <1231854029-26810-8-git-send-email-juhosg@openwrt.org> (sfid-20090113_144159_734576_1EEA7BE3)
In-Reply-To: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
References: <1231854029-26810-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On the AR913x SOCs we have to provide EEPROM contents via platform_data,
because accessing the flash via MMIO is not safe. Additionally different
boards may store the radio calibration data at different locations.

Changes-licensed-under: ISC

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/ahb.c    |   27 ++++++++++++++++++
 drivers/net/wireless/ath9k/core.h   |    1 +
 drivers/net/wireless/ath9k/eeprom.c |   51 ++--------------------------------
 drivers/net/wireless/ath9k/pci.c    |   18 ++++++++++++
 include/linux/ath9k_platform.h      |   28 +++++++++++++++++++
 5 files changed, 77 insertions(+), 48 deletions(-)
 create mode 100644 include/linux/ath9k_platform.h

diff --git a/drivers/net/wireless/ath9k/ahb.c b/drivers/net/wireless/ath9k/ahb.c
index 8cbd4c2..7f2c3a0 100644
--- a/drivers/net/wireless/ath9k/ahb.c
+++ b/drivers/net/wireless/ath9k/ahb.c
@@ -18,6 +18,7 @@
 
 #include <linux/nl80211.h>
 #include <linux/platform_device.h>
+#include <linux/ath9k_platform.h>
 #include "core.h"
 #include "reg.h"
 #include "hw.h"
@@ -33,9 +34,29 @@ static void ath_ahb_cleanup(struct ath_softc *sc)
 	iounmap(sc->mem);
 }
 
+static bool ath_ahb_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
+{
+	struct ath_softc *sc = ah->ah_sc;
+	struct platform_device *pdev = to_platform_device(sc->dev);
+	struct ath9k_platform_data *pdata;
+
+	pdata = (struct ath9k_platform_data *) pdev->dev.platform_data;
+	if (off >= (ARRAY_SIZE(pdata->eeprom_data))) {
+		DPRINTF(ah->ah_sc, ATH_DBG_FATAL,
+			"%s: flash read failed, offset %08x is out of range\n",
+				__func__, off);
+		return false;
+	}
+
+	*data = pdata->eeprom_data[off];
+	return true;
+}
+
 static struct ath_bus_ops ath_ahb_bus_ops  = {
 	.read_cachesize = ath_ahb_read_cachesize,
 	.cleanup = ath_ahb_cleanup,
+
+	.eeprom_read = ath_ahb_eeprom_read,
 };
 
 static int ath_ahb_probe(struct platform_device *pdev)
@@ -48,6 +69,12 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int ret = 0;
 	struct ath_hal *ah;
 
+	if (!pdev->dev.platform_data) {
+		dev_err(&pdev->dev, "no platform data specified\n");
+		ret = -EINVAL;
+		goto err_out;
+	}
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource found\n");
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index c5dae11..b687ae9 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -696,6 +696,7 @@ enum PROT_MODE {
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
 	void		(*cleanup)(struct ath_softc *sc);
+	bool		(*eeprom_read)(struct ath_hal *ah, u32 off, u16 *data);
 };
 
 struct ath_softc {
diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 1ef8b5a..50cb388 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -91,53 +91,11 @@ static inline bool ath9k_hw_get_lower_upper_index(u8 target, u8 *pList,
 	return false;
 }
 
-static bool ath9k_hw_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
-{
-	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
-
-	if (!ath9k_hw_wait(ah,
-			   AR_EEPROM_STATUS_DATA,
-			   AR_EEPROM_STATUS_DATA_BUSY |
-			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0)) {
-		return false;
-	}
-
-	*data = MS(REG_READ(ah, AR_EEPROM_STATUS_DATA),
-		   AR_EEPROM_STATUS_DATA_VAL);
-
-	return true;
-}
-
-static int ath9k_hw_flash_map(struct ath_hal *ah)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	ahp->ah_cal_mem = ioremap(AR5416_EEPROM_START_ADDR, AR5416_EEPROM_MAX);
-
-	if (!ahp->ah_cal_mem) {
-		DPRINTF(ah->ah_sc, ATH_DBG_EEPROM,
-			"cannot remap eeprom region \n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static bool ath9k_hw_flash_read(struct ath_hal *ah, u32 off, u16 *data)
-{
-	struct ath_hal_5416 *ahp = AH5416(ah);
-
-	*data = ioread16(ahp->ah_cal_mem + off);
-
-	return true;
-}
-
 static inline bool ath9k_hw_nvram_read(struct ath_hal *ah, u32 off, u16 *data)
 {
-	if (ath9k_hw_use_flash(ah))
-		return ath9k_hw_flash_read(ah, off, data);
-	else
-		return ath9k_hw_eeprom_read(ah, off, data);
+	struct ath_softc *sc = ah->ah_sc;
+
+	return sc->bus_ops->eeprom_read(ah, off, data);
 }
 
 static bool ath9k_hw_fill_4k_eeprom(struct ath_hal *ah)
@@ -2825,9 +2783,6 @@ int ath9k_hw_eeprom_attach(struct ath_hal *ah)
 	int status;
 	struct ath_hal_5416 *ahp = AH5416(ah);
 
-	if (ath9k_hw_use_flash(ah))
-		ath9k_hw_flash_map(ah);
-
 	if (AR_SREV_9285(ah))
 		ahp->ah_eep_map = EEP_MAP_4KBITS;
 	else
diff --git a/drivers/net/wireless/ath9k/pci.c b/drivers/net/wireless/ath9k/pci.c
index 9f676ef..86bf346 100644
--- a/drivers/net/wireless/ath9k/pci.c
+++ b/drivers/net/wireless/ath9k/pci.c
@@ -58,9 +58,27 @@ static void ath_pci_cleanup(struct ath_softc *sc)
 	pci_disable_device(pdev);
 }
 
+static bool ath_pci_eeprom_read(struct ath_hal *ah, u32 off, u16 *data)
+{
+	(void)REG_READ(ah, AR5416_EEPROM_OFFSET + (off << AR5416_EEPROM_S));
+
+	if (!ath9k_hw_wait(ah,
+			   AR_EEPROM_STATUS_DATA,
+			   AR_EEPROM_STATUS_DATA_BUSY |
+			   AR_EEPROM_STATUS_DATA_PROT_ACCESS, 0)) {
+		return false;
+	}
+
+	*data = MS(REG_READ(ah, AR_EEPROM_STATUS_DATA),
+		   AR_EEPROM_STATUS_DATA_VAL);
+
+	return true;
+}
+
 static struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
+	.eeprom_read = ath_pci_eeprom_read,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/include/linux/ath9k_platform.h b/include/linux/ath9k_platform.h
new file mode 100644
index 0000000..b847fc7
--- /dev/null
+++ b/include/linux/ath9k_platform.h
@@ -0,0 +1,28 @@
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
+#ifndef _LINUX_ATH9K_PLATFORM_H
+#define _LINUX_ATH9K_PLATFORM_H
+
+#define ATH9K_PLAT_EEP_MAX_WORDS	2048
+
+struct ath9k_platform_data {
+	u16 eeprom_data[ATH9K_PLAT_EEP_MAX_WORDS];
+};
+
+#endif /* _LINUX_ATH9K_PLATFORM_H */
-- 
1.5.3.2

