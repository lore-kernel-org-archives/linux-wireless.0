Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1732 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733Ab1JBRO6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:14:58 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 06/20] staging: brcm80211: added __iomem qualifier to
 softmac main.c
Date: Sun, 2 Oct 2011 10:14:31 -0700
Message-ID: <1317575685-3156-7-git-send-email-frankyl@broadcom.com> (sfid-20111002_191508_938441_3C87DE2F)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Makes it clear when an address is mapped IO space.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |   81 ++++++++++++++---------------
 drivers/staging/brcm80211/brcmsmac/main.h |    4 +-
 2 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ac5a52a..e4dd2d4 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -638,7 +638,7 @@ brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 
 	regs = wlc_hw->regs;
 
@@ -657,23 +657,23 @@ static void brcms_c_write_inits(struct brcms_hardware *wlc_hw,
 				const struct d11init *inits)
 {
 	int i;
-	u8 *base;
-	u8 *addr;
+	u8 __iomem *base;
+	u8 __iomem *addr;
 	u16 size;
 	u32 value;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	base = (u8 *)wlc_hw->regs;
+	base = (u8 __iomem *)wlc_hw->regs;
 
 	for (i = 0; inits[i].addr != cpu_to_le16(0xffff); i++) {
 		size = le16_to_cpu(inits[i].size);
 		addr = base + le16_to_cpu(inits[i].addr);
 		value = le32_to_cpu(inits[i].value);
 		if (size == 2)
-			W_REG((u16 *)addr, value);
+			W_REG((u16 __iomem *)addr, value);
 		else if (size == 4)
-			W_REG((u32 *)addr, value);
+			W_REG((u32 __iomem *)addr, value);
 		else
 			break;
 	}
@@ -1025,7 +1025,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
 	uint n = 0;
@@ -1113,7 +1113,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
 	u32 macintstatus;
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
 
@@ -1230,7 +1230,7 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 	}
 }
 
-static struct dma64regs *
+static struct dma64regs __iomem *
 dmareg(struct brcms_hardware *hw, uint direction, uint fifonum)
 {
 	if (direction == DMA_TX)
@@ -1645,7 +1645,7 @@ static void
 brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u16 mac_l;
 	u16 mac_m;
 	u16 mac_h;
@@ -1670,7 +1670,7 @@ void
 brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 			    void *buf)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 word;
 	__le32 word_le;
 	__be32 word_be;
@@ -1745,7 +1745,7 @@ static void
 brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 
 	brcms_b_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
 				    bcn);
@@ -1759,7 +1759,7 @@ static void
 brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 
 	brcms_b_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
 				    bcn);
@@ -2168,7 +2168,7 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		 */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-			wlc_hw->regs = (struct d11regs *)
+			wlc_hw->regs = (struct d11regs __iomem *)
 					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
 		brcms_c_mctrl_reset(wlc_hw);
@@ -2202,7 +2202,7 @@ static bool wlc_dma_rxreset(struct brcms_hardware *wlc_hw, uint fifo)
  */
 void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	uint i;
 	bool fastclk;
 	u32 resetbits = 0;
@@ -2286,7 +2286,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
  */
 static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	u16 fifo_nu;
 	u16 txfifo_startblk = TXFIFO_START_BLK, txfifo_endblk;
 	u16 txfifo_def, txfifo_def1;
@@ -2346,8 +2346,7 @@ static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 
 void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
-	struct d11regs *regs;
-	regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 
 	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 	    (wlc_hw->sih->chip == BCM43225_CHIP_ID)) {
@@ -2376,7 +2375,7 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 gc, gm;
 
 	regs = wlc_hw->regs;
@@ -2441,7 +2440,7 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
 			      const __le32 ucode[], const size_t nbytes)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	uint i;
 	uint count;
 
@@ -2518,7 +2517,7 @@ static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 	bool fatal = false;
 	uint unit;
 	uint intstatus, idx;
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	unit = wlc_hw->unit;
@@ -2734,7 +2733,7 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	u32 macintstatus;
 
 	/* macintstatus includes a DMA interrupt summary bit */
@@ -2843,7 +2842,7 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
 
