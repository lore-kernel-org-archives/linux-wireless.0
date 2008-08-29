Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:43445 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYH2Unk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 16:43:40 -0400
Date: Fri, 29 Aug 2008 23:43:47 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com
Subject: [PATCH] ath5k: add support for AR2417
Message-ID: <20080829204347.GB8017@makis> (sfid-20080829_224344_696934_32AE5AA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add support for AR2417 chips and remove an obsolete message about 2425 during attach.
    
 Thanks to Unex for donating this card to Madwifi project ;-)

 It seems that AR2417 is just the m-pci version of AR2425.

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/ath5k.h  |    2 ++
 drivers/net/wireless/ath5k/attach.c |    8 ++++----
 drivers/net/wireless/ath5k/base.c   |    2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 4c02117..45688a5 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -63,6 +63,7 @@
 #define PCI_DEVICE_ID_ATHEROS_AR2413 		0x001a /* AR2413 (Griffin-lite) */
 #define PCI_DEVICE_ID_ATHEROS_AR5413 		0x001b /* AR5413 (Eagle) */
 #define PCI_DEVICE_ID_ATHEROS_AR5424 		0x001c /* AR5424 (Condor PCI-E) */
+#define PCI_DEVICE_ID_ATHEROS_AR2417 		0x001b /* AR2417 */
 #define PCI_DEVICE_ID_ATHEROS_AR5416 		0x0023 /* AR5416 */
 #define PCI_DEVICE_ID_ATHEROS_AR5418 		0x0024 /* AR5418 */
 
@@ -318,6 +319,7 @@ struct ath5k_srev_name {
 #define AR5K_SREV_VER_AR5416	0xc0 /* PCI-E */
 #define AR5K_SREV_VER_AR5418	0xca /* PCI-E */
 #define AR5K_SREV_VER_AR2425	0xe2 /* PCI-E */
+#define AR5K_SREV_VER_AR2417	0xf0
 
 #define AR5K_SREV_RAD_5110	0x00
 #define AR5K_SREV_RAD_5111	0x10
diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
index 0eb2511..b5fee7b 100644
--- a/drivers/net/wireless/ath5k/attach.c
+++ b/drivers/net/wireless/ath5k/attach.c
@@ -173,14 +173,13 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		ATH5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
 		goto err_free;
-	} else if (srev == AR5K_SREV_VER_AR2425) {
-		ATH5K_WARN(sc, "Support for RF2425 is under development.\n");
 	}
 
 	/* Identify single chip solutions */
 	if (((srev <= AR5K_SREV_VER_AR5414) &&
 	(srev >= AR5K_SREV_VER_AR2413)) ||
-	(srev == AR5K_SREV_VER_AR2425)) {
+	(srev == AR5K_SREV_VER_AR2425) ||
+	(srev == AR5K_SREV_VER_AR2417)) {
 		ah->ah_single_chip = true;
 	} else {
 		ah->ah_single_chip = false;
@@ -199,7 +198,8 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	 * correctly. For now we are based on mac's srev to
 	 * identify RF2425 radio.
 	 */
-	} else if (srev == AR5K_SREV_VER_AR2425) {
+	} else if ((srev == AR5K_SREV_VER_AR2425) ||
+	(srev == AR5K_SREV_VER_AR2417)) {
 		ah->ah_radio = AR5K_RF2425;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 7989ab5..4be4805 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -94,6 +94,7 @@ static struct pci_device_id ath5k_pci_id_table[] __devinitdata = {
 	{ PCI_VDEVICE(ATHEROS, 0x001a), .driver_data = AR5K_AR5212 }, /* 2413 Griffin-lite */
 	{ PCI_VDEVICE(ATHEROS, 0x001b), .driver_data = AR5K_AR5212 }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c), .driver_data = AR5K_AR5212 }, /* 5424 Condor (PCI-E)*/
+	{ PCI_VDEVICE(ATHEROS, 0x001d), .driver_data = AR5K_AR5212 }, /* 2417 (2425 m-pci)*/
 	{ 0 }
 };
 MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
@@ -117,6 +118,7 @@ static struct ath5k_srev_name srev_names[] = {
 	{ "5416",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5416 },
 	{ "5418",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5418 },
 	{ "2425",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2425 },
+	{ "2417",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2417 },
 	{ "xxxxx",	AR5K_VERSION_VER,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
