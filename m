Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40884 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab3HDIzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Aug 2013 04:55:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] ath9k: Enable WLAN/BT Ant Diversity for WB225/WB195
Date: Sun,  4 Aug 2013 14:21:58 +0530
Message-Id: <1375606322-9983-7-git-send-email-sujith@msujith.org> (sfid-20130804_105613_831746_4DC43BB1)
In-Reply-To: <1375606322-9983-1-git-send-email-sujith@msujith.org>
References: <1375606322-9983-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

A custom solution for Asus is WB195 based and supports
WLAN/BT Rx diversity. Identify this card and set the
capability.

CUS198/CUS230, which are based on WB225 also support
WLAN/BT Rx diversity.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c585c9b..30652b4 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -29,6 +29,14 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x0027) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x0029) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002A) }, /* PCI-E */
+
+	/* AR9285 card for Asus */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x002B,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2C37),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+
 	{ PCI_VDEVICE(ATHEROS, 0x002B) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x002C) }, /* PCI-E 802.11n bonded out */
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
@@ -40,29 +48,29 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x0032,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2086),
-	  .driver_data = ATH9K_PCI_CUS198 },
+	  .driver_data = ATH9K_PCI_CUS198 | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x1237),
-	  .driver_data = ATH9K_PCI_CUS198 },
+	  .driver_data = ATH9K_PCI_CUS198 | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2126),
-	  .driver_data = ATH9K_PCI_CUS198 },
+	  .driver_data = ATH9K_PCI_CUS198 | ATH9K_PCI_BT_ANT_DIV },
 
 	/* PCI-E CUS230 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2152),
-	  .driver_data = ATH9K_PCI_CUS230 },
+	  .driver_data = ATH9K_PCI_CUS230 | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_FOXCONN,
 			 0xE075),
-	  .driver_data = ATH9K_PCI_CUS230 },
+	  .driver_data = ATH9K_PCI_CUS230 | ATH9K_PCI_BT_ANT_DIV },
 
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
-- 
1.8.3.4

