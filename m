Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1176 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652Ab1IAJRk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:40 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 23/30] staging: brcm80211: use static qualifier for
 local symbols in brcmsmac
Date: Thu, 1 Sep 2011 11:17:13 +0200
Message-ID: <1314868640-9425-24-git-send-email-rvossen@broadcom.com> (sfid-20110901_111804_329322_7E50F86D)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Cleanup resulted in merging several files and made several symbols
local to a source file. These were found by running sparse as it
gave the warning: symbol 'foo' was not declared. Should it be static?

Reported-by: Aaro Koskinen <aaro.koskinen@iki.fi>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |    8 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |    8 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |    5 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |   64 +++++-----
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |    7 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |   26 ++--
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   66 +++++-----
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |  128 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/rate.c          |    4 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |    3 +-
 drivers/staging/brcm80211/brcmsmac/ucode_loader.c  |    5 +-
 13 files changed, 168 insertions(+), 162 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 07f9d37..f78cc50 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -487,7 +487,7 @@ static void ai_hwfixup(struct si_info *sii)
 }
 
 /* parse the enumeration rom to identify all cores */
-void ai_scan(struct si_pub *sih, struct chipcregs *cc)
+static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 {
 	struct si_info *sii = SI_INFO(sih);
 	u32 erombase, *eromptr, *eromlim;
@@ -2057,12 +2057,12 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 		if (sih->chippkg == 9 || sih->chippkg == 0xb)
 			/* Ext PA Controls for 4331 12x9 Package */
 			W_REG(&cc->chipcontrol, val |
-			      (CCTRL4331_EXTPA_EN |
-			       CCTRL4331_EXTPA_ON_GPIO2_5));
+			      CCTRL4331_EXTPA_EN |
+			      CCTRL4331_EXTPA_ON_GPIO2_5);
 		else
 			/* Ext PA Controls for 4331 12x12 Package */
 			W_REG(&cc->chipcontrol,
-			      val | (CCTRL4331_EXTPA_EN));
+			      val | CCTRL4331_EXTPA_EN);
 	} else {
 		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
 		W_REG(&cc->chipcontrol, val);
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 9dfc2ef..29b51a1 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -49,26 +49,26 @@
 #define ANT_SELCFG_NUM_2x4	4
 #define ANT_SELCFG_DEF_2x4	0x02	/* default antenna configuration */
 
-const u16 mimo_2x4_div_antselpat_tbl[] = {
+static const u16 mimo_2x4_div_antselpat_tbl[] = {
 	0, 0, 0x9, 0xa,		/* ant0: 0 ant1: 2,3 */
 	0, 0, 0x5, 0x6,		/* ant0: 1 ant1: 2,3 */
 	0, 0, 0, 0,		/* n.a.              */
 	0, 0, 0, 0		/* n.a.              */
 };
 
-const u8 mimo_2x4_div_antselid_tbl[16] = {
+static const u8 mimo_2x4_div_antselid_tbl[16] = {
 	0, 0, 0, 0, 0, 2, 3, 0,
 	0, 0, 1, 0, 0, 0, 0, 0	/* pat to antselid */
 };
 
-const u16 mimo_2x3_div_antselpat_tbl[] = {
+static const u16 mimo_2x3_div_antselpat_tbl[] = {
 	16, 0, 1, 16,		/* ant0: 0 ant1: 1,2 */
 	16, 16, 16, 16,		/* n.a.              */
 	16, 2, 16, 16,		/* ant0: 2 ant1: 1   */
 	16, 16, 16, 16		/* n.a.              */
 };
 
-const u8 mimo_2x3_div_antselid_tbl[16] = {
+static const u8 mimo_2x3_div_antselid_tbl[16] = {
 	0, 1, 2, 0, 0, 0, 0, 0,
 	0, 0, 0, 0, 0, 0, 0, 0	/* pat to antselid */
 };
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 6d9a0fe..85680c8 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -409,8 +409,9 @@ static bool _dma_descriptor_align(struct dma_info *di)
 	return true;
 }
 
-void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
-			       uint *alloced, dma_addr_t *pap)
+static void *dma_alloc_consistent(struct pci_dev *pdev, uint size,
+				  u16 align_bits, uint *alloced,
+				  dma_addr_t *pap)
 {
 	if (align_bits) {
 		u16 align = (1 << align_bits);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 2825b1e..6ded4fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -754,7 +754,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	return wlc->macintstatus != 0;
 }
 
-int brcms_b_state_get(struct brcms_hardware *wlc_hw,
+static int brcms_b_state_get(struct brcms_hardware *wlc_hw,
 		      struct brcms_b_state *state)
 {
 	state->machwcap = wlc_hw->machwcap;
@@ -904,7 +904,7 @@ static void brcms_b_info_init(struct brcms_hardware *wlc_hw)
 	wlc_hw->chanspec = CH20MHZ_CHSPEC(1);
 }
 
-void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
+static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 {
 	/* delay before first read of ucode state */
 	udelay(40);
@@ -914,7 +914,7 @@ void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
 }
 
-void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw, u8 *ea)
+static void brcms_b_hw_etheraddr(struct brcms_hardware *wlc_hw, u8 *ea)
 {
 	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
 }
@@ -1186,7 +1186,7 @@ static void brcms_c_ucode_mute_override_clear(struct brcms_hardware *wlc_hw)
 /*
  * Write a MAC address to the given match reg offset in the RXE match engine.
  */
-void
+static void
 brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
@@ -1244,7 +1244,7 @@ brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 	}
 }
 
-void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
+static void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
 {
 	wlc_hw->band->CWmin = newmin;
 
@@ -1253,7 +1253,7 @@ void brcms_b_set_cwmin(struct brcms_hardware *wlc_hw, u16 newmin)
 	W_REG(&wlc_hw->regs->objdata, newmin);
 }
 
-void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax)
+static void brcms_b_set_cwmax(struct brcms_hardware *wlc_hw, u16 newmax)
 {
 	wlc_hw->band->CWmax = newmax;
 
@@ -1684,7 +1684,7 @@ static void brcms_b_xtal(struct brcms_hardware *wlc_hw, bool want)
  * this function could be called when driver is down and w/o clock
  * it operates on different registers depending on corerev and boardflag.
  */
-bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
+static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 {
 	bool v, clk, xtal;
 	u32 resetbits = 0, flags = 0;
@@ -2051,7 +2051,7 @@ void brcms_b_antsel_type_set(struct brcms_hardware *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
-void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
+static void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 {
 	bool fatal = false;
 	uint unit;
@@ -2755,7 +2755,7 @@ brcms_b_copyfrom_objmem(struct brcms_hardware *wlc_hw, uint offset, void *buf,
 	}
 }
 
-void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
+static void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
 			   uint *len)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
@@ -2765,7 +2765,8 @@ void brcms_b_copyfrom_vars(struct brcms_hardware *wlc_hw, char **buf,
 	*len = wlc_hw->vars_size;
 }
 
-void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL, u16 LRL)
+static void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw,
+				   u16 SRL, u16 LRL)
 {
 	wlc_hw->SRL = SRL;
 	wlc_hw->LRL = LRL;
@@ -2783,7 +2784,7 @@ void brcms_b_retrylimit_upd(struct brcms_hardware *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
+static void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 {
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
@@ -2810,7 +2811,7 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 	return;
 }
 
-void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
+static void brcms_b_antsel_set(struct brcms_hardware *wlc_hw, u32 antsel_avail)
 {
 	wlc_hw->antsel_avail = antsel_avail;
 }
@@ -2850,7 +2851,7 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 	return true;
 }
 
-void brcms_b_reset(struct brcms_hardware *wlc_hw)
+static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -2899,7 +2900,7 @@ static u16 brcms_c_init_chanspec(struct brcms_c_info *wlc)
 	return chanspec;
 }
 
-struct scb global_scb;
+static struct scb global_scb;
 
 static void brcms_c_init_scb(struct brcms_c_info *wlc, struct scb *scb)
 {
@@ -3092,7 +3093,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 }
 
 void
-brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
+static brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 			  bool mute) {
 	u32 macintmask;
 	bool fastclk;
@@ -3581,7 +3582,7 @@ void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
 		brcms_c_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
 }
 
