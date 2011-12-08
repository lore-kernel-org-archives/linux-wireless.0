Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2185 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 15/23] brcm80211: smac: use bcma core register access
 functions for 802.11 core
Date: Thu, 8 Dec 2011 15:06:51 -0800
Message-ID: <1323385619-7454-16-git-send-email-frankyl@broadcom.com> (sfid-20111209_000819_312727_34ABF424)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The driver now uses the bcma register access functions to read and
write the registers on the 802.11 core. The dma and phy code need
to be modified next and access to the other cores. That will be done
in coming patches.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   48 ++-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c   |    7 +-
 drivers/net/wireless/brcm80211/brcmsmac/d11.h     |    3 +
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |  479 ++++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/main.h    |    4 +-
 5 files changed, 274 insertions(+), 267 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 989dd3e..ef1441a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -504,6 +504,17 @@ static void ai_scan(struct si_pub *sih, struct bcma_bus *bus)
 	}
 }
 
+static struct bcma_device *ai_find_bcma_core(struct si_pub *sih, uint coreidx)
+{
+	struct si_info *sii = (struct si_info *)sih;
+	struct bcma_device *core;
+
+	list_for_each_entry(core, &sii->icbus->cores, list) {
+		if (core->core_index == coreidx)
+			return core;
+	}
+	return NULL;
+}
 /*
  * This function changes the logical "focus" to the indicated core.
  * Return the current core's virtual address. Since each core starts with the
@@ -514,18 +525,16 @@ static void ai_scan(struct si_pub *sih, struct bcma_bus *bus)
 void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
 	struct si_info *sii = (struct si_info *)sih;
-	u32 addr = sii->coresba[coreidx];
-	u32 wrap = sii->wrapba[coreidx];
-
-	if (coreidx >= sii->numcores)
-		return NULL;
+	struct bcma_device *core;
 
-	/* point bar0 window */
-	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN, addr);
-	/* point bar0 2nd 4KB window */
-	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN2, wrap);
-	sii->curidx = coreidx;
+	if (sii->curidx != coreidx) {
+		core = ai_find_bcma_core(sih, coreidx);
+		if (core == NULL)
+			return NULL;
 
+		(void)bcma_aread32(core, BCMA_IOST);
+		sii->curidx = coreidx;
+	}
 	return sii->curmap;
 }
 
@@ -811,8 +820,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	uint socitype;
 	uint origidx;
 
-	/* assume the window is looking at chipcommon */
-	WARN_ON(pbus->mapped_core->id.id != BCMA_CORE_CHIPCOMMON);
 	memset((unsigned char *) sii, 0, sizeof(struct si_info));
 
 	savewin = 0;
@@ -823,13 +830,10 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sii->curmap = regs;
 	sii->curwrap = sii->curmap + SI_CORE_SIZE;
 
-	/* find Chipcommon address */
-	pci_read_config_dword(sii->pcibus, PCI_BAR0_WIN, &savewin);
-	if (!GOODCOREADDR(savewin, SI_ENUM_BASE))
-		savewin = SI_ENUM_BASE;
+	/* switch to Chipcommon core */
+	bcma_read32(pbus->drv_cc.core, 0);
+	savewin = SI_ENUM_BASE;
 
-	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN,
-			       SI_ENUM_BASE);
 	cc = (struct chipcregs __iomem *) regs;
 
 	/* bus/core/clk setup for register access */
