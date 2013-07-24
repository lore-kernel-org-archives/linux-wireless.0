Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40332 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab3GXIZA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 04:25:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Add PCI IDs that support WLAN/BT RX diversity
Date: Wed, 24 Jul 2013 13:51:30 +0530
Message-Id: <1374654090-24408-5-git-send-email-sujith@msujith.org> (sfid-20130724_102516_843115_36408C94)
In-Reply-To: <1374654090-24408-1-git-send-email-sujith@msujith.org>
References: <1374654090-24408-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index c585c9b..ad48702 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -40,29 +40,29 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
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
@@ -138,7 +138,11 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
 	{ PCI_VDEVICE(ATHEROS, 0x0037) }, /* PCI-E  AR1111/AR9485 */
-	{ PCI_VDEVICE(ATHEROS, 0x0036) }, /* PCI-E  AR9565 */
+
+	/* PCI-E AR9565 */
+	{ PCI_VDEVICE(ATHEROS, 0x0036),
+	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
+
 	{ 0 }
 };
 
-- 
1.8.3.3

