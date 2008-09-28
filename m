Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:33552 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752792AbYI1XJN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Sep 2008 19:09:13 -0400
Date: Mon, 29 Sep 2008 02:09:09 +0300
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	me@bobcopeland.com, nbd@openwrt.org
Subject: [PATCH 1/5] ath5k: Update registers and SREV ids v2
Message-ID: <20080928230909.GA2996@makis> (sfid-20080929_010936_345617_DBA539E6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Update registers
 * Update SREV values and add some PHY srevs
 * Prepare ath5k.h for newer radios etc

 Thanks to Atheros 's HAL source we now know for sure how many parts we have
 and what their SREV values are. We also have some updates on registers. Prepare
 ath5k for some major updates ;-)

 My previous mail had 2 more patches following (git log misusage), sorry for double
 posting ;-(

 Changes-Licensed-under: ISC
 Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/ath5k.h  |   59 +++--
 drivers/net/wireless/ath5k/attach.c |   26 +-
 drivers/net/wireless/ath5k/base.c   |   50 ++--
 drivers/net/wireless/ath5k/qcu.c    |    8 +-
 drivers/net/wireless/ath5k/reg.h    |  577 ++++++++++++++++++++++++-----------
 drivers/net/wireless/ath5k/reset.c  |    8 +-
 6 files changed, 490 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 2001886..148cb50 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -281,7 +281,9 @@ enum ath5k_radio {
 	AR5K_RF5112	= 2,
 	AR5K_RF2413	= 3,
 	AR5K_RF5413	= 4,
-	AR5K_RF2425	= 5,
+	AR5K_RF2316	= 5,
+	AR5K_RF2317	= 6,
+	AR5K_RF2425	= 7,
 };
 
 /*
@@ -289,7 +291,7 @@ enum ath5k_radio {
  */
 
 enum ath5k_srev_type {
-	AR5K_VERSION_VER,
+	AR5K_VERSION_MAC,
 	AR5K_VERSION_RAD,
 };
 
@@ -301,23 +303,24 @@ struct ath5k_srev_name {
 
 #define AR5K_SREV_UNKNOWN	0xffff
 
-#define AR5K_SREV_VER_AR5210	0x00
-#define AR5K_SREV_VER_AR5311	0x10
-#define AR5K_SREV_VER_AR5311A	0x20
-#define AR5K_SREV_VER_AR5311B	0x30
-#define AR5K_SREV_VER_AR5211	0x40
-#define AR5K_SREV_VER_AR5212	0x50
-#define AR5K_SREV_VER_AR5213	0x55
-#define AR5K_SREV_VER_AR5213A	0x59
-#define AR5K_SREV_VER_AR2413	0x78
-#define AR5K_SREV_VER_AR2414	0x79
-#define AR5K_SREV_VER_AR2424	0xa0 /* PCI-E */
-#define AR5K_SREV_VER_AR5424	0xa3 /* PCI-E */
-#define AR5K_SREV_VER_AR5413	0xa4
-#define AR5K_SREV_VER_AR5414	0xa5
-#define AR5K_SREV_VER_AR5416	0xc0 /* PCI-E */
-#define AR5K_SREV_VER_AR5418	0xca /* PCI-E */
-#define AR5K_SREV_VER_AR2425	0xe2 /* PCI-E */
+#define AR5K_SREV_AR5210	0x00 /* Crete */
+#define AR5K_SREV_AR5311	0x10 /* Maui 1 */
+#define AR5K_SREV_AR5311A	0x20 /* Maui 2 */
+#define AR5K_SREV_AR5311B	0x30 /* Spirit */
+#define AR5K_SREV_AR5211	0x40 /* Oahu */
+#define AR5K_SREV_AR5212	0x50 /* Venice */
+#define AR5K_SREV_AR5213	0x55 /* ??? */
+#define AR5K_SREV_AR5213A	0x59 /* Hainan */
+#define AR5K_SREV_AR2413	0x78 /* Griffin lite */
+#define AR5K_SREV_AR2414	0x70 /* Griffin */
+#define AR5K_SREV_AR5424	0x90 /* Condor */
+#define AR5K_SREV_AR5413	0xa4 /* Eagle lite */
+#define AR5K_SREV_AR5414	0xa0 /* Eagle */
+#define AR5K_SREV_AR2415	0xb0 /* Cobra */
+#define AR5K_SREV_AR5416	0xc0 /* PCI-E */
+#define AR5K_SREV_AR5418	0xca /* PCI-E */
+#define AR5K_SREV_AR2425	0xe0 /* Swan */
+#define AR5K_SREV_AR2417	0xf0 /* Nala */
 
 #define AR5K_SREV_RAD_5110	0x00
 #define AR5K_SREV_RAD_5111	0x10
@@ -329,10 +332,20 @@ struct ath5k_srev_name {
 #define AR5K_SREV_RAD_2112	0x40
 #define AR5K_SREV_RAD_2112A	0x45
 #define	AR5K_SREV_RAD_2112B	0x46
-#define AR5K_SREV_RAD_SC0	0x50	/* Found on 2413/2414 */
-#define AR5K_SREV_RAD_SC1	0x60	/* Found on 5413/5414 */
-#define AR5K_SREV_RAD_SC2	0xa0	/* Found on 2424-5/5424 */
-#define AR5K_SREV_RAD_5133	0xc0	/* MIMO found on 5418 */
+#define AR5K_SREV_RAD_2413	0x50
+#define AR5K_SREV_RAD_5413	0x60
+#define AR5K_SREV_RAD_2316	0x70
+#define AR5K_SREV_RAD_2317	0x80
+#define AR5K_SREV_RAD_5424	0xa0 /* Mostly same as 5413 */
+#define AR5K_SREV_RAD_2425	0xa2
+#define AR5K_SREV_RAD_5133	0xc0
+
+#define AR5K_SREV_PHY_5211	0x30
+#define AR5K_SREV_PHY_5212	0x41
+#define AR5K_SREV_PHY_2112B	0x43
+#define AR5K_SREV_PHY_2413	0x45
+#define AR5K_SREV_PHY_5413	0x61
+#define AR5K_SREV_PHY_2425	0x70
 
 /* IEEE defs */
 #define IEEE80211_MAX_LEN       2500
diff --git a/drivers/net/wireless/ath5k/attach.c b/drivers/net/wireless/ath5k/attach.c
index 153c411..d92b4a1 100644
--- a/drivers/net/wireless/ath5k/attach.c
+++ b/drivers/net/wireless/ath5k/attach.c
@@ -168,19 +168,19 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 				CHANNEL_2GHZ);
 
 	/* Return on unsuported chips (unsupported eeprom etc) */
-	if ((srev >= AR5K_SREV_VER_AR5416) &&
-	(srev < AR5K_SREV_VER_AR2425)) {
+	if ((srev >= AR5K_SREV_AR5416) &&
+	(srev < AR5K_SREV_AR2425)) {
 		ATH5K_ERR(sc, "Device not yet supported.\n");
 		ret = -ENODEV;
 		goto err_free;
-	} else if (srev == AR5K_SREV_VER_AR2425) {
+	} else if (srev == AR5K_SREV_AR2425) {
 		ATH5K_WARN(sc, "Support for RF2425 is under development.\n");
 	}
 
 	/* Identify single chip solutions */
-	if (((srev <= AR5K_SREV_VER_AR5414) &&
-	(srev >= AR5K_SREV_VER_AR2413)) ||
-	(srev == AR5K_SREV_VER_AR2425)) {
+	if (((srev <= AR5K_SREV_AR5414) &&
+	(srev >= AR5K_SREV_AR2413)) ||
+	(srev == AR5K_SREV_AR2425)) {
 		ah->ah_single_chip = true;
 	} else {
 		ah->ah_single_chip = false;
@@ -199,24 +199,24 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 	 * correctly. For now we are based on mac's srev to
 	 * identify RF2425 radio.
 	 */
-	} else if (srev == AR5K_SREV_VER_AR2425) {
+	} else if (srev == AR5K_SREV_AR2425) {
 		ah->ah_radio = AR5K_RF2425;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2425;
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5112) {
 		ah->ah_radio = AR5K_RF5111;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5111;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC0) {
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_2413) {
 		ah->ah_radio = AR5K_RF5112;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5112;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC1) {
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5413) {
 		ah->ah_radio = AR5K_RF2413;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF2413;
-	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_SC2) {
+	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_2316) {
 		ah->ah_radio = AR5K_RF5413;
 		ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
 	} else if (ah->ah_radio_5ghz_revision < AR5K_SREV_RAD_5133) {
 		/* AR5424 */
-		if (srev >= AR5K_SREV_VER_AR5424) {
+		if (srev >= AR5K_SREV_AR5424) {
 			ah->ah_radio = AR5K_RF5413;
 			ah->ah_phy_spending = AR5K_PHY_SPENDING_RF5413;
 		/* AR2424 */
@@ -252,8 +252,8 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 
 	/* Write AR5K_PCICFG_UNK on 2112B and later chips */
 	if (ah->ah_radio_5ghz_revision > AR5K_SREV_RAD_2112B ||
-	srev > AR5K_SREV_VER_AR2413) {
-		ath5k_hw_reg_write(ah, AR5K_PCICFG_UNK, AR5K_PCICFG);
+	srev > AR5K_SREV_AR2413) {
+		ath5k_hw_reg_write(ah, AR5K_PCICFG_RETRY_FIX, AR5K_PCICFG);
 	}
 
 	/*
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e09ed2c..c8bb9bf 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -100,34 +100,40 @@ MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
 
 /* Known SREVs */
 static struct ath5k_srev_name srev_names[] = {
-	{ "5210",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5210 },
-	{ "5311",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311 },
-	{ "5311A",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311A },
-	{ "5311B",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5311B },
-	{ "5211",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5211 },
-	{ "5212",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5212 },
-	{ "5213",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213 },
-	{ "5213A",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5213A },
-	{ "2413",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2413 },
-	{ "2414",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2414 },
-	{ "2424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2424 },
-	{ "5424",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5424 },
-	{ "5413",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5413 },
-	{ "5414",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5414 },
-	{ "5416",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5416 },
-	{ "5418",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR5418 },
-	{ "2425",	AR5K_VERSION_VER,	AR5K_SREV_VER_AR2425 },
-	{ "xxxxx",	AR5K_VERSION_VER,	AR5K_SREV_UNKNOWN },
+	{ "5210",	AR5K_VERSION_MAC,	AR5K_SREV_AR5210 },
+	{ "5311",	AR5K_VERSION_MAC,	AR5K_SREV_AR5311 },
+	{ "5311A",	AR5K_VERSION_MAC,	AR5K_SREV_AR5311A },
+	{ "5311B",	AR5K_VERSION_MAC,	AR5K_SREV_AR5311B },
+	{ "5211",	AR5K_VERSION_MAC,	AR5K_SREV_AR5211 },
+	{ "5212",	AR5K_VERSION_MAC,	AR5K_SREV_AR5212 },
+	{ "5213",	AR5K_VERSION_MAC,	AR5K_SREV_AR5213 },
+	{ "5213A",	AR5K_VERSION_MAC,	AR5K_SREV_AR5213A },
+	{ "2413",	AR5K_VERSION_MAC,	AR5K_SREV_AR2413 },
+	{ "2414",	AR5K_VERSION_MAC,	AR5K_SREV_AR2414 },
+	{ "5424",	AR5K_VERSION_MAC,	AR5K_SREV_AR5424 },
+	{ "5413",	AR5K_VERSION_MAC,	AR5K_SREV_AR5413 },
+	{ "5414",	AR5K_VERSION_MAC,	AR5K_SREV_AR5414 },
+	{ "2415",	AR5K_VERSION_MAC,	AR5K_SREV_AR2415 },
+	{ "5416",	AR5K_VERSION_MAC,	AR5K_SREV_AR5416 },
+	{ "5418",	AR5K_VERSION_MAC,	AR5K_SREV_AR5418 },
+	{ "2425",	AR5K_VERSION_MAC,	AR5K_SREV_AR2425 },
+	{ "2417",	AR5K_VERSION_MAC,	AR5K_SREV_AR2417 },
+	{ "xxxxx",	AR5K_VERSION_MAC,	AR5K_SREV_UNKNOWN },
 	{ "5110",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5110 },
 	{ "5111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111 },
+	{ "5111A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5111A },
 	{ "2111",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2111 },
 	{ "5112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112 },
 	{ "5112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112A },
+	{ "5112B",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5112B },
 	{ "2112",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112 },
 	{ "2112A",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112A },
-	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC0 },
-	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC1 },
-	{ "SChip",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_SC2 },
+	{ "2112B",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2112B },
+	{ "2413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2413 },
+	{ "5413",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5413 },
+	{ "2316",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2316 },
+	{ "2317",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_2317 },
+	{ "5424",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5424 },
 	{ "5133",	AR5K_VERSION_RAD,	AR5K_SREV_RAD_5133 },
 	{ "xxxxx",	AR5K_VERSION_RAD,	AR5K_SREV_UNKNOWN },
 };
@@ -536,7 +542,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		goto err_ah;
 
 	ATH5K_INFO(sc, "Atheros AR%s chip found (MAC: 0x%x, PHY: 0x%x)\n",
-			ath5k_chip_name(AR5K_VERSION_VER,sc->ah->ah_mac_srev),
+			ath5k_chip_name(AR5K_VERSION_MAC, sc->ah->ah_mac_srev),
 					sc->ah->ah_mac_srev,
 					sc->ah->ah_phy_revision);
 
diff --git a/drivers/net/wireless/ath5k/qcu.c b/drivers/net/wireless/ath5k/qcu.c
index 2e20f78..01bf091 100644
--- a/drivers/net/wireless/ath5k/qcu.c
+++ b/drivers/net/wireless/ath5k/qcu.c
@@ -375,7 +375,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		case AR5K_TX_QUEUE_BEACON:
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
-				AR5K_QCU_MISC_CBREXP_BCN |
+				AR5K_QCU_MISC_CBREXP_BCN_DIS |
 				AR5K_QCU_MISC_BCN_ENABLE);
 
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
@@ -395,8 +395,8 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 		case AR5K_TX_QUEUE_CAB:
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
 				AR5K_QCU_MISC_FRSHED_DBA_GT |
-				AR5K_QCU_MISC_CBREXP |
-				AR5K_QCU_MISC_CBREXP_BCN);
+				AR5K_QCU_MISC_CBREXP_DIS |
+				AR5K_QCU_MISC_CBREXP_BCN_DIS);
 
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_DFS_MISC(queue),
 				(AR5K_DCU_MISC_ARBLOCK_CTL_GLOBAL <<
@@ -405,7 +405,7 @@ int ath5k_hw_reset_tx_queue(struct ath5k_hw *ah, unsigned int queue)
 
 		case AR5K_TX_QUEUE_UAPSD:
 			AR5K_REG_ENABLE_BITS(ah, AR5K_QUEUE_MISC(queue),
-				AR5K_QCU_MISC_CBREXP);
+				AR5K_QCU_MISC_CBREXP_DIS);
 			break;
 
 		case AR5K_TX_QUEUE_DATA:
diff --git a/drivers/net/wireless/ath5k/reg.h b/drivers/net/wireless/ath5k/reg.h
index 410f99a..2c0fb8a 100644
--- a/drivers/net/wireless/ath5k/reg.h
+++ b/drivers/net/wireless/ath5k/reg.h
@@ -29,6 +29,10 @@
  *        http://www.it.iitb.ac.in/~janak/wifire/01222734.pdf
  *
  * 5211 - http://www.hotchips.org/archives/hc14/3_Tue/16_mcfarland.pdf
+ *
+ * This file also contains register values found on a memory dump of
+ * Atheros's ART program (Atheros Radio Test), on ath9k, on legacy-hal
+ * released by Atheros and on various debug messages found on the net.
  */
 
 
@@ -295,7 +299,7 @@
 #define AR5K_ISR_RXPHY		0x00004000	/* PHY error */
 #define AR5K_ISR_RXKCM		0x00008000	/* RX Key cache miss */
 #define AR5K_ISR_SWBA		0x00010000	/* Software beacon alert */
-#define AR5K_ISR_BRSSI		0x00020000
+#define AR5K_ISR_BRSSI		0x00020000	/* Beacon rssi below threshold (?) */
 #define AR5K_ISR_BMISS		0x00040000	/* Beacon missed */
 #define AR5K_ISR_HIUERR		0x00080000	/* Host Interface Unit error [5211+] */
 #define AR5K_ISR_BNR		0x00100000 	/* Beacon not ready [5211+] */
@@ -303,46 +307,56 @@
 #define AR5K_ISR_RXCHIRP	0x00200000	/* CHIRP Received [5212+] */
 #define AR5K_ISR_SSERR		0x00200000	/* Signaled System Error [5210] */
 #define AR5K_ISR_DPERR		0x00400000	/* Det par Error (?) [5210] */
-#define AR5K_ISR_TIM		0x00800000	/* [5210] */
-#define AR5K_ISR_BCNMISC	0x00800000	/* [5212+] */
-#define AR5K_ISR_GPIO		0x01000000	/* GPIO (rf kill)*/
-#define AR5K_ISR_QCBRORN	0x02000000	/* CBR overrun (?)  [5211+] */
-#define AR5K_ISR_QCBRURN	0x04000000	/* CBR underrun (?) [5211+] */
-#define AR5K_ISR_QTRIG		0x08000000	/* [5211+] */
+#define AR5K_ISR_RXDOPPLER	0x00400000	/* Doppler chirp received [5212+] */
+#define AR5K_ISR_TIM		0x00800000	/* [5211+] */
+#define AR5K_ISR_BCNMISC	0x00800000	/* 'or' of TIM, CAB_END, DTIM_SYNC, BCN_TIMEOUT,
+						CAB_TIMEOUT and DTIM bits from SISR2 [5212+] */
+#define AR5K_ISR_GPIO		0x01000000	/* GPIO (rf kill) */
+#define AR5K_ISR_QCBRORN	0x02000000	/* QCU CBR overrun [5211+] */
+#define AR5K_ISR_QCBRURN	0x04000000	/* QCU CBR underrun [5211+] */
+#define AR5K_ISR_QTRIG		0x08000000	/* QCU scheduling trigger [5211+] */
 
 /*
  * Secondary status registers [5211+] (0 - 4)
  *
- * I guess from the names that these give the status for each
- * queue, that's why only masks are defined here, haven't got
- * any info about them (couldn't find them anywhere in ar5k code).
+ * These give the status for each QCU, only QCUs 0-9 are
+ * represented.
  */
 #define AR5K_SISR0		0x0084			/* Register Address [5211+] */
 #define AR5K_SISR0_QCU_TXOK	0x000003ff	/* Mask for QCU_TXOK */
+#define AR5K_SISR0_QCU_TXOK_S	0
 #define AR5K_SISR0_QCU_TXDESC	0x03ff0000	/* Mask for QCU_TXDESC */
+#define AR5K_SISR0_QCU_TXDESC_S	16
 
 #define AR5K_SISR1		0x0088			/* Register Address [5211+] */
 #define AR5K_SISR1_QCU_TXERR	0x000003ff	/* Mask for QCU_TXERR */
+#define AR5K_SISR1_QCU_TXERR_S	0
 #define AR5K_SISR1_QCU_TXEOL	0x03ff0000	/* Mask for QCU_TXEOL */
+#define AR5K_SISR1_QCU_TXEOL_S	16
 
 #define AR5K_SISR2		0x008c			/* Register Address [5211+] */
 #define AR5K_SISR2_QCU_TXURN	0x000003ff	/* Mask for QCU_TXURN */
+#define	AR5K_SISR2_QCU_TXURN_S	0
 #define	AR5K_SISR2_MCABT	0x00100000	/* Master Cycle Abort */
 #define	AR5K_SISR2_SSERR	0x00200000	/* Signaled System Error */
-#define	AR5K_SISR2_DPERR	0x00400000	/* Det par Error (?) */
+#define	AR5K_SISR2_DPERR	0x00400000	/* Bus parity error */
 #define	AR5K_SISR2_TIM		0x01000000	/* [5212+] */
 #define	AR5K_SISR2_CAB_END	0x02000000	/* [5212+] */
 #define	AR5K_SISR2_DTIM_SYNC	0x04000000	/* DTIM sync lost [5212+] */
 #define	AR5K_SISR2_BCN_TIMEOUT	0x08000000	/* Beacon Timeout [5212+] */
 #define	AR5K_SISR2_CAB_TIMEOUT	0x10000000	/* CAB Timeout [5212+] */
 #define	AR5K_SISR2_DTIM		0x20000000	/* [5212+] */
+#define	AR5K_SISR2_TSFOOR	0x80000000	/* TSF OOR (?) */
 
 #define AR5K_SISR3		0x0090			/* Register Address [5211+] */
 #define AR5K_SISR3_QCBRORN	0x000003ff	/* Mask for QCBRORN */
+#define AR5K_SISR3_QCBORN_S	0
 #define AR5K_SISR3_QCBRURN	0x03ff0000	/* Mask for QCBRURN */
+#define AR5K_SISR3_QCBRURN_S	16
 
 #define AR5K_SISR4		0x0094			/* Register Address [5211+] */
 #define AR5K_SISR4_QTRIG	0x000003ff	/* Mask for QTRIG */
+#define AR5K_SISR4_QTRIG_S	0
 
 /*
  * Shadow read-and-clear interrupt status registers [5211+]
@@ -379,7 +393,7 @@
 #define AR5K_IMR_RXPHY		0x00004000	/* PHY error*/
 #define AR5K_IMR_RXKCM		0x00008000	/* RX Key cache miss */
 #define AR5K_IMR_SWBA		0x00010000	/* Software beacon alert*/
-#define AR5K_IMR_BRSSI		0x00020000
+#define AR5K_IMR_BRSSI		0x00020000	/* Beacon rssi below threshold (?) */
 #define AR5K_IMR_BMISS		0x00040000	/* Beacon missed*/
 #define AR5K_IMR_HIUERR		0x00080000	/* Host Interface Unit error [5211+] */
 #define AR5K_IMR_BNR		0x00100000 	/* Beacon not ready [5211+] */
@@ -387,12 +401,14 @@
 #define AR5K_IMR_RXCHIRP	0x00200000	/* CHIRP Received [5212+]*/
 #define AR5K_IMR_SSERR		0x00200000	/* Signaled System Error [5210] */
 #define AR5K_IMR_DPERR		0x00400000	/* Det par Error (?) [5210] */
+#define AR5K_IMR_RXDOPPLER	0x00400000	/* Doppler chirp received [5212+] */
 #define AR5K_IMR_TIM		0x00800000	/* [5211+] */
-#define AR5K_IMR_BCNMISC	0x00800000	/* [5212+] */
+#define AR5K_IMR_BCNMISC	0x00800000	/* 'or' of TIM, CAB_END, DTIM_SYNC, BCN_TIMEOUT,
+						CAB_TIMEOUT and DTIM bits from SISR2 [5212+] */
 #define AR5K_IMR_GPIO		0x01000000	/* GPIO (rf kill)*/
-#define AR5K_IMR_QCBRORN	0x02000000	/* CBR overrun (?) [5211+] */
-#define AR5K_IMR_QCBRURN	0x04000000	/* CBR underrun (?) [5211+] */
-#define AR5K_IMR_QTRIG		0x08000000	/* [5211+] */
+#define AR5K_IMR_QCBRORN	0x02000000	/* QCU CBR overrun (?) [5211+] */
+#define AR5K_IMR_QCBRURN	0x04000000	/* QCU CBR underrun (?) [5211+] */
+#define AR5K_IMR_QTRIG		0x08000000	/* QCU scheduling trigger [5211+] */
 
 /*
  * Secondary interrupt mask registers [5211+] (0 - 4)
@@ -414,13 +430,14 @@
 #define AR5K_SIMR2_QCU_TXURN_S	0
 #define	AR5K_SIMR2_MCABT	0x00100000	/* Master Cycle Abort */
 #define	AR5K_SIMR2_SSERR	0x00200000	/* Signaled System Error */
-#define	AR5K_SIMR2_DPERR	0x00400000	/* Det par Error (?) */
+#define	AR5K_SIMR2_DPERR	0x00400000	/* Bus parity error */
 #define	AR5K_SIMR2_TIM		0x01000000	/* [5212+] */
 #define	AR5K_SIMR2_CAB_END	0x02000000	/* [5212+] */
 #define	AR5K_SIMR2_DTIM_SYNC	0x04000000	/* DTIM Sync lost [5212+] */
 #define	AR5K_SIMR2_BCN_TIMEOUT	0x08000000	/* Beacon Timeout [5212+] */
 #define	AR5K_SIMR2_CAB_TIMEOUT	0x10000000	/* CAB Timeout [5212+] */
 #define	AR5K_SIMR2_DTIM		0x20000000	/* [5212+] */
+#define	AR5K_SIMR2_TSFOOR	0x80000000	/* TSF OOR (?) */
 
 #define AR5K_SIMR3		0x00b0			/* Register Address [5211+] */
 #define AR5K_SIMR3_QCBRORN	0x000003ff	/* Mask for QCBRORN */
@@ -586,15 +603,15 @@
 #define	AR5K_QCU_MISC_FRSHED_M		0x0000000f	/* Frame sheduling mask */
 #define	AR5K_QCU_MISC_FRSHED_ASAP		0	/* ASAP */
 #define	AR5K_QCU_MISC_FRSHED_CBR		1	/* Constant Bit Rate */
-#define	AR5K_QCU_MISC_FRSHED_DBA_GT		2	/* DMA Beacon alert gated (?) */
-#define	AR5K_QCU_MISC_FRSHED_TIM_GT		3	/* Time gated (?) */
-#define	AR5K_QCU_MISC_FRSHED_BCN_SENT_GT	4	/* Beacon sent gated (?) */
+#define	AR5K_QCU_MISC_FRSHED_DBA_GT		2	/* DMA Beacon alert gated */
+#define	AR5K_QCU_MISC_FRSHED_TIM_GT		3	/* TIMT gated */
+#define	AR5K_QCU_MISC_FRSHED_BCN_SENT_GT	4	/* Beacon sent gated */
 #define	AR5K_QCU_MISC_ONESHOT_ENABLE	0x00000010	/* Oneshot enable */
-#define	AR5K_QCU_MISC_CBREXP		0x00000020	/* CBR expired (normal queue) */
-#define	AR5K_QCU_MISC_CBREXP_BCN	0x00000040	/* CBR expired (beacon queue) */
+#define	AR5K_QCU_MISC_CBREXP_DIS	0x00000020	/* Disable CBR expired counter (normal queue) */
+#define	AR5K_QCU_MISC_CBREXP_BCN_DIS	0x00000040	/* Disable CBR expired counter (beacon queue) */
 #define	AR5K_QCU_MISC_BCN_ENABLE	0x00000080	/* Enable Beacon use */
-#define	AR5K_QCU_MISC_CBR_THRES_ENABLE	0x00000100	/* CBR threshold enabled */
-#define	AR5K_QCU_MISC_RDY_VEOL_POLICY	0x00000200	/* TXE reset when RDYTIME enalbed */
+#define	AR5K_QCU_MISC_CBR_THRES_ENABLE	0x00000100	/* CBR expired threshold enabled */
+#define	AR5K_QCU_MISC_RDY_VEOL_POLICY	0x00000200	/* TXE reset when RDYTIME expired or VEOL */
 #define	AR5K_QCU_MISC_CBR_RESET_CNT	0x00000400	/* CBR threshold (counter) reset */
 #define	AR5K_QCU_MISC_DCU_EARLY		0x00000800	/* DCU early termination */
 #define AR5K_QCU_MISC_DCU_CMP_EN	0x00001000	/* Enable frame compression */
@@ -663,6 +680,7 @@
 #define	AR5K_DCU_LCL_IFS_CW_MAX_S	10
 #define	AR5K_DCU_LCL_IFS_AIFS		0x0ff00000	/* Arbitrated Interframe Space */
 #define	AR5K_DCU_LCL_IFS_AIFS_S		20
+#define	AR5K_DCU_LCL_IFS_AIFS_MAX	0xfc		/* Anything above that can cause DCU to hang */
 #define	AR5K_QUEUE_DFS_LOCAL_IFS(_q)	AR5K_QUEUE_REG(AR5K_DCU_LCL_IFS_BASE, _q)
 
 /*
@@ -691,11 +709,7 @@
 /*
  * DCU misc registers [5211+]
  *
- * For some of the registers i couldn't find in the code
- * (only backoff stuff is there realy) i tried to match the
- * names with 802.11e parameters etc, so i guess VIRTCOL here
- * means Virtual Collision and HCFPOLL means Hybrid Coordination
- * factor Poll (CF- Poll). Arbiter lockout control controls the
+ * Note: Arbiter lockout control controls the
  * behaviour on low priority queues when we have multiple queues
  * with pending frames. Intra-frame lockout means we wait until
  * the queue's current frame transmits (with post frame backoff and bursting)
@@ -705,15 +719,20 @@
  * No lockout means there is no special handling.
  */
 #define AR5K_DCU_MISC_BASE		0x1100			/* Register Address -Queue0 DCU_MISC */
-#define	AR5K_DCU_MISC_BACKOFF		0x000007ff	/* Mask for backoff threshold */
+#define	AR5K_DCU_MISC_BACKOFF		0x0000003f	/* Mask for backoff threshold */
+#define	AR5K_DCU_MISC_ETS_RTS_POL	0x00000040	/* End of transmission series
+							station RTS/data failure count
+							reset policy (?) */
+#define AR5K_DCU_MISC_ETS_CW_POL	0x00000080	/* End of transmission series
+							CW reset policy */
+#define	AR5K_DCU_MISC_FRAG_WAIT		0x00000100	/* Wait for next fragment */
 #define AR5K_DCU_MISC_BACKOFF_FRAG	0x00000200	/* Enable backoff while bursting */
 #define	AR5K_DCU_MISC_HCFPOLL_ENABLE	0x00000800	/* CF - Poll enable */
 #define	AR5K_DCU_MISC_BACKOFF_PERSIST	0x00001000	/* Persistent backoff */
 #define	AR5K_DCU_MISC_FRMPRFTCH_ENABLE	0x00002000	/* Enable frame pre-fetch */
 #define	AR5K_DCU_MISC_VIRTCOL		0x0000c000	/* Mask for Virtual Collision (?) */
-#define	AR5K_DCU_MISC_VIRTCOL_NORMAL		0
-#define	AR5K_DCU_MISC_VIRTCOL_MODIFIED		1
-#define	AR5K_DCU_MISC_VIRTCOL_IGNORE		2
+#define	AR5K_DCU_MISC_VIRTCOL_NORMAL	0
+#define	AR5K_DCU_MISC_VIRTCOL_IGNORE	1
 #define	AR5K_DCU_MISC_BCN_ENABLE	0x00010000	/* Enable Beacon use */
 #define	AR5K_DCU_MISC_ARBLOCK_CTL	0x00060000	/* Arbiter lockout control mask */
 #define	AR5K_DCU_MISC_ARBLOCK_CTL_S	17
@@ -768,8 +787,9 @@
 #define	AR5K_DCU_GBL_IFS_MISC_TURBO_MODE	0x00000008	/* Turbo mode */
 #define	AR5K_DCU_GBL_IFS_MISC_SIFS_DUR_USEC	0x000003f0	/* SIFS Duration mask */
 #define	AR5K_DCU_GBL_IFS_MISC_USEC_DUR		0x000ffc00	/* USEC Duration mask */
+#define	AR5K_DCU_GBL_IFS_MISC_USEC_DUR_S	10
 #define	AR5K_DCU_GBL_IFS_MISC_DCU_ARB_DELAY	0x00300000	/* DCU Arbiter delay mask */
-#define AR5K_DCU_GBL_IFS_MISC_SIFS_CNT_RST	0x00400000	/* SIFC cnt reset policy (?) */
+#define AR5K_DCU_GBL_IFS_MISC_SIFS_CNT_RST	0x00400000	/* SIFS cnt reset policy (?) */
 #define AR5K_DCU_GBL_IFS_MISC_AIFS_CNT_RST	0x00800000	/* AIFS cnt reset policy (?) */
 #define AR5K_DCU_GBL_IFS_MISC_RND_LFSR_SL_DIS	0x01000000	/* Disable random LFSR slice */
 
@@ -831,9 +851,11 @@
 #define AR5K_SLEEP_CTL_SLE_S		16
 #define AR5K_SLEEP_CTL_SLE_WAKE		0x00000000	/* Force chip awake */
 #define AR5K_SLEEP_CTL_SLE_SLP		0x00010000	/* Force chip sleep */
-#define AR5K_SLEEP_CTL_SLE_ALLOW	0x00020000
+#define AR5K_SLEEP_CTL_SLE_ALLOW	0x00020000	/* Normal sleep policy */
 #define AR5K_SLEEP_CTL_SLE_UNITS	0x00000008	/* [5211+] */
-/* more bits */
+#define AR5K_SLEEP_CTL_DUR_TIM_POL	0x00040000	/* Sleep duration timing policy */
+#define AR5K_SLEEP_CTL_DUR_WRITE_POL	0x00080000	/* Sleep duration write policy */
+#define AR5K_SLEEP_CTL_SLE_POL		0x00100000	/* Sleep policy mode */
 
 /*
  * Interrupt pending register
@@ -849,27 +871,28 @@
 
 /*
  * PCI configuration register
+ * TODO: Fix LED stuff
  */
 #define AR5K_PCICFG			0x4010			/* Register Address */
 #define AR5K_PCICFG_EEAE		0x00000001	/* Eeprom access enable [5210] */
-#define	AR5K_PCICFG_SLEEP_CLOCK_EN	0x00000002	/* Enable sleep clock (?) */
+#define AR5K_PCICFG_SLEEP_CLOCK_EN	0x00000002	/* Enable sleep clock */
 #define AR5K_PCICFG_CLKRUNEN		0x00000004	/* CLKRUN enable [5211+] */
 #define AR5K_PCICFG_EESIZE		0x00000018	/* Mask for EEPROM size [5211+] */
 #define AR5K_PCICFG_EESIZE_S		3
 #define AR5K_PCICFG_EESIZE_4K		0		/* 4K */
 #define AR5K_PCICFG_EESIZE_8K		1		/* 8K */
 #define AR5K_PCICFG_EESIZE_16K		2		/* 16K */
-#define AR5K_PCICFG_EESIZE_FAIL		3		/* Failed to get size (?) [5211+] */
+#define AR5K_PCICFG_EESIZE_FAIL		3		/* Failed to get size [5211+] */
 #define AR5K_PCICFG_LED			0x00000060	/* Led status [5211+] */
 #define AR5K_PCICFG_LED_NONE		0x00000000	/* Default [5211+] */
 #define AR5K_PCICFG_LED_PEND		0x00000020	/* Scan / Auth pending */
 #define AR5K_PCICFG_LED_ASSOC		0x00000040	/* Associated */
 #define	AR5K_PCICFG_BUS_SEL		0x00000380	/* Mask for "bus select" [5211+] (?) */
-#define	AR5K_PCICFG_CBEFIX_DIS		0x00000400	/* Disable CBE fix (?) */
-#define AR5K_PCICFG_SL_INTEN		0x00000800	/* Enable interrupts when asleep (?) */
+#define AR5K_PCICFG_CBEFIX_DIS		0x00000400	/* Disable CBE fix */
+#define AR5K_PCICFG_SL_INTEN		0x00000800	/* Enable interrupts when asleep */
 #define AR5K_PCICFG_LED_BCTL		0x00001000	/* Led blink (?) [5210] */
-#define	AR5K_PCICFG_UNK			0x00001000	/* Passed on some parts durring attach (?) */
-#define AR5K_PCICFG_SL_INPEN		0x00002000	/* Sleep even whith pending interrupts (?) */
+#define AR5K_PCICFG_RETRY_FIX		0x00001000	/* Enable pci core retry fix */
+#define AR5K_PCICFG_SL_INPEN		0x00002000	/* Sleep even whith pending interrupts*/
 #define AR5K_PCICFG_SPWR_DN		0x00010000	/* Mask for power status */
 #define AR5K_PCICFG_LEDMODE		0x000e0000	/* Ledmode [5211+] */
 #define AR5K_PCICFG_LEDMODE_PROP	0x00000000	/* Blink on standard traffic [5211+] */
@@ -882,7 +905,8 @@
 #define AR5K_PCICFG_LEDSTATE				\
 	(AR5K_PCICFG_LED | AR5K_PCICFG_LEDMODE |	\
 	AR5K_PCICFG_LEDBLINK | AR5K_PCICFG_LEDSLOW)
-#define	AR5K_PCICFG_SLEEP_CLOCK_RATE	0x03000000	/* Sleep clock rate (field) */
+#define	AR5K_PCICFG_SLEEP_CLOCK_RATE	0x03000000	/* Sleep clock rate */
+#define	AR5K_PCICFG_SLEEP_CLOCK_RATE_S	24
 
 /*
  * "General Purpose Input/Output" (GPIO) control register
@@ -904,8 +928,8 @@
 
 #define AR5K_GPIOCR		0x4014				/* Register Address */
 #define AR5K_GPIOCR_INT_ENA	0x00008000		/* Enable GPIO interrupt */
-#define AR5K_GPIOCR_INT_SELL	0x00000000		/* Generate interrupt when pin is off (?) */
-#define AR5K_GPIOCR_INT_SELH	0x00010000		/* Generate interrupt when pin is on */
+#define AR5K_GPIOCR_INT_SELL	0x00000000		/* Generate interrupt when pin is low */
+#define AR5K_GPIOCR_INT_SELH	0x00010000		/* Generate interrupt when pin is high */
 #define AR5K_GPIOCR_IN(n)	(0 << ((n) * 2))	/* Mode 0 for pin n */
 #define AR5K_GPIOCR_OUT0(n)	(1 << ((n) * 2))	/* Mode 1 for pin n */
 #define AR5K_GPIOCR_OUT1(n)	(2 << ((n) * 2))	/* Mode 2 for pin n */
@@ -923,7 +947,6 @@
 #define AR5K_GPIODI	0x401c
 #define AR5K_GPIODI_M	0x0000002f
 
-
 /*
  * Silicon revision register
  */
@@ -933,7 +956,59 @@
 #define AR5K_SREV_VER		0x000000ff	/* Mask for version */
 #define AR5K_SREV_VER_S		4
 
+/*
+ * TXE write posting register
+ */
+#define	AR5K_TXEPOST	0x4028
 
+/*
+ * QCU sleep mask
+ */
+#define	AR5K_QCU_SLEEP_MASK	0x402c
+
+/* 0x4068 is compression buffer configuration
+ * register on 5414 and pm configuration register
+ * on 5424 and newer pci-e chips. */
+
+/*
+ * Compression buffer configuration
+ * register (enable/disable) [5414]
+ */
+#define AR5K_5414_CBCFG		0x4068
+#define AR5K_5414_CBCFG_BUF_DIS	0x10	/* Disable buffer */
+
+/*
+ * PCI-E Power managment configuration
+ * and status register [5424+]
+ */
+#define	AR5K_PCIE_PM_CTL		0x4068			/* Register address */
+/* Only 5424 */
+#define	AR5K_PCIE_PM_CTL_L1_WHEN_D2	0x00000001	/* enable PCIe core enter L1
+							when d2_sleep_en is asserted */
+#define	AR5K_PCIE_PM_CTL_L0_L0S_CLEAR	0x00000002	/* Clear L0 and L0S counters */
+#define	AR5K_PCIE_PM_CTL_L0_L0S_EN	0x00000004	/* Start L0 nd L0S counters */
+#define	AR5K_PCIE_PM_CTL_LDRESET_EN	0x00000008	/* Enable reset when link goes
+							down */
+/* Wake On Wireless */
+#define	AR5K_PCIE_PM_CTL_PME_EN		0x00000010	/* PME Enable */
+#define	AR5K_PCIE_PM_CTL_AUX_PWR_DET	0x00000020	/* Aux power detect */
+#define	AR5K_PCIE_PM_CTL_PME_CLEAR	0x00000040	/* Clear PME */
+#define	AR5K_PCIE_PM_CTL_PSM_D0		0x00000080
+#define	AR5K_PCIE_PM_CTL_PSM_D1		0x00000100
+#define	AR5K_PCIE_PM_CTL_PSM_D2		0x00000200
+#define	AR5K_PCIE_PM_CTL_PSM_D3		0x00000400
+
+/*
+ * PCI-E Workaround enable register
+ */
+#define	AR5K_PCIE_WAEN	0x407c
+
+/*
+ * PCI-E Serializer/Desirializer
+ * registers
+ */
+#define	AR5K_PCIE_SERDES	0x4080
+#define	AR5K_PCIE_SERDES_RESET	0x4084
 
 /*====EEPROM REGISTERS====*/
 
@@ -1006,14 +1081,28 @@
  * EEPROM config register
  */
 #define AR5K_EEPROM_CFG			0x6010			/* Register Addres */
-#define AR5K_EEPROM_CFG_SIZE_OVR	0x00000001
+#define AR5K_EEPROM_CFG_SIZE		0x00000003	/* Size determination override */
+#define AR5K_EEPROM_CFG_SIZE_AUTO	0
+#define AR5K_EEPROM_CFG_SIZE_4KBIT	1
+#define AR5K_EEPROM_CFG_SIZE_8KBIT	2
+#define AR5K_EEPROM_CFG_SIZE_16KBIT	3
 #define AR5K_EEPROM_CFG_WR_WAIT_DIS	0x00000004	/* Disable write wait */
 #define AR5K_EEPROM_CFG_CLK_RATE	0x00000018	/* Clock rate */
-#define AR5K_EEPROM_CFG_PROT_KEY	0x00ffff00	/* Protectio key */
+#define AR5K_EEPROM_CFG_CLK_RATE_S		3
+#define AR5K_EEPROM_CFG_CLK_RATE_156KHZ	0
+#define AR5K_EEPROM_CFG_CLK_RATE_312KHZ	1
+#define AR5K_EEPROM_CFG_CLK_RATE_625KHZ	2
+#define AR5K_EEPROM_CFG_PROT_KEY	0x00ffff00	/* Protection key */
+#define AR5K_EEPROM_CFG_PROT_KEY_S	8
 #define AR5K_EEPROM_CFG_LIND_EN	0x01000000	/* Enable length indicator (?) */
 
 
 /*
+ * TODO: Wake On Wireless registers
+ * Range 0x7000 - 0x7ce0
+ */
+
+/*
  * Protocol Control Unit (PCU) registers
  */
 /*
@@ -1045,11 +1134,13 @@
 #define AR5K_STA_ID1_DESC_ANTENNA	0x00400000	/* Update antenna from descriptor */
 #define AR5K_STA_ID1_RTS_DEF_ANTENNA	0x00800000	/* Use default antenna for RTS */
 #define AR5K_STA_ID1_ACKCTS_6MB		0x01000000	/* Use 6Mbit/s for ACK/CTS */
-#define AR5K_STA_ID1_BASE_RATE_11B	0x02000000	/* Use 11b base rate (for ACK/CTS ?) [5211+] */
-#define AR5K_STA_ID1_SELF_GEN_SECTORE	0x04000000	/* Self generate sectore (?) */
+#define AR5K_STA_ID1_BASE_RATE_11B	0x02000000	/* Use 11b base rate for ACK/CTS [5211+] */
+#define AR5K_STA_ID1_SELFGEN_DEF_ANT	0x04000000	/* Use def. antenna for self generated frames */
 #define AR5K_STA_ID1_CRYPT_MIC_EN	0x08000000	/* Enable MIC */
-#define AR5K_STA_ID1_KEYSRCH_MODE	0x10000000	/* Keysearch mode (?) */
+#define AR5K_STA_ID1_KEYSRCH_MODE	0x10000000	/* Look up key when key id != 0 */
 #define AR5K_STA_ID1_PRESERVE_SEQ_NUM	0x20000000	/* Preserve sequence number */
+#define AR5K_STA_ID1_CBCIV_ENDIAN	0x40000000	/* ??? */
+#define AR5K_STA_ID1_KEYSRCH_MCAST	0x80000000	/* Do key cache search for mcast frames */
 
 /*
  * First BSSID register (MAC address, lower 32bits)
@@ -1308,16 +1399,16 @@
 #define AR5K_DIAG_SW_LOOP_BACK_5211	0x00000040
 #define AR5K_DIAG_SW_LOOP_BACK		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_LOOP_BACK_5210 : AR5K_DIAG_SW_LOOP_BACK_5211)
-#define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100
+#define AR5K_DIAG_SW_CORR_FCS_5210	0x00000100	/* Corrupted FCS */
 #define AR5K_DIAG_SW_CORR_FCS_5211	0x00000080
 #define AR5K_DIAG_SW_CORR_FCS		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CORR_FCS_5210 : AR5K_DIAG_SW_CORR_FCS_5211)
-#define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200
+#define AR5K_DIAG_SW_CHAN_INFO_5210	0x00000200	/* Dump channel info */
 #define AR5K_DIAG_SW_CHAN_INFO_5211	0x00000100
 #define AR5K_DIAG_SW_CHAN_INFO		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_CHAN_INFO_5210 : AR5K_DIAG_SW_CHAN_INFO_5211)
-#define AR5K_DIAG_SW_EN_SCRAM_SEED_5211	0x00000200	/* Enable scrambler seed */
-#define AR5K_DIAG_SW_EN_SCRAM_SEED_5210	0x00000400
+#define AR5K_DIAG_SW_EN_SCRAM_SEED_5210	0x00000400	/* Enable fixed scrambler seed */
+#define AR5K_DIAG_SW_EN_SCRAM_SEED_5211	0x00000200
 #define AR5K_DIAG_SW_EN_SCRAM_SEED	(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_EN_SCRAM_SEED_5210 : AR5K_DIAG_SW_EN_SCRAM_SEED_5211)
 #define AR5K_DIAG_SW_ECO_ENABLE		0x00000400	/* [5211+] */
@@ -1326,12 +1417,15 @@
 #define AR5K_DIAG_SW_SCRAM_SEED_S	10
 #define AR5K_DIAG_SW_DIS_SEQ_INC	0x00040000	/* Disable seqnum increment (?)[5210] */
 #define AR5K_DIAG_SW_FRAME_NV0_5210	0x00080000
-#define AR5K_DIAG_SW_FRAME_NV0_5211	0x00020000
+#define AR5K_DIAG_SW_FRAME_NV0_5211	0x00020000	/* Accept frames of non-zero protocol number */
 #define	AR5K_DIAG_SW_FRAME_NV0		(ah->ah_version == AR5K_AR5210 ? \
 					AR5K_DIAG_SW_FRAME_NV0_5210 : AR5K_DIAG_SW_FRAME_NV0_5211)
-#define AR5K_DIAG_SW_OBSPT_M		0x000c0000
+#define AR5K_DIAG_SW_OBSPT_M		0x000c0000	/* Observation point select (?) */
 #define AR5K_DIAG_SW_OBSPT_S		18
-/* more bits */
+#define AR5K_DIAG_SW_RX_CLEAR_HIGH	0x0010000	/* Force RX Clear high */
+#define AR5K_DIAG_SW_IGNORE_CARR_SENSE	0x0020000	/* Ignore virtual carrier sense */
+#define AR5K_DIAG_SW_CHANEL_IDLE_HIGH	0x0040000	/* Force channel idle high (?) */
+#define AR5K_DIAG_SW_PHEAR_ME		0x0080000	/* ??? */
 
 /*
  * TSF (clock) register (lower 32 bits)
@@ -1542,16 +1636,16 @@
  *
  * XXX: PCDAC steps (0.5dbm) or DBM ?
  *
- * XXX: Mask changes for newer chips to 7f
- *      like tx power table ?
  */
 #define AR5K_TXPC			0x80e8			/* Register Address */
-#define AR5K_TXPC_ACK_M			0x0000003f	/* Mask for ACK tx power */
+#define AR5K_TXPC_ACK_M			0x0000003f	/* ACK tx power */
 #define AR5K_TXPC_ACK_S			0
-#define AR5K_TXPC_CTS_M			0x00003f00	/* Mask for CTS tx power */
+#define AR5K_TXPC_CTS_M			0x00003f00	/* CTS tx power */
 #define AR5K_TXPC_CTS_S			8
-#define AR5K_TXPC_CHIRP_M		0x003f0000	/* Mask for CHIRP tx power */
-#define AR5K_TXPC_CHIRP_S		22
+#define AR5K_TXPC_CHIRP_M		0x003f0000	/* CHIRP tx power */
+#define AR5K_TXPC_CHIRP_S		16
+#define AR5K_TXPC_DOPPLER		0x0f000000	/* Doppler chirp span (?) */
+#define AR5K_TXPC_DOPPLER_S		24
 
 /*
  * Profile count registers
@@ -1562,14 +1656,19 @@
 #define AR5K_PROFCNT_CYCLE		0x80f8	/* Cycle count (?) */
 
 /*
- * Quiet (period) control registers (?)
+ * Quiet period control registers
  */
 #define AR5K_QUIET_CTL1			0x80fc			/* Register Address */
-#define AR5K_QUIET_CTL1_NEXT_QT		0x0000ffff	/* Mask for next quiet (period?) (?) */
-#define AR5K_QUIET_CTL1_QT_EN		0x00010000	/* Enable quiet (period?) */
+#define AR5K_QUIET_CTL1_NEXT_QT_TSF	0x0000ffff	/* Next quiet period TSF (TU) */
+#define AR5K_QUIET_CTL1_NEXT_QT_TSF_0
+#define AR5K_QUIET_CTL1_QT_EN		0x00010000	/* Enable quiet period */
+#define AR5K_QUIET_CTL1_ACK_CTS_EN	0x00020000	/* Send ACK/CTS during quiet period */
+
 #define AR5K_QUIET_CTL2			0x8100			/* Register Address */
-#define AR5K_QUIET_CTL2_QT_PER		0x0000ffff	/* Mask for quiet period (?) */
-#define AR5K_QUIET_CTL2_QT_DUR		0xffff0000	/* Mask for quiet duration (?) */
+#define AR5K_QUIET_CTL2_QT_PER		0x0000ffff	/* Mask for quiet period periodicity */
+#define AR5K_QUIET_CTL2_QT_PER_S	0
+#define AR5K_QUIET_CTL2_QT_DUR		0xffff0000	/* Mask for quiet period duration */
+#define AR5K_QUIET_CTL2_QT_DUR_S	16
 
 /*
  * TSF parameter register
@@ -1579,12 +1678,15 @@
 #define AR5K_TSF_PARM_INC_S		0
 
 /*
- * QoS register (?)
+ * QoS NOACK policy
  */
-#define AR5K_QOS			0x8108			/* Register Address */
-#define AR5K_QOS_NOACK_2BIT_VALUES	0x00000000	/* (field) */
-#define AR5K_QOS_NOACK_BIT_OFFSET	0x00000020	/* (field) */
-#define AR5K_QOS_NOACK_BYTE_OFFSET	0x00000080	/* (field) */
+#define AR5K_QOS_NOACK			0x8108			/* Register Address */
+#define AR5K_QOS_NOACK_2BIT_VALUES	0x0000000f	/* ??? */
+#define AR5K_QOS_NOACK_2BIT_VALUES_S	0
+#define AR5K_QOS_NOACK_BIT_OFFSET	0x00000070	/* ??? */
+#define AR5K_QOS_NOACK_BIT_OFFSET_S	4
+#define AR5K_QOS_NOACK_BYTE_OFFSET	0x00000180	/* ??? */
+#define AR5K_QOS_NOACK_BYTE_OFFSET_S	8
 
 /*
  * PHY error filter register
@@ -1608,29 +1710,15 @@
 /*
  * MIC QoS control register (?)
  */
-#define	AR5K_MIC_QOS_CTL	0x8118			/* Register Address */
-#define	AR5K_MIC_QOS_CTL_0	0x00000001	/* MIC QoS control 0 (?) */
-#define	AR5K_MIC_QOS_CTL_1	0x00000004	/* MIC QoS control 1 (?) */
-#define	AR5K_MIC_QOS_CTL_2	0x00000010	/* MIC QoS control 2 (?) */
-#define	AR5K_MIC_QOS_CTL_3	0x00000040	/* MIC QoS control 3 (?) */
-#define	AR5K_MIC_QOS_CTL_4	0x00000100	/* MIC QoS control 4 (?) */
-#define	AR5K_MIC_QOS_CTL_5	0x00000400	/* MIC QoS control 5 (?) */
-#define	AR5K_MIC_QOS_CTL_6	0x00001000	/* MIC QoS control 6 (?) */
-#define	AR5K_MIC_QOS_CTL_7	0x00004000	/* MIC QoS control 7 (?) */
-#define	AR5K_MIC_QOS_CTL_MQ_EN	0x00010000	/* Enable MIC QoS */
+#define	AR5K_MIC_QOS_CTL		0x8118			/* Register Address */
+#define	AR5K_MIC_QOS_CTL_OFF(_n)	(1 << (_n * 2))
+#define	AR5K_MIC_QOS_CTL_MQ_EN		0x00010000	/* Enable MIC QoS */
 
 /*
  * MIC QoS select register (?)
  */
-#define	AR5K_MIC_QOS_SEL	0x811c
-#define	AR5K_MIC_QOS_SEL_0	0x00000001
-#define	AR5K_MIC_QOS_SEL_1	0x00000010
-#define	AR5K_MIC_QOS_SEL_2	0x00000100
-#define	AR5K_MIC_QOS_SEL_3	0x00001000
-#define	AR5K_MIC_QOS_SEL_4	0x00010000
-#define	AR5K_MIC_QOS_SEL_5	0x00100000
-#define	AR5K_MIC_QOS_SEL_6	0x01000000
-#define	AR5K_MIC_QOS_SEL_7	0x10000000
+#define	AR5K_MIC_QOS_SEL		0x811c
+#define	AR5K_MIC_QOS_SEL_OFF(_n)	(1 << (_n * 4))
 
 /*
  * Misc mode control register (?)
@@ -1665,6 +1753,11 @@
 #define	AR5K_TSF_THRES			0x813c
 
 /*
+ * TODO: Wake On Wireless registers
+ * Range: 0x8147 - 0x818c
+ */
+
+/*
  * Rate -> ACK SIFS mapping table (32 entries)
  */
 #define	AR5K_RATE_ACKSIFS_BASE		0x8680			/* Register Address */
@@ -1779,7 +1872,8 @@
  */
 #define	AR5K_PHY_TURBO			0x9804			/* Register Address */
 #define	AR5K_PHY_TURBO_MODE		0x00000001	/* Enable turbo mode */
-#define	AR5K_PHY_TURBO_SHORT		0x00000002	/* Short mode (20Mhz channels) (?) */
+#define	AR5K_PHY_TURBO_SHORT		0x00000002	/* Set short symbols to turbo mode */
+#define	AR5K_PHY_TURBO_MIMO		0x00000004	/* Set turbo for mimo mimo */
 
 /*
  * PHY agility command register
@@ -1789,6 +1883,11 @@
 #define	AR5K_PHY_TST1			0x9808
 #define	AR5K_PHY_AGC_DISABLE		0x08000000	/* Disable AGC to A2 (?)*/
 #define	AR5K_PHY_TST1_TXHOLD		0x00003800	/* Set tx hold (?) */
+#define	AR5K_PHY_TST1_TXSRC_SRC		0x00000002	/* Used with bit 7 (?) */
+#define	AR5K_PHY_TST1_TXSRC_SRC_S	1
+#define	AR5K_PHY_TST1_TXSRC_ALT		0x00000080	/* Set input to tsdac (?) */
+#define	AR5K_PHY_TST1_TXSRC_ALT_S	7
+
 
 /*
  * PHY timing register 3 [5112+]
@@ -1813,15 +1912,23 @@
 
 /*
  * PHY RF control registers
- * (i think these are delay times,
- * these calibration values exist
- * in EEPROM)
  */
 #define AR5K_PHY_RF_CTL2		0x9824			/* Register Address */
-#define	AR5K_PHY_RF_CTL2_TXF2TXD_START	0x0000000f	/* Mask for TX frame to TX d(esc?) start */
+#define	AR5K_PHY_RF_CTL2_TXF2TXD_START	0x0000000f	/* TX frame to TX data start */
+#define	AR5K_PHY_RF_CTL2_TXF2TXD_START_S	0
 
 #define AR5K_PHY_RF_CTL3		0x9828			/* Register Address */
-#define AR5K_PHY_RF_CTL3_TXE2XLNA_ON	0x0000000f	/* Mask for TX end to XLNA on */
+#define AR5K_PHY_RF_CTL3_TXE2XLNA_ON	0x0000000f	/* TX end to XLNA on */
+#define	AR5K_PHY_RF_CTL3_TXE2XLNA_ON_S	0
+
+#define	AR5K_PHY_ADC_CTL			0x982c
+#define	AR5K_PHY_ADC_CTL_INBUFGAIN_OFF		0x00000003
+#define	AR5K_PHY_ADC_CTL_INBUFGAIN_OFF_S	0
+#define	AR5K_PHY_ADC_CTL_PWD_DAC_OFF		0x00002000
+#define	AR5K_PHY_ADC_CTL_PWD_BAND_GAP_OFF	0x00004000
+#define	AR5K_PHY_ADC_CTL_PWD_ADC_OFF		0x00008000
+#define	AR5K_PHY_ADC_CTL_INBUFGAIN_ON		0x00030000
+#define	AR5K_PHY_ADC_CTL_INBUFGAIN_ON_S		16
 
 #define AR5K_PHY_RF_CTL4		0x9834			/* Register Address */
 #define AR5K_PHY_RF_CTL4_TXF2XPA_A_ON	0x00000001	/* TX frame to XPA A on (field) */
@@ -1843,14 +1950,19 @@
  * PHY settling register
  */
 #define AR5K_PHY_SETTLING		0x9844			/* Register Address */
-#define	AR5K_PHY_SETTLING_AGC		0x0000007f	/* Mask for AGC settling time */
-#define	AR5K_PHY_SETTLING_SWITCH	0x00003f80	/* Mask for Switch settlig time */
+#define	AR5K_PHY_SETTLING_AGC		0x0000007f	/* AGC settling time */
+#define	AR5K_PHY_SETTLING_AGC_S		0
+#define	AR5K_PHY_SETTLING_SWITCH	0x00003f80	/* Switch settlig time */
+#define	AR5K_PHY_SETTLINK_SWITCH_S	7
 
 /*
  * PHY Gain registers
  */
 #define AR5K_PHY_GAIN			0x9848			/* Register Address */
-#define	AR5K_PHY_GAIN_TXRX_ATTEN	0x0003f000	/* Mask for TX-RX Attenuation */
+#define	AR5K_PHY_GAIN_TXRX_ATTEN	0x0003f000	/* TX-RX Attenuation */
+#define	AR5K_PHY_GAIN_TXRX_ATTEN_S	12
+#define	AR5K_PHY_GAIN_TXRX_RF_MAX	0x007c0000
+#define	AR5K_PHY_GAIN_TXRX_RF_MAX_S	18
 
 #define	AR5K_PHY_GAIN_OFFSET		0x984c			/* Register Address */
 #define	AR5K_PHY_GAIN_OFFSET_RXTX_FLAG	0x00020000	/* RX-TX flag (?) */
@@ -1860,18 +1972,21 @@
  * (for more infos read ANI patent)
  */
 #define AR5K_PHY_DESIRED_SIZE		0x9850			/* Register Address */
-#define	AR5K_PHY_DESIRED_SIZE_ADC	0x000000ff	/* Mask for ADC desired size */
-#define	AR5K_PHY_DESIRED_SIZE_PGA	0x0000ff00	/* Mask for PGA desired size */
-#define	AR5K_PHY_DESIRED_SIZE_TOT	0x0ff00000	/* Mask for Total desired size */
+#define	AR5K_PHY_DESIRED_SIZE_ADC	0x000000ff	/* ADC desired size */
+#define	AR5K_PHY_DESIRED_SIZE_ADC_S	0
+#define	AR5K_PHY_DESIRED_SIZE_PGA	0x0000ff00	/* PGA desired size */
+#define	AR5K_PHY_DESIRED_SIZE_PGA_S	8
+#define	AR5K_PHY_DESIRED_SIZE_TOT	0x0ff00000	/* Total desired size */
+#define	AR5K_PHY_DESIRED_SIZE_TOT_S	20
 
 /*
  * PHY signal register
  * (for more infos read ANI patent)
  */
 #define	AR5K_PHY_SIG			0x9858			/* Register Address */
-#define	AR5K_PHY_SIG_FIRSTEP		0x0003f000	/* Mask for FIRSTEP */
+#define	AR5K_PHY_SIG_FIRSTEP		0x0003f000	/* FIRSTEP */
 #define	AR5K_PHY_SIG_FIRSTEP_S		12
-#define	AR5K_PHY_SIG_FIRPWR		0x03fc0000	/* Mask for FIPWR */
+#define	AR5K_PHY_SIG_FIRPWR		0x03fc0000	/* FIPWR */
 #define	AR5K_PHY_SIG_FIRPWR_S		18
 
 /*
@@ -1879,9 +1994,9 @@
  * (for more infos read ANI patent)
  */
 #define	AR5K_PHY_AGCCOARSE		0x985c			/* Register Address */
-#define	AR5K_PHY_AGCCOARSE_LO		0x00007f80	/* Mask for AGC Coarse low */
+#define	AR5K_PHY_AGCCOARSE_LO		0x00007f80	/* AGC Coarse low */
 #define	AR5K_PHY_AGCCOARSE_LO_S		7
-#define	AR5K_PHY_AGCCOARSE_HI		0x003f8000	/* Mask for AGC Coarse high */
+#define	AR5K_PHY_AGCCOARSE_HI		0x003f8000	/* AGC Coarse high */
 #define	AR5K_PHY_AGCCOARSE_HI_S		15
 
 /*
@@ -1890,6 +2005,8 @@
 #define	AR5K_PHY_AGCCTL			0x9860			/* Register address */
 #define	AR5K_PHY_AGCCTL_CAL		0x00000001	/* Enable PHY calibration */
 #define	AR5K_PHY_AGCCTL_NF		0x00000002	/* Enable Noise Floor calibration */
+#define	AR5K_PHY_AGCCTL_NF_EN		0x00008000	/* Enable nf calibration to happen (?) */
+#define	AR5K_PHY_AGCCTL_NF_NOUPDATE	0x00020000	/* Don't update nf automaticaly */
 
 /*
  * PHY noise floor status register
@@ -1900,7 +2017,10 @@
 #define AR5K_PHY_NF_RVAL(_n)		(((_n) >> 19) & AR5K_PHY_NF_M)
 #define AR5K_PHY_NF_AVAL(_n)		(-((_n) ^ AR5K_PHY_NF_M) + 1)
 #define AR5K_PHY_NF_SVAL(_n)		(((_n) & AR5K_PHY_NF_M) | (1 << 9))
-#define	AR5K_PHY_NF_THRESH62		0x00001000	/* Thresh62 -check ANI patent- (field) */
+#define	AR5K_PHY_NF_THRESH62		0x0007f000	/* Thresh62 -check ANI patent- (field) */
+#define	AR5K_PHY_NF_THRESH62_S		12
+#define	AR5K_PHY_NF_MINCCA_PWR		0x0ff80000	/* ??? */
+#define	AR5K_PHY_NF_MINCCA_PWR_S	19
 
 /*
  * PHY ADC saturation register [5110]
@@ -1940,24 +2060,31 @@
  */
 #define AR5K_PHY_SCR			0x9870
 #define AR5K_PHY_SCR_32MHZ		0x0000001f
+
 #define AR5K_PHY_SLMT			0x9874
 #define AR5K_PHY_SLMT_32MHZ		0x0000007f
+
 #define AR5K_PHY_SCAL			0x9878
 #define AR5K_PHY_SCAL_32MHZ		0x0000000e
 
+
 /*
  * PHY PLL (Phase Locked Loop) control register
  */
 #define	AR5K_PHY_PLL			0x987c
-#define	AR5K_PHY_PLL_20MHZ		0x13	/* For half rate (?) [5111+] */
-#define	AR5K_PHY_PLL_40MHZ_5211		0x18	/* For 802.11a */
+#define	AR5K_PHY_PLL_20MHZ		0x00000013	/* For half rate (?) */
+/* 40MHz -> 5GHz band */
+#define	AR5K_PHY_PLL_40MHZ_5211		0x00000018
 #define	AR5K_PHY_PLL_40MHZ_5212		0x000000aa
+#define	AR5K_PHY_PLL_40MHZ_5413		0x00000004
 #define	AR5K_PHY_PLL_40MHZ		(ah->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_40MHZ_5211 : AR5K_PHY_PLL_40MHZ_5212)
-#define	AR5K_PHY_PLL_44MHZ_5211		0x19	/* For 802.11b/g */
+/* 44MHz -> 2.4GHz band */
+#define	AR5K_PHY_PLL_44MHZ_5211		0x00000019
 #define	AR5K_PHY_PLL_44MHZ_5212		0x000000ab
 #define	AR5K_PHY_PLL_44MHZ		(ah->ah_version == AR5K_AR5211 ? \
 					AR5K_PHY_PLL_44MHZ_5211 : AR5K_PHY_PLL_44MHZ_5212)
+
 #define AR5K_PHY_PLL_RF5111		0x00000000
 #define AR5K_PHY_PLL_RF5112		0x00000040
 #define	AR5K_PHY_PLL_HALF_RATE		0x00000100
@@ -2024,6 +2151,19 @@
 #define AR5K_PHY_RFSTG_DISABLE		0x00000021
 
 /*
+ * BIN masks (?)
+ */
+#define	AR5K_PHY_BIN_MASK_1	0x9900
+#define	AR5K_PHY_BIN_MASK_2	0x9904
+#define	AR5K_PHY_BIN_MASK_3	0x9908
+
+#define	AR5K_PHY_BIN_MASK_CTL		0x990c
+#define	AR5K_PHY_BIN_MASK_CTL_MASK_4	0x00003fff
+#define	AR5K_PHY_BIN_MASK_CTL_MASK_4_S	0
+#define	AR5K_PHY_BIN_MASK_CTL_RATE	0xff000000
+#define	AR5K_PHY_BIN_MASK_CTL_RATE_S	24
+
+/*
  * PHY Antenna control register
  */
 #define AR5K_PHY_ANT_CTL		0x9910			/* Register Address */
@@ -2070,6 +2210,7 @@
 #define	AR5K_PHY_OFDM_SELFCORR			0x9924			/* Register Address */
 #define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_EN	0x00000001	/* Enable cyclic RSSI thr 1 */
 #define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1	0x000000fe	/* Mask for Cyclic RSSI threshold 1 */
+#define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR1_S	0
 #define	AR5K_PHY_OFDM_SELFCORR_CYPWR_THR3	0x00000100	/* Cyclic RSSI threshold 3 (field) (?) */
 #define	AR5K_PHY_OFDM_SELFCORR_RSSI_1ATHR_EN	0x00008000	/* Enable 1A RSSI threshold (?) */
 #define	AR5K_PHY_OFDM_SELFCORR_RSSI_1ATHR	0x00010000	/* 1A RSSI threshold (field) (?) */
@@ -2116,7 +2257,6 @@
 #define	AR5K_PHY_PAPD_PROBE_INI_5111	0x00004883	/* [5212+] */
 #define	AR5K_PHY_PAPD_PROBE_INI_5112	0x00004882	/* [5212+] */
 
-
 /*
  * PHY TX rate power registers [5112+]
  */
@@ -2138,6 +2278,8 @@
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP	0x00000038	/* Mask for tx clip (?) */
 #define	AR5K_PHY_FRAME_CTL_TX_CLIP_S	3
 #define	AR5K_PHY_FRAME_CTL_PREP_CHINFO	0x00010000	/* Prepend chan info */
+#define	AR5K_PHY_FRAME_CTL_EMU		0x80000000
+#define	AR5K_PHY_FRAME_CTL_EMU_S	31
 /*---[5110/5111]---*/
 #define	AR5K_PHY_FRAME_CTL_TIMING_ERR	0x01000000	/* PHY timing error */
 #define	AR5K_PHY_FRAME_CTL_PARITY_ERR	0x02000000	/* Parity error */
@@ -2156,48 +2298,36 @@
  * PHY radar detection register [5111+]
  */
 #define	AR5K_PHY_RADAR			0x9954
-
-/* Radar enable 			........ ........ ........ .......1 */
 #define	AR5K_PHY_RADAR_ENABLE		0x00000001
-#define	AR5K_PHY_RADAR_DISABLE          0x00000000
-#define	AR5K_PHY_RADAR_ENABLE_S		0
-
-/* This is the value found on the card  .1.111.1 .1.1.... 111....1 1...1...
-at power on. */
-#define	AR5K_PHY_RADAR_PWONDEF_AR5213	0x5d50e188
-
-/* This is the value found on the card 	.1.1.111 ..11...1 .1...1.1 1...11.1
-after DFS is enabled */
-#define	AR5K_PHY_RADAR_ENABLED_AR5213	0x5731458d
-
-/* Finite Impulse Response (FIR) filter .1111111 ........ ........ ........
- * power out threshold.
- * 7-bits, standard power range {0..127} in 1/2 dBm units. */
-#define AR5K_PHY_RADAR_FIRPWROUTTHR    	0x7f000000
-#define AR5K_PHY_RADAR_FIRPWROUTTHR_S	24
-
-/* Radar RSSI/SNR threshold.		........ 111111.. ........ ........
- * 6-bits, dBm range {0..63} in dBm units. */
-#define AR5K_PHY_RADAR_RADARRSSITHR    	0x00fc0000
-#define AR5K_PHY_RADAR_RADARRSSITHR_S	18
-
-/* Pulse height threshold 		........ ......11 1111.... ........
- * 6-bits, dBm range {0..63} in dBm units. */
-#define AR5K_PHY_RADAR_PULSEHEIGHTTHR   0x0003f000
-#define AR5K_PHY_RADAR_PULSEHEIGHTTHR_S	12
-
-/* Pulse RSSI/SNR threshold		........ ........ ....1111 11......
- * 6-bits, dBm range {0..63} in dBm units. */
-#define AR5K_PHY_RADAR_PULSERSSITHR    	0x00000fc0
-#define AR5K_PHY_RADAR_PULSERSSITHR_S	6
-
-/* Inband threshold  			........ ........ ........ ..11111.
- * 5-bits, units unknown {0..31} (? MHz ?) */
-#define AR5K_PHY_RADAR_INBANDTHR    	0x0000003e
+#define	AR5K_PHY_RADAR_DISABLE		0x00000000
+#define AR5K_PHY_RADAR_INBANDTHR    	0x0000003e	/* Inband threshold
+							5-bits, units unknown {0..31}
+							(? MHz ?) */
 #define AR5K_PHY_RADAR_INBANDTHR_S	1
 
+#define AR5K_PHY_RADAR_PRSSI_THR    	0x00000fc0	/* Pulse RSSI/SNR threshold
+							6-bits, dBm range {0..63}
+							in dBm units. */
+#define AR5K_PHY_RADAR_PRSSI_THR_S	6
+
+#define AR5K_PHY_RADAR_PHEIGHT_THR   	0x0003f000	/* Pulse height threshold
+							6-bits, dBm range {0..63}
+							in dBm units. */
+#define AR5K_PHY_RADAR_PHEIGHT_THR_S	12
+
+#define AR5K_PHY_RADAR_RSSI_THR    	0x00fc0000	/* Radar RSSI/SNR threshold.
+							6-bits, dBm range {0..63}
+							in dBm units. */
+#define AR5K_PHY_RADAR_RSSI_THR_S	18
+
+#define AR5K_PHY_RADAR_FIRPWR_THR	0x7f000000	/* Finite Impulse Response
+							filter power out threshold.
+							7-bits, standard power range
+							{0..127} in 1/2 dBm units. */
+#define AR5K_PHY_RADAR_FIRPWR_THRS	24
+
 /*
- * PHY antenna switch table registers [5110]
+ * PHY antenna switch table registers
  */
 #define AR5K_PHY_ANT_SWITCH_TABLE_0	0x9960
 #define AR5K_PHY_ANT_SWITCH_TABLE_1	0x9964
@@ -2208,25 +2338,65 @@ after DFS is enabled */
 #define AR5K_PHY_NFTHRES		0x9968
 
 /*
- * PHY clock sleep registers [5112+]
+ * Sigma Delta register (?) [5213]
  */
-#define AR5K_PHY_SCLOCK			0x99f0
-#define AR5K_PHY_SCLOCK_32MHZ		0x0000000c
-#define AR5K_PHY_SDELAY			0x99f4
-#define AR5K_PHY_SDELAY_32MHZ		0x000000ff
-#define AR5K_PHY_SPENDING		0x99f8
-#define	AR5K_PHY_SPENDING_14		0x00000014
-#define	AR5K_PHY_SPENDING_18		0x00000018
-#define AR5K_PHY_SPENDING_RF5111	0x00000018
-#define AR5K_PHY_SPENDING_RF5112	0x00000014
-/* #define AR5K_PHY_SPENDING_RF5112A	0x0000000e */
-/* #define AR5K_PHY_SPENDING_RF5424	0x00000012 */
-#define	AR5K_PHY_SPENDING_RF5413	0x00000014
-#define	AR5K_PHY_SPENDING_RF2413	0x00000014
-#define	AR5K_PHY_SPENDING_RF2425	0x00000018
+#define AR5K_PHY_SIGMA_DELTA		0x996C
+#define AR5K_PHY_SIGMA_DELTA_ADC_SEL	0x00000003
+#define AR5K_PHY_SIGMA_DELTA_ADC_SEL_S	0
+#define AR5K_PHY_SIGMA_DELTA_FILT2	0x000000f8
+#define AR5K_PHY_SIGMA_DELTA_FILT2_S	3
+#define AR5K_PHY_SIGMA_DELTA_FILT1	0x00001f00
+#define AR5K_PHY_SIGMA_DELTA_FILT1_S	8
+#define AR5K_PHY_SIGMA_DELTA_ADC_CLIP	0x01ff3000
+#define AR5K_PHY_SIGMA_DELTA_ADC_CLIP_S	13
+
+/*
+ * RF restart register [5112+] (?)
+ */
+#define AR5K_PHY_RESTART		0x9970		/* restart */
+#define AR5K_PHY_RESTART_DIV_GC	0x001c0000	/* Fast diversity gc_limit (?) */
+#define AR5K_PHY_RESTART_DIV_GC_S	18
+
+/*
+ * RF Bus access request register (for synth-oly channel switching)
+ */
+#define AR5K_PHY_RFBUS_REQ		0x997C
+#define AR5K_PHY_RFBUS_REQ_REQUEST	0x00000001
 
 /*
- * Misc PHY/radio registers [5110 - 5111]
+ * Spur mitigation masks (?)
+ */
+#define AR5K_PHY_TIMING_7		0x9980
+#define AR5K_PHY_TIMING_8		0x9984
+#define AR5K_PHY_TIMING_8_PILOT_MASK_2	0x000fffff
+#define AR5K_PHY_TIMING_8_PILOT_MASK_2_S	0
+
+#define AR5K_PHY_BIN_MASK2_1		0x9988
+#define AR5K_PHY_BIN_MASK2_2		0x998c
+#define AR5K_PHY_BIN_MASK2_3		0x9990
+
+#define AR5K_PHY_BIN_MASK2_4		0x9994
+#define AR5K_PHY_BIN_MASK2_4_MASK_4	0x00003fff
+#define AR5K_PHY_BIN_MASK2_4_MASK_4_S		0
+
+#define AR_PHY_TIMING_9			0x9998
+#define AR_PHY_TIMING_10			0x999c
+#define AR_PHY_TIMING_10_PILOT_MASK_2		0x000fffff
+#define AR_PHY_TIMING_10_PILOT_MASK_2_S	0
+
+/*
+ * Spur mitigation control
+ */
+#define AR_PHY_TIMING_11			0x99a0			/* Register address */
+#define AR_PHY_TIMING_11_SPUR_DELTA_PHASE	0x000fffff	/* Spur delta phase */
+#define AR_PHY_TIMING_11_SPUR_DELTA_PHASE_S	0
+#define AR_PHY_TIMING_11_SPUR_FREQ_SD		0x3ff00000	/* Freq sigma delta */
+#define AR_PHY_TIMING_11_SPUR_FREQ_SD_S	20
+#define AR_PHY_TIMING_11_USE_SPUR_IN_AGC	0x40000000	/* Spur filter in AGC detector */
+#define AR_PHY_TIMING_11_USE_SPUR_IN_SELFCOR	0x80000000	/* Spur filter in OFDM self correlator */
+
+/*
+ * Gain tables
  */
 #define	AR5K_BB_GAIN_BASE		0x9b00	/* BaseBand Amplifier Gain table base address */
 #define AR5K_BB_GAIN(_n)		(AR5K_BB_GAIN_BASE + ((_n) << 2))
@@ -2246,9 +2416,10 @@ after DFS is enabled */
 #define	AR5K_PHY_CURRENT_RSSI	0x9c1c
 
 /*
- * PHY RF Bus grant register (?)
+ * PHY RF Bus grant register
  */
 #define	AR5K_PHY_RFBUS_GRANT	0x9c20
+#define	AR5K_PHY_RFBUS_GRANT_OK	0x00000001
 
 /*
  * PHY ADC test register
@@ -2292,6 +2463,31 @@ after DFS is enabled */
 #define	AR5K_PHY_CHAN_STATUS_RX_CLR_PAP	0x00000008
 
 /*
+ * Heavy clip enable register
+ */
+#define	AR5K_PHY_HEAVY_CLIP_ENABLE	0x99e0
+
+/*
+ * PHY clock sleep registers [5112+]
+ */
+#define AR5K_PHY_SCLOCK			0x99f0
+#define AR5K_PHY_SCLOCK_32MHZ		0x0000000c
+#define AR5K_PHY_SDELAY			0x99f4
+#define AR5K_PHY_SDELAY_32MHZ		0x000000ff
+#define AR5K_PHY_SPENDING		0x99f8
+#define AR5K_PHY_SPENDING_14		0x00000014
+#define AR5K_PHY_SPENDING_18		0x00000018
+#define AR5K_PHY_SPENDING_RF5111	0x00000018
+#define AR5K_PHY_SPENDING_RF5112	0x00000014
+/* #define AR5K_PHY_SPENDING_RF5112A	0x0000000e */
+/* #define AR5K_PHY_SPENDING_RF5424	0x00000012 */
+#define AR5K_PHY_SPENDING_RF5413	0x00000018
+#define AR5K_PHY_SPENDING_RF2413	0x00000018
+#define AR5K_PHY_SPENDING_RF2316	0x00000018
+#define AR5K_PHY_SPENDING_RF2317	0x00000018
+#define AR5K_PHY_SPENDING_RF2425	0x00000014
+
+/*
  * PHY PAPD I (power?) table (?)
  * (92! entries)
  */
@@ -2342,10 +2538,47 @@ after DFS is enabled */
 #define AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR	0x0000000f
 #define AR5K_PHY_CCK_CROSSCORR_WEAK_SIG_THR_S	0
 
+/* Same address is used for antenna diversity activation */
+#define	AR5K_PHY_FAST_ANT_DIV		0xa208
+#define	AR5K_PHY_FAST_ANT_DIV_EN	0x00002000
+
 /*
  * PHY 2GHz gain register [5111+]
  */
-#define	AR5K_PHY_GAIN_2GHZ		0xa20c
-#define	AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX	0x00fc0000
+#define	AR5K_PHY_GAIN_2GHZ			0xa20c
+#define	AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX		0x00fc0000
 #define	AR5K_PHY_GAIN_2GHZ_MARGIN_TXRX_S	18
-#define	AR5K_PHY_GAIN_2GHZ_INI_5111	0x6480416c
+#define	AR5K_PHY_GAIN_2GHZ_INI_5111		0x6480416c
+
+#define	AR5K_PHY_CCK_RX_CTL_4			0xa21c
+#define	AR5K_PHY_CCK_RX_CTL_4_FREQ_EST_SHORT	0x01f80000
+#define	AR5K_PHY_CCK_RX_CTL_4_FREQ_EST_SHORT_S	19
+
+#define	AR5K_PHY_DAG_CCK_CTL			0xa228
+#define	AR5K_PHY_DAG_CCK_CTL_EN_RSSI_THR	0x00000200
+#define	AR5K_PHY_DAG_CCK_CTL_RSSI_THR		0x0001fc00
+#define	AR5K_PHY_DAG_CCK_CTL_RSSI_THR_S		10
+
+#define	AR5K_PHY_FAST_ADC	0xa24c
+
+#define	AR5K_PHY_BLUETOOTH	0xa254
+
+/*
+ * Transmit Power Control register
+ * [2413+]
+ */
+#define	AR5K_PHY_TPC_RG1		0xa258
+#define	AR5K_PHY_TPC_RG1_NUM_PD_GAIN	0x0000c000
+#define	AR5K_PHY_TPC_RG1_NUM_PD_GAIN_S	14
+
+#define	AR5K_PHY_TPC_RG5			0xa26C
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_OVERLAP	0x0000000F
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_OVERLAP_S	0
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_1	0x000003F0
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_1_S	4
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_2	0x0000FC00
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_2_S	10
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_3	0x003F0000
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_3_S	16
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_4	0x0FC00000
+#define	AR5K_PHY_TPC_RG5_PD_GAIN_BOUNDARY_4_S	22
diff --git a/drivers/net/wireless/ath5k/reset.c b/drivers/net/wireless/ath5k/reset.c
index 953ba3b..8f18868 100644
--- a/drivers/net/wireless/ath5k/reset.c
+++ b/drivers/net/wireless/ath5k/reset.c
@@ -543,13 +543,13 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 			ath5k_hw_reg_write(ah, 0x0002a002, 0x982c);
 
 			if (channel->hw_value == CHANNEL_G)
-				if (ah->ah_mac_srev < AR5K_SREV_VER_AR2413)
+				if (ah->ah_mac_srev < AR5K_SREV_AR2413)
 					ath5k_hw_reg_write(ah, 0x00f80d80,
 								0x994c);
-				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2424)
+				else if (ah->ah_mac_srev < AR5K_SREV_AR5424)
 					ath5k_hw_reg_write(ah, 0x00380140,
 								0x994c);
-				else if (ah->ah_mac_srev < AR5K_SREV_VER_AR2425)
+				else if (ah->ah_mac_srev < AR5K_SREV_AR2425)
 					ath5k_hw_reg_write(ah, 0x00fc0ec0,
 								0x994c);
 				else /* 2425 */
@@ -915,7 +915,7 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 		ath5k_hw_reg_write(ah, 0x000100aa, 0x8118);
 		ath5k_hw_reg_write(ah, 0x00003210, 0x811c);
 		ath5k_hw_reg_write(ah, 0x00000052, 0x8108);
-		if (ah->ah_mac_srev >= AR5K_SREV_VER_AR2413)
+		if (ah->ah_mac_srev >= AR5K_SREV_AR2413)
 			ath5k_hw_reg_write(ah, 0x00000004, 0x8120);
 	}
 

