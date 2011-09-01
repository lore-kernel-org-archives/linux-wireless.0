Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1180 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 30/30] staging: brcm80211: cleaned up several
 main.h/main.c related macro's
Date: Thu, 1 Sep 2011 11:17:20 +0200
Message-ID: <1314868640-9425-31-git-send-email-rvossen@broadcom.com> (sfid-20110901_111800_691465_FA8D6B2A)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved, deleted or substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |   12 +-
 drivers/staging/brcm80211/brcmsmac/main.c  |  283 +++++++++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h  |  164 +---------------
 drivers/staging/brcm80211/brcmsmac/stf.c   |    2 +
 4 files changed, 195 insertions(+), 266 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 341768d..cbf6c6d 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -60,6 +60,8 @@
 					 * accumulate between resets.
 					 */
 
+#define AMPDU_DELIMITER_LEN	4
+
 #define TX_SEQ_TO_INDEX(seq) ((seq) % AMPDU_TX_BA_MAX_WSIZE)
 
 /* max possible overhead per mpdu in the ampdu; 3 is for roundup if needed */
@@ -677,7 +679,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 			if (is40)
 				mimo_ctlchbw =
-				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
+				   CHSPEC_SB_UPPER(wlc_phy_chanspec_get(
+								 wlc->band->pi))
 				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
 
 			/* rebuild the rspec and rspec_fallback */
@@ -748,7 +751,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 				 * check if there are enough
 				 * descriptors available
 				 */
-				if (TXAVAIL(wlc, fifo) <= (seg_cnt + 1)) {
+				if (*wlc->core->txavail[fifo] <= seg_cnt + 1) {
 					wiphy_err(wiphy, "%s: No fifo space  "
 						  "!!\n", __func__);
 					p = NULL;
@@ -1083,7 +1086,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		    TXC_AMPDU_LAST)
 			break;
 
-		p = GETNEXTTXP(wlc, queue);
+		p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	}
 	brcms_c_send_q(wlc);
 
@@ -1141,7 +1144,8 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 			if (((mcl & TXC_AMPDU_MASK) >> TXC_AMPDU_SHIFT) ==
 			    TXC_AMPDU_LAST)
 				break;
-			p = GETNEXTTXP(wlc, queue);
+			p = dma_getnexttxp(wlc->hw->di[queue],
+					   DMA_RANGE_TRANSMITTED);
 		}
 		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 03985ca..6b694b1 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -170,6 +170,22 @@
 
 #define	BCN_TMPL_LEN		512	/* length of the BCN template area */
 
+/* brcms_bss_info flag bit values */
+#define BRCMS_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
+
+/* Flags used in brcms_c_txq_info.stopped */
+/* per prio flow control bits */
+#define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF
+/* stop txq enqueue for packet drain */
+#define TXQ_STOP_FOR_PKT_DRAIN		0x00000100
+/* stop txq enqueue for ampdu flow control */
+#define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200
+
+/* number of 802.11 default (non-paired, group keys) */
+#define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
+
+#define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
+
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
  * OS timer(soft watchdog) it is not a wall clock and won't increment when
@@ -177,12 +193,6 @@
  * for maintenance tasks such as phy calibration and scb update
  */
 
-/*
- * To inform the ucode of the last mcast frame posted
- * so that it can clear moredata bit
- */
-#define BCMCFID(wlc, fid) brcms_b_write_shm((wlc)->hw, M_BCMC_FID, (fid))
-
 #define BRCMS_WAR16165(wlc) ((!AP_ENAB(wlc->pub)) && (wlc->war16165))
 
 /* Find basic rate for a given rate */
@@ -199,10 +209,6 @@
 
 #define BRCMS_TEMPSENSE_PERIOD		10	/* 10 second timeout */
 
-#define SCAN_IN_PROGRESS(x)	0
-
-#define EPI_VERSION_NUM		0x054b0b00
-
 /* precedences numbers for wlc queues. These are twice as may levels as
  * 802.1D priorities.
  * Odd numbers are used for HI priority traffic at same precedence levels
@@ -218,18 +224,9 @@
 #define	_BRCMS_PREC_VO		12	/* Vo - Voice */
 #define	_BRCMS_PREC_NC		14	/* NC - Network Control */
 
-#define MAXMACLIST		64	/* max # source MAC matches */
-#define BCN_TEMPLATE_COUNT	2
-
 /* The BSS is generating beacons in HW */
 #define BRCMS_BSSCFG_HW_BCN	0x20
 
-#define HWBCN_ENAB(cfg)		(((cfg)->flags & BRCMS_BSSCFG_HW_BCN) != 0)
-
-#define MBSS_BCN_ENAB(cfg)       0
-#define MBSS_PRB_ENAB(cfg)       0
-#define SOFTBCN_ENAB(pub)    (0)
-
 #define	SYNTHPU_DLY_APHY_US	3700	/* a phy synthpu_dly time in us */
 #define	SYNTHPU_DLY_BPHY_US	1050	/* b/g phy synthpu_dly time in us */
 #define	SYNTHPU_DLY_NPHY_US	2048	/* n phy REV3 synthpu_dly time in us */
