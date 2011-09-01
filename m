Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2951 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab1IAJRn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:43 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 24/30] staging: brcm80211: removed redundant macro's in
 softmac
Date: Thu, 1 Sep 2011 11:17:14 +0200
Message-ID: <1314868640-9425-25-git-send-email-rvossen@broadcom.com> (sfid-20110901_111828_362023_8116DD14)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |   29 +-----------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |   36 ----------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   21 ++++++++++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |   34 --------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   31 +++++++++++-------
 5 files changed, 37 insertions(+), 114 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index f78cc50..e98eb27 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -202,10 +202,6 @@
  /* 12 mA drive strengh for later 4313 */
 #define CCTRL_4313_12MA_LED_DRIVE    0x00000007
 
-#define BCM47162_DMP() ((sih->chip == BCM47162_CHIP_ID) && \
-		(sih->chiprev == 0) && \
-		(sii->coreid[sii->curidx] == MIPS74K_CORE_ID))
-
 /* Manufacturer Ids */
 #define	MFGID_ARM		0x43b
 #define	MFGID_BRCM		0x4bf
@@ -750,11 +746,6 @@ uint ai_flag(struct si_pub *sih)
 	struct aidmp *ai;
 
 	sii = SI_INFO(sih);
-	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Attempting to read MIPS DMP registers "
-			  "on 47162a0", __func__));
-		return sii->curidx;
-	}
 	ai = sii->curwrap;
 
 	return R_REG(&ai->oobselouta30) & 0x1f;
@@ -805,12 +796,6 @@ void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
 
 	sii = SI_INFO(sih);
 
