Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40179 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab3FRKPh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 06:15:37 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] ath9k: Add PCI IDs for CUS217
Date: Tue, 18 Jun 2013 15:42:36 +0530
Message-Id: <1371550358-5920-1-git-send-email-sujith@msujith.org> (sfid-20130618_121551_786834_0DE8A7A1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CUS217 is a card based on AR9462.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  2 ++
 drivers/net/wireless/ath/ath9k/pci.c   | 13 +++++++++++++
 3 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1a0a168..04b2d3e 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -633,6 +633,7 @@ void ath_ant_comb_update(struct ath_softc *sc);
 
 #define ATH9K_PCI_CUS198 0x0001
 #define ATH9K_PCI_CUS230 0x0002
+#define ATH9K_PCI_CUS217 0x0004
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 0d17415..1e555d8 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -529,6 +529,8 @@ static void ath9k_init_platform(struct ath_softc *sc)
 		ath_info(common, "Set parameters for %s\n",
 			 (sc->driver_data & ATH9K_PCI_CUS198) ?
 			 "CUS198" : "CUS230");
+	} else if (sc->driver_data & ATH9K_PCI_CUS217) {
+		ath_info(common, "CUS217 card detected\n");
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index ddf0d78..b096bb2 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -66,6 +66,19 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
+
+	/* PCI-E CUS217 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2116),
+	  .driver_data = ATH9K_PCI_CUS217 },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x11AD, /* LITEON */
+			 0x6661),
+	  .driver_data = ATH9K_PCI_CUS217 },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0036) }, /* PCI-E  AR9565 */
-- 
1.8.3.1