@@ -239,6 +236,29 @@
 
 #define	ANTCNT			10	/* vanilla M_MAX_ANTCNT value */
 
+/* Per-AC retry limit register definitions; uses defs.h bitfield macros */
+#define EDCF_SHORT_S            0
+#define EDCF_SFB_S              4
+#define EDCF_LONG_S             8
+#define EDCF_LFB_S              12
+#define EDCF_SHORT_M            BITFIELD_MASK(4)
+#define EDCF_SFB_M              BITFIELD_MASK(4)
+#define EDCF_LONG_M             BITFIELD_MASK(4)
+#define EDCF_LFB_M              BITFIELD_MASK(4)
+
+#define	RETRY_SHORT_DEF			7	/* Default Short retry Limit */
+#define	RETRY_SHORT_MAX			255	/* Maximum Short retry Limit */
+#define	RETRY_LONG_DEF			4	/* Default Long retry count */
+#define	RETRY_SHORT_FB			3 /* Short count for fallback rate */
+#define	RETRY_LONG_FB			2 /* Long count for fallback rate */
+
+#define	APHY_CWMIN		15
+#define PHY_CWMAX		1023
+
+#define EDCF_AIFSN_MIN               1
+
+#define FRAGNUM_MASK		0xF
+
 #define DMAREG(wlc_hw, direction, fifonum) \
 	((direction == DMA_TX) ? \
 		&(wlc_hw->regs->fifo64regs[fifonum].dmaxmt) : \
@@ -259,11 +279,6 @@
 /* Starting corerev for the fifo size table */
 #define XMTFIFOTBL_STARTREV	20
 
-/* Check if a particular BSS config is AP or STA */
-#define BSSCFG_AP(cfg)		(0)
-#define BSSCFG_STA(cfg)		(1)
-#define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
-
 /* iterate through all valid bsscfg entries */
 #define FOREACH_BSS(wlc, idx, cfg) \
 	for (idx = 0; (int) idx < BRCMS_MAXBSSCFG; idx++) { \
@@ -273,13 +288,79 @@
 /* close marker for iterator code block */
 #define END_FOREACH_BSS()	}
 
-/* Shared memory location index for various AC params */
-#define wme_shmemacindex(ac)	wme_ac2fifo[ac]
-
 /* currently the best mechanism for determining SIFS is the band in use */
 #define SIFS(band) ((band)->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : \
 						       BPHY_SIFS_TIME);
 
+/* A fifo is full. Clear precedences related to that FIFO */
+#define BRCMS_TX_FIFO_CLEAR(wlc, fifo) \
+			((wlc)->tx_prec_map &= ~(wlc)->fifo2prec_map[fifo])
+
+/* Fifo is NOT full. Enable precedences for that FIFO */
+#define BRCMS_TX_FIFO_ENAB(wlc, fifo) \
+			((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
+
+/*
+ * if wpa is in use then portopen is true when the
+ * group key is plumbed otherwise it is always true
+ */
+#define WSEC_ENABLED(wsec) ((wsec) & (WEP_ENABLED | TKIP_ENABLED | AES_ENABLED))
+
+#define BRCMS_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
+	((bsscfg)->wsec & WSEC_SWFLAG)))
+
+#define BRCMS_PORTOPEN(cfg) \
+	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
+	(cfg)->wsec_portopen : true)
+
+#define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
+	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+
+/*
+ * Detect Card removed.
+ * Even checking an sbconfig register read will not false trigger when the core
+ * is in reset it breaks CF address mechanism. Accessing gphy phyversion will
+ * cause SB error if aphy is in reset on 4306B0-DB. Need a simple accessible
+ * reg with fixed 0/1 pattern (some platforms return all 0).
+ * If clocks are present, call the sb routine which will figure out if the
+ * device is removed.
+ */
+#define DEVICEREMOVED(wlc)      \
+	((wlc->hw->clk) ?   \
+	((R_REG(&wlc->hw->regs->maccontrol) & \
+	(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN) : \
+	(ai_deviceremoved(wlc->hw->sih)))
+
+#define BRCMS_WME_RETRY_SHORT_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
+#define BRCMS_WME_RETRY_SFB_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_SFB)
+#define BRCMS_WME_RETRY_LONG_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_LONG)
+#define BRCMS_WME_RETRY_LFB_GET(wlc, ac) \
+					GFIELD(wlc->wme_retries[ac], EDCF_LFB)
+
+#define BRCMS_WME_RETRY_SHORT_SET(wlc, ac, val) \
+	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SHORT, val))
+#define BRCMS_WME_RETRY_SFB_SET(wlc, ac, val) \
+	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SFB, val))
+#define BRCMS_WME_RETRY_LONG_SET(wlc, ac, val) \
+	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LONG, val))
+#define BRCMS_WME_RETRY_LFB_SET(wlc, ac, val) \
+	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LFB, val))
+
+/* sum the individual fifo tx pending packet counts */
+#define	TXPKTPENDTOT(wlc) \
+	((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
+	 (wlc)->core->txpktpend[2] + (wlc)->core->txpktpend[3])
+#define TXPKTPENDGET(wlc, fifo) ((wlc)->core->txpktpend[(fifo)])
+#define TXPKTPENDINC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] += (val))
+#define TXPKTPENDDEC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] -= (val))
+#define TXPKTPENDCLR(wlc, fifo)	((wlc)->core->txpktpend[(fifo)] = 0)
+
+#define IS_MBAND_UNLOCKED(wlc) \
+	((wlc->pub->_nbands > 1) && !(wlc)->bandlocked)
+
 /* dup state between BMAC(struct brcms_hardware) and HIGH(struct brcms_c_info)
    driver */
 struct brcms_b_state {
@@ -682,7 +763,6 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	WARN_ON(macintstatus & MI_PRQ); /* PRQ Interrupt in non-MBSS */
 
 	/* BCN template is available */
-	/* ZZZ: Use AP_ACTIVE ? */
 	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub))
 	    && (macintstatus & MI_BCNTPL))
 		brcms_c_update_beacon(wlc);
