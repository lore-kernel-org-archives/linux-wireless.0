Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:46010 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab3HYLE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Aug 2013 07:04:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Fix ASPM workaround usage
Date: Sun, 25 Aug 2013 16:30:40 +0530
Message-Id: <1377428440-32005-1-git-send-email-sujith@msujith.org> (sfid-20130825_130441_991738_95057352)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The PCIE Workaround register (AR_WA/0x4004) is used to handle
various hardware quirks. For AR9002 chips, AR_WA_D3_L1_DISABLE
is used to prevent the HW from automatically entering L1 state
when D3 is enforced.

AR_WA_D3_L1_DISABLE has to be enabled for a few AR9280 based
cards, mark them based on their PCI subdevice/subvendor IDs
and enforce it in ar9002_hw_configpcipowersave().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c | 29 +++++++------------
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |  7 +----
 drivers/net/wireless/ath/ath9k/ath9k.h     |  1 +
 drivers/net/wireless/ath/ath9k/hw.c        |  1 -
 drivers/net/wireless/ath/ath9k/init.c      |  5 ++++
 drivers/net/wireless/ath/ath9k/pci.c       | 46 ++++++++++++++++++++++++++++++
 6 files changed, 64 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 8dc2d08..fb61b08 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -269,13 +269,12 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 			if (ah->config.pcie_waen & AR_WA_D3_L1_DISABLE)
 				val |= AR_WA_D3_L1_DISABLE;
 		} else {
-			if (((AR_SREV_9285(ah) ||
-			      AR_SREV_9271(ah) ||
-			      AR_SREV_9287(ah)) &&
-			     (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)) ||
-			    (AR_SREV_9280(ah) &&
-			     (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE))) {
-				val |= AR_WA_D3_L1_DISABLE;
+			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah)) {
+				if (AR9285_WA_DEFAULT & AR_WA_D3_L1_DISABLE)
+					val |= AR_WA_D3_L1_DISABLE;
+			} else if (AR_SREV_9280(ah)) {
+				if (AR9280_WA_DEFAULT & AR_WA_D3_L1_DISABLE)
+					val |= AR_WA_D3_L1_DISABLE;
 			}
 		}
 
@@ -297,24 +296,18 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 	} else {
 		if (ah->config.pcie_waen) {
 			val = ah->config.pcie_waen;
-			if (!power_off)
-				val &= (~AR_WA_D3_L1_DISABLE);
+			val &= (~AR_WA_D3_L1_DISABLE);
 		} else {
-			if (AR_SREV_9285(ah) ||
-			    AR_SREV_9271(ah) ||
-			    AR_SREV_9287(ah)) {
+			if (AR_SREV_9285(ah) || AR_SREV_9271(ah) || AR_SREV_9287(ah)) {
 				val = AR9285_WA_DEFAULT;
-				if (!power_off)
-					val &= (~AR_WA_D3_L1_DISABLE);
-			}
-			else if (AR_SREV_9280(ah)) {
+				val &= (~AR_WA_D3_L1_DISABLE);
+			} else if (AR_SREV_9280(ah)) {
 				/*
 				 * For AR9280 chips, bit 22 of 0x4004
 				 * needs to be set.
 				 */
 				val = AR9280_WA_DEFAULT;
-				if (!power_off)
-					val &= (~AR_WA_D3_L1_DISABLE);
+				val &= (~AR_WA_D3_L1_DISABLE);
 			} else {
 				val = AR_WA_DEFAULT;
 			}
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 582cddd..608bb48 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -763,12 +763,7 @@ static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
 	if (!power_off /* !restore */) {
 		/* set bit 19 to allow forcing of pcie core into L1 state */
 		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
-
-		/* Several PCIe massages to ensure proper behaviour */
-		if (ah->config.pcie_waen)
-			REG_WRITE(ah, AR_WA, ah->config.pcie_waen);
-		else
-			REG_WRITE(ah, AR_WA, ah->WARegVal);
+		REG_WRITE(ah, AR_WA, ah->WARegVal);
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8519e75..2ee35f6 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -631,6 +631,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define ATH9K_PCI_CUS217     0x0004
 #define ATH9K_PCI_WOW        0x0008
 #define ATH9K_PCI_BT_ANT_DIV 0x0010
+#define ATH9K_PCI_D3_L1_WAR  0x0020
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index b3a6891..2670bf6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -450,7 +450,6 @@ static void ath9k_hw_init_config(struct ath_hw *ah)
 	ah->config.ack_6mb = 0x0;
 	ah->config.cwm_ignore_extcca = 0;
 	ah->config.pcie_clock_req = 0;
-	ah->config.pcie_waen = 0;
 	ah->config.analog_shiftreg = 1;
 
 	for (i = 0; i < AR_EEPROM_MODAL_SPURS; i++) {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index b897183..9a1f349 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -551,6 +551,11 @@ static void ath9k_init_platform(struct ath_softc *sc)
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_ANT_DIV;
 		ath_info(common, "Set BT/WLAN RX diversity capability\n");
 	}
+
+	if (sc->driver_data & ATH9K_PCI_D3_L1_WAR) {
+		ah->config.pcie_waen = 0x0040473b;
+		ath_info(common, "Enable WAR for ASPM D3/L1\n");
+	}
 }
 
 static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index e7996a6..d089a7c 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -30,6 +30,52 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
 
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1C71),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE01F),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x11AD, /* LITEON */
+			 0x6632),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x11AD, /* LITEON */
+			 0x6642),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 PCI_VENDOR_ID_QMI,
+			 0x0306),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x185F, /* WNC */
+			 0x309D),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x10CF, /* Fujitsu */
+			 0x147C),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x10CF, /* Fujitsu */
+			 0x147D),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002A,
+			 0x10CF, /* Fujitsu */
+			 0x1536),
+	  .driver_data = ATH9K_PCI_D3_L1_WAR },
+
 	/* AR9285 card for Asus */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x002B,
-- 
1.8.3.4