@@ -2912,7 +2911,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 void brcms_c_enable_mac(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 	u32 mc, mi;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
@@ -2955,7 +2954,7 @@ void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 
 static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 w, val;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
@@ -3020,7 +3019,7 @@ static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 
 void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 tmp;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -3118,9 +3117,9 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 static u16
 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
-	struct d11regs *regs = wlc_hw->regs;
-	u16 *objdata_lo = (u16 *)&regs->objdata;
-	u16 *objdata_hi = objdata_lo + 1;
+	struct d11regs __iomem *regs = wlc_hw->regs;
+	u16 __iomem *objdata_lo = (u16 __iomem *)&regs->objdata;
+	u16 __iomem *objdata_hi = objdata_lo + 1;
 	u16 v;
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
@@ -3137,9 +3136,9 @@ static void
 brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		     u32 sel)
 {
-	struct d11regs *regs = wlc_hw->regs;
-	u16 *objdata_lo = (u16 *)&regs->objdata;
-	u16 *objdata_hi = objdata_lo + 1;
+	struct d11regs __iomem *regs = wlc_hw->regs;
+	u16 __iomem *objdata_lo = (u16 __iomem *)&regs->objdata;
+	u16 __iomem *objdata_hi = objdata_lo + 1;
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
@@ -3371,7 +3370,7 @@ void brcms_c_init_scb(struct scb *scb)
 static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u32 sflags;
 	uint bcnint_us;
 	uint i = 0;
@@ -3769,7 +3768,7 @@ static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
 
 void brcms_c_init(struct brcms_c_info *wlc)
 {
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	u16 chanspec;
 	bool mute = false;
 
@@ -4682,7 +4681,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 			  struct pci_dev *btparam)
 {
 	struct brcms_hardware *wlc_hw;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	char *macaddr = NULL;
 	char *vars;
 	uint err = 0;
@@ -4755,8 +4754,8 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	wlc_hw->deviceid = device;
 
 	/* set bar0 window to point at D11 core */
-	wlc_hw->regs = (struct d11regs *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
-						     0);
+	wlc_hw->regs = (struct d11regs __iomem *)
+				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
 
 	regs = wlc_hw->regs;
@@ -5641,7 +5640,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	 */
 	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 	    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-		wlc_hw->regs = (struct d11regs *)
+		wlc_hw->regs = (struct d11regs __iomem *)
 				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
 	/*
@@ -8084,7 +8083,7 @@ static void
 brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 
 	/* read the tsf timer low, then high to get an atomic read */
 	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
@@ -8810,7 +8809,7 @@ static void
 brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len, bool both)
 {
-	struct d11regs *regs = wlc_hw->regs;
+	struct d11regs __iomem *regs = wlc_hw->regs;
 
 	if (both) {
 		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
@@ -8855,7 +8854,7 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 		/* Hardware beaconing for this config */
 		u16 bcn[BCN_TMPL_LEN / 2];
 		u32 both_valid = MCMD_BCN0VLD | MCMD_BCN1VLD;
-		struct d11regs *regs = wlc->regs;
+		struct d11regs __iomem *regs = wlc->regs;
 
 		/* Check if both templates are in use, if so sched. an interrupt
 		 *      that will call back into this routine
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index c938add..045356a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -340,7 +340,7 @@ struct brcms_hardware {
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
 	char *vars;		/* "environment" name=value */
 	uint vars_size;		/* size of vars, free vars on detach */
-	struct d11regs *regs;	/* pointer to device registers */
+	struct d11regs __iomem *regs;	/* pointer to device registers */
 	struct phy_shim_info *physhim; /* phy shim layer handler */
 	struct shared_phy *phy_sh;	/* pointer to shared phy state */
 	struct brcms_hw_band *band;/* pointer to active per-band state */
@@ -489,7 +489,7 @@ struct brcms_txq_info {
 struct brcms_c_info {
 	struct brcms_pub *pub;
 	struct brcms_info *wl;
-	struct d11regs *regs;
+	struct d11regs __iomem *regs;
 	struct brcms_hardware *hw;
 
 	/* clock */
-- 
1.7.1


