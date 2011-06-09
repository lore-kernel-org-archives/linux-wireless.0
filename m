Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2259 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753067Ab1FIOp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 14/21] staging: brcm80211: replaced wlc_ by brcms_c_
Date: Thu, 9 Jun 2011 16:44:54 +0200
Message-ID: <1307630701-9170-15-git-send-email-rvossen@broadcom.com> (sfid-20110609_164545_160422_CCC0F566)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |   51 +-
 drivers/staging/brcm80211/brcmsmac/alloc.h       |    4 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   88 ++--
 drivers/staging/brcm80211/brcmsmac/ampdu.h       |    6 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c      |    8 +-
 drivers/staging/brcm80211/brcmsmac/antsel.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c        |  448 ++++++------
 drivers/staging/brcm80211/brcmsmac/bmac.h        |  106 ++--
 drivers/staging/brcm80211/brcmsmac/channel.c     |   46 +-
 drivers/staging/brcm80211/brcmsmac/channel.h     |    4 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |  101 ++--
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  874 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h        |  304 ++++----
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    4 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |  124 ++--
 drivers/staging/brcm80211/brcmsmac/stf.c         |   56 +-
 drivers/staging/brcm80211/brcmsmac/stf.h         |   27 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |   16 +-
 21 files changed, 1172 insertions(+), 1109 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 486cd49..b66418e 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,8 +20,8 @@
 #include "main.h"
 #include "alloc.h"
 
-static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit);
-static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg);
+static struct brcms_c_bsscfg *wlc_bsscfg_malloc(uint unit);
+static void wlc_bsscfg_mfree(struct brcms_c_bsscfg *cfg);
 static struct wlc_pub *wlc_pub_malloc(uint unit,
 				      uint *err, uint devid);
 static void wlc_pub_mfree(struct wlc_pub *pub);
@@ -87,11 +87,11 @@ static void wlc_pub_mfree(struct wlc_pub *pub)
 	kfree(pub);
 }
 
-static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit)
+static struct brcms_c_bsscfg *wlc_bsscfg_malloc(uint unit)
 {
-	struct wlc_bsscfg *cfg;
+	struct brcms_c_bsscfg *cfg;
 
-	cfg = kzalloc(sizeof(struct wlc_bsscfg), GFP_ATOMIC);
+	cfg = kzalloc(sizeof(struct brcms_c_bsscfg), GFP_ATOMIC);
 	if (cfg == NULL)
 		goto fail;
 
@@ -106,7 +106,7 @@ static struct wlc_bsscfg *wlc_bsscfg_malloc(uint unit)
 	return NULL;
 }
 
-static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg)
+static void wlc_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
 {
 	if (cfg == NULL)
 		return;
@@ -116,8 +116,8 @@ static void wlc_bsscfg_mfree(struct wlc_bsscfg *cfg)
 	kfree(cfg);
 }
 
-static void wlc_bsscfg_ID_assign(struct wlc_info *wlc,
-				 struct wlc_bsscfg *bsscfg)
+static void wlc_bsscfg_ID_assign(struct brcms_c_info *wlc,
+				 struct brcms_c_bsscfg *bsscfg)
 {
 	bsscfg->ID = wlc->next_bsscfg_ID;
 	wlc->next_bsscfg_ID++;
@@ -126,17 +126,17 @@ static void wlc_bsscfg_ID_assign(struct wlc_info *wlc,
 /*
  * The common driver entry routine. Error codes should be unique
  */
-struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
+struct brcms_c_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 {
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 
-	wlc = kzalloc(sizeof(struct wlc_info), GFP_ATOMIC);
+	wlc = kzalloc(sizeof(struct brcms_c_info), GFP_ATOMIC);
 	if (wlc == NULL) {
 		*err = 1002;
 		goto fail;
 	}
 
-	/* allocate struct wlc_pub state structure */
+	/* allocate struct brcms_c_pub state structure */
 	wlc->pub = wlc_pub_malloc(unit, err, devid);
 	if (wlc->pub == NULL) {
 		*err = 1003;
@@ -144,9 +144,9 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	}
 	wlc->pub->wlc = wlc;
 
-	/* allocate struct wlc_hw_info state structure */
+	/* allocate struct brcms_c_hw_info state structure */
 
-	wlc->hw = kzalloc(sizeof(struct wlc_hw_info), GFP_ATOMIC);
+	wlc->hw = kzalloc(sizeof(struct brcms_c_hw_info), GFP_ATOMIC);
 	if (wlc->hw == NULL) {
 		*err = 1005;
 		goto fail;
@@ -154,7 +154,7 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	wlc->hw->wlc = wlc;
 
 	wlc->hw->bandstate[0] =
-		kzalloc(sizeof(struct wlc_hwband) * MAXBANDS, GFP_ATOMIC);
+		kzalloc(sizeof(struct brcms_c_hwband) * MAXBANDS, GFP_ATOMIC);
 	if (wlc->hw->bandstate[0] == NULL) {
 		*err = 1006;
 		goto fail;
@@ -162,9 +162,9 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		int i;
 
 		for (i = 1; i < MAXBANDS; i++) {
-			wlc->hw->bandstate[i] = (struct wlc_hwband *)
+			wlc->hw->bandstate[i] = (struct brcms_c_hwband *)
 			    ((unsigned long)wlc->hw->bandstate[0] +
-			     (sizeof(struct wlc_hwband) * i));
+			     (sizeof(struct brcms_c_hwband) * i));
 		}
 	}
 
@@ -202,20 +202,21 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		}
 	}
 
-	wlc->protection = kzalloc(sizeof(struct wlc_protection), GFP_ATOMIC);
+	wlc->protection = kzalloc(sizeof(struct brcms_c_protection),
+				  GFP_ATOMIC);
 	if (wlc->protection == NULL) {
 		*err = 1016;
 		goto fail;
 	}
 
-	wlc->stf = kzalloc(sizeof(struct wlc_stf), GFP_ATOMIC);
+	wlc->stf = kzalloc(sizeof(struct brcms_c_stf), GFP_ATOMIC);
 	if (wlc->stf == NULL) {
 		*err = 1017;
 		goto fail;
 	}
 
 	wlc->bandstate[0] =
-		kzalloc(sizeof(struct wlcband)*MAXBANDS, GFP_ATOMIC);
+		kzalloc(sizeof(struct brcms_c_band)*MAXBANDS, GFP_ATOMIC);
 	if (wlc->bandstate[0] == NULL) {
 		*err = 1025;
 		goto fail;
@@ -223,13 +224,13 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 		int i;
 
 		for (i = 1; i < MAXBANDS; i++) {
-			wlc->bandstate[i] =
-			    (struct wlcband *) ((unsigned long)wlc->bandstate[0]
-			    + (sizeof(struct wlcband)*i));
+			wlc->bandstate[i] = (struct brcms_c_band *)
+				((unsigned long)wlc->bandstate[0]
+				+ (sizeof(struct brcms_c_band)*i));
 		}
 	}
 
-	wlc->corestate = kzalloc(sizeof(struct wlccore), GFP_ATOMIC);
+	wlc->corestate = kzalloc(sizeof(struct brcms_c_core), GFP_ATOMIC);
 	if (wlc->corestate == NULL) {
 		*err = 1026;
 		goto fail;
@@ -249,7 +250,7 @@ struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	return NULL;
 }
 
-void wlc_detach_mfree(struct wlc_info *wlc)
+void wlc_detach_mfree(struct brcms_c_info *wlc)
 {
 	if (wlc == NULL)
 		return;
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.h b/drivers/staging/brcm80211/brcmsmac/alloc.h
index 95f951e..b8dc287 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.h
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.h
@@ -14,5 +14,5 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-extern struct wlc_info *wlc_attach_malloc(uint unit, uint *err, uint devid);
-extern void wlc_detach_mfree(struct wlc_info *wlc);
+extern struct brcms_c_info *wlc_attach_malloc(uint unit, uint *err, uint devid);
+extern void wlc_detach_mfree(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 17552f2..0795679 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -72,7 +72,7 @@ typedef struct wlc_fifo_info {
 
 /* AMPDU module specific state */
 struct ampdu_info {
-	struct wlc_info *wlc;	/* pointer to main wlc structure */
+	struct brcms_c_info *wlc;	/* pointer to main wlc structure */
 	int scb_handle;		/* scb cubby handle to retrieve data from scb */
 	u8 ini_enable[AMPDU_MAX_SCB_TID];	/* per-tid initiator enable/disable of ampdu */
 	u8 ba_tx_wsize;	/* Tx ba window size (in pdu) */
@@ -111,7 +111,7 @@ struct cb_del_ampdu_pars {
 #define SCB_AMPDU_INI(scb_ampdu, tid) (&(scb_ampdu->ini[tid]))
 
 static void wlc_ffpld_init(struct ampdu_info *ampdu);
-static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int f);
+static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int f);
 static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
 
 static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
@@ -130,7 +130,7 @@ static void wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
 static bool wlc_ampdu_cap(struct ampdu_info *ampdu);
 static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on);
 
-struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc)
+struct ampdu_info *wlc_ampdu_attach(struct brcms_c_info *wlc)
 {
 	struct ampdu_info *ampdu;
 	int i;
@@ -197,7 +197,7 @@ void wlc_ampdu_detach(struct ampdu_info *ampdu)
 		kfree(ampdu->ini_free[i]);
 	}
 
-	wlc_module_unregister(ampdu->wlc->pub, "ampdu", ampdu);
+	brcms_c_module_unregister(ampdu->wlc->pub, "ampdu", ampdu);
 	kfree(ampdu);
 }
 
@@ -258,7 +258,7 @@ static void wlc_ffpld_init(struct ampdu_info *ampdu)
  * Return 1 if pre-loading not active, -1 if not an underflow event,
  * 0 if pre-loading module took care of the event.
  */
-static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
+static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 {
 	struct ampdu_info *ampdu = wlc->ampdu;
 	u32 phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
@@ -273,7 +273,7 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 
 	/* return if we got here for a different reason than underflows */
 	cur_txunfl =
-	    wlc_read_shm(wlc,
+	    brcms_c_read_shm(wlc,
 			 M_UCODE_MACSTAT + offsetof(macstat_t, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
 	if (new_txunfl == 0) {
@@ -286,9 +286,8 @@ static int wlc_ffpld_check_txfunfl(struct wlc_info *wlc, int fid)
 		return 1;
 
 	/* check if fifo is big enough */
-	if (wlc_xmtfifo_sz_get(wlc, fid, &xmtfifo_sz)) {
+	if (brcms_c_xmtfifo_sz_get(wlc, fid, &xmtfifo_sz))
 		return -1;
-	}
 
 	if ((TXFIFO_SIZE_UNIT * (u32) xmtfifo_sz) <= ampdu->ffpld_rsvd)
 		return 1;
@@ -428,10 +427,10 @@ wlc_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
 }
 
 int
-wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
+wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 	      struct sk_buff **pdu, int prec)
 {
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 	struct sk_buff *p, *pkt[AMPDU_MAX_MPDU];
 	u8 tid, ndelim;
 	int err = 0;
@@ -493,7 +492,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		txrate = tx_info->status.rates;
 
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = wlc_prep_pdu(wlc, p, &fifo);
+			err = brcms_c_prep_pdu(wlc, p, &fifo);
 		} else {
 			wiphy_err(wiphy, "%s: AMPDU flag is off!\n", __func__);
 			*pdu = NULL;
@@ -643,11 +642,11 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 			if (use_rts || use_cts) {
 				rts_rspec =
-				    wlc_rspec_to_rts_rspec(wlc, rspec, false,
-							   mimo_ctlchbw);
+				    brcms_c_rspec_to_rts_rspec(wlc,
+					rspec, false, mimo_ctlchbw);
 				rts_rspec_fallback =
-				    wlc_rspec_to_rts_rspec(wlc, rspec_fallback,
-							   false, mimo_ctlchbw);
+				    brcms_c_rspec_to_rts_rspec(wlc,
+					rspec_fallback, false, mimo_ctlchbw);
 			}
 		}
 
@@ -730,13 +729,14 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		/* reset the mixed mode header durations */
 		if (txh->MModeLen) {
 			u16 mmodelen =
-			    wlc_calc_lsig_len(wlc, rspec, ampdu_len);
+			    brcms_c_calc_lsig_len(wlc, rspec, ampdu_len);
 			txh->MModeLen = cpu_to_le16(mmodelen);
 			preamble_type = WLC_MM_PREAMBLE;
 		}
 		if (txh->MModeFbrLen) {
 			u16 mmfbrlen =
-			    wlc_calc_lsig_len(wlc, rspec_fallback, ampdu_len);
+			    brcms_c_calc_lsig_len(wlc, rspec_fallback,
+						  ampdu_len);
 			txh->MModeFbrLen = cpu_to_le16(mmfbrlen);
 			fbr_preamble_type = WLC_MM_PREAMBLE;
 		}
@@ -763,12 +763,12 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 				rts_fbr_preamble_type = WLC_SHORT_PREAMBLE;
 
 			durid =
-			    wlc_compute_rtscts_dur(wlc, use_cts, rts_rspec,
+			    brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec,
 						   rspec, rts_preamble_type,
 						   preamble_type, ampdu_len,
 						   true);
 			rts->duration = cpu_to_le16(durid);
-			durid = wlc_compute_rtscts_dur(wlc, use_cts,
+			durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
 						       rts_rspec_fallback,
 						       rspec_fallback,
 						       rts_fbr_preamble_type,
@@ -799,7 +799,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 				  "TXFID_RATE_PROBE_MASK!?\n", __func__);
 		}
 		for (i = 0; i < count; i++)
-			wlc_txfifo(wlc, fifo, pkt[i], i == (count - 1),
+			brcms_c_txfifo(wlc, fifo, pkt[i], i == (count - 1),
 				   ampdu->txpkt_weight);
 
 	}
@@ -812,7 +812,7 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		     struct sk_buff *p, tx_status_t *txs)
 {
 	scb_ampdu_t *scb_ampdu;
-	struct wlc_info *wlc = ampdu->wlc;
+	struct brcms_c_info *wlc = ampdu->wlc;
 	scb_ampdu_tid_ini_t *ini;
 	u32 s1 = 0, s2 = 0;
 	struct ieee80211_tx_info *tx_info;
@@ -858,13 +858,13 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				break;
 			p = GETNEXTTXP(wlc, queue);
 		}
-		wlc_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
+		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
 	wlc_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
 }
 
 static void
-rate_status(struct wlc_info *wlc, struct ieee80211_tx_info *tx_info,
+rate_status(struct brcms_c_info *wlc, struct ieee80211_tx_info *tx_info,
 	    tx_status_t *txs, u8 mcs)
 {
 	struct ieee80211_tx_rate *txrate = tx_info->status.rates;
@@ -885,7 +885,7 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			      u32 s1, u32 s2)
 {
 	scb_ampdu_t *scb_ampdu;
-	struct wlc_info *wlc = ampdu->wlc;
+	struct brcms_c_info *wlc = ampdu->wlc;
 	scb_ampdu_tid_ini_t *ini;
 	u8 bitmap[8], queue, tid;
 	d11txh_t *txh;
@@ -981,9 +981,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 			if (WL_ERROR_ON()) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
-				wlc_print_txdesc((d11txh_t *) p->data);
+				brcms_c_print_txdesc((d11txh_t *) p->data);
 			}
-			wlc_print_txstatus(txs);
+			brcms_c_print_txstatus(txs);
 		}
 	}
 
@@ -1040,8 +1040,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				ini->txretry[index]++;
 				ini->tx_in_transit--;
 				/* Use high prededence for retransmit to give some punch */
-				/* wlc_txq_enq(wlc, scb, p, WLC_PRIO_TO_PREC(tid)); */
-				wlc_txq_enq(wlc, scb, p,
+				/* brcms_c_txq_enq(wlc, scb, p,
+				 * WLC_PRIO_TO_PREC(tid)); */
+				brcms_c_txq_enq(wlc, scb, p,
 					    WLC_PRIO_TO_HI_PREC(tid));
 			} else {
 				/* Retry timeout */
@@ -1069,12 +1070,12 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		p = GETNEXTTXP(wlc, queue);
 	}
-	wlc_send_q(wlc);
+	brcms_c_send_q(wlc);
 
 	/* update rate state */
 	antselid = wlc_antsel_antsel2id(wlc->asi, mimoantsel);
 
-	wlc_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
+	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
 /* initialize the initiator code for tid */
@@ -1100,7 +1101,7 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 
 static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 {
-	struct wlc_info *wlc = ampdu->wlc;
+	struct brcms_c_info *wlc = ampdu->wlc;
 
 	wlc->pub->_ampdu = false;
 
@@ -1150,34 +1151,35 @@ static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 	}
 }
 
-void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
+void wlc_ampdu_macaddr_upd(struct brcms_c_info *wlc)
 {
 	char template[T_RAM_ACCESS_SZ * 2];
 
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
 	memcpy(template, wlc->pub->cur_etheraddr, ETH_ALEN);
-	wlc_write_template_ram(wlc, (T_BA_TPL_BASE + 16), (T_RAM_ACCESS_SZ * 2),
-			       template);
+	brcms_c_write_template_ram(wlc, (T_BA_TPL_BASE + 16),
+				  (T_RAM_ACCESS_SZ * 2),
+				  template);
 }
 
-bool wlc_aggregatable(struct wlc_info *wlc, u8 tid)
+bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid)
 {
 	return wlc->ampdu->ini_enable[tid];
 }
 
 void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
 {
-	struct wlc_info *wlc = ampdu->wlc;
+	struct brcms_c_info *wlc = ampdu->wlc;
 
 	/* Extend ucode internal watchdog timer to match larger received frames */
 	if ((ampdu->rx_factor & IEEE80211_HT_AMPDU_PARM_FACTOR) ==
 	    IEEE80211_HT_MAX_AMPDU_64K) {
-		wlc_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
-		wlc_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_MAX);
+		brcms_c_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_MAX);
+		brcms_c_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_MAX);
 	} else {
-		wlc_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_DEF);
-		wlc_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_DEF);
+		brcms_c_write_shm(wlc, M_MIMO_MAXSYM, MIMO_MAXSYM_DEF);
+		brcms_c_write_shm(wlc, M_WATCHDOG_8TU, WATCHDOG_8TU_DEF);
 	}
 }
 
@@ -1215,10 +1217,10 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
  * When a remote party is no longer available for ampdu communication, any
  * pending tx ampdu packets in the driver have to be flushed.
  */
-void wlc_ampdu_flush(struct wlc_info *wlc,
+void wlc_ampdu_flush(struct brcms_c_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
-	struct wlc_txq_info *qi = wlc->pkt_queue;
+	struct brcms_c_txq_info *qi = wlc->pkt_queue;
 	struct pktq *pq = &qi->q;
 	int prec;
 	struct cb_del_ampdu_pars ampdu_pars;
@@ -1229,5 +1231,5 @@ void wlc_ampdu_flush(struct wlc_info *wlc,
 		brcmu_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
 			    (void *)&ampdu_pars);
 	}
-	wlc_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
+	brcms_c_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.h b/drivers/staging/brcm80211/brcmsmac/ampdu.h
index df7d7d9..6f9aa9c 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.h
@@ -17,13 +17,13 @@
 #ifndef _BRCM_AMPDU_H_
 #define _BRCM_AMPDU_H_
 
-extern struct ampdu_info *wlc_ampdu_attach(struct wlc_info *wlc);
+extern struct ampdu_info *wlc_ampdu_attach(struct brcms_c_info *wlc);
 extern void wlc_ampdu_detach(struct ampdu_info *ampdu);
-extern int wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
+extern int wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 			 struct sk_buff **aggp, int prec);
 extern void wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, tx_status_t *txs);
-extern void wlc_ampdu_macaddr_upd(struct wlc_info *wlc);
+extern void wlc_ampdu_macaddr_upd(struct brcms_c_info *wlc);
 extern void wlc_ampdu_shm_upd(struct ampdu_info *ampdu);
 
 #endif				/* _BRCM_AMPDU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index b18c85b..7e12f60 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -81,7 +81,7 @@ const u8 mimo_2x3_div_antselid_tbl[16] = {
 	0, 0, 0, 0, 0, 0, 0, 0	/* pat to antselid */
 };
 
-struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
+struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc)
 {
 	struct antsel_info *asi;
 
@@ -282,7 +282,7 @@ static u16 wlc_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 /* boardlevel antenna selection: ucode interface control */
 static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 {
-	struct wlc_info *wlc = asi->wlc;
+	struct brcms_c_info *wlc = asi->wlc;
 	u8 ant_cfg;
 	u16 mimo_antsel;
 
@@ -291,7 +291,7 @@ static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
 	mimo_antsel = wlc_antsel_antcfg2antsel(asi, ant_cfg);
-	wlc_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
+	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
 	/* Update driver stats for currently selected default tx/rx antenna config */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_TX_DEF] = ant_cfg;
 
@@ -300,7 +300,7 @@ static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
 	mimo_antsel = wlc_antsel_antcfg2antsel(asi, ant_cfg);
-	wlc_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
+	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
 	/* Update driver stats for currently selected default tx/rx antenna config */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_RX_DEF] = ant_cfg;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.h b/drivers/staging/brcm80211/brcmsmac/antsel.h
index c1b9cef..a2c98e9 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.h
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.h
@@ -17,7 +17,7 @@
 #ifndef _BRCM_ANTSEL_H_
 #define _BRCM_ANTSEL_H_
 
-extern struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc);
+extern struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc);
 extern void wlc_antsel_detach(struct antsel_info *asi);
 extern void wlc_antsel_init(struct antsel_info *asi);
 extern void wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef,
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index ccd9cb5..7f88ea2 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -71,82 +71,86 @@ static u16 xmtfifo_sz[][NFIFO] = {
 	{9, 58, 22, 14, 14, 5},	/* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
 };
 
-static void brcms_b_clkctl_clk(struct wlc_hw_info *wlc, uint mode);
-static void brcms_b_coreinit(struct wlc_info *wlc);
+static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc, uint mode);
+static void brcms_b_coreinit(struct brcms_c_info *wlc);
 
 /* used by wlc_wakeucode_init() */
-static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
+static void wlc_write_inits(struct brcms_c_hw_info *wlc_hw,
 			    const struct d11init *inits);
-static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
+static void wlc_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 			    const uint nbytes);
-static void wlc_ucode_download(struct wlc_hw_info *wlc);
-static void wlc_ucode_txant_set(struct wlc_hw_info *wlc_hw);
+static void wlc_ucode_download(struct brcms_c_hw_info *wlc);
+static void wlc_ucode_txant_set(struct brcms_c_hw_info *wlc_hw);
 
-/* used by wlc_dpc() */
-static bool brcms_b_dotxstatus(struct wlc_hw_info *wlc, tx_status_t *txs,
+/* used by brcms_c_dpc() */
+static bool brcms_b_dotxstatus(struct brcms_c_hw_info *wlc, tx_status_t *txs,
 				u32 s2);
-static bool brcms_b_txstatus(struct wlc_hw_info *wlc, bool bound, bool *fatal);
-static bool brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound);
+static bool brcms_b_txstatus(struct brcms_c_hw_info *wlc, bool bound,
+			     bool *fatal);
+static bool brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound);
 
-/* used by wlc_down() */
-static void wlc_flushqueues(struct wlc_info *wlc);
+/* used by brcms_c_down() */
+static void wlc_flushqueues(struct brcms_c_info *wlc);
 
-static void wlc_write_mhf(struct wlc_hw_info *wlc_hw, u16 *mhfs);
-static void wlc_mctrl_reset(struct wlc_hw_info *wlc_hw);
-static void brcms_b_corerev_fifofixup(struct wlc_hw_info *wlc_hw);
-static bool brcms_b_tx_fifo_suspended(struct wlc_hw_info *wlc_hw,
+static void wlc_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs);
+static void wlc_mctrl_reset(struct brcms_c_hw_info *wlc_hw);
+static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw);
+static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
 				       uint tx_fifo);
-static void brcms_b_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo);
-static void brcms_b_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo);
+static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
+				    uint tx_fifo);
+static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
+				   uint tx_fifo);
 
 /* Low Level Prototypes */
-static int brcms_b_bandtype(struct wlc_hw_info *wlc_hw);
-static void brcms_b_info_init(struct wlc_hw_info *wlc_hw);
-static void brcms_b_xtal(struct wlc_hw_info *wlc_hw, bool want);
-static u16 brcms_b_read_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+static int brcms_b_bandtype(struct brcms_c_hw_info *wlc_hw);
+static void brcms_b_info_init(struct brcms_c_hw_info *wlc_hw);
+static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want);
+static u16 brcms_b_read_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
 				   u32 sel);
-static void brcms_b_write_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+static void brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
 				  u16 v, u32 sel);
-static void brcms_b_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk);
-static bool brcms_b_attach_dmapio(struct wlc_info *wlc, uint j, bool wme);
-static void brcms_b_detach_dmapio(struct wlc_hw_info *wlc_hw);
-static void wlc_ucode_bsinit(struct wlc_hw_info *wlc_hw);
-static bool wlc_validboardtype(struct wlc_hw_info *wlc);
-static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw);
-static bool brcms_b_validate_chip_access(struct wlc_hw_info *wlc_hw);
-static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw);
-static void wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init);
-static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw);
-static void brcms_b_mute(struct wlc_hw_info *wlc_hw, bool want, mbool flags);
-static void wlc_ucode_mute_override_set(struct wlc_hw_info *wlc_hw);
-static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw);
-static u32 wlc_wlintrsoff(struct wlc_info *wlc);
-static void wlc_wlintrsrestore(struct wlc_info *wlc, u32 macintmask);
-static void wlc_gpio_init(struct wlc_info *wlc);
-static void wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn,
+static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk);
+static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme);
+static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw);
+static void wlc_ucode_bsinit(struct brcms_c_hw_info *wlc_hw);
+static bool wlc_validboardtype(struct brcms_c_hw_info *wlc);
+static bool wlc_isgoodchip(struct brcms_c_hw_info *wlc_hw);
+static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw);
+static char *wlc_get_macaddr(struct brcms_c_hw_info *wlc_hw);
+static void wlc_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
+static void wlc_mctrl_write(struct brcms_c_hw_info *wlc_hw);
+static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool want,
+			 mbool flags);
+static void wlc_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw);
+static void wlc_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw);
+static u32 wlc_wlintrsoff(struct brcms_c_info *wlc);
+static void wlc_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
+static void wlc_gpio_init(struct brcms_c_info *wlc);
+static void wlc_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn,
 				      int len);
-static void wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn,
+static void wlc_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn,
 				      int len);
-static void brcms_b_bsinit(struct wlc_info *wlc, chanspec_t chanspec);
-static u32 wlc_setband_inact(struct wlc_info *wlc, uint bandunit);
-static void brcms_b_setband(struct wlc_hw_info *wlc_hw, uint bandunit,
+static void brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec);
+static u32 wlc_setband_inact(struct brcms_c_info *wlc, uint bandunit);
+static void brcms_b_setband(struct brcms_c_hw_info *wlc_hw, uint bandunit,
 			     chanspec_t chanspec);
-static void brcms_b_update_slot_timing(struct wlc_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
 					bool shortslot);
-static void wlc_upd_ofdm_pctl1_table(struct wlc_hw_info *wlc_hw);
-static u16 brcms_b_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw,
+static void wlc_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw);
+static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
 					     u8 rate);
 
 /* === Low Level functions === */
 
-void brcms_b_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot)
+void brcms_b_set_shortslot(struct brcms_c_hw_info *wlc_hw, bool shortslot)
 {
 	wlc_hw->shortslot = shortslot;
 
 	if (BAND_2G(brcms_b_bandtype(wlc_hw)) && wlc_hw->up) {
-		wlc_suspend_mac_and_wait(wlc_hw->wlc);
+		brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 		brcms_b_update_slot_timing(wlc_hw, shortslot);
-		wlc_enable_mac(wlc_hw->wlc);
+		brcms_c_enable_mac(wlc_hw->wlc);
 	}
 }
 
@@ -155,7 +159,7 @@ void brcms_b_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot)
  * or shortslot 11g (9us slots)
  * The PSM needs to be suspended for this call.
  */
-static void brcms_b_update_slot_timing(struct wlc_hw_info *wlc_hw,
+static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
 					bool shortslot)
 {
 	d11regs_t *regs;
@@ -173,7 +177,7 @@ static void brcms_b_update_slot_timing(struct wlc_hw_info *wlc_hw,
 	}
 }
 
-static void WLBANDINITFN(wlc_ucode_bsinit) (struct wlc_hw_info *wlc_hw)
+static void WLBANDINITFN(wlc_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
@@ -205,9 +209,10 @@ static void WLBANDINITFN(wlc_ucode_bsinit) (struct wlc_hw_info *wlc_hw)
 }
 
 /* switch to new band but leave it inactive */
-static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
+static u32 WLBANDINITFN(wlc_setband_inact) (struct brcms_c_info *wlc,
+					    uint bandunit)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	u32 macintmask;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -222,7 +227,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
 
 	brcms_b_core_phy_clk(wlc_hw, OFF);
 
-	wlc_setxband(wlc_hw, bandunit);
+	brcms_c_setxband(wlc_hw, bandunit);
 
 	return macintmask;
 }
@@ -233,7 +238,7 @@ static u32 WLBANDINITFN(wlc_setband_inact) (struct wlc_info *wlc, uint bandunit)
  * Param 'bound' indicates max. # frames to process before break out.
  */
 static bool
-brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
+brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound)
 {
 	struct sk_buff *p;
 	struct sk_buff *head = NULL;
@@ -271,7 +276,7 @@ brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
 		/* compute the RSSI from d11rxhdr and record it in wlc_rxd11hr */
 		wlc_phy_rssi_compute(wlc_hw->band->pi, wlc_rxhdr);
 
-		wlc_recv(wlc_hw->wlc, p);
+		brcms_c_recv(wlc_hw->wlc, p);
 	}
 
 	return n >= bound_limit;
@@ -281,10 +286,10 @@ brcms_b_recv(struct wlc_hw_info *wlc_hw, uint fifo, bool bound)
  *   Return true if another dpc needs to be re-scheduled. false otherwise.
  *   Param 'bounded' indicates if applicable loops should be bounded.
  */
-bool wlc_dpc(struct wlc_info *wlc, bool bounded)
+bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
 	u32 macintstatus;
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -309,7 +314,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	/* ZZZ: Use AP_ACTIVE ? */
 	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub))
 	    && (macintstatus & MI_BCNTPL)) {
-		wlc_update_beacon(wlc);
+		brcms_c_update_beacon(wlc);
 	}
 
 	/* PMQ entry addition */
@@ -327,7 +332,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & (MI_TBTT | MI_DTIM_TBTT))
-		wlc_tbtt(wlc);
+		brcms_c_tbtt(wlc);
 
 	/* ATIM window end */
 	if (macintstatus & MI_ATIMWINEND) {
@@ -374,7 +379,7 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 
 	/* send any enq'd tx packets. Just makes sure to jump start tx */
 	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc);
+		brcms_c_send_q(wlc);
 
 	/* it isn't done and needs to be resched if macintstatus is non-zero */
 	return wlc->macintstatus != 0;
@@ -387,8 +392,8 @@ bool wlc_dpc(struct wlc_info *wlc, bool bounded)
 /* common low-level watchdog code */
 void brcms_b_watchdog(void *arg)
 {
-	struct wlc_info *wlc = (struct wlc_info *) arg;
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -408,7 +413,7 @@ void brcms_b_watchdog(void *arg)
 }
 
 void
-brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 		      bool mute, struct txpwr_limits *txpwr)
 {
 	uint bandunit;
@@ -430,7 +435,7 @@ brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 							   pi, chanspec);
 				brcms_b_setband(wlc_hw, bandunit, chanspec);
 			} else {
-				wlc_setxband(wlc_hw, bandunit);
+				brcms_c_setxband(wlc_hw, bandunit);
 			}
 		}
 	}
