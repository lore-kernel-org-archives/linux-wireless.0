Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2344 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 27/61] staging: brcm80211: removed remaining ASSERTs
 from phy
Date: Tue, 3 May 2011 11:35:27 +0200
Message-ID: <1304415361-7813-28-git-send-email-arend@broadcom.com> (sfid-20110503_113850_668589_10190009)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Partially deleted, partially replaced by WARN_ON to indicate hardware
failure to the user.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c   |   43 ++++----------------
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |   41 ++++++++++---------
 2 files changed, 30 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
index 8fb3e04..ff8bd4e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_cmn.c
@@ -389,16 +389,6 @@ void write_phy_channel_reg(phy_info_t *pi, uint val)
 	W_REG(&pi->regs->phychannel, val);
 }
 
-#if defined(BCMDBG)
-static bool wlc_phy_war41476(phy_info_t *pi)
-{
-	u32 mc = R_REG(&pi->regs->maccontrol);
-
-	return ((mc & MCTL_EN_MAC) == 0)
-	    || ((mc & MCTL_PHYLOCK) == MCTL_PHYLOCK);
-}
-#endif
-
 u16 read_phy_reg(phy_info_t *pi, u16 addr)
 {
 	d11regs_t *regs;
@@ -410,10 +400,6 @@ u16 read_phy_reg(phy_info_t *pi, u16 addr)
 	(void)R_REG(&regs->phyregaddr);
 #endif
 
-	ASSERT(!
-	       (D11REV_IS(pi->sh->corerev, 11)
-		|| D11REV_IS(pi->sh->corerev, 12)) || wlc_phy_war41476(pi));
-
 	pi->phy_wreg = 0;
 	return R_REG(&regs->phyregdata);
 }
@@ -453,10 +439,6 @@ void and_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	(void)R_REG(&regs->phyregaddr);
 #endif
 
-	ASSERT(!
-	       (D11REV_IS(pi->sh->corerev, 11)
-		|| D11REV_IS(pi->sh->corerev, 12)) || wlc_phy_war41476(pi));
-
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) & val));
 	pi->phy_wreg = 0;
 }
@@ -472,10 +454,6 @@ void or_phy_reg(phy_info_t *pi, u16 addr, u16 val)
 	(void)R_REG(&regs->phyregaddr);
 #endif
 
-	ASSERT(!
-	       (D11REV_IS(pi->sh->corerev, 11)
-		|| D11REV_IS(pi->sh->corerev, 12)) || wlc_phy_war41476(pi));
-
 	W_REG(&regs->phyregdata, (R_REG(&regs->phyregdata) | val));
 	pi->phy_wreg = 0;
 }
@@ -491,10 +469,6 @@ void mod_phy_reg(phy_info_t *pi, u16 addr, u16 mask, u16 val)
 	(void)R_REG(&regs->phyregaddr);
 #endif
 
-	ASSERT(!
-	       (D11REV_IS(pi->sh->corerev, 11)
-		|| D11REV_IS(pi->sh->corerev, 12)) || wlc_phy_war41476(pi));
-
 	W_REG(&regs->phyregdata,
 	      ((R_REG(&regs->phyregdata) & ~mask) | (val & mask)));
 	pi->phy_wreg = 0;
@@ -956,17 +930,16 @@ void WLBANDINITFN(wlc_phy_init) (wlc_phy_t *pih, chanspec_t chanspec)
 	pi->radio_chanspec = chanspec;
 
 	mc = R_REG(&pi->regs->maccontrol);
-	if ((mc & MCTL_EN_MAC) != 0) {
-		ASSERT((const char *)
-		       "wlc_phy_init: Called with the MAC running!" == NULL);
-	}
+	if (WARN(mc & MCTL_EN_MAC, "HW error MAC running on init"))
+		return;
 
 	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN)) {
 		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
 	}
 
-	if (D11REV_GE(pi->sh->corerev, 5))
-		ASSERT(ai_core_sflags(pi->sh->sih, 0, 0) & SISF_FCLKA);
+	if (WARN(!(ai_core_sflags(pi->sh->sih, 0, 0) & SISF_FCLKA),
+		 "HW error SISF_FCLKA\n"))
+		return;
 
 	phy_init = pi->pi_fptr.init;
 
@@ -1004,7 +977,9 @@ void wlc_phy_cal_init(wlc_phy_t *pih)
 	phy_info_t *pi = (phy_info_t *) pih;
 	initfn_t cal_init = NULL;
 
-	ASSERT((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) == 0);
+	if (WARN((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) != 0,
+		 "HW error: MAC enabled during phy cal\n"))
+		return;
 
 	if (!pi->initialized) {
 		cal_init = pi->pi_fptr.calinit;
@@ -1226,8 +1201,6 @@ void wlc_phy_do_dummy_tx(phy_info_t *pi, bool ofdm, bool pa_on)
 	};
 	u32 *dummypkt;
 
