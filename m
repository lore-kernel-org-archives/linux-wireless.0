Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3690 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab1ILKPT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 06:15:19 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 02/20] staging: brcm80211: cleaned up softmac types.h
 macro's
Date: Mon, 12 Sep 2011 12:14:46 +0200
Message-ID: <1315822504-24210-3-git-send-email-rvossen@broadcom.com> (sfid-20110912_121525_816966_EF87CF9A)
In-Reply-To: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
References: <1315822504-24210-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/removed macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |   30 ++++++++++++++++++
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    2 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |   18 +++++-----
 drivers/staging/brcm80211/brcmsmac/main.c        |   31 ++++++++++---------
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   10 +++---
 drivers/staging/brcm80211/brcmsmac/rate.c        |    5 ++-
 drivers/staging/brcm80211/brcmsmac/types.h       |   35 ----------------------
 7 files changed, 64 insertions(+), 67 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 52ca7e3..7a499ba 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,6 +20,36 @@
 #include "main.h"
 #include "alloc.h"
 
+/* Max # of entries in Tx FIFO based on 4kb page size */
+#define NTXD		256
+/* Max # of entries in Rx FIFO based on 4kb page size */
+#define NRXD		256
+/* try to keep this # rbufs posted to the chip */
+#define	NRXBUFPOST	32
+/* Maximum SCBs in cache for STA */
+#define MAXSCB		32
+
+/* Count of packet callback structures. either of following
+ * 1. Set to the number of SCBs since a STA
+ * can queue up a rate callback for each IBSS STA it knows about, and an AP can
+ * queue up an "are you there?" Null Data callback for each associated STA
+ * 2. controlled by tunable config file
+ */
+#define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
+
+/* Number of BSS handled in ucode bcn/prb */
+#define BRCMS_MAX_UCODE_BSS	(16)
+/* Number of BSS handled in sw bcn/prb */
+#define BRCMS_MAX_UCODE_BSS4	(4)
+
+/* data msg txq hiwat mark */
+#define BRCMS_DATAHIWAT		50
+#define BRCMS_AMPDUDATAHIWAT 255
+
+/* bounded rx loops */
+#define RXBND		8 /* max # frames to process in brcms_c_recv() */
+#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
+
 static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 7c44598..9c1ae7c 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -990,7 +990,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				  "error (0x%x)\n", wlc->pub->unit,
 				  txs->phyerr);
 
-			if (WL_ERROR_ON()) {
+			if (brcm_msg_level & LOG_ERROR_VAL) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
 				brcms_c_print_txdesc((struct d11txh *) p->data);
 			}
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 282adce..27c62c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -911,7 +911,7 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	 * Now that the country abbreviation is set, if the radio supports 2G,
 	 * then set channel 14 restrictions based on the new locale.
 	 */
-	if (wlc->pub->_nbands > 1 || BAND_2G(wlc->band->bandtype))
+	if (wlc->pub->_nbands > 1 || wlc->band->bandtype == BRCM_BAND_2G)
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
 						     brcms_c_japan(wlc) ? true :
 						     false);
@@ -939,11 +939,11 @@ brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
 	for (i = 0; i < wlc->pub->_nbands;
 	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
 
-		li = BAND_5G(band->bandtype) ?
+		li = (band->bandtype == BRCM_BAND_5G) ?
 		    brcms_c_get_locale_5g(country->locale_5G) :
 		    brcms_c_get_locale_2g(country->locale_2G);
 		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
-		li_mimo = BAND_5G(band->bandtype) ?
+		li_mimo = (band->bandtype == BRCM_BAND_5G) ?
 		    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 		    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
@@ -1311,11 +1311,11 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 
 	chan = CHSPEC_CHANNEL(chanspec);
 	band = wlc->bandstate[CHSPEC_BANDUNIT(chanspec)];
-	li = BAND_5G(band->bandtype) ?
+	li = (band->bandtype == BRCM_BAND_5G) ?
 	    brcms_c_get_locale_5g(country->locale_5G) :
 	    brcms_c_get_locale_2g(country->locale_2G);
 
-	li_mimo = BAND_5G(band->bandtype) ?
+	li_mimo = (band->bandtype == BRCM_BAND_5G) ?
 	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
 	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
@@ -1333,7 +1333,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	}
 
 	/* CCK txpwr limits for 2.4G band */
