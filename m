Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2383 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933185Ab1JDVTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 17:19:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/26] staging: brcm80211: cleaned up struct
 brcms_bss_cfg
Date: Tue, 4 Oct 2011 23:18:47 +0200
Message-ID: <1317763152-17607-2-git-send-email-arend@broadcom.com> (sfid-20111004_232021_411573_FA857652)
In-Reply-To: <1317763152-17607-1-git-send-email-arend@broadcom.com>
References: <1317763152-17607-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Several fields were unused or were only set once. They have been
removed. Uncalled functions that relied on these constants have been
removed as well.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |  132 +----------------------------
 drivers/staging/brcm80211/brcmsmac/main.h |   38 --------
 2 files changed, 3 insertions(+), 167 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index de5f5c0..efc6682 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -1741,34 +1741,6 @@ void brcms_b_bw_set(struct brcms_hardware *wlc_hw, u16 bw)
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-static void
-brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, u16 bcn[],
-			      int len)
-{
-	struct d11regs __iomem *regs = wlc_hw->regs;
-
-	brcms_b_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
-				    bcn);
-	/* write beacon length to SCR */
-	brcms_b_write_shm(wlc_hw, M_BCN0_FRM_BYTESZ, (u16) len);
-	/* mark beacon0 valid */
-	OR_REG(&regs->maccommand, MCMD_BCN0VLD);
-}
-
-static void
-brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, u16 bcn[],
-			      int len)
-{
-	struct d11regs __iomem *regs = wlc_hw->regs;
-
-	brcms_b_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
-				    bcn);
-	/* write beacon length to SCR */
-	brcms_b_write_shm(wlc_hw, M_BCN1_FRM_BYTESZ, (u16) len);
-	/* mark beacon1 valid */
-	OR_REG(&regs->maccommand, MCMD_BCN1VLD);
-}
-
 static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 {
 	u16 v;
@@ -3288,8 +3260,7 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 		if (!cfg->BSS)
 			return false;
 
-		if (!cfg->dtim_programmed)
-			return false;
+		return false;
 	}
 
 	return true;
@@ -3791,9 +3762,6 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	/* update beacon listen interval */
 	brcms_c_bcn_li_upd(wlc);
 
-	/* the world is new again, so is our reported rate */
-	brcms_c_reprate_init(wlc);
-
 	/* write ethernet address to core */
 	brcms_c_set_mac(wlc->bsscfg);
 	brcms_c_set_bssid(wlc->bsscfg);
@@ -4054,17 +4022,12 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 static void brcms_c_setband(struct brcms_c_info *wlc,
 					   uint bandunit)
 {
-	struct brcms_bss_cfg *cfg = wlc->bsscfg;
-
 	wlc->band = wlc->bandstate[bandunit];
 
 	if (!wlc->pub->up)
 		return;
 
 	/* wait for at least one beacon before entering sleeping state */
-	if (cfg->associated)
-		cfg->PMawakebcn = true;
-
 	brcms_c_set_ps_ctrl(wlc);
 
 	/* band-specific initializations */
@@ -5357,7 +5320,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		goto fail;
 	}
 
-	wlc->bsscfg->_idx = 0;
 	wlc->bsscfg->wlc = wlc;
 
 	wlc->mimoft = FT_HT;
@@ -8763,82 +8725,6 @@ int brcms_c_get_header_len(void)
 	return TXOFF;
 }
 
-/* mac is assumed to be suspended at this point */
-static void
-brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, u16 bcn[],
-			      int len, bool both)
-{
-	struct d11regs __iomem *regs = wlc_hw->regs;
-
-	if (both) {
-		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
-		brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
-	} else {
-		/* bcn 0 */
-		if (!(R_REG(&regs->maccommand) & MCMD_BCN0VLD))
-			brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
-		/* bcn 1 */
-		else if (!
-			 (R_REG(&regs->maccommand) & MCMD_BCN1VLD))
-			brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
-	}
-}
-
-static void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, u16 bcn[],
-					  int len, bool both)
-{
-	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
-}
-
-/*
- * Update a beacon for a particular BSS
- * For MBSS, this updates the software template and sets "latest" to
- * the index of the template updated. Otherwise, it updates the hardware
- * template.
- */
-void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
-			       struct brcms_bss_cfg *cfg)
-{
-	int len = BCN_TMPL_LEN;
-
-	/* Clear the soft intmask */
-	wlc->defmacintmask &= ~MI_BCNTPL;
-
-	if (!cfg->up)
-		/* Only allow updates on an UP bss */
-		return;
-
-	/* Optimize:  Some of if/else could be combined */
-	if ((cfg->flags & BRCMS_BSSCFG_HW_BCN) != 0) {
-		/* Hardware beaconing for this config */
-		u16 bcn[BCN_TMPL_LEN / 2];
-		u32 both_valid = MCMD_BCN0VLD | MCMD_BCN1VLD;
-		struct d11regs __iomem *regs = wlc->regs;
-
-		/* Check if both templates are in use, if so sched. an interrupt
-		 *      that will call back into this routine
-		 */
-		if ((R_REG(&regs->maccommand) & both_valid) == both_valid)
-			/* clear any previous status */
-			W_REG(&regs->macintstatus, MI_BCNTPL);
-
-		/* Check that after scheduling the interrupt both of the
-		 *      templates are still busy. if not clear the int. & remask
-		 */
-		if ((R_REG(&regs->maccommand) & both_valid) == both_valid) {
-			wlc->defmacintmask |= MI_BCNTPL;
-			return;
-		}
-
-		wlc->bcn_rspec =
-		    brcms_c_lowest_basic_rspec(wlc, &cfg->current_bss->rateset);
-		/* update the template and ucode shm */
-		brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON,
-				     wlc->bcn_rspec, cfg, bcn, &len);
-		brcms_c_write_hw_bcntemplates(wlc, bcn, len, false);
-	}
-}
-
 /*
  * Update all beacons for the system.
  */