-	ASSERT((R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC) == 0);
-
 	dummypkt = (u32 *) (ofdm ? ofdmpkt : cckpkt);
 	wlapi_bmac_write_template_ram(pi->sh->physhim, 0, DUMMY_PKT_LEN,
 				      dummypkt);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index c5512eb..34a7b4e 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -14950,8 +14950,6 @@ static void wlc_phy_resetcca_nphy(phy_info_t *pi)
 {
 	u16 val;
 
-	ASSERT(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-
 	wlapi_bmac_phyclk_fgc(pi->sh->physhim, ON);
 
 	val = read_phy_reg(pi, 0x01);
@@ -17403,8 +17401,10 @@ static void wlc_phy_radio_postinit_2055(phy_info_t *pi)
 	SPINWAIT(((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
 		   RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE), 2000);
 
-	ASSERT((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
-		RADIO_2055_RCAL_DONE) == RADIO_2055_RCAL_DONE);
+	if (WARN((read_radio_reg(pi, RADIO_2055_CAL_COUNTER_OUT2) &
+		 RADIO_2055_RCAL_DONE) != RADIO_2055_RCAL_DONE,
+		 "HW error: radio calibration1\n"))
+		return;
 
 	and_radio_reg(pi, RADIO_2055_CAL_LPO_CNTRL,
 		      ~(RADIO_2055_CAL_LPO_ENABLE));
@@ -18253,7 +18253,9 @@ static u16 wlc_phy_radio205x_rcal(phy_info_t *pi)
 			udelay(100);
 		}
 
-		ASSERT(i < MAX_205x_RCAL_WAITLOOPS);
+		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
+			 "HW error: radio calib2"))
+			return 0;
 
 		mod_radio_reg(pi, RADIO_2057_RCAL_CONFIG, 0x2, 0x0);
 
@@ -18302,7 +18304,9 @@ static u16 wlc_phy_radio205x_rcal(phy_info_t *pi)
 			udelay(100);
 		}
 
-		ASSERT(i < MAX_205x_RCAL_WAITLOOPS);
+		if (WARN(i == MAX_205x_RCAL_WAITLOOPS,
+			 "HW error: radio calib3"))
+			return 0;
 
 		write_radio_reg(pi, RADIO_2056_SYN_RCAL_MASTER | RADIO_2056_SYN,
 				0x1);
@@ -18549,8 +18553,6 @@ static u16 wlc_phy_radio2057_rccal(phy_info_t *pi)
 		udelay(500);
 	}
 
-	ASSERT(rccal_valid & 0x2);
-
 	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
 
 	rccal_valid = 0;
@@ -18573,8 +18575,6 @@ static u16 wlc_phy_radio2057_rccal(phy_info_t *pi)
 		udelay(500);
 	}
 
-	ASSERT(rccal_valid & 0x2);
-
 	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
 
 	rccal_valid = 0;
@@ -18598,7 +18598,8 @@ static u16 wlc_phy_radio2057_rccal(phy_info_t *pi)
 		udelay(500);
 	}
 
-	ASSERT(rccal_valid & 0x2);
+	if (WARN(!(rccal_valid & 0x2), "HW error: radio calib4"))
+		return 0;
 
 	write_radio_reg(pi, RADIO_2057_RCCAL_START_R1_Q1_P1, 0x15);
 
@@ -19676,8 +19677,7 @@ void wlc_phy_force_rfseq_nphy(phy_info_t *pi, u8 cmd)
 	or_phy_reg(pi, 0xa3, trigger_mask);
 	SPINWAIT((read_phy_reg(pi, 0xa4) & status_mask), 200000);
 	write_phy_reg(pi, 0xa1, orig_RfseqCoreActv);
-
-	ASSERT((read_phy_reg(pi, 0xa4) & status_mask) == 0);
+	WARN(read_phy_reg(pi, 0xa4) & status_mask, "HW error in rf");
 }
 
 static void
@@ -21557,8 +21557,9 @@ wlc_phy_rfctrlintc_override_nphy(phy_info_t *pi, u8 field, u16 value,
 
 					SPINWAIT(((read_phy_reg(pi, 0x78) & val)
 						  != 0), 10000);
-					ASSERT((read_phy_reg(pi, 0x78) & val) ==
-					       0);
+					if (WARN(read_phy_reg(pi, 0x78) & val,
+						"HW error: override failed"))
+						return;
 
 					mask = (0x1 << 0);
 					val = 0 << 0;
@@ -24321,7 +24322,9 @@ wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
 
 			SPINWAIT(((read_phy_reg(pi, 0xc0) & 0xc000) != 0),
 				 20000);
-			ASSERT((read_phy_reg(pi, 0xc0) & 0xc000) == 0);
+			if (WARN(read_phy_reg(pi, 0xc0) & 0xc000,
+				 "HW error: txiq calib"))
+				return -EIO;
 
 			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
 						tbl_len, 96, 16, tbl_buf);
@@ -24502,7 +24505,9 @@ wlc_phy_rx_iq_est_nphy(phy_info_t *pi, phy_iq_est_t *est, u16 num_samps,
 
 	SPINWAIT(((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) != 0),
 		 10000);
-	ASSERT((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) == 0);
+	if (WARN(read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart,
+		 "HW error: rxiq est"))
+		return;
 
 	if ((read_phy_reg(pi, 0x129) & NPHY_IqestCmd_iqstart) == 0) {
 		for (core = 0; core < pi->pubpi.phy_corenum; core++) {
@@ -29125,8 +29130,6 @@ void wlc_phy_stay_in_carriersearch_nphy(phy_info_t *pi, bool enable)
 {
 	u16 clip_off[] = { 0xffff, 0xffff };
 
-	ASSERT(0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-
 	if (enable) {
 		if (pi->nphy_deaf_count == 0) {
 			pi->classifier_state =
-- 
1.7.4.1