@@ -451,20 +456,20 @@ brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	}
 }
 
-int brcms_b_state_get(struct wlc_hw_info *wlc_hw, brcms_b_state_t *state)
+int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw, brcms_b_state_t *state)
 {
 	state->machwcap = wlc_hw->machwcap;
 
 	return 0;
 }
 
-static bool brcms_b_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
+static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 {
 	uint i;
 	char name[8];
 	/* ucode host flag 2 needed for pio mode, independent of band and fifo */
 	u16 pio_mhf2 = 0;
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
 	wlc_tunables_t *tune = wlc->pub->tunables;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -555,7 +560,7 @@ static bool brcms_b_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 	return true;
 }
 
-static void brcms_b_detach_dmapio(struct wlc_hw_info *wlc_hw)
+static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw)
 {
 	uint j;
 
@@ -573,10 +578,10 @@ static void brcms_b_detach_dmapio(struct wlc_hw_info *wlc_hw)
  *    initialize software state for each core and band
  *    put the whole chip in reset(driver down state), no clock
  */
-int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
+int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		    bool piomode, void *regsva, uint bustype, void *btparam)
 {
-	struct wlc_hw_info *wlc_hw;
+	struct brcms_c_hw_info *wlc_hw;
 	d11regs_t *regs;
 	char *macaddr = NULL;
 	char *vars;
@@ -597,7 +602,7 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->band = wlc_hw->bandstate[0];
 	wlc_hw->_piomode = piomode;
 
-	/* populate struct wlc_hw_info with default values  */
+	/* populate struct brcms_c_hw_info with default values  */
 	brcms_b_info_init(wlc_hw);
 
 	/*
@@ -643,7 +648,7 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		}
 
 		/* verify again the device is supported */
-		if (!wlc_chipmatch(vendor, device)) {
+		if (!brcms_c_chipmatch(vendor, device)) {
 			wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
 				"vendor/device (0x%x/0x%x)\n",
 				 unit, vendor, device);
@@ -722,8 +727,8 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	if ((wlc_hw->sih->chip == BCM43225_CHIP_ID))
 		wlc_hw->_nbands = 1;
 
-	/* BMAC_NOTE: remove init of pub values when wlc_attach() unconditionally does the
-	 * init of these values
+	/* BMAC_NOTE: remove init of pub values when brcms_c_attach()
+	 * unconditionally does the init of these values
 	 */
 	wlc->vendorid = wlc_hw->vendorid;
 	wlc->deviceid = wlc_hw->deviceid;
@@ -782,7 +787,7 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		if (IS_SINGLEBAND_5G(wlc_hw->deviceid))
 			j = BAND_5G_INDEX;
 
-		wlc_setxband(wlc_hw, j);
+		brcms_c_setxband(wlc_hw, j);
 
 		wlc_hw->band->bandunit = j;
 		wlc_hw->band->bandtype = j ? WLC_BAND_5G : WLC_BAND_2G;
@@ -864,7 +869,7 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	}
 
 	/* disable core to match driver "down" state */
-	wlc_coredisable(wlc_hw);
+	brcms_c_coredisable(wlc_hw);
 
 	/* Match driver "down" state */
 	if (wlc_hw->sih->bustype == PCI_BUS)
@@ -918,13 +923,13 @@ int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 }
 
 /*
- * Initialize wlc_info default values ...
+ * Initialize brcms_c_info default values ...
  * may get overrides later in this function
  *  BMAC_NOTES, move low out and resolve the dangling ones
  */
-static void brcms_b_info_init(struct wlc_hw_info *wlc_hw)
+static void brcms_b_info_init(struct brcms_c_hw_info *wlc_hw)
 {
-	struct wlc_info *wlc = wlc_hw->wlc;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
 
 	/* set default sw macintmask value */
 	wlc->defmacintmask = DEF_MACINTMASK;
@@ -944,11 +949,11 @@ static void brcms_b_info_init(struct wlc_hw_info *wlc_hw)
 /*
  * low level detach
  */
-int brcms_b_detach(struct wlc_info *wlc)
+int brcms_b_detach(struct brcms_c_info *wlc)
 {
 	uint i;
-	struct wlc_hwband *band;
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hwband *band;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	int callbacks;
 
 	callbacks = 0;
@@ -993,7 +998,7 @@ int brcms_b_detach(struct wlc_info *wlc)
 
 }
 
-void brcms_b_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_reset(struct brcms_c_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1004,15 +1009,15 @@ void brcms_b_reset(struct wlc_hw_info *wlc_hw)
 	/* purge the dma rings */
 	wlc_flushqueues(wlc_hw->wlc);
 
-	wlc_reset_bmac_done(wlc_hw->wlc);
+	brcms_c_reset_bmac_done(wlc_hw->wlc);
 }
 
 void
-brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+brcms_b_init(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 			  bool mute) {
 	u32 macintmask;
 	bool fastclk;
-	struct wlc_info *wlc = wlc_hw->wlc;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1025,7 +1030,7 @@ brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	macintmask = brcms_intrsoff(wlc->wl);
 
 	/* set up the specified band and chanspec */
-	wlc_setxband(wlc_hw, CHSPEC_WLCBANDUNIT(chanspec));
+	brcms_c_setxband(wlc_hw, CHSPEC_WLCBANDUNIT(chanspec));
 	wlc_phy_chanspec_radio_set(wlc_hw->band->pi, chanspec);
 
 	/* do one-time phy inits and calibration */
@@ -1045,7 +1050,7 @@ brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 	brcms_intrsrestore(wlc->wl, macintmask);
 
 	/* seed wake_override with WLC_WAKE_OVERRIDE_MACSUSPEND since the mac is suspended
-	 * and wlc_enable_mac() will clear this override bit.
+	 * and brcms_c_enable_mac() will clear this override bit.
 	 */
 	mboolset(wlc_hw->wake_override, WLC_WAKE_OVERRIDE_MACSUSPEND);
 
@@ -1059,7 +1064,7 @@ brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
 		brcms_b_clkctl_clk(wlc_hw, CLK_DYNAMIC);
 }
 
-int brcms_b_up_prep(struct wlc_hw_info *wlc_hw)
+int brcms_b_up_prep(struct brcms_c_hw_info *wlc_hw)
 {
 	uint coremask;
 
@@ -1067,14 +1072,14 @@ int brcms_b_up_prep(struct wlc_hw_info *wlc_hw)
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
-	 * and force fastclock for the remainder of wlc_up().
+	 * and force fastclock for the remainder of brcms_c_up().
 	 */
 	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
 	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	/*
-	 * Configure pci/pcmcia here instead of in wlc_attach()
+	 * Configure pci/pcmcia here instead of in brcms_c_attach()
 	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
 	 */
 	coremask = (1 << wlc_hw->wlc->core->coreidx);
@@ -1103,7 +1108,7 @@ int brcms_b_up_prep(struct wlc_hw_info *wlc_hw)
 	return 0;
 }
 
-int brcms_b_up_finish(struct wlc_hw_info *wlc_hw)
+int brcms_b_up_finish(struct brcms_c_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1116,7 +1121,7 @@ int brcms_b_up_finish(struct wlc_hw_info *wlc_hw)
 	return 0;
 }
 
-int brcms_b_bmac_down_prep(struct wlc_hw_info *wlc_hw)
+int brcms_b_bmac_down_prep(struct brcms_c_hw_info *wlc_hw)
 {
 	bool dev_gone;
 	uint callbacks = 0;
@@ -1144,7 +1149,7 @@ int brcms_b_bmac_down_prep(struct wlc_hw_info *wlc_hw)
 	return callbacks;
 }
 
-int brcms_b_down_finish(struct wlc_hw_info *wlc_hw)
+int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw)
 {
 	uint callbacks = 0;
 	bool dev_gone;
@@ -1172,9 +1177,9 @@ int brcms_b_down_finish(struct wlc_hw_info *wlc_hw)
 		if (ai_iscoreup(wlc_hw->sih)) {
 			if (R_REG(&wlc_hw->regs->maccontrol) &
 			    MCTL_EN_MAC)
-				wlc_suspend_mac_and_wait(wlc_hw->wlc);
+				brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 			callbacks += brcms_reset(wlc_hw->wlc->wl);
-			wlc_coredisable(wlc_hw);
+			brcms_c_coredisable(wlc_hw);
 		}
 
 		/* turn off primary xtal and pll */
@@ -1188,7 +1193,7 @@ int brcms_b_down_finish(struct wlc_hw_info *wlc_hw)
 	return callbacks;
 }
 
-void brcms_b_wait_for_wake(struct wlc_hw_info *wlc_hw)
+void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw)
 {
 	/* delay before first read of ucode state */
 	udelay(40);
@@ -1198,18 +1203,18 @@ void brcms_b_wait_for_wake(struct wlc_hw_info *wlc_hw)
 		  DBGST_ASLEEP), wlc_hw->wlc->fastpwrup_dly);
 }
 
-void brcms_b_hw_etheraddr(struct wlc_hw_info *wlc_hw, u8 *ea)
+void brcms_b_hw_etheraddr(struct brcms_c_hw_info *wlc_hw, u8 *ea)
 {
 	memcpy(ea, wlc_hw->etheraddr, ETH_ALEN);
 }
 
-static int brcms_b_bandtype(struct wlc_hw_info *wlc_hw)
+static int brcms_b_bandtype(struct brcms_c_hw_info *wlc_hw)
 {
 	return wlc_hw->band->bandtype;
 }
 
 /* control chip clock to save power, enable dynamic clock or force fast clock */
-static void brcms_b_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
+static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc_hw, uint mode)
 {
 	if (PMUCTL_ENAB(wlc_hw->sih)) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock on backplane,
@@ -1280,9 +1285,9 @@ static void brcms_b_clkctl_clk(struct wlc_hw_info *wlc_hw, uint mode)
 
 /* set initial host flags value */
 static void
-wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init)
+wlc_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 
 	memset(mhfs, 0, MHFMAX * sizeof(u16));
 
@@ -1310,7 +1315,7 @@ wlc_mhfdef(struct wlc_info *wlc, u16 *mhfs, u16 mhf2_init)
  *                   WLC_BAND_ALL  <--- All bands
  */
 void
-brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
+brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	     int bands)
 {
 	u16 save;
@@ -1318,7 +1323,7 @@ brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 		M_HOST_FLAGS1, M_HOST_FLAGS2, M_HOST_FLAGS3, M_HOST_FLAGS4,
 		M_HOST_FLAGS5
 	};
-	struct wlc_hwband *band;
+	struct brcms_c_hwband *band;
 
 	if ((val & ~mask) || idx >= MHFMAX)
 		return; /* error condition */
@@ -1362,9 +1367,9 @@ brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask, u16 val,
 	}
 }
 
-u16 brcms_b_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
+u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands)
 {
-	struct wlc_hwband *band;
+	struct brcms_c_hwband *band;
 
 	if (idx >= MHFMAX)
 		return 0; /* error condition */
@@ -1388,7 +1393,7 @@ u16 brcms_b_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands)
 	return band->mhfs[idx];
 }
 
-static void wlc_write_mhf(struct wlc_hw_info *wlc_hw, u16 *mhfs)
+static void wlc_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
 {
 	u8 idx;
 	u16 addr[] = {
@@ -1404,7 +1409,7 @@ static void wlc_write_mhf(struct wlc_hw_info *wlc_hw, u16 *mhfs)
 /* set the maccontrol register to desired reset state and
  * initialize the sw cache of the register
  */
-static void wlc_mctrl_reset(struct wlc_hw_info *wlc_hw)
+static void wlc_mctrl_reset(struct brcms_c_hw_info *wlc_hw)
 {
 	/* IHR accesses are always enabled, PSM disabled, HPS off and WAKE on */
 	wlc_hw->maccontrol = 0;
@@ -1415,7 +1420,7 @@ static void wlc_mctrl_reset(struct wlc_hw_info *wlc_hw)
 }
 
 /* set or clear maccontrol bits */
-void brcms_b_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val)
+void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val)
 {
 	u32 maccontrol;
 	u32 new_maccontrol;
@@ -1437,7 +1442,7 @@ void brcms_b_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val)
 }
 
 /* write the software state of maccontrol and overrides to the maccontrol register */
-static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw)
+static void wlc_mctrl_write(struct brcms_c_hw_info *wlc_hw)
 {
 	u32 maccontrol = wlc_hw->maccontrol;
 
@@ -1454,7 +1459,8 @@ static void wlc_mctrl_write(struct wlc_hw_info *wlc_hw)
 	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
 }
 
-void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw, u32 override_bit)
+void wlc_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
+				 u32 override_bit)
 {
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE)) {
 		mboolset(wlc_hw->wake_override, override_bit);
@@ -1469,7 +1475,8 @@ void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw, u32 override_bit)
 	return;
 }
 
-void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw, u32 override_bit)
+void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
+				   u32 override_bit)
 {
 	mboolclr(wlc_hw->wake_override, override_bit);
 
@@ -1488,7 +1495,7 @@ void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw, u32 override_bit)
  * STA               0              1 <--- This will ensure no beacons
  * IBSS              0              0
  */
-static void wlc_ucode_mute_override_set(struct wlc_hw_info *wlc_hw)
+static void wlc_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
 {
 	wlc_hw->mute_override = 1;
 
@@ -1504,7 +1511,7 @@ static void wlc_ucode_mute_override_set(struct wlc_hw_info *wlc_hw)
 }
 
 /* Clear the override on AP and INFRA bits */
-static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
+static void wlc_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
 {
 	if (wlc_hw->mute_override == 0)
 		return;
@@ -1524,7 +1531,7 @@ static void wlc_ucode_mute_override_clear(struct wlc_hw_info *wlc_hw)
  * Write a MAC address to the given match reg offset in the RXE match engine.
  */
 void
-brcms_b_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
+brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
 	d11regs_t *regs;
@@ -1549,7 +1556,7 @@ brcms_b_set_addrmatch(struct wlc_hw_info *wlc_hw, int match_reg_offset,
 }
 
 void
-brcms_b_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
+brcms_b_write_template_ram(struct brcms_c_hw_info *wlc_hw, int offset, int len,
 			    void *buf)
 {
 	d11regs_t *regs;
@@ -1581,7 +1588,7 @@ brcms_b_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 	}
 }
 
-void brcms_b_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin)
+void brcms_b_set_cwmin(struct brcms_c_hw_info *wlc_hw, u16 newmin)
 {
 	wlc_hw->band->CWmin = newmin;
 
@@ -1590,7 +1597,7 @@ void brcms_b_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin)
 	W_REG(&wlc_hw->regs->objdata, newmin);
 }
 
-void brcms_b_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax)
+void brcms_b_set_cwmax(struct brcms_c_hw_info *wlc_hw, u16 newmax)
 {
 	wlc_hw->band->CWmax = newmax;
 
@@ -1599,7 +1606,7 @@ void brcms_b_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax)
 	W_REG(&wlc_hw->regs->objdata, newmax);
 }
 
-void brcms_b_bw_set(struct wlc_hw_info *wlc_hw, u16 bw)
+void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw)
 {
 	bool fastclk;
 
@@ -1619,7 +1626,7 @@ void brcms_b_bw_set(struct wlc_hw_info *wlc_hw, u16 bw)
 }
 
 static void
-wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn, int len)
+wlc_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn, int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
@@ -1632,7 +1639,7 @@ wlc_write_hw_bcntemplate0(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 }
 
 static void
-wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn, int len)
+wlc_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn, int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
@@ -1646,8 +1653,8 @@ wlc_write_hw_bcntemplate1(struct wlc_hw_info *wlc_hw, void *bcn, int len)
 
 /* mac is assumed to be suspended at this point */
 void
-brcms_b_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
-			       bool both)
+brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw, void *bcn,
+			      int len, bool both)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
@@ -1665,10 +1672,10 @@ brcms_b_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw, void *bcn, int len,
 	}
 }
 
-static void WLBANDINITFN(brcms_b_upd_synthpu) (struct wlc_hw_info *wlc_hw)
+static void WLBANDINITFN(brcms_b_upd_synthpu) (struct brcms_c_hw_info *wlc_hw)
 {
 	u16 v;
-	struct wlc_info *wlc = wlc_hw->wlc;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
 	/* update SYNTHPU_DLY */
 
 	if (WLCISLCNPHY(wlc->band)) {
@@ -1684,9 +1691,9 @@ static void WLBANDINITFN(brcms_b_upd_synthpu) (struct wlc_hw_info *wlc_hw)
 
 /* band-specific init */
 static void
-WLBANDINITFN(brcms_b_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
+WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
 		wlc_hw->band->bandunit);
@@ -1716,7 +1723,7 @@ WLBANDINITFN(brcms_b_bsinit) (struct wlc_info *wlc, chanspec_t chanspec)
 	brcms_b_upd_synthpu(wlc_hw);
 }
 
-static void brcms_b_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
+static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: clk %d\n", wlc_hw->unit, clk);
 
@@ -1741,7 +1748,7 @@ static void brcms_b_core_phy_clk(struct wlc_hw_info *wlc_hw, bool clk)
 }
 
 /* Perform a soft reset of the PHY PLL */
-void brcms_b_core_phypll_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_core_phypll_reset(struct brcms_c_hw_info *wlc_hw)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
@@ -1762,7 +1769,7 @@ void brcms_b_core_phypll_reset(struct wlc_hw_info *wlc_hw)
 /* light way to turn on phy clock without reset for NPHY only
  *  refer to brcms_b_core_phy_clk for full version
  */
-void brcms_b_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk)
+void brcms_b_phyclk_fgc(struct brcms_c_hw_info *wlc_hw, bool clk)
 {
 	/* support(necessary for NPHY and HYPHY) only */
 	if (!WLCISNPHY(wlc_hw->band))
@@ -1775,7 +1782,7 @@ void brcms_b_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk)
 
 }
 
-void brcms_b_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk)
+void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk)
 {
 	if (ON == clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, SICF_MPCLKE);
@@ -1783,7 +1790,7 @@ void brcms_b_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk)
 		ai_core_cflags(wlc_hw->sih, SICF_MPCLKE, 0);
 }
 
-void brcms_b_phy_reset(struct wlc_hw_info *wlc_hw)
+void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw)
 {
 	wlc_phy_t *pih = wlc_hw->band->pi;
 	u32 phy_bw_clkbits;
@@ -1827,9 +1834,9 @@ void brcms_b_phy_reset(struct wlc_hw_info *wlc_hw)
 
 /* switch to and initialize new band */
 static void
-WLBANDINITFN(brcms_b_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
+WLBANDINITFN(brcms_b_setband) (struct brcms_c_hw_info *wlc_hw, uint bandunit,
 				chanspec_t chanspec) {
-	struct wlc_info *wlc = wlc_hw->wlc;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
 	u32 macintmask;
 
 	/* Enable the d11 core before accessing it */
@@ -1851,7 +1858,7 @@ WLBANDINITFN(brcms_b_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 	/*
 	 * If there are any pending software interrupt bits,
 	 * then replace these with a harmless nonzero value
-	 * so wlc_dpc() will re-enable interrupts when done.
+	 * so brcms_c_dpc() will re-enable interrupts when done.
 	 */
 	if (wlc->macintstatus)
 		wlc->macintstatus = MI_DMAINT;
@@ -1864,7 +1871,8 @@ WLBANDINITFN(brcms_b_setband) (struct wlc_hw_info *wlc_hw, uint bandunit,
 }
 
 /* low-level band switch utility routine */
-void WLBANDINITFN(wlc_setxband) (struct wlc_hw_info *wlc_hw, uint bandunit)
+void WLBANDINITFN(brcms_c_setxband) (struct brcms_c_hw_info *wlc_hw,
+				     uint bandunit)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
 		bandunit);
@@ -1881,7 +1889,7 @@ void WLBANDINITFN(wlc_setxband) (struct wlc_hw_info *wlc_hw, uint bandunit)
 	}
 }
 
-static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw)
+static bool wlc_isgoodchip(struct brcms_c_hw_info *wlc_hw)
 {
 
 	/* reject unsupported corerev */
@@ -1894,7 +1902,7 @@ static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw)
 	return true;
 }
 
-static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
+static bool wlc_validboardtype(struct brcms_c_hw_info *wlc_hw)
 {
 	bool goodboard = true;
 	uint boardrev = wlc_hw->boardrev;
@@ -1918,7 +1926,7 @@ static bool wlc_validboardtype(struct wlc_hw_info *wlc_hw)
 	return goodboard;
 }
 
-static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw)
+static char *wlc_get_macaddr(struct brcms_c_hw_info *wlc_hw)
 {
 	const char *varname = "macaddr";
 	char *macaddr;
@@ -1948,7 +1956,7 @@ static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw)
  * this function could be called when driver is down and w/o clock
  * it operates on different registers depending on corerev and boardflag.
  */
-bool brcms_b_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
+bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw)
 {
 	bool v, clk, xtal;
 	u32 resetbits = 0, flags = 0;
@@ -1991,7 +1999,7 @@ bool brcms_b_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw)
 }
 
 /* Initialize just the hardware when coming out of POR or S3/S5 system states */
-void brcms_b_hw_up(struct wlc_hw_info *wlc_hw)
+void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw)
 {
 	if (wlc_hw->wlc->pub->hw_up)
 		return;
@@ -2000,7 +2008,7 @@ void brcms_b_hw_up(struct wlc_hw_info *wlc_hw)
 
 	/*
 	 * Enable pll and xtal, initialize the power control registers,
-	 * and force fastclock for the remainder of wlc_up().
+	 * and force fastclock for the remainder of brcms_c_up().
 	 */
 	brcms_b_xtal(wlc_hw, ON);
 	ai_clkctl_init(wlc_hw->sih);
@@ -2033,7 +2041,7 @@ void brcms_b_hw_up(struct wlc_hw_info *wlc_hw)
 	}
 }
 
-static bool wlc_dma_rxreset(struct wlc_hw_info *wlc_hw, uint fifo)
+static bool wlc_dma_rxreset(struct brcms_c_hw_info *wlc_hw, uint fifo)
 {
 	struct dma_pub *di = wlc_hw->di[fifo];
 	return dma_rxreset(di);
@@ -2047,7 +2055,7 @@ static bool wlc_dma_rxreset(struct wlc_hw_info *wlc_hw, uint fifo)
  *   clear software macintstatus for fresh new start
  * one testing hack wlc_hw->noreset will bypass the d11/phy reset
  */
-void brcms_b_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
+void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags)
 {
 	d11regs_t *regs;
 	uint i;
@@ -2130,7 +2138,7 @@ void brcms_b_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 /* txfifo sizes needs to be modified(increased) since the newer cores
  * have more memory.
  */
-static void brcms_b_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
+static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	u16 fifo_nu;
@@ -2185,9 +2193,9 @@ static void brcms_b_corerev_fifofixup(struct wlc_hw_info *wlc_hw)
  *   config other core registers
  *   init dma
  */
-static void brcms_b_coreinit(struct wlc_info *wlc)
+static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs;
 	u32 sflags;
 	uint bcnint_us;
@@ -2375,7 +2383,7 @@ static void brcms_b_coreinit(struct wlc_info *wlc)
  *  - 559241 = 0x88889 => tsf_clk_frac_h = 0x8, tsf_clk_frac_l = 0x8889
  */
 
-void brcms_b_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode)
+void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode)
 {
 	d11regs_t *regs;
 	regs = wlc_hw->regs;
@@ -2404,9 +2412,9 @@ void brcms_b_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode)
 }
 
 /* Initialize GPIOs that are controlled by D11 core */
-static void wlc_gpio_init(struct wlc_info *wlc)
+static void wlc_gpio_init(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs;
 	u32 gc, gm;
 
@@ -2466,9 +2474,9 @@ static void wlc_gpio_init(struct wlc_info *wlc)
 	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
-static void wlc_ucode_download(struct wlc_hw_info *wlc_hw)
+static void wlc_ucode_download(struct brcms_c_hw_info *wlc_hw)
 {
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 	wlc = wlc_hw->wlc;
 
 	if (wlc_hw->ucode_loaded)
@@ -2496,7 +2504,7 @@ static void wlc_ucode_download(struct wlc_hw_info *wlc_hw)
 	}
 }
 
-static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
+static void wlc_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 			      const uint nbytes) {
 	d11regs_t *regs = wlc_hw->regs;
 	uint i;
@@ -2512,7 +2520,7 @@ static void wlc_ucode_write(struct wlc_hw_info *wlc_hw, const u32 ucode[],
 		W_REG(&regs->objdata, ucode[i]);
 }
 
-static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
+static void wlc_write_inits(struct brcms_c_hw_info *wlc_hw,
 			    const struct d11init *inits)
 {
 	int i;
@@ -2532,7 +2540,7 @@ static void wlc_write_inits(struct wlc_hw_info *wlc_hw,
 	}
 }
 
-static void wlc_ucode_txant_set(struct wlc_hw_info *wlc_hw)
+static void wlc_ucode_txant_set(struct brcms_c_hw_info *wlc_hw)
 {
 	u16 phyctl;
 	u16 phytxant = wlc_hw->bmac_phytxant;
@@ -2549,7 +2557,7 @@ static void wlc_ucode_txant_set(struct wlc_hw_info *wlc_hw)
 	brcms_b_write_shm(wlc_hw, M_RSP_PCTLWD, phyctl);
 }
 
-void brcms_b_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant)
+void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant)
 {
 	/* update sw state */
 	wlc_hw->bmac_phytxant = phytxant;
@@ -2561,12 +2569,12 @@ void brcms_b_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant)
 
 }
 
-u16 brcms_b_get_txant(struct wlc_hw_info *wlc_hw)
+u16 brcms_b_get_txant(struct brcms_c_hw_info *wlc_hw)
 {
 	return (u16) wlc_hw->wlc->stf->txant;
 }
 
-void brcms_b_antsel_type_set(struct wlc_hw_info *wlc_hw, u8 antsel_type)
+void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw, u8 antsel_type)
 {
 	wlc_hw->antsel_type = antsel_type;
 
@@ -2574,7 +2582,7 @@ void brcms_b_antsel_type_set(struct wlc_hw_info *wlc_hw, u8 antsel_type)
 	wlc_phy_antsel_type_set(wlc_hw->band->pi, antsel_type);
 }
 
-void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw)
+void brcms_b_fifoerrors(struct brcms_c_hw_info *wlc_hw)
 {
 	bool fatal = false;
 	uint unit;
@@ -2630,7 +2638,7 @@ void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw)
 		}
 
 		if (fatal) {
-			wlc_fatal_error(wlc_hw->wlc);	/* big hammer */
+			brcms_c_fatal_error(wlc_hw->wlc);	/* big hammer */
 			break;
 		} else
 			W_REG(&regs->intctrlregs[idx].intstatus,
@@ -2638,9 +2646,9 @@ void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw)
 	}
 }
 
-void wlc_intrson(struct wlc_info *wlc)
+void brcms_c_intrson(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	wlc->macintmask = wlc->defmacintmask;
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
@@ -2650,7 +2658,7 @@ void wlc_intrson(struct wlc_info *wlc)
  *  but also because per-port code may require sync with valid interrupt.
  */
 
-static u32 wlc_wlintrsoff(struct wlc_info *wlc)
+static u32 wlc_wlintrsoff(struct brcms_c_info *wlc)
 {
 	if (!wlc->hw->up)
 		return 0;
@@ -2658,7 +2666,7 @@ static u32 wlc_wlintrsoff(struct wlc_info *wlc)
 	return brcms_intrsoff(wlc->wl);
 }
 
-static void wlc_wlintrsrestore(struct wlc_info *wlc, u32 macintmask)
+static void wlc_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 {
 	if (!wlc->hw->up)
 		return;
@@ -2666,9 +2674,9 @@ static void wlc_wlintrsrestore(struct wlc_info *wlc, u32 macintmask)
 	brcms_intrsrestore(wlc->wl, macintmask);
 }
 
-u32 wlc_intrsoff(struct wlc_info *wlc)
+u32 brcms_c_intrsoff(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	u32 macintmask;
 
 	if (!wlc_hw->clk)
@@ -2685,9 +2693,9 @@ u32 wlc_intrsoff(struct wlc_info *wlc)
 	return wlc->macintstatus ? 0 : macintmask;
 }
 
-void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
+void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	if (!wlc_hw->clk)
 		return;
 
@@ -2695,7 +2703,7 @@ void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask)
 	W_REG(&wlc_hw->regs->macintmask, wlc->macintmask);
 }
 
-static void brcms_b_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
+static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool on, mbool flags)
 {
 	u8 null_ether_addr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
 
@@ -2731,7 +2739,8 @@ static void brcms_b_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 		wlc_ucode_mute_override_clear(wlc_hw);
 }
 
-int brcms_b_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
+int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
+			   uint *blocks)
 {
 	if (fifo >= NFIFO)
 		return -EINVAL;
@@ -2750,7 +2759,8 @@ int brcms_b_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
  * be pulling data into a tx fifo, by the time the MAC acks the suspend
  * request.
  */
-static bool brcms_b_tx_fifo_suspended(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
+				      uint tx_fifo)
 {
 	/* check that a suspend has been requested and is no longer pending */
 
@@ -2769,7 +2779,8 @@ static bool brcms_b_tx_fifo_suspended(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 	return false;
 }
 
-static void brcms_b_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
+				    uint tx_fifo)
 {
 	u8 fifo = 1 << tx_fifo;
 
@@ -2791,19 +2802,21 @@ static void brcms_b_tx_fifo_suspend(struct wlc_hw_info *wlc_hw, uint tx_fifo)
 		 * so suspend the mac before suspending the FIFO
 		 */
 		if (WLC_PHY_11N_CAP(wlc_hw->band))
-			wlc_suspend_mac_and_wait(wlc_hw->wlc);
+			brcms_c_suspend_mac_and_wait(wlc_hw->wlc);
 
 		dma_txsuspend(wlc_hw->di[tx_fifo]);
 
 		if (WLC_PHY_11N_CAP(wlc_hw->band))
-			wlc_enable_mac(wlc_hw->wlc);
+			brcms_c_enable_mac(wlc_hw->wlc);
 	}
 }
 
-static void brcms_b_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo)
+static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
+				   uint tx_fifo)
 {
-	/* BMAC_NOTE: WLC_TX_FIFO_ENAB is done in wlc_dpc() for DMA case but need to be done
-	 * here for PIO otherwise the watchdog will catch the inconsistency and fire
+	/* BMAC_NOTE: WLC_TX_FIFO_ENAB is done in brcms_c_dpc() for DMA case
+	 * but need to be done here for PIO otherwise the watchdog will catch
+	 * the inconsistency and fire
 	 */
 	/* Two clients of this code, 11h Quiet period and scanning. */
 	if (wlc_hw->di[tx_fifo])
@@ -2828,9 +2841,9 @@ static void brcms_b_tx_fifo_resume(struct wlc_hw_info *wlc_hw, uint tx_fifo)
  *   0 if the interrupt is not for us, or we are in some special cases;
  *   device interrupt status bits otherwise.
  */
-static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
+static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 macintstatus;
 
@@ -2885,7 +2898,7 @@ static inline u32 wlc_intstatus(struct wlc_info *wlc, bool in_isr)
 
 /* Update wlc->macintstatus and wlc->intstatus[]. */
 /* Return true if they are updated successfully. false otherwise */
-bool wlc_intrsupd(struct wlc_info *wlc)
+bool brcms_c_intrsupd(struct brcms_c_info *wlc)
 {
 	u32 macintstatus;
 
@@ -2905,12 +2918,12 @@ bool wlc_intrsupd(struct wlc_info *wlc)
 /*
  * First-level interrupt processing.
  * Return true if this was our interrupt, false otherwise.
- * *wantdpc will be set to true if further wlc_dpc() processing is required,
+ * *wantdpc will be set to true if further brcms_c_dpc() processing is required,
  * false otherwise.
  */
-bool wlc_isr(struct wlc_info *wlc, bool *wantdpc)
+bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	u32 macintstatus;
 
 	*wantdpc = false;
@@ -2939,7 +2952,7 @@ bool wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 }
 
 static bool
-brcms_b_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
+brcms_b_dotxstatus(struct brcms_c_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
@@ -2951,17 +2964,17 @@ brcms_b_dotxstatus(struct wlc_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
 		return false;
 	}
 
-	return wlc_dotxstatus(wlc_hw->wlc, txs, s2);
+	return brcms_c_dotxstatus(wlc_hw->wlc, txs, s2);
 }
 
 /* process tx completion events in BMAC
  * Return true if more tx status need to be processed. false otherwise.
  */
 static bool
-brcms_b_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
+brcms_b_txstatus(struct brcms_c_hw_info *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
-	struct wlc_info *wlc = wlc_hw->wlc;
+	struct brcms_c_info *wlc = wlc_hw->wlc;
 	d11regs_t *regs;
 	tx_status_t txstatus, *txs;
 	u32 s1, s2;
@@ -3007,14 +3020,14 @@ brcms_b_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 		morepending = true;
 
 	if (!pktq_empty(&wlc->pkt_queue->q))
-		wlc_send_q(wlc);
+		brcms_c_send_q(wlc);
 
 	return morepending;
 }
 
-void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
+void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
@@ -3081,9 +3094,9 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	WARN_ON(mc & MCTL_EN_MAC);
 }
 
