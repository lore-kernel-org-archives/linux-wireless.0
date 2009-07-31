Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:42483 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbZGaSe6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:34:58 -0400
Date: Fri, 31 Jul 2009 21:04:15 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Subject: [PATCH 1/4] ath5k: Check EEPROM before tweaking SERDES
Message-ID: <20090731180415.GB7963@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Read PCI-E infos offset from EEPROM and if it points to
   serdes section (0x40), enable serdes programming (further
   tweaking of serdes values during attach). This follows
   Legacy and Sam's HAL sources.

---
 drivers/net/wireless/ath/ath5k/attach.c |   56 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath5k/eeprom.c |   10 +++++
 drivers/net/wireless/ath/ath5k/eeprom.h |    4 ++
 3 files changed, 48 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 9a84d94..6263065 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -253,28 +253,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	}
 
 	/*
-	 * Write PCI-E power save settings
-	 */
-	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
-		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
-		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
-		/* Shut off RX when elecidle is asserted */
-		ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
-		ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
-		/* TODO: EEPROM work */
-		ath5k_hw_reg_write(ah, 0xe5980579, AR5K_PCIE_SERDES);
-		/* Shut off PLL and CLKREQ active in L1 */
-		ath5k_hw_reg_write(ah, 0x001defff, AR5K_PCIE_SERDES);
-		/* Preserce other settings */
-		ath5k_hw_reg_write(ah, 0x1aaabe40, AR5K_PCIE_SERDES);
-		ath5k_hw_reg_write(ah, 0xbe105554, AR5K_PCIE_SERDES);
-		ath5k_hw_reg_write(ah, 0x000e3007, AR5K_PCIE_SERDES);
-		/* Reset SERDES to load new settings */
-		ath5k_hw_reg_write(ah, 0x00000000, AR5K_PCIE_SERDES_RESET);
-		mdelay(1);
-	}
-
-	/*
 	 * POST
 	 */
 	ret = ath5k_hw_post(ah);
@@ -295,6 +273,40 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 	}
 
+	/*
+	 * Write PCI-E power save settings
+	 */
+	if ((ah->ah_version == AR5K_AR5212) && (pdev->is_pcie)) {
+		struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
+
+		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
+
+		/* Shut off RX when elecidle is asserted */
+		ath5k_hw_reg_write(ah, 0x28000039, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x53160824, AR5K_PCIE_SERDES);
+
+		/* If serdes programing is enabled, increase PCI-E
+		 * tx power for systems with long trace from host
+		 * to minicard connector. */
+		if (ee->ee_serdes)
+			ath5k_hw_reg_write(ah, 0xe5980579, AR5K_PCIE_SERDES);
+		else
+			ath5k_hw_reg_write(ah, 0xf6800579, AR5K_PCIE_SERDES);
+
+		/* Shut off PLL and CLKREQ active in L1 */
+		ath5k_hw_reg_write(ah, 0x001defff, AR5K_PCIE_SERDES);
+
+		/* Preserve other settings */
+		ath5k_hw_reg_write(ah, 0x1aaabe40, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0xbe105554, AR5K_PCIE_SERDES);
+		ath5k_hw_reg_write(ah, 0x000e3007, AR5K_PCIE_SERDES);
+
+		/* Reset SERDES to load new settings */
+		ath5k_hw_reg_write(ah, 0x00000000, AR5K_PCIE_SERDES_RESET);
+		mdelay(1);
+	}
+
 	/* Get misc capabilities */
 	ret = ath5k_hw_set_capabilities(ah);
 	if (ret) {
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index c56b494..8af477d 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -167,6 +167,16 @@ ath5k_eeprom_init_header(struct ath5k_hw *ah)
 	ee->ee_rfkill_pin = (u8) AR5K_REG_MS(val, AR5K_EEPROM_RFKILL_GPIO_SEL);
 	ee->ee_rfkill_pol = val & AR5K_EEPROM_RFKILL_POLARITY ? true : false;
 
+	/* Check if PCIE_OFFSET points to PCIE_SERDES_SECTION
+	 * and enable serdes programming if needed.
+	 *
+	 * XXX: Serdes values seem to be fixed so
+	 * no need to read them here, we write them
+	 * during ath5k_hw_attach */
+	AR5K_EEPROM_READ(AR5K_EEPROM_PCIE_OFFSET, val);
+	ee->ee_serdes = (val == AR5K_EEPROM_PCIE_SERDES_SECTION) ?
+							true : false;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.h b/drivers/net/wireless/ath/ath5k/eeprom.h
index 64be73a..0123f35 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.h
+++ b/drivers/net/wireless/ath/ath5k/eeprom.h
@@ -19,6 +19,9 @@
 /*
  * Common ar5xxx EEPROM data offsets (set these on AR5K_EEPROM_BASE)
  */
+#define	AR5K_EEPROM_PCIE_OFFSET		0x02	/* Contains offset to PCI-E infos */
+#define	AR5K_EEPROM_PCIE_SERDES_SECTION	0x40	/* PCIE_OFFSET points here when
+						 * SERDES infos are present */
 #define AR5K_EEPROM_MAGIC		0x003d	/* EEPROM Magic number */
 #define AR5K_EEPROM_MAGIC_VALUE		0x5aa5	/* Default - found on EEPROM */
 #define AR5K_EEPROM_MAGIC_5212		0x0000145c /* 5212 */
@@ -391,6 +394,7 @@ struct ath5k_eeprom_info {
 	u8	ee_rfkill_pin;
 	bool	ee_rfkill_pol;
 	bool	ee_is_hb63;
+	bool	ee_serdes;
 	u16	ee_misc0;
 	u16	ee_misc1;
 	u16	ee_misc2;