-void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
+static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
@@ -4151,7 +4152,7 @@ static void brcms_c_radio_timer(void *arg)
 }
 
 /* common low-level watchdog code */
-void brcms_b_watchdog(void *arg)
+static void brcms_b_watchdog(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	struct brcms_hardware *wlc_hw = wlc->hw;
@@ -4399,8 +4400,9 @@ struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc)
  *    initialize software state for each core and band
  *    put the whole chip in reset(driver down state), no clock
  */
-int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
-		   bool piomode, void *regsva, struct pci_dev *btparam)
+static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
+			  uint unit, bool piomode, void *regsva,
+			  struct pci_dev *btparam)
 {
 	struct brcms_hardware *wlc_hw;
 	struct d11regs *regs;
@@ -5209,7 +5211,7 @@ static void brcms_c_detach_module(struct brcms_c_info *wlc)
 /*
  * low level detach
  */
-int brcms_b_detach(struct brcms_c_info *wlc)
+static int brcms_b_detach(struct brcms_c_info *wlc)
 {
 	uint i;
 	struct brcms_hw_band *band;
@@ -5380,7 +5382,7 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
 }
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
-void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
+static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 {
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
@@ -5424,7 +5426,7 @@ void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	}
 }
 
-int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
+static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 {
 	uint coremask;
 
@@ -5466,7 +5468,7 @@ int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	return 0;
 }
 
-int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
+static int brcms_b_up_finish(struct brcms_hardware *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -5611,7 +5613,7 @@ static uint brcms_c_down_del_timer(struct brcms_c_info *wlc)
 	return callbacks;
 }
 
-int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
+static int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 {
 	bool dev_gone;
 	uint callbacks = 0;
@@ -5639,7 +5641,7 @@ int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 	return callbacks;
 }
 
-int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
+static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 {
 	uint callbacks = 0;
 	bool dev_gone;
@@ -6644,7 +6646,7 @@ static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
  *
  * Returns true if packet consumed (queued), false if not.
  */
-bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
+static bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
 {
 	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
@@ -8284,7 +8286,7 @@ void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 			      (wlc->bcn_li_dtim << 8) | wlc->bcn_li_bcn);
 }
 
-void
+static void
 brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
@@ -9033,7 +9035,7 @@ int brcms_c_get_header_len()
 }
 
 /* mac is assumed to be suspended at this point */
-void
+static void
 brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
 			      int len, bool both)
 {
@@ -9053,8 +9055,8 @@ brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
 	}
 }
 
-void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[], int len,
-				   bool both)
+static void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[],
+					  int len, bool both)
 {
 	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
 }
@@ -9297,7 +9299,7 @@ void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
 }
 