-void wlc_enable_mac(struct wlc_info *wlc)
+void brcms_c_enable_mac(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
 
@@ -3116,7 +3129,7 @@ void wlc_enable_mac(struct wlc_info *wlc)
 	wlc_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
 }
 
-static void wlc_upd_ofdm_pctl1_table(struct wlc_hw_info *wlc_hw)
+static void wlc_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw)
 {
 	u8 rate;
 	u8 rates[8] = {
@@ -3150,7 +3163,8 @@ static void wlc_upd_ofdm_pctl1_table(struct wlc_hw_info *wlc_hw)
 	}
 }
 
-static u16 brcms_b_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw, u8 rate)
+static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
+					 u8 rate)
 {
 	uint i;
 	u8 plcp_rate = 0;
@@ -3183,7 +3197,7 @@ static u16 brcms_b_ofdm_ratetable_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, M_RT_DIRMAP_A + (plcp_rate * 2));
 }
 
-void brcms_b_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
+void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw, u8 stf_mode)
 {
 	wlc_hw->hw_stf_ss_opmode = stf_mode;
 
@@ -3192,7 +3206,7 @@ void brcms_b_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode)
 }
 
 void
-brcms_b_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
+brcms_b_read_tsf(struct brcms_c_hw_info *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
 	d11regs_t *regs = wlc_hw->regs;
@@ -3204,7 +3218,7 @@ brcms_b_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
 	return;
 }
 
-static bool brcms_b_validate_chip_access(struct wlc_hw_info *wlc_hw)
+static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw)
 {
 	d11regs_t *regs;
 	u32 w, val;
@@ -3269,7 +3283,7 @@ static bool brcms_b_validate_chip_access(struct wlc_hw_info *wlc_hw)
 
 #define PHYPLL_WAIT_US	100000
 
-void brcms_b_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
+void brcms_b_core_phypll_ctl(struct brcms_c_hw_info *wlc_hw, bool on)
 {
 	d11regs_t *regs;
 	u32 tmp;
@@ -3321,7 +3335,7 @@ void brcms_b_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 	}
 }
 
-void wlc_coredisable(struct wlc_hw_info *wlc_hw)
+void brcms_c_coredisable(struct brcms_c_hw_info *wlc_hw)
 {
 	bool dev_gone;
 
@@ -3359,7 +3373,7 @@ void wlc_coredisable(struct wlc_hw_info *wlc_hw)
 }
 
 /* power both the pll and external oscillator on/off */
-static void brcms_b_xtal(struct wlc_hw_info *wlc_hw, bool want)
+static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d: want %d\n", wlc_hw->unit, want);
 
@@ -3378,9 +3392,9 @@ static void brcms_b_xtal(struct wlc_hw_info *wlc_hw, bool want)
 	}
 }
 
-static void wlc_flushqueues(struct wlc_info *wlc)
+static void wlc_flushqueues(struct brcms_c_info *wlc)
 {
-	struct wlc_hw_info *wlc_hw = wlc->hw;
+	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	uint i;
 
 	wlc->txpend16165war = 0;
@@ -3397,18 +3411,18 @@ static void wlc_flushqueues(struct wlc_info *wlc)
 	dma_rxreclaim(wlc_hw->di[RX_FIFO]);
 }
 
-u16 brcms_b_read_shm(struct wlc_hw_info *wlc_hw, uint offset)
+u16 brcms_b_read_shm(struct brcms_c_hw_info *wlc_hw, uint offset)
 {
 	return brcms_b_read_objmem(wlc_hw, offset, OBJADDR_SHM_SEL);
 }
 
-void brcms_b_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v)
+void brcms_b_write_shm(struct brcms_c_hw_info *wlc_hw, uint offset, u16 v)
 {
 	brcms_b_write_objmem(wlc_hw, offset, v, OBJADDR_SHM_SEL);
 }
 
 static u16
-brcms_b_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
+brcms_b_read_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
@@ -3427,7 +3441,8 @@ brcms_b_read_objmem(struct wlc_hw_info *wlc_hw, uint offset, u32 sel)
 }
 
 static void
-brcms_b_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
+brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, u16 v,
+		     u32 sel)
 {
 	d11regs_t *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
@@ -3448,8 +3463,8 @@ brcms_b_write_objmem(struct wlc_hw_info *wlc_hw, uint offset, u16 v, u32 sel)
  * 'sel' selects the type of memory
  */
 void
-brcms_b_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
-		       int len, u32 sel)
+brcms_b_copyto_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
+		      const void *buf, int len, u32 sel)
 {
 	u16 v;
 	const u8 *p = (const u8 *)buf;
@@ -3470,7 +3485,7 @@ brcms_b_copyto_objmem(struct wlc_hw_info *wlc_hw, uint offset, const void *buf,
  * 'sel' selects the type of memory
  */
 void
-brcms_b_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
+brcms_b_copyfrom_objmem(struct brcms_c_hw_info *wlc_hw, uint offset, void *buf,
 			 int len, u32 sel)
 {
 	u16 v;
@@ -3487,7 +3502,8 @@ brcms_b_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset, void *buf,
 	}
 }
 
-void brcms_b_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
+void brcms_b_copyfrom_vars(struct brcms_c_hw_info *wlc_hw, char **buf,
+			   uint *len)
 {
 	BCMMSG(wlc_hw->wlc->wiphy, "nvram vars totlen=%d\n",
 		wlc_hw->vars_size);
@@ -3496,7 +3512,7 @@ void brcms_b_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf, uint *len)
 	*len = wlc_hw->vars_size;
 }
 
-void brcms_b_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
+void brcms_b_retrylimit_upd(struct brcms_c_hw_info *wlc_hw, u16 SRL, u16 LRL)
 {
 	wlc_hw->SRL = SRL;
 	wlc_hw->LRL = LRL;
@@ -3514,7 +3530,7 @@ void brcms_b_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL, u16 LRL)
 	}
 }
 
-void brcms_b_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
+void brcms_b_pllreq(struct brcms_c_hw_info *wlc_hw, bool set, mbool req_bit)
 {
 	if (set) {
 		if (mboolisset(wlc_hw->pllreq, req_bit))
@@ -3543,7 +3559,7 @@ void brcms_b_pllreq(struct wlc_hw_info *wlc_hw, bool set, mbool req_bit)
 	return;
 }
 
-u16 brcms_b_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
+u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate)
 {
 	u16 table_ptr;
 	u8 phy_rate, index;
@@ -3567,7 +3583,7 @@ u16 brcms_b_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate)
 	return 2 * brcms_b_read_shm(wlc_hw, table_ptr + (index * 2));
 }
 
-void brcms_b_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail)
+void brcms_b_antsel_set(struct brcms_c_hw_info *wlc_hw, u32 antsel_avail)
 {
 	wlc_hw->antsel_avail = antsel_avail;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index fe94685..693d342 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -19,7 +19,7 @@
 #include <brcmu_wifi.h>
 #include "types.h"
 
-/* dup state between BMAC(struct wlc_hw_info) and HIGH(struct wlc_info)
+/* dup state between BMAC(struct brcms_c_hw_info) and HIGH(struct brcms_c_info)
    driver */
 struct brcms_b_state {
 	u32 machwcap;	/* mac hw capibility */
@@ -71,100 +71,104 @@ enum {
 	IOV_BMAC_LAST
 };
 
-extern int brcms_b_attach(struct wlc_info *wlc, u16 vendor, u16 device,
+extern int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 			   uint unit, bool piomode, void *regsva, uint bustype,
 			   void *btparam);
-extern int brcms_b_detach(struct wlc_info *wlc);
+extern int brcms_b_detach(struct brcms_c_info *wlc);
 extern void brcms_b_watchdog(void *arg);
 
 /* up/down, reset, clk */
-extern void brcms_b_copyto_objmem(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_copyto_objmem(struct brcms_c_hw_info *wlc_hw,
 				   uint offset, const void *buf, int len,
 				   u32 sel);
-extern void brcms_b_copyfrom_objmem(struct wlc_hw_info *wlc_hw, uint offset,
+extern void brcms_b_copyfrom_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
 				     void *buf, int len, u32 sel);
 #define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
 	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
 #define brcms_b_copyto_shm(wlc_hw, offset, buf, len)                   \
 	brcms_b_copyto_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
 
-extern void brcms_b_core_phypll_reset(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on);
-extern void brcms_b_phyclk_fgc(struct wlc_hw_info *wlc_hw, bool clk);
-extern void brcms_b_macphyclk_set(struct wlc_hw_info *wlc_hw, bool clk);
-extern void brcms_b_phy_reset(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_corereset(struct wlc_hw_info *wlc_hw, u32 flags);
-extern void brcms_b_reset(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_init(struct wlc_hw_info *wlc_hw, chanspec_t chanspec,
+extern void brcms_b_core_phypll_reset(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_core_phypll_ctl(struct brcms_c_hw_info *wlc_hw, bool on);
+extern void brcms_b_phyclk_fgc(struct brcms_c_hw_info *wlc_hw, bool clk);
+extern void brcms_b_macphyclk_set(struct brcms_c_hw_info *wlc_hw, bool clk);
+extern void brcms_b_phy_reset(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags);
+extern void brcms_b_reset(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_init(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 			  bool mute);
-extern int brcms_b_up_prep(struct wlc_hw_info *wlc_hw);
-extern int brcms_b_up_finish(struct wlc_hw_info *wlc_hw);
-extern int brcms_b_bmac_down_prep(struct wlc_hw_info *wlc_hw);
-extern int brcms_b_down_finish(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_switch_macfreq(struct wlc_hw_info *wlc_hw, u8 spurmode);
+extern int brcms_b_up_prep(struct brcms_c_hw_info *wlc_hw);
+extern int brcms_b_up_finish(struct brcms_c_hw_info *wlc_hw);
+extern int brcms_b_bmac_down_prep(struct brcms_c_hw_info *wlc_hw);
+extern int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode);
 
 /* chanspec, ucode interface */
-extern void brcms_b_set_chanspec(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw,
 				  chanspec_t chanspec,
 				  bool mute, struct txpwr_limits *txpwr);
 
-extern int brcms_b_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo,
+extern int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
 				   uint *blocks);
-extern void brcms_b_mhf(struct wlc_hw_info *wlc_hw, u8 idx, u16 mask,
+extern void brcms_b_mhf(struct brcms_c_hw_info *wlc_hw, u8 idx, u16 mask,
 			 u16 val, int bands);
-extern void brcms_b_mctrl(struct wlc_hw_info *wlc_hw, u32 mask, u32 val);
-extern u16 brcms_b_mhf_get(struct wlc_hw_info *wlc_hw, u8 idx, int bands);
-extern void brcms_b_txant_set(struct wlc_hw_info *wlc_hw, u16 phytxant);
-extern u16 brcms_b_get_txant(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_antsel_type_set(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val);
+extern u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands);
+extern void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant);
+extern u16 brcms_b_get_txant(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw,
 				     u8 antsel_type);
-extern int brcms_b_state_get(struct wlc_hw_info *wlc_hw,
+extern int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw,
 			      brcms_b_state_t *state);
-extern void brcms_b_write_shm(struct wlc_hw_info *wlc_hw, uint offset, u16 v);
-extern u16 brcms_b_read_shm(struct wlc_hw_info *wlc_hw, uint offset);
-extern void brcms_b_write_template_ram(struct wlc_hw_info *wlc_hw, int offset,
-					int len, void *buf);
-extern void brcms_b_copyfrom_vars(struct wlc_hw_info *wlc_hw, char **buf,
+extern void brcms_b_write_shm(struct brcms_c_hw_info *wlc_hw, uint offset,
+			      u16 v);
+extern u16 brcms_b_read_shm(struct brcms_c_hw_info *wlc_hw, uint offset);
+extern void brcms_b_write_template_ram(struct brcms_c_hw_info *wlc_hw,
+				       int offset, int len, void *buf);
+extern void brcms_b_copyfrom_vars(struct brcms_c_hw_info *wlc_hw, char **buf,
 				   uint *len);
 
-extern void brcms_b_hw_etheraddr(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_hw_etheraddr(struct brcms_c_hw_info *wlc_hw,
 				  u8 *ea);
 
-extern bool brcms_b_radio_read_hwdisabled(struct wlc_hw_info *wlc_hw);
-extern void brcms_b_set_shortslot(struct wlc_hw_info *wlc_hw, bool shortslot);
-extern void brcms_b_band_stf_ss_set(struct wlc_hw_info *wlc_hw, u8 stf_mode);
+extern bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw);
+extern void brcms_b_set_shortslot(struct brcms_c_hw_info *wlc_hw,
+				  bool shortslot);
+extern void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw,
+				    u8 stf_mode);
 
-extern void brcms_b_wait_for_wake(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw);
 
-extern void wlc_ucode_wake_override_set(struct wlc_hw_info *wlc_hw,
+extern void wlc_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
 					u32 override_bit);
-extern void wlc_ucode_wake_override_clear(struct wlc_hw_info *wlc_hw,
+extern void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
 					  u32 override_bit);
 
-extern void brcms_b_set_addrmatch(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw,
 				   int match_reg_offset,
 				   const u8 *addr);
-extern void brcms_b_write_hw_bcntemplates(struct wlc_hw_info *wlc_hw,
+extern void brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw,
 					   void *bcn, int len, bool both);
 
-extern void brcms_b_read_tsf(struct wlc_hw_info *wlc_hw, u32 *tsf_l_ptr,
+extern void brcms_b_read_tsf(struct brcms_c_hw_info *wlc_hw, u32 *tsf_l_ptr,
 			      u32 *tsf_h_ptr);
-extern void brcms_b_set_cwmin(struct wlc_hw_info *wlc_hw, u16 newmin);
-extern void brcms_b_set_cwmax(struct wlc_hw_info *wlc_hw, u16 newmax);
+extern void brcms_b_set_cwmin(struct brcms_c_hw_info *wlc_hw, u16 newmin);
+extern void brcms_b_set_cwmax(struct brcms_c_hw_info *wlc_hw, u16 newmax);
 
-extern void brcms_b_retrylimit_upd(struct wlc_hw_info *wlc_hw, u16 SRL,
+extern void brcms_b_retrylimit_upd(struct brcms_c_hw_info *wlc_hw, u16 SRL,
 				    u16 LRL);
 
-extern void brcms_b_fifoerrors(struct wlc_hw_info *wlc_hw);
+extern void brcms_b_fifoerrors(struct brcms_c_hw_info *wlc_hw);
 
 
 /* API for BMAC driver (e.g. wlc_phy.c etc) */
 
-extern void brcms_b_bw_set(struct wlc_hw_info *wlc_hw, u16 bw);
-extern void brcms_b_pllreq(struct wlc_hw_info *wlc_hw, bool set,
+extern void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw);
+extern void brcms_b_pllreq(struct brcms_c_hw_info *wlc_hw, bool set,
 			    mbool req_bit);
-extern void brcms_b_hw_up(struct wlc_hw_info *wlc_hw);
-extern u16 brcms_b_rate_shm_offset(struct wlc_hw_info *wlc_hw, u8 rate);
-extern void brcms_b_antsel_set(struct wlc_hw_info *wlc_hw, u32 antsel_avail);
+extern void brcms_b_hw_up(struct brcms_c_hw_info *wlc_hw);
+extern u16 brcms_b_rate_shm_offset(struct brcms_c_hw_info *wlc_hw, u8 rate);
+extern void brcms_b_antsel_set(struct brcms_c_hw_info *wlc_hw,
+			       u32 antsel_avail);
 
 #endif /* _BRCM_BOTTOM_MAC_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 9ed7a87..6101575 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -40,7 +40,7 @@ typedef struct wlc_cm_band {
 
 struct wlc_cm_info {
 	struct wlc_pub *pub;
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 	char srom_ccode[WLC_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
 	const country_info_t *country;	/* current country def */
@@ -77,13 +77,13 @@ static bool wlc_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val);
 static bool wlc_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit,
 					uint val);
 static bool wlc_valid_channel20(wlc_cm_info_t *wlc_cm, uint val);
-static const country_info_t *wlc_country_lookup(struct wlc_info *wlc,
+static const country_info_t *wlc_country_lookup(struct brcms_c_info *wlc,
 						const char *ccode);
 static void wlc_locale_get_channels(const locale_info_t *locale,
 				    chanvec_t *valid_channels);
 static const locale_info_t *wlc_get_locale_2g(u8 locale_idx);
 static const locale_info_t *wlc_get_locale_5g(u8 locale_idx);
-static bool wlc_japan(struct wlc_info *wlc);
+static bool wlc_japan(struct brcms_c_info *wlc);
 static bool wlc_japan_ccode(const char *ccode);
 static void wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *
 								 wlc_cm,
@@ -611,7 +611,7 @@ static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
+wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	wlc_cm_info_t *wlc_cm;
 	char country_abbrev[WLC_CNTRY_BUF_SZ];
@@ -718,7 +718,7 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 {
 	const locale_mimo_info_t *li_mimo;
 	const locale_info_t *locale;
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	char prev_country_abbrev[WLC_CNTRY_BUF_SZ];
 
 	/* save current country state */
@@ -735,12 +735,12 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 	/* disable/restore nmode based on country regulations */
 	li_mimo = wlc_get_mimo_2g(country->locale_mimo_2G);
 	if (li_mimo && (li_mimo->flags & WLC_NO_MIMO)) {
-		wlc_set_nmode(wlc, OFF);
+		brcms_c_set_nmode(wlc, OFF);
 		wlc->stf->no_cddstbc = true;
 	} else {
 		wlc->stf->no_cddstbc = false;
 		if (N_ENAB(wlc->pub) != wlc->protection->nmode_user)
-			wlc_set_nmode(wlc, wlc->protection->nmode_user);
+			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 	}
 
 	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
@@ -748,9 +748,9 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 	/* set or restore gmode as required by regulatory */
 	locale = wlc_get_locale_2g(country->locale_2G);
 	if (locale && (locale->flags & WLC_NO_OFDM)) {
-		wlc_set_gmode(wlc, GMODE_LEGACY_B, false);
+		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
 	} else {
-		wlc_set_gmode(wlc, wlc->protection->gmode_user, false);
+		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 	}
 
 	wlc_channels_init(wlc_cm, country);
@@ -761,7 +761,7 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 /* Lookup a country info structure from a null terminated country code
  * The lookup is case sensitive.
  */
-static const country_info_t *wlc_country_lookup(struct wlc_info *wlc,
+static const country_info_t *wlc_country_lookup(struct brcms_c_info *wlc,
 					 const char *ccode)
 {
 	const country_info_t *country;
@@ -780,7 +780,7 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 						 char *mapped_ccode,
 						 uint *mapped_regrev)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	const country_info_t *country;
 	uint srom_regrev = wlc_cm->srom_regrev;
 	const char *srom_ccode = wlc_cm->srom_ccode;
@@ -859,9 +859,9 @@ static const country_info_t *wlc_country_lookup_direct(const char *ccode,
 static int
 wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
-	struct wlcband *band;
+	struct brcms_c_band *band;
 	const locale_info_t *li;
 	chanvec_t sup_chan;
 	const locale_mimo_info_t *li_mimo;
@@ -911,7 +911,7 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
  */
 static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint chan;
 	struct txpwr_limits txpwr;
 
@@ -960,9 +960,9 @@ static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 /* reset the quiet channels vector to the union of the restricted and radar channel sets */
 static void wlc_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
-	struct wlcband *band;
+	struct brcms_c_band *band;
 	const chanvec_t *chanvec;
 
 	memset(&wlc_cm->quiet_channels, 0, sizeof(chanvec_t));
@@ -998,7 +998,7 @@ static bool wlc_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
  */
 static bool wlc_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 
 	return VALID_CHANNEL20(wlc, val) ||
 		(!wlc->bandlocked
@@ -1016,7 +1016,7 @@ wlc_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit, uint val)
 /* Is the channel valid for the current locale and current band? */
 static bool wlc_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 
 	return ((val < MAXCHANNEL) &&
 		isset(wlc_cm->bandstate[wlc->band->bandunit].valid_channels.vec,
@@ -1114,7 +1114,7 @@ void
 wlc_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 			 u8 local_constraint_qdbm)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	struct txpwr_limits txpwr;
 
 	wlc_channel_reg_limits(wlc_cm, chanspec, &txpwr);
@@ -1248,13 +1248,13 @@ void
 wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 		       txpwr_limits_t *txpwr)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i;
 	uint chan;
 	int maxpwr;
 	int delta;
 	const country_info_t *country;
-	struct wlcband *band;
+	struct brcms_c_band *band;
 	const locale_info_t *li;
 	int conducted_max;
 	int conducted_ofdm_max;
@@ -1458,7 +1458,7 @@ wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 }
 
 /* Returns true if currently set country is Japan or variant */
-static bool wlc_japan(struct wlc_info *wlc)
+static bool wlc_japan(struct brcms_c_info *wlc)
 {
 	return wlc_japan_ccode(wlc->cmi->country_abbrev);
 }
@@ -1477,7 +1477,7 @@ static bool wlc_japan_ccode(const char *ccode)
 static bool
 wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 {
-	struct wlc_info *wlc = wlc_cm->wlc;
+	struct brcms_c_info *wlc = wlc_cm->wlc;
 	u8 channel = CHSPEC_CHANNEL(chspec);
 
 	/* check the chanspec */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index dd0149a..e743392 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -20,7 +20,7 @@
 #define WLC_TXPWR_DB_FACTOR 4	/* conversion for phy txpwr cacluations that use .25 dB units */
 
 
-struct wlc_info;
+struct brcms_c_info;
 
 /* maxpwr mapping to 5GHz band channels:
  * maxpwr[0] - channels [34-48]
@@ -105,7 +105,7 @@ struct country_info {
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
 
-extern wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc);
+extern wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc);
 extern void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm);
 
 extern u8 wlc_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm,
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index ecad659..8001bee 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -165,7 +165,7 @@ static void brcms_ops_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		kfree_skb(skb);
 		goto done;
 	}
-	wlc_sendpkt_mac80211(wl->wlc, skb, hw);
+	brcms_c_sendpkt_mac80211(wl->wlc, skb, hw);
  done:
 	UNLOCK(wl);
 }
@@ -248,7 +248,7 @@ ieee_set_channel(struct ieee80211_hw *hw, struct ieee80211_channel *chan,
 	switch (type) {
 	case NL80211_CHAN_HT20:
 	case NL80211_CHAN_NO_HT:
-		err = wlc_set(wl->wlc, WLC_SET_CHANNEL, chan->hw_value);
+		err = brcms_c_set(wl->wlc, WLC_SET_CHANNEL, chan->hw_value);
 		break;
 	case NL80211_CHAN_HT40MINUS:
 	case NL80211_CHAN_HT40PLUS:
@@ -273,14 +273,14 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 
 	LOCK(wl);
 	if (changed & IEEE80211_CONF_CHANGE_LISTEN_INTERVAL) {
-		if (wlc_set_par(wl->wlc, IOV_BCN_LI_BCN, conf->listen_interval)
-		    < 0) {
+		if (brcms_c_set_par(wl->wlc, IOV_BCN_LI_BCN,
+				    conf->listen_interval) < 0) {
 			wiphy_err(wiphy, "%s: Error setting listen_interval\n",
 				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		wlc_get_par(wl->wlc, IOV_BCN_LI_BCN, &new_int);
+		brcms_c_get_par(wl->wlc, IOV_BCN_LI_BCN, &new_int);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_MONITOR)
 		wiphy_err(wiphy, "%s: change monitor mode: %s (implement)\n",
@@ -292,14 +292,14 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 			  "true" : "false");
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-		if (wlc_set_par(wl->wlc, IOV_QTXPOWER, conf->power_level * 4)
-				< 0) {
+		if (brcms_c_set_par(wl->wlc, IOV_QTXPOWER,
+				    conf->power_level * 4) < 0) {
 			wiphy_err(wiphy, "%s: Error setting power_level\n",
 				  __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		wlc_get_par(wl->wlc, IOV_QTXPOWER, &new_int);
+		brcms_c_get_par(wl->wlc, IOV_QTXPOWER, &new_int);
 		if (new_int != (conf->power_level * 4))
 			wiphy_err(wiphy, "%s: Power level req != actual, %d %d"
 				  "\n", __func__, conf->power_level * 4,
@@ -309,15 +309,15 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
 	}
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		if (wlc_set
+		if (brcms_c_set
 		    (wl->wlc, WLC_SET_SRL,
 		     conf->short_frame_max_tx_count) < 0) {
 			wiphy_err(wiphy, "%s: Error setting srl\n", __func__);
 			err = -EIO;
 			goto config_out;
 		}
-		if (wlc_set(wl->wlc, WLC_SET_LRL, conf->long_frame_max_tx_count)
-		    < 0) {
+		if (brcms_c_set(wl->wlc, WLC_SET_LRL,
+				conf->long_frame_max_tx_count) < 0) {
 			wiphy_err(wiphy, "%s: Error setting lrl\n", __func__);
 			err = -EIO;
 			goto config_out;
@@ -345,7 +345,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		wiphy_err(wiphy, "%s: %s: %sassociated\n", KBUILD_MODNAME,
 			  __func__, info->assoc ? "" : "dis");
 		LOCK(wl);
-		wlc_associate_upd(wl->wlc, info->assoc);
+		brcms_c_associate_upd(wl->wlc, info->assoc);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -355,7 +355,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		else
 			val = 0;
 		LOCK(wl);
-		wlc_set(wl->wlc, WLC_SET_SHORTSLOT_OVERRIDE, val);
+		brcms_c_set(wl->wlc, WLC_SET_SHORTSLOT_OVERRIDE, val);
 		UNLOCK(wl);
 	}
 
@@ -364,11 +364,11 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 		u16 mode = info->ht_operation_mode;
 
 		LOCK(wl);
-		wlc_protection_upd(wl->wlc, WLC_PROT_N_CFG,
+		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_CFG,
 			mode & IEEE80211_HT_OP_MODE_PROTECTION);
-		wlc_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
+		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_NONGF,
 			mode & IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT);
-		wlc_protection_upd(wl->wlc, WLC_PROT_N_OBSS,
+		brcms_c_protection_upd(wl->wlc, WLC_PROT_N_OBSS,
 			mode & IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT);
 		UNLOCK(wl);
 	}
@@ -381,7 +381,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* retrieve the current rates */
 		LOCK(wl);
-		error = wlc_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
+		error = brcms_c_ioctl(wl->wlc, WLC_GET_CURR_RATESET,
 				  &rs, sizeof(rs), NULL);
 		UNLOCK(wl);
 		if (error) {
@@ -390,7 +390,7 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 			return;
 		}
 		br_mask = info->basic_rates;
-		bi = hw->wiphy->bands[wlc_get_curband(wl->wlc)];
+		bi = hw->wiphy->bands[brcms_c_get_curband(wl->wlc)];
 		for (i = 0; i < bi->n_bitrates; i++) {
 			/* convert to internal rate value */
 			rate = (bi->bitrates[i].bitrate << 1) / 10;
@@ -402,19 +402,19 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 
 		/* update the rate set */
 		LOCK(wl);
-		wlc_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
+		brcms_c_ioctl(wl->wlc, WLC_SET_RATESET, &rs, sizeof(rs), NULL);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BEACON_INT) {
 		/* Beacon interval changed */
 		LOCK(wl);
-		wlc_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
+		brcms_c_set(wl->wlc, WLC_SET_BCNPRD, info->beacon_int);
 		UNLOCK(wl);
 	}
 	if (changed & BSS_CHANGED_BSSID) {
 		/* BSSID changed, for whatever reason (IBSS and managed mode) */
 		LOCK(wl);
-		wlc_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
+		brcms_c_set_addrmatch(wl->wlc, RCM_BSSID_OFFSET,
 				  info->bssid);
 		UNLOCK(wl);
 	}
@@ -486,9 +486,9 @@ brcms_ops_configure_filter(struct ieee80211_hw *hw,
 		LOCK(wl);
 		if (*total_flags & FIF_BCN_PRBRESP_PROMISC) {
 			wl->pub->mac80211_state |= MAC80211_PROMISC_BCNS;
-			wlc_mac_bcn_promisc_change(wl->wlc, 1);
+			brcms_c_mac_bcn_promisc_change(wl->wlc, 1);
 		} else {
-			wlc_mac_bcn_promisc_change(wl->wlc, 0);
+			brcms_c_mac_bcn_promisc_change(wl->wlc, 0);
 			wl->pub->mac80211_state &= ~MAC80211_PROMISC_BCNS;
 		}
 		UNLOCK(wl);
@@ -506,7 +506,7 @@ static void brcms_ops_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
 	LOCK(wl);
-	wlc_scan_start(wl->wlc);
+	brcms_c_scan_start(wl->wlc);
 	UNLOCK(wl);
 	return;
 }
@@ -515,7 +515,7 @@ static void brcms_ops_sw_scan_complete(struct ieee80211_hw *hw)
 {
 	struct brcms_info *wl = hw->priv;
 	LOCK(wl);
-	wlc_scan_stop(wl->wlc);
+	brcms_c_scan_stop(wl->wlc);
 	UNLOCK(wl);
 	return;
 }
@@ -563,7 +563,7 @@ brcms_ops_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	struct brcms_info *wl = hw->priv;
 
 	LOCK(wl);
-	wlc_wme_setparams(wl->wlc, queue, params, true);
+	brcms_c_wme_setparams(wl->wlc, queue, params, true);
 	UNLOCK(wl);
 
 	return 0;
@@ -637,7 +637,7 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		LOCK(wl);
-		status = wlc_aggregatable(wl->wlc, tid);
+		status = brcms_c_aggregatable(wl->wlc, tid);
 		UNLOCK(wl);
 		if (!status) {
 			wiphy_err(wl->wiphy, "START: tid %d is not agg\'able\n",
@@ -673,7 +673,7 @@ static void brcms_ops_rfkill_poll(struct ieee80211_hw *hw)
 	bool blocked;
 
 	LOCK(wl);
-	blocked = wlc_check_radio_disabled(wl->wlc);
+	blocked = brcms_c_check_radio_disabled(wl->wlc);
 	UNLOCK(wl);
 
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
@@ -687,7 +687,7 @@ static void brcms_ops_flush(struct ieee80211_hw *hw, bool drop)
 
 	/* wait for packet queue and dma fifos to run empty */
 	LOCK(wl);
-	wlc_wait_for_tx_completion(wl->wlc, drop);
+	brcms_c_wait_for_tx_completion(wl->wlc, drop);
 	UNLOCK(wl);
 }
 
@@ -797,7 +797,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	}
 
 	/* common load-time initialization */
-	wl->wlc = wlc_attach((void *)wl, vendor, device, unit, false,
+	wl->wlc = brcms_c_attach((void *)wl, vendor, device, unit, false,
 			     wl->regsva, wl->bcm_bustype, btparam, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
@@ -805,11 +805,11 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 			  KBUILD_MODNAME, err);
 		goto fail;
 	}
-	wl->pub = wlc_pub(wl->wlc);
+	wl->pub = brcms_c_pub(wl->wlc);
 
 	wl->pub->ieee_hw = hw;
 
-	if (wlc_set_par(wl->wlc, IOV_MPC, 0) < 0) {
+	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0) {
 		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
 			  unit);
 	}
@@ -822,7 +822,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	wl->irq = irq;
 
 	/* register module */
-	wlc_module_register(wl->pub, "linux", wl, wl_linux_watchdog, NULL);
+	brcms_c_module_register(wl->pub, "linux", wl, wl_linux_watchdog, NULL);
 
 	if (ieee_hw_init(hw)) {
 		wiphy_err(wl->wiphy, "wl%d: %s: ieee_hw_init failed!\n", unit,
@@ -1040,9 +1040,8 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	hw->wiphy->bands[IEEE80211_BAND_2GHZ] = NULL;
 	hw->wiphy->bands[IEEE80211_BAND_5GHZ] = NULL;
 
-	if (wlc_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0) {
+	if (brcms_c_get(wl->wlc, WLC_GET_PHYLIST, (int *)&phy_list) < 0)
 		wiphy_err(hw->wiphy, "Phy list failed\n");
-	}
 
 	if (phy_list[0] == 'n' || phy_list[0] == 'c') {
 		if (phy_list[0] == 'c') {
@@ -1078,7 +1077,7 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
 	    | IEEE80211_HW_REPORTS_TX_ACK_STATUS
 	    | IEEE80211_HW_AMPDU_AGGREGATION;
 
-	hw->extra_tx_headroom = wlc_get_header_len();
+	hw->extra_tx_headroom = brcms_c_get_header_len();
 	hw->queues = N_TX_QUEUES;
 	/* FIXME: this doesn't seem to be used properly in minstrel_ht.
 	 * mac80211/status.c:ieee80211_tx_status() checks this value,
@@ -1239,7 +1238,7 @@ static void brcms_remove(struct pci_dev *pdev)
 	}
 
 	LOCK(wl);
-	status = wlc_chipmatch(pdev->vendor, pdev->device);
+	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
 	UNLOCK(wl);
 	if (!status) {
 		wiphy_err(wl->wiphy, "wl: brcms_remove: wlc_chipmatch "
@@ -1337,12 +1336,12 @@ static void brcms_free(struct brcms_info *wl)
 	tasklet_kill(&wl->tasklet);
 
 	if (wl->pub) {
-		wlc_module_unregister(wl->pub, "linux", wl);
+		brcms_c_module_unregister(wl->pub, "linux", wl);
 	}
 
 	/* free common resources */
 	if (wl->wlc) {
-		wlc_detach(wl->wlc);
+		brcms_c_detach(wl->wlc);
 		wl->wlc = NULL;
 		wl->pub = NULL;
 	}
@@ -1407,7 +1406,7 @@ void brcms_init(struct brcms_info *wl)
 	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
 	brcms_reset(wl);
 
-	wlc_init(wl->wlc);
+	brcms_c_init(wl->wlc);
 }
 
 /*
@@ -1416,7 +1415,7 @@ void brcms_init(struct brcms_info *wl)
 uint brcms_reset(struct brcms_info *wl)
 {
 	BCMMSG(WL_TO_HW(wl)->wiphy, "wl%d\n", wl->pub->unit);
-	wlc_reset(wl->wlc);
+	brcms_c_reset(wl->wlc);
 
 	/* dpc will not be rescheduled */
 	wl->resched = 0;
@@ -1433,7 +1432,7 @@ void brcms_intrson(struct brcms_info *wl)
 	unsigned long flags;
 
 	INT_LOCK(wl, flags);
-	wlc_intrson(wl->wlc);
+	brcms_c_intrson(wl->wlc);
 	INT_UNLOCK(wl, flags);
 }
 
@@ -1451,7 +1450,7 @@ u32 brcms_intrsoff(struct brcms_info *wl)
 	u32 status;
 
 	INT_LOCK(wl, flags);
-	status = wlc_intrsoff(wl->wlc);
+	status = brcms_c_intrsoff(wl->wlc);
 	INT_UNLOCK(wl, flags);
 	return status;
 }
@@ -1461,7 +1460,7 @@ void brcms_intrsrestore(struct brcms_info *wl, u32 macintmask)
 	unsigned long flags;
 
 	INT_LOCK(wl, flags);
-	wlc_intrsrestore(wl->wlc, macintmask);
+	brcms_c_intrsrestore(wl->wlc, macintmask);
 	INT_UNLOCK(wl, flags);
 }
 
@@ -1475,7 +1474,7 @@ int brcms_up(struct brcms_info *wl)
 	if (wl->pub->up)
 		return 0;
 
-	error = wlc_up(wl->wlc);
+	error = brcms_c_up(wl->wlc);
 
 	return error;
 }
@@ -1488,7 +1487,7 @@ void brcms_down(struct brcms_info *wl)
 	uint callbacks, ret_val = 0;
 
 	/* call common down function */
-	ret_val = wlc_down(wl->wlc);
+	ret_val = brcms_c_down(wl->wlc);
 	callbacks = atomic_read(&wl->callbacks) - ret_val;
 
 	/* wait for down callbacks to complete */
@@ -1513,7 +1512,7 @@ static irqreturn_t brcms_isr(int irq, void *dev_id)
 	ISR_LOCK(wl, flags);
 
 	/* call common first level interrupt handler */
-	ours = wlc_isr(wl->wlc, &wantdpc);
+	ours = brcms_c_isr(wl->wlc, &wantdpc);
 	if (ours) {
 		/* if more to do... */
 		if (wantdpc) {
@@ -1543,14 +1542,14 @@ static void brcms_dpc(unsigned long data)
 			unsigned long flags;
 
 			INT_LOCK(wl, flags);
-			wlc_intrsupd(wl->wlc);
+			brcms_c_intrsupd(wl->wlc);
 			INT_UNLOCK(wl, flags);
 		}
 
-		wl->resched = wlc_dpc(wl->wlc, true);
+		wl->resched = brcms_c_dpc(wl->wlc, true);
 	}
 
-	/* wlc_dpc() may bring the driver down */
+	/* brcms_c_dpc() may bring the driver down */
 	if (!wl->pub->up)
 		goto done;
 
@@ -1913,7 +1912,7 @@ int brcms_check_firmwares(struct brcms_info *wl)
  */
 bool brcms_rfkill_set_hw_state(struct brcms_info *wl)
 {
-	bool blocked = wlc_check_radio_disabled(wl->wlc);
+	bool blocked = brcms_c_check_radio_disabled(wl->wlc);
 
 	UNLOCK(wl);
 	wiphy_rfkill_set_hw_state(wl->pub->ieee_hw->wiphy, blocked);
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 6227455..71526b2 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -85,7 +85,7 @@ struct brcms_info {
 /* misc callbacks */
 struct brcms_info;
 struct brcms_if;
-struct wlc_if;
+struct brcms_c_if;
 extern void brcms_init(struct brcms_info *wl);
 extern uint brcms_reset(struct brcms_info *wl);
 extern void brcms_intrson(struct brcms_info *wl);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 34438ac..a8f36f2 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -195,7 +195,7 @@ uint brcm_msg_level =
 
 #ifdef BCMDBG
 /* pointer to most recently allocated wl/wlc */
-static struct wlc_info *wlc_info_dbg = (struct wlc_info *) (NULL);
+static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 #endif
 
 const u8 prio2fifo[NUMPRIO] = {
@@ -253,7 +253,7 @@ const u8 wlc_prio2prec_map[] = {
 #define BSSCFG_IBSS(cfg)	(!(cfg)->BSS)
 
 /* Iterator for "associated" STA bss configs:
-   (struct wlc_info *wlc, int idx, struct wlc_bsscfg *cfg) */
+   (struct brcms_c_info *wlc, int idx, struct brcms_c_bsscfg *cfg) */
 #define FOREACH_AS_STA(wlc, idx, cfg) \
 	for (idx = 0; (int) idx < WLC_MAXBSSCFG; idx++) \
 		if ((cfg = (wlc)->bsscfg[idx]) && BSSCFG_STA(cfg) && cfg->associated)
@@ -304,7 +304,7 @@ static const u8 acbitmap2maxprio[] = {
 #define WLC_REPLAY_CNTRS_VALUE	WPA_CAP_16_REPLAY_CNTRS
 
 /* local prototypes */
-static u16 wlc_d11hdrs_mac80211(struct wlc_info *wlc,
+static u16 wlc_d11hdrs_mac80211(struct brcms_c_info *wlc,
 					       struct ieee80211_hw *hw,
 					       struct sk_buff *p,
 					       struct scb *scb, uint frag,
@@ -312,78 +312,80 @@ static u16 wlc_d11hdrs_mac80211(struct wlc_info *wlc,
 					       uint next_frag_len,
 					       wsec_key_t *key,
 					       ratespec_t rspec_override);
-static void wlc_bss_default_init(struct wlc_info *wlc);
-static void wlc_ucode_mac_upd(struct wlc_info *wlc);
-static ratespec_t mac80211_wlc_set_nrate(struct wlc_info *wlc,
-					 struct wlcband *cur_band, u32 int_val);
-static void wlc_tx_prec_map_init(struct wlc_info *wlc);
+static void wlc_bss_default_init(struct brcms_c_info *wlc);
+static void wlc_ucode_mac_upd(struct brcms_c_info *wlc);
+static ratespec_t mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
+					 struct brcms_c_band *cur_band,
+					 u32 int_val);
+static void wlc_tx_prec_map_init(struct brcms_c_info *wlc);
 static void wlc_watchdog(void *arg);
 static void wlc_watchdog_by_timer(void *arg);
-static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate);
-static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg);
-static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc);
+static u16 wlc_rate_shm_offset(struct brcms_c_info *wlc, u8 rate);
+static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg);
+static u8 wlc_local_constraint_qdbm(struct brcms_c_info *wlc);
 
 /* send and receive */
-static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc);
-static void wlc_txq_free(struct wlc_info *wlc,
-			 struct wlc_txq_info *qi);
-static void wlc_txflowcontrol_signal(struct wlc_info *wlc,
-				     struct wlc_txq_info *qi,
+static struct brcms_c_txq_info *wlc_txq_alloc(struct brcms_c_info *wlc);
+static void wlc_txq_free(struct brcms_c_info *wlc,
+			 struct brcms_c_txq_info *qi);
+static void wlc_txflowcontrol_signal(struct brcms_c_info *wlc,
+				     struct brcms_c_txq_info *qi,
 				     bool on, int prio);
-static void wlc_txflowcontrol_reset(struct wlc_info *wlc);
-static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rate,
+static void wlc_txflowcontrol_reset(struct brcms_c_info *wlc);
+static void wlc_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rate,
 				 uint length, u8 *plcp);
 static void wlc_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
 static void wlc_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
-static u16 wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate,
+static u16 wlc_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
 				    u8 preamble_type, uint next_frag_len);
-static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh);
-static void wlc_recvctl(struct wlc_info *wlc,
+static u64 wlc_recover_tsf64(struct brcms_c_info *wlc,
+			     struct wlc_d11rxhdr *rxh);
+static void wlc_recvctl(struct brcms_c_info *wlc,
 			d11rxhdr_t *rxh, struct sk_buff *p);
-static uint wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t rate,
+static uint wlc_calc_frame_len(struct brcms_c_info *wlc, ratespec_t rate,
 			       u8 preamble_type, uint dur);
-static uint wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rate,
+static uint wlc_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rate,
 			      u8 preamble_type);
-static uint wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rate,
+static uint wlc_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rate,
 			      u8 preamble_type);
 /* interrupt, up/down, band */
-static void wlc_setband(struct wlc_info *wlc, uint bandunit);
-static chanspec_t wlc_init_chanspec(struct wlc_info *wlc);
-static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec);
-static void wlc_bsinit(struct wlc_info *wlc);
-static int wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
-			      bool writeToShm);
-static void wlc_radio_hwdisable_upd(struct wlc_info *wlc);
-static bool wlc_radio_monitor_start(struct wlc_info *wlc);
+static void wlc_setband(struct brcms_c_info *wlc, uint bandunit);
+static chanspec_t wlc_init_chanspec(struct brcms_c_info *wlc);
+static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec);
+static void wlc_bsinit(struct brcms_c_info *wlc);
+static int wlc_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle,
+			      bool isOFDM, bool writeToShm);
+static void wlc_radio_hwdisable_upd(struct brcms_c_info *wlc);
+static bool wlc_radio_monitor_start(struct brcms_c_info *wlc);
 static void wlc_radio_timer(void *arg);
-static void wlc_radio_enable(struct wlc_info *wlc);
-static void wlc_radio_upd(struct wlc_info *wlc);
+static void wlc_radio_enable(struct brcms_c_info *wlc);
+static void wlc_radio_upd(struct brcms_c_info *wlc);
 
 /* scan, association, BSS */
-static uint wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rate,
+static uint wlc_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rate,
 			     u8 preamble_type);
-static void wlc_update_mimo_band_bwcap(struct wlc_info *wlc, u8 bwcap);
-static void wlc_ht_update_sgi_rx(struct wlc_info *wlc, int val);
-static void wlc_ht_update_ldpc(struct wlc_info *wlc, s8 val);
-static void wlc_war16165(struct wlc_info *wlc, bool tx);
-
-static void wlc_wme_retries_write(struct wlc_info *wlc);
-static bool wlc_attach_stf_ant_init(struct wlc_info *wlc);
-static uint wlc_attach_module(struct wlc_info *wlc);
-static void wlc_detach_module(struct wlc_info *wlc);
-static void wlc_timers_deinit(struct wlc_info *wlc);
-static void wlc_down_led_upd(struct wlc_info *wlc);
-static uint wlc_down_del_timer(struct wlc_info *wlc);
-static void wlc_ofdm_rateset_war(struct wlc_info *wlc);
-static int _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
-		      struct wlc_if *wlcif);
+static void wlc_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap);
+static void wlc_ht_update_sgi_rx(struct brcms_c_info *wlc, int val);
+static void wlc_ht_update_ldpc(struct brcms_c_info *wlc, s8 val);
+static void wlc_war16165(struct brcms_c_info *wlc, bool tx);
+
+static void wlc_wme_retries_write(struct brcms_c_info *wlc);
+static bool wlc_attach_stf_ant_init(struct brcms_c_info *wlc);
+static uint wlc_attach_module(struct brcms_c_info *wlc);
+static void wlc_detach_module(struct brcms_c_info *wlc);
+static void wlc_timers_deinit(struct brcms_c_info *wlc);
+static void wlc_down_led_upd(struct brcms_c_info *wlc);
+static uint wlc_down_del_timer(struct brcms_c_info *wlc);
+static void wlc_ofdm_rateset_war(struct brcms_c_info *wlc);
+static int _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+		      struct brcms_c_if *wlcif);
 
 /* conditions under which the PM bit should be set in outgoing frames and STAY_AWAKE is meaningful
  */
-bool wlc_ps_allowed(struct wlc_info *wlc)
+bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 {
 	int idx;
-	struct wlc_bsscfg *cfg;
+	struct brcms_c_bsscfg *cfg;
 
 	/* disallow PS when one of the following global conditions meets */
 	if (!wlc->pub->associated)
@@ -405,12 +407,12 @@ bool wlc_ps_allowed(struct wlc_info *wlc)
 	return true;
 }
 
-void wlc_reset(struct wlc_info *wlc)
+void brcms_c_reset(struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* slurp up hw mac counters before core reset */
-	wlc_statsupd(wlc);
+	brcms_c_statsupd(wlc);
 
 	/* reset our snapshot of macstat counters */
 	memset((char *)wlc->core->macstat_snapshot, 0,
@@ -419,19 +421,19 @@ void wlc_reset(struct wlc_info *wlc)
 	brcms_b_reset(wlc->hw);
 }
 
-void wlc_fatal_error(struct wlc_info *wlc)
+void brcms_c_fatal_error(struct brcms_c_info *wlc)
 {
 	wiphy_err(wlc->wiphy, "wl%d: fatal error, reinitializing\n",
 		  wlc->pub->unit);
 	brcms_init(wlc->wl);
 }
 
-/* Return the channel the driver should initialize during wlc_init.
+/* Return the channel the driver should initialize during brcms_c_init.
  * the channel may have to be changed from the currently configured channel
  * if other configurations are in conflict (bandlocked, 11n mode disabled,
  * invalid channel for current country, etc.)
  */
-static chanspec_t wlc_init_chanspec(struct wlc_info *wlc)
+static chanspec_t wlc_init_chanspec(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec =
 	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
@@ -442,7 +444,7 @@ static chanspec_t wlc_init_chanspec(struct wlc_info *wlc)
 
 struct scb global_scb;
 
-static void wlc_init_scb(struct wlc_info *wlc, struct scb *scb)
+static void wlc_init_scb(struct brcms_c_info *wlc, struct scb *scb)
 {
 	int i;
 	scb->flags = SCB_WMECAP | SCB_HTCAP;
@@ -450,12 +452,12 @@ static void wlc_init_scb(struct wlc_info *wlc, struct scb *scb)
 		scb->seqnum[i] = 0;
 }
 
-void wlc_init(struct wlc_info *wlc)
+void brcms_c_init(struct brcms_c_info *wlc)
 {
 	d11regs_t *regs;
 	chanspec_t chanspec;
 	int i;
-	struct wlc_bsscfg *bsscfg;
+	struct brcms_c_bsscfg *bsscfg;
 	bool mute = false;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
@@ -473,15 +475,15 @@ void wlc_init(struct wlc_info *wlc)
 	brcms_b_init(wlc->hw, chanspec, mute);
 
 	/* update beacon listen interval */
-	wlc_bcn_li_upd(wlc);
+	brcms_c_bcn_li_upd(wlc);
 
 	/* the world is new again, so is our reported rate */
-	wlc_reprate_init(wlc);
+	brcms_c_reprate_init(wlc);
 
 	/* write ethernet address to core */
 	FOREACH_BSS(wlc, i, bsscfg) {
-		wlc_set_mac(bsscfg);
-		wlc_set_bssid(bsscfg);
+		brcms_c_set_mac(bsscfg);
+		brcms_c_set_bssid(bsscfg);
 	}
 
 	/* Update tsf_cfprep if associated and up */
@@ -500,7 +502,7 @@ void wlc_init(struct wlc_info *wlc)
 				      (bi << CFPREP_CBI_SHIFT));
 
 				/* Update maccontrol PM related bits */
-				wlc_set_ps_ctrl(wlc);
+				brcms_c_set_ps_ctrl(wlc);
 
 				break;
 			}
@@ -512,10 +514,10 @@ void wlc_init(struct wlc_info *wlc)
 	wlc_init_scb(wlc, &global_scb);
 
 	/* init probe response timeout */
-	wlc_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
+	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
 
 	/* init max burst txop (framebursting) */
-	wlc_write_shm(wlc, M_MBURST_TXOP,
+	brcms_c_write_shm(wlc, M_MBURST_TXOP,
 		      (wlc->
 		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
 
@@ -532,7 +534,7 @@ void wlc_init(struct wlc_info *wlc)
 	/* Enable EDCF mode (while the MAC is suspended) */
 	if (EDCF_ENAB(wlc->pub)) {
 		OR_REG(&regs->ifs_ctl, IFS_USEEDCF);
-		wlc_edcf_setparams(wlc, false);
+		brcms_c_edcf_setparams(wlc, false);
 	}
 
 	/* Init precedence maps for empty FIFOs */
@@ -541,12 +543,12 @@ void wlc_init(struct wlc_info *wlc)
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
 		wlc->ucode_rev =
-		    wlc_read_shm(wlc, M_BOM_REV_MAJOR) << NBITS(u16);
-		wlc->ucode_rev |= wlc_read_shm(wlc, M_BOM_REV_MINOR);
+		    brcms_c_read_shm(wlc, M_BOM_REV_MAJOR) << NBITS(u16);
+		wlc->ucode_rev |= brcms_c_read_shm(wlc, M_BOM_REV_MINOR);
 	}
 
 	/* ..now really unleash hell (allow the MAC out of suspend) */
-	wlc_enable_mac(wlc);
+	brcms_c_enable_mac(wlc);
 
 	/* clear tx flow control */
 	wlc_txflowcontrol_reset(wlc);
@@ -569,28 +571,28 @@ void wlc_init(struct wlc_info *wlc)
 
 		for (ac = 0; ac < AC_COUNT; ac++) {
 			wlc->wme_retries[ac] =
-			    wlc_read_shm(wlc, M_AC_TXLMT_ADDR(ac));
+			    brcms_c_read_shm(wlc, M_AC_TXLMT_ADDR(ac));
 		}
 	}
 }
 
-void wlc_mac_bcn_promisc_change(struct wlc_info *wlc, bool promisc)
+void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc, bool promisc)
 {
 	wlc->bcnmisc_monitor = promisc;
-	wlc_mac_bcn_promisc(wlc);
+	brcms_c_mac_bcn_promisc(wlc);
 }
 
-void wlc_mac_bcn_promisc(struct wlc_info *wlc)
+void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc)
 {
 	if ((AP_ENAB(wlc->pub) && (N_ENAB(wlc->pub) || wlc->band->gmode)) ||
 	    wlc->bcnmisc_ibss || wlc->bcnmisc_scan || wlc->bcnmisc_monitor)
-		wlc_mctrl(wlc, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
+		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, MCTL_BCNS_PROMISC);
 	else
-		wlc_mctrl(wlc, MCTL_BCNS_PROMISC, 0);
+		brcms_c_mctrl(wlc, MCTL_BCNS_PROMISC, 0);
 }
 
 /* set or clear maccontrol bits MCTL_PROMISC and MCTL_KEEPCONTROL */
