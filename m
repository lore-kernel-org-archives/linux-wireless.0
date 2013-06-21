Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:33133 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161096Ab3FUFow (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jun 2013 01:44:52 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Enable WoW only for supported models
Date: Fri, 21 Jun 2013 11:11:52 +0530
Message-Id: <1371793312-15929-1-git-send-email-sujith@msujith.org> (sfid-20130621_074501_290756_E6E83C75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Since platform support is required for WoW, identify and
and enable Wow only for supported cards.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/init.c  |  1 +
 drivers/net/wireless/ath/ath9k/pci.c   | 57 ++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 04b2d3e..c1224b5 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -634,6 +634,7 @@ void ath_ant_comb_update(struct ath_softc *sc);
 #define ATH9K_PCI_CUS198 0x0001
 #define ATH9K_PCI_CUS230 0x0002
 #define ATH9K_PCI_CUS217 0x0004
+#define ATH9K_PCI_WOW    0x0008
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 1e555d8..16f8b20 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -837,6 +837,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 #ifdef CONFIG_PM_SLEEP
 	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
+	    (sc->driver_data & ATH9K_PCI_WOW) &&
 	    device_can_wakeup(sc->dev))
 		hw->wiphy->wowlan = &ath9k_wowlan_support;
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index b096bb2..c585c9b 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -79,6 +79,63 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x6661),
 	  .driver_data = ATH9K_PCI_CUS217 },
 
+	/* AR9462 with WoW support */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_ATHEROS,
+			 0x3117),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x3214),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_ATTANSIC,
+			 0x0091),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2110),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_ASUSTEK,
+			 0x850E),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x11AD, /* LITEON */
+			 0x6631),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x11AD, /* LITEON */
+			 0x6641),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 PCI_VENDOR_ID_HP,
+			 0x1864),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x14CD, /* USI */
+			 0x0063),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x14CD, /* USI */
+			 0x0064),
+	  .driver_data = ATH9K_PCI_WOW },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0034,
+			 0x10CF, /* Fujitsu */
+			 0x1783),
+	  .driver_data = ATH9K_PCI_WOW },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0036) }, /* PCI-E  AR9565 */
-- 
1.8.3.1