@@ -1036,18 +1040,18 @@ bool ai_backplane64(struct si_pub *sih)
 /* return index of coreid or BADIDX if not found */
 uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 {
+	struct bcma_device *core;
 	struct si_info *sii;
 	uint found;
-	uint i;
 
 	sii = (struct si_info *)sih;
 
 	found = 0;
 
-	for (i = 0; i < sii->numcores; i++)
-		if (sii->coreid[i] == coreid) {
+	list_for_each_entry(core, &sii->icbus->cores, list)
+		if (core->id.id == coreid) {
 			if (found == coreunit)
-				return i;
+				return core->core_index;
 			found++;
 		}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
index 43f7a72..90911ee 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
@@ -1118,14 +1118,17 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		u8 status_delay = 0;
 
 		/* wait till the next 8 bytes of txstatus is available */
-		while (((s1 = R_REG(&wlc->regs->frmtxstatus)) & TXS_V) == 0) {
+		s1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(frmtxstatus));
+		while ((s1 & TXS_V) == 0) {
 			udelay(1);
 			status_delay++;
 			if (status_delay > 10)
 				return; /* error condition */
+			s1 = bcma_read32(wlc->hw->d11core,
+					 D11REGOFFS(frmtxstatus));
 		}
 
-		s2 = R_REG(&wlc->regs->frmtxstatus2);
+		s2 = bcma_read32(wlc->hw->d11core, D11REGOFFS(frmtxstatus2));
 	}
 
 	if (scb) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/d11.h b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
index ed51616..1948cb2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/d11.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
@@ -430,6 +430,9 @@ struct d11regs {
 	u16 PAD[0x380];	/* 0x800 - 0xEFE */
 };
 
+/* d11 register field offset */
+#define D11REGOFFS(field)	offsetof(struct d11regs, field)
+
 #define	PIHR_BASE	0x0400	/* byte address of packed IHR region */
 
 /* biststatus */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 73bc0ab..f4a6465 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -388,10 +388,13 @@ static u16 get_sifs(struct brcms_band *band)
  */
 static bool brcms_deviceremoved(struct brcms_c_info *wlc)
 {
+	u32 macctrl;
+
 	if (!wlc->hw->clk)
 		return ai_deviceremoved(wlc->hw->sih);
-	return (R_REG(&wlc->hw->regs->maccontrol) &
-		(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN;
+	macctrl = bcma_read32(wlc->hw->d11core,
+			      D11REGOFFS(maccontrol));
+	return (macctrl & (MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN;
 }
 
 /* sum the individual fifo tx pending packet counts */
@@ -582,17 +585,15 @@ brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot)
 {
-	struct d11regs __iomem *regs;
-
-	regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 
 	if (shortslot) {
 		/* 11g short slot: 11a timing */
-		W_REG(&regs->ifs_slot, 0x0207);	/* APHY_SLOT_TIME */
+		bcma_write16(core, D11REGOFFS(ifs_slot), 0x0207);
 		brcms_b_write_shm(wlc_hw, M_DOT11_SLOT, APHY_SLOT_TIME);
 	} else {
 		/* 11g long slot: 11b timing */
-		W_REG(&regs->ifs_slot, 0x0212);	/* BPHY_SLOT_TIME */
+		bcma_write16(core, D11REGOFFS(ifs_slot), 0x0212);
 		brcms_b_write_shm(wlc_hw, M_DOT11_SLOT, BPHY_SLOT_TIME);
 	}
 }
@@ -672,24 +673,22 @@ static uint brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 				const struct d11init *inits)
 {
+	struct bcma_device *core = wlc_hw->d11core;
 	int i;
-	u8 __iomem *base;
-	u8 __iomem *addr;
+	uint offset;
 	u16 size;
 	u32 value;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	base = (u8 __iomem *)wlc_hw->regs;
-
 	for (i = 0; inits[i].addr != cpu_to_le16(0xffff); i++) {
 		size = le16_to_cpu(inits[i].size);
-		addr = base + le16_to_cpu(inits[i].addr);
+		offset = le16_to_cpu(inits[i].addr);
 		value = le32_to_cpu(inits[i].value);
 		if (size == 2)
-			W_REG((u16 __iomem *)addr, value);
+			bcma_write16(core, offset, value);
 		else if (size == 4)
-			W_REG((u32 __iomem *)addr, value);
+			bcma_write32(core, offset, value);
 		else
 			break;
 	}
@@ -788,10 +787,12 @@ static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	u32 macintmask;
+	u32 macctrl;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
-
-	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
+	macctrl = bcma_read32(wlc_hw->d11core,
+			      D11REGOFFS(maccontrol));
+	WARN_ON((macctrl & MCTL_EN_MAC) != 0);
 
 	/* disable interrupts */
 	macintmask = brcms_intrsoff(wlc->wl);
@@ -982,7 +983,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
-	struct d11regs __iomem *regs;
+	struct bcma_device *core;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
 	uint n = 0;
@@ -995,18 +996,18 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	txs = &txstatus;
-	regs = wlc_hw->regs;
+	core = wlc_hw->d11core;
 	*fatal = false;
+	s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
 	while (!(*fatal)
-	       && (s1 = R_REG(&regs->frmtxstatus)) & TXS_V) {
+	       && (s1 & TXS_V)) {
 
 		if (s1 == 0xffffffff) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
 				wlc_hw->unit, __func__);
 			return morepending;
 		}
-
-		s2 = R_REG(&regs->frmtxstatus2);
+		s2 = bcma_read32(core, D11REGOFFS(frmtxstatus2));
 
 		txs->status = s1 & TXS_STATUS_MASK;
 		txs->frameid = (s1 & TXS_FID_MASK) >> TXS_FID_SHIFT;
@@ -1019,6 +1020,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 		/* !give others some time to run! */
 		if (++n >= max_tx_num)
 			break;
+		s1 = bcma_read32(core, D11REGOFFS(frmtxstatus));
 	}
 
 	if (*fatal)
@@ -1066,9 +1068,11 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 static struct dma64regs __iomem *
 dmareg(struct brcms_hardware *hw, uint direction, uint fifonum)
 {
+	struct d11regs __iomem *regs = hw->d11core->bus->mmio;
+
 	if (direction == DMA_TX)
-		return &(hw->regs->fifo64regs[fifonum].dmaxmt);
-	return &(hw->regs->fifo64regs[fifonum].dmarcv);
+		return &(regs->fifo64regs[fifonum].dmaxmt);
+	return &(regs->fifo64regs[fifonum].dmarcv);
 }
 
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
@@ -1214,29 +1218,33 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 
 		if (wlc_hw->clk) {
 			if (mode == CLK_FAST) {
-				OR_REG(&wlc_hw->regs->clk_ctl_st,
-				       CCS_FORCEHT);
+				bcma_set32(wlc_hw->d11core,
+					   D11REGOFFS(clk_ctl_st),
+					   CCS_FORCEHT);
 
 				udelay(64);
 
-				SPINWAIT(((R_REG
-					   (&wlc_hw->regs->
-					    clk_ctl_st) & CCS_HTAVAIL) == 0),
-					 PMU_MAX_TRANSITION_DLY);
-				WARN_ON(!(R_REG
-					  (&wlc_hw->regs->
-					   clk_ctl_st) & CCS_HTAVAIL));
+				SPINWAIT(
+				    ((bcma_read32(wlc_hw->d11core,
+				      D11REGOFFS(clk_ctl_st)) &
+				      CCS_HTAVAIL) == 0),
+				      PMU_MAX_TRANSITION_DLY);
+				WARN_ON(!(bcma_read32(wlc_hw->d11core,
+					D11REGOFFS(clk_ctl_st)) &
+					CCS_HTAVAIL));
 			} else {
 				if ((ai_get_pmurev(wlc_hw->sih) == 0) &&
-				    (R_REG
-				     (&wlc_hw->regs->
-				      clk_ctl_st) & (CCS_FORCEHT | CCS_HTAREQ)))
-					SPINWAIT(((R_REG
-						   (&wlc_hw->regs->
-						    clk_ctl_st) & CCS_HTAVAIL)
-						  == 0),
-						 PMU_MAX_TRANSITION_DLY);
-				AND_REG(&wlc_hw->regs->clk_ctl_st,
+				    (bcma_read32(wlc_hw->d11core,
+					D11REGOFFS(clk_ctl_st)) &
+					(CCS_FORCEHT | CCS_HTAREQ)))
+					SPINWAIT(
+					    ((bcma_read32(wlc_hw->d11core,
+					      offsetof(struct d11regs,
+						       clk_ctl_st)) &
+					      CCS_HTAVAIL) == 0),
+					      PMU_MAX_TRANSITION_DLY);
+				bcma_mask32(wlc_hw->d11core,
+					D11REGOFFS(clk_ctl_st),
 					~CCS_FORCEHT);
 			}
 		}
@@ -1368,7 +1376,8 @@ static void brcms_c_mctrl_write(struct brcms_hardware *wlc_hw)
 		maccontrol |= MCTL_INFRA;
 	}
 
-	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(maccontrol),
+		     maccontrol);
 }
 
 /* set or clear maccontrol bits */
@@ -1462,7 +1471,7 @@ static void
 brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u16 mac_l;
 	u16 mac_m;
 	u16 mac_h;
@@ -1470,38 +1479,36 @@ brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: brcms_b_set_addrmatch\n",
 		 wlc_hw->unit);
 