-	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Accessing MIPS DMP register (ioctrl) on 47162a0",
-			  __func__));
-		return;
-	}
-
 	ai = sii->curwrap;
 
 	if (mask || val) {
@@ -826,12 +811,6 @@ u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 	u32 w;
 
 	sii = SI_INFO(sih);
-	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Accessing MIPS DMP register (ioctrl) on 47162a0",
-			  __func__));
-		return 0;
-	}
-
 	ai = sii->curwrap;
 
 	if (mask || val) {
@@ -871,12 +850,6 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 	u32 w;
 
 	sii = SI_INFO(sih);
-	if (BCM47162_DMP()) {
-		SI_ERROR(("%s: Accessing MIPS DMP register (iostatus) "
-			  "on 47162a0", __func__));
-		return 0;
-	}
-
 	ai = sii->curwrap;
 
 	if (mask || val) {
@@ -1073,7 +1046,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sih->chiprev = (w & CID_REV_MASK) >> CID_REV_SHIFT;
 	sih->chippkg = (w & CID_PKG_MASK) >> CID_PKG_SHIFT;
 
-	sih->issim = IS_SIM(sih->chippkg);
+	sih->issim = false;
 
 	/* scan for cores */
 	if (socitype == SOCI_AI) {
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 5dee80f..b1f2c38 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -233,48 +233,15 @@
 #define	SRC_SIZE_SHIFT		1
 #define	SRC_PRESENT		0x00000001
 
-/* 4330 chip-specific ChipStatus register bits */
- /* SDIO || gSPI */
-#define CST4330_CHIPMODE_SDIOD(cs)	(((cs) & 0x7) < 6)
- /* USB || USBDA */
-#define CST4330_CHIPMODE_USB20D(cs)	(((cs) & 0x7) >= 6)
- /* SDIO */
-#define CST4330_CHIPMODE_SDIO(cs)	(((cs) & 0x4) == 0)
- /* gSPI */
-#define CST4330_CHIPMODE_GSPI(cs)	(((cs) & 0x6) == 4)
- /* USB packet-oriented */
-#define CST4330_CHIPMODE_USB(cs)	(((cs) & 0x7) == 6)
- /* USB Direct Access */
-#define CST4330_CHIPMODE_USBDA(cs)	(((cs) & 0x7) == 7)
-#define	CST4330_OTP_PRESENT		0x00000010
-#define	CST4330_LPO_AUTODET_EN		0x00000020
-#define	CST4330_ARMREMAP_0		0x00000040
- /* takes priority over OTP if both set */
-#define	CST4330_SPROM_PRESENT		0x00000080
-#define	CST4330_ILPDIV_EN		0x00000100
-#define	CST4330_LPO_SEL			0x00000200
-#define	CST4330_RES_INIT_MODE_SHIFT	10
-#define	CST4330_RES_INIT_MODE_MASK	0x00000c00
-#define CST4330_CBUCK_MODE_SHIFT	12
-#define CST4330_CBUCK_MODE_MASK		0x00003000
-#define	CST4330_CBUCK_POWER_OK		0x00004000
-#define	CST4330_BB_PLL_LOCKED		0x00008000
-
 /* Package IDs */
-#define BCM4329_289PIN_PKG_ID	0	/* 4329 289-pin package id */
-#define BCM4329_182PIN_PKG_ID	1	/* 4329N 182-pin package id */
 #define	BCM4717_PKG_ID		9	/* 4717 package id */
 #define	BCM4718_PKG_ID		10	/* 4718 package id */
-#define HDLSIM_PKG_ID		14	/* HDL simulator package id */
-#define HWSIM_PKG_ID		15	/* Hardware simulator package id */
 #define BCM43224_FAB_SMIC	0xa	/* the chip is manufactured by SMIC */
 
 /* these are router chips */
 #define	BCM4716_CHIP_ID		0x4716	/* 4716 chipcommon chipid */
 #define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
 #define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
-#define	BCM5356_CHIP_ID		0x5356	/* 5356 chipcommon chipid */
-#define	BCM5357_CHIP_ID		0x5357	/* 5357 chipcommon chipid */
 
 
 #define	SI_INFO(sih)	((struct si_info *)sih)
@@ -424,9 +391,6 @@ struct si_pub {
 /* Define SI_VMSG to printf for verbose debugging, but don't check it in */
 #define	SI_VMSG(args)
 
-#define	IS_SIM(chippkg)	\
-	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
-
 struct pci_dev;
 
 struct gpioh_item {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index eec83ab..b52b305 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -27,6 +27,16 @@
 #include "phy_lcn.h"
 #include "phyreg_n.h"
 
+#define VALID_N_RADIO(radioid) ((radioid == BCM2055_ID) || \
+				 (radioid == BCM2056_ID) || \
+				 (radioid == BCM2057_ID))
+
+#define VALID_LCN_RADIO(radioid)	(radioid == BCM2064_ID)
+
+#define VALID_RADIO(pi, radioid)        ( \
+		(ISNPHY(pi) ? VALID_N_RADIO(radioid) : false) || \
+		(ISLCNPHY(pi) ? VALID_LCN_RADIO(radioid) : false))
+
 struct chan_info_basic {
 	u16 chan;
 	u16 freq;
@@ -545,7 +555,8 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	pi->pubpi.phy_corenum = PHY_CORE_NUM_2;
 	pi->pubpi.ana_rev = (phyversion & PV_AV_MASK) >> PV_AV_SHIFT;
 
-	if (!VALID_PHYTYPE(pi->pubpi.phy_type))
+	if (!pi->pubpi.phy_type == PHY_TYPE_N &&
+	    !pi->pubpi.phy_type == PHY_TYPE_LCN)
 		goto err;
 
 	if (BAND_5G(bandtype)) {
@@ -1340,7 +1351,7 @@ u16 wlc_phy_chanspec_band_firstch(struct brcms_phy_pub *ppi, uint band)
 	for (i = 0; i < ARRAY_SIZE(chan_info_all); i++) {
 		channel = chan_info_all[i].chan;
 
-		if (ISNPHY(pi) && IS40MHZ(pi)) {
+		if (ISNPHY(pi) && pi->bw == WL_CHANSPEC_BW_40) {
 			uint j;
 
 			for (j = 0; j < ARRAY_SIZE(chan_info_all); j++) {
@@ -2881,7 +2892,8 @@ void wlc_phy_stf_chain_init(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 	pi->sh->hw_phyrxchain = rxchain;
 	pi->sh->phytxchain = txchain;
 	pi->sh->phyrxchain = rxchain;
-	pi->pubpi.phy_corenum = (u8) PHY_BITSCNT(pi->sh->phyrxchain);
+	pi->pubpi.phy_corenum = (u8) brcmu_bitcount((u8 *)&pi->sh->phyrxchain,
+						    sizeof(u8));
 }
 
 void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
@@ -2893,7 +2905,8 @@ void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 	if (ISNPHY(pi))
 		wlc_phy_rxcore_setstate_nphy(pih, rxchain);
 
-	pi->pubpi.phy_corenum = (u8) PHY_BITSCNT(pi->sh->phyrxchain);
+	pi->pubpi.phy_corenum = (u8) brcmu_bitcount((u8 *)&pi->sh->phyrxchain,
+						    sizeof(u8));
 }
 
 void wlc_phy_stf_chain_get(struct brcms_phy_pub *pih, u8 *txchain, u8 *rxchain)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index e09752d..b94117b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -40,16 +40,9 @@ struct brcms_phy_srom_fem {
 	u8 antswctrllut;
 };
 
-#undef ISNPHY
-#undef ISLCNPHY
 #define ISNPHY(pi)	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_N)
 #define ISLCNPHY(pi)	PHYTYPE_IS((pi)->pubpi.phy_type, PHY_TYPE_LCN)
 
-#define ISPHY_11N_CAP(pi)	(ISNPHY(pi) || ISLCNPHY(pi))
-
-#define IS20MHZ(pi)	((pi)->bw == WL_CHANSPEC_BW_20)
-#define IS40MHZ(pi)	((pi)->bw == WL_CHANSPEC_BW_40)
-
 #define PHY_GET_RFATTN(rfgain)	((rfgain) & 0x0f)
 #define PHY_GET_PADMIX(rfgain)	(((rfgain) & 0x10) >> 4)
 #define PHY_GET_RFGAINID(rfattn, padmix, width)	((rfattn) + ((padmix)*(width)))
@@ -237,36 +230,9 @@ enum phy_cal_mode {
 #define PHY_CHAIN_TX_DISABLE_TEMP	115
 #define PHY_HYSTERESIS_DELTATEMP	5
 
-#define PHY_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
-
-#define MOD_PHY_REG(pi, phy_type, reg_name, field, value) \
-	mod_phy_reg(pi, phy_type##_##reg_name, \
-		    phy_type##_##reg_name##_##field##_MASK, \
-		    (value) << phy_type##_##reg_name##_##field##_##SHIFT)
-
-#define READ_PHY_REG(pi, phy_type, reg_name, field) \
-	((read_phy_reg(pi, phy_type##_##reg_name) & \
-	  phy_type##_##reg_name##_##field##_##MASK) \
-	 >> phy_type##_##reg_name##_##field##_##SHIFT)
-
-#define	VALID_PHYTYPE(phytype)	(((uint)phytype == PHY_TYPE_N) || \
-				((uint)phytype == PHY_TYPE_LCN))
-
-#define VALID_N_RADIO(radioid) ((radioid == BCM2055_ID) || \
-				 (radioid == BCM2056_ID) || \
-				 (radioid == BCM2057_ID))
-
-#define VALID_LCN_RADIO(radioid)	(radioid == BCM2064_ID)
-
-#define VALID_RADIO(pi, radioid)        ( \
-		(ISNPHY(pi) ? VALID_N_RADIO(radioid) : false) || \
-		(ISLCNPHY(pi) ? VALID_LCN_RADIO(radioid) : false))
-
 #define SCAN_INPROG_PHY(pi) \
 	(mboolisset(pi->measure_hold, PHY_HOLD_FOR_SCAN))
 
-#define RM_INPROG_PHY(pi)       (mboolisset(pi->measure_hold, PHY_HOLD_FOR_RM))
-
 #define PLT_INPROG_PHY(pi)      (mboolisset(pi->measure_hold, PHY_HOLD_FOR_PLT))
 
 #define ASSOC_INPROG_PHY(pi) \
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index f4c89ae..7a50a23 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14756,7 +14756,7 @@ static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
 	}
 
-	if (IS40MHZ(pi)) {
+	if (pi->bw == WL_CHANSPEC_BW_40) {
 		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, 0x186 + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
@@ -14779,7 +14779,7 @@ static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
 	int j;
 
-	if (IS40MHZ(pi)) {
+	if (pi->bw == WL_CHANSPEC_BW_40) {
 		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, 0x195 + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[4][j]);
@@ -20851,7 +20851,8 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 						 mixg_boost_tune);
 			} else {
 
-				bias = IS40MHZ(pi) ? 0x40 : 0x20;
+				bias = (pi->bw == WL_CHANSPEC_BW_40) ?
+				       0x40 : 0x20;
 
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 INTPAG_IMAIN_STAT, bias);
@@ -24872,11 +24873,13 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			if ((pi->pubpi.radiorev <= 4)
 			    || (pi->pubpi.radiorev == 6))
-				m[core] = IS40MHZ(pi) ? 60 : 79;
+				m[core] = (pi->bw == WL_CHANSPEC_BW_40) ?
+					  60 : 79;
 			else
-				m[core] = IS40MHZ(pi) ? 45 : 64;
+				m[core] = (pi->bw == WL_CHANSPEC_BW_40) ?
+					  45 : 64;
 		} else {
-			m[core] = IS40MHZ(pi) ? 75 : 107;
+			m[core] = (pi->bw == WL_CHANSPEC_BW_40) ? 75 : 107;
 		}
 
 		m[phy_a7] = 0;
@@ -25015,9 +25018,9 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 		}
 
 		if (CHSPEC_IS2G(pi->radio_chanspec))
-			m[core] = IS40MHZ(pi) ? 45 : 64;
+			m[core] = (pi->bw == WL_CHANSPEC_BW_40) ? 45 : 64;
 		else
-			m[core] = IS40MHZ(pi) ? 75 : 107;
+			m[core] = (pi->bw == WL_CHANSPEC_BW_40) ? 75 : 107;
 
 		m[phy_a7] = 0;
 		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
@@ -27583,8 +27586,10 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 			txlpf_rccal_lpc = ((int)best_rccal[rx_core] - 12) + 10;
 
 			if (PHY_IPA(pi)) {
-				txlpf_rccal_lpc += IS40MHZ(pi) ? 24 : 12;
-				txlpf_idac = IS40MHZ(pi) ? 0x0e : 0x13;
+				txlpf_rccal_lpc +=
+					(pi->bw == WL_CHANSPEC_BW_40) ? 24 : 12;
+				txlpf_idac = (pi->bw == WL_CHANSPEC_BW_40) ?
+					     0x0e : 0x13;
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, rx_core,
 						 TXLPF_IDAC_4, txlpf_idac);
 			}
@@ -28391,7 +28396,8 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 		else if (NREV_LT(pi->pubpi.phy_rev, 2))
 			mod_phy_reg(pi, 0xdc, 0x00ff, 0x5a);
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2) && IS40MHZ(pi))
+		if (NREV_LT(pi->pubpi.phy_rev, 2) &&
+		    pi->bw == WL_CHANSPEC_BW_40)
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_IQSWAP_WAR,
 				       MHF1_IQSWAP_WAR, BRCM_BAND_ALL);
 
@@ -28449,7 +28455,8 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 		else if (NREV_LT(pi->pubpi.phy_rev, 2))
 			mod_phy_reg(pi, 0xdc, 0x00ff, 0x40);
 
-		if (NREV_LT(pi->pubpi.phy_rev, 2) && IS40MHZ(pi))
+		if (NREV_LT(pi->pubpi.phy_rev, 2) &&
+		    pi->bw == WL_CHANSPEC_BW_40)
 			wlapi_bmac_mhf(pi->sh->physhim, MHF1, MHF1_IQSWAP_WAR,
 				       0x0, BRCM_BAND_ALL);
 
-- 
1.7.4.1


