Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3242 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1HHN7f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:35 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 64/82] staging: brcm80211: removed void * from softmac
 phy
Date: Mon, 8 Aug 2011 15:58:48 +0200
Message-ID: <1312811946-16713-65-git-send-email-arend@broadcom.com> (sfid-20110808_160040_297419_AD19EA47)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replacing void * by other pointer types improves code
readability and enforces stronger type checking.

Reported-by: Julian Calaby <julian.calaby@gmail.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c        |    7 ++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   13 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |   11 ++++-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    5 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    7 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   47 ++++++++-------------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    7 ++-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    6 ++-
 8 files changed, 50 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e7a166f..f5f914f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4528,9 +4528,10 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		    xmtfifo_sz[(wlc_hw->corerev - XMTFIFOTBL_STARTREV)];
 
 		/* Get a phy for this band */
-		wlc_hw->band->pi = wlc_phy_attach(wlc_hw->phy_sh,
-			(void *)regs, brcms_b_bandtype(wlc_hw), vars,
-			wlc->wiphy);
+		wlc_hw->band->pi =
+			wlc_phy_attach(wlc_hw->phy_sh, regs,
+				       brcms_b_bandtype(wlc_hw), vars,
+				       wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
 			wiphy_err(wiphy, "wl%d: brcms_b_attach: wlc_phy_"
 				  "attach failed\n", unit);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 22f7bfc..831c2fe 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -123,7 +123,7 @@ const u8 ofdm_rate_lookup[] = {
 
 static void wlc_set_phy_uninitted(struct brcms_phy *pi);
 static u32 wlc_phy_get_radio_ver(struct brcms_phy *pi);
-static void wlc_phy_timercb_phycal(void *arg);
+static void wlc_phy_timercb_phycal(struct brcms_phy *pi);
 
 static bool wlc_phy_noise_calc_phy(struct brcms_phy *pi, u32 *cmplx_pwr,
 				   s8 *pwr_ant);
@@ -509,7 +509,7 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 }
 
 struct brcms_phy_pub *
-wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
+wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	       char *vars, struct wiphy *wiphy)
 {
 	struct brcms_phy *pi;
@@ -539,7 +539,7 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 	if (pi == NULL)
 		return NULL;
 	pi->wiphy = wiphy;
-	pi->regs = (struct d11regs *) regs;
+	pi->regs = regs;
 	pi->sh = sh;
 	pi->phy_init_por = true;
 	pi->phy_wreg_limit = PHY_WREG_LIMIT;
@@ -720,9 +720,8 @@ u32 wlc_phy_get_coreflags(struct brcms_phy_pub *pih)
 	return pi->pubpi.coreflags;
 }
 
-static void wlc_phy_timercb_phycal(void *arg)
+static void wlc_phy_timercb_phycal(struct brcms_phy *pi)
 {
-	struct brcms_phy *pi = (struct brcms_phy *) arg;
 	uint delay = 5;
 
 	if (PHY_PERICAL_MPHASE_PENDING(pi)) {
@@ -2619,9 +2618,9 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 	}
 }
 