-	regs = wlc_hw->regs;
 	mac_l = addr[0] | (addr[1] << 8);
 	mac_m = addr[2] | (addr[3] << 8);
 	mac_h = addr[4] | (addr[5] << 8);
 
 	/* enter the MAC addr into the RXE match registers */
-	W_REG(&regs->rcm_ctl, RCM_INC_DATA | match_reg_offset);
-	W_REG(&regs->rcm_mat_data, mac_l);
-	W_REG(&regs->rcm_mat_data, mac_m);
-	W_REG(&regs->rcm_mat_data, mac_h);
-
+	bcma_write16(core, D11REGOFFS(rcm_ctl),
+		     RCM_INC_DATA | match_reg_offset);
+	bcma_write16(core, D11REGOFFS(rcm_mat_data), mac_l);
+	bcma_write16(core, D11REGOFFS(rcm_mat_data), mac_m);
+	bcma_write16(core, D11REGOFFS(rcm_mat_data), mac_h);
 }
 
 void
 brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 			    void *buf)
 {
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 word;
 	__le32 word_le;
 	__be32 word_be;
 	bool be_bit;
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	regs = wlc_hw->regs;
-	W_REG(&regs->tplatewrptr, offset);
+	bcma_write32(core, D11REGOFFS(tplatewrptr), offset);
 
 	/* if MCTL_BIGEND bit set in mac control register,
 	 * the chip swaps data in fifo, as well as data in
 	 * template ram
 	 */
-	be_bit = (R_REG(&regs->maccontrol) & MCTL_BIGEND) != 0;
+	be_bit = (bcma_read32(core, D11REGOFFS(maccontrol)) & MCTL_BIGEND) != 0;
 
 	while (len > 0) {
 		memcpy(&word, buf, sizeof(u32));
@@ -1514,7 +1521,7 @@ brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 			word = *(u32 *)&word_le;
 		}
 
-		W_REG(&regs->tplatewrdata, word);
+		bcma_write32(core, D11REGOFFS(tplatewrdata), word);
 
 		buf = (u8 *) buf + sizeof(u32);
 		len -= sizeof(u32);
@@ -1525,18 +1532,20 @@ static void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
 {
 	wlc_hw->band->CWmin = newmin;
 
-	W_REG(&wlc_hw->regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_CWMIN);
-	(void)R_REG(&wlc_hw->regs->objaddr);
-	W_REG(&wlc_hw->regs->objdata, newmin);
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(objaddr),
+		     OBJADDR_SCR_SEL | S_DOT11_CWMIN);
+	(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(objaddr));
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(objdata), newmin);
 }
 
 static void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax)
 {
 	wlc_hw->band->CWmax = newmax;
 
-	W_REG(&wlc_hw->regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_CWMAX);
-	(void)R_REG(&wlc_hw->regs->objaddr);
-	W_REG(&wlc_hw->regs->objdata, newmax);
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(objaddr),
+		     OBJADDR_SCR_SEL | S_DOT11_CWMAX);
+	(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(objaddr));
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(objdata), newmax);
 }
 
 void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
@@ -1815,7 +1824,8 @@ static void brcms_b_setband(struct brcms_hardware *wlc_hw, uint bandunit,
 	brcms_intrsrestore(wlc->wl, macintmask);
 
 	/* ucode should still be suspended.. */
-	WARN_ON((R_REG(&wlc_hw->regs->maccontrol) & MCTL_EN_MAC) != 0);
+	WARN_ON((bcma_read32(wlc_hw->d11core, D11REGOFFS(maccontrol)) &
+		 MCTL_EN_MAC) != 0);
 }
 
 static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw)
@@ -1937,13 +1947,14 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		 */
 		if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
 		    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
-			wlc_hw->regs = (struct d11regs __iomem *)
-					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+			(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
 		brcms_c_mctrl_reset(wlc_hw);
 	}
 
-	v = ((R_REG(&wlc_hw->regs->phydebug) & PDBG_RFD) != 0);
+	v = ((bcma_read32(wlc_hw->d11core,
+			  D11REGOFFS(phydebug)) & PDBG_RFD) != 0);
 
 	/* put core back into reset */
 	if (!clk)
@@ -1971,7 +1982,6 @@ static bool wlc_dma_rxreset(struct brcms_hardware *wlc_hw, uint fifo)
  */
 void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 {
-	struct d11regs __iomem *regs;
 	uint i;
 	bool fastclk;
 	u32 resetbits = 0;
@@ -1981,8 +1991,6 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	regs = wlc_hw->regs;
-
 	/* request FAST clock if not on  */
 	fastclk = wlc_hw->forcefastclk;
 	if (!fastclk)
@@ -2055,7 +2063,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
  */
 static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u16 fifo_nu;
 	u16 txfifo_startblk = TXFIFO_START_BLK, txfifo_endblk;
 	u16 txfifo_def, txfifo_def1;
@@ -2076,11 +2084,11 @@ static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 		txfifo_cmd =
 		    TXFIFOCMD_RESET_MASK | (fifo_nu << TXFIFOCMD_FIFOSEL_SHIFT);
 
-		W_REG(&regs->xmtfifocmd, txfifo_cmd);
-		W_REG(&regs->xmtfifodef, txfifo_def);
-		W_REG(&regs->xmtfifodef1, txfifo_def1);
+		bcma_write16(core, D11REGOFFS(xmtfifocmd), txfifo_cmd);
+		bcma_write16(core, D11REGOFFS(xmtfifodef), txfifo_def);
+		bcma_write16(core, D11REGOFFS(xmtfifodef1), txfifo_def1);
 
-		W_REG(&regs->xmtfifocmd, txfifo_cmd);
+		bcma_write16(core, D11REGOFFS(xmtfifocmd), txfifo_cmd);
 
 		txfifo_startblk += wlc_hw->xmtfifo_sz[fifo_nu];
 	}
