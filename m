Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:41346 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751964Ab3FREqv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 00:46:51 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] ath9k: Modify IDs to identify CUS230
Date: Tue, 18 Jun 2013 10:13:43 +0530
Message-Id: <1371530623-15746-5-git-send-email-sujith@msujith.org> (sfid-20130618_064653_721327_B8CDD478)
In-Reply-To: <1371530623-15746-1-git-send-email-sujith@msujith.org>
References: <1371530623-15746-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CUS198 and CUS230 are similar cards, both
are AR9485 + xLNA solutions. But, the subsystem IDs
differ - identify CUS230 explicitly to make things
clearer.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 1 +
 drivers/net/wireless/ath/ath9k/init.c  | 7 +++++--
 drivers/net/wireless/ath/ath9k/pci.c   | 6 ++++--
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 74965ee..1a0a168 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -632,6 +632,7 @@ void ath_ant_comb_update(struct ath_softc *sc);
 /********************/
 
 #define ATH9K_PCI_CUS198 0x0001
+#define ATH9K_PCI_CUS230 0x0002
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 7c2ed1c..0d17415 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -521,11 +521,14 @@ static void ath9k_init_platform(struct ath_softc *sc)
 	if (common->bus_ops->ath_bus_type != ATH_PCI)
 		return;
 
-	if (sc->driver_data & ATH9K_PCI_CUS198) {
+	if (sc->driver_data & (ATH9K_PCI_CUS198 |
+			       ATH9K_PCI_CUS230)) {
 		ah->config.xlna_gpio = 9;
 		ah->config.xatten_margin_cfg = true;
 
-		ath_info(common, "Set parameters for CUS198\n");
+		ath_info(common, "Set parameters for %s\n",
+			 (sc->driver_data & ATH9K_PCI_CUS198) ?
+			 "CUS198" : "CUS230");
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 4ac00b4..ddf0d78 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -51,16 +51,18 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2126),
 	  .driver_data = ATH9K_PCI_CUS198 },
+
+	/* PCI-E CUS230 */
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_AZWAVE,
 			 0x2152),
-	  .driver_data = ATH9K_PCI_CUS198 },
+	  .driver_data = ATH9K_PCI_CUS230 },
 	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
 			 0x0032,
 			 PCI_VENDOR_ID_FOXCONN,
 			 0xE075),
-	  .driver_data = ATH9K_PCI_CUS198 },
+	  .driver_data = ATH9K_PCI_CUS230 },
 
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
-- 
1.8.3.1