-void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx)
+void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
+			  struct brcms_d11rxhdr *wlc_rxhdr)
 {
-	struct brcms_d11rxhdr *wlc_rxhdr = (struct brcms_d11rxhdr *) ctx;
 	struct d11rxhdr *rxh = &wlc_rxhdr->rxhdr;
 	int rssi = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_JSSI_MASK;
 	uint radioid = pih->radioid;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index d2faba2..42e0cf0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -103,6 +103,9 @@
 
 #define	BRCMS_RSSI_INVALID	 0	/* invalid RSSI value */
 
+struct d11regs;
+struct phy_shim_info;
+
 struct txpwr_limits {
 	u8 cck[BRCMS_NUM_RATES_CCK];
 	u8 ofdm[BRCMS_NUM_RATES_OFDM];
@@ -160,7 +163,7 @@ struct brcms_chanvec {
 
 struct shared_phy_params {
 	struct si_pub *sih;
-	void *physhim;
+	struct phy_shim_info *physhim;
 	uint unit;
 	uint corerev;
 	uint bustype;
@@ -181,7 +184,8 @@ struct shared_phy_params {
 
 
 extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
-extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh, void *regs,
+extern struct brcms_phy_pub *wlc_phy_attach(struct shared_phy *sh,
+					    struct d11regs *regs,
 					    int bandtype, char *vars,
 					    struct wiphy *wiphy);
 extern void wlc_phy_detach(struct brcms_phy_pub *ppi);
@@ -209,7 +213,8 @@ extern void wlc_phy_chanspec_radio_set(struct brcms_phy_pub *ppi,
 extern u16 wlc_phy_bw_state_get(struct brcms_phy_pub *ppi);
 extern void wlc_phy_bw_state_set(struct brcms_phy_pub *ppi, u16 bw);
 
-extern void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx);
+extern void wlc_phy_rssi_compute(struct brcms_phy_pub *pih,
+				 struct brcms_d11rxhdr *wlc_rxhdr);
 extern void wlc_phy_por_inform(struct brcms_phy_pub *ppi);
 extern void wlc_phy_noise_sample_intr(struct brcms_phy_pub *ppi);
 extern bool wlc_phy_bist_check_phy(struct brcms_phy_pub *ppi);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 25ea003..bcc6d83 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -41,6 +41,8 @@ extern u32 phyhal_msg_level;
 
 #define LCNXN_BASEREV		16
 
+struct phy_shim_info;
+
 struct brcms_phy_srom_fem {
 	/* TSSI positive slope, 1: positive, 0: negative */
 	u8 tssipos;
@@ -546,7 +548,7 @@ struct shared_phy {
 	struct brcms_phy *phy_head;
 	uint unit;
 	struct si_pub *sih;
-	void *physhim;
+	struct phy_shim_info *physhim;
 	uint corerev;
 	u32 machwcap;
 	bool up;
@@ -611,7 +613,6 @@ struct brcms_phy {
 	struct brcms_phy_pub pubpi_ro;
 	struct shared_phy *sh;
 	struct phy_func_ptr pi_fptr;
-	void *pi_ptr;
 
 	union {
 		struct brcms_phy_lcnphy *pi_lcnphy;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 3d140eb..dcf626e5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1041,7 +1041,7 @@ void wlc_lcnphy_read_table(struct brcms_phy *pi, struct phytbl_info *pti)
 
 static void
 wlc_lcnphy_common_read_table(struct brcms_phy *pi, u32 tbl_id,
-			     const void *tbl_ptr, u32 tbl_len,
+			     const u16 *tbl_ptr, u32 tbl_len,
 			     u32 tbl_width, u32 tbl_offset)
 {
 	struct phytbl_info tab;
@@ -1055,7 +1055,7 @@ wlc_lcnphy_common_read_table(struct brcms_phy *pi, u32 tbl_id,
 
 static void
 wlc_lcnphy_common_write_table(struct brcms_phy *pi, u32 tbl_id,
-			      const void *tbl_ptr, u32 tbl_len,
+			      const u16 *tbl_ptr, u32 tbl_len,
 			      u32 tbl_width, u32 tbl_offset)
 {
 
@@ -1965,13 +1965,12 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 	write_phy_reg(pi, 0x93d, 0xc0);
 
 	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      (const void *)
 				      lcnphy_iqcal_loft_gainladder,
 				      ARRAY_SIZE(lcnphy_iqcal_loft_gainladder),
 				      16, 0);
 
 	wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
-				      (const void *)lcnphy_iqcal_ir_gainladder,
+				      lcnphy_iqcal_ir_gainladder,
 				      ARRAY_SIZE(
 					      lcnphy_iqcal_ir_gainladder), 16,
 				      32);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index fb64597..2e8aa64 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -18627,11 +18627,10 @@ wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
 			offset = (tone_id >= 0) ?
 				 ((tone_id *
 				   2) + 1) : (tbllen + (tone_id * 2) + 1);
-			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 offset, 32,
-						 (void *)&pi->
-						 nphy_saved_noisevars.
-						 min_noise_vars[i]);
+			wlc_phy_table_write_nphy(
+				pi, NPHY_TBL_ID_NOISEVAR, 1,
+				offset, 32,
+				&pi->nphy_saved_noisevars.min_noise_vars[i]);
 		}
 
 		pi->nphy_saved_noisevars.bufcount = 0;
@@ -18652,8 +18651,7 @@ wlc_phy_adjust_min_noisevar_nphy(struct brcms_phy *pi, int ntones,
 						&pi->nphy_saved_noisevars.
 						min_noise_vars[i]);
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_NOISEVAR, 1,
-						 offset, 32,
-						 (void *)&noise_var_buf[i]);
+						 offset, 32, &noise_var_buf[i]);
 			pi->nphy_saved_noisevars.bufcount++;
 		}
 
@@ -19296,8 +19294,7 @@ static void wlc_phy_restorecal_nphy(struct brcms_phy *pi)
 		loft_comp = &pi->calibration_cache.txcal_coeffs_5G[5];
 	}
 
-	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80, 16,
-				 (void *)tbl_ptr);
+	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_IQLOCAL, 4, 80, 16, tbl_ptr);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 		txcal_coeffs_bphy[0] = tbl_ptr[0];
@@ -24307,7 +24304,7 @@ static void wlc_phy_tx_iq_war_nphy(struct brcms_phy *pi)
 {
 	struct nphy_iq_comp tx_comp;
 
-	wlc_phy_table_read_nphy(pi, 15, 4, 0x50, 16, (void *)&tx_comp);
+	wlc_phy_table_read_nphy(pi, 15, 4, 0x50, 16, &tx_comp);
 
 	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ, tx_comp.a0);
 	wlapi_bmac_write_shm(pi->sh->physhim, M_20IN40_IQ + 2, tx_comp.b0);
@@ -28684,23 +28681,15 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &m1m2);
 
 			if (restore_cals) {
-
-				wlc_phy_table_write_nphy(pi, 15, 2,
-							 (80 + 2 * core), 16,
-							 (void *)&pi->
-							 nphy_txpwrindex[core].
-							 iqcomp_a);
-
-				wlc_phy_table_write_nphy(pi, 15, 1, (85 + core),
-							 16,
-							 &pi->
-							 nphy_txpwrindex[core].
-							 locomp);
-				wlc_phy_table_write_nphy(pi, 15, 1, (93 + core),
-							 16,
-							 (void *)&pi->
-							 nphy_txpwrindex[core].
-							 locomp);
+				wlc_phy_table_write_nphy(
+					pi, 15, 2, (80 + 2 * core), 16,
+					&pi->nphy_txpwrindex[core].iqcomp_a);
+				wlc_phy_table_write_nphy(
+					pi, 15, 1, (85 + core), 16,
+					&pi->nphy_txpwrindex[core].locomp);
+				wlc_phy_table_write_nphy(
+					pi, 15, 1, (93 + core), 16,
+					&pi->nphy_txpwrindex[core].locomp);
 			}
 
 			wlc_phy_txpwrctrl_enable_nphy(pi, pi->nphy_txpwrctrl);
@@ -28743,13 +28732,13 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 
 				wlc_phy_table_read_nphy(pi, 15, 2,
 							(80 + 2 * core), 16,
-							(void *)&pi->
+							&pi->
 							nphy_txpwrindex[core].
 							iqcomp_a);
 
 				wlc_phy_table_read_nphy(pi, 15, 1, (85 + core),
 							16,
-							(void *)&pi->
+							&pi->
 							nphy_txpwrindex[core].
 							locomp);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index a882139..ec88867 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -59,11 +59,12 @@ void wlc_phy_shim_detach(struct phy_shim_info *physhim)
 }
 
 struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