@@ -2115,27 +2123,27 @@ static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 
 void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 
 	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
 	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID)) {
 		if (spurmode == WL_SPURAVOID_ON2) {	/* 126Mhz */
-			W_REG(&regs->tsf_clk_frac_l, 0x2082);
-			W_REG(&regs->tsf_clk_frac_h, 0x8);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0x2082);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0x8);
 		} else if (spurmode == WL_SPURAVOID_ON1) {	/* 123Mhz */
-			W_REG(&regs->tsf_clk_frac_l, 0x5341);
-			W_REG(&regs->tsf_clk_frac_h, 0x8);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0x5341);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0x8);
 		} else {	/* 120Mhz */
-			W_REG(&regs->tsf_clk_frac_l, 0x8889);
-			W_REG(&regs->tsf_clk_frac_h, 0x8);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0x8889);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0x8);
 		}
 	} else if (BRCMS_ISLCNPHY(wlc_hw->band)) {
 		if (spurmode == WL_SPURAVOID_ON1) {	/* 82Mhz */
-			W_REG(&regs->tsf_clk_frac_l, 0x7CE0);
-			W_REG(&regs->tsf_clk_frac_h, 0xC);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0x7CE0);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0xC);
 		} else {	/* 80Mhz */
-			W_REG(&regs->tsf_clk_frac_l, 0xCCCD);
-			W_REG(&regs->tsf_clk_frac_h, 0xC);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_l), 0xCCCD);
+			bcma_write16(core, D11REGOFFS(tsf_clk_frac_h), 0xC);
 		}
 	}
 }
@@ -2144,11 +2152,8 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs;
 	u32 gc, gm;
 
-	regs = wlc_hw->regs;
-
 	/* use GPIO select 0 to get all gpio signals from the gpio out reg */
 	brcms_b_mctrl(wlc_hw, MCTL_GPOUT_SEL_MASK, 0);
 
@@ -2179,10 +2184,10 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 		 * The board itself is powered by these GPIOs
 		 * (when not sending pattern) so set them high
 		 */
-		OR_REG(&regs->psm_gpio_oe,
-		       (BOARD_GPIO_12 | BOARD_GPIO_13));
-		OR_REG(&regs->psm_gpio_out,
-		       (BOARD_GPIO_12 | BOARD_GPIO_13));
+		bcma_set16(wlc_hw->d11core, D11REGOFFS(psm_gpio_oe),
+			   (BOARD_GPIO_12 | BOARD_GPIO_13));
+		bcma_set16(wlc_hw->d11core, D11REGOFFS(psm_gpio_out),
+			   (BOARD_GPIO_12 | BOARD_GPIO_13));
 
 		/* Enable antenna diversity, use 2x4 mode */
 		brcms_b_mhf(wlc_hw, MHF3, MHF3_ANTSEL_EN,
@@ -2209,7 +2214,7 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
 			      const __le32 ucode[], const size_t nbytes)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	uint i;
 	uint count;
 
@@ -2217,10 +2222,11 @@ static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
 
 	count = (nbytes / sizeof(u32));
 
-	W_REG(&regs->objaddr, (OBJADDR_AUTO_INC | OBJADDR_UCM_SEL));
-	(void)R_REG(&regs->objaddr);
+	bcma_write32(core, D11REGOFFS(objaddr),
+		     OBJADDR_AUTO_INC | OBJADDR_UCM_SEL);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
 	for (i = 0; i < count; i++)
-		W_REG(&regs->objdata, le32_to_cpu(ucode[i]));
+		bcma_write32(core, D11REGOFFS(objdata), le32_to_cpu(ucode[i]));
 
 }
 
@@ -2286,7 +2292,7 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 	bool fatal = false;
 	uint unit;
 	uint intstatus, idx;
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	unit = wlc_hw->unit;
@@ -2294,7 +2300,9 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 	for (idx = 0; idx < NFIFO; idx++) {
 		/* read intstatus register and ignore any non-error bits */
 		intstatus =
-		    R_REG(&regs->intctrlregs[idx].intstatus) & I_ERRORS;
+			bcma_read32(core,
+				    D11REGOFFS(intctrlregs[idx].intstatus)) &
+			I_ERRORS;
 		if (!intstatus)
 			continue;
 
@@ -2339,8 +2347,9 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 			brcms_fatal_error(wlc_hw->wlc->wl); /* big hammer */
 			break;
 		} else
-			W_REG(&regs->intctrlregs[idx].intstatus,
-			      intstatus);
+			bcma_write32(core,
+				     D11REGOFFS(intctrlregs[idx].intstatus),
+				     intstatus);
 	}
 }
 
@@ -2348,7 +2357,7 @@ void brcms_c_intrson(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
 	wlc->macintmask = wlc->defmacintmask;
-	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(macintmask), wlc->macintmask);
 }
 
 /*
@@ -2382,8 +2391,8 @@ u32 brcms_c_intrsoff(struct brcms_c_info *wlc)
 
 	macintmask = wlc->macintmask;	/* isr can still happen */
 
-	W_REG(&wlc_hw->regs->macintmask, 0);
-	(void)R_REG(&wlc_hw->regs->macintmask);	/* sync readback */
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(macintmask), 0);
+	(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(macintmask));
 	udelay(1);		/* ensure int line is no longer driven */
 	wlc->macintmask = 0;
 
@@ -2398,7 +2407,7 @@ void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 		return;
 
 	wlc->macintmask = macintmask;
-	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
+	bcma_write32(wlc_hw->d11core, D11REGOFFS(macintmask), wlc->macintmask);
 }
 
 /* assumes that the d11 MAC is enabled */
@@ -2510,11 +2519,11 @@ brcms_c_mute(struct brcms_c_info *wlc, bool mute_tx)
 static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 macintstatus;
 
 	/* macintstatus includes a DMA interrupt summary bit */
-	macintstatus = R_REG(&regs->macintstatus);
+	macintstatus = bcma_read32(core, D11REGOFFS(macintstatus));
 
 	BCMMSG(wlc->wiphy, "wl%d: macintstatus: 0x%x\n", wlc_hw->unit,
 		 macintstatus);
@@ -2541,12 +2550,12 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 	 * consequences
 	 */
 	/* turn off the interrupts */
-	W_REG(&regs->macintmask, 0);
-	(void)R_REG(&regs->macintmask);	/* sync readback */
+	bcma_write32(core, D11REGOFFS(macintmask), 0);
+	(void)bcma_read32(core, D11REGOFFS(macintmask));
 	wlc->macintmask = 0;
 
 	/* clear device interrupts */
-	W_REG(&regs->macintstatus, macintstatus);
+	bcma_write32(core, D11REGOFFS(macintstatus), macintstatus);
 
 	/* MI_DMAINT is indication of non-zero intstatus */
 	if (macintstatus & MI_DMAINT)
@@ -2555,8 +2564,8 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 		 * RX_FIFO. If MI_DMAINT is set, assume it
 		 * is set and clear the interrupt.
 		 */