@@ -8847,7 +8733,8 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 	struct brcms_bss_cfg *bsscfg = wlc->bsscfg;
 
 	if (bsscfg->up && !bsscfg->BSS)
-		brcms_c_bss_update_beacon(wlc, bsscfg);
+		/* Clear the soft intmask */
+		wlc->defmacintmask &= ~MI_BCNTPL;
 }
 
 /* Write ssid into shared memory */
@@ -8946,19 +8833,6 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	return 0;
 }
 
-/* init tx reported rate mechanism */
-void brcms_c_reprate_init(struct brcms_c_info *wlc)
-{
-	brcms_c_bsscfg_reprate_init(wlc->bsscfg);
-}
-
-/* per bsscfg init tx reported rate mechanism */
-void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg)
-{
-	bsscfg->txrspecidx = 0;
-	memset((char *)bsscfg->txrspec, 0, sizeof(bsscfg->txrspec));
-}
-
 void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 {
 	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index e458916..9e1575c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -634,35 +634,18 @@ struct antsel_info {
  * enable: is this configuration enabled
  * associated: is BSS in ASSOCIATED state
  * BSS: infraustructure or adhoc
- * dtim_programmed:
  * SSID_len: the length of SSID
  * SSID: SSID string
- * bcmc_scb: one bcmc_scb per band
- * _idx: the index of this bsscfg, assigned at wlc_bsscfg_alloc()
  *
  *
  * BSSID: BSSID (associated)
  * cur_etheraddr: h/w address
- * bcmc_fid: the last BCMC FID queued to TX_BCMC_FIFO
- * bcmc_fid_shm: the last BCMC FID written to shared mem
  * flags: BSSCFG flags; see below
- * bcn: AP beacon
- * bcn_len: AP beacon length
- * ar_disassoc: disassociated in associated recreation
  *
  * current_bss: BSS parms in ASSOCIATED state
  *
- * PM states
- * ---------
- * PMawakebcn: bcn recvd during current waking state
- * PMpending: waiting for tx status with PM indicated set
- * priorPMstate: Detecting PM state transitions
- * PSpoll: flags there is an outstanding PS-Poll frame
  *
  * ID: 'unique' ID of this bsscfg, assigned at bsscfg allocation
- *
- * txrspecidx: index into tx rate circular buffer
- * txrspec: circular buffer of prev MPDUs tx rates
  */
 struct brcms_bss_cfg {
 	struct brcms_c_info *wlc;
@@ -670,27 +653,11 @@ struct brcms_bss_cfg {
 	bool enable;
 	bool associated;
 	bool BSS;
-	bool dtim_programmed;
 	u8 SSID_len;
 	u8 SSID[IEEE80211_MAX_SSID_LEN];
-	struct scb *bcmc_scb[MAXBANDS];
-	s8 _idx;
 	u8 BSSID[ETH_ALEN];
 	u8 cur_etheraddr[ETH_ALEN];
-	u16 bcmc_fid;
-	u16 bcmc_fid_shm;
-	u32 flags;
-	u8 *bcn;
-	uint bcn_len;
-	bool ar_disassoc;
 	struct brcms_bss_info *current_bss;
-	bool PMawakebcn;
-	bool PMpending;
-	bool priorPMstate;
-	bool PSpoll;
-	u16 ID;
-	uint txrspecidx;
-	u32 txrspec[NTXRATE][2];
 };
 
 extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
@@ -765,9 +732,6 @@ extern void brcms_c_inval_dma_pkts(struct brcms_hardware *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
 
-extern void brcms_c_reprate_init(struct brcms_c_info *wlc);
-extern void brcms_c_bsscfg_reprate_init(struct brcms_bss_cfg *bsscfg);
-
 /* Shared memory access */
 extern void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v);
 extern u16 brcms_c_read_shm(struct brcms_c_info *wlc, uint offset);
@@ -775,8 +739,6 @@ extern void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
 			       const void *buf, int len);
 
 extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
-extern void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
-				  struct brcms_bss_cfg *bsscfg);
 
 extern void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
 extern void brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
-- 
1.7.4.1