@@ -1596,7 +1676,7 @@ static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw)
 {
 
 	/* reject unsupported corerev */
-	if (!VALID_COREREV(wlc_hw->corerev)) {
+	if (!CONF_HAS(D11CONF, wlc_hw->corerev)) {
 		wiphy_err(wlc_hw->wlc->wiphy, "unsupported core rev %d\n",
 			  wlc_hw->corerev);
 		return false;
@@ -2832,12 +2912,12 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 		return false;
 
 	/* disallow PS when one of these meets when not scanning */
-	if (AP_ACTIVE(wlc) || wlc->monitor)
+	if (wlc->monitor)
 		return false;
 
 	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
 		cfg = wlc->bsscfg[idx];
-		if (cfg && BSSCFG_STA(cfg) && cfg->associated) {
+		if (cfg && cfg->associated) {
 			/*
 			 * disallow PS when one of the following
 			 * bsscfg specific conditions meets
@@ -3249,7 +3329,7 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 	/* enable or disable any active IBSSs depending on whether or not
 	 * we are on the home channel
 	 */
-	if (wlc->home_chanspec == BRCMS_BAND_PI_RADIO_CHANSPEC) {
+	if (wlc->home_chanspec == wlc_phy_chanspec_get(wlc->band->pi)) {
 		if (wlc->pub->associated) {
 			/*
 			 * BMAC_NOTE: This is something that should be fixed
@@ -3536,7 +3616,7 @@ void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 	bool hps;
 	bool awake_before;
 
-	hps = PS_ALLOWED(wlc);
+	hps = brcms_c_ps_allowed(wlc);
 
 	BCMMSG(wlc->wiphy, "wl%d: hps %d\n", wlc->pub->unit, hps);
 
@@ -3709,7 +3789,7 @@ static void brcms_c_setband(struct brcms_c_info *wlc,
 	/* wait for at least one beacon before entering sleeping state */
 	for (idx = 0; idx < BRCMS_MAXBSSCFG; idx++) {
 		cfg = wlc->bsscfg[idx];
-		if (cfg && BSSCFG_STA(cfg) && cfg->associated)
+		if (cfg && cfg->associated)
 			cfg->PMawakebcn = true;
 	}
 	brcms_c_set_ps_ctrl(wlc);
@@ -3972,18 +4052,18 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
 		/* Indicate the new params to the ucode */
 		acp_shm.status = brcms_c_read_shm(wlc, (M_EDCF_QINFO +
-						    wme_shmemacindex(aci) *
-						    M_EDCF_QLEN +
-						    M_EDCF_STATUS_OFF));
+						  wme_ac2fifo[aci] *
+						  M_EDCF_QLEN +
+						  M_EDCF_STATUS_OFF));
 		acp_shm.status |= WME_STATUS_NEWAC;
 
 		/* Fill in shm acparam table */
 		shm_entry = (u16 *) &acp_shm;
 		for (i = 0; i < (int)sizeof(struct shm_acparams); i += 2)
 			brcms_c_write_shm(wlc,
-				      M_EDCF_QINFO +
-				      wme_shmemacindex(aci) * M_EDCF_QLEN + i,
-				      *shm_entry++);
+					  M_EDCF_QINFO +
+					  wme_ac2fifo[aci] * M_EDCF_QLEN + i,
+					  *shm_entry++);
 
 	} while (0);
 
@@ -5536,8 +5616,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 					 WL_RADIO_HW_DISABLE);
 
 				FOREACH_BSS(wlc, idx, bsscfg)
-					if (!BSSCFG_STA(bsscfg)
-					    || !bsscfg->enable || !bsscfg->BSS)
+					if (!bsscfg->enable || !bsscfg->BSS)
 						continue;
 					wiphy_err(wlc->wiphy, "wl%d.%d: up"
 						  ": rfdisable -> "
@@ -6127,7 +6206,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			/* brcms_c_BSSinit() will sanitize the rateset before
 			 * using it.. */
 			if (wlc->pub->up &&
-			    (BRCMS_BAND_PI_RADIO_CHANSPEC != chspec)) {
+			    (wlc_phy_chanspec_get(wlc->band->pi) != chspec)) {
 				brcms_c_set_home_chanspec(wlc, chspec);
 				brcms_c_suspend_mac_and_wait(wlc);
 				brcms_c_set_chanspec(wlc, chspec);
@@ -6901,7 +6980,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		/* mcs only allowed when nmode */
 		if (stf > PHY_TXC1_MODE_SDM) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid stf\n",
-				 BRCMS_UNIT(wlc), __func__);
+				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
@@ -6912,7 +6991,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			    ((stf != PHY_TXC1_MODE_SISO)
 			     && (stf != PHY_TXC1_MODE_CDD))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid mcs "
-					  "32\n", BRCMS_UNIT(wlc), __func__);
+					  "32\n", wlc->pub->unit, __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
@@ -6921,8 +7000,8 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			/* mcs > 7 must use stf SDM */
 			if (stf != PHY_TXC1_MODE_SDM) {
 				BCMMSG(wlc->wiphy, "wl%d: enabling "
-					 "SDM mode for mcs %d\n",
-					 BRCMS_UNIT(wlc), rate);
+				       "SDM mode for mcs %d\n",
+				       wlc->pub->unit, rate);
 				stf = PHY_TXC1_MODE_SDM;
 			}
 		} else {
@@ -6934,7 +7013,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 			    (!BRCMS_STBC_CAP_PHY(wlc)
 			     && (stf == PHY_TXC1_MODE_STBC))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: Invalid STBC"
-					  "\n", BRCMS_UNIT(wlc), __func__);
+					  "\n", wlc->pub->unit, __func__);
 				bcmerror = -EINVAL;
 				goto done;
 			}