-int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
+static int brcms_b_xmtfifo_sz_get(struct brcms_hardware *wlc_hw, uint fifo,
 			   uint *blocks)
 {
 	if (fifo >= NFIFO)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 3955d6e..eec83ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -1019,7 +1019,8 @@ wlc_phy_init_radio_regs_allbands(struct brcms_phy *pi,
 }
 
 uint
-wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
+wlc_phy_init_radio_regs(struct brcms_phy *pi,
+			const struct radio_regs *radioregs,
 			u16 core_offset)
 {
 	uint i = 0;
@@ -1724,7 +1725,7 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 		(*txpwr_recalc_fn)(pi);
 }
 
-void
+static void
 wlc_phy_txpower_reg_limit_calc(struct brcms_phy *pi, struct txpwr_limits *txpwr,
 			       u16 chanspec)
 {
@@ -2539,7 +2540,7 @@ void wlc_phy_noise_sample_request_external(struct brcms_phy_pub *pih)
 	wlc_phy_noise_sample_request(pih, PHY_NOISE_SAMPLE_EXTERNAL, channel);
 }
 
-s8 lcnphy_gain_index_offset_for_pkt_rssi[] = {
+static const s8 lcnphy_gain_index_offset_for_pkt_rssi[] = {
 	8,
 	8,
 	8,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index a06e719..e09752d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -1023,7 +1023,7 @@ extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 extern uint wlc_phy_init_radio_regs_allbands(struct brcms_phy *pi,
 					     struct radio_20xx_regs *radioregs);
 extern uint wlc_phy_init_radio_regs(struct brcms_phy *pi,
-				    struct radio_regs *radioregs,
+				    const struct radio_regs *radioregs,
 				    u16 core_offset);
 
 extern void wlc_phy_txpower_ipa_upd(struct brcms_phy *pi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 941b7fa..fa21734 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -878,7 +878,7 @@ struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
 #define LCNPHY_NUM_DIG_FILT_COEFFS 16
 #define LCNPHY_NUM_TX_DIG_FILTERS_CCK 13
 
-u16 LCNPHY_txdigfiltcoeffs_cck[LCNPHY_NUM_TX_DIG_FILTERS_CCK]
+static const u16 LCNPHY_txdigfiltcoeffs_cck[LCNPHY_NUM_TX_DIG_FILTERS_CCK]
 	[LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
 	{0, 1, 415, 1874, 64, 128, 64, 792, 1656, 64, 128, 64, 778, 1582, 64,
 	 128, 64,},
@@ -909,7 +909,7 @@ u16 LCNPHY_txdigfiltcoeffs_cck[LCNPHY_NUM_TX_DIG_FILTERS_CCK]
 };
 
 #define LCNPHY_NUM_TX_DIG_FILTERS_OFDM 3
-u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
+static const u16 LCNPHY_txdigfiltcoeffs_ofdm[LCNPHY_NUM_TX_DIG_FILTERS_OFDM]
 	[LCNPHY_NUM_DIG_FILT_COEFFS + 1] = {
 	{0, 0, 0xa2, 0x0, 0x100, 0x100, 0x0, 0x0, 0x0, 0x100, 0x0, 0x0,
 	 0x278, 0xfea0, 0x80, 0x100, 0x80,},
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index cdf6185..f4c89ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -218,7 +218,7 @@ struct nphy_ipa_txrxgain {
 
 #define NPHY_IPA_RXCAL_MAXGAININDEX (6 - 1)
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = {
+static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = {
 	{0, 0, 0, 0, 0, 100},
 	{0, 0, 0, 0, 0, 50},
 	{0, 0, 0, 0, 0, -1},
@@ -227,7 +227,7 @@ struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = {
 	{0, 2, 3, 3, 0, -1}
 };
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = {
+static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = {
 	{0, 0, 0, 0, 0, 128},
 	{0, 0, 0, 0, 0, 70},
 	{0, 0, 0, 0, 0, 20},
@@ -236,7 +236,7 @@ struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = {
 	{0, 2, 3, 3, 0, 20}
 };
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = {
+static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = {
 	{0, 0, 0, 0, 0, 100},
 	{0, 0, 0, 0, 0, 50},
 	{0, 0, 0, 0, 0, -1},
@@ -245,7 +245,7 @@ struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = {
 	{0, 0, 5, 3, 0, -1}
 };
 
-struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = {
+static const struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = {
 	{0, 0, 0, 0, 0, 10},
 	{0, 0, 0, 1, 0, 10},
 	{0, 0, 1, 2, 0, 10},
@@ -266,7 +266,7 @@ enum {
 	  (0x1 << 14) |	\
 	  (0x1 << 13)))
 
-u16 NPHY_IPA_REV4_txdigi_filtcoeffs[][NPHY_NUM_DIG_FILT_COEFFS] = {
+static const u16 NPHY_IPA_REV4_txdigi_filtcoeffs[][NPHY_NUM_DIG_FILT_COEFFS] = {
 	{-377, 137, -407, 208, -1527, 956, 93, 186, 93,
 	 230, -44, 230, 201, -191, 201},
 	{-77, 20, -98, 49, -93, 60, 56, 111, 56, 26, -5,
@@ -10930,7 +10930,7 @@ struct radio_regs regs_RX_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_SYN_2056_rev11[] = {
+static const struct radio_regs regs_SYN_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11115,7 +11115,7 @@ struct radio_regs regs_SYN_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_TX_2056_rev11[] = {
+static const struct radio_regs regs_TX_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11272,7 +11272,7 @@ struct radio_regs regs_TX_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-struct radio_regs regs_RX_2056_rev11[] = {
+static const struct radio_regs regs_RX_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -20140,9 +20140,9 @@ static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi)
 
 static void wlc_phy_radio_init_2056(struct brcms_phy *pi)
 {
-	struct radio_regs *regs_SYN_2056_ptr = NULL;
-	struct radio_regs *regs_TX_2056_ptr = NULL;
-	struct radio_regs *regs_RX_2056_ptr = NULL;
+	const struct radio_regs *regs_SYN_2056_ptr = NULL;
+	const struct radio_regs *regs_TX_2056_ptr = NULL;
+	const struct radio_regs *regs_RX_2056_ptr = NULL;
 
 	if (NREV_IS(pi->pubpi.phy_rev, 3)) {
 		regs_SYN_2056_ptr = regs_SYN_2056;
@@ -20637,7 +20637,7 @@ static void
 wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 				 const struct chan_info_nphy_radio205x *ci)
 {
-	struct radio_regs *regs_SYN_2056_ptr = NULL;
+	const struct radio_regs *regs_SYN_2056_ptr = NULL;
 
 	write_radio_reg(pi,
 			RADIO_2056_SYN_PLL_VCOCAL1 | RADIO_2056_SYN,
@@ -27041,7 +27041,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	s8 optim_gaintbl_index = 0, prev_gaintbl_index = 0;
 	s8 curr_gaintbl_index = 3;
 	u8 gainctrl_dirn = NPHY_RXCAL_GAIN_INIT;
-	struct nphy_ipa_txrxgain *nphy_rxcal_gaintbl;
+	const struct nphy_ipa_txrxgain *nphy_rxcal_gaintbl;
 	u16 hpvga, lpf_biq1, lpf_biq0, lna2, lna1;
 	int fine_gain_idx;
 	s8 txpwrindex;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index c354496..15c5ffc 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -17,7 +17,7 @@
 #include <types.h>
 #include "phytbl_lcn.h"
 
-const u32 dot11lcn_gain_tbl_rev0[] = {
+static const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -116,7 +116,7 @@ const u32 dot11lcn_gain_tbl_rev0[] = {
 	0x00000000,
 };
 
-const u32 dot11lcn_gain_tbl_rev1[] = {
+static const u32 dot11lcn_gain_tbl_rev1[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -215,7 +215,7 @@ const u32 dot11lcn_gain_tbl_rev1[] = {
 	0x00000000,
 };
 
-const u16 dot11lcn_aux_gain_idx_tbl_rev0[] = {
+static const u16 dot11lcn_aux_gain_idx_tbl_rev0[] = {
 	0x0401,
 	0x0402,
 	0x0403,
@@ -256,7 +256,7 @@ const u16 dot11lcn_aux_gain_idx_tbl_rev0[] = {
 	0x0000,
 };
 
-const u32 dot11lcn_gain_idx_tbl_rev0[] = {
+static const u32 dot11lcn_gain_idx_tbl_rev0[] = {
 	0x00000000,
 	0x00000000,
 	0x10000000,
@@ -407,7 +407,7 @@ const u32 dot11lcn_gain_idx_tbl_rev0[] = {
 	0x0000001c,
 };
 
-const u16 dot11lcn_aux_gain_idx_tbl_2G[] = {
+static const u16 dot11lcn_aux_gain_idx_tbl_2G[] = {
 	0x0000,
 	0x0000,
 	0x0000,
@@ -448,7 +448,7 @@ const u16 dot11lcn_aux_gain_idx_tbl_2G[] = {
 	0x0000
 };
 
-const u8 dot11lcn_gain_val_tbl_2G[] = {
+static const u8 dot11lcn_gain_val_tbl_2G[] = {
 	0xfc,
 	0x02,
 	0x08,
@@ -519,7 +519,7 @@ const u8 dot11lcn_gain_val_tbl_2G[] = {
 	0x00
 };
 
-const u32 dot11lcn_gain_idx_tbl_2G[] = {
+static const u32 dot11lcn_gain_idx_tbl_2G[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -674,7 +674,7 @@ const u32 dot11lcn_gain_idx_tbl_2G[] = {
 	0x00000000
 };
 
-const u32 dot11lcn_gain_tbl_2G[] = {
+static const u32 dot11lcn_gain_tbl_2G[] = {
 	0x00000000,
 	0x00000004,
 	0x00000008,
@@ -773,7 +773,7 @@ const u32 dot11lcn_gain_tbl_2G[] = {
 	0x00000000
 };
 
-const u32 dot11lcn_gain_tbl_extlna_2G[] = {
+static const u32 dot11lcn_gain_tbl_extlna_2G[] = {
 	0x00000000,
 	0x00000004,
 	0x00000008,
@@ -872,7 +872,7 @@ const u32 dot11lcn_gain_tbl_extlna_2G[] = {
 	0x00000000
 };
 
-const u16 dot11lcn_aux_gain_idx_tbl_extlna_2G[] = {
+static const u16 dot11lcn_aux_gain_idx_tbl_extlna_2G[] = {
 	0x0400,
 	0x0400,
 	0x0400,
@@ -913,7 +913,7 @@ const u16 dot11lcn_aux_gain_idx_tbl_extlna_2G[] = {
 	0x0000
 };
 
-const u8 dot11lcn_gain_val_tbl_extlna_2G[] = {
+static const u8 dot11lcn_gain_val_tbl_extlna_2G[] = {
 	0xfc,
 	0x02,
 	0x08,
@@ -984,7 +984,7 @@ const u8 dot11lcn_gain_val_tbl_extlna_2G[] = {
 	0x00
 };
 
-const u32 dot11lcn_gain_idx_tbl_extlna_2G[] = {
+static const u32 dot11lcn_gain_idx_tbl_extlna_2G[] = {
 	0x00000000,
 	0x00000040,
 	0x00000000,
@@ -1139,7 +1139,7 @@ const u32 dot11lcn_gain_idx_tbl_extlna_2G[] = {
 	0x00000000
 };
 
-const u32 dot11lcn_aux_gain_idx_tbl_5G[] = {
+static const u32 dot11lcn_aux_gain_idx_tbl_5G[] = {
 	0x0000,
 	0x0000,
 	0x0000,
@@ -1180,7 +1180,7 @@ const u32 dot11lcn_aux_gain_idx_tbl_5G[] = {
 	0x0000
 };
 
-const u32 dot11lcn_gain_val_tbl_5G[] = {
+static const u32 dot11lcn_gain_val_tbl_5G[] = {
 	0xf7,
 	0xfd,
 	0x00,
@@ -1251,7 +1251,7 @@ const u32 dot11lcn_gain_val_tbl_5G[] = {
 	0x00
 };
 
-const u32 dot11lcn_gain_idx_tbl_5G[] = {
+static const u32 dot11lcn_gain_idx_tbl_5G[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -1406,7 +1406,7 @@ const u32 dot11lcn_gain_idx_tbl_5G[] = {
 	0x00000000
 };
 
-const u32 dot11lcn_gain_tbl_5G[] = {
+static const u32 dot11lcn_gain_tbl_5G[] = {
 	0x00000000,
 	0x00000040,
 	0x00000080,
@@ -1520,7 +1520,7 @@ const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[] = {
 	,
 };
 
-const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[] = {
+static const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[] = {
 	{&dot11lcn_gain_tbl_rev1,
 	 sizeof(dot11lcn_gain_tbl_rev1) / sizeof(dot11lcn_gain_tbl_rev1[0]), 18,
 	 0, 32}
@@ -1611,7 +1611,7 @@ const u32 dot11lcnphytbl_rx_gain_info_sz_rev0 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev0[0]);
 
-const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
+static const u32 dot11lcnphytbl_rx_gain_info_sz_rev1 =
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1) /
 	sizeof(dot11lcnphytbl_rx_gain_info_rev1[0]);
 
@@ -1623,7 +1623,7 @@ const u32 dot11lcnphytbl_rx_gain_info_5G_rev2_sz =
 	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2) /
 	sizeof(dot11lcnphytbl_rx_gain_info_5G_rev2[0]);
 
-const u16 dot11lcn_min_sig_sq_tbl_rev0[] = {
+static const u16 dot11lcn_min_sig_sq_tbl_rev0[] = {
 	0x014d,
 	0x014d,
 	0x014d,
@@ -1690,7 +1690,7 @@ const u16 dot11lcn_min_sig_sq_tbl_rev0[] = {
 	0x014d,
 };
 
-const u16 dot11lcn_noise_scale_tbl_rev0[] = {
+static const u16 dot11lcn_noise_scale_tbl_rev0[] = {
 	0x0000,
 	0x0000,
 	0x0000,
@@ -1757,7 +1757,7 @@ const u16 dot11lcn_noise_scale_tbl_rev0[] = {
 	0x0000,
 };
 
-const u32 dot11lcn_fltr_ctrl_tbl_rev0[] = {
+static const u32 dot11lcn_fltr_ctrl_tbl_rev0[] = {
 	0x000141f8,
 	0x000021f8,
 	0x000021fb,
@@ -1770,7 +1770,7 @@ const u32 dot11lcn_fltr_ctrl_tbl_rev0[] = {
 	0x0000024b,
 };
 
-const u32 dot11lcn_ps_ctrl_tbl_rev0[] = {
+static const u32 dot11lcn_ps_ctrl_tbl_rev0[] = {
 	0x00100001,
 	0x00200010,
 	0x00300001,
@@ -1793,7 +1793,7 @@ const u32 dot11lcn_ps_ctrl_tbl_rev0[] = {
 	0x00600f22,
 };
 
-const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[] = {
+static const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[] = {
 	0x0007,
 	0x0005,
 	0x0006,
@@ -1861,7 +1861,7 @@ const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[] = {
 
 };
 
-const u16 dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[] = {
+static const u16 dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[] = {
 	0x0007,
 	0x0005,
 	0x0002,
@@ -1928,7 +1928,7 @@ const u16 dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[] = {
 	0x0002,
 };
 
-const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0[] = {
+static const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0[] = {
 	0x0002,
 	0x0008,
 	0x0004,
@@ -1995,7 +1995,7 @@ const u16 dot11lcn_sw_ctrl_tbl_4313_epa_rev0[] = {
 	0x0001,
 };
 
-const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
+static const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
 	0x000a,
 	0x0009,
 	0x0006,
@@ -2062,7 +2062,7 @@ const u16 dot11lcn_sw_ctrl_tbl_4313_rev0[] = {
 	0x0005,
 };
 
-const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
+static const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
 	0x0004,
 	0x0004,
 	0x0002,
@@ -2129,7 +2129,7 @@ const u16 dot11lcn_sw_ctrl_tbl_rev0[] = {
 	0x0002,
 };
 
-const u8 dot11lcn_nf_table_rev0[] = {
+static const u8 dot11lcn_nf_table_rev0[] = {
 	0x5f,
 	0x36,
 	0x29,
@@ -2148,7 +2148,7 @@ const u8 dot11lcn_nf_table_rev0[] = {
 	0x1f,
 };
 
-const u8 dot11lcn_gain_val_tbl_rev0[] = {
+static const u8 dot11lcn_gain_val_tbl_rev0[] = {
 	0x09,
 	0x0f,
 	0x14,
@@ -2211,7 +2211,7 @@ const u8 dot11lcn_gain_val_tbl_rev0[] = {
 	0x00,
 };
 
-const u8 dot11lcn_spur_tbl_rev0[] = {
+static const u8 dot11lcn_spur_tbl_rev0[] = {
 	0x01,
 	0x01,
 	0x01,
@@ -2342,7 +2342,7 @@ const u8 dot11lcn_spur_tbl_rev0[] = {
 	0x01,
 };
 
-const u16 dot11lcn_unsup_mcs_tbl_rev0[] = {
+static const u16 dot11lcn_unsup_mcs_tbl_rev0[] = {
 	0x001a,
 	0x0034,
 	0x004e,
@@ -2499,7 +2499,7 @@ const u16 dot11lcn_unsup_mcs_tbl_rev0[] = {
 	0x06f6,
 };
 
-const u16 dot11lcn_iq_local_tbl_rev0[] = {
+static const u16 dot11lcn_iq_local_tbl_rev0[] = {
 	0x0200,
 	0x0300,
 	0x0400,
@@ -2610,7 +2610,7 @@ const u16 dot11lcn_iq_local_tbl_rev0[] = {
 	0x0000,
 };
 
-const u32 dot11lcn_papd_compdelta_tbl_rev0[] = {
+static const u32 dot11lcn_papd_compdelta_tbl_rev0[] = {
 	0x00080000,
 	0x00080000,
 	0x00080000,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index d1455ae..dbf50ef 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -17,7 +17,7 @@
 #include <types.h>
 #include "phytbl_n.h"
 
-const u32 frame_struct_rev0[] = {
+static const u32 frame_struct_rev0[] = {
 	0x08004a04,
 	0x00100000,
 	0x01000a05,
@@ -852,7 +852,7 @@ const u32 frame_struct_rev0[] = {
 	0x00000000,
 };
 
-const u8 frame_lut_rev0[] = {
+static const u8 frame_lut_rev0[] = {
 	0x02,
 	0x04,
 	0x14,
@@ -887,7 +887,7 @@ const u8 frame_lut_rev0[] = {
 	0x2a,
 };
 
-const u32 tmap_tbl_rev0[] = {
+static const u32 tmap_tbl_rev0[] = {
 	0x8a88aa80,
 	0x8aaaaa8a,
 	0x8a8a8aa8,
@@ -1338,7 +1338,7 @@ const u32 tmap_tbl_rev0[] = {
 	0x00000000,
 };
 
-const u32 tdtrn_tbl_rev0[] = {
+static const u32 tdtrn_tbl_rev0[] = {
 	0x061c061c,
 	0x0050ee68,
 	0xf592fe36,
@@ -2045,7 +2045,7 @@ const u32 tdtrn_tbl_rev0[] = {
 	0x00f006be,
 };
 
-const u32 intlv_tbl_rev0[] = {
+static const u32 intlv_tbl_rev0[] = {
 	0x00802070,
 	0x0671188d,
 	0x0a60192c,
@@ -2055,7 +2055,7 @@ const u32 intlv_tbl_rev0[] = {
 	0x00000070,
 };
 
-const u16 pilot_tbl_rev0[] = {
+static const u16 pilot_tbl_rev0[] = {
 	0xff08,
 	0xff08,
 	0xff08,
@@ -2146,7 +2146,7 @@ const u16 pilot_tbl_rev0[] = {
 	0xffff,
 };
 
-const u32 pltlut_tbl_rev0[] = {
+static const u32 pltlut_tbl_rev0[] = {
 	0x76540123,
 	0x62407351,
 	0x76543201,
@@ -2155,7 +2155,7 @@ const u32 pltlut_tbl_rev0[] = {
 	0x76430521,
 };
 
-const u32 tdi_tbl20_ant0_rev0[] = {
+static const u32 tdi_tbl20_ant0_rev0[] = {
 	0x00091226,
 	0x000a1429,
 	0x000b56ad,
@@ -2213,7 +2213,7 @@ const u32 tdi_tbl20_ant0_rev0[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl20_ant1_rev0[] = {
+static const u32 tdi_tbl20_ant1_rev0[] = {
 	0x00014b26,
 	0x00028d29,
 	0x000393ad,
@@ -2271,7 +2271,7 @@ const u32 tdi_tbl20_ant1_rev0[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl40_ant0_rev0[] = {
+static const u32 tdi_tbl40_ant0_rev0[] = {
 	0x0011a346,
 	0x00136ccf,
 	0x0014f5d9,
@@ -2384,7 +2384,7 @@ const u32 tdi_tbl40_ant0_rev0[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl40_ant1_rev0[] = {
+static const u32 tdi_tbl40_ant1_rev0[] = {
 	0x001edb36,
 	0x000129ca,
 	0x0002b353,
@@ -2497,7 +2497,7 @@ const u32 tdi_tbl40_ant1_rev0[] = {
 	0x00000000,
 };
 
-const u16 bdi_tbl_rev0[] = {
+static const u16 bdi_tbl_rev0[] = {
 	0x0070,
 	0x0126,
 	0x012c,
@@ -2506,7 +2506,7 @@ const u16 bdi_tbl_rev0[] = {
 	0x04d2,
 };
 
-const u32 chanest_tbl_rev0[] = {
+static const u32 chanest_tbl_rev0[] = {
 	0x44444444,
 	0x44444444,
 	0x44444444,
@@ -2605,7 +2605,7 @@ const u32 chanest_tbl_rev0[] = {
 	0x10101010,
 };
 
-const u8 mcs_tbl_rev0[] = {
+static const u8 mcs_tbl_rev0[] = {
 	0x00,
 	0x08,
 	0x0a,
@@ -2736,7 +2736,7 @@ const u8 mcs_tbl_rev0[] = {
 	0x00,
 };
 
-const u32 noise_var_tbl0_rev0[] = {
+static const u32 noise_var_tbl0_rev0[] = {
 	0x020c020c,
 	0x0000014d,
 	0x020c020c,
@@ -2995,7 +2995,7 @@ const u32 noise_var_tbl0_rev0[] = {
 	0x0000014d,
 };
 
-const u32 noise_var_tbl1_rev0[] = {
+static const u32 noise_var_tbl1_rev0[] = {
 	0x020c020c,
 	0x0000014d,
 	0x020c020c,
@@ -3254,7 +3254,7 @@ const u32 noise_var_tbl1_rev0[] = {
 	0x0000014d,
 };
 
-const u8 est_pwr_lut_core0_rev0[] = {
+static const u8 est_pwr_lut_core0_rev0[] = {
 	0x50,
 	0x4f,
 	0x4e,
@@ -3321,7 +3321,7 @@ const u8 est_pwr_lut_core0_rev0[] = {
 	0x11,
 };
 
-const u8 est_pwr_lut_core1_rev0[] = {
+static const u8 est_pwr_lut_core1_rev0[] = {
 	0x50,
 	0x4f,
 	0x4e,
@@ -3388,7 +3388,7 @@ const u8 est_pwr_lut_core1_rev0[] = {
 	0x11,
 };
 
-const u8 adj_pwr_lut_core0_rev0[] = {
+static const u8 adj_pwr_lut_core0_rev0[] = {
 	0x00,
 	0x00,
 	0x00,
@@ -3519,7 +3519,7 @@ const u8 adj_pwr_lut_core0_rev0[] = {
 	0x00,
 };
 
-const u8 adj_pwr_lut_core1_rev0[] = {
+static const u8 adj_pwr_lut_core1_rev0[] = {
 	0x00,
 	0x00,
 	0x00,
@@ -3650,7 +3650,7 @@ const u8 adj_pwr_lut_core1_rev0[] = {
 	0x00,
 };
 
-const u32 gainctrl_lut_core0_rev0[] = {
+static const u32 gainctrl_lut_core0_rev0[] = {
 	0x03cc2b44,
 	0x03cc2b42,
 	0x03cc2b40,
@@ -3781,7 +3781,7 @@ const u32 gainctrl_lut_core0_rev0[] = {
 	0x00002b00,
 };
 
-const u32 gainctrl_lut_core1_rev0[] = {
+static const u32 gainctrl_lut_core1_rev0[] = {
 	0x03cc2b44,
 	0x03cc2b42,
 	0x03cc2b40,
@@ -3912,7 +3912,7 @@ const u32 gainctrl_lut_core1_rev0[] = {
 	0x00002b00,
 };
 
-const u32 iq_lut_core0_rev0[] = {
+static const u32 iq_lut_core0_rev0[] = {
 	0x0000007f,
 	0x0000007f,
 	0x0000007f,
@@ -4043,7 +4043,7 @@ const u32 iq_lut_core0_rev0[] = {
 	0x0000007f,
 };
 
-const u32 iq_lut_core1_rev0[] = {
+static const u32 iq_lut_core1_rev0[] = {
 	0x0000007f,
 	0x0000007f,
 	0x0000007f,
@@ -4174,7 +4174,7 @@ const u32 iq_lut_core1_rev0[] = {
 	0x0000007f,
 };
 
-const u16 loft_lut_core0_rev0[] = {
+static const u16 loft_lut_core0_rev0[] = {
 	0x0000,
 	0x0101,
 	0x0002,
@@ -4305,7 +4305,7 @@ const u16 loft_lut_core0_rev0[] = {
 	0x0103,
 };
 
-const u16 loft_lut_core1_rev0[] = {
+static const u16 loft_lut_core1_rev0[] = {
 	0x0000,
 	0x0101,
 	0x0002,
@@ -4541,7 +4541,7 @@ const u32 mimophytbl_info_sz_rev0_volatile =
 	sizeof(mimophytbl_info_rev0_volatile) /
 	sizeof(mimophytbl_info_rev0_volatile[0]);
 
-const u16 ant_swctrl_tbl_rev3[] = {
+static const u16 ant_swctrl_tbl_rev3[] = {
 	0x0082,
 	0x0082,
 	0x0211,
@@ -4576,7 +4576,7 @@ const u16 ant_swctrl_tbl_rev3[] = {
 	0x0000,
 };
 
-const u16 ant_swctrl_tbl_rev3_1[] = {
+static const u16 ant_swctrl_tbl_rev3_1[] = {
 	0x0022,
 	0x0022,
 	0x0011,
@@ -4611,7 +4611,7 @@ const u16 ant_swctrl_tbl_rev3_1[] = {
 	0x0000,
 };
 
-const u16 ant_swctrl_tbl_rev3_2[] = {
+static const u16 ant_swctrl_tbl_rev3_2[] = {
 	0x0088,
 	0x0088,
 	0x0044,
@@ -4646,7 +4646,7 @@ const u16 ant_swctrl_tbl_rev3_2[] = {
 	0x0000,
 };
 
-const u16 ant_swctrl_tbl_rev3_3[] = {
+static const u16 ant_swctrl_tbl_rev3_3[] = {
 	0x022,
 	0x022,
 	0x011,
@@ -4681,7 +4681,7 @@ const u16 ant_swctrl_tbl_rev3_3[] = {
 	0x3cc
 };
 
-const u32 frame_struct_rev3[] = {
+static const u32 frame_struct_rev3[] = {
 	0x08004a04,
 	0x00100000,
 	0x01000a05,
@@ -5516,7 +5516,7 @@ const u32 frame_struct_rev3[] = {
 	0x00000000,
 };
 
-const u16 pilot_tbl_rev3[] = {
+static const u16 pilot_tbl_rev3[] = {
 	0xff08,
 	0xff08,
 	0xff08,
@@ -5607,7 +5607,7 @@ const u16 pilot_tbl_rev3[] = {
 	0xffff,
 };
 
-const u32 tmap_tbl_rev3[] = {
+static const u32 tmap_tbl_rev3[] = {
 	0x8a88aa80,
 	0x8aaaaa8a,
 	0x8a8a8aa8,
@@ -6058,7 +6058,7 @@ const u32 tmap_tbl_rev3[] = {
 	0x00000000,
 };
 
-const u32 intlv_tbl_rev3[] = {
+static const u32 intlv_tbl_rev3[] = {
 	0x00802070,
 	0x0671188d,
 	0x0a60192c,
@@ -6068,7 +6068,7 @@ const u32 intlv_tbl_rev3[] = {
 	0x00000070,
 };
 
-const u32 tdtrn_tbl_rev3[] = {
+static const u32 tdtrn_tbl_rev3[] = {
 	0x061c061c,
 	0x0050ee68,
 	0xf592fe36,
@@ -7034,7 +7034,7 @@ const u32 noise_var_tbl_rev3[] = {
 	0x0000014d,
 };
 
-const u16 mcs_tbl_rev3[] = {
+static const u16 mcs_tbl_rev3[] = {
 	0x0000,
 	0x0008,
 	0x000a,
@@ -7165,7 +7165,7 @@ const u16 mcs_tbl_rev3[] = {
 	0x0007,
 };
 
-const u32 tdi_tbl20_ant0_rev3[] = {
+static const u32 tdi_tbl20_ant0_rev3[] = {
 	0x00091226,
 	0x000a1429,
 	0x000b56ad,
@@ -7223,7 +7223,7 @@ const u32 tdi_tbl20_ant0_rev3[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl20_ant1_rev3[] = {
+static const u32 tdi_tbl20_ant1_rev3[] = {
 	0x00014b26,
 	0x00028d29,
 	0x000393ad,
@@ -7281,7 +7281,7 @@ const u32 tdi_tbl20_ant1_rev3[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl40_ant0_rev3[] = {
+static const u32 tdi_tbl40_ant0_rev3[] = {
 	0x0011a346,
 	0x00136ccf,
 	0x0014f5d9,
@@ -7394,7 +7394,7 @@ const u32 tdi_tbl40_ant0_rev3[] = {
 	0x00000000,
 };
 
-const u32 tdi_tbl40_ant1_rev3[] = {
+static const u32 tdi_tbl40_ant1_rev3[] = {
 	0x001edb36,
 	0x000129ca,
 	0x0002b353,
@@ -7507,7 +7507,7 @@ const u32 tdi_tbl40_ant1_rev3[] = {
 	0x00000000,
 };
 
-const u32 pltlut_tbl_rev3[] = {
+static const u32 pltlut_tbl_rev3[] = {
 	0x76540213,
 	0x62407351,
 	0x76543210,
@@ -7516,7 +7516,7 @@ const u32 pltlut_tbl_rev3[] = {
 	0x76430521,
 };
 
-const u32 chanest_tbl_rev3[] = {
+static const u32 chanest_tbl_rev3[] = {
 	0x44444444,
 	0x44444444,
 	0x44444444,
@@ -7615,7 +7615,7 @@ const u32 chanest_tbl_rev3[] = {
 	0x10101010,
 };
 
-const u8 frame_lut_rev3[] = {
+static const u8 frame_lut_rev3[] = {
 	0x02,
 	0x04,
 	0x14,
@@ -7650,7 +7650,7 @@ const u8 frame_lut_rev3[] = {
 	0x2a,
 };
 
-const u8 est_pwr_lut_core0_rev3[] = {
+static const u8 est_pwr_lut_core0_rev3[] = {
 	0x55,
 	0x54,
 	0x54,
@@ -7717,7 +7717,7 @@ const u8 est_pwr_lut_core0_rev3[] = {
 	0xfd,
 };
 
-const u8 est_pwr_lut_core1_rev3[] = {
+static const u8 est_pwr_lut_core1_rev3[] = {
 	0x55,
 	0x54,
 	0x54,
@@ -7784,7 +7784,7 @@ const u8 est_pwr_lut_core1_rev3[] = {
 	0xfd,
 };
 
-const u8 adj_pwr_lut_core0_rev3[] = {
+static const u8 adj_pwr_lut_core0_rev3[] = {
 	0x00,
 	0x00,
 	0x00,
@@ -7915,7 +7915,7 @@ const u8 adj_pwr_lut_core0_rev3[] = {
 	0x00,
 };
 
-const u8 adj_pwr_lut_core1_rev3[] = {
+static const u8 adj_pwr_lut_core1_rev3[] = {
 	0x00,
 	0x00,
 	0x00,
@@ -8046,7 +8046,7 @@ const u8 adj_pwr_lut_core1_rev3[] = {
 	0x00,
 };
 
-const u32 gainctrl_lut_core0_rev3[] = {
+static const u32 gainctrl_lut_core0_rev3[] = {
 	0x5bf70044,
 	0x5bf70042,
 	0x5bf70040,
@@ -8177,7 +8177,7 @@ const u32 gainctrl_lut_core0_rev3[] = {
 	0x5b07001c,
 };
 
-const u32 gainctrl_lut_core1_rev3[] = {
+static const u32 gainctrl_lut_core1_rev3[] = {
 	0x5bf70044,
 	0x5bf70042,
 	0x5bf70040,
@@ -8308,7 +8308,7 @@ const u32 gainctrl_lut_core1_rev3[] = {
 	0x5b07001c,
 };
 
-const u32 iq_lut_core0_rev3[] = {
+static const u32 iq_lut_core0_rev3[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -8439,7 +8439,7 @@ const u32 iq_lut_core0_rev3[] = {
 	0x00000000,
 };
 
-const u32 iq_lut_core1_rev3[] = {
+static const u32 iq_lut_core1_rev3[] = {
 	0x00000000,
 	0x00000000,
 	0x00000000,
@@ -8570,7 +8570,7 @@ const u32 iq_lut_core1_rev3[] = {
 	0x00000000,
 };
 
-const u16 loft_lut_core0_rev3[] = {
+static const u16 loft_lut_core0_rev3[] = {
 	0x0000,
 	0x0000,
 	0x0000,
@@ -8701,7 +8701,7 @@ const u16 loft_lut_core0_rev3[] = {
 	0x0000,
 };
 
-const u16 loft_lut_core1_rev3[] = {
+static const u16 loft_lut_core1_rev3[] = {
 	0x0000,
 	0x0000,
 	0x0000,
@@ -8832,7 +8832,7 @@ const u16 loft_lut_core1_rev3[] = {
 	0x0000,
 };
 
-const u16 papd_comp_rfpwr_tbl_core0_rev3[] = {
+static const u16 papd_comp_rfpwr_tbl_core0_rev3[] = {
 	0x0036,
 	0x0036,
 	0x0036,
@@ -8963,7 +8963,7 @@ const u16 papd_comp_rfpwr_tbl_core0_rev3[] = {
 	0x01d6,
 };
 
-const u16 papd_comp_rfpwr_tbl_core1_rev3[] = {
+static const u16 papd_comp_rfpwr_tbl_core1_rev3[] = {
 	0x0036,
 	0x0036,
 	0x0036,
@@ -9094,7 +9094,7 @@ const u16 papd_comp_rfpwr_tbl_core1_rev3[] = {
 	0x01d6,
 };
 
-const u32 papd_comp_epsilon_tbl_core0_rev3[] = {
+static const u32 papd_comp_epsilon_tbl_core0_rev3[] = {
 	0x00000000,
 	0x00001fa0,
 	0x00019f78,
@@ -9161,7 +9161,7 @@ const u32 papd_comp_epsilon_tbl_core0_rev3[] = {
 	0x03e38ffe,
 };
 
-const u32 papd_cal_scalars_tbl_core0_rev3[] = {
+static const u32 papd_cal_scalars_tbl_core0_rev3[] = {
 	0x05af005a,
 	0x0571005e,
 	0x05040066,
@@ -9228,7 +9228,7 @@ const u32 papd_cal_scalars_tbl_core0_rev3[] = {
 	0x002606a4,
 };
 
-const u32 papd_comp_epsilon_tbl_core1_rev3[] = {
+static const u32 papd_comp_epsilon_tbl_core1_rev3[] = {
 	0x00000000,
 	0x00001fa0,
 	0x00019f78,
@@ -9295,7 +9295,7 @@ const u32 papd_comp_epsilon_tbl_core1_rev3[] = {
 	0x03e38ffe,
 };
 
-const u32 papd_cal_scalars_tbl_core1_rev3[] = {
+static const u32 papd_cal_scalars_tbl_core1_rev3[] = {
 	0x05af005a,
 	0x0571005e,
 	0x05040066,
@@ -9490,7 +9490,7 @@ const u32 mimophytbl_info_sz_rev3_volatile3 =
 	sizeof(mimophytbl_info_rev3_volatile3) /
 	sizeof(mimophytbl_info_rev3_volatile3[0]);
 
-const u32 tmap_tbl_rev7[] = {
+static const u32 tmap_tbl_rev7[] = {
 	0x8a88aa80,
 	0x8aaaaa8a,
 	0x8a8a8aa8,
@@ -10200,7 +10200,7 @@ const u32 noise_var_tbl_rev7[] = {
 	0x0000014d,
 };
 
-const u32 papd_comp_epsilon_tbl_core0_rev7[] = {
+static const u32 papd_comp_epsilon_tbl_core0_rev7[] = {
 	0x00000000,
 	0x00000000,
 	0x00016023,
@@ -10267,7 +10267,7 @@ const u32 papd_comp_epsilon_tbl_core0_rev7[] = {
 	0x0156cfff,
 };
 
-const u32 papd_cal_scalars_tbl_core0_rev7[] = {
+static const u32 papd_cal_scalars_tbl_core0_rev7[] = {
 	0x0b5e002d,
 	0x0ae2002f,
 	0x0a3b0032,
@@ -10334,7 +10334,7 @@ const u32 papd_cal_scalars_tbl_core0_rev7[] = {
 	0x004e068c,
 };
 
-const u32 papd_comp_epsilon_tbl_core1_rev7[] = {
+static const u32 papd_comp_epsilon_tbl_core1_rev7[] = {
 	0x00000000,
 	0x00000000,
 	0x00016023,
@@ -10401,7 +10401,7 @@ const u32 papd_comp_epsilon_tbl_core1_rev7[] = {
 	0x0156cfff,
 };
 
-const u32 papd_cal_scalars_tbl_core1_rev7[] = {
+static const u32 papd_cal_scalars_tbl_core1_rev7[] = {
 	0x0b5e002d,
 	0x0ae2002f,
 	0x0a3b0032,
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 5fb0d9e..9730139 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -208,7 +208,7 @@ const struct brcms_c_rateset ofdm_mimo_rates = {
 };
 
 /* Default ratesets that include MCS32 for 40BW channels */
-const struct brcms_c_rateset cck_ofdm_40bw_mimo_rates = {
+static const struct brcms_c_rateset cck_ofdm_40bw_mimo_rates = {
 	12,
 	/*  1b,   2b,   5.5b, 6,    9,    11b,  12,   18,   24,   36,   48 */
 	{ 0x82, 0x84, 0x8b, 0x0c, 0x12, 0x96, 0x18, 0x24, 0x30, 0x48, 0x60,
@@ -219,7 +219,7 @@ const struct brcms_c_rateset cck_ofdm_40bw_mimo_rates = {
 	  0x00, 0x00, 0x00, 0x00, 0x00}
 };
 
-const struct brcms_c_rateset ofdm_40bw_mimo_rates = {
+static const struct brcms_c_rateset ofdm_40bw_mimo_rates = {
 	8,
 	/*  6b,   9,    12b,  18,   24b,  36,   48,   54 Mbps */
 	{ 0x8c, 0x12, 0x98, 0x24, 0xb0, 0x48, 0x60, 0x6c},
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 0c32e20..7a9349c 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -34,7 +34,8 @@
 #define NSTS_2	2
 #define NSTS_3	3
 #define NSTS_4	4
-const u8 txcore_default[5] = {
+
+static const u8 txcore_default[5] = {
 	(0),			/* bitmap of the core enabled */
 	(0x01),			/* For Nsts = 1, enable core 1 */
 	(0x03),			/* For Nsts = 2, enable core 1 & 2 */
diff --git a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
index bf733fb..c14bce8 100644
--- a/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
+++ b/drivers/staging/brcm80211/brcmsmac/ucode_loader.c
@@ -50,8 +50,9 @@ u32 *bcm43xx_16_mimo;
 u32 bcm43xx_16_mimosz;
 u32 *bcm43xx_24_lcn;
 u32 bcm43xx_24_lcnsz;
-u32 *bcm43xx_bommajor;
-u32 *bcm43xx_bomminor;
+
+static u32 *bcm43xx_bommajor;
+static u32 *bcm43xx_bomminor;
 
 int brcms_ucode_data_init(struct brcms_info *wl)
 {
-- 
1.7.4.1


