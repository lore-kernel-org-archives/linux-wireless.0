Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54715 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab3JWJU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Oct 2013 05:20:26 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Identify Killer Wireless cards
Date: Wed, 23 Oct 2013 14:46:11 +0530
Message-Id: <1382519771-11170-1-git-send-email-sujith@msujith.org> (sfid-20131023_112029_323527_457FF2AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  3 +++
 drivers/net/wireless/ath/ath9k/pci.c   | 20 ++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4c3bbe4..f48cfe8 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -641,6 +641,7 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define ATH9K_PCI_D3_L1_WAR   0x0040
 #define ATH9K_PCI_AR9565_1ANT 0x0080
 #define ATH9K_PCI_AR9565_2ANT 0x0100
+#define ATH9K_PCI_KILLER      0x0200
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index e89db64..17502b4 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -589,6 +589,9 @@ static void ath9k_init_platform(struct ath_softc *sc)
 	if (sc->driver_data & ATH9K_PCI_AR9565_2ANT)
 		ath_info(common, "WB335 2-ANT card detected\n");
 
+	if (sc->driver_data & ATH9K_PCI_KILLER)
+		ath_info(common, "Killer Wireless card detected\n");
+
 	/*
 	 * Some WB335 cards do not support antenna diversity. Since
 	 * we use a hardcoded value for AR9565 instead of using the
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 04e6507..4a7a456 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -87,6 +87,19 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
+
+	/* Killer Wireless (3x3) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0030,
+			 0x1A56,
+			 0x2000),
+	  .driver_data = ATH9K_PCI_KILLER },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0030,
+			 0x1A56,
+			 0x2001),
+	  .driver_data = ATH9K_PCI_KILLER },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
 
 	/* PCI-E CUS198 */
@@ -267,6 +280,13 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x1783),
 	  .driver_data = ATH9K_PCI_WOW },
 
+	/* Killer Wireless (2x2) */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0030,
+			 0x1A56,
+			 0x2003),
+	  .driver_data = ATH9K_PCI_KILLER },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 
-- 
1.8.4.1