-				     void (*fn) (void *arg), void *arg,
-				     const char *name)
+				     void (*fn)(struct brcms_phy *pi),
+				     void *arg, const char *name)
 {
 	return (struct wlapi_timer *)
-			brcms_init_timer(physhim->wl, fn, arg, name);
+			brcms_init_timer(physhim->wl, (void (*)(void *))fn,
+					 arg, name);
 }
 
 void wlapi_free_timer(struct phy_shim_info *physhim, struct wlapi_timer *t)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index a35e1ed..14c56f9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -122,14 +122,16 @@
 #define BRCMS_N_TXRX_CHAIN0		0
 #define BRCMS_N_TXRX_CHAIN1		1
 
+struct brcms_phy;
+
 extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
 						void *wl, void *wlc);
 extern void wlc_phy_shim_detach(struct phy_shim_info *physhim);
 
 /* PHY to WL utility functions */
 extern struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
-					    void (*fn) (void *arg), void *arg,
-					    const char *name);
+					    void (*fn) (struct brcms_phy *pi),
+					    void *arg, const char *name);
 extern void wlapi_free_timer(struct phy_shim_info *physhim,
 			     struct wlapi_timer *t);
 extern void wlapi_add_timer(struct phy_shim_info *physhim,
-- 
1.7.4.1


