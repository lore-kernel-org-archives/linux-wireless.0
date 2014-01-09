Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:40054 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaAID01 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jan 2014 22:26:27 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [PATCH v2 1/3] ath9k: Update WB335 PCI IDs
Date: Thu,  9 Jan 2014 08:51:13 +0530
Message-Id: <1389237675-32658-1-git-send-email-sujith@msujith.org> (sfid-20140109_042631_018417_DEFD61E8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

* Add new AR9565 1.0/1.0.1/1.1 IDs
* Change Dell/Lenovo/Samsung cards to 2-Antenna with diversity.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c | 101 ++++++++++++++++++++++++++++-------
 1 file changed, 82 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index e9a5857..55724b0 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -412,6 +412,16 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 0x11AD, /* LITEON */
+			 0x06B2),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0842),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
 			 0x6671),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
@@ -424,6 +434,16 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x1B9A, /* XAVI */
 			 0x2812),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x1B9A, /* XAVI */
+			 0x28A1),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x218A),
+	  .driver_data = ATH9K_PCI_AR9565_1ANT },
 
 	/* WB335 1-ANT / Antenna Diversity */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
@@ -469,22 +489,17 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 0x11AD, /* LITEON */
-			 0x0682),
+			 0x06A2),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
-			 PCI_VENDOR_ID_AZWAVE,
-			 0x213A),
-	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
-	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
-			 0x0036,
-			 PCI_VENDOR_ID_LENOVO,
-			 0x3026),
+			 0x11AD, /* LITEON */
+			 0x0682),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
-			 PCI_VENDOR_ID_LENOVO,
-			 0x4026),
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x213A),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
@@ -504,37 +519,35 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_DELL,
-			 0x020E),
+			 0x020C),
 	  .driver_data = ATH9K_PCI_AR9565_1ANT | ATH9K_PCI_BT_ANT_DIV },
 
-	/* WB335 2-ANT */
+	/* WB335 2-ANT / Antenna-Diversity */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_SAMSUNG,
 			 0x411A),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT },
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_SAMSUNG,
 			 0x411B),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT },
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_SAMSUNG,
 			 0x411C),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT },
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_SAMSUNG,
 			 0x411D),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT },
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_SAMSUNG,
 			 0x411E),
-	  .driver_data = ATH9K_PCI_AR9565_2ANT },
-
-	/* WB335 2-ANT / Antenna-Diversity */
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
 			 PCI_VENDOR_ID_ATHEROS,
@@ -562,11 +575,31 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0832),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 0x11AD, /* LITEON */
+			 0x0692),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2130),
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x213B),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2182),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
 			 0x144F, /* ASKEY */
 			 0x7202),
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
@@ -577,6 +610,11 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0036,
+			 0x1B9A, /* XAVI */
+			 0x28A2),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
 			 0x185F, /* WNC */
 			 0x3027),
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
@@ -590,6 +628,31 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 PCI_VENDOR_ID_FOXCONN,
 			 0xE07F),
 	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE081),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x3026),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_LENOVO,
+			 0x4026),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_ASUSTEK,
+			 0x85F2),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0036,
+			 PCI_VENDOR_ID_DELL,
+			 0x020E),
+	  .driver_data = ATH9K_PCI_AR9565_2ANT | ATH9K_PCI_BT_ANT_DIV },
 
 	/* PCI-E AR9565 (WB335) */
 	{ PCI_VDEVICE(ATHEROS, 0x0036),
-- 
1.8.5.2

