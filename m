Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44948 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab2D2Avf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:35 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 06/19] brcmsmac: remove PCIe functions needed for PCIe core rev <= 10
Date: Sun, 29 Apr 2012 02:50:30 +0200
Message-Id: <1335660643-26368-7-git-send-email-hauke@hauke-m.de> (sfid-20120429_025202_310632_DCBE56D7)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The devices I know of are not using a PCIe core with rev <= 10. The
BCM4718 uses a PCIe core with revision 14 and the BCM43224 uses a PCIe
core with revision 15. This patch removes support for old PCIe core
versions, which are not found on devices supported by brcmsmac.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   10 -
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    9 -
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |  244 +--------------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |    1 -
 5 files changed, 9 insertions(+), 256 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index bcefe67..daa7f25 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -828,16 +828,6 @@ void ai_pci_up(struct si_pub *sih)
 
 }
 
-/* Unconfigure and/or apply various WARs when system is going to sleep mode */
-void ai_pci_sleep(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-
-	pcicore_sleep(sii->pch);
-}
-
 /* Unconfigure and/or apply various WARs when going down */
 void ai_pci_down(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index db78197..4ea166c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -204,7 +204,6 @@ extern bool ai_deviceremoved(struct si_pub *sih);
 extern u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val,
 			     u8 priority);
 
-extern void ai_pci_sleep(struct si_pub *sih);
 extern void ai_pci_down(struct si_pub *sih);
 extern void ai_pci_up(struct si_pub *sih);
 extern int ai_pci_fixcfg(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 13c7bb1..d61e4a0 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4933,15 +4933,6 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 
 	callbacks = 0;
 
-	if (wlc_hw->sih) {
-		/*
-		 * detach interrupt sync mechanism since interrupt is disabled
-		 * and per-port interrupt object may has been freed. this must
-		 * be done before sb core switch
-		 */
-		ai_pci_sleep(wlc_hw->sih);
-	}
-
 	brcms_b_detach_dmapio(wlc_hw);
 
 	band = wlc_hw->band;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 4678bf2..e57a5b1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -211,23 +211,12 @@ struct pcicore_info {
 	struct bcma_device *core;
 	struct si_pub *sih;	/* System interconnect handle */
 	struct pci_dev *dev;
-	u8 pciecap_lcreg_offset;/* PCIE capability LCreg offset
-				 * in the config space
-				 */
-	bool pcie_pr42767;
 	u8 pcie_polarity;
-	u8 pcie_war_aspm_ovr;	/* Override ASPM/Clkreq settings */
 
 	u8 pmecap_offset;	/* PM Capability offset in the config space */
 	bool pmecap;		/* Capable of generating PME */
 };
 
-#define PCIE_ASPM(sih)							\
-	((ai_get_buscoretype(sih) == PCIE_CORE_ID) &&			\
-	 ((ai_get_buscorerev(sih) >= 3) &&				\
-	  (ai_get_buscorerev(sih) <= 5)))
-
-
 /* delay needed between the mdio control/ mdiodata register data access */
 static void pr28829_delay(void)
 {
@@ -240,7 +229,6 @@ static void pr28829_delay(void)
 struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
 {
 	struct pcicore_info *pi;
-	u8 cap_ptr;
 
 	/* alloc struct pcicore_info */
 	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
@@ -251,9 +239,6 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
 	pi->dev = core->bus->host_pci;
 	pi->core = core;
 
-	cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
-						      NULL, NULL);
-	pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
 	return pi;
 }
 
@@ -406,19 +391,14 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol),
 		     MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
 
-	if (ai_get_buscorerev(pi->sih) >= 10) {
-		/* new serdes is slower in rw,
-		 * using two layers of reg address mapping
-		 */
-		if (!pcie_mdiosetblock(pi, physmedia))
-			return 1;
-		mdiodata = ((MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
-			    (regaddr << MDIODATA_REGADDR_SHF));
-		pcie_serdes_spinwait *= 20;
-	} else {
-		mdiodata = ((physmedia << MDIODATA_DEVADDR_SHF_OLD) |
-			    (regaddr << MDIODATA_REGADDR_SHF_OLD));
-	}
+	/* new serdes is slower in rw,
+	 * using two layers of reg address mapping
+	 */
+	if (!pcie_mdiosetblock(pi, physmedia))
+		return 1;
+	mdiodata = ((MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
+		    (regaddr << MDIODATA_REGADDR_SHF));
+	pcie_serdes_spinwait *= 20;
 
 	if (!write)
 		mdiodata |= (MDIODATA_START | MDIODATA_READ | MDIODATA_TA);
@@ -469,39 +449,9 @@ pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint regaddr, uint val)
 }
 
 /* ***** Support functions ***** */