-		W_REG(&regs->intctrlregs[RX_FIFO].intstatus,
-		      DEF_RXINTMASK);
+		bcma_write32(core, D11REGOFFS(intctrlregs[RX_FIFO].intstatus),
+			     DEF_RXINTMASK);
 
 	return macintstatus;
 }
@@ -2619,7 +2628,7 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
 
@@ -2636,7 +2645,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	/* force the core awake */
 	brcms_c_ucode_wake_override_set(wlc_hw, BRCMS_WAKE_OVERRIDE_MACSUSPEND);
 
-	mc = R_REG(&regs->maccontrol);
+	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 
 	if (mc == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
@@ -2648,7 +2657,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 	WARN_ON(!(mc & MCTL_PSM_RUN));
 	WARN_ON(!(mc & MCTL_EN_MAC));
 
-	mi = R_REG(&regs->macintstatus);
+	mi = bcma_read32(core, D11REGOFFS(macintstatus));
 	if (mi == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
@@ -2659,21 +2668,21 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 
 	brcms_b_mctrl(wlc_hw, MCTL_EN_MAC, 0);
 
-	SPINWAIT(!(R_REG(&regs->macintstatus) & MI_MACSSPNDD),
+	SPINWAIT(!(bcma_read32(core, D11REGOFFS(macintstatus)) & MI_MACSSPNDD),
 		 BRCMS_MAX_MAC_SUSPEND);
 
-	if (!(R_REG(&regs->macintstatus) & MI_MACSSPNDD)) {
+	if (!(bcma_read32(core, D11REGOFFS(macintstatus)) & MI_MACSSPNDD)) {
 		wiphy_err(wiphy, "wl%d: wlc_suspend_mac_and_wait: waited %d uS"
 			  " and MI_MACSSPNDD is still not on.\n",
 			  wlc_hw->unit, BRCMS_MAX_MAC_SUSPEND);
 		wiphy_err(wiphy, "wl%d: psmdebug 0x%08x, phydebug 0x%08x, "
 			  "psm_brc 0x%04x\n", wlc_hw->unit,
-			  R_REG(&regs->psmdebug),
-			  R_REG(&regs->phydebug),
-			  R_REG(&regs->psm_brc));
+			  bcma_read32(core, D11REGOFFS(psmdebug)),
+			  bcma_read32(core, D11REGOFFS(phydebug)),
+			  bcma_read16(core, D11REGOFFS(psm_brc)));
 	}
 
-	mc = R_REG(&regs->maccontrol);
+	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 	if (mc == 0xffffffff) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
@@ -2688,7 +2697,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 void brcms_c_enable_mac(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 mc, mi;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
@@ -2701,20 +2710,20 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	if (wlc_hw->mac_suspend_depth > 0)
 		return;
 
-	mc = R_REG(&regs->maccontrol);
+	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 	WARN_ON(mc & MCTL_PSM_JMP_0);
 	WARN_ON(mc & MCTL_EN_MAC);
 	WARN_ON(!(mc & MCTL_PSM_RUN));
 
 	brcms_b_mctrl(wlc_hw, MCTL_EN_MAC, MCTL_EN_MAC);
-	W_REG(&regs->macintstatus, MI_MACSSPNDD);
+	bcma_write32(core, D11REGOFFS(macintstatus), MI_MACSSPNDD);
 
-	mc = R_REG(&regs->maccontrol);
+	mc = bcma_read32(core, D11REGOFFS(maccontrol));
 	WARN_ON(mc & MCTL_PSM_JMP_0);
 	WARN_ON(!(mc & MCTL_EN_MAC));
 	WARN_ON(!(mc & MCTL_PSM_RUN));
 
-	mi = R_REG(&regs->macintstatus);
+	mi = bcma_read32(core, D11REGOFFS(macintstatus));
 	WARN_ON(mi & MI_MACSSPNDD);
 
 	brcms_c_ucode_wake_override_clear(wlc_hw,
@@ -2731,55 +2740,53 @@ void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 
 static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 {
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 w, val;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	BCMMSG(wiphy, "wl%d\n", wlc_hw->unit);
 
-	regs = wlc_hw->regs;
-
 	/* Validate dchip register access */
 
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	w = R_REG(&regs->objdata);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	w = bcma_read32(core, D11REGOFFS(objdata));
 
 	/* Can we write and read back a 32bit register? */
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, (u32) 0xaa5555aa);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	bcma_write32(core, D11REGOFFS(objdata), (u32) 0xaa5555aa);
 
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	val = R_REG(&regs->objdata);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	val = bcma_read32(core, D11REGOFFS(objdata));
 	if (val != (u32) 0xaa5555aa) {
 		wiphy_err(wiphy, "wl%d: validate_chip_access: SHM = 0x%x, "
 			  "expected 0xaa5555aa\n", wlc_hw->unit, val);
 		return false;
 	}
 
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, (u32) 0x55aaaa55);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	bcma_write32(core, D11REGOFFS(objdata), (u32) 0x55aaaa55);
 
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	val = R_REG(&regs->objdata);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	val = bcma_read32(core, D11REGOFFS(objdata));
 	if (val != (u32) 0x55aaaa55) {
 		wiphy_err(wiphy, "wl%d: validate_chip_access: SHM = 0x%x, "
 			  "expected 0x55aaaa55\n", wlc_hw->unit, val);
 		return false;
 	}
 
-	W_REG(&regs->objaddr, OBJADDR_SHM_SEL | 0);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, w);
+	bcma_write32(core, D11REGOFFS(objaddr), OBJADDR_SHM_SEL | 0);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	bcma_write32(core, D11REGOFFS(objdata), w);
 
 	/* clear CFPStart */
-	W_REG(&regs->tsf_cfpstart, 0);
+	bcma_write32(core, D11REGOFFS(tsf_cfpstart), 0);
 
-	w = R_REG(&regs->maccontrol);
+	w = bcma_read32(core, D11REGOFFS(maccontrol));
 	if ((w != (MCTL_IHR_EN | MCTL_WAKE)) &&
 	    (w != (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE))) {
 		wiphy_err(wiphy, "wl%d: validate_chip_access: maccontrol = "
@@ -2796,38 +2803,38 @@ static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 
 void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 {
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 tmp;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	tmp = 0;
-	regs = wlc_hw->regs;
 
 	if (on) {
 		if ((ai_get_chip_id(wlc_hw->sih) == BCM4313_CHIP_ID)) {
-			OR_REG(&regs->clk_ctl_st,
-			       (CCS_ERSRC_REQ_HT | CCS_ERSRC_REQ_D11PLL |
-				CCS_ERSRC_REQ_PHYPLL));
-			SPINWAIT((R_REG(&regs->clk_ctl_st) &
-				  (CCS_ERSRC_AVAIL_HT)) != (CCS_ERSRC_AVAIL_HT),
+			bcma_set32(core, D11REGOFFS(clk_ctl_st),
+				   CCS_ERSRC_REQ_HT |
+				   CCS_ERSRC_REQ_D11PLL |
+				   CCS_ERSRC_REQ_PHYPLL);
+			SPINWAIT((bcma_read32(core, D11REGOFFS(clk_ctl_st)) &
+				  CCS_ERSRC_AVAIL_HT) != CCS_ERSRC_AVAIL_HT,
 				 PHYPLL_WAIT_US);
 
-			tmp = R_REG(&regs->clk_ctl_st);
-			if ((tmp & (CCS_ERSRC_AVAIL_HT)) !=
-			    (CCS_ERSRC_AVAIL_HT))
+			tmp = bcma_read32(core, D11REGOFFS(clk_ctl_st));
+			if ((tmp & CCS_ERSRC_AVAIL_HT) != CCS_ERSRC_AVAIL_HT)
 				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on PHY"
 					  " PLL failed\n", __func__);
 		} else {
-			OR_REG(&regs->clk_ctl_st,
-			       (CCS_ERSRC_REQ_D11PLL | CCS_ERSRC_REQ_PHYPLL));
-			SPINWAIT((R_REG(&regs->clk_ctl_st) &
+			bcma_set32(core, D11REGOFFS(clk_ctl_st),
+				   tmp | CCS_ERSRC_REQ_D11PLL |
+				   CCS_ERSRC_REQ_PHYPLL);
+			SPINWAIT((bcma_read32(core, D11REGOFFS(clk_ctl_st)) &
 				  (CCS_ERSRC_AVAIL_D11PLL |
 				   CCS_ERSRC_AVAIL_PHYPLL)) !=
 				 (CCS_ERSRC_AVAIL_D11PLL |
 				  CCS_ERSRC_AVAIL_PHYPLL), PHYPLL_WAIT_US);
 
-			tmp = R_REG(&regs->clk_ctl_st);
+			tmp = bcma_read32(core, D11REGOFFS(clk_ctl_st));
 			if ((tmp &
 			     (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 			    !=
@@ -2841,8 +2848,9 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 		 * be requesting it; so we'll deassert the request but
 		 * not wait for status to comply.
 		 */
-		AND_REG(&regs->clk_ctl_st, ~CCS_ERSRC_REQ_PHYPLL);
-		tmp = R_REG(&regs->clk_ctl_st);
+		bcma_mask32(core, D11REGOFFS(clk_ctl_st),
+			    ~CCS_ERSRC_REQ_PHYPLL);
+		(void)bcma_read32(core, D11REGOFFS(clk_ctl_st));
 	}
 }
 
@@ -2894,35 +2902,31 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 static u16
 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
-	u16 __iomem *objdata_lo = (u16 __iomem *)&regs->objdata;
-	u16 __iomem *objdata_hi = objdata_lo + 1;
-	u16 v;
+	struct bcma_device *core = wlc_hw->d11core;
+	u16 objoff = D11REGOFFS(objdata);
 
-	W_REG(&regs->objaddr, sel | (offset >> 2));
-	(void)R_REG(&regs->objaddr);
+	bcma_write32(core, D11REGOFFS(objaddr), sel | (offset >> 2));
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
 	if (offset & 2)
-		v = R_REG(objdata_hi);
-	else
-		v = R_REG(objdata_lo);
+		objoff += 2;
 
-	return v;
+	return bcma_read16(core, objoff);
+;
 }
 
 static void
 brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		     u32 sel)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
-	u16 __iomem *objdata_lo = (u16 __iomem *)&regs->objdata;
-	u16 __iomem *objdata_hi = objdata_lo + 1;
+	struct bcma_device *core = wlc_hw->d11core;
+	u16 objoff = D11REGOFFS(objdata);
 
-	W_REG(&regs->objaddr, sel | (offset >> 2));
-	(void)R_REG(&regs->objaddr);
+	bcma_write32(core, D11REGOFFS(objaddr), sel | (offset >> 2));
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
 	if (offset & 2)
-		W_REG(objdata_hi, v);
-	else
-		W_REG(objdata_lo, v);
+		objoff += 2;
+
+	bcma_write16(core, objoff, v);
 }
 
 /*
@@ -3008,14 +3012,14 @@ static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw,
 
 	/* write retry limit to SCR, shouldn't need to suspend */
 	if (wlc_hw->up) {
-		W_REG(&wlc_hw->regs->objaddr,
-		      OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
-		(void)R_REG(&wlc_hw->regs->objaddr);
-		W_REG(&wlc_hw->regs->objdata, wlc_hw->SRL);
-		W_REG(&wlc_hw->regs->objaddr,
-		      OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
-		(void)R_REG(&wlc_hw->regs->objaddr);
-		W_REG(&wlc_hw->regs->objdata, wlc_hw->LRL);
+		bcma_write32(wlc_hw->d11core, D11REGOFFS(objaddr),
+			     OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
+		(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(objaddr));
+		bcma_write32(wlc_hw->d11core, D11REGOFFS(objdata), wlc_hw->SRL);
+		bcma_write32(wlc_hw->d11core, D11REGOFFS(objaddr),
+			     OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
+		(void)bcma_read32(wlc_hw->d11core, D11REGOFFS(objaddr));
+		bcma_write32(wlc_hw->d11core, D11REGOFFS(objdata), wlc_hw->LRL);
 	}
 }
 
@@ -3197,9 +3201,9 @@ void brcms_c_init_scb(struct scb *scb)
 static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	u32 sflags;
-	uint bcnint_us;
+	u32 bcnint_us;
 	uint i = 0;
 	bool fifosz_fixup = false;
 	int err = 0;
@@ -3207,8 +3211,6 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	struct wiphy *wiphy = wlc->wiphy;
 	struct brcms_ucode *ucode = &wlc_hw->wlc->wl->ucode;
 
-	regs = wlc_hw->regs;
-
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* reset PSM */
@@ -3221,14 +3223,14 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	fifosz_fixup = true;
 
 	/* let the PSM run to the suspended state, set mode to BSS STA */
-	W_REG(&regs->macintstatus, -1);
+	bcma_write32(core, D11REGOFFS(macintstatus), -1);
 	brcms_b_mctrl(wlc_hw, ~0,
 		       (MCTL_IHR_EN | MCTL_INFRA | MCTL_PSM_RUN | MCTL_WAKE));
 
 	/* wait for ucode to self-suspend after auto-init */
-	SPINWAIT(((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0),
-		 1000 * 1000);
-	if ((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0)
+	SPINWAIT(((bcma_read32(core, D11REGOFFS(macintstatus)) &
+		   MI_MACSSPNDD) == 0), 1000 * 1000);
+	if ((bcma_read32(core, D11REGOFFS(macintstatus)) & MI_MACSSPNDD) == 0)
 		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
 			  "suspend!\n", wlc_hw->unit);
 
@@ -3298,7 +3300,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 			  wlc_hw->xmtfifo_sz[i], i);
 
 	/* make sure we can still talk to the mac */
-	WARN_ON(R_REG(&regs->maccontrol) == 0xffffffff);
+	WARN_ON(bcma_read32(core, D11REGOFFS(maccontrol)) == 0xffffffff);
 
 	/* band-specific inits done by wlc_bsinit() */
 
@@ -3307,7 +3309,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	brcms_b_write_shm(wlc_hw, M_MAX_ANTCNT, ANTCNT);
 
 	/* enable one rx interrupt per received frame */
-	W_REG(&regs->intrcvlazy[0], (1 << IRL_FC_SHIFT));
+	bcma_write32(core, D11REGOFFS(intrcvlazy[0]), (1 << IRL_FC_SHIFT));
 
 	/* set the station mode (BSS STA) */
 	brcms_b_mctrl(wlc_hw,
@@ -3316,19 +3318,21 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 
 	/* set up Beacon interval */
 	bcnint_us = 0x8000 << 10;
-	W_REG(&regs->tsf_cfprep, (bcnint_us << CFPREP_CBI_SHIFT));
-	W_REG(&regs->tsf_cfpstart, bcnint_us);
-	W_REG(&regs->macintstatus, MI_GP1);
+	bcma_write32(core, D11REGOFFS(tsf_cfprep),
+		     (bcnint_us << CFPREP_CBI_SHIFT));
+	bcma_write32(core, D11REGOFFS(tsf_cfpstart), bcnint_us);
+	bcma_write32(core, D11REGOFFS(macintstatus), MI_GP1);
 
 	/* write interrupt mask */
-	W_REG(&regs->intctrlregs[RX_FIFO].intmask, DEF_RXINTMASK);
+	bcma_write32(core, D11REGOFFS(intctrlregs[RX_FIFO].intmask),
+		     DEF_RXINTMASK);
 
 	/* allow the MAC to control the PHY clock (dynamic on/off) */
 	brcms_b_macphyclk_set(wlc_hw, ON);
 
 	/* program dynamic clock control fast powerup delay register */
 	wlc->fastpwrup_dly = ai_clkctl_fast_pwrup_delay(wlc_hw->sih);
-	W_REG(&regs->scc_fastpwrup_dly, wlc->fastpwrup_dly);
+	bcma_write16(core, D11REGOFFS(scc_fastpwrup_dly), wlc->fastpwrup_dly);
 
 	/* tell the ucode the corerev */
 	brcms_b_write_shm(wlc_hw, M_MACHW_VER, (u16) wlc_hw->corerev);
@@ -3341,19 +3345,21 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 				      machwcap >> 16) & 0xffff));
 
 	/* write retry limits to SCR, this done after PSM init */
-	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, wlc_hw->SRL);
-	W_REG(&regs->objaddr, OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
-	(void)R_REG(&regs->objaddr);
-	W_REG(&regs->objdata, wlc_hw->LRL);
+	bcma_write32(core, D11REGOFFS(objaddr),
+		     OBJADDR_SCR_SEL | S_DOT11_SRC_LMT);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	bcma_write32(core, D11REGOFFS(objdata), wlc_hw->SRL);
+	bcma_write32(core, D11REGOFFS(objaddr),
+		     OBJADDR_SCR_SEL | S_DOT11_LRC_LMT);
+	(void)bcma_read32(core, D11REGOFFS(objaddr));
+	bcma_write32(core, D11REGOFFS(objdata), wlc_hw->LRL);
 
 	/* write rate fallback retry limits */
 	brcms_b_write_shm(wlc_hw, M_SFRMTXCNTFBRTHSD, wlc_hw->SFBL);
 	brcms_b_write_shm(wlc_hw, M_LFRMTXCNTFBRTHSD, wlc_hw->LFBL);
 
-	AND_REG(&regs->ifs_ctl, 0x0FFF);
-	W_REG(&regs->ifs_aifsn, EDCF_AIFSN_MIN);
+	bcma_mask16(core, D11REGOFFS(ifs_ctl), 0x0FFF);
+	bcma_write16(core, D11REGOFFS(ifs_aifsn), EDCF_AIFSN_MIN);
 
 	/* init the tx dma engines */
 	for (i = 0; i < NFIFO; i++) {
@@ -3810,7 +3816,7 @@ static void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 
 	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
 
-	v1 = R_REG(&wlc->regs->maccontrol);
+	v1 = bcma_read32(wlc->hw->d11core, D11REGOFFS(maccontrol));
 	v2 = MCTL_WAKE;
 	if (hps)
 		v2 |= MCTL_HPS;
@@ -4129,7 +4135,8 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		acp_shm.cwmax = params->cw_max;
 		acp_shm.cwcur = acp_shm.cwmin;
 		acp_shm.bslots =
-		    R_REG(&wlc->regs->tsf_random) & acp_shm.cwcur;
+			bcma_read16(wlc->hw->d11core, D11REGOFFS(tsf_random)) &
+			acp_shm.cwcur;
 		acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
 		/* Indicate the new params to the ucode */
 		acp_shm.status = brcms_b_read_shm(wlc->hw, (M_EDCF_QINFO +
@@ -4441,7 +4448,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 			  uint unit, bool piomode)
 {
 	struct brcms_hardware *wlc_hw;
-	struct d11regs __iomem *regs;
 	char *macaddr = NULL;
 	uint err = 0;
 	uint j;
@@ -4490,13 +4496,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	wlc_hw->deviceid = pcidev->device;
 
 	/* set bar0 window to point at D11 core */
-	wlc_hw->regs = (struct d11regs __iomem *)
-				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
-	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
-
-	regs = wlc_hw->regs;
-
-	wlc->regs = wlc_hw->regs;
+	(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+	wlc_hw->d11core = core;
+	wlc_hw->corerev = core->id.rev;
 
 	/* validate chip, chiprev and corerev */
 	if (!brcms_c_isgoodchip(wlc_hw)) {
@@ -4617,7 +4619,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 		wlc->band->bandtype = j ? BRCM_BAND_5G : BRCM_BAND_2G;
 		wlc->core->coreidx = ai_coreidx(wlc_hw->sih);
 
-		wlc_hw->machwcap = R_REG(&regs->machwcap);
+		wlc_hw->machwcap = bcma_read32(core, D11REGOFFS(machwcap));
 		wlc_hw->machwcap_backup = wlc_hw->machwcap;
 
 		/* init tx fifo size */
@@ -4626,7 +4628,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 
 		/* Get a phy for this band */
 		wlc_hw->band->pi =
-			wlc_phy_attach(wlc_hw->phy_sh, regs,
+			wlc_phy_attach(wlc_hw->phy_sh, core->bus->mmio,
 				       wlc_hw->band->bandtype,
 				       wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
@@ -5074,8 +5076,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	 */
 	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
 	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
-		wlc_hw->regs = (struct d11regs __iomem *)
-				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+		(void)ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
 	/*
 	 * Inform phy that a POR reset has occurred so
@@ -5320,8 +5321,8 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 
 		/* Reset and disable the core */
 		if (ai_iscoreup(wlc_hw->sih)) {
-			if (R_REG(&wlc_hw->regs->maccontrol) &
-			    MCTL_EN_MAC)
+			if (bcma_read32(wlc_hw->d11core,
+					D11REGOFFS(maccontrol)) & MCTL_EN_MAC)
 				brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 			callbacks += brcms_reset(wlc_hw->wlc->wl);
 			brcms_c_coredisable(wlc_hw);
@@ -7478,11 +7479,11 @@ static void
 brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 
 	/* read the tsf timer low, then high to get an atomic read */
-	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
-	*tsf_h_ptr = R_REG(&regs->tsf_timerhigh);
+	*tsf_l_ptr = bcma_read32(core, D11REGOFFS(tsf_timerlow));
+	*tsf_h_ptr = bcma_read32(core, D11REGOFFS(tsf_timerhigh));
 }
 
 /*
@@ -8155,7 +8156,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
 	u32 macintstatus;
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs __iomem *regs = wlc_hw->regs;
+	struct bcma_device *core = wlc_hw->d11core;
 	struct wiphy *wiphy = wlc->wiphy;
 
 	if (brcms_deviceremoved(wlc)) {
@@ -8191,7 +8192,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
 		BCMMSG(wlc->wiphy, "end of ATIM window\n");
-		OR_REG(&regs->maccommand, wlc->qvalid);
+		bcma_set32(core, D11REGOFFS(maccommand), wlc->qvalid);
 		wlc->qvalid = 0;
 	}
 
@@ -8219,7 +8220,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	/* gptimer timeout */
 	if (macintstatus & MI_TO)
-		W_REG(&regs->gptimer, 0);
+		bcma_write32(core, D11REGOFFS(gptimer), 0);
 
 	if (macintstatus & MI_RFDISABLE) {
 		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
@@ -8241,13 +8242,11 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 {
-	struct d11regs __iomem *regs;
+	struct bcma_device *core = wlc->hw->d11core;
 	u16 chanspec;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	regs = wlc->regs;
-
 	/*
 	 * This will happen if a big-hammer was executed. In
 	 * that case, we want to go back to the channel that
@@ -8277,8 +8276,8 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 		 * update since init path would reset
 		 * to default value
 		 */
-		W_REG(&regs->tsf_cfprep,
-		      (bi << CFPREP_CBI_SHIFT));
+		bcma_write32(core, D11REGOFFS(tsf_cfprep),
+			     bi << CFPREP_CBI_SHIFT);
 
 		/* Update maccontrol PM related bits */
 		brcms_c_set_ps_ctrl(wlc);
@@ -8308,7 +8307,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	brcms_c_bsinit(wlc);
 
 	/* Enable EDCF mode (while the MAC is suspended) */
-	OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
+	bcma_set16(core, D11REGOFFS(ifs_ctl), IFS_USEEDCF);
 	brcms_c_edcf_setparams(wlc, false);
 
 	/* Init precedence maps for empty FIFOs */
@@ -8332,7 +8331,7 @@ void brcms_c_init(struct brcms_c_info *wlc, bool mute_tx)
 	brcms_c_txflowcontrol_reset(wlc);
 
 	/* enable the RF Disable Delay timer */
-	W_REG(&wlc->regs->rfdisabledly, RFDISABLE_DEFAULT);
+	bcma_write32(core, D11REGOFFS(rfdisabledly), RFDISABLE_DEFAULT);
 
 	/*
 	 * Initialize WME parameters; if they haven't been set by some other
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.h b/drivers/net/wireless/brcm80211/brcmsmac/main.h
index e2de97d..adb136e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.h
@@ -334,7 +334,7 @@ struct brcms_hardware {
 	u32 machwcap_backup;	/* backup of machwcap */
 
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
-	struct d11regs __iomem *regs;	/* pointer to device registers */
+	struct bcma_device *d11core;	/* pointer to 802.11 core */
 	struct phy_shim_info *physhim; /* phy shim layer handler */
 	struct shared_phy *phy_sh;	/* pointer to shared phy state */
 	struct brcms_hw_band *band;/* pointer to active per-band state */
@@ -400,7 +400,6 @@ struct brcms_txq_info {
  *
  * pub: pointer to driver public state.
  * wl: pointer to specific private state.
- * regs: pointer to device registers.
  * hw: HW related state.
  * clkreq_override: setting for clkreq for PCIE : Auto, 0, 1.
  * fastpwrup_dly: time in us needed to bring up d11 fast clock.
@@ -477,7 +476,6 @@ struct brcms_txq_info {
 struct brcms_c_info {
 	struct brcms_pub *pub;
 	struct brcms_info *wl;
-	struct d11regs __iomem *regs;
 	struct brcms_hardware *hw;
 
 	/* clock */
-- 
1.7.5.4