-void wlc_mac_promisc(struct wlc_info *wlc)
+void brcms_c_mac_promisc(struct brcms_c_info *wlc)
 {
 	u32 promisc_bits = 0;
 
@@ -603,16 +605,16 @@ void wlc_mac_promisc(struct wlc_info *wlc)
 
 	/* monitor mode needs both MCTL_PROMISC and MCTL_KEEPCONTROL
 	 * Note: monitor mode also needs MCTL_BCNS_PROMISC, but that is
-	 * handled in wlc_mac_bcn_promisc()
+	 * handled in brcms_c_mac_bcn_promisc()
 	 */
 	if (MONITOR_ENAB(wlc))
 		promisc_bits |= MCTL_PROMISC | MCTL_KEEPCONTROL;
 
-	wlc_mctrl(wlc, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
+	brcms_c_mctrl(wlc, MCTL_PROMISC | MCTL_KEEPCONTROL, promisc_bits);
 }
 
 /* push sw hps and wake state through hardware */
-void wlc_set_ps_ctrl(struct wlc_info *wlc)
+void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc)
 {
 	u32 v1, v2;
 	bool hps;
@@ -627,7 +629,7 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
 	if (hps)
 		v2 |= MCTL_HPS;
 
-	wlc_mctrl(wlc, MCTL_WAKE | MCTL_HPS, v2);
+	brcms_c_mctrl(wlc, MCTL_WAKE | MCTL_HPS, v2);
 
 	awake_before = ((v1 & MCTL_WAKE) || ((v1 & MCTL_HPS) == 0));
 
@@ -640,14 +642,14 @@ void wlc_set_ps_ctrl(struct wlc_info *wlc)
  * Write this BSS config's MAC address to core.
  * Updates RXE match engine.
  */
-int wlc_set_mac(struct wlc_bsscfg *cfg)
+int brcms_c_set_mac(struct brcms_c_bsscfg *cfg)
 {
 	int err = 0;
-	struct wlc_info *wlc = cfg->wlc;
+	struct brcms_c_info *wlc = cfg->wlc;
 
 	if (cfg == wlc->cfg) {
 		/* enter the MAC addr into the RXE match registers */
-		wlc_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
+		brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
 	}
 
 	wlc_ampdu_macaddr_upd(wlc);
@@ -658,13 +660,13 @@ int wlc_set_mac(struct wlc_bsscfg *cfg)
 /* Write the BSS config's BSSID address to core (set_bssid in d11procs.tcl).
  * Updates RXE match engine.
  */
-void wlc_set_bssid(struct wlc_bsscfg *cfg)
+void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg)
 {
-	struct wlc_info *wlc = cfg->wlc;
+	struct brcms_c_info *wlc = cfg->wlc;
 
 	/* if primary config, we need to update BSSID in RXE match registers */
 	if (cfg == wlc->cfg) {
-		wlc_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
+		brcms_c_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
 	}
 #ifdef SUPPORT_HWKEYS
 	else if (BSSCFG_STA(cfg) && cfg->BSS) {
@@ -677,10 +679,10 @@ void wlc_set_bssid(struct wlc_bsscfg *cfg)
  * Suspend the the MAC and update the slot timing
  * for standard 11b/g (20us slots) or shortslot 11g (9us slots).
  */
-void wlc_switch_shortslot(struct wlc_info *wlc, bool shortslot)
+void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 {
 	int idx;
-	struct wlc_bsscfg *cfg;
+	struct brcms_c_bsscfg *cfg;
 
 	/* use the override if it is set */
 	if (wlc->shortslot_override != WLC_SHORTSLOT_AUTO)
@@ -705,7 +707,7 @@ void wlc_switch_shortslot(struct wlc_info *wlc, bool shortslot)
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
-static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc)
+static u8 wlc_local_constraint_qdbm(struct brcms_c_info *wlc)
 {
 	u8 local;
 	s16 local_max;
@@ -732,11 +734,11 @@ static u8 wlc_local_constraint_qdbm(struct wlc_info *wlc)
 }
 
 /* propagate home chanspec to all bsscfgs in case bsscfg->current_bss->chanspec is referenced */
-void wlc_set_home_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
+void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	if (wlc->home_chanspec != chanspec) {
 		int idx;
-		struct wlc_bsscfg *cfg;
+		struct brcms_c_bsscfg *cfg;
 
 		wlc->home_chanspec = chanspec;
 
@@ -750,7 +752,7 @@ void wlc_set_home_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	}
 }
 
-static void wlc_set_phy_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
+static void wlc_set_phy_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	/* Save our copy of the chanspec */
 	wlc->chanspec = chanspec;
@@ -769,7 +771,7 @@ static void wlc_set_phy_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 
 }
 
-void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
+void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	uint bandunit;
 	bool switchband = false;
@@ -825,7 +827,8 @@ void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec)
 	wlc_ucode_mac_upd(wlc);
 }
 
-ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc, wlc_rateset_t *rs)
+ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
+				      wlc_rateset_t *rs)
 {
 	ratespec_t lowest_basic_rspec;
 	uint i;
@@ -853,7 +856,8 @@ ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc, wlc_rateset_t *rs)
  *  ratespec     CCK		ant = wlc->stf->txant
  *  		OFDM		ant = 3
  */
-void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc, ratespec_t bcn_rspec)
+void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
+				       ratespec_t bcn_rspec)
 {
 	u16 phyctl;
 	u16 phytxant = wlc->stf->phytxant;
@@ -864,15 +868,15 @@ void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc, ratespec_t bcn_rspec)
 		phytxant = wlc_stf_phytxchain_sel(wlc, bcn_rspec);
 	}
 
-	phyctl = wlc_read_shm(wlc, M_BCN_PCTLWD);
+	phyctl = brcms_c_read_shm(wlc, M_BCN_PCTLWD);
 	phyctl = (phyctl & ~mask) | phytxant;
-	wlc_write_shm(wlc, M_BCN_PCTLWD, phyctl);
+	brcms_c_write_shm(wlc, M_BCN_PCTLWD, phyctl);
 }
 
 /* centralized protection config change function to simplify debugging, no consistency checking
  * this should be called only on changes to avoid overhead in periodic function
 */
-void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
+void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 {
 	BCMMSG(wlc->wiphy, "idx %d, val %d\n", idx, val);
 
@@ -917,7 +921,7 @@ void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val)
 
 }
 
-static void wlc_ht_update_sgi_rx(struct wlc_info *wlc, int val)
+static void wlc_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
 {
 	wlc->ht_cap.cap_info &= ~(IEEE80211_HT_CAP_SGI_20 |
 					IEEE80211_HT_CAP_SGI_40);
@@ -927,12 +931,12 @@ static void wlc_ht_update_sgi_rx(struct wlc_info *wlc, int val)
 					IEEE80211_HT_CAP_SGI_40 : 0;
 
 	if (wlc->pub->up) {
-		wlc_update_beacon(wlc);
-		wlc_update_probe_resp(wlc, true);
+		brcms_c_update_beacon(wlc);
+		brcms_c_update_probe_resp(wlc, true);
 	}
 }
 
-static void wlc_ht_update_ldpc(struct wlc_info *wlc, s8 val)
+static void wlc_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
 {
 	wlc->stf->ldpc = val;
 
@@ -941,8 +945,8 @@ static void wlc_ht_update_ldpc(struct wlc_info *wlc, s8 val)
 		wlc->ht_cap.cap_info |= IEEE80211_HT_CAP_LDPC_CODING;
 
 	if (wlc->pub->up) {
-		wlc_update_beacon(wlc);
-		wlc_update_probe_resp(wlc, true);
+		brcms_c_update_beacon(wlc);
+		brcms_c_update_probe_resp(wlc, true);
 		wlc_phy_ldpc_override_set(wlc->band->pi, (val ? true : false));
 	}
 }
@@ -951,7 +955,7 @@ static void wlc_ht_update_ldpc(struct wlc_info *wlc, s8 val)
  * ucode, hwmac update
  *    Channel dependent updates for ucode and hw
  */
-static void wlc_ucode_mac_upd(struct wlc_info *wlc)
+static void wlc_ucode_mac_upd(struct brcms_c_info *wlc)
 {
 	/* enable or disable any active IBSSs depending on whether or not
 	 * we are on the home channel
@@ -965,7 +969,7 @@ static void wlc_ucode_mac_upd(struct wlc_info *wlc)
 			 * not expect the inits to populate a bogus beacon.
 			 */
 			if (WLC_PHY_11N_CAP(wlc->band)) {
-				wlc_write_shm(wlc, M_BCN_TXTSF_OFFSET,
+				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
 					      wlc->band->bcntsfoff);
 			}
 		}
@@ -974,11 +978,11 @@ static void wlc_ucode_mac_upd(struct wlc_info *wlc)
 	}
 
 	/* update the various promisc bits */
-	wlc_mac_bcn_promisc(wlc);
-	wlc_mac_promisc(wlc);
+	brcms_c_mac_bcn_promisc(wlc);
+	brcms_c_mac_promisc(wlc);
 }
 
-static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
+static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec)
 {
 	wlc_rateset_t default_rateset;
 	uint parkband;
@@ -1007,7 +1011,7 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 
 		wlc->band = wlc->bandstate[j];
 
-		wlc_default_rateset(wlc, &default_rateset);
+		brcms_default_rateset(wlc, &default_rateset);
 
 		/* fill in hw_rate */
 		wlc_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
@@ -1023,13 +1027,13 @@ static void wlc_bandinit_ordered(struct wlc_info *wlc, chanspec_t chanspec)
 }
 
 /* band-specific init */
-static void WLBANDINITFN(wlc_bsinit) (struct wlc_info *wlc)
+static void WLBANDINITFN(wlc_bsinit) (struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
 		 wlc->pub->unit, wlc->band->bandunit);
 
 	/* write ucode ACK/CTS rate table */