-	if (BAND_2G(band->bandtype)) {
+	if (band->bandtype == BRCM_BAND_2G) {
 		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_CCK(chan)];
 
 		maxpwr = maxpwr - delta;
@@ -1345,7 +1345,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	}
 
 	/* OFDM txpwr limits for 2.4G or 5G bands */
-	if (BAND_2G(band->bandtype))
+	if (band->bandtype == BRCM_BAND_2G)
 		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_OFDM(chan)];
 	else
 		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_5G(chan)];
@@ -1355,7 +1355,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	maxpwr = min(maxpwr, conducted_ofdm_max);
 
 	/* Keep OFDM lmit below CCK limit */
-	if (BAND_2G(band->bandtype))
+	if (band->bandtype == BRCM_BAND_2G)
 		maxpwr = min_t(int, maxpwr, txpwr->cck[0]);
 
 	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
@@ -1385,7 +1385,7 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			delta = band->antgain - QDB(6);	/* Excess over 6 dB */
 	}
 
-	if (BAND_2G(band->bandtype))
+	if (band->bandtype == BRCM_BAND_2G)
 		maxpwr_idx = (chan - 1);
 	else
 		maxpwr_idx = CHANNEL_POWER_IDX_5G(chan);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 6d2fc103..7cd3b9e 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -329,6 +329,8 @@
 #define NRATE_STF_STBC	2	/* stf mode STBC */
 #define NRATE_STF_SDM	3	/* stf mode SDM */
 
+#define MAX_DMA_SEGS 4
+
 /*
  * 32 SSID chars, max of 4 chars for each SSID char "\xFF", plus NULL.
  */
@@ -1585,9 +1587,8 @@ static void brcms_b_bsinit(struct brcms_c_info *wlc, u16 chanspec)
 	brcms_b_set_cwmax(wlc_hw, wlc_hw->band->CWmax);
 
 	brcms_b_update_slot_timing(wlc_hw,
-				    BAND_5G(wlc_hw->band->
-					    bandtype) ? true : wlc_hw->
-				    shortslot);
+				   wlc_hw->band->bandtype == BRCM_BAND_5G ?
+				   true : wlc_hw->shortslot);
 
 	/* write phytype and phyvers */
 	brcms_b_write_shm(wlc_hw, M_PHYTYPE, (u16) wlc_hw->band->phytype);
