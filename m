Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:47234 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3FMRXi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:23:38 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add custom parameters for CUS198
Date: Thu, 13 Jun 2013 22:50:39 +0530
Message-Id: <1371144039-10042-1-git-send-email-sujith@msujith.org> (sfid-20130613_192342_337079_BDB334AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

CUS198 is a card based on AR9485. There are differences
between the base reference design HB125 and CUS198.
Identify such cards based on the PCI subsystem IDs and
set HW parameters appropriately.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c | 18 +++++++++++++---
 drivers/net/wireless/ath/ath9k/ath9k.h         |  3 +++
 drivers/net/wireless/ath/ath9k/hw.h            |  4 ++++
 drivers/net/wireless/ath/ath9k/init.c          | 21 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/pci.c           | 29 ++++++++++++++++++++++++++
 5 files changed, 72 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 25b8bbb..9a00bc0 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -3563,16 +3563,22 @@ static void ar9003_hw_ant_ctrl_apply(struct ath_hw *ah, bool is2ghz)
 {
 	struct ath9k_hw_capabilities *pCap = &ah->caps;
 	int chain;
-	u32 regval, value;
+	u32 regval, value, gpio;
 	static const u32 switch_chain_reg[AR9300_MAX_CHAINS] = {
 			AR_PHY_SWITCH_CHAIN_0,
 			AR_PHY_SWITCH_CHAIN_1,
 			AR_PHY_SWITCH_CHAIN_2,
 	};
 
-	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0))
+	if (AR_SREV_9485(ah) && (ar9003_hw_get_rx_gain_idx(ah) == 0)) {
+		if (ah->config.xlna_gpio)
+			gpio = ah->config.xlna_gpio;
+		else
+			gpio = AR9300_EXT_LNA_CTL_GPIO_AR9485;
+
 		ath9k_hw_cfg_output(ah, AR9300_EXT_LNA_CTL_GPIO_AR9485,
 				    AR_GPIO_OUTPUT_MUX_AS_PCIE_ATTENTION_LED);
+	}
 
 	value = ar9003_hw_ant_ctrl_common_get(ah, is2ghz);
 
@@ -3800,7 +3806,13 @@ static void ar9003_hw_atten_apply(struct ath_hw *ah, struct ath9k_channel *chan)
 			REG_RMW_FIELD(ah, ext_atten_reg[i],
 				      AR_PHY_EXT_ATTEN_CTL_XATTEN1_DB, value);
 
-			value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
+			if (AR_SREV_9485(ah) &&
+			    (ar9003_hw_get_rx_gain_idx(ah) == 0) &&
+			    ah->config.xatten_margin_cfg)
+				value = 5;
+			else
+				value = ar9003_hw_atten_chain_get_margin(ah, i, chan);
+
 			REG_RMW_FIELD(ah, ext_atten_reg[i],
 				      AR_PHY_EXT_ATTEN_CTL_XATTEN1_MARGIN,
 				      value);
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a6e666b..74965ee 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -631,6 +631,8 @@ void ath_ant_comb_update(struct ath_softc *sc);
 /* Main driver core */
 /********************/
 
+#define ATH9K_PCI_CUS198 0x0001
+
 /*
  * Default cache line size, in bytes.
  * Used when PCI device not fully initialized by bootrom/BIOS
@@ -715,6 +717,7 @@ struct ath_softc {
 
 	unsigned int hw_busy_count;
 	unsigned long sc_flags;
+	unsigned long driver_data;
 
 	u32 intrstatus;
 	u16 ps_flags; /* PS_* */
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7d259b7..ed7d4fc 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -307,6 +307,10 @@ struct ath9k_ops_config {
 	u16 spurchans[AR_EEPROM_MODAL_SPURS][2];
 	u8 max_txtrig_level;
 	u16 ani_poll_interval; /* ANI poll interval in ms */
+
+	/* Platform specific config */
+	u32 xlna_gpio;
+	bool xatten_margin_cfg;
 };
 
 enum ath9k_int {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 818f22d..7c2ed1c 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -513,6 +513,22 @@ static void ath9k_init_misc(struct ath_softc *sc)
 	sc->spec_config.fft_period = 0xF;
 }
 
+static void ath9k_init_platform(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+
+	if (common->bus_ops->ath_bus_type != ATH_PCI)
+		return;
+
+	if (sc->driver_data & ATH9K_PCI_CUS198) {
+		ah->config.xlna_gpio = 9;
+		ah->config.xatten_margin_cfg = true;
+
+		ath_info(common, "Set parameters for CUS198\n");
+	}
+}
+
 static void ath9k_eeprom_request_cb(const struct firmware *eeprom_blob,
 				    void *ctx)
 {
@@ -605,6 +621,11 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	common->disable_ani = false;
 
 	/*
+	 * Platform quirks.
+	 */
+	ath9k_init_platform(sc);
+
+	/*
 	 * Enable Antenna diversity only when BTCOEX is disabled
 	 * and the user manually requests the feature.
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 0e0d395..4ac00b4 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -34,6 +34,34 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ PCI_VDEVICE(ATHEROS, 0x002D) }, /* PCI   */
 	{ PCI_VDEVICE(ATHEROS, 0x002E) }, /* PCI-E */
 	{ PCI_VDEVICE(ATHEROS, 0x0030) }, /* PCI-E  AR9300 */
+
+	/* PCI-E CUS198 */
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2086),
+	  .driver_data = ATH9K_PCI_CUS198 },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x1237),
+	  .driver_data = ATH9K_PCI_CUS198 },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2126),
+	  .driver_data = ATH9K_PCI_CUS198 },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_AZWAVE,
+			 0x2152),
+	  .driver_data = ATH9K_PCI_CUS198 },
+	{ PCI_DEVICE_SUB(PCI_VENDOR_ID_ATHEROS,
+			 0x0032,
+			 PCI_VENDOR_ID_FOXCONN,
+			 0xE075),
+	  .driver_data = ATH9K_PCI_CUS198 },
+
 	{ PCI_VDEVICE(ATHEROS, 0x0032) }, /* PCI-E  AR9485 */
 	{ PCI_VDEVICE(ATHEROS, 0x0033) }, /* PCI-E  AR9580 */
 	{ PCI_VDEVICE(ATHEROS, 0x0034) }, /* PCI-E  AR9462 */
@@ -221,6 +249,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = pcim_iomap_table(pdev)[0];
+	sc->driver_data = id->driver_data;
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(SC_OP_INVALID, &sc->sc_flags);
-- 
1.8.3.1