@@ -6942,7 +7021,7 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 	} else if (IS_OFDM(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
-				  BRCMS_UNIT(wlc), __func__);
+				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
@@ -6950,20 +7029,20 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		if ((cur_band->bandtype != BRCM_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
-				  BRCMS_UNIT(wlc), __func__);
+				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Unknown rate type\n",
-			  BRCMS_UNIT(wlc), __func__);
+			  wlc->pub->unit, __func__);
 		bcmerror = -EINVAL;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: SISO antenna but !SISO "
-			  "request\n", BRCMS_UNIT(wlc), __func__);
+			  "request\n", wlc->pub->unit, __func__);
 		bcmerror = -EINVAL;
 		goto done;
 	}
@@ -7075,7 +7154,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		/* non-AP STA should never use BCMC queue */
 		if (queue == TX_BCMC_FIFO) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: ASSERT queue == "
-				  "TX_BCMC!\n", BRCMS_UNIT(wlc), __func__);
+				  "TX_BCMC!\n", wlc->pub->unit, __func__);
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
@@ -7198,7 +7277,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
 				/* default txbw is 20in40 SB */
 				mimo_ctlchbw = mimo_txbw =
-				   CHSPEC_SB_UPPER(BRCMS_BAND_PI_RADIO_CHANSPEC)
+				   CHSPEC_SB_UPPER(wlc_phy_chanspec_get(
+								 wlc->band->pi))
 				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
 
 				if (IS_MCS(rspec[k])) {
@@ -7250,7 +7330,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			    && (!IS_MCS(rspec[k]))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
 					  "RC_MCS != IS_MCS(rspec)\n",
-					  BRCMS_UNIT(wlc), __func__);
+					  wlc->pub->unit, __func__);
 			}
 
 			if (IS_MCS(rspec[k])) {
@@ -7352,7 +7432,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (BAND_5G(wlc->band->bandtype))
 		mcl |= TXC_FREQBAND_5G;
 
-	if (CHSPEC_IS40(BRCMS_BAND_PI_RADIO_CHANSPEC))
+	if (CHSPEC_IS40(wlc_phy_chanspec_get(wlc->band->pi)))
 		mcl |= TXC_BW_40;
 
 	/* set AMIC bit if using hardware TKIP MIC */
@@ -7515,8 +7595,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	xfts = FRAMETYPE(rspec[1], wlc->mimoft);
 	xfts |= (FRAMETYPE(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
 	xfts |= (FRAMETYPE(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
-	xfts |=
-	    CHSPEC_CHANNEL(BRCMS_BAND_PI_RADIO_CHANSPEC) << XFTS_CHANNEL_SHIFT;
+	xfts |= CHSPEC_CHANNEL(wlc_phy_chanspec_get(wlc->band->pi)) <<
+							     XFTS_CHANNEL_SHIFT;
 	txh->XtraFrameTypes = cpu_to_le16(xfts);
 
 	/* PhyTxControlWord */
@@ -7798,8 +7878,13 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	}
 
 	/* Commit BCMC sequence number in the SHM frame ID location */
-	if (frameid != INVALIDFID)
-		BCMCFID(wlc, frameid);
+	if (frameid != INVALIDFID) {
+		/*
+		 * To inform the ucode of the last mcast frame posted
+		 * so that it can clear moredata bit
+		 */
+		brcms_b_write_shm(wlc->hw, M_BCMC_FID, frameid);
+	}
 
 	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
 		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
@@ -8113,7 +8198,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 		goto fatal;
 	}
 
-	p = GETNEXTTXP(wlc, queue);
+	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
 	if (BRCMS_WAR16165(wlc))
 		brcms_c_war16165(wlc, false);
 	if (p == NULL)
@@ -8972,10 +9057,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	struct ieee80211_mgmt *h;
 	int hdr_len, body_len;
 
-	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
-		hdr_len = DOT11_MAC_HDR_LEN;
-	else
-		hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
+	hdr_len = D11_PHY_HDR_LEN + DOT11_MAC_HDR_LEN;
 
 	/* calc buffer size provided for frame body */
 	body_len = *len - hdr_len;
@@ -8991,7 +9073,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	 * PLCP for Probe Response frames are filled in from
 	 * core's rate table
 	 */
-	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg))
+	if (type == IEEE80211_STYPE_BEACON)
 		/* fill in PLCP */
 		brcms_c_compute_plcp(wlc, bcn_rspec,
 				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
@@ -8999,13 +9081,9 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 
 	/* "Regular" and 16 MBSS but not for 4 MBSS */
 	/* Update the phytxctl for the beacon based on the rspec */
-	if (!SOFTBCN_ENAB(cfg))
-		brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
+	brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
 
-	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
-		h = (struct ieee80211_mgmt *)&plcp[0];
-	else
-		h = (struct ieee80211_mgmt *)&plcp[1];
+	h = (struct ieee80211_mgmt *)&plcp[1];
 
 	/* fill in 802.11 header */
 	h->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT | type);
@@ -9073,7 +9151,7 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 		return;
 
 	/* Optimize:  Some of if/else could be combined */
-	if (!MBSS_BCN_ENAB(cfg) && HWBCN_ENAB(cfg)) {
+	if ((cfg->flags & BRCMS_BSSCFG_HW_BCN) != 0) {
 		/* Hardware beaconing for this config */
 		u16 bcn[BCN_TMPL_LEN / 2];
 		u32 both_valid = MCMD_BCN0VLD | MCMD_BCN1VLD;
@@ -9113,7 +9191,7 @@ void brcms_c_update_beacon(struct brcms_c_info *wlc)
 
 	/* update AP or IBSS beacons */
 	FOREACH_BSS(wlc, idx, bsscfg)
-		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
+		if (bsscfg->up && !bsscfg->BSS)
 			brcms_c_bss_update_beacon(wlc, bsscfg);
 	END_FOREACH_BSS()
 }
@@ -9130,9 +9208,7 @@ void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_bss_cfg *cfg)
 	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
 
 	brcms_c_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
-
-	if (!MBSS_BCN_ENAB(cfg))
-		brcms_c_write_shm(wlc, M_SSIDLEN, (u16) cfg->SSID_len);
+	brcms_c_write_shm(wlc, M_SSIDLEN, (u16) cfg->SSID_len);
 }
 
 void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
