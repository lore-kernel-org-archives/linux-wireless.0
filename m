Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:48279 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3KHGT4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 01:19:56 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath9k: Use correct PCIE initvals for AR9485
Date: Fri,  8 Nov 2013 11:45:25 +0530
Message-Id: <1383891325-10258-1-git-send-email-sujith@msujith.org> (sfid-20131108_072000_111707_DCAC4B7E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Currently, the PLL is turned off for AR9485 when
switching to a low power state, but AR9485 has an issue
where the card will become unresponsive if left idle
for a long time without any traffic. To fix this,
force the PLL to always be on using a different initval
array, ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1.

This is done for most of the AR9485 based cards
like HB125, WB225 etc. but certain models require the
feature to be turned off. Identify such cards and use
default values for them.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c       | 22 +++---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 42 ++++--------
 drivers/net/wireless/ath/ath9k/ath9k.h           | 21 +++---
 drivers/net/wireless/ath/ath9k/hw.h              |  1 +
 drivers/net/wireless/ath/ath9k/init.c            |  5 ++
 drivers/net/wireless/ath/ath9k/pci.c             | 87 ++++++++++++++++++++++++
 6 files changed, 129 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index f281bad..33f63dc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -187,17 +187,17 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		INIT_INI_ARRAY(&ah->iniCckfirJapan2484,
 			       ar9485_1_1_baseband_core_txfir_coeff_japan_2484);
 
-		/* Load PCIE SERDES settings from INI */
-
-		/* Awake Setting */
-
-		INIT_INI_ARRAY(&ah->iniPcieSerdes,
-				ar9485_1_1_pcie_phy_clkreq_disable_L1);
-
-		/* Sleep Setting */
-
-		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				ar9485_1_1_pcie_phy_clkreq_disable_L1);
+		if (ah->config.no_pll_pwrsave) {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9485_1_1_pcie_phy_clkreq_disable_L1);
+		} else {
+			INIT_INI_ARRAY(&ah->iniPcieSerdes,
+				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
+			INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
+				       ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1);
+		}
 	} else if (AR_SREV_9462_21(ah)) {
 		INIT_INI_ARRAY(&ah->iniMac[ATH_INI_CORE],
 			       ar9462_2p1_mac_core);
diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index 6f899c6..7c18452 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -32,13 +32,6 @@ static const u32 ar9485_1_1_mac_postamble[][5] = {
 	{0x00008318, 0x00003e80, 0x00007d00, 0x00006880, 0x00003440},
 };
 
-static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18012e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485Common_wo_xlna_rx_gain_1_1[][2] = {
 	/* Addr      allmodes  */
 	{0x00009e00, 0x037216a0},
@@ -1101,20 +1094,6 @@ static const u32 ar9485_common_rx_gain_1_1[][2] = {
 	{0x0000a1fc, 0x00000296},
 };
 
-static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18052e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
-static const u32 ar9485_1_1_pcie_phy_clkreq_enable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18053e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485_1_1_soc_preamble[][2] = {
 	/* Addr      allmodes  */
 	{0x00004014, 0xba280400},
@@ -1173,13 +1152,6 @@ static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	{0x0000be18, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 };
 
-static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
-	/* Addr      allmodes  */
-	{0x00018c00, 0x18013e5e},
-	{0x00018c04, 0x000801d8},
-	{0x00018c08, 0x0000080c},
-};
-
 static const u32 ar9485_1_1_radio_postamble[][2] = {
 	/* Addr      allmodes  */
 	{0x0001609c, 0x0b283f31},
@@ -1358,4 +1330,18 @@ static const u32 ar9485_1_1_baseband_core_txfir_coeff_japan_2484[][2] = {
 	{0x0000a3a0, 0xca9228ee},
 };
 
+static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
+	/* Addr      allmodes  */
+	{0x00018c00, 0x18013e5e},
+	{0x00018c04, 0x000801d8},
+	{0x00018c08, 0x0000080c},
+};
+
+static const u32 ar9485_1_1_pll_on_cdr_on_clkreq_disable_L1[][2] = {
+	/* Addr      allmodes  */
+	{0x00018c00, 0x1801265e},
+	{0x00018c04, 0x000801d8},
+	{0x00018c08, 0x0000080c},
+};
+
 #endif /* INITVALS_9485_H */
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b351df3..a085ec4 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -660,16 +660,17 @@ void ath_ant_comb_scan(struct ath_softc *sc, struct ath_rx_status *rs);
 /* Main driver core */
 /********************/
 
-#define ATH9K_PCI_CUS198      0x0001
-#define ATH9K_PCI_CUS230      0x0002
-#define ATH9K_PCI_CUS217      0x0004
-#define ATH9K_PCI_CUS252      0x0008
-#define ATH9K_PCI_WOW         0x0010
-#define ATH9K_PCI_BT_ANT_DIV  0x0020
-#define ATH9K_PCI_D3_L1_WAR   0x0040
-#define ATH9K_PCI_AR9565_1ANT 0x0080
-#define ATH9K_PCI_AR9565_2ANT 0x0100
-#define ATH9K_PCI_KILLER      0x0200
+#define ATH9K_PCI_CUS198          0x0001
+#define ATH9K_PCI_CUS230          0x0002
+#define ATH9K_PCI_CUS217          0x0004
+#define ATH9K_PCI_CUS252          0x0008
+#define ATH9K_PCI_WOW             0x0010
+#define ATH9K_PCI_BT_ANT_DIV      0x0020
+#define ATH9K_PCI_D3_L1_WAR       0x0040
+#define ATH9K_PCI_AR9565_1ANT     0x0080
+#define ATH9K_PCI_AR9565_2ANT     0x0100
+#define ATH9K_PCI_KILLER          0x0200
+#define ATH9K_PCI_NO_PLL_PWRSAVE  0x0400
 
 /*
  * Default cache line size, in bytes.
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 289e5ce..e508436 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -315,6 +315,7 @@ struct ath9k_ops_config {
 	u32 ant_ctrl_comm2g_switch_enable;
 	bool xatten_margin_cfg;
 	bool alt_mingainidx;
+	bool no_pll_pwrsave;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 6ca7177..eb46b7d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -612,6 +612,11 @@ static void ath9k_init_platform(struct ath_softc *sc)
 		ah->config.pcie_waen = 0x0040473b;
 		ath_info(common, "Enable WAR for ASPM D3/L1\n");
 	}
+
+	if (sc->driver_data & ATH9K_PCI_NO_PLL_PWRSAVE) {
+		ah->config.no_pll_pwrsave = true;
+		ath_info(common, "Disable PLL PowerSave\n");
+	}
 }
 
 static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 4a7a456..e9a5857 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -208,6 +208,93 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 			 0x3219),
 	  .driver_data = ATH9K_PCI_BT_ANT_DIV },
 
+	/* AR9485 cards with PLL power-save disabled by default. */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2C97),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2100),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x1C56, /* ASKEY */
+			 0x4001),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x11AD, /* LITEON */
+			 0x6627),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x11AD, /* LITEON */
+			 0x6628),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE04E),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE04F),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x144F, /* ASKEY */
+			 0x7197),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x1B9A, /* XAVI */
+			 0x2000),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x1B9A, /* XAVI */
+			 0x2001),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1186),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1F86),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1195),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1F95),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x1B9A, /* XAVI */
+			 0x1C00),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 0x1B9A, /* XAVI */
+			 0x1C01),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_ASUSTEK,
+			 0x850D),
+	  .driver_data = ATH9K_PCI_NO_PLL_PWRSAVE },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 
-- 
1.8.4.2

