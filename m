Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:26581 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZH0CaK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:30:10 -0400
Subject: [PATCH 2/2] ath5k: don't use PCI ID to find the chip revision
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 26 Aug 2009 22:30:09 -0400
Message-ID: <20090827023009.21926.49329.stgit@mj.roinet.com>
In-Reply-To: <20090827023000.21926.90867.stgit@mj.roinet.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR5K_SREV is available even if the chip has been put to sleep.  Relying
on the chip register allows binding non-standard PCI IDs by

echo VENDOR_ID PRODUCT_ID >/sys/bus/pci/drivers/ath5k/new_id

without having to specify the driver data as well.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    2 +-
 drivers/net/wireless/ath/ath5k/attach.c |   14 +++++++----
 drivers/net/wireless/ath/ath5k/base.c   |   38 ++++++++++++++++---------------
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index cdc79cd..c2d4c6a 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1159,7 +1159,7 @@ struct ath5k_hw {
  */
 
 /* Attach/Detach Functions */
-extern struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version);
+extern struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc);
 extern void ath5k_hw_detach(struct ath5k_hw *ah);
 
 /* LED functions */
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 109ab7b..0d789ef 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -95,14 +95,13 @@ static int ath5k_hw_post(struct ath5k_hw *ah)
  * ath5k_hw_attach - Check if hw is supported and init the needed structs
  *
  * @sc: The &struct ath5k_softc we got from the driver's attach function
- * @mac_version: The mac version id (check out ath5k.h) based on pci id
  *
  * Check if the device is supported, perform a POST and initialize the needed
  * structs. Returns -ENOMEM if we don't have memory for the needed structs,
  * -ENODEV if the device is not supported or prints an error msg if something
  * else went wrong.
  */
-struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
+struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah;
 	struct pci_dev *pdev = sc->pdev;
@@ -136,9 +135,15 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	ah->ah_software_retry = false;
 
 	/*
-	 * Set the mac version based on the pci id
+	 * Find the mac version
 	 */
-	ah->ah_version = mac_version;
+	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
+	if (srev < AR5K_SREV_AR5311)
+		ah->ah_version = AR5K_AR5210;
+	else if (srev < AR5K_SREV_AR5212)
+		ah->ah_version = AR5K_AR5211;
+	else
+		ah->ah_version = AR5K_AR5212;
 
 	/*Fill the ath5k_hw struct with the needed functions*/
 	ret = ath5k_hw_init_desc_functions(ah);
@@ -151,7 +156,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 
 	/* Get MAC, PHY and RADIO revisions */
-	srev = ath5k_hw_reg_read(ah, AR5K_SREV);
 	ah->ah_mac_srev = srev;
 	ah->ah_mac_version = AR5K_REG_MS(srev, AR5K_SREV_VER);
 	ah->ah_mac_revision = AR5K_REG_MS(srev, AR5K_SREV_REV);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 94d46fd..9c6ab53 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -84,24 +84,24 @@ MODULE_VERSION("0.6.0 (EXPERIMENTAL)");
 
 /* Known PCI ids */
 static const struct pci_device_id ath5k_pci_id_table[] = {
-	{ PCI_VDEVICE(ATHEROS, 0x0207), .driver_data = AR5K_AR5210 }, /* 5210 early */
-	{ PCI_VDEVICE(ATHEROS, 0x0007), .driver_data = AR5K_AR5210 }, /* 5210 */
-	{ PCI_VDEVICE(ATHEROS, 0x0011), .driver_data = AR5K_AR5211 }, /* 5311 - this is on AHB bus !*/
-	{ PCI_VDEVICE(ATHEROS, 0x0012), .driver_data = AR5K_AR5211 }, /* 5211 */
-	{ PCI_VDEVICE(ATHEROS, 0x0013), .driver_data = AR5K_AR5212 }, /* 5212 */
-	{ PCI_VDEVICE(3COM_2,  0x0013), .driver_data = AR5K_AR5212 }, /* 3com 5212 */
-	{ PCI_VDEVICE(3COM,    0x0013), .driver_data = AR5K_AR5212 }, /* 3com 3CRDAG675 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x1014), .driver_data = AR5K_AR5212 }, /* IBM minipci 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x0014), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0015), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0016), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0017), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0018), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0019), .driver_data = AR5K_AR5212 }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
-	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
-	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* PCI-E cards */
-	{ PCI_VDEVICE(ATHEROS, 0x001d), .driver_data = AR5K_AR5212 }, /* 2417 Nala */
+	{ PCI_VDEVICE(ATHEROS, 0x0207) }, /* 5210 early */
+	{ PCI_VDEVICE(ATHEROS, 0x0007) }, /* 5210 */
+	{ PCI_VDEVICE(ATHEROS, 0x0011) }, /* 5311 - this is on AHB bus !*/
+	{ PCI_VDEVICE(ATHEROS, 0x0012) }, /* 5211 */
+	{ PCI_VDEVICE(ATHEROS, 0x0013) }, /* 5212 */
+	{ PCI_VDEVICE(3COM_2,  0x0013) }, /* 3com 5212 */
+	{ PCI_VDEVICE(3COM,    0x0013) }, /* 3com 3CRDAG675 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x1014) }, /* IBM minipci 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x0014) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0015) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0016) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0017) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0018) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x001a) }, /* 2413 Griffin-lite */
+	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
+	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
+	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
@@ -566,7 +566,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Initialize device */
-	sc->ah = ath5k_hw_attach(sc, id->driver_data);
+	sc->ah = ath5k_hw_attach(sc);
 	if (IS_ERR(sc->ah)) {
 		ret = PTR_ERR(sc->ah);
 		goto err_irq;