-	wlc_set_ratetable(wlc);
+	brcms_c_set_ratetable(wlc);
 
 	/* update some band specific mac configuration */
 	wlc_ucode_mac_upd(wlc);
@@ -1040,10 +1044,10 @@ static void WLBANDINITFN(wlc_bsinit) (struct wlc_info *wlc)
 }
 
 /* switch to and initialize new band */
-static void WLBANDINITFN(wlc_setband) (struct wlc_info *wlc, uint bandunit)
+static void WLBANDINITFN(wlc_setband) (struct brcms_c_info *wlc, uint bandunit)
 {
 	int idx;
-	struct wlc_bsscfg *cfg;
+	struct brcms_c_bsscfg *cfg;
 
 	wlc->band = wlc->bandstate[bandunit];
 
@@ -1053,14 +1057,14 @@ static void WLBANDINITFN(wlc_setband) (struct wlc_info *wlc, uint bandunit)
 	/* wait for at least one beacon before entering sleeping state */
 	FOREACH_AS_STA(wlc, idx, cfg)
 	    cfg->PMawakebcn = true;
-	wlc_set_ps_ctrl(wlc);
+	brcms_c_set_ps_ctrl(wlc);
 
 	/* band-specific initializations */
 	wlc_bsinit(wlc);
 }
 
 /* Initialize a WME Parameter Info Element with default STA parameters from WMM Spec, Table 12 */
-void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe)
+void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc, wme_param_ie_t *pe)
 {
 	static const wme_param_ie_t stadef = {
 		WME_OUI,
@@ -1083,7 +1087,7 @@ void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe)
 	memcpy(pe, &stadef, sizeof(*pe));
 }
 
-void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
+void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		       const struct ieee80211_tx_queue_params *params,
 		       bool suspend)
 {
@@ -1125,7 +1129,7 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 		    R_REG(&wlc->regs->tsf_random) & acp_shm.cwcur;
 		acp_shm.reggap = acp_shm.bslots + acp_shm.aifs;
 		/* Indicate the new params to the ucode */
-		acp_shm.status = wlc_read_shm(wlc, (M_EDCF_QINFO +
+		acp_shm.status = brcms_c_read_shm(wlc, (M_EDCF_QINFO +
 						    wme_shmemacindex(aci) *
 						    M_EDCF_QLEN +
 						    M_EDCF_STATUS_OFF));
@@ -1134,7 +1138,7 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 		/* Fill in shm acparam table */
 		shm_entry = (u16 *) &acp_shm;
 		for (i = 0; i < (int)sizeof(shm_acparams_t); i += 2)
-			wlc_write_shm(wlc,
+			brcms_c_write_shm(wlc,
 				      M_EDCF_QINFO +
 				      wme_shmemacindex(aci) * M_EDCF_QLEN + i,
 				      *shm_entry++);
@@ -1142,14 +1146,14 @@ void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
 	} while (0);
 
 	if (suspend)
-		wlc_suspend_mac_and_wait(wlc);
+		brcms_c_suspend_mac_and_wait(wlc);
 
 	if (suspend)
-		wlc_enable_mac(wlc);
+		brcms_c_enable_mac(wlc);
 
 }
 
-void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
+void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 {
 	u16 aci;
 	int i_ac;
@@ -1179,23 +1183,23 @@ void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend)
 		/* CWmax = 2^(ECWmax) - 1 */
 		params->cw_max = EDCF_ECW2CW((edcf_acp->ECW & EDCF_ECWMAX_MASK)
 					    >> EDCF_ECWMAX_SHIFT);
-		wlc_wme_setparams(wlc, aci, params, suspend);
+		brcms_c_wme_setparams(wlc, aci, params, suspend);
 	}
 
 	if (suspend)
-		wlc_suspend_mac_and_wait(wlc);
+		brcms_c_suspend_mac_and_wait(wlc);
 
 	if (AP_ENAB(wlc->pub) && WME_ENAB(wlc->pub)) {
-		wlc_update_beacon(wlc);
-		wlc_update_probe_resp(wlc, false);
+		brcms_c_update_beacon(wlc);
+		brcms_c_update_probe_resp(wlc, false);
 	}
 
 	if (suspend)
-		wlc_enable_mac(wlc);
+		brcms_c_enable_mac(wlc);
 
 }
 
-bool wlc_timers_init(struct wlc_info *wlc, int unit)
+bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
 {
 	wlc->wdtimer = brcms_init_timer(wlc->wl, wlc_watchdog_by_timer,
 		wlc, "watchdog");
@@ -1220,10 +1224,10 @@ bool wlc_timers_init(struct wlc_info *wlc, int unit)
 }
 
 /*
- * Initialize wlc_info default values ...
+ * Initialize brcms_c_info default values ...
  * may get overrides later in this function
  */
-void wlc_info_init(struct wlc_info *wlc, int unit)
+void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 {
 	int i;
 	/* Assume the device is there until proven otherwise */
@@ -1236,16 +1240,17 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 	wlc->shortslot = false;
 	wlc->shortslot_override = WLC_SHORTSLOT_AUTO;
 
-	wlc_protection_upd(wlc, WLC_PROT_G_OVR, WLC_PROTECTION_AUTO);
-	wlc_protection_upd(wlc, WLC_PROT_G_SPEC, false);
+	brcms_c_protection_upd(wlc, WLC_PROT_G_OVR, WLC_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, WLC_PROT_G_SPEC, false);
 
-	wlc_protection_upd(wlc, WLC_PROT_N_CFG_OVR, WLC_PROTECTION_AUTO);
-	wlc_protection_upd(wlc, WLC_PROT_N_CFG, WLC_N_PROTECTION_OFF);
-	wlc_protection_upd(wlc, WLC_PROT_N_NONGF_OVR, WLC_PROTECTION_AUTO);
-	wlc_protection_upd(wlc, WLC_PROT_N_NONGF, false);
-	wlc_protection_upd(wlc, WLC_PROT_N_PAM_OVR, AUTO);
+	brcms_c_protection_upd(wlc, WLC_PROT_N_CFG_OVR, WLC_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, WLC_PROT_N_CFG, WLC_N_PROTECTION_OFF);
+	brcms_c_protection_upd(wlc, WLC_PROT_N_NONGF_OVR, WLC_PROTECTION_AUTO);
+	brcms_c_protection_upd(wlc, WLC_PROT_N_NONGF, false);
+	brcms_c_protection_upd(wlc, WLC_PROT_N_PAM_OVR, AUTO);
 
-	wlc_protection_upd(wlc, WLC_PROT_OVERLAP, WLC_PROTECTION_CTL_OVERLAP);
+	brcms_c_protection_upd(wlc, WLC_PROT_OVERLAP,
+			       WLC_PROTECTION_CTL_OVERLAP);
 
 	/* 802.11g draft 4.0 NonERP elt advertisement */
 	wlc->include_legacy_erp = true;
@@ -1292,7 +1297,7 @@ void wlc_info_init(struct wlc_info *wlc, int unit)
 	wlc->mpc_delay_off = wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
 }
 
-static bool wlc_state_bmac_sync(struct wlc_info *wlc)
+static bool wlc_state_bmac_sync(struct brcms_c_info *wlc)
 {
 	brcms_b_state_t state_bmac;
 
@@ -1300,13 +1305,13 @@ static bool wlc_state_bmac_sync(struct wlc_info *wlc)
 		return false;
 
 	wlc->machwcap = state_bmac.machwcap;
-	wlc_protection_upd(wlc, WLC_PROT_N_PAM_OVR,
+	brcms_c_protection_upd(wlc, WLC_PROT_N_PAM_OVR,
 			   (s8) state_bmac.preamble_ovr);
 
 	return true;
 }
 
-static uint wlc_attach_module(struct wlc_info *wlc)
+static uint wlc_attach_module(struct brcms_c_info *wlc)
 {
 	uint err = 0;
 	uint unit;
@@ -1338,9 +1343,9 @@ static uint wlc_attach_module(struct wlc_info *wlc)
 	return err;
 }
 
-struct wlc_pub *wlc_pub(void *wlc)
+struct wlc_pub *brcms_c_pub(void *wlc)
 {
-	return ((struct wlc_info *) wlc)->pub;
+	return ((struct brcms_c_info *) wlc)->pub;
 }
 
 #define CHIP_SUPPORTS_11N(wlc) 	1
@@ -1348,18 +1353,18 @@ struct wlc_pub *wlc_pub(void *wlc)
 /*
  * The common driver entry routine. Error codes should be unique
  */
-void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
+void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		 bool piomode, void *regsva, uint bustype, void *btparam,
 		 uint *perr)
 {
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 	uint err = 0;
 	uint j;
 	struct wlc_pub *pub;
 	uint n_disabled;
 
-	/* allocate struct wlc_info state and its substructures */
-	wlc = (struct wlc_info *) wlc_attach_malloc(unit, &err, device);
+	/* allocate struct brcms_c_info state and its substructures */
+	wlc = (struct brcms_c_info *) wlc_attach_malloc(unit, &err, device);
 	if (wlc == NULL)
 		goto fail;
 	wlc->wiphy = wl->wiphy;
@@ -1376,11 +1381,11 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	pub->_piomode = piomode;
 	wlc->bandinit_pending = false;
 
-	/* populate struct wlc_info with default values  */
-	wlc_info_init(wlc, unit);
+	/* populate struct brcms_c_info with default values  */
+	brcms_c_info_init(wlc, unit);
 
 	/* update sta/ap related parameters */
-	wlc_ap_upd(wlc);
+	brcms_c_ap_upd(wlc);
 
 	/* 11n_disable nvram */
 	n_disabled = getintvar(pub->vars, "11n_disable");
@@ -1454,7 +1459,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		/* init gmode value */
 		if (BAND_2G(wlc->band->bandtype)) {
 			wlc->band->gmode = GMODE_AUTO;
-			wlc_protection_upd(wlc, WLC_PROT_G_USER,
+			brcms_c_protection_upd(wlc, WLC_PROT_G_USER,
 					   wlc->band->gmode);
 		}
 
@@ -1462,10 +1467,11 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		if (WLC_PHY_11N_CAP(wlc->band) && CHIP_SUPPORTS_11N(wlc)) {
 			if (n_disabled & WLFEATURE_DISABLE_11N) {
 				pub->_n_enab = OFF;
-				wlc_protection_upd(wlc, WLC_PROT_N_USER, OFF);
+				brcms_c_protection_upd(wlc, WLC_PROT_N_USER,
+						       OFF);
 			} else {
 				pub->_n_enab = SUPPORT_11N;
-				wlc_protection_upd(wlc, WLC_PROT_N_USER,
+				brcms_c_protection_upd(wlc, WLC_PROT_N_USER,
 						   ((pub->_n_enab ==
 						     SUPPORT_11N) ? WL_11N_2x2 :
 						    WL_11N_3x3));
@@ -1473,7 +1479,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		}
 
 		/* init per-band default rateset, depend on band->gmode */
-		wlc_default_rateset(wlc, &wlc->band->defrateset);
+		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
 		/* fill in hw_rateset (used early by WLC_SET_RATESET) */
 		wlc_rateset_filter(&wlc->band->defrateset,
@@ -1490,7 +1496,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	if (err != 0)
 		goto fail;
 
-	if (!wlc_timers_init(wlc, unit)) {
+	if (!brcms_c_timers_init(wlc, unit)) {
 		wiphy_err(wl->wiphy, "wl%d: %s: wlc_init_timer failed\n", unit,
 			  __func__);
 		err = 32;
@@ -1527,7 +1533,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->cfg->wlc = wlc;
 	pub->txmaxpkts = MAXTXPKTS;
 
-	wlc_wme_initparams_sta(wlc, &wlc->wme_param_ie);
+	brcms_c_wme_initparams_sta(wlc, &wlc->wme_param_ie);
 
 	wlc->mimoft = FT_HT;
 	wlc->ht_cap.cap_info = HT_CAP;
@@ -1574,7 +1580,7 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_GRN_FLD;
 
 	/* initialize radio_mpc_disable according to wlc->mpc */
-	wlc_radio_mpc_upd(wlc);
+	brcms_c_radio_mpc_upd(wlc);
 
 	if ((wlc->pub->sih->chip) == BCM43235_CHIP_ID) {
 		if ((getintvar(wlc->pub->vars, "aa2g") == 7) ||
@@ -1594,14 +1600,14 @@ void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wiphy_err(wl->wiphy, "wl%d: %s: failed with err %d\n",
 		  unit, __func__, err);
 	if (wlc)
-		wlc_detach(wlc);
+		brcms_c_detach(wlc);
 
 	if (perr)
 		*perr = err;
 	return NULL;
 }
 
-static void wlc_attach_antgain_init(struct wlc_info *wlc)
+static void wlc_attach_antgain_init(struct brcms_c_info *wlc)
 {
 	uint unit;
 	unit = wlc->pub->unit;
@@ -1633,7 +1639,7 @@ static void wlc_attach_antgain_init(struct wlc_info *wlc)
 	}
 }
 
-static bool wlc_attach_stf_ant_init(struct wlc_info *wlc)
+static bool wlc_attach_stf_ant_init(struct brcms_c_info *wlc)
 {
 	int aa;
 	uint unit;
@@ -1674,7 +1680,7 @@ static bool wlc_attach_stf_ant_init(struct wlc_info *wlc)
 }
 
 
-static void wlc_timers_deinit(struct wlc_info *wlc)
+static void wlc_timers_deinit(struct brcms_c_info *wlc)
 {
 	/* free timer state */
 	if (wlc->wdtimer) {
@@ -1687,7 +1693,7 @@ static void wlc_timers_deinit(struct wlc_info *wlc)
 	}
 }
 
-static void wlc_detach_module(struct wlc_info *wlc)
+static void wlc_detach_module(struct brcms_c_info *wlc)
 {
 	if (wlc->asi) {
 		wlc_antsel_detach(wlc->asi);
@@ -1705,12 +1711,14 @@ static void wlc_detach_module(struct wlc_info *wlc)
 /*
  * Return a count of the number of driver callbacks still pending.
  *
- * General policy is that wlc_detach can only dealloc/free software states. It can NOT
- *  touch hardware registers since the d11core may be in reset and clock may not be available.
- *    One exception is sb register access, which is possible if crystal is turned on
- * After "down" state, driver should avoid software timer with the exception of radio_monitor.
+ * General policy is that brcms_c_detach can only dealloc/free software states.
+ * It can NOT touch hardware registers since the d11core may be in reset and
+ * clock may not be available.
+ * One exception is sb register access, which is possible if crystal is turned
+ * on after "down" state, driver should avoid software timer with the exception
+ * of radio_monitor.
  */
-uint wlc_detach(struct wlc_info *wlc)
+uint brcms_c_detach(struct brcms_c_info *wlc)
 {
 	uint callbacks = 0;
 
@@ -1740,7 +1748,7 @@ uint wlc_detach(struct wlc_info *wlc)
 }
 
 /* update state that depends on the current value of "ap" */
-void wlc_ap_upd(struct wlc_info *wlc)
+void brcms_c_ap_upd(struct brcms_c_info *wlc)
 {
 	if (AP_ENAB(wlc->pub))
 		wlc->PLCPHdr_override = WLC_PLCP_AUTO;	/* AP: short not allowed, but not enforced */
@@ -1752,7 +1760,7 @@ void wlc_ap_upd(struct wlc_info *wlc)
 }
 
 /* read hwdisable state and propagate to wlc flag */
-static void wlc_radio_hwdisable_upd(struct wlc_info *wlc)
+static void wlc_radio_hwdisable_upd(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
 		return;
@@ -1765,17 +1773,17 @@ static void wlc_radio_hwdisable_upd(struct wlc_info *wlc)
 }
 
 /* return true if Minimum Power Consumption should be entered, false otherwise */
-bool wlc_is_non_delay_mpc(struct wlc_info *wlc)
+bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc)
 {
 	return false;
 }
 
-bool wlc_ismpc(struct wlc_info *wlc)
+bool brcms_c_ismpc(struct brcms_c_info *wlc)
 {
-	return (wlc->mpc_delay_off == 0) && (wlc_is_non_delay_mpc(wlc));
+	return (wlc->mpc_delay_off == 0) && (brcms_c_is_non_delay_mpc(wlc));
 }
 
-void wlc_radio_mpc_upd(struct wlc_info *wlc)
+void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 {
 	bool mpc_radio, radio_state;
 
@@ -1803,7 +1811,7 @@ void wlc_radio_mpc_upd(struct wlc_info *wlc)
 	radio_state =
 	    (mboolisset(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE) ? OFF :
 	     ON);
-	mpc_radio = (wlc_ismpc(wlc) == true) ? OFF : ON;
+	mpc_radio = (brcms_c_ismpc(wlc) == true) ? OFF : ON;
 
 	if (radio_state == ON && mpc_radio == OFF)
 		wlc->mpc_delay_off = wlc->mpc_dlycnt;
@@ -1821,46 +1829,46 @@ void wlc_radio_mpc_upd(struct wlc_info *wlc)
 	 * wlc->mpc_delay_off to wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
 	 */
 	if ((wlc->prev_non_delay_mpc == false) &&
-	    (wlc_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off) {
+	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off) {
 		wlc->mpc_delay_off = wlc->mpc_dlycnt;
 	}
-	wlc->prev_non_delay_mpc = wlc_is_non_delay_mpc(wlc);
+	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
 }
 
 /*
  * centralized radio disable/enable function,
  * invoke radio enable/disable after updating hwradio status
  */
-static void wlc_radio_upd(struct wlc_info *wlc)
+static void wlc_radio_upd(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->radio_disabled) {
-		wlc_radio_disable(wlc);
+		brcms_c_radio_disable(wlc);
 	} else {
 		wlc_radio_enable(wlc);
 	}
 }
 
 /* maintain LED behavior in down state */
-static void wlc_down_led_upd(struct wlc_info *wlc)
+static void wlc_down_led_upd(struct brcms_c_info *wlc)
 {
 	/* maintain LEDs while in down state, turn on sbclk if not available yet */
 	/* turn on sbclk if necessary */
 	if (!AP_ENAB(wlc->pub)) {
-		wlc_pllreq(wlc, true, WLC_PLLREQ_FLIP);
+		brcms_c_pllreq(wlc, true, WLC_PLLREQ_FLIP);
 
-		wlc_pllreq(wlc, false, WLC_PLLREQ_FLIP);
+		brcms_c_pllreq(wlc, false, WLC_PLLREQ_FLIP);
 	}
 }
 
 /* update hwradio status and return it */
-bool wlc_check_radio_disabled(struct wlc_info *wlc)
+bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
 {
 	wlc_radio_hwdisable_upd(wlc);
 
 	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ? true : false;
 }
 
-void wlc_radio_disable(struct wlc_info *wlc)
+void brcms_c_radio_disable(struct brcms_c_info *wlc)
 {
 	if (!wlc->pub->up) {
 		wlc_down_led_upd(wlc);
@@ -1871,7 +1879,7 @@ void wlc_radio_disable(struct wlc_info *wlc)
 	brcms_down(wlc->wl);
 }
 
-static void wlc_radio_enable(struct wlc_info *wlc)
+static void wlc_radio_enable(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->up)
 		return;
@@ -1885,7 +1893,7 @@ static void wlc_radio_enable(struct wlc_info *wlc)
 /* periodical query hw radio button while driver is "down" */
 static void wlc_radio_timer(void *arg)
 {
-	struct wlc_info *wlc = (struct wlc_info *) arg;
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 
 	if (DEVICEREMOVED(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
@@ -1902,26 +1910,26 @@ static void wlc_radio_timer(void *arg)
 	wlc_radio_upd(wlc);
 }
 
-static bool wlc_radio_monitor_start(struct wlc_info *wlc)
+static bool wlc_radio_monitor_start(struct brcms_c_info *wlc)
 {
 	/* Don't start the timer if HWRADIO feature is disabled */
 	if (wlc->radio_monitor || (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO))
 		return true;
 
 	wlc->radio_monitor = true;
-	wlc_pllreq(wlc, true, WLC_PLLREQ_RADIO_MON);
+	brcms_c_pllreq(wlc, true, WLC_PLLREQ_RADIO_MON);
 	brcms_add_timer(wlc->wl, wlc->radio_timer, TIMER_INTERVAL_RADIOCHK,
 			true);
 	return true;
 }
 
-bool wlc_radio_monitor_stop(struct wlc_info *wlc)
+bool wlc_radio_monitor_stop(struct brcms_c_info *wlc)
 {
 	if (!wlc->radio_monitor)
 		return true;
 
 	wlc->radio_monitor = false;
-	wlc_pllreq(wlc, false, WLC_PLLREQ_RADIO_MON);
+	brcms_c_pllreq(wlc, false, WLC_PLLREQ_RADIO_MON);
 	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
@@ -1933,9 +1941,9 @@ static void wlc_watchdog_by_timer(void *arg)
 /* common watchdog code */
 static void wlc_watchdog(void *arg)
 {
-	struct wlc_info *wlc = (struct wlc_info *) arg;
+	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	int i;
-	struct wlc_bsscfg *cfg;
+	struct brcms_c_bsscfg *cfg;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -1957,14 +1965,14 @@ static void wlc_watchdog(void *arg)
 		if (--wlc->mpc_delay_off == 0) {
 			mboolset(wlc->pub->radio_disabled,
 				 WL_RADIO_MPC_DISABLE);
-			if (wlc->mpc && wlc_ismpc(wlc))
+			if (wlc->mpc && brcms_c_ismpc(wlc))
 				wlc->mpc_offcnt = 0;
 			wlc->mpc_laston_ts = OSL_SYSUPTIME();
 		}
 	}
 
 	/* mpc sync */
-	wlc_radio_mpc_upd(wlc);
+	brcms_c_radio_mpc_upd(wlc);
 	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
 	wlc_radio_hwdisable_upd(wlc);
 	wlc_radio_upd(wlc);
@@ -1976,7 +1984,7 @@ static void wlc_watchdog(void *arg)
 
 	/* occasionally sample mac stat counters to detect 16-bit counter wrap */
 	if ((wlc->pub->now % SW_TIMER_MAC_STAT_UPD) == 0)
-		wlc_statsupd(wlc);
+		brcms_c_statsupd(wlc);
 
 	/* Manage TKIP countermeasures timers */
 	FOREACH_BSS(wlc, i, cfg) {
@@ -2003,7 +2011,7 @@ static void wlc_watchdog(void *arg)
 }
 
 /* make interface operational */
-int wlc_up(struct wlc_info *wlc)
+int brcms_c_up(struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -2020,11 +2028,11 @@ int wlc_up(struct wlc_info *wlc)
 	    && (wlc->pub->sih->chip == BCM4313_CHIP_ID)) {
 		if (wlc->pub->boardrev >= 0x1250
 		    && (wlc->pub->boardflags & BFL_FEM_BT)) {
-			wlc_mhf(wlc, MHF5, MHF5_4313_GPIOCTRL,
+			brcms_c_mhf(wlc, MHF5, MHF5_4313_GPIOCTRL,
 				MHF5_4313_GPIOCTRL, WLC_BAND_ALL);
 		} else {
-			wlc_mhf(wlc, MHF4, MHF4_EXTPA_ENABLE, MHF4_EXTPA_ENABLE,
-				WLC_BAND_ALL);
+			brcms_c_mhf(wlc, MHF4, MHF4_EXTPA_ENABLE,
+				    MHF4_EXTPA_ENABLE, WLC_BAND_ALL);
 		}
 	}
 
@@ -2032,7 +2040,7 @@ int wlc_up(struct wlc_info *wlc)
 	 * Need to read the hwradio status here to cover the case where the system
 	 * is loaded with the hw radio disabled. We do not want to bring the driver up in this case.
 	 * if radio is disabled, abort up, lower power, start radio timer and return 0(for NDIS)
-	 * don't call radio_update to avoid looping wlc_up.
+	 * don't call radio_update to avoid looping brcms_c_up.
 	 *
 	 * brcms_b_up_prep() returns either 0 or -BCME_RADIOOFF only
 	 */
@@ -2042,7 +2050,7 @@ int wlc_up(struct wlc_info *wlc)
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
 				int idx;
-				struct wlc_bsscfg *bsscfg;
+				struct brcms_c_bsscfg *bsscfg;
 				mboolset(wlc->pub->radio_disabled,
 					 WL_RADIO_HW_DISABLE);
 
@@ -2071,23 +2079,23 @@ int wlc_up(struct wlc_info *wlc)
 
 	/* Set EDCF hostflags */
 	if (EDCF_ENAB(wlc->pub)) {
-		wlc_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, WLC_BAND_ALL);
+		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, WLC_BAND_ALL);
 	} else {
-		wlc_mhf(wlc, MHF1, MHF1_EDCF, 0, WLC_BAND_ALL);
+		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, 0, WLC_BAND_ALL);
 	}
 
 	if (WLC_WAR16165(wlc))
-		wlc_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
+		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
 			WLC_BAND_ALL);
 
 	brcms_init(wlc->wl);
 	wlc->pub->up = true;
 
 	if (wlc->bandinit_pending) {
-		wlc_suspend_mac_and_wait(wlc);
-		wlc_set_chanspec(wlc, wlc->default_bss->chanspec);
+		brcms_c_suspend_mac_and_wait(wlc);
+		brcms_c_set_chanspec(wlc, wlc->default_bss->chanspec);
 		wlc->bandinit_pending = false;
-		wlc_enable_mac(wlc);
+		brcms_c_enable_mac(wlc);
 	}
 
 	brcms_b_up_finish(wlc->hw);
@@ -2112,7 +2120,7 @@ int wlc_up(struct wlc_info *wlc)
 }
 
 /* Initialize the base precedence map for dequeueing from txq based on WME settings */
-static void wlc_tx_prec_map_init(struct wlc_info *wlc)
+static void wlc_tx_prec_map_init(struct brcms_c_info *wlc)
 {
 	wlc->tx_prec_map = WLC_PREC_BMP_ALL;
 	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
@@ -2131,7 +2139,7 @@ static void wlc_tx_prec_map_init(struct wlc_info *wlc)
 	}
 }
 
-static uint wlc_down_del_timer(struct wlc_info *wlc)
+static uint wlc_down_del_timer(struct brcms_c_info *wlc)
 {
 	uint callbacks = 0;
 
@@ -2143,13 +2151,13 @@ static uint wlc_down_del_timer(struct wlc_info *wlc)
  * disable the hardware, free any transient buffer state.
  * Return a count of the number of driver callbacks still pending.
  */
-uint wlc_down(struct wlc_info *wlc)
+uint brcms_c_down(struct brcms_c_info *wlc)
 {
 
 	uint callbacks = 0;
 	int i;
 	bool dev_gone = false;
-	struct wlc_txq_info *qi;
+	struct brcms_c_txq_info *qi;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
@@ -2199,7 +2207,7 @@ uint wlc_down(struct wlc_info *wlc)
 
 	callbacks += brcms_b_down_finish(wlc->hw);
 
-	/* brcms_b_down_finish has done wlc_coredisable(). so clk is off */
+	/* brcms_b_down_finish has done brcms_c_coredisable(). so clk is off */
 	wlc->clk = false;
 
 	wlc->going_down = false;
@@ -2207,7 +2215,7 @@ uint wlc_down(struct wlc_info *wlc)
 }
 
 /* Set the current gmode configuration */
-int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
+int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 {
 	int ret = 0;
 	uint i;
@@ -2221,7 +2229,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	bool preamble_restrict = false;	/* Restrict association to stations that support short
 					 * preambles
 					 */
-	struct wlcband *band;
+	struct brcms_c_band *band;
 
 	/* if N-support is enabled, allow Gmode set as long as requested
 	 * Gmode is not GMODE_LEGACY_B
@@ -2245,7 +2253,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 
 	/* update configuration value */
 	if (config == true)
-		wlc_protection_upd(wlc, WLC_PROT_G_USER, gmode);
+		brcms_c_protection_upd(wlc, WLC_PROT_G_USER, gmode);
 
 	/* Clear supported rates filter */
 	memset(&wlc->sup_rates_override, 0, sizeof(wlc_rateset_t));
@@ -2302,7 +2310,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 		band->gmode = gmode;
 		if (band->rspec_override && !IS_CCK(band->rspec_override)) {
 			band->rspec_override = 0;
-			wlc_reprate_init(wlc);
+			brcms_c_reprate_init(wlc);
 		}
 		if (band->mrspec_override && !IS_CCK(band->mrspec_override)) {
 			band->mrspec_override = 0;
@@ -2355,7 +2363,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	return ret;
 }
 
-static int wlc_nmode_validate(struct wlc_info *wlc, s32 nmode)
+static int wlc_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
 {
 	int err = 0;
 
@@ -2379,7 +2387,7 @@ static int wlc_nmode_validate(struct wlc_info *wlc, s32 nmode)
 	return err;
 }
 
-int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
+int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 {
 	uint i;
 	int err;
@@ -2399,7 +2407,7 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 			       MCSSET_LEN);
 			if (IS_MCS(wlc->band->rspec_override)) {
 				wlc->bandstate[i]->rspec_override = 0;
-				wlc_reprate_init(wlc);
+				brcms_c_reprate_init(wlc);
 			}
 			if (IS_MCS(wlc->band->mrspec_override))
 				wlc->bandstate[i]->mrspec_override = 0;
@@ -2414,7 +2422,7 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 	case WL_11N_2x2:
 	case WL_11N_3x3:
 		/* force GMODE_AUTO if NMODE is ON */
-		wlc_set_gmode(wlc, GMODE_AUTO, true);
+		brcms_c_set_gmode(wlc, GMODE_AUTO, true);
 		if (nmode == WL_11N_3x3)
 			wlc->pub->_n_enab = SUPPORT_HT;
 		else
@@ -2435,7 +2443,7 @@ int wlc_set_nmode(struct wlc_info *wlc, s32 nmode)
 	return err;
 }
 
-static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
+static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 {
 	wlc_rateset_t rs, new;
 	uint bandunit;
@@ -2477,18 +2485,18 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 }
 
 /* simplified integer set interface for common ioctl handler */
-int wlc_set(struct wlc_info *wlc, int cmd, int arg)
+int brcms_c_set(struct brcms_c_info *wlc, int cmd, int arg)
 {
-	return wlc_ioctl(wlc, cmd, (void *)&arg, sizeof(arg), NULL);
+	return brcms_c_ioctl(wlc, cmd, (void *)&arg, sizeof(arg), NULL);
 }
 
 /* simplified integer get interface for common ioctl handler */
-int wlc_get(struct wlc_info *wlc, int cmd, int *arg)
+int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg)
 {
-	return wlc_ioctl(wlc, cmd, arg, sizeof(int), NULL);
+	return brcms_c_ioctl(wlc, cmd, arg, sizeof(int), NULL);
 }
 
-static void wlc_ofdm_rateset_war(struct wlc_info *wlc)
+static void wlc_ofdm_rateset_war(struct brcms_c_info *wlc)
 {
 	u8 r;
 	bool war = false;
@@ -2504,16 +2512,16 @@ static void wlc_ofdm_rateset_war(struct wlc_info *wlc)
 }
 
 int
-wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
-	  struct wlc_if *wlcif)
+brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+	  struct brcms_c_if *wlcif)
 {
 	return _wlc_ioctl(wlc, cmd, arg, len, wlcif);
 }
 
 /* common ioctl handler. return: 0=ok, -1=error, positive=particular error */
 static int
-_wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
-	   struct wlc_if *wlcif)
+_wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+	   struct brcms_c_if *wlcif)
 {
 	int val, *pval;
 	bool bool_val;
@@ -2521,7 +2529,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	struct scb *nextscb;
 	bool ta_ok;
 	uint band;
-	struct wlc_bsscfg *bsscfg;
+	struct brcms_c_bsscfg *bsscfg;
 	wlc_bss_info_t *current_bss;
 
 	/* update bsscfg pointer */
@@ -2588,10 +2596,10 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			/* wlc_BSSinit() will sanitize the rateset before using it.. */
 			if (wlc->pub->up &&
 			    (WLC_BAND_PI_RADIO_CHANSPEC != chspec)) {
-				wlc_set_home_chanspec(wlc, chspec);
-				wlc_suspend_mac_and_wait(wlc);
-				wlc_set_chanspec(wlc, chspec);
-				wlc_enable_mac(wlc);
+				brcms_c_set_home_chanspec(wlc, chspec);
+				brcms_c_suspend_mac_and_wait(wlc);
+				brcms_c_set_chanspec(wlc, chspec);
+				brcms_c_enable_mac(wlc);
 			}
 			break;
 		}
@@ -2733,9 +2741,10 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			/* let watchdog or beacon processing update shortslot */
 		} else if (wlc->pub->up) {
 			/* unassociated shortslot is off */
-			wlc_switch_shortslot(wlc, false);
+			brcms_c_switch_shortslot(wlc, false);
 		} else {
-			/* driver is down, so just update the wlc_info value */
+			/* driver is down, so just update the brcms_c_info
+			 * value */
 			if (wlc->shortslot_override == WLC_SHORTSLOT_AUTO) {
 				wlc->shortslot = false;
 			} else {
@@ -2759,11 +2768,11 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 /*
  * register watchdog and down handlers.
  */
-int wlc_module_register(struct wlc_pub *pub,
+int brcms_c_module_register(struct wlc_pub *pub,
 			const char *name, void *hdl,
 			watchdog_fn_t w_fn, down_fn_t d_fn)
 {
-	struct wlc_info *wlc = (struct wlc_info *) pub->wlc;
+	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
 
 	/* find an empty entry and just add, no duplication check! */
@@ -2782,9 +2791,9 @@ int wlc_module_register(struct wlc_pub *pub,
 }
 
 /* unregister module callbacks */
-int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
+int brcms_c_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 {
-	struct wlc_info *wlc = (struct wlc_info *) pub->wlc;
+	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
 
 	if (wlc == NULL)
@@ -2803,7 +2812,7 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 }
 
 /* Write WME tunable parameters for retransmit/max rate from wlc struct to ucode */
-static void wlc_wme_retries_write(struct wlc_info *wlc)
+static void wlc_wme_retries_write(struct brcms_c_info *wlc)
 {
 	int ac;
 
@@ -2812,7 +2821,8 @@ static void wlc_wme_retries_write(struct wlc_info *wlc)
 		return;
 
 	for (ac = 0; ac < AC_COUNT; ac++) {
-		wlc_write_shm(wlc, M_AC_TXLMT_ADDR(ac), wlc->wme_retries[ac]);
+		brcms_c_write_shm(wlc, M_AC_TXLMT_ADDR(ac),
+				  wlc->wme_retries[ac]);
 	}
 }
 
@@ -2843,7 +2853,7 @@ static void wlc_print_txs_status(u16 s)
 }
 #endif				/* BCMDBG */
 
-void wlc_print_txstatus(tx_status_t *txs)
+void brcms_c_print_txstatus(tx_status_t *txs)
 {
 #if defined(BCMDBG)
 	u16 s = txs->status;
@@ -2868,7 +2878,7 @@ void wlc_print_txstatus(tx_status_t *txs)
 #endif				/* defined(BCMDBG) */
 }
 
-void wlc_statsupd(struct wlc_info *wlc)
+void brcms_c_statsupd(struct brcms_c_info *wlc)
 {
 	int i;
 	macstat_t macstats;
@@ -2921,7 +2931,7 @@ void wlc_statsupd(struct wlc_info *wlc)
 	}
 }
 
-bool wlc_chipmatch(u16 vendor, u16 device)
+bool brcms_c_chipmatch(u16 vendor, u16 device)
 {
 	if (vendor != PCI_VENDOR_ID_BROADCOM) {
 		pr_err("wlc_chipmatch: unknown vendor id %04x\n", vendor);
@@ -2942,7 +2952,7 @@ bool wlc_chipmatch(u16 vendor, u16 device)
 }
 
 #if defined(BCMDBG)
-void wlc_print_txdesc(d11txh_t *txh)
+void brcms_c_print_txdesc(d11txh_t *txh)
 {
 	u16 mtcl = le16_to_cpu(txh->MacTxControlLow);
 	u16 mtch = le16_to_cpu(txh->MacTxControlHigh);
@@ -3028,7 +3038,7 @@ void wlc_print_txdesc(d11txh_t *txh)
 #endif				/* defined(BCMDBG) */
 
 #if defined(BCMDBG)
-void wlc_print_rxh(d11rxhdr_t *rxh)
+void brcms_c_print_rxh(d11rxhdr_t *rxh)
 {
 	u16 len = rxh->RxFrameSize;
 	u16 phystatus_0 = rxh->PhyRxStatus_0;
@@ -3067,7 +3077,7 @@ void wlc_print_rxh(d11rxhdr_t *rxh)
 }
 #endif				/* defined(BCMDBG) */
 
-static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate)
+static u16 wlc_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
 {
 	return brcms_b_rate_shm_offset(wlc->hw, rate);
 }
@@ -3084,14 +3094,14 @@ static u16 wlc_rate_shm_offset(struct wlc_info *wlc, u8 rate)
  * Returns true if packet consumed (queued), false if not.
  */
 bool
-wlc_prec_enq(struct wlc_info *wlc, struct pktq *q, void *pkt, int prec)
+brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q, void *pkt, int prec)
 {
-	return wlc_prec_enq_head(wlc, q, pkt, prec, false);
+	return brcms_c_prec_enq_head(wlc, q, pkt, prec, false);
 }
 
 bool
-wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
-		  int prec, bool head)
+brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
+		      struct sk_buff *pkt, int prec, bool head)
 {
 	struct sk_buff *p;
 	int eprec = -1;		/* precedence to evict from */
@@ -3136,17 +3146,17 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 	return true;
 }
 
-void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
+void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			     uint prec)
 {
-	struct wlc_info *wlc = (struct wlc_info *) ctx;
-	struct wlc_txq_info *qi = wlc->pkt_queue;	/* Check me */
+	struct brcms_c_info *wlc = (struct brcms_c_info *) ctx;
+	struct brcms_c_txq_info *qi = wlc->pkt_queue;	/* Check me */
 	struct pktq *q = &qi->q;
 	int prio;
 
 	prio = sdu->priority;
 
-	if (!wlc_prec_enq(wlc, q, sdu, prec)) {
+	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
 		if (!EDCF_ENAB(wlc->pub)
 		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
 			wiphy_err(wlc->wiphy, "wl%d: wlc_txq_enq: txq overflow"
@@ -3166,18 +3176,18 @@ void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
 		if (pktq_len(q) >= wlc->pub->tunables->datahiwat) {
-			wlc_txflowcontrol(wlc, qi, ON, ALLPRIO);
+			brcms_c_txflowcontrol(wlc, qi, ON, ALLPRIO);
 		}
 	} else if (wlc->pub->_priofc) {
 		if (pktq_plen(q, wlc_prio2prec_map[prio]) >=
 		    wlc->pub->tunables->datahiwat) {
-			wlc_txflowcontrol(wlc, qi, ON, prio);
+			brcms_c_txflowcontrol(wlc, qi, ON, prio);
 		}
 	}
 }
 
 bool
-wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
+brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 		     struct ieee80211_hw *hw)
 {
 	u8 prio;
@@ -3194,19 +3204,19 @@ wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
 	if (unlikely
 	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
-	wlc_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
-	wlc_send_q(wlc);
+	brcms_c_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
+	brcms_c_send_q(wlc);
 	return 0;
 }
 
-void wlc_send_q(struct wlc_info *wlc)
+void brcms_c_send_q(struct brcms_c_info *wlc)
 {
 	struct sk_buff *pkt[DOT11_MAXNUMFRAGS];
 	int prec;
 	u16 prec_map;
 	int err = 0, i, count;
 	uint fifo;
-	struct wlc_txq_info *qi = wlc->pkt_queue;
+	struct brcms_c_txq_info *qi = wlc->pkt_queue;
 	struct pktq *q = &qi->q;
 	struct ieee80211_tx_info *tx_info;
 
@@ -3226,10 +3236,11 @@ void wlc_send_q(struct wlc_info *wlc)
 			err = wlc_sendampdu(wlc->ampdu, qi, pkt, prec);
 		} else {
 			count = 1;
-			err = wlc_prep_pdu(wlc, pkt[0], &fifo);
+			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
 			if (!err) {
 				for (i = 0; i < count; i++) {
-					wlc_txfifo(wlc, fifo, pkt[i], true, 1);
+					brcms_c_txfifo(wlc, fifo, pkt[i], true,
+						       1);
 				}
 			}
 		}
@@ -3248,17 +3259,17 @@ void wlc_send_q(struct wlc_info *wlc)
 	/* Check if flow control needs to be turned off after sending the packet */
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
-		if (wlc_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
+		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
 		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2)) {
-			wlc_txflowcontrol(wlc, qi, OFF, ALLPRIO);
+			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
 		}
 	} else if (wlc->pub->_priofc) {
 		int prio;
 		for (prio = MAXPRIO; prio >= 0; prio--) {
-			if (wlc_txflowcontrol_prio_isset(wlc, qi, prio) &&
+			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
 			    (pktq_plen(q, wlc_prio2prec_map[prio]) <
 			     wlc->pub->tunables->datahiwat / 2)) {
-				wlc_txflowcontrol(wlc, qi, OFF, prio);
+				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
 			}
 		}
 	}
@@ -3271,7 +3282,7 @@ void wlc_send_q(struct wlc_info *wlc)
  * for MC frames so is used as part of the sequence number.
  */
 static inline u16
-bcmc_fid_generate(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg,
+bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_c_bsscfg *bsscfg,
 		  d11txh_t *txh)
 {
 	u16 frameid;
@@ -3287,8 +3298,8 @@ bcmc_fid_generate(struct wlc_info *wlc, struct wlc_bsscfg *bsscfg,
 }
 
 void
-wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
-	   s8 txpktpend)
+brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
+	       bool commit, s8 txpktpend)
 {
 	u16 frameid = INVALIDFID;
 	d11txh_t *txh;
@@ -3326,7 +3337,8 @@ wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p, bool commit,
 }
 
 void
-wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rspec, uint length, u8 *plcp)
+brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
+		     uint length, u8 *plcp)
 {
 	if (IS_MCS(rspec)) {
 		wlc_compute_mimo_plcp(rspec, length, plcp);
@@ -3380,8 +3392,8 @@ wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
  * Broken out for PRQ.
  */
 
-static void wlc_cck_plcp_set(struct wlc_info *wlc, int rate_500, uint length,
-			     u8 *plcp)
+static void wlc_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
+			     uint length, u8 *plcp)
 {
 	u16 usec = 0;
 	u8 le = 0;
@@ -3427,7 +3439,7 @@ static void wlc_cck_plcp_set(struct wlc_info *wlc, int rate_500, uint length,
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rspec,
+static void wlc_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
 				 uint length, u8 *plcp)
 {
 	int rate = RSPEC2RATE(rspec);
@@ -3446,8 +3458,8 @@ static void wlc_compute_cck_plcp(struct wlc_info *wlc, ratespec_t rspec,
  * preamble_type	use short/GF or long/MM PLCP header
  */
 static u16
-wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate, u8 preamble_type,
-		      uint next_frag_len)
+wlc_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
+		      u8 preamble_type, uint next_frag_len)
 {
 	u16 dur, sifs;
 
@@ -3462,13 +3474,13 @@ wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate, u8 preamble_type,
 		/* add another SIFS and the frag time */
 		dur += sifs;
 		dur +=
-		    (u16) wlc_calc_frame_time(wlc, rate, preamble_type,
+		    (u16) brcms_c_calc_frame_time(wlc, rate, preamble_type,
 						 next_frag_len);
 	}
 	return dur;
 }
 
-/* wlc_compute_rtscts_dur()
+/* brcms_c_compute_rtscts_dur()
  *
  * Calculate the 802.11 MAC header DUR field for an RTS or CTS frame
  * DUR for normal RTS/CTS w/ frame = 3 SIFS + 1 CTS + next frame time + 1 ACK
@@ -3480,9 +3492,10 @@ wlc_compute_frame_dur(struct wlc_info *wlc, ratespec_t rate, u8 preamble_type,
  * frame_len		next MPDU frame length in bytes
  */
 u16
-wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
-		       ratespec_t frame_rate, u8 rts_preamble_type,
-		       u8 frame_preamble_type, uint frame_len, bool ba)
+brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
+			   ratespec_t rts_rate,
+			   ratespec_t frame_rate, u8 rts_preamble_type,
+			   u8 frame_preamble_type, uint frame_len, bool ba)
 {
 	u16 dur, sifs;
 
@@ -3498,7 +3511,7 @@ wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
 	}
 
 	dur +=
-	    (u16) wlc_calc_frame_time(wlc, frame_rate, frame_preamble_type,
+	    (u16) brcms_c_calc_frame_time(wlc, frame_rate, frame_preamble_type,
 					 frame_len);
 	if (ba)
 		dur +=
@@ -3511,7 +3524,7 @@ wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only, ratespec_t rts_rate,
 	return dur;
 }
 
-u16 wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
+u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 {
 	u16 phyctl1 = 0;
 	u16 bw;
@@ -3559,8 +3572,8 @@ u16 wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec)
 }
 
 ratespec_t
-wlc_rspec_to_rts_rspec(struct wlc_info *wlc, ratespec_t rspec, bool use_rspec,
-		       u16 mimo_ctlchbw)
+brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, ratespec_t rspec,
+			   bool use_rspec, u16 mimo_ctlchbw)
 {
 	ratespec_t rts_rspec = 0;
 
@@ -3615,7 +3628,7 @@ wlc_rspec_to_rts_rspec(struct wlc_info *wlc, ratespec_t rspec, bool use_rspec,
  *
  */
 static u16
-wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
+wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
 		     wsec_key_t *key, ratespec_t rspec_override)
@@ -3897,8 +3910,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		use_rts = true;
 
 	/* (3) PLCP: determine PLCP header and MAC duration, fill d11txh_t */
-	wlc_compute_plcp(wlc, rspec[0], phylen, plcp);
-	wlc_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
+	brcms_c_compute_plcp(wlc, rspec[0], phylen, plcp);
+	brcms_c_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
 	memcpy(&txh->FragPLCPFallback,
 	       plcp_fallback, sizeof(txh->FragPLCPFallback));
 
@@ -3923,7 +3936,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	} else if (use_rifs) {
 		/* NAV protect to end of next max packet size */
 		durid =
-		    (u16) wlc_calc_frame_time(wlc, rspec[0],
+		    (u16) brcms_c_calc_frame_time(wlc, rspec[0],
 						 preamble_type[0],
 						 DOT11_MAX_FRAG_LEN);
 		durid += RIFS_11N_TIME;
@@ -4002,7 +4015,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 			use_cts = false;
 
 		for (k = 0; k < 2; k++) {
-			rts_rspec[k] = wlc_rspec_to_rts_rspec(wlc, rspec[k],
+			rts_rspec[k] = brcms_c_rspec_to_rts_rspec(wlc, rspec[k],
 							      false,
 							      mimo_ctlchbw);
 		}
@@ -4036,10 +4049,10 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		else
 			rts_phylen = DOT11_RTS_LEN + FCS_LEN;
 
-		wlc_compute_plcp(wlc, rts_rspec[0], rts_phylen, rts_plcp);
+		brcms_c_compute_plcp(wlc, rts_rspec[0], rts_phylen, rts_plcp);
 
 		/* fallback rate version of RTS PLCP header */
-		wlc_compute_plcp(wlc, rts_rspec[1], rts_phylen,
+		brcms_c_compute_plcp(wlc, rts_rspec[1], rts_phylen,
 				 rts_plcp_fallback);
 		memcpy(&txh->RTSPLCPFallback, rts_plcp_fallback,
 		       sizeof(txh->RTSPLCPFallback));
@@ -4047,12 +4060,12 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		/* RTS frame fields... */
 		rts = (struct ieee80211_rts *)&txh->rts_frame;
 
-		durid = wlc_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts, rts_rspec[0],
 					       rspec[0], rts_preamble_type[0],
 					       preamble_type[0], phylen, false);
 		rts->duration = cpu_to_le16(durid);
 		/* fallback rate version of RTS DUR field */
-		durid = wlc_compute_rtscts_dur(wlc, use_cts,
+		durid = brcms_c_compute_rtscts_dur(wlc, use_cts,
 					       rts_rspec[1], rspec[1],
 					       rts_preamble_type[1],
 					       preamble_type[1], phylen, false);
@@ -4124,15 +4137,15 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	if (WLC_PHY_11N_CAP(wlc->band)) {
 		u16 phyctl1 = 0;
 
-		phyctl1 = wlc_phytxctl1_calc(wlc, rspec[0]);
+		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[0]);
 		txh->PhyTxControlWord_1 = cpu_to_le16(phyctl1);
-		phyctl1 = wlc_phytxctl1_calc(wlc, rspec[1]);
+		phyctl1 = brcms_c_phytxctl1_calc(wlc, rspec[1]);
 		txh->PhyTxControlWord_1_Fbr = cpu_to_le16(phyctl1);
 
 		if (use_rts || use_cts) {
-			phyctl1 = wlc_phytxctl1_calc(wlc, rts_rspec[0]);
+			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[0]);
 			txh->PhyTxControlWord_1_Rts = cpu_to_le16(phyctl1);
-			phyctl1 = wlc_phytxctl1_calc(wlc, rts_rspec[1]);
+			phyctl1 = brcms_c_phytxctl1_calc(wlc, rts_rspec[1]);
 			txh->PhyTxControlWord_1_FbrRts = cpu_to_le16(phyctl1);
 		}
 
@@ -4143,13 +4156,13 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		 */
 		if (IS_MCS(rspec[0]) && (preamble_type[0] == WLC_MM_PREAMBLE)) {
 			u16 mmodelen =
-			    wlc_calc_lsig_len(wlc, rspec[0], phylen);
+			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
 			txh->MModeLen = cpu_to_le16(mmodelen);
 		}
 
 		if (IS_MCS(rspec[1]) && (preamble_type[1] == WLC_MM_PREAMBLE)) {
 			u16 mmodefbrlen =
-			    wlc_calc_lsig_len(wlc, rspec[1], phylen);
+			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
 			txh->MModeFbrLen = cpu_to_le16(mmodefbrlen);
 		}
 	}
@@ -4161,8 +4174,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		/* WME: Update TXOP threshold */
 		if ((!(tx_info->flags & IEEE80211_TX_CTL_AMPDU)) && (frag == 0)) {
 			frag_dur =
-			    wlc_calc_frame_time(wlc, rspec[0], preamble_type[0],
-						phylen);
+			    brcms_c_calc_frame_time(wlc, rspec[0],
+					preamble_type[0], phylen);
 
 			if (rts) {
 				/* 1 RTS or CTS-to-self frame */
@@ -4187,7 +4200,7 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 							  preamble_type[0], 0);
 
 				dur_fallback =
-				    wlc_calc_frame_time(wlc, rspec[1],
+				    brcms_c_calc_frame_time(wlc, rspec[1],
 							preamble_type[1],
 							phylen);
 				dur_fallback +=
@@ -4246,9 +4259,9 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	return 0;
 }
 
-void wlc_tbtt(struct wlc_info *wlc)
+void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
-	struct wlc_bsscfg *cfg = wlc->cfg;
+	struct brcms_c_bsscfg *cfg = wlc->cfg;
 
 	if (!cfg->BSS) {
 		/* DirFrmQ is now valid...defer setting until end of ATIM window */
@@ -4256,23 +4269,23 @@ void wlc_tbtt(struct wlc_info *wlc)
 	}
 }
 
-static void wlc_war16165(struct wlc_info *wlc, bool tx)
+static void wlc_war16165(struct brcms_c_info *wlc, bool tx)
 {
 	if (tx) {
 		/* the post-increment is used in STAY_AWAKE macro */
 		if (wlc->txpend16165war++ == 0)
-			wlc_set_ps_ctrl(wlc);
+			brcms_c_set_ps_ctrl(wlc);
 	} else {
 		wlc->txpend16165war--;
 		if (wlc->txpend16165war == 0)
-			wlc_set_ps_ctrl(wlc);
+			brcms_c_set_ps_ctrl(wlc);
 	}
 }
 
 /* process an individual tx_status_t */
 /* WLC_HIGH_API */
 bool
-wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
+brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 {
 	struct sk_buff *p;
 	uint queue;
@@ -4321,9 +4334,9 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		if (WL_ERROR_ON()) {
 			wiphy_err(wlc->wiphy, "phyerr 0x%x, rate 0x%x\n",
 				  txs->phyerr, txh->MainRates);
-			wlc_print_txdesc(txh);
+			brcms_c_print_txdesc(txh);
 		}
-		wlc_print_txstatus(txs);
+		brcms_c_print_txstatus(txs);
 	}
 
 	if (txs->frameid != cpu_to_le16(txh->TxFrameID))
@@ -4393,7 +4406,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	totlen = brcmu_pkttotlen(p);
 	free_pdu = true;
 
-	wlc_txfifo_complete(wlc, queue, 1);
+	brcms_c_txfifo_complete(wlc, queue, 1);
 
 	if (lastframe) {
 		p->next = NULL;
@@ -4418,7 +4431,7 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 }
 
 void
-wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
+brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 {
 	TXPKTPENDDEC(wlc, fifo, txpktpend);
 	BCMMSG(wlc->wiphy, "pktpend dec %d to %d\n", txpktpend,
@@ -4430,23 +4443,23 @@ wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend)
 	/* Clear MHF2_TXBCMC_NOW flag if BCMC fifo has drained */
 	if (AP_ENAB(wlc->pub) &&
 	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO)) {
-		wlc_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, WLC_BAND_AUTO);
+		brcms_c_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, WLC_BAND_AUTO);
 	}
 
 	/* figure out which bsscfg is being worked on... */
 }
 
 /* Update beacon listen interval in shared memory */
-void wlc_bcn_li_upd(struct wlc_info *wlc)
+void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
 {
 	if (AP_ENAB(wlc->pub))
 		return;
 
 	/* wake up every DTIM is the default */
 	if (wlc->bcn_li_dtim == 1)
-		wlc_write_shm(wlc, M_BCN_LI, 0);
+		brcms_c_write_shm(wlc, M_BCN_LI, 0);
 	else
-		wlc_write_shm(wlc, M_BCN_LI,
+		brcms_c_write_shm(wlc, M_BCN_LI,
 			      (wlc->bcn_li_dtim << 8) | wlc->bcn_li_bcn);
 }
 
@@ -4464,7 +4477,7 @@ void wlc_bcn_li_upd(struct wlc_info *wlc)
  * receive call sequence after rx interrupt. Only the higher 16 bits
  * are used. Finally, the tsf_h is read from the tsf register.
  */
-static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh)
+static u64 wlc_recover_tsf64(struct brcms_c_info *wlc, struct wlc_d11rxhdr *rxh)
 {
 	u32 tsf_h, tsf_l;
 	u16 rx_tsf_0_15, rx_tsf_16_31;
@@ -4488,7 +4501,8 @@ static u64 wlc_recover_tsf64(struct wlc_info *wlc, struct wlc_d11rxhdr *rxh)
 }
 
 static void
-prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
+prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
+		     struct sk_buff *p,
 		     struct ieee80211_rx_status *rx_status)
 {
 	wlc_d11rxhdr_t *wlc_rxh = (wlc_d11rxhdr_t *) rxh;
@@ -4598,7 +4612,7 @@ prep_mac80211_status(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p,
 }
 
 static void
-wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
+wlc_recvctl(struct brcms_c_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
@@ -4622,7 +4636,7 @@ wlc_recvctl(struct wlc_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
  * Param 'bound' indicates max. # frames to process before break out.
  */
 /* WLC_HIGH_API */
-void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
+void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 {
 	d11rxhdr_t *rxh;
 	struct ieee80211_hdr *h;
@@ -4719,7 +4733,8 @@ void wlc_recv(struct wlc_info *wlc, struct sk_buff *p)
  *   len = 3(nsyms + nstream + 3) - 3
  */
 u16
-wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
+brcms_c_calc_lsig_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+		      uint mac_len)
 {
 	uint nsyms, len = 0, kNdps;
 
@@ -4759,8 +4774,8 @@ wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec, uint mac_len)
 
 /* calculate frame duration of a given rate and length, return time in usec unit */
 uint
-wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
-		    uint mac_len)
+brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
+			u8 preamble_type, uint mac_len)
 {
 	uint nsyms, dur = 0, Ndps, kNdps;
 	uint rate = RSPEC2RATE(ratespec);
@@ -4826,10 +4841,10 @@ wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 	return dur;
 }
 
-/* The opposite of wlc_calc_frame_time */
+/* The opposite of brcms_c_calc_frame_time */
 static uint
-wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
-		   uint dur)
+wlc_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+		   u8 preamble_type, uint dur)
 {
 	uint nsyms, mac_len, Ndps, kNdps;
 	uint rate = RSPEC2RATE(ratespec);
@@ -4874,7 +4889,7 @@ wlc_calc_frame_len(struct wlc_info *wlc, ratespec_t ratespec, u8 preamble_type,
 }
 
 static uint
-wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
+wlc_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
 		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
@@ -4883,13 +4898,13 @@ wlc_calc_ba_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 	 */
 	rspec = WLC_BASIC_RATE(wlc, rspec);
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
-	return wlc_calc_frame_time(wlc, rspec, preamble_type,
+	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
 				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
 				    FCS_LEN));
 }
 
 static uint
-wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
+wlc_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	uint dur = 0;
 
@@ -4901,13 +4916,13 @@ wlc_calc_ack_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 	rspec = WLC_BASIC_RATE(wlc, rspec);
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
 	dur =
-	    wlc_calc_frame_time(wlc, rspec, preamble_type,
+	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
 				(DOT11_ACK_LEN + FCS_LEN));
 	return dur;
 }
 
 static uint
-wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
+wlc_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
 		wlc->pub->unit, rspec, preamble_type);
@@ -4915,7 +4930,7 @@ wlc_calc_cts_time(struct wlc_info *wlc, ratespec_t rspec, u8 preamble_type)
 }
 
 /* derive wlc->band->basic_rate[] table from 'rateset' */
-void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
+void wlc_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 {
 	u8 rate;
 	u8 mandatory;
@@ -5005,7 +5020,7 @@ void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset)
 	}
 }
 
-static void wlc_write_rate_shm(struct wlc_info *wlc, u8 rate, u8 basic_rate)
+static void wlc_write_rate_shm(struct brcms_c_info *wlc, u8 rate, u8 basic_rate)
 {
 	u8 phy_rate, index;
 	u8 basic_phy_rate, basic_index;
@@ -5030,15 +5045,15 @@ static void wlc_write_rate_shm(struct wlc_info *wlc, u8 rate, u8 basic_rate)
 	/* Find the SHM pointer to the ACK rate entry by looking in the
 	 * Direct-map Table
 	 */
-	basic_ptr = wlc_read_shm(wlc, (dir_table + basic_index * 2));
+	basic_ptr = brcms_c_read_shm(wlc, (dir_table + basic_index * 2));
 
 	/* Update the SHM BSS-basic-rate-set mapping table with the pointer
 	 * to the correct basic rate for the given incoming rate
 	 */
-	wlc_write_shm(wlc, (basic_table + index * 2), basic_ptr);
+	brcms_c_write_shm(wlc, (basic_table + index * 2), basic_ptr);
 }
 
-static const wlc_rateset_t *wlc_rateset_get_hwrs(struct wlc_info *wlc)
+static const wlc_rateset_t *wlc_rateset_get_hwrs(struct brcms_c_info *wlc)
 {
 	const wlc_rateset_t *rs_dflt;
 
@@ -5055,7 +5070,7 @@ static const wlc_rateset_t *wlc_rateset_get_hwrs(struct wlc_info *wlc)
 	return rs_dflt;
 }
 
-void wlc_set_ratetable(struct wlc_info *wlc)
+void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 {
 	const wlc_rateset_t *rs_dflt;
 	wlc_rateset_t rs;
@@ -5090,7 +5105,7 @@ void wlc_set_ratetable(struct wlc_info *wlc)
  * Return true if the specified rate is supported by the specified band.
  * WLC_BAND_AUTO indicates the current band.
  */
-bool wlc_valid_rate(struct wlc_info *wlc, ratespec_t rspec, int band,
+bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
 		    bool verbose)
 {
 	wlc_rateset_t *hw_rateset;
@@ -5125,10 +5140,10 @@ bool wlc_valid_rate(struct wlc_info *wlc, ratespec_t rspec, int band,
 	return false;
 }
 
-static void wlc_update_mimo_band_bwcap(struct wlc_info *wlc, u8 bwcap)
+static void wlc_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 {
 	uint i;
-	struct wlcband *band;
+	struct brcms_c_band *band;
 
 	for (i = 0; i < NBANDS(wlc); i++) {
 		if (IS_SINGLEBAND_5G(wlc->deviceid))
@@ -5149,7 +5164,7 @@ static void wlc_update_mimo_band_bwcap(struct wlc_info *wlc, u8 bwcap)
 	}
 }
 
-void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
+void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 {
 	const wlc_rateset_t *rs_dflt;
 	wlc_rateset_t rs;
@@ -5173,20 +5188,20 @@ void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
 		entry_ptr = wlc_rate_shm_offset(wlc, rate);
 
 		/* Calculate the Probe Response PLCP for the given rate */
-		wlc_compute_plcp(wlc, rate, frame_len, plcp);
+		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
 
 		/* Calculate the duration of the Probe Response frame plus SIFS for the MAC */
 		dur =
-		    (u16) wlc_calc_frame_time(wlc, rate, WLC_LONG_PREAMBLE,
+		    (u16) brcms_c_calc_frame_time(wlc, rate, WLC_LONG_PREAMBLE,
 						 frame_len);
 		dur += sifs;
 
 		/* Update the SHM Rate Table entry Probe Response values */
-		wlc_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS,
+		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS,
 			      (u16) (plcp[0] + (plcp[1] << 8)));
-		wlc_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS + 2,
+		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_PLCP_POS + 2,
 			      (u16) (plcp[2] + (plcp[3] << 8)));
-		wlc_write_shm(wlc, entry_ptr + M_RT_PRS_DUR_POS, dur);
+		brcms_c_write_shm(wlc, entry_ptr + M_RT_PRS_DUR_POS, dur);
 	}
 }
 
@@ -5203,8 +5218,8 @@ void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len)
  *	and included up to, but not including, the 4 byte FCS.
  */
 static void