@@ -3738,7 +3739,7 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
-	if (BAND_2G(brcms_b_bandtype(wlc_hw)) && wlc_hw->up) {
+	if (brcms_b_bandtype(wlc_hw) == BRCM_BAND_2G && wlc_hw->up) {
 		brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 		brcms_b_update_slot_timing(wlc_hw, shortslot);
 		brcms_c_enable_mac(wlc_hw->wlc);
@@ -4929,10 +4930,10 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 	bandtype = wlc->band->bandtype;
 
 	/* get antennas available */
-	aa = (s8) getintvar(vars, (BAND_5G(bandtype) ? "aa5g" : "aa2g"));
+	aa = (s8) getintvar(vars, bandtype == BRCM_BAND_5G ? "aa5g" : "aa2g");
 	if (aa == 0)
 		aa = (s8) getintvar(vars,
-				      (BAND_5G(bandtype) ? "aa1" : "aa0"));
+				    bandtype == BRCM_BAND_5G ? "aa1" : "aa0");
 	if ((aa < 1) || (aa > 15)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
 			  " srom (0x%x), using 3\n", unit, __func__, aa);
@@ -4951,7 +4952,7 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 
 	/* Compute Antenna Gain */
 	wlc->band->antgain =
-	    (s8) getintvar(vars, (BAND_5G(bandtype) ? "ag1" : "ag0"));
+	    (s8) getintvar(vars, bandtype == BRCM_BAND_5G ? "ag1" : "ag0");
 	brcms_c_attach_antgain_init(wlc);
 
 	return true;
@@ -5169,7 +5170,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		wlc->band->CWmax = PHY_CWMAX;
 
 		/* init gmode value */
-		if (BAND_2G(wlc->band->bandtype)) {
+		if (wlc->band->bandtype == BRCM_BAND_2G) {
 			wlc->band->gmode = GMODE_AUTO;
 			brcms_c_protection_upd(wlc, BRCMS_PROT_G_USER,
 					   wlc->band->gmode);
@@ -6382,7 +6383,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		/* shortslot is an 11g feature, so no more work if we are
 		 * currently on the 5G band
 		 */
-		if (BAND_5G(wlc->band->bandtype))
+		if (wlc->band->bandtype == BRCM_BAND_5G)
 			break;
 
 		if (wlc->pub->up && wlc->pub->associated) {
@@ -6965,7 +6966,7 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
 		dur -= PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		/* payload calculation matches that of regular ofdm */
-		if (BAND_2G(wlc->band->bandtype))
+		if (wlc->band->bandtype == BRCM_BAND_2G)
 			dur -= DOT11_OFDM_SIGNAL_EXTENSION;
 		/* kNdbps = kbps * 4 */
 		kNdps =
@@ -7466,7 +7467,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (!is_multicast_ether_addr(h->addr1))
 		mcl |= TXC_IMMEDACK;
 
-	if (BAND_5G(wlc->band->bandtype))
+	if (wlc->band->bandtype == BRCM_BAND_5G)
 		mcl |= TXC_FREQBAND_5G;
 
 	if (CHSPEC_IS40(wlc_phy_chanspec_get(wlc->band->pi)))
@@ -8243,7 +8244,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
-		if (WL_ERROR_ON()) {
+		if (brcm_msg_level & LOG_ERROR_VAL) {
 			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
 			brcms_c_print_txdesc(txh);
@@ -8772,7 +8773,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 				  APHY_TAIL_NBITS) * 1000, 2 * kNdps);
 
 		dur += APHY_SYMBOL_TIME * nsyms;
-		if (BAND_2G(wlc->band->bandtype))
+		if (wlc->band->bandtype == BRCM_BAND_2G)
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
 	} else if (IS_OFDM(rate)) {
 		dur = APHY_PREAMBLE_TIME;
@@ -8784,7 +8785,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		    CEIL((APHY_SERVICE_NBITS + 8 * mac_len + APHY_TAIL_NBITS),
 			 Ndps);
 		dur += APHY_SYMBOL_TIME * nsyms;
-		if (BAND_2G(wlc->band->bandtype))
+		if (wlc->band->bandtype == BRCM_BAND_2G)
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
 	} else {
 		/*
@@ -8937,7 +8938,7 @@ brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 	const struct brcms_c_rateset *rs_dflt;
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
-		if (BAND_5G(wlc->band->bandtype))
+		if (wlc->band->bandtype == BRCM_BAND_5G)
 			rs_dflt = &ofdm_mimo_rates;
 		else
 			rs_dflt = &cck_ofdm_mimo_rates;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 5f30de2..a159961 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -512,7 +512,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	else
 		sflags = ai_core_sflags(sh->sih, 0, 0);
 
-	if (BAND_5G(bandtype)) {
+	if (bandtype == BRCM_BAND_5G) {
 		if ((sflags & (SISF_5G_PHY | SISF_DB_PHY)) == 0)
 			return NULL;
 	}
@@ -541,7 +541,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 
 	pi->phycal_tempdelta = 0;
 
-	if (BAND_2G(bandtype) && (sflags & SISF_2G_PHY))
+	if (bandtype == BRCM_BAND_2G && (sflags & SISF_2G_PHY))
 		pi->pubpi.coreflags = SICF_GMODE;
 
 	wlapi_bmac_corereset(pi->sh->physhim, pi->pubpi.coreflags);
@@ -561,7 +561,7 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	    !pi->pubpi.phy_type == PHY_TYPE_LCN)
 		goto err;
 
-	if (BAND_5G(bandtype)) {
+	if (bandtype == BRCM_BAND_5G) {
 		if (!ISNPHY(pi))
 			goto err;
 	} else if (!ISNPHY(pi) && !ISLCNPHY(pi)) {
@@ -585,8 +585,8 @@ wlc_phy_attach(struct shared_phy *sh, struct d11regs *regs, int bandtype,
 	wlc_set_phy_uninitted(pi);
 
 	pi->bw = WL_CHANSPEC_BW_20;
-	pi->radio_chanspec =
-		BAND_2G(bandtype) ? CH20MHZ_CHSPEC(1) : CH20MHZ_CHSPEC(36);
+	pi->radio_chanspec = (bandtype == BRCM_BAND_2G) ?
+			     CH20MHZ_CHSPEC(1) : CH20MHZ_CHSPEC(36);
 
 	pi->rxiq_samps = PHY_NOISE_SAMPLE_LOG_NUM_NPHY;
 	pi->rxiq_antsel = ANT_RX_DIV_DEF;
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 9730139..1241dc9 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -447,7 +447,7 @@ brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_N)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_LCN)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_SSN))) {
-		if (BAND_5G(bandtype))
+		if (bandtype == BRCM_BAND_5G)
 			rs_dflt = (bw == BRCMS_20_MHZ ?
 				   &ofdm_mimo_rates : &ofdm_40bw_mimo_rates);
 		else
@@ -455,7 +455,8 @@ brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
 				   &cck_ofdm_mimo_rates :
 				   &cck_ofdm_40bw_mimo_rates);
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_LP)) {
-		rs_dflt = (BAND_5G(bandtype)) ? &ofdm_rates : &cck_ofdm_rates;
+		rs_dflt = (bandtype == BRCM_BAND_5G) ?
+			  &ofdm_rates : &cck_ofdm_rates;
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_A)) {
 		rs_dflt = &ofdm_rates;
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_G)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 792df07..f9794dc 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -25,8 +25,6 @@
 #define WL_CHAN_FREQ_RANGE_5GM     2
 #define WL_CHAN_FREQ_RANGE_5GH     3
 
-#define MAX_DMA_SEGS 4
-
 /* boardflags */
 
 /* Board has gpio 9 controlling the PA */
@@ -257,46 +255,15 @@
  * ***********************************************
  */
 
-/* Max # of entries in Tx FIFO based on 4kb page size */
-#define NTXD		256
-/* Max # of entries in Rx FIFO based on 4kb page size */
-#define NRXD		256
-/* try to keep this # rbufs posted to the chip */
-#define	NRXBUFPOST	32
-/* Maximum SCBs in cache for STA */
-#define MAXSCB		32
-
 /* max allowed number of mpdus in an ampdu (2 streams) */
 #define AMPDU_NUM_MPDU		16
 
-/* Count of packet callback structures. either of following
- * 1. Set to the number of SCBs since a STA
- * can queue up a rate callback for each IBSS STA it knows about, and an AP can
- * queue up an "are you there?" Null Data callback for each associated STA
- * 2. controlled by tunable config file
- */
-#define MAXPKTCB	MAXSCB	/* Max number of packet callbacks */
-
 /* NetBSD also needs to keep track of this */
 
-/* Number of BSS handled in ucode bcn/prb */
-#define BRCMS_MAX_UCODE_BSS	(16)
-/* Number of BSS handled in sw bcn/prb */
-#define BRCMS_MAX_UCODE_BSS4	(4)
 /* max # BSS configs */
 #define BRCMS_MAXBSSCFG		(1)
 /* max # available networks */
 #define MAXBSS		64
-/* data msg txq hiwat mark */
-#define BRCMS_DATAHIWAT		50
-#define BRCMS_AMPDUDATAHIWAT 255
-
-/* bounded rx loops */
-#define RXBND		8 /* max # frames to process in brcms_c_recv() */
-#define TXSBND		8 /* max # tx status to process in wlc_txstatus() */
-
-#define BAND_5G(bt)	((bt) == BRCM_BAND_5G)
-#define BAND_2G(bt)	((bt) == BRCM_BAND_2G)
 
 #define BCMMSG(dev, fmt, args...)		\
 do {						\
@@ -304,8 +271,6 @@ do {						\
 		wiphy_err(dev, "%s: " fmt, __func__, ##args);	\
 } while (0)
 
-#define WL_ERROR_ON()		(brcm_msg_level & LOG_ERROR_VAL)
-
 /*
  * Register access macros.
  *
-- 
1.7.4.1