@@ -9142,7 +9218,7 @@ void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 
 	/* update AP or IBSS probe responses */
 	FOREACH_BSS(wlc, idx, bsscfg)
-		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
+		if (bsscfg->up && !bsscfg->BSS)
 			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 	END_FOREACH_BSS()
 }
@@ -9159,40 +9235,35 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 	 * write the probe response to hardware, or save in
 	 * the config structure
 	 */
-	if (!MBSS_PRB_ENAB(cfg)) {
 
-		/* create the probe response template */
-		brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
-					 cfg, prb_resp, &len);
+	/* create the probe response template */
+	brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
+				 cfg, prb_resp, &len);
 
-		if (suspend)
-			brcms_c_suspend_mac_and_wait(wlc);
+	if (suspend)
+		brcms_c_suspend_mac_and_wait(wlc);
 
-		/* write the probe response into the template region */
-		brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
-					    (len + 3) & ~3, prb_resp);
+	/* write the probe response into the template region */
+	brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
+				    (len + 3) & ~3, prb_resp);
 
-		/* write the length of the probe response frame (+PLCP/-FCS) */
-		brcms_c_write_shm(wlc, M_PRB_RESP_FRM_LEN, (u16) len);
+	/* write the length of the probe response frame (+PLCP/-FCS) */
+	brcms_c_write_shm(wlc, M_PRB_RESP_FRM_LEN, (u16) len);
 