-wlc_bcn_prb_template(struct wlc_info *wlc, u16 type, ratespec_t bcn_rspec,
-		     struct wlc_bsscfg *cfg, u16 *buf, int *len)
+wlc_bcn_prb_template(struct brcms_c_info *wlc, u16 type, ratespec_t bcn_rspec,
+		     struct brcms_c_bsscfg *cfg, u16 *buf, int *len)
 {
 	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 	cck_phy_hdr_t *plcp;
@@ -5227,7 +5242,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, u16 type, ratespec_t bcn_rspec,
 	/* PLCP for Probe Response frames are filled in from core's rate table */
 	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg)) {
 		/* fill in PLCP */
-		wlc_compute_plcp(wlc, bcn_rspec,
+		brcms_c_compute_plcp(wlc, bcn_rspec,
 				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
 				 (u8 *) plcp);
 
@@ -5235,7 +5250,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, u16 type, ratespec_t bcn_rspec,
 	/* "Regular" and 16 MBSS but not for 4 MBSS */
 	/* Update the phytxctl for the beacon based on the rspec */
 	if (!SOFTBCN_ENAB(cfg))
-		wlc_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
+		brcms_c_beacon_phytxctl_txant_upd(wlc, bcn_rspec);
 
 	if (MBSS_BCN_ENAB(cfg) && type == IEEE80211_STYPE_BEACON)
 		h = (struct ieee80211_mgmt *)&plcp[0];
@@ -5257,7 +5272,7 @@ wlc_bcn_prb_template(struct wlc_info *wlc, u16 type, ratespec_t bcn_rspec,
 	return;
 }
 
-int wlc_get_header_len()
+int brcms_c_get_header_len()
 {
 	return TXOFF;
 }
@@ -5267,7 +5282,8 @@ int wlc_get_header_len()
  * template updated.
  * Otherwise, it updates the hardware template.
  */
-void wlc_bss_update_beacon(struct wlc_info *wlc, struct wlc_bsscfg *cfg)
+void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
+			       struct brcms_c_bsscfg *cfg)
 {
 	int len = BCN_TMPL_LEN;
 
@@ -5301,31 +5317,31 @@ void wlc_bss_update_beacon(struct wlc_info *wlc, struct wlc_bsscfg *cfg)
 		}
 
 		wlc->bcn_rspec =
-		    wlc_lowest_basic_rspec(wlc, &cfg->current_bss->rateset);
+		    brcms_c_lowest_basic_rspec(wlc, &cfg->current_bss->rateset);
 		/* update the template and ucode shm */
 		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON,
 				     wlc->bcn_rspec, cfg, bcn, &len);
-		wlc_write_hw_bcntemplates(wlc, bcn, len, false);
+		brcms_c_write_hw_bcntemplates(wlc, bcn, len, false);
 	}
 }
 
 /*
  * Update all beacons for the system.
  */
-void wlc_update_beacon(struct wlc_info *wlc)
+void brcms_c_update_beacon(struct brcms_c_info *wlc)
 {
 	int idx;
-	struct wlc_bsscfg *bsscfg;
+	struct brcms_c_bsscfg *bsscfg;
 
 	/* update AP or IBSS beacons */
 	FOREACH_BSS(wlc, idx, bsscfg) {
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
-			wlc_bss_update_beacon(wlc, bsscfg);
+			brcms_c_bss_update_beacon(wlc, bsscfg);
 	}
 }
 
 /* Write ssid into shared memory */
-void wlc_shm_ssid_upd(struct wlc_info *wlc, struct wlc_bsscfg *cfg)
+void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc, struct brcms_c_bsscfg *cfg)
 {
 	u8 *ssidptr = cfg->SSID;
 	u16 base = M_SSID;
@@ -5335,27 +5351,28 @@ void wlc_shm_ssid_upd(struct wlc_info *wlc, struct wlc_bsscfg *cfg)
 	memset(ssidbuf, 0, IEEE80211_MAX_SSID_LEN);
 	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
 
-	wlc_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
+	brcms_c_copyto_shm(wlc, base, ssidbuf, IEEE80211_MAX_SSID_LEN);
 
 	if (!MBSS_BCN_ENAB(cfg))
-		wlc_write_shm(wlc, M_SSIDLEN, (u16) cfg->SSID_len);
+		brcms_c_write_shm(wlc, M_SSIDLEN, (u16) cfg->SSID_len);
 }
 
-void wlc_update_probe_resp(struct wlc_info *wlc, bool suspend)
+void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend)
 {
 	int idx;
-	struct wlc_bsscfg *bsscfg;
+	struct brcms_c_bsscfg *bsscfg;
 
 	/* update AP or IBSS probe responses */
 	FOREACH_BSS(wlc, idx, bsscfg) {
 		if (bsscfg->up && (BSSCFG_AP(bsscfg) || !bsscfg->BSS))
-			wlc_bss_update_probe_resp(wlc, bsscfg, suspend);
+			brcms_c_bss_update_probe_resp(wlc, bsscfg, suspend);
 	}
 }
 
 void
-wlc_bss_update_probe_resp(struct wlc_info *wlc, struct wlc_bsscfg *cfg,
-			  bool suspend)
+brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
+			      struct brcms_c_bsscfg *cfg,
+			      bool suspend)
 {
 	u16 prb_resp[BCN_TMPL_LEN / 2];
 	int len = BCN_TMPL_LEN;
@@ -5368,35 +5385,36 @@ wlc_bss_update_probe_resp(struct wlc_info *wlc, struct wlc_bsscfg *cfg,
 				     prb_resp, &len);
 
 		if (suspend)
-			wlc_suspend_mac_and_wait(wlc);
+			brcms_c_suspend_mac_and_wait(wlc);
 
 		/* write the probe response into the template region */
 		brcms_b_write_template_ram(wlc->hw, T_PRS_TPL_BASE,
 					    (len + 3) & ~3, prb_resp);
 
 		/* write the length of the probe response frame (+PLCP/-FCS) */
-		wlc_write_shm(wlc, M_PRB_RESP_FRM_LEN, (u16) len);
+		brcms_c_write_shm(wlc, M_PRB_RESP_FRM_LEN, (u16) len);
 
 		/* write the SSID and SSID length */
-		wlc_shm_ssid_upd(wlc, cfg);
+		brcms_c_shm_ssid_upd(wlc, cfg);
 
 		/*
 		 * Write PLCP headers and durations for probe response frames at all rates.
 		 * Use the actual frame length covered by the PLCP header for the call to
-		 * wlc_mod_prb_rsp_rate_table() by subtracting the PLCP len and adding the FCS.
+		 * brcms_c_mod_prb_rsp_rate_table() by subtracting the PLCP len
+		 * and adding the FCS.
 		 */
 		len += (-D11_PHY_HDR_LEN + FCS_LEN);
-		wlc_mod_prb_rsp_rate_table(wlc, (u16) len);
+		brcms_c_mod_prb_rsp_rate_table(wlc, (u16) len);
 
 		if (suspend)
-			wlc_enable_mac(wlc);
+			brcms_c_enable_mac(wlc);
 	} else {		/* Generating probe resp in sw; update local template */
 		/* error: No software probe response support without MBSS */
 	}
 }
 
 /* prepares pdu for transmission. returns BCM error codes */
-int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
+int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 {
 	uint fifo;
 	d11txh_t *txh;
@@ -5423,24 +5441,24 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 }
 
 /* init tx reported rate mechanism */
-void wlc_reprate_init(struct wlc_info *wlc)
+void brcms_c_reprate_init(struct brcms_c_info *wlc)
 {
 	int i;
-	struct wlc_bsscfg *bsscfg;
+	struct brcms_c_bsscfg *bsscfg;
 
 	FOREACH_BSS(wlc, i, bsscfg) {
-		wlc_bsscfg_reprate_init(bsscfg);
+		brcms_c_bsscfg_reprate_init(bsscfg);
 	}
 }
 
 /* per bsscfg init tx reported rate mechanism */
-void wlc_bsscfg_reprate_init(struct wlc_bsscfg *bsscfg)
+void brcms_c_bsscfg_reprate_init(struct brcms_c_bsscfg *bsscfg)
 {
 	bsscfg->txrspecidx = 0;
 	memset((char *)bsscfg->txrspec, 0, sizeof(bsscfg->txrspec));
 }
 
-void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs)
+void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 {
 	wlc_rateset_default(rs, NULL, wlc->band->phytype, wlc->band->bandtype,
 			    false, WLC_RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
@@ -5448,10 +5466,10 @@ void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs)
 			    wlc->stf->txstreams);
 }
 
-static void wlc_bss_default_init(struct wlc_info *wlc)
+static void wlc_bss_default_init(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec;
-	struct wlcband *band;
+	struct brcms_c_band *band;
 	wlc_bss_info_t *bi = wlc->default_bss;
 
 	/* init default and target BSS with some sane initial values */
@@ -5482,7 +5500,7 @@ static void wlc_bss_default_init(struct wlc_info *wlc)
 }
 
 static ratespec_t
-mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
+mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_c_band *cur_band,
 		       u32 int_val)
 {
 	u8 stf = (int_val & NRATE_STF_MASK) >> NRATE_STF_SHIFT;
@@ -5587,7 +5605,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		rspec |= RSPEC_SHORT_GI;
 
 	if ((rate != 0)
-	    && !wlc_valid_rate(wlc, rspec, cur_band->bandtype, true)) {
+	    && !brcms_c_valid_rate(wlc, rspec, cur_band->bandtype, true)) {
 		return rate;
 	}
 
@@ -5598,7 +5616,7 @@ done:
 
 /* formula:  IDLE_BUSY_RATIO_X_16 = (100-duty_cycle)/duty_cycle*16 */
 static int
-wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
+wlc_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 		   bool writeToShm)
 {
 	int idle_busy_ratio_x_16 = 0;
@@ -5614,7 +5632,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
 	/* Only write to shared memory  when wl is up */
 	if (writeToShm)
-		wlc_write_shm(wlc, offset, (u16) idle_busy_ratio_x_16);
+		brcms_c_write_shm(wlc, offset, (u16) idle_busy_ratio_x_16);
 
 	if (isOFDM)
 		wlc->tx_duty_cycle_ofdm = (u16) duty_cycle;
@@ -5627,7 +5645,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 /* Read a single u16 from shared memory.
  * SHM 'offset' needs to be an even address
  */
-u16 wlc_read_shm(struct wlc_info *wlc, uint offset)
+u16 brcms_c_read_shm(struct brcms_c_info *wlc, uint offset)
 {
 	return brcms_b_read_shm(wlc->hw, offset);
 }
@@ -5635,7 +5653,7 @@ u16 wlc_read_shm(struct wlc_info *wlc, uint offset)
 /* Write a single u16 to shared memory.
  * SHM 'offset' needs to be an even address
  */
-void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v)
+void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v)
 {
 	brcms_b_write_shm(wlc->hw, offset, v);
 }
@@ -5644,7 +5662,8 @@ void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v)
  * SHM 'offset' needs to be an even address and
  * Buffer length 'len' must be an even number of bytes
  */
-void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
+void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset, const void *buf,
+			int len)
 {
 	/* offset and len need to be even */
 	if (len <= 0 || (offset & 1) || (len & 1))
@@ -5655,35 +5674,35 @@ void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf, int len)
 }
 
 /* wrapper BMAC functions to for HIGH driver access */
-void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val)
+void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val)
 {
 	brcms_b_mctrl(wlc->hw, mask, val);
 }
 
-void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val, int bands)
+void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val, int bands)
 {
 	brcms_b_mhf(wlc->hw, idx, mask, val, bands);
 }
 
-int wlc_xmtfifo_sz_get(struct wlc_info *wlc, uint fifo, uint *blocks)
+int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo, uint *blocks)
 {
 	return brcms_b_xmtfifo_sz_get(wlc->hw, fifo, blocks);
 }
 
-void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
+void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset, int len,
 			    void *buf)
 {
 	brcms_b_write_template_ram(wlc->hw, offset, len, buf);
 }
 
-void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
+void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, void *bcn, int len,
 			       bool both)
 {
 	brcms_b_write_hw_bcntemplates(wlc->hw, bcn, len, both);
 }
 
 void
-wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
+brcms_c_set_addrmatch(struct brcms_c_info *wlc, int match_reg_offset,
 		  const u8 *addr)
 {
 	brcms_b_set_addrmatch(wlc->hw, match_reg_offset, addr);
@@ -5691,19 +5710,20 @@ wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
 		memcpy(wlc->cfg->BSSID, addr, ETH_ALEN);
 }
 
-void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit)
+void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, mbool req_bit)
 {
 	brcms_b_pllreq(wlc->hw, set, req_bit);
 }
 
-void wlc_reset_bmac_done(struct wlc_info *wlc)
+void brcms_c_reset_bmac_done(struct brcms_c_info *wlc)
 {
 }
 
 /* check for the particular priority flow control bit being set */
 bool
-wlc_txflowcontrol_prio_isset(struct wlc_info *wlc, struct wlc_txq_info *q,
-			     int prio)
+brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
+				 struct brcms_c_txq_info *q,
+				 int prio)
 {
 	uint prio_mask;
 
@@ -5717,8 +5737,9 @@ wlc_txflowcontrol_prio_isset(struct wlc_info *wlc, struct wlc_txq_info *q,
 }
 
 /* propagate the flow control to all interfaces using the given tx queue */
-void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
-		       bool on, int prio)
+void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
+			   struct brcms_c_txq_info *qi,
+			   bool on, int prio)
 {
 	uint prio_bits;
 	uint cur_bits;
@@ -5759,8 +5780,9 @@ void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
 }
 
 void
-wlc_txflowcontrol_override(struct wlc_info *wlc, struct wlc_txq_info *qi,
-			   bool on, uint override)
+brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
+			       struct brcms_c_txq_info *qi,
+			       bool on, uint override)
 {
 	uint prev_override;
 
@@ -5803,9 +5825,9 @@ wlc_txflowcontrol_override(struct wlc_info *wlc, struct wlc_txq_info *qi,
 	}
 }
 
-static void wlc_txflowcontrol_reset(struct wlc_info *wlc)
+static void wlc_txflowcontrol_reset(struct brcms_c_info *wlc)
 {
-	struct wlc_txq_info *qi;
+	struct brcms_c_txq_info *qi;
 
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
 		if (qi->stopped) {
@@ -5816,12 +5838,12 @@ static void wlc_txflowcontrol_reset(struct wlc_info *wlc)
 }
 
 static void
-wlc_txflowcontrol_signal(struct wlc_info *wlc, struct wlc_txq_info *qi, bool on,
-			 int prio)
+wlc_txflowcontrol_signal(struct brcms_c_info *wlc, struct brcms_c_txq_info *qi,
+			 bool on, int prio)
 {
 #ifdef NON_FUNCTIONAL
 	/* wlcif_list is never filled so this function is not functional */
-	struct wlc_if *wlcif;
+	struct brcms_c_if *wlcif;
 
 	for (wlcif = wlc->wlcif_list; wlcif != NULL; wlcif = wlcif->next) {
 		if (wlcif->qi == qi && wlcif->flags & WLC_IF_LINKED)
@@ -5830,11 +5852,11 @@ wlc_txflowcontrol_signal(struct wlc_info *wlc, struct wlc_txq_info *qi, bool on,
 #endif
 }
 
-static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
+static struct brcms_c_txq_info *wlc_txq_alloc(struct brcms_c_info *wlc)
 {
-	struct wlc_txq_info *qi, *p;
+	struct brcms_c_txq_info *qi, *p;
 
-	qi = kzalloc(sizeof(struct wlc_txq_info), GFP_ATOMIC);
+	qi = kzalloc(sizeof(struct brcms_c_txq_info), GFP_ATOMIC);
 	if (qi != NULL) {
 		/*
 		 * Have enough room for control packets along with HI watermark
@@ -5859,9 +5881,9 @@ static struct wlc_txq_info *wlc_txq_alloc(struct wlc_info *wlc)
 	return qi;
 }
 
-static void wlc_txq_free(struct wlc_info *wlc, struct wlc_txq_info *qi)
+static void wlc_txq_free(struct brcms_c_info *wlc, struct brcms_c_txq_info *qi)
 {
-	struct wlc_txq_info *p;
+	struct brcms_c_txq_info *p;
 
 	if (qi == NULL)
 		return;
@@ -5883,17 +5905,17 @@ static void wlc_txq_free(struct wlc_info *wlc, struct wlc_txq_info *qi)
 /*
  * Flag 'scan in progress' to withhold dynamic phy calibration
  */
-void wlc_scan_start(struct wlc_info *wlc)
+void brcms_c_scan_start(struct brcms_c_info *wlc)
 {
 	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, true);
 }
 
-void wlc_scan_stop(struct wlc_info *wlc)
+void brcms_c_scan_stop(struct brcms_c_info *wlc)
 {
 	wlc_phy_hold_upd(wlc->band->pi, PHY_HOLD_FOR_SCAN, false);
 }
 
-void wlc_associate_upd(struct wlc_info *wlc, bool state)
+void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state)
 {
 	wlc->pub->associated = state;
 	wlc->cfg->associated = state;
@@ -5904,7 +5926,7 @@ void wlc_associate_upd(struct wlc_info *wlc, bool state)
  * AMPDU traffic, packets pending in hardware have to be invalidated so that
  * when later on hardware releases them, they can be handled appropriately.
  */
-void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
+void brcms_c_inval_dma_pkts(struct brcms_c_hw_info *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn))
 {
@@ -5917,12 +5939,12 @@ void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
 	}
 }
 
-int wlc_get_curband(struct wlc_info *wlc)
+int brcms_c_get_curband(struct brcms_c_info *wlc)
 {
 	return wlc->band->bandunit;
 }
 
-void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
+void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 {
 	/* flush packet queue when requested */
 	if (drop)
@@ -5935,7 +5957,8 @@ void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop)
 	}
 }
 
-int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int int_val)
+int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
+		    int int_val)
 {
 	int err = 0;
 
@@ -5943,7 +5966,7 @@ int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int int_val)
 	case IOV_BCN_LI_BCN:
 		wlc->bcn_li_bcn = (u8) int_val;
 		if (wlc->pub->up)
-			wlc_bcn_li_upd(wlc);
+			brcms_c_bcn_li_upd(wlc);
 		break;
 		/* As long as override is false, this only sets the *user*
 		   targets. User can twiddle this all he wants with no harm.
@@ -5964,7 +5987,7 @@ int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int int_val)
 		}
 	case IOV_MPC:
 		wlc->mpc = (bool)int_val;
-		wlc_radio_mpc_upd(wlc);
+		brcms_c_radio_mpc_upd(wlc);
 		break;
 	default:
 		err = -ENOTSUPP;
@@ -5972,7 +5995,8 @@ int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int int_val)
 	return err;
 }
 
-int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr)
+int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
+		    int *ret_int_ptr)
 {
 	int err = 0;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index cc0772e..323f210 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -27,7 +27,7 @@
 #define	WL_HWRXOFF		38	/* chip rx buffer offset */
 #define	INVCHANNEL		255	/* invalid channel */
 #define	MAXCOREREV		28	/* max # supported core revisions (0 .. MAXCOREREV - 1) */
-#define WLC_MAXMODULES		22	/* max #  wlc_module_register() calls */
+#define WLC_MAXMODULES		22  /* max # brcms_c_module_register() calls */
 
 #define SEQNUM_SHIFT		4
 #define AMPDU_DELIMITER_LEN	4
