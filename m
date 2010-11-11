Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56674 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756234Ab0KKO6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:58:17 -0500
Date: Thu, 11 Nov 2010 15:58:11 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <6105834.1111289487490143.JavaMail.wlan@CHBU500181>
In-Reply-To: <17186438.751289486686690.JavaMail.wlan@CHBU500181>
Subject: [PATCH 6/9] ath5k: AHB port. Use more generic functions for finding
 mac revision instead of pci specific.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use ath5k_bus_read_srev as a wrapper for MAC revision register reading. Different buses have
to aceess it with own functions before hardware is initialized.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 ++
 drivers/net/wireless/ath/ath5k/attach.c |   11 +++++++----
 drivers/net/wireless/ath/ath5k/pci.c    |    6 ++++++
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2b9d693..a13243a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1034,6 +1034,7 @@ struct ath5k_hw {
 	u32			ah_phy;
 	u32			ah_mac_srev;
 	u16			ah_mac_version;
+	u16			ah_mac_revision;
 	u16			ah_phy_revision;
 	u16			ah_radio_5ghz_revision;
 	u16			ah_radio_2ghz_revision;
@@ -1144,6 +1145,7 @@ void ath5k_sysfs_unregister(struct ath5k_softc *sc);
 
 /*chip id helper function */
 const char * ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
+int ath5k_bus_read_srev(struct ath5k_hw *ah);
 
 /* LED functions */
 int ath5k_init_leds(struct ath5k_softc *sc);
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index c5b2eb7..15e3a83 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -128,7 +128,8 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	/*
 	 * Find the mac version
 	 */
-	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	ath5k_bus_read_srev(ah);
+	srev = ah->ah_mac_srev;
 	if (srev < AR5K_SREV_AR5311)
 		ah->ah_version = AR5K_AR5210;
 	else if (srev < AR5K_SREV_AR5212)
@@ -136,6 +137,10 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	else
 		ah->ah_version = AR5K_AR5212;
 
+	/* Get the MAC revision */
+	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
+	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
+
 	/* Fill the ath5k_hw struct with the needed functions */
 	ret = ath5k_hw_init_desc_functions(ah);
 	if (ret)
@@ -146,9 +151,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	if (ret)
 		goto err;
 
-	/* Get MAC, PHY and RADIO revisions */
-	ah->ah_mac_srev = srev;
-	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
+	/* Get PHY and RADIO revisions */
 	ah->ah_phy_revision = ath5k_hw_reg_read(ah, AR5K_PHY_CHIP_ID) &
 			0xffffffff;
 	ah->ah_radio_5ghz_revision = ath5k_hw_radio_revision(ah,
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 0d8dd2d..0acf1fc 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -100,6 +100,12 @@ bool ath5k_pci_eeprom_read(struct ath_common *common, u32 offset, u16 *data)
 	return -ETIMEDOUT;
 }
 
+int ath5k_bus_read_srev(struct ath5k_hw *ah)
+{
+	ah->ah_mac_srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	return 0;
+}
+
 /* Common ath_bus_opts structure */
 static const struct ath_bus_ops ath_pci_bus_ops = {
 	.ath_bus_type = ATH_PCI,
-- 
1.7.1

