Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:51586 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3IBHKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Sep 2013 03:10:23 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Identify WB335 Antenna configuration
Date: Mon,  2 Sep 2013 12:36:36 +0530
Message-Id: <1378105596-26994-1-git-send-email-sujith@msujith.org> (sfid-20130902_091026_390961_C6F0345E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

There are 2 types of WB335 cards, 1-antenna and 2-antenna.
Identify them based on PCI subsystem IDs, this will be used
for MCI/BTCOEX tweaks.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  16 +--
 drivers/net/wireless/ath/ath9k/init.c  |   6 ++
 drivers/net/wireless/ath/ath9k/pci.c   | 172 ++++++++++++++++++++++++++++++++-
 3 files changed, 185 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 585c310..5fd4294 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -625,13 +625,15 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 /* Main driver core */
 /********************/
 
-#define ATH9K_PCI_CUS198     0x0001
-#define ATH9K_PCI_CUS230     0x0002
-#define ATH9K_PCI_CUS217     0x0004
-#define ATH9K_PCI_CUS252     0x0008
-#define ATH9K_PCI_WOW        0x0010
-#define ATH9K_PCI_BT_ANT_DIV 0x0020
-#define ATH9K_PCI_D3_L1_WAR  0x0040
+#define ATH9K_PCI_CUS198      0x0001
+#define ATH9K_PCI_CUS230      0x0002
+#define ATH9K_PCI_CUS217      0x0004
+#define ATH9K_PCI_CUS252      0x0008
+#define ATH9K_PCI_WOW         0x0010
+#define ATH9K_PCI_BT_ANT_DIV  0x0020
+#define ATH9K_PCI_D3_L1_WAR   0x0040
+#define ATH9K_PCI_AR9565_1ANT 0x0080
+#define ATH9K_PCI_AR9565_2ANT 0x0100
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4fe0535..ee8fc9d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -550,6 +550,12 @@ static void ath9k_init_platform(struct ath_softc *sc)
 	if (sc->driver_data & ATH9K_PCI_CUS252)
 		ath_info(common, "CUS252 card detected\n");
 
+	if (sc->driver_data & ATH9K_PCI_AR9565_1ANT)
+		ath_info(common, "WB335 1-ANT card detected\n");
+
+	if (sc->driver_data & ATH9K_PCI_AR9565_2ANT)
+		ath_info(common, "WB335 2-ANT card detected\n");
+
 	if (sc->driver_data & ATH9K_PCI_BT_ANT_DIV) {
 		pCap->hw_caps |= ATH9K_HW_CAP_BT_ANT_DIV;
 		ath_info(common, "Set BT/WLAN RX diversity capability\n");
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 465574b..d66f500 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -275,12 +275,180 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x0036,
 			 PCI_VENDOR_ID_ATHEROS,
 			 0x3028),
-	  .driver_data = ATH9K_PCI_CUS252 | ATH9K_PCI_BT_ANT_DIV },
+	  .driver_data = ATH9K_PCI_CUS252 |
+			 ATH9K_PCI_AR9565_2ANT |
+			 ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2176),
-	  .driver_data = ATH9K_PCI_CUS252 | ATH9K_PCI_BT_ANT_DIV },
+	  .driver_data = ATH9K_PCI_CUS252 |
+			 ATH9K_PCI_AR9565_2ANT |
+			 ATH9K_PCI_BT_ANT_DIV },
+
+	/* WB335 1-ANT */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3025),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3026),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x302B),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE069),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE068),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x185F, /* WNC */
+			 0x3028),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x185F, /* WNC */
+			 0xA119),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0632),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0622),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x6671),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0672),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0662),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x1B9A, /* XAVI */
+			 0x2811),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x1B9A, /* XAVI */
+			 0x2812),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x213A),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x3026),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_HP,
+			 0x18E3),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_HP,
+			 0x217F),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
+
+	/* WB335 2-ANT */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3027),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x302C),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x411A),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x411B),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x411C),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x411D),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_SAMSUNG,
+			 0x411E),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0642),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0652),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0612),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2130),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x144F, /* ASKEY */
+			 0x7202),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x1B9A, /* XAVI */
+			 0x2810),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x185F, /* WNC */
+			 0x3027),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 
 	/* PCI-E AR9565 (WB335) */
 	{ PCI_VDEVICE(ATHEROS, 0x0036),
-- 
1.8.4