@@ -74,7 +74,7 @@
 		 ((unsigned)(bits) << field ## _S))
 
 /* For managing scan result lists */
-struct wlc_bss_list {
+struct brcms_c_bss_list {
 	uint count;
 	bool beacon;		/* set for beacon, cleared for probe response */
 	wlc_bss_info_t *ptrs[MAXBSS];
@@ -135,7 +135,7 @@ struct wlc_bss_list {
 	(((cfg)->WPA_auth != WPA_AUTH_DISABLED && WSEC_ENABLED((cfg)->wsec)) ? \
 	(cfg)->wsec_portopen : true)
 
-#define PS_ALLOWED(wlc)	wlc_ps_allowed(wlc)
+#define PS_ALLOWED(wlc)	brcms_c_ps_allowed(wlc)
 
 #define DATA_BLOCK_TX_SUPR	(1 << 4)
 
@@ -236,7 +236,7 @@ extern const u8 prio2fifo[];
 
 #define WLCWLUNIT(wlc)		((wlc)->pub->unit)
 
-struct wlc_protection {
+struct brcms_c_protection {
 	bool _g;		/* use g spec protection, driver internal */
 	s8 g_override;	/* override for use of g spec protection */
 	u8 gmode_user;	/* user config gmode, operating band->gmode is different */
@@ -251,7 +251,7 @@ struct wlc_protection {
 };
 
 /* anything affects the single/dual streams/antenna operation */
-struct wlc_stf {
+struct brcms_c_stf {
 	u8 hw_txchain;	/* HW txchain bitmap cfg */
 	u8 txchain;		/* txchain bitmap being used */
 	u8 txstreams;	/* number of txchains being used */
@@ -295,7 +295,7 @@ struct wlc_stf {
 /* wlc_bss_info flag bit values */
 #define WLC_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
 
-/* Flags used in wlc_txq_info.stopped */
+/* Flags used in brcms_c_txq_info.stopped */
 #define TXQ_STOP_FOR_PRIOFC_MASK	0x000000FF	/* per prio flow control bits */
 #define TXQ_STOP_FOR_PKT_DRAIN		0x00000100	/* stop txq enqueue for packet drain */
 #define TXQ_STOP_FOR_AMPDU_FLOW_CNTRL	0x00000200	/* stop txq enqueue for ampdu flow control */
@@ -348,7 +348,7 @@ struct wsec_key {
 /*
  * core state (mac)
  */
-struct wlccore {
+struct brcms_c_core {
 	uint coreidx;		/* # sb enumerated core */
 
 	/* fifo */
@@ -361,7 +361,7 @@ struct wlccore {
 /*
  * band state (phy+ana+radio)
  */
-struct wlcband {
+struct brcms_c_band {
 	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 
@@ -393,7 +393,7 @@ struct wlcband {
 };
 
 /* tx completion callback takes 3 args */
-typedef void (*pkcb_fn_t) (struct wlc_info *wlc, uint txstatus, void *arg);
+typedef void (*pkcb_fn_t) (struct brcms_c_info *wlc, uint txstatus, void *arg);
 
 struct pkt_cb {
 	pkcb_fn_t fn;		/* function to call when tx frame completes */
@@ -441,8 +441,8 @@ struct wme_param_ie {
 } __attribute__((packed));
 
 /* virtual interface */
-struct wlc_if {
-	struct wlc_if *next;
+struct brcms_c_if {
+	struct brcms_c_if *next;
 	u8 type;		/* WLC_IFTYPE_BSS or WLC_IFTYPE_WDS */
 	u8 index;		/* assigned in wl_add_if(), index of the wlif if any,
 				 * not necessarily corresponding to bsscfg._idx or
@@ -450,17 +450,19 @@ struct wlc_if {
 				 */
 	u8 flags;		/* flags for the interface */
 	struct brcms_if *wlif;		/* pointer to wlif */
-	struct wlc_txq_info *qi;	/* pointer to associated tx queue */
+	struct brcms_c_txq_info *qi;	/* pointer to associated tx queue */
 	union {
-		struct scb *scb;	/* pointer to scb if WLC_IFTYPE_WDS */
-		struct wlc_bsscfg *bsscfg;	/* pointer to bsscfg if WLC_IFTYPE_BSS */
+		/* pointer to scb if WLC_IFTYPE_WDS */
+		struct scb *scb;
+		/* pointer to bsscfg if WLC_IFTYPE_BSS */
+		struct brcms_c_bsscfg *bsscfg;
 	} u;
 };
 
 /* flags for the interface, this interface is linked to a brcms_if */
 #define WLC_IF_LINKED		0x02
 
-struct wlc_hwband {
+struct brcms_c_hwband {
 	int bandtype;		/* WLC_BAND_2G, WLC_BAND_5G */
 	uint bandunit;		/* bandstate[] index */
 	u16 mhfs[MHFMAX];	/* MHF array shadow */
@@ -477,9 +479,9 @@ struct wlc_hwband {
 	bool abgphy_encore;
 };
 
-struct wlc_hw_info {
+struct brcms_c_hw_info {
 	bool _piomode;		/* true if pio mode */
-	struct wlc_info *wlc;
+	struct brcms_c_info *wlc;
 
 	/* fifo */
 	struct dma_pub *di[NFIFO];	/* dma handles, per fifo */
@@ -504,8 +506,9 @@ struct wlc_hw_info {
 	d11regs_t *regs;	/* pointer to device registers */
 	void *physhim;		/* phy shim layer handler */
 	void *phy_sh;		/* pointer to shared phy state */
-	struct wlc_hwband *band;/* pointer to active per-band state */
-	struct wlc_hwband *bandstate[MAXBANDS];/* band state per phy/radio */
+	struct brcms_c_hwband *band;/* pointer to active per-band state */
+	/* band state per phy/radio */
+	struct brcms_c_hwband *bandstate[MAXBANDS];
 	u16 bmac_phytxant;	/* cache of high phytxant state */
 	bool shortslot;		/* currently using 11g ShortSlot timing */
 	u16 SRL;		/* 802.11 dot11ShortRetryLimit */
@@ -558,8 +561,8 @@ struct wlc_hw_info {
  * if they belong to the same flow of traffic from the device. For multi-channel
  * operation there are independent TX Queues for each channel.
  */
-struct wlc_txq_info {
-	struct wlc_txq_info *next;
+struct brcms_c_txq_info {
+	struct brcms_c_txq_info *next;
 	struct pktq q;
 	uint stopped;		/* tx flow control bits */
 };
@@ -567,12 +570,13 @@ struct wlc_txq_info {
 /*
  * Principal common (os-independent) software data structure.
  */
-struct wlc_info {
+struct brcms_c_info {
 	struct wlc_pub *pub;		/* pointer to wlc public state */
 	struct brcms_info *wl;	/* pointer to os-specific private state */
 	d11regs_t *regs;	/* pointer to device registers */
 
-	struct wlc_hw_info *hw;	/* HW related state used primarily by BMAC */
+	/* HW related state used primarily by BMAC */
+	struct brcms_c_hw_info *hw;
 
 	/* clock */
 	int clkreq_override;	/* setting for clkreq for PCIE : Auto, 0, 1 */
@@ -589,11 +593,11 @@ struct wlc_info {
 	bool clk;		/* core is out of reset and has clock */
 
 	/* multiband */
-	struct wlccore *core;	/* pointer to active io core */
-	struct wlcband *band;	/* pointer to active per-band state */
-	struct wlccore *corestate;	/* per-core state (one per hw core) */
+	struct brcms_c_core *core;	/* pointer to active io core */
+	struct brcms_c_band *band;	/* pointer to active per-band state */
+	struct brcms_c_core *corestate;	/* per-core state (one per hw core) */
 	/* per-band state (one per phy/radio): */
-	struct wlcband *bandstate[MAXBANDS];
+	struct brcms_c_band *bandstate[MAXBANDS];
 
 	bool war16165;		/* PCI slow clock 16165 war flag */
 
@@ -633,7 +637,7 @@ struct wlc_info {
 	u8 mpc_dlycnt;	/* # of watchdog cnt before turn disable radio */
 	u8 mpc_offcnt;	/* # of watchdog cnt that radio is disabled */
 	u8 mpc_delay_off;	/* delay radio disable by # of watchdog cnt */
-	u8 prev_non_delay_mpc;	/* prev state wlc_is_non_delay_mpc */
+	u8 prev_non_delay_mpc;	/* prev state brcms_c_is_non_delay_mpc */
 
 	/* timer for watchdog routine */
 	struct brcms_timer *wdtimer;
@@ -674,11 +678,11 @@ struct wlc_info {
 	 * BSS Configurations set of BSS configurations, idx 0 is default and
 	 * always valid
 	 */
-	struct wlc_bsscfg *bsscfg[WLC_MAXBSSCFG];
-	struct wlc_bsscfg *cfg;	/* the primary bsscfg (can be AP or STA) */
+	struct brcms_c_bsscfg *bsscfg[WLC_MAXBSSCFG];
+	struct brcms_c_bsscfg *cfg; /* the primary bsscfg (can be AP or STA) */
 
 	/* tx queue */
-	struct wlc_txq_info *tx_queues;	/* common TX Queue list */
+	struct brcms_c_txq_info *tx_queues;	/* common TX Queue list */
 
 	/* security */
 	wsec_key_t *wsec_keys[WSEC_MAX_KEYS];	/* dynamic key storage */
@@ -730,10 +734,10 @@ struct wlc_info {
 	s8 shortslot_override;	/* 11g ShortSlot override */
 	bool include_legacy_erp;	/* include Legacy ERP info elt ID 47 as well as g ID 42 */
 
-	struct wlc_protection *protection;
+	struct brcms_c_protection *protection;
 	s8 PLCPHdr_override;	/* 802.11b Preamble Type override */
 
-	struct wlc_stf *stf;
+	struct brcms_c_stf *stf;
 
 	ratespec_t bcn_rspec;	/* save bcn ratespec purpose */
 
@@ -744,7 +748,7 @@ struct wlc_info {
 
 	u16 next_bsscfg_ID;
 
-	struct wlc_txq_info *pkt_queue; /* txq for transmit packets */
+	struct brcms_c_txq_info *pkt_queue; /* txq for transmit packets */
 	u32 mpc_dur;		/* total time (ms) in mpc mode except for the
 				 * portion since radio is turned off last time
 				 */
@@ -756,7 +760,7 @@ struct wlc_info {
 
 /* antsel module specific state */
 struct antsel_info {
-	struct wlc_info *wlc;	/* pointer to main wlc structure */
+	struct brcms_c_info *wlc;	/* pointer to main wlc structure */
 	struct wlc_pub *pub;		/* pointer to public fn */
 	u8 antsel_type;	/* Type of boardlevel mimo antenna switch-logic
 				 * 0 = N/A, 1 = 2x4 board, 2 = 2x3 CB2 board
@@ -768,8 +772,8 @@ struct antsel_info {
 };
 
 /* BSS configuration state */
-struct wlc_bsscfg {
-	struct wlc_info *wlc;	/* wlc to which this bsscfg belongs to. */
+struct brcms_c_bsscfg {
+	struct brcms_c_info *wlc; /* wlc to which this bsscfg belongs to. */
 	bool up;		/* is this configuration up operational */
 	bool enable;		/* is this configuration enabled */
 	bool associated;	/* is BSS in ASSOCIATED state */
@@ -867,140 +871,142 @@ struct wlc_bsscfg {
 #define WLC_IS_MATCH_SSID(wlc, ssid1, ssid2, len1, len2) \
 	((len1 == len2) && !memcmp(ssid1, ssid2, len1))
 
-extern void wlc_fatal_error(struct wlc_info *wlc);
-extern void wlc_bmac_rpc_watchdog(struct wlc_info *wlc);
-extern void wlc_recv(struct wlc_info *wlc, struct sk_buff *p);
-extern bool wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2);
-extern void wlc_txfifo(struct wlc_info *wlc, uint fifo, struct sk_buff *p,
-		       bool commit, s8 txpktpend);
-extern void wlc_txfifo_complete(struct wlc_info *wlc, uint fifo, s8 txpktpend);
-extern void wlc_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
-			uint prec);
-extern void wlc_info_init(struct wlc_info *wlc, int unit);
-extern void wlc_print_txstatus(tx_status_t *txs);
-extern int wlc_xmtfifo_sz_get(struct wlc_info *wlc, uint fifo, uint *blocks);
-extern void wlc_write_template_ram(struct wlc_info *wlc, int offset, int len,
-				   void *buf);
-extern void wlc_write_hw_bcntemplates(struct wlc_info *wlc, void *bcn, int len,
-				      bool both);
-extern void wlc_pllreq(struct wlc_info *wlc, bool set, mbool req_bit);
-extern void wlc_reset_bmac_done(struct wlc_info *wlc);
+extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
+extern void brcms_b_rpc_watchdog(struct brcms_c_info *wlc);
+extern void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p);
+extern bool brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs,
+			       u32 frm_tx2);
+extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
+			   struct sk_buff *p,
+			   bool commit, s8 txpktpend);
+extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
+				    s8 txpktpend);
+extern void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
+			    uint prec);
+extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
+extern void brcms_c_print_txstatus(tx_status_t *txs);
+extern int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo,
+				  uint *blocks);
+extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
+				       int len, void *buf);
+extern void brcms_c_write_hw_bcntemplates(struct brcms_c_info *wlc, void *bcn,
+					  int len, bool both);
+extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, mbool req_bit);
+extern void brcms_c_reset_bmac_done(struct brcms_c_info *wlc);
 
 #if defined(BCMDBG)
-extern void wlc_print_rxh(d11rxhdr_t *rxh);
-extern void wlc_print_hdrs(struct wlc_info *wlc, const char *prefix, u8 *frame,
-			   d11txh_t *txh, d11rxhdr_t *rxh, uint len);
-extern void wlc_print_txdesc(d11txh_t *txh);
+extern void brcms_c_print_rxh(d11rxhdr_t *rxh);
+extern void brcms_c_print_txdesc(d11txh_t *txh);
 #else
-#define wlc_print_txdesc(a)
-#endif
-#if defined(BCMDBG)
-extern void wlc_print_dot11_mac_hdr(u8 *buf, int len);
+#define brcms_c_print_txdesc(a)
 #endif
 
-extern void wlc_setxband(struct wlc_hw_info *wlc_hw, uint bandunit);
-extern void wlc_coredisable(struct wlc_hw_info *wlc_hw);
+extern void brcms_c_setxband(struct brcms_c_hw_info *wlc_hw, uint bandunit);
+extern void brcms_c_coredisable(struct brcms_c_hw_info *wlc_hw);
 
-extern bool wlc_valid_rate(struct wlc_info *wlc, ratespec_t rate, int band,
-			   bool verbose);
-extern void wlc_ap_upd(struct wlc_info *wlc);
+extern bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rate,
+			       int band, bool verbose);
+extern void brcms_c_ap_upd(struct brcms_c_info *wlc);
 
 /* helper functions */
-extern void wlc_shm_ssid_upd(struct wlc_info *wlc, struct wlc_bsscfg *cfg);
-extern int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config);
-
-extern void wlc_mac_bcn_promisc_change(struct wlc_info *wlc, bool promisc);
-extern void wlc_mac_bcn_promisc(struct wlc_info *wlc);
-extern void wlc_mac_promisc(struct wlc_info *wlc);
-extern void wlc_txflowcontrol(struct wlc_info *wlc, struct wlc_txq_info *qi,
-			      bool on, int prio);
-extern void wlc_txflowcontrol_override(struct wlc_info *wlc,
-				       struct wlc_txq_info *qi,
+extern void brcms_c_shm_ssid_upd(struct brcms_c_info *wlc,
+				 struct brcms_c_bsscfg *cfg);
+extern int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config);
+
+extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
+					   bool promisc);
+extern void brcms_c_mac_bcn_promisc(struct brcms_c_info *wlc);
+extern void brcms_c_mac_promisc(struct brcms_c_info *wlc);
+extern void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
+				  struct brcms_c_txq_info *qi,
+				  bool on, int prio);
+extern void brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
+				       struct brcms_c_txq_info *qi,
 				       bool on, uint override);
-extern bool wlc_txflowcontrol_prio_isset(struct wlc_info *wlc,
-					 struct wlc_txq_info *qi, int prio);
-extern void wlc_send_q(struct wlc_info *wlc);
-extern int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifo);
-
-extern u16 wlc_calc_lsig_len(struct wlc_info *wlc, ratespec_t ratespec,
+extern bool brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
+					     struct brcms_c_txq_info *qi,
+					     int prio);
+extern void brcms_c_send_q(struct brcms_c_info *wlc);
+extern int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu,
+			    uint *fifo);
+
+extern u16 brcms_c_calc_lsig_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 				uint mac_len);
-extern ratespec_t wlc_rspec_to_rts_rspec(struct wlc_info *wlc, ratespec_t rspec,
-					 bool use_rspec, u16 mimo_ctlchbw);
-extern u16 wlc_compute_rtscts_dur(struct wlc_info *wlc, bool cts_only,
-				     ratespec_t rts_rate, ratespec_t frame_rate,
-				     u8 rts_preamble_type,
-				     u8 frame_preamble_type, uint frame_len,
-				     bool ba);
-
-extern void wlc_tbtt(struct wlc_info *wlc);
-extern void wlc_inval_dma_pkts(struct wlc_hw_info *hw,
+extern ratespec_t brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc,
+					     ratespec_t rspec,
+					     bool use_rspec, u16 mimo_ctlchbw);
+extern u16 brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
+				      ratespec_t rts_rate,
+				      ratespec_t frame_rate,
+				      u8 rts_preamble_type,
+				      u8 frame_preamble_type, uint frame_len,
+				      bool ba);
+
+extern void brcms_c_tbtt(struct brcms_c_info *wlc);
+extern void brcms_c_inval_dma_pkts(struct brcms_c_hw_info *hw,
 			       struct ieee80211_sta *sta,
 			       void (*dma_callback_fn));
 
-#if defined(BCMDBG)
-extern void wlc_dump_ie(struct wlc_info *wlc, struct brcmu_tlv *ie,
-			struct brcmu_strbuf *b);
-#endif
-
-extern void wlc_reprate_init(struct wlc_info *wlc);
-extern void wlc_bsscfg_reprate_init(struct wlc_bsscfg *bsscfg);
+extern void brcms_c_reprate_init(struct brcms_c_info *wlc);
+extern void brcms_c_bsscfg_reprate_init(struct brcms_c_bsscfg *bsscfg);
 
 /* Shared memory access */
-extern void wlc_write_shm(struct wlc_info *wlc, uint offset, u16 v);
-extern u16 wlc_read_shm(struct wlc_info *wlc, uint offset);
-extern void wlc_copyto_shm(struct wlc_info *wlc, uint offset, const void *buf,
-			   int len);
-
-extern void wlc_update_beacon(struct wlc_info *wlc);
-extern void wlc_bss_update_beacon(struct wlc_info *wlc,
-				  struct wlc_bsscfg *bsscfg);
-
-extern void wlc_update_probe_resp(struct wlc_info *wlc, bool suspend);
-extern void wlc_bss_update_probe_resp(struct wlc_info *wlc,
-				      struct wlc_bsscfg *cfg, bool suspend);
-
-extern bool wlc_ismpc(struct wlc_info *wlc);
-extern bool wlc_is_non_delay_mpc(struct wlc_info *wlc);
-extern void wlc_radio_mpc_upd(struct wlc_info *wlc);
-extern bool wlc_prec_enq(struct wlc_info *wlc, struct pktq *q, void *pkt,
-			 int prec);
-extern bool wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q,
+extern void brcms_c_write_shm(struct brcms_c_info *wlc, uint offset, u16 v);
+extern u16 brcms_c_read_shm(struct brcms_c_info *wlc, uint offset);
+extern void brcms_c_copyto_shm(struct brcms_c_info *wlc, uint offset,
+			       const void *buf, int len);
+
+extern void brcms_c_update_beacon(struct brcms_c_info *wlc);
+extern void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
+				  struct brcms_c_bsscfg *bsscfg);
+
+extern void brcms_c_update_probe_resp(struct brcms_c_info *wlc, bool suspend);
+extern void brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
+					  struct brcms_c_bsscfg *cfg,
+					  bool suspend);
+extern bool brcms_c_ismpc(struct brcms_c_info *wlc);
+extern bool brcms_c_is_non_delay_mpc(struct brcms_c_info *wlc);
+extern void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc);
+extern bool brcms_c_prec_enq(struct brcms_c_info *wlc, struct pktq *q,
+			     void *pkt, int prec);
+extern bool brcms_c_prec_enq_head(struct brcms_c_info *wlc, struct pktq *q,
 			      struct sk_buff *pkt, int prec, bool head);
-extern u16 wlc_phytxctl1_calc(struct wlc_info *wlc, ratespec_t rspec);
-extern void wlc_compute_plcp(struct wlc_info *wlc, ratespec_t rate, uint length,
-			     u8 *plcp);
-extern uint wlc_calc_frame_time(struct wlc_info *wlc, ratespec_t ratespec,
-				u8 preamble_type, uint mac_len);
-
-extern void wlc_set_chanspec(struct wlc_info *wlc, chanspec_t chanspec);
+extern u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec);
+extern void brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rate,
+				 uint length, u8 *plcp);
+extern uint brcms_c_calc_frame_time(struct brcms_c_info *wlc,
+				    ratespec_t ratespec,
+				    u8 preamble_type, uint mac_len);
 
-extern bool wlc_timers_init(struct wlc_info *wlc, int unit);
+extern void brcms_c_set_chanspec(struct brcms_c_info *wlc,
+				 chanspec_t chanspec);
 
-#if defined(BCMDBG)
-extern void wlc_print_ies(struct wlc_info *wlc, u8 *ies, uint ies_len);
-#endif
+extern bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit);
 
-extern int wlc_set_nmode(struct wlc_info *wlc, s32 nmode);
-extern void wlc_mimops_action_ht_send(struct wlc_info *wlc,
-				      struct wlc_bsscfg *bsscfg,
+extern int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode);
+extern void brcms_c_mimops_action_ht_send(struct brcms_c_info *wlc,
+				      struct brcms_c_bsscfg *bsscfg,
 				      u8 mimops_mode);
 
-extern void wlc_switch_shortslot(struct wlc_info *wlc, bool shortslot);
-extern void wlc_set_bssid(struct wlc_bsscfg *cfg);
-extern void wlc_edcf_setparams(struct wlc_info *wlc, bool suspend);
+extern void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot);
+extern void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg);
+extern void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend);
 
-extern void wlc_set_ratetable(struct wlc_info *wlc);
-extern int wlc_set_mac(struct wlc_bsscfg *cfg);
-extern void wlc_beacon_phytxctl_txant_upd(struct wlc_info *wlc,
+extern void brcms_c_set_ratetable(struct brcms_c_info *wlc);
+extern int brcms_c_set_mac(struct brcms_c_bsscfg *cfg);
+extern void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 					  ratespec_t bcn_rate);
-extern void wlc_mod_prb_rsp_rate_table(struct wlc_info *wlc, uint frame_len);
-extern ratespec_t wlc_lowest_basic_rspec(struct wlc_info *wlc,
-					 wlc_rateset_t *rs);
-extern void wlc_radio_disable(struct wlc_info *wlc);
-extern void wlc_bcn_li_upd(struct wlc_info *wlc);
-extern void wlc_set_home_chanspec(struct wlc_info *wlc, chanspec_t chanspec);
-extern bool wlc_ps_allowed(struct wlc_info *wlc);
-extern bool wlc_stay_awake(struct wlc_info *wlc);
-extern void wlc_wme_initparams_sta(struct wlc_info *wlc, wme_param_ie_t *pe);
+extern void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc,
+					   uint frame_len);
+extern ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
+					     wlc_rateset_t *rs);
+extern void brcms_c_radio_disable(struct brcms_c_info *wlc);
+extern void brcms_c_bcn_li_upd(struct brcms_c_info *wlc);
+extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
+				      chanspec_t chanspec);
+extern bool brcms_c_ps_allowed(struct brcms_c_info *wlc);
+extern bool brcms_c_stay_awake(struct brcms_c_info *wlc);
+extern void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc,
+				       wme_param_ie_t *pe);
 
 #endif				/* _BRCM_MAIN_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 1e6885c..fa0ff3f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -49,7 +49,7 @@ struct wlc_phy_srom_fem {
 	u8 antswctrllut;	/* antswctrl lookup table configuration: 32 possible choices */
 };
 
-struct wlc_hw_info;
+struct brcms_c_hw_info;
 typedef void (*initfn_t) (phy_info_t *);
 typedef void (*chansetfn_t) (phy_info_t *, chanspec_t);
 typedef int (*longtrnfn_t) (phy_info_t *, int);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 972898b..728b9e2 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -30,12 +30,12 @@
 
 /* PHY SHIM module specific state */
 struct wlc_phy_shim_info {
-	struct wlc_hw_info *wlc_hw;	/* pointer to main wlc_hw structure */
+	struct brcms_c_hw_info *wlc_hw;	/* pointer to main wlc_hw structure */
 	void *wlc;		/* pointer to main wlc structure */
 	void *wl;		/* pointer to os-specific private state */
 };
 
-wlc_phy_shim_info_t *wlc_phy_shim_attach(struct wlc_hw_info *wlc_hw,
+wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 						       void *wl, void *wlc) {
 	wlc_phy_shim_info_t *physhim = NULL;
 
@@ -122,7 +122,7 @@ void wlapi_bmac_corereset(wlc_phy_shim_info_t *physhim, u32 flags)
 
 void wlapi_suspend_mac_and_wait(wlc_phy_shim_info_t *physhim)
 {
-	wlc_suspend_mac_and_wait(physhim->wlc);
+	brcms_c_suspend_mac_and_wait(physhim->wlc);
 }
 
 void wlapi_switch_macfreq(wlc_phy_shim_info_t *physhim, u8 spurmode)
@@ -132,7 +132,7 @@ void wlapi_switch_macfreq(wlc_phy_shim_info_t *physhim, u8 spurmode)
 
 void wlapi_enable_mac(wlc_phy_shim_info_t *physhim)
 {
-	wlc_enable_mac(physhim->wlc);
+	brcms_c_enable_mac(physhim->wlc);
 }
 
 void wlapi_bmac_mctrl(wlc_phy_shim_info_t *physhim, u32 mask, u32 val)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 4e1a51d..4b45b2c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -109,9 +109,9 @@
 #define WLC_N_TXRX_CHAIN1		1
 
 /* Forward declarations */
-struct wlc_hw_info;
+struct brcms_c_hw_info;
 
-extern wlc_phy_shim_info_t *wlc_phy_shim_attach(struct wlc_hw_info *wlc_hw,
+extern wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 						void *wl, void *wlc);
 extern void wlc_phy_shim_detach(wlc_phy_shim_info_t *physhim);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index cdb4cc6..25c65e8 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -188,9 +188,9 @@ struct wlc_bss_info {
 };
 
 /* forward declarations */
-struct wlc_if;
+struct brcms_c_if;
 
-/* wlc_ioctl error codes */
+/* brcms_c_ioctl error codes */
 #define WLC_ENOIOCTL	1	/* No such Ioctl */
 #define WLC_EINVAL	2	/* Invalid value */
 #define WLC_ETOOSMALL	3	/* Value too small */
@@ -231,14 +231,14 @@ typedef int (*dump_fn_t) (void *handle, struct brcmu_strbuf *b);
  * params/plen - parameters and length for a get, input only.
  * arg/len - buffer and length for value to be set or retrieved, input or output.
  * vsize - value size, valid for integer type only.
- * wlcif - interface context (wlc_if pointer)
+ * wlcif - interface context (brcms_c_if pointer)
  *
  * All pointers may point into the same buffer.
  */
 typedef int (*iovar_fn_t) (void *handle, const struct brcmu_iovar *vi,
 			   u32 actionid, const char *name, void *params,
 			   uint plen, void *arg, int alen, int vsize,
-			   struct wlc_if *wlcif);
+			   struct brcms_c_if *wlcif);
 
 #define MAC80211_PROMISC_BCNS	(1 << 0)
 #define MAC80211_SCAN		(1 << 1)
@@ -387,10 +387,10 @@ enum wlc_par_id {
 /* forward declare and use the struct notation so we don't have to
  * have it defined if not necessary.
  */
-struct wlc_info;
-struct wlc_hw_info;
-struct wlc_bsscfg;
-struct wlc_if;
+struct brcms_c_info;
+struct brcms_c_hw_info;
+struct brcms_c_bsscfg;
+struct brcms_c_if;
 
 /***********************************************
  * Feature-related macros to optimize out code *
@@ -589,77 +589,85 @@ struct wlc_antselcfg {
 };
 
 /* common functions for every port */
-extern void *wlc_attach(struct brcms_info *wl, u16 vendor, u16 device,
+extern void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device,
 			uint unit, bool piomode, void *regsva, uint bustype,
 			void *btparam, uint *perr);
-extern uint wlc_detach(struct wlc_info *wlc);
-extern int wlc_up(struct wlc_info *wlc);
-extern uint wlc_down(struct wlc_info *wlc);
-
-extern int wlc_set(struct wlc_info *wlc, int cmd, int arg);
-extern int wlc_get(struct wlc_info *wlc, int cmd, int *arg);
-extern bool wlc_chipmatch(u16 vendor, u16 device);
-extern void wlc_init(struct wlc_info *wlc);
-extern void wlc_reset(struct wlc_info *wlc);
-
-extern void wlc_intrson(struct wlc_info *wlc);
-extern u32 wlc_intrsoff(struct wlc_info *wlc);
-extern void wlc_intrsrestore(struct wlc_info *wlc, u32 macintmask);
-extern bool wlc_intrsupd(struct wlc_info *wlc);
-extern bool wlc_isr(struct wlc_info *wlc, bool *wantdpc);
-extern bool wlc_dpc(struct wlc_info *wlc, bool bounded);
-extern bool wlc_sendpkt_mac80211(struct wlc_info *wlc, struct sk_buff *sdu,
-				 struct ieee80211_hw *hw);
-extern int wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
-		     struct wlc_if *wlcif);
-extern bool wlc_aggregatable(struct wlc_info *wlc, u8 tid);
+extern uint brcms_c_detach(struct brcms_c_info *wlc);
+extern int brcms_c_up(struct brcms_c_info *wlc);
+extern uint brcms_c_down(struct brcms_c_info *wlc);
+
+extern int brcms_c_set(struct brcms_c_info *wlc, int cmd, int arg);
+extern int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg);
+extern bool brcms_c_chipmatch(u16 vendor, u16 device);
+extern void brcms_c_init(struct brcms_c_info *wlc);
+extern void brcms_c_reset(struct brcms_c_info *wlc);
+
+extern void brcms_c_intrson(struct brcms_c_info *wlc);
+extern u32 brcms_c_intrsoff(struct brcms_c_info *wlc);
+extern void brcms_c_intrsrestore(struct brcms_c_info *wlc, u32 macintmask);
+extern bool brcms_c_intrsupd(struct brcms_c_info *wlc);
+extern bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc);
+extern bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded);
+extern bool brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc,
+				     struct sk_buff *sdu,
+				     struct ieee80211_hw *hw);
+extern int brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+			 struct brcms_c_if *wlcif);
+extern bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid);
 
 /* helper functions */
-extern void wlc_statsupd(struct wlc_info *wlc);
-extern void wlc_protection_upd(struct wlc_info *wlc, uint idx, int val);
-extern int wlc_get_header_len(void);
-extern void wlc_mac_bcn_promisc_change(struct wlc_info *wlc, bool promisc);
-extern void wlc_set_addrmatch(struct wlc_info *wlc, int match_reg_offset,
-			      const u8 *addr);
-extern void wlc_wme_setparams(struct wlc_info *wlc, u16 aci,
+extern void brcms_c_statsupd(struct brcms_c_info *wlc);
+extern void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx,
+				   int val);
+extern int brcms_c_get_header_len(void);
+extern void brcms_c_mac_bcn_promisc_change(struct brcms_c_info *wlc,
+					   bool promisc);
+extern void brcms_c_set_addrmatch(struct brcms_c_info *wlc,
+				  int match_reg_offset,
+				  const u8 *addr);
+extern void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 			      const struct ieee80211_tx_queue_params *arg,
 			      bool suspend);
-extern struct wlc_pub *wlc_pub(void *wlc);
+extern struct wlc_pub *brcms_c_pub(void *wlc);
 
 /* common functions for every port */
-extern void wlc_mhf(struct wlc_info *wlc, u8 idx, u16 mask, u16 val,
+extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
 		    int bands);
-extern void wlc_rate_lookup_init(struct wlc_info *wlc, wlc_rateset_t *rateset);
-extern void wlc_default_rateset(struct wlc_info *wlc, wlc_rateset_t *rs);
+extern void wlc_rate_lookup_init(struct brcms_c_info *wlc,
+				 wlc_rateset_t *rateset);
+extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
 
 struct ieee80211_sta;
-extern void wlc_ampdu_flush(struct wlc_info *wlc, struct ieee80211_sta *sta,
-			    u16 tid);
-extern int wlc_set_par(struct wlc_info *wlc, enum wlc_par_id par_id, int val);
-extern int wlc_get_par(struct wlc_info *wlc, enum wlc_par_id par_id, int *ret_int_ptr);
+extern void wlc_ampdu_flush(struct brcms_c_info *wlc,
+			    struct ieee80211_sta *sta, u16 tid);
+extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
+			   int val);
+extern int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
+			   int *ret_int_ptr);
 extern char *getvar(char *vars, const char *name);
 extern int getintvar(char *vars, const char *name);
 
 /* wlc_phy.c helper functions */
-extern void wlc_set_ps_ctrl(struct wlc_info *wlc);
-extern void wlc_mctrl(struct wlc_info *wlc, u32 mask, u32 val);
+extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
+extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
 
-extern int wlc_module_register(struct wlc_pub *pub,
+extern int brcms_c_module_register(struct wlc_pub *pub,
 			       const char *name, void *hdl,
 			       watchdog_fn_t watchdog_fn, down_fn_t down_fn);
-extern int wlc_module_unregister(struct wlc_pub *pub, const char *name,
+extern int brcms_c_module_unregister(struct wlc_pub *pub, const char *name,
 				 void *hdl);
-extern void wlc_suspend_mac_and_wait(struct wlc_info *wlc);
-extern void wlc_enable_mac(struct wlc_info *wlc);
-extern void wlc_associate_upd(struct wlc_info *wlc, bool state);
-extern void wlc_scan_start(struct wlc_info *wlc);
-extern void wlc_scan_stop(struct wlc_info *wlc);
-extern int wlc_get_curband(struct wlc_info *wlc);
-extern void wlc_wait_for_tx_completion(struct wlc_info *wlc, bool drop);
+extern void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc);
+extern void brcms_c_enable_mac(struct brcms_c_info *wlc);
+extern void brcms_c_associate_upd(struct brcms_c_info *wlc, bool state);
+extern void brcms_c_scan_start(struct brcms_c_info *wlc);
+extern void brcms_c_scan_stop(struct brcms_c_info *wlc);
+extern int brcms_c_get_curband(struct brcms_c_info *wlc);
+extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
+					   bool drop);
 
 /* helper functions */
-extern bool wlc_check_radio_disabled(struct wlc_info *wlc);
-extern bool wlc_radio_monitor_stop(struct wlc_info *wlc);
+extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
+extern bool wlc_radio_monitor_stop(struct brcms_c_info *wlc);
 
 #define	MAXBANDS		2	/* Maximum #of bands */
 /* bandstate array indices */
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 41dd168..8276e76c 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -31,13 +31,13 @@
 #define WLC_STF_SS_STBC_RX(wlc) (WLCISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
-static bool wlc_stf_stbc_tx_set(struct wlc_info *wlc, s32 int_val);
-static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 val);
-static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val);
-static void wlc_stf_stbc_rx_ht_update(struct wlc_info *wlc, int val);
+static bool wlc_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val);
+static int wlc_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 val);
+static int wlc_stf_spatial_policy_set(struct brcms_c_info *wlc, int val);
+static void wlc_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val);
 
-static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc);
-static u16 _wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec);
+static void _wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
+static u16 _wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec);
 
 #define NSTS_1	1
 #define NSTS_2	2
@@ -51,7 +51,7 @@ const u8 txcore_default[5] = {
 	(0x0f)			/* For Nsts = 4, enable all cores */
 };
 
-static void wlc_stf_stbc_rx_ht_update(struct wlc_info *wlc, int val)
+static void wlc_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 {
 	/* MIMOPHYs rev3-6 cannot receive STBC with only one rx core active */
 	if (WLC_STF_SS_STBC_RX(wlc)) {
@@ -63,13 +63,13 @@ static void wlc_stf_stbc_rx_ht_update(struct wlc_info *wlc, int val)
 	wlc->ht_cap.cap_info |= (val << IEEE80211_HT_CAP_RX_STBC_SHIFT);
 
 	if (wlc->pub->up) {
-		wlc_update_beacon(wlc);
-		wlc_update_probe_resp(wlc, true);
+		brcms_c_update_beacon(wlc);
+		brcms_c_update_probe_resp(wlc, true);
 	}
 }
 
 /* every WLC_TEMPSENSE_PERIOD seconds temperature check to decide whether to turn on/off txchain */
-void wlc_tempsense_upd(struct wlc_info *wlc)
+void wlc_tempsense_upd(struct brcms_c_info *wlc)
 {
 	wlc_phy_t *pi = wlc->band->pi;
 	uint active_chains, txchain;
@@ -93,7 +93,7 @@ void wlc_tempsense_upd(struct wlc_info *wlc)
 }
 
 void
-wlc_stf_ss_algo_channel_get(struct wlc_info *wlc, u16 *ss_algo_channel,
+wlc_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 			    chanspec_t chanspec)
 {
 	tx_power_t power;
@@ -134,7 +134,7 @@ wlc_stf_ss_algo_channel_get(struct wlc_info *wlc, u16 *ss_algo_channel,
 		setbit(ss_algo_channel, PHY_TXC1_MODE_STBC);
 }
 
-static bool wlc_stf_stbc_tx_set(struct wlc_info *wlc, s32 int_val)
+static bool wlc_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 {
 	if ((int_val != AUTO) && (int_val != OFF) && (int_val != ON)) {
 		return false;
@@ -155,7 +155,7 @@ static bool wlc_stf_stbc_tx_set(struct wlc_info *wlc, s32 int_val)
 	return true;
 }
 
-bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val)
+bool wlc_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 {
 	if ((int_val != HT_CAP_RX_STBC_NO)
 	    && (int_val != HT_CAP_RX_STBC_ONE_STREAM)) {
@@ -172,7 +172,7 @@ bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val)
 	return true;
 }
 
-static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
+static int wlc_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 core_mask)
 {
 	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, Nsts, core_mask);
@@ -196,16 +196,16 @@ static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 		wlc->stf->phytxant = core_mask << PHY_TXC_ANT_SHIFT;
 		brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
 		if (wlc->clk) {
-			wlc_suspend_mac_and_wait(wlc);
-			wlc_beacon_phytxctl_txant_upd(wlc, wlc->bcn_rspec);
-			wlc_enable_mac(wlc);
+			brcms_c_suspend_mac_and_wait(wlc);
+			brcms_c_beacon_phytxctl_txant_upd(wlc, wlc->bcn_rspec);
+			brcms_c_enable_mac(wlc);
 		}
 	}
 
 	return 0;
 }
 
-static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val)
+static int wlc_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
 {
 	int i;
 	u8 core_mask = 0;
@@ -221,7 +221,7 @@ static int wlc_stf_spatial_policy_set(struct wlc_info *wlc, int val)
 	return 0;
 }
 
-int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
+int wlc_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 {
 	u8 txchain = (u8) int_val;
 	u8 txstreams;
@@ -288,7 +288,7 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 }
 
 /* update wlc->stf->ss_opmode which represents the operational stf_ss mode we're using */
-int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band)
+int wlc_stf_ss_update(struct brcms_c_info *wlc, struct brcms_c_band *band)
 {
 	int ret_code = 0;
 	u8 prev_stf_ss;
@@ -320,7 +320,7 @@ int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band)
 	return ret_code;
 }
 
-int wlc_stf_attach(struct wlc_info *wlc)
+int wlc_stf_attach(struct brcms_c_info *wlc)
 {
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_SISO;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_CDD;
@@ -343,7 +343,7 @@ int wlc_stf_attach(struct wlc_info *wlc)
 	return 0;
 }
 
-void wlc_stf_detach(struct wlc_info *wlc)
+void wlc_stf_detach(struct brcms_c_info *wlc)
 {
 }
 
@@ -361,7 +361,7 @@ void wlc_stf_detach(struct wlc_info *wlc)
  *    do tx-antenna selection for SISO transmissions
  * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7 means both cores active
 */
-static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc)
+static void _wlc_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
 	s8 txant;
 
@@ -399,12 +399,12 @@ static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc)
 	brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
 }
 
-void wlc_stf_phy_txant_upd(struct wlc_info *wlc)
+void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
 	_wlc_stf_phy_txant_upd(wlc);
 }
 
-void wlc_stf_phy_chain_calc(struct wlc_info *wlc)
+void wlc_stf_phy_chain_calc(struct brcms_c_info *wlc)
 {
 	/* get available rx/tx chains */
 	wlc->stf->hw_txchain = (u8) getintvar(wlc->pub->vars, "txchain");
@@ -441,7 +441,7 @@ void wlc_stf_phy_chain_calc(struct wlc_info *wlc)
 	wlc_stf_spatial_policy_set(wlc, MIN_SPATIAL_EXPANSION);
 }
 
-static u16 _wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec)
+static u16 _wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 
@@ -453,12 +453,12 @@ static u16 _wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec)
 	return phytxant;
 }
 
-u16 wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec)
+u16 wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
 {
 	return _wlc_stf_phytxchain_sel(wlc, rspec);
 }
 
-u16 wlc_stf_d11hdrs_phyctl_txant(struct wlc_info *wlc, ratespec_t rspec)
+u16 wlc_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, ratespec_t rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 	u16 mask = PHY_TXC_ANT_MASK;
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
index 0b48f4d..a68c819 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/stf.h
@@ -19,20 +19,23 @@
 
 #include "types.h"
 
-extern int wlc_stf_attach(struct wlc_info *wlc);
-extern void wlc_stf_detach(struct wlc_info *wlc);
+extern int wlc_stf_attach(struct brcms_c_info *wlc);
+extern void wlc_stf_detach(struct brcms_c_info *wlc);
 
-extern void wlc_tempsense_upd(struct wlc_info *wlc);
-extern void wlc_stf_ss_algo_channel_get(struct wlc_info *wlc,
+extern void wlc_tempsense_upd(struct brcms_c_info *wlc);
+extern void wlc_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
 					u16 *ss_algo_channel,
 					chanspec_t chanspec);
-extern int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band);
-extern void wlc_stf_phy_txant_upd(struct wlc_info *wlc);
-extern int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force);
-extern bool wlc_stf_stbc_rx_set(struct wlc_info *wlc, s32 int_val);
-extern void wlc_stf_phy_txant_upd(struct wlc_info *wlc);
-extern void wlc_stf_phy_chain_calc(struct wlc_info *wlc);
-extern u16 wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec);
-extern u16 wlc_stf_d11hdrs_phyctl_txant(struct wlc_info *wlc, ratespec_t rspec);
+extern int wlc_stf_ss_update(struct brcms_c_info *wlc,
+			     struct brcms_c_band *band);
+extern void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
+extern int wlc_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val,
+			       bool force);
+extern bool wlc_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val);
+extern void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
+extern void wlc_stf_phy_chain_calc(struct brcms_c_info *wlc);
+extern u16 wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec);
+extern u16 wlc_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc,
+					ratespec_t rspec);
 
 #endif				/* _BRCM_STF_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index c4f7d9d..3f53e8c 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -206,7 +206,7 @@
  * Defaults for tunables (e.g. sizing constants)
  *
  * For each new tunable, add a member to the end
- * of wlc_tunables_t in wlc_pub.h to enable
+ * of wlc_tunables_t in brcms_c_pub.h to enable
  * runtime checks of tunable values. (Directly
  * using the macros in code invalidates ROM code)
  *
@@ -235,7 +235,7 @@
 #define WLC_AMPDUDATAHIWAT 255
 
 /* bounded rx loops */
-#define RXBND		8	/* max # frames to process in wlc_recv() */
+#define RXBND		8	/* max # frames to process in brcms_c_recv() */
 #define TXSBND		8	/* max # tx status to process in wlc_txstatus() */
 
 #define WLBANDINITFN(_fn)	_fn
@@ -355,22 +355,22 @@ typedef u32 mbool;
 /* forward declarations */
 struct sk_buff;
 struct brcms_info;
-struct wlc_info;
-struct wlc_hw_info;
-struct wlc_if;
+struct brcms_c_info;
+struct brcms_c_hw_info;
+struct brcms_c_if;
 struct brcms_if;
 struct ampdu_info;
 struct antsel_info;
 struct bmac_pmq;
 struct d11init;
 struct dma_pub;
-struct wlc_bsscfg;
+struct brcms_c_bsscfg;
 struct brcmu_strbuf;
 struct si_pub;
 struct wiphy;
 struct brcmu_iovar;
-struct wlc_txq_info;
-struct wlcband;
+struct brcms_c_txq_info;
+struct brcms_c_band;
 
 typedef struct gpioh_item gpioh_item_t;
 typedef struct si_info si_info_t;
-- 
1.7.4.1