-		/* write the SSID and SSID length */
-		brcms_c_shm_ssid_upd(wlc, cfg);
+	/* write the SSID and SSID length */
+	brcms_c_shm_ssid_upd(wlc, cfg);
 
-		/*
-		 * Write PLCP headers and durations for probe response frames
-		 * at all rates. Use the actual frame length covered by the
-		 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
-		 * by subtracting the PLCP len and adding the FCS.
-		 */
-		len += (-D11_PHY_HDR_LEN + FCS_LEN);
-		brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
+	/*
+	 * Write PLCP headers and durations for probe response frames
+	 * at all rates. Use the actual frame length covered by the
+	 * PLCP header for the call to brcms_c_mod_prb_rsp_rate_table()
+	 * by subtracting the PLCP len and adding the FCS.
+	 */
+	len += (-D11_PHY_HDR_LEN + FCS_LEN);
+	brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
 
-		if (suspend)
-			brcms_c_enable_mac(wlc);
-	} else {
-		/* Generating probe resp in sw; update local template */
-		/* error: No software probe response support without MBSS */
-	}
+	if (suspend)
+		brcms_c_enable_mac(wlc);
 }
 
 /* prepares pdu for transmission. returns BCM error codes */
@@ -9215,7 +9286,7 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	*fifop = fifo;
 
 	/* return if insufficient dma resources */
-	if (TXAVAIL(wlc, fifo) < MAX_DMA_SEGS) {
+	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
 		BRCMS_TX_FIFO_CLEAR(wlc, fifo);
 		return -EBUSY;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index d151a5c..e8a854b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -24,27 +24,16 @@
 #include "d11.h"
 
 #define MA_WINDOW_SZ		8	/* moving average window size */
-#define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 #define	INVCHANNEL		255	/* invalid channel */
-/* max # supported core revisions (0 .. MAXCOREREV - 1) */
-#define	MAXCOREREV		28
+
 /* max # brcms_c_module_register() calls */
 #define BRCMS_MAXMODULES	22
 
 #define SEQNUM_SHIFT		4
-#define AMPDU_DELIMITER_LEN	4
 #define SEQNUM_MAX		0x1000
 
-#define	APHY_CWMIN		15
-#define PHY_CWMAX		1023
-
-#define EDCF_AIFSN_MIN               1
-#define FRAGNUM_MASK		0xF
-
 #define NTXRATE			64	/* # tx MPDUs rate is reported for */
 
-#define BRCMS_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
-
 /* Maximum wait time for a MAC suspend */
 /* uS: 83mS is max packet time (64KB ampdu @ 6Mbps) */
 #define	BRCMS_MAX_MAC_SUSPEND	83000
@@ -77,13 +66,14 @@
 
 #define	SW_TIMER_MAC_STAT_UPD		30	/* periodic MAC stats update */
 
+/* max # supported core revisions (0 .. MAXCOREREV - 1) */
+#define	MAXCOREREV		28
+
 /* Double check that unsupported cores are not enabled */
 #if CONF_MSK(D11CONF, 0x4f) || CONF_GE(D11CONF, MAXCOREREV)
 #error "Configuration for D11CONF includes unsupported versions."
 #endif				/* Bad versions */
 
-#define	VALID_COREREV(corerev)	CONF_HAS(D11CONF, corerev)
-
 /* values for shortslot_override */
 #define BRCMS_SHORTSLOT_AUTO	-1 /* Driver will manage Shortslot setting */
 #define BRCMS_SHORTSLOT_OFF	0  /* Turn off short slot */
@@ -97,17 +87,6 @@
 #define BRCMS_IS_MIMO_PREAMBLE(_pre) (((_pre) == BRCMS_GF_PREAMBLE) || \
 				      ((_pre) == BRCMS_MM_PREAMBLE))
 