-static u8 pcie_clkreq(struct pcicore_info *pi, u32 mask, u32 val)
-{
-	u32 reg_val;
-	u8 offset;
-
-	offset = pi->pciecap_lcreg_offset;
-	if (!offset)
-		return 0;
-
-	pci_read_config_dword(pi->dev, offset, &reg_val);
-	/* set operation */
-	if (mask) {
-		if (val)
-			reg_val |= PCIE_CLKREQ_ENAB;
-		else
-			reg_val &= ~PCIE_CLKREQ_ENAB;
-		pci_write_config_dword(pi->dev, offset, reg_val);
-		pci_read_config_dword(pi->dev, offset, &reg_val);
-	}
-	if (reg_val & PCIE_CLKREQ_ENAB)
-		return 1;
-	else
-		return 0;
-}
-
 static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 {
 	u32 w;
-	struct si_pub *sih = pi->sih;
-
-	if (ai_get_buscoretype(sih) != PCIE_CORE_ID ||
-	    ai_get_buscorerev(sih) < 7)
-		return;
 
 	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
 	if (extend)
@@ -512,45 +462,6 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
 }
 
-/* centralized clkreq control policy */
-static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
-{
-	struct si_pub *sih = pi->sih;
-
-	switch (state) {
-	case SI_DOATTACH:
-		if (PCIE_ASPM(sih))
-			pcie_clkreq(pi, 1, 0);
-		break;
-	case SI_PCIDOWN:
-		/* turn on serdes PLL down */
-		if (ai_get_buscorerev(sih) == 6) {
-			ai_cc_reg(sih,
-				  offsetof(struct chipcregs, chipcontrol_addr),
-				  ~0, 0);
-			ai_cc_reg(sih,
-				  offsetof(struct chipcregs, chipcontrol_data),
-				  ~0x40, 0);
-		} else if (pi->pcie_pr42767) {
-			pcie_clkreq(pi, 1, 1);
-		}
-		break;
-	case SI_PCIUP:
-		/* turn off serdes PLL down */
-		if (ai_get_buscorerev(sih) == 6) {
-			ai_cc_reg(sih,
-				  offsetof(struct chipcregs, chipcontrol_addr),
-				  ~0, 0);
-			ai_cc_reg(sih,
-				  offsetof(struct chipcregs, chipcontrol_data),
-				  ~0x40, 0x40);
-		} else if (PCIE_ASPM(sih)) {	/* disable clkreq */
-			pcie_clkreq(pi, 1, 0);
-		}
-		break;
-	}
-}
-
 /* ***** PCI core WARs ***** */
 /* Done only once at attach time */
 static void pcie_war_polarity(struct pcicore_info *pi)
@@ -572,51 +483,6 @@ static void pcie_war_polarity(struct pcicore_info *pi)
 				     SERDES_RX_CTRL_POLARITY);
 }
 
-/* enable ASPM and CLKREQ if srom doesn't have it */
-/* Needs to happen when update to shadow SROM is needed
- *   : Coming out of 'standby'/'hibernate'
- *   : If pcie_war_aspm_ovr state changed
- */
-static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
-{
-	struct si_pub *sih = pi->sih;
-	u16 val16;
-	u32 w;
-
-	if (!PCIE_ASPM(sih))
-		return;
-
-	/* bypass this on QT or VSIM */
-	val16 = bcma_read16(pi->core, PCIEREGOFFS(sprom[SRSH_ASPM_OFFSET]));
-
-	val16 &= ~SRSH_ASPM_ENB;
-	if (pi->pcie_war_aspm_ovr == PCIE_ASPM_ENAB)
-		val16 |= SRSH_ASPM_ENB;
-	else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L1_ENAB)
-		val16 |= SRSH_ASPM_L1_ENB;
-	else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L0s_ENAB)
-		val16 |= SRSH_ASPM_L0s_ENB;
-
-	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_ASPM_OFFSET]), val16);
-
-	pci_read_config_dword(pi->dev, pi->pciecap_lcreg_offset, &w);
-	w &= ~PCIE_ASPM_ENAB;
-	w |= pi->pcie_war_aspm_ovr;
-	pci_write_config_dword(pi->dev, pi->pciecap_lcreg_offset, w);
-
-	val16 = bcma_read16(pi->core,
-			    PCIEREGOFFS(sprom[SRSH_CLKREQ_OFFSET_REV5]));
-
-	if (pi->pcie_war_aspm_ovr != PCIE_ASPM_DISAB) {
-		val16 |= SRSH_CLKREQ_ENB;
-		pi->pcie_pr42767 = true;
-	} else
-		val16 &= ~SRSH_CLKREQ_ENB;
-
-	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_CLKREQ_OFFSET_REV5]),
-		     val16);
-}
-
 /* Apply the polarity determined at the start */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_serdes(struct pcicore_info *pi)
@@ -650,90 +516,19 @@ static void pcie_misc_config_fixup(struct pcicore_info *pi)
 	}
 }
 
