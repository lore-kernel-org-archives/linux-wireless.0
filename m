Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:33144 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbYKCUs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 15:48:57 -0500
Message-ID: <490F63B6.8080600@free.fr> (sfid-20081103_214902_121740_0BFDC4CE)
Date: Mon, 03 Nov 2008 21:48:54 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k : Display MAC/BB and RF version at startup
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch decodes the MAC/BB version (for instance: AR5416) and the RF
part version (for instance: AR5133). It has been tested on AR5416/AR5133
which is a 2.4/5GHz 3x3 11n device. It also makes the differences
between AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
the register definitions.

Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

diff --git a/drivers/net/wireless/ath9k/hw.c
b/drivers/net/wireless/ath9k/hw.c
index ded9453..f2916a5 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -382,8 +382,9 @@ static const char *ath9k_hw_devname(u16 devid)
 {
 	switch (devid) {
 	case AR5416_DEVID_PCI:
-	case AR5416_DEVID_PCIE:
 		return "Atheros 5416";
+	case AR5416_DEVID_PCIE:
+		return "Atheros 5418";
 	case AR9160_DEVID_PCI:
 		return "Atheros 9160";
 	case AR9280_DEVID_PCI:
diff --git a/drivers/net/wireless/ath9k/main.c
b/drivers/net/wireless/ath9k/main.c
index c67dadc..7c53ea8 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -18,6 +18,7 @@

 #include <linux/nl80211.h>
 #include "core.h"
+#include "reg.h"

 #define ATH_PCI_VERSION "0.1"

@@ -1524,10 +1525,11 @@ static int ath_pci_probe(struct pci_dev *pdev,
const struct pci_device_id *id)
 	void __iomem *mem;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
-	const char *athname;
 	u8 csz;
 	u32 val;
 	int ret = 0;
+	struct ath_hal *ah;
+	u16 macVersion, rfVersion;

 	if (pci_enable_device(pdev))
 		return -EIO;
@@ -1614,11 +1616,26 @@ static int ath_pci_probe(struct pci_dev *pdev,
const struct pci_device_id *id)
 		goto bad4;
 	}

-	athname = ath9k_hw_probe(id->vendor, id->device);
-
-	printk(KERN_INFO "%s: %s: mem=0x%lx, irq=%d\n",
+	ah = sc->sc_ah;
+	macVersion = ah->ah_macVersion;
+	rfVersion  = (ah->ah_analog5GhzRev & AR_RADIO_SREV_MAJOR);
+	printk(KERN_INFO
+	       "%s: Atheros AR%s%s%s%s%s%s MAC/BB Rev:%x "
+	       "AR%s%s%s%s%s RF Rev:%x: mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       athname ? athname : "Atheros ???",
+	       macVersion == AR_SREV_VERSION_5416_PCI  ? "5416" : "",
+	       macVersion == AR_SREV_VERSION_5416_PCIE ? "5418" : "",
+	       macVersion == AR_SREV_VERSION_9100      ? "9100" : "",
+	       macVersion == AR_SREV_VERSION_9160      ? "9160" : "",
+	       macVersion == AR_SREV_VERSION_9280      ? "9280" : "",
+	       macVersion == AR_SREV_VERSION_9285      ? "9285" : "",
+	       ah->ah_macRev,
+	       rfVersion  == 0                         ? "5133" : "",
+	       rfVersion  == AR_RAD5133_SREV_MAJOR     ? "5133" : "",
+	       rfVersion  == AR_RAD5122_SREV_MAJOR     ? "5122" : "",
+	       rfVersion  == AR_RAD2133_SREV_MAJOR     ? "2133" : "",
+	       rfVersion  == AR_RAD2122_SREV_MAJOR     ? "2122" : "",
+	       ah->ah_phyRev,
 	       (unsigned long)mem, pdev->irq);

 	return 0;