-/* values for barker_preamble */
-#define BRCMS_BARKER_SHORT_ALLOWED	0	/* Short pre-amble allowed */
-
-/* A fifo is full. Clear precedences related to that FIFO */
-#define BRCMS_TX_FIFO_CLEAR(wlc, fifo) \
-			((wlc)->tx_prec_map &= ~(wlc)->fifo2prec_map[fifo])
-
-/* Fifo is NOT full. Enable precedences for that FIFO */
-#define BRCMS_TX_FIFO_ENAB(wlc, fifo) \
-			((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
-
 /* TxFrameID */
 /* seq and frag bits: SEQNUM_SHIFT, FRAGNUM_MASK (802.11.h) */
 /* rate epoch bits: TXFID_RATE_SHIFT, TXFID_RATE_MASK ((wlc_rate.c) */
@@ -122,20 +101,6 @@
 #define BOARDREV_PROMOTABLE	0xFF	/* from */
 #define BOARDREV_PROMOTED	1	/* to */
 
-/*
- * if wpa is in use then portopen is true when the
- * group key is plumbed otherwise it is always true
- */
-#define WSEC_ENABLED(wsec) ((wsec) & (WEP_ENABLED | TKIP_ENABLED | AES_ENABLED))
-#define BRCMS_SW_KEYS(wlc, bsscfg) ((((wlc)->wsec_swkeys) || \
-	((bsscfg)->wsec & WSEC_SWFLAG)))
-
-#define BRCMS_PORTOPEN(cfg) \
-	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
-	(cfg)->wsec_portopen : true)
-
-#define PS_ALLOWED(wlc)	brcms_c_ps_allowed(wlc)
-
 #define DATA_BLOCK_TX_SUPR	(1 << 4)
 
 /* 802.1D Priority to TX FIFO number for wme */
@@ -161,48 +126,14 @@ extern const u8 prio2fifo[];
 			 MI_PHYTXERR | MI_DMAINT | MI_TFS | MI_BG_NOISE | \
 			 MI_CCA | MI_TO | MI_GP0 | MI_RFDISABLE | MI_PWRUP)
 
-#define	RETRY_SHORT_DEF			7	/* Default Short retry Limit */
-#define	RETRY_SHORT_MAX			255	/* Maximum Short retry Limit */
-#define	RETRY_LONG_DEF			4	/* Default Long retry count */
-#define	RETRY_SHORT_FB			3 /* Short count for fallback rate */
-#define	RETRY_LONG_FB			2 /* Long count for fallback rate */
-
 #define	MAXTXPKTS		6	/* max # pkts pending */
 
 /* frameburst */
 #define	MAXTXFRAMEBURST		8 /* vanilla xpress mode: max frames/burst */
 #define	MAXFRAMEBURST_TXOP	10000	/* Frameburst TXOP in usec */
 
-/* Per-AC retry limit register definitions; uses defs.h bitfield macros */
-#define EDCF_SHORT_S            0
-#define EDCF_SFB_S              4
-#define EDCF_LONG_S             8
-#define EDCF_LFB_S              12
-#define EDCF_SHORT_M            BITFIELD_MASK(4)
-#define EDCF_SFB_M              BITFIELD_MASK(4)
-#define EDCF_LONG_M             BITFIELD_MASK(4)
-#define EDCF_LFB_M              BITFIELD_MASK(4)
-
 #define	NFIFO			6	/* # tx/rx fifopairs */
 
-#define BRCMS_WME_RETRY_SHORT_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
-#define BRCMS_WME_RETRY_SFB_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_SFB)
-#define BRCMS_WME_RETRY_LONG_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_LONG)
-#define BRCMS_WME_RETRY_LFB_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_LFB)
-
-#define BRCMS_WME_RETRY_SHORT_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SHORT, val))
-#define BRCMS_WME_RETRY_SFB_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SFB, val))
-#define BRCMS_WME_RETRY_LONG_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LONG, val))
-#define BRCMS_WME_RETRY_LFB_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LFB, val))
-
 /* PLL requests */
 
 /* pll is shared on old chips */
@@ -212,43 +143,11 @@ extern const u8 prio2fifo[];
 /* hold/release pll for some short operation */
 #define BRCMS_PLLREQ_FLIP		0x4
 