-/* quick hack for testing */
-/* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_noplldown(struct pcicore_info *pi)
-{
-	/* turn off serdes PLL down */
-	ai_cc_reg(pi->sih, offsetof(struct chipcregs, chipcontrol),
-		  CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
-
-	/* clear srom shadow backdoor */
-	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_BD_OFFSET]), 0);
-}
-
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_pci_setup(struct pcicore_info *pi)
 {
-	struct si_pub *sih = pi->sih;
-	u32 w;
-
-	if (ai_get_buscorerev(sih) == 0 || ai_get_buscorerev(sih) == 1) {
-		w = pcie_readreg(pi->core, PCIE_PCIEREGS,
-				 PCIE_TLP_WORKAROUNDSREG);
-		w |= 0x8;
-		pcie_writereg(pi->core, PCIE_PCIEREGS,
-			      PCIE_TLP_WORKAROUNDSREG, w);
-	}
-
-	if (ai_get_buscorerev(sih) == 1) {
-		w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_LCREG);
-		w |= 0x40;
-		pcie_writereg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_LCREG, w);
-	}
-
-	if (ai_get_buscorerev(sih) == 0) {
-		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_TIMER1, 0x8128);
-		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CDR, 0x0100);
-		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CDRBW, 0x1466);
-	} else if (PCIE_ASPM(sih)) {
-		/* Change the L1 threshold for better performance */
-		w = pcie_readreg(pi->core, PCIE_PCIEREGS,
-				 PCIE_DLLP_PMTHRESHREG);
-		w &= ~PCIE_L1THRESHOLDTIME_MASK;
-		w |= PCIE_L1THRESHOLD_WARVAL << PCIE_L1THRESHOLDTIME_SHIFT;
-		pcie_writereg(pi->core, PCIE_PCIEREGS,
-			      PCIE_DLLP_PMTHRESHREG, w);
-
-		pcie_war_serdes(pi);
-
-		pcie_war_aspm_clkreq(pi);
-	} else if (ai_get_buscorerev(pi->sih) == 7)
-		pcie_war_noplldown(pi);
-
-	/* Note that the fix is actually in the SROM,
-	 * that's why this is open-ended
-	 */
-	if (ai_get_buscorerev(pi->sih) >= 6)
-		pcie_misc_config_fixup(pi);
+	pcie_misc_config_fixup(pi);
 }
 
 /* ***** Functions called during driver state changes ***** */
 void pcicore_attach(struct pcicore_info *pi, int state)
 {
-	struct si_pub *sih = pi->sih;
-	struct ssb_sprom *sprom = &pi->core->bus->sprom;
-	u32 bfl2;
-	
-	bfl2 = sprom->boardflags2_lo + (sprom->boardflags2_hi << 16);
-
-	/* Determine if this board needs override */
-	if (PCIE_ASPM(sih)) {
-		if (bfl2 & BFL2_PCIEWAR_OVR)
-			pi->pcie_war_aspm_ovr = PCIE_ASPM_DISAB;
-		else
-			pi->pcie_war_aspm_ovr = PCIE_ASPM_ENAB;
-	}
-
 	/* These need to happen in this order only */
 	pcie_war_polarity(pi);
 
 	pcie_war_serdes(pi);
-
-	pcie_war_aspm_clkreq(pi);
-
-	pcie_clkreq_upd(pi, state);
-
 }
 
 void pcicore_hwup(struct pcicore_info *pi)
@@ -751,25 +546,6 @@ void pcicore_up(struct pcicore_info *pi, int state)
 
 	/* Restore L1 timer for better performance */
 	pcie_extendL1timer(pi, true);
-
-	pcie_clkreq_upd(pi, state);
-}
-
-/* When the device is going to enter D3 state
- * (or the system is going to enter S3/S4 states)
- */
-void pcicore_sleep(struct pcicore_info *pi)
-{
-	u32 w;
-
-	if (!pi || !PCIE_ASPM(pi->sih))
-		return;
-
-	pci_read_config_dword(pi->dev, pi->pciecap_lcreg_offset, &w);
-	w &= ~PCIE_CAP_LCREG_ASPML1;
-	pci_write_config_dword(pi->dev, pi->pciecap_lcreg_offset, w);
-
-	pi->pcie_pr42767 = false;
 }
 
 void pcicore_down(struct pcicore_info *pi, int state)
@@ -777,8 +553,6 @@ void pcicore_down(struct pcicore_info *pi, int state)
 	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
 		return;
 
-	pcie_clkreq_upd(pi, state);
-
 	/* Reduce L1 timer for better power savings */
 	pcie_extendL1timer(pi, false);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index e24babe..21271b4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -67,7 +67,6 @@ extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_attach(struct pcicore_info *pch, int state);
 extern void pcicore_hwup(struct pcicore_info *pch);
 extern void pcicore_up(struct pcicore_info *pch, int state);
-extern void pcicore_sleep(struct pcicore_info *pch);
 extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
 				      unsigned char *buf, u32 *buflen);
-- 
1.7.9.5

