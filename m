Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:44513 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab3IBIdG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 04:33:06 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2 7/8] ath9k: Identify CUS252 cards
Date: Mon,  2 Sep 2013 13:59:05 +0530
Message-Id: <1378110546-22305-7-git-send-email-sujith@msujith.org> (sfid-20130902_103315_575999_9B204E54)
In-Reply-To: <1378110546-22305-1-git-send-email-sujith@msujith.org>
References: <21028.19411.335796.192256@gargle.gargle.HOWL>
 <1378110546-22305-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

These cards are based on WB335/AR9565.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  7 ++++---
 drivers/net/wireless/ath/ath9k/init.c  |  3 +++
 drivers/net/wireless/ath/ath9k/pci.c   | 12 ++++++++++++
 3 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 74a8770..585c310 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -628,9 +628,10 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 #define ATH9K_PCI_CUS198     0x0001
 #define ATH9K_PCI_CUS230     0x0002
 #define ATH9K_PCI_CUS217     0x0004
-#define ATH9K_PCI_WOW        0x0008
-#define ATH9K_PCI_BT_ANT_DIV 0x0010
-#define ATH9K_PCI_D3_L1_WAR  0x0020
+#define ATH9K_PCI_CUS252     0x0008
+#define ATH9K_PCI_WOW        0x0010
+#define ATH9K_PCI_BT_ANT_DIV 0x0020
+#define ATH9K_PCI_D3_L1_WAR  0x0040
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9a1f349..4fe0535 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -547,6 +547,9 @@ static void ath9k_init_platform(struct ath_softc *sc)
 	if (sc->driver_data & ATH9K_PCI_CUS217)
 		ath_info(common, "CUS217 card detected\n");
 
+	if (sc->driver_data & ATH9K_PCI_CUS252)
+		ath_info(common, "CUS252 card detected\n");
+
 	if (sc->driver_data & ATH9K_PCI_BT_ANT_DIV) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_ANT_DIV;
 		ath_info(common, "Set BT/WLAN RX diversity capability\n");
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index b43a2ec..465574b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -270,6 +270,18 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 
+	/* CUS252 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3028),
+	  .driver_data = ATH9K_PCI_CUS252 | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2176),
+	  .driver_data = ATH9K_PCI_CUS252 | ATH9K_PCI_BT_ANT_DIV },
+
 	/* PCI-E AR9565 (WB335) */
 	{ PCI_VDEVICE(ATHEROS, 0x0036),
 	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
-- 
1.8.4