-/*
- * Macros to check if AP or STA is active.
- * AP Active means more than just configured: driver and BSS are "up";
- * that is, we are beaconing/responding as an AP (aps_associated).
- * STA Active similarly means the driver is up and a configured STA BSS
- * is up: either associated (stas_associated) or trying.
- *
- * Macro definitions vary as per AP/STA ifdefs, allowing references to
- * ifdef'd structure fields and constant values (0) for optimization.
- * Make sure to enclose blocks of code such that any routines they
- * reference can also be unused and optimized out by the linker.
- */
-/* NOTE: References structure fields defined in wlc.h */
-#define AP_ACTIVE(wlc)	(0)
-
-/*
- * Detect Card removed.
- * Even checking an sbconfig register read will not false trigger when the core
- * is in reset it breaks CF address mechanism. Accessing gphy phyversion will
- * cause SB error if aphy is in reset on 4306B0-DB. Need a simple accessible
- * reg with fixed 0/1 pattern (some platforms return all 0).
- * If clocks are present, call the sb routine which will figure out if the
- * device is removed.
- */
-#define DEVICEREMOVED(wlc)      \
-	((wlc->hw->clk) ?   \
-	((R_REG(&wlc->hw->regs->maccontrol) & \
-	(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN) : \
-	(ai_deviceremoved(wlc->hw->sih)))
-
-#define BRCMS_UNIT(wlc)		((wlc)->pub->unit)
-
-#define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
-	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+#define	CHANNEL_BANDUNIT(wlc, ch) \
+	(((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
 
-#define brcms_b_copyto_shm(wlc_hw, offset, buf, len)                   \
-	brcms_b_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+#define	OTHERBANDUNIT(wlc) \
+	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
 
 /*
  * 802.11 protection information
@@ -337,21 +236,6 @@ struct brcms_stf {
 				   >> RXS_CHAN_PHYTYPE_SHIFT)
 #define BRCMS_CHAN_CHANNEL(x)     (((x) & RXS_CHAN_ID_MASK) \
 				   >> RXS_CHAN_ID_SHIFT)
-#define BRCMS_RX_CHANNEL(rxh)	(BRCMS_CHAN_CHANNEL((rxh)->RxChan))
-
-/* brcms_bss_info flag bit values */
-#define BRCMS_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
-
-/* Flags used in brcms_c_txq_info.stopped */
-/* per prio flow control bits */
-#define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF
-/* stop txq enqueue for packet drain */
-#define TXQ_STOP_FOR_PKT_DRAIN		0x00000100
-/* stop txq enqueue for ampdu flow control */
-#define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200
-
-#define BRCMS_HT_WEP_RESTRICT	0x01	/* restrict HT with WEP */
-#define BRCMS_HT_TKIP_RESTRICT	0x02	/* restrict HT with TKIP */
 
 /* Maximum # of keys that wl driver supports in S/W.
  * Keys supported in H/W is less than or equal to WSEC_MAX_KEYS.
@@ -365,10 +249,6 @@ struct brcms_stf {
 *     s/w keys if WSEC_SW(wlc->wsec).
 *     h/w keys otherwise.
 */
-#define BRCMS_MAX_WSEC_KEYS(wlc) WSEC_MAX_KEYS
-
-/* number of 802.11 default (non-paired, group keys) */
-#define WSEC_MAX_DEFAULT_KEYS	4	/* # of default keys */
 
 struct wsec_iv {
 	u32 hi;		/* upper 32 bits of IV */
@@ -526,9 +406,6 @@ struct brcms_c_if {
 	} u;
 };
 
-/* flags for the interface, this interface is linked to a brcms_if */
-#define BRCMS_IF_LINKED		0x02
-
 struct brcms_hw_band {
 	int bandtype;		/* BRCM_BAND_2G, BRCM_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
@@ -1038,31 +915,6 @@ struct brcms_bss_cfg {
 	u32 txrspec[NTXRATE][2];
 };
 
-#define	CHANNEL_BANDUNIT(wlc, ch) \
-	(((ch) <= CH_MAX_2G_CHANNEL) ? BAND_2G_INDEX : BAND_5G_INDEX)
-#define	OTHERBANDUNIT(wlc) \
-	((uint)((wlc)->band->bandunit ? BAND_2G_INDEX : BAND_5G_INDEX))
-
-#define IS_MBAND_UNLOCKED(wlc) \
-	((wlc->pub->_nbands > 1) && !(wlc)->bandlocked)
-
-#define BRCMS_BAND_PI_RADIO_CHANSPEC wlc_phy_chanspec_get(wlc->band->pi)
-
-/* sum the individual fifo tx pending packet counts */
-#define	TXPKTPENDTOT(wlc) \
-	((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
-	 (wlc)->core->txpktpend[2] + (wlc)->core->txpktpend[3])
-#define TXPKTPENDGET(wlc, fifo) ((wlc)->core->txpktpend[(fifo)])
-#define TXPKTPENDINC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] += (val))
-#define TXPKTPENDDEC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] -= (val))
-#define TXPKTPENDCLR(wlc, fifo)	((wlc)->core->txpktpend[(fifo)] = 0)
-#define TXAVAIL(wlc, fifo) (*(wlc)->core->txavail[(fifo)])
-#define GETNEXTTXP(wlc, _queue) \
-		dma_getnexttxp((wlc)->hw->di[(_queue)], DMA_RANGE_TRANSMITTED)
-
-#define BRCMS_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
-	((len1 == len2) && !memcmp(ssid1, ssid2, len1))
-
 extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
 extern void brcms_b_rpc_watchdog(struct brcms_c_info *wlc);
 extern void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p);
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 62f3efe..0a101a4 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -30,6 +30,8 @@
 #define BRCMS_STF_SS_STBC_RX(wlc) (BRCMS_ISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
+#define BRCMS_BITSCNT(x)	brcmu_bitcount((u8 *)&(x), sizeof(u8))
+
 #define NSTS_1	1
 #define NSTS_2	2
 #define NSTS_3	3
-- 
1.7.4.1


