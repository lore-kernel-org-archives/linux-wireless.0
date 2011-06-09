Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2515 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab1FIOpS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/21] staging: brcm80211: further replaced wlc_ by
 brcmsmac_c_
Date: Thu, 9 Jun 2011 16:44:56 +0200
Message-ID: <1307630701-9170-17-git-send-email-rvossen@broadcom.com> (sfid-20110609_164605_609323_392307C8)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Renamed functions.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |    6 +-
 drivers/staging/brcm80211/brcmsmac/alloc.h       |    5 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |  111 ++++++------
 drivers/staging/brcm80211/brcmsmac/ampdu.h       |   15 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c      |   48 +++---
 drivers/staging/brcm80211/brcmsmac/antsel.h      |   10 +-
 drivers/staging/brcm80211/brcmsmac/channel.c     |  202 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/channel.h     |   12 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  129 +++++++-------
 drivers/staging/brcm80211/brcmsmac/pub.h         |    6 +-
 drivers/staging/brcm80211/brcmsmac/rate.c        |   38 ++--
 drivers/staging/brcm80211/brcmsmac/rate.h        |   28 ++--
 drivers/staging/brcm80211/brcmsmac/stf.c         |   81 +++++----
 drivers/staging/brcm80211/brcmsmac/stf.h         |   25 ++--
 15 files changed, 366 insertions(+), 352 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index b66418e..dbf64d7 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -126,7 +126,7 @@ static void wlc_bsscfg_ID_assign(struct brcms_c_info *wlc,
 /*
  * The common driver entry routine. Error codes should be unique
  */
-struct brcms_c_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
+struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 {
 	struct brcms_c_info *wlc;
 
@@ -246,11 +246,11 @@ struct brcms_c_info *wlc_attach_malloc(uint unit, uint *err, uint devid)
 	return wlc;
 
  fail:
-	wlc_detach_mfree(wlc);
+	brcms_c_detach_mfree(wlc);
 	return NULL;
 }
 
-void wlc_detach_mfree(struct brcms_c_info *wlc)
+void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 {
 	if (wlc == NULL)
 		return;
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.h b/drivers/staging/brcm80211/brcmsmac/alloc.h
index b8dc287..f465d30 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.h
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.h
@@ -14,5 +14,6 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-extern struct brcms_c_info *wlc_attach_malloc(uint unit, uint *err, uint devid);
-extern void wlc_detach_mfree(struct brcms_c_info *wlc);
+extern struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err,
+						  uint devid);
+extern void brcms_c_detach_mfree(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 0795679..b8c6002 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -110,35 +110,37 @@ struct cb_del_ampdu_pars {
 #define SCB_AMPDU_CUBBY(ampdu, scb) (&(scb->scb_ampdu))
 #define SCB_AMPDU_INI(scb_ampdu, tid) (&(scb_ampdu->ini[tid]))
 
-static void wlc_ffpld_init(struct ampdu_info *ampdu);
-static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int f);
-static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
+static void brcms_c_ffpld_init(struct ampdu_info *ampdu);
+static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int f);
+static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f);
 
-static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
+static scb_ampdu_tid_ini_t *brcms_c_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 						   scb_ampdu_t *scb_ampdu,
 						   u8 tid, bool override);
-static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur);
-static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb);
-static void scb_ampdu_update_config_all(struct ampdu_info *ampdu);
+static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu,
+					       u8 dur);
+static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
+					    struct scb *scb);
+static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu);
 
-#define wlc_ampdu_txflowcontrol(a, b, c)	do {} while (0)
+#define brcms_c_ampdu_txflowcontrol(a, b, c)	do {} while (0)
 
-static void wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
+static void brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
 					  struct scb *scb,
 					  struct sk_buff *p, tx_status_t *txs,
 					  u32 frmtxstatus, u32 frmtxstatus2);
-static bool wlc_ampdu_cap(struct ampdu_info *ampdu);
-static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on);
+static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu);
+static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on);
 
-struct ampdu_info *wlc_ampdu_attach(struct brcms_c_info *wlc)
+struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 {
 	struct ampdu_info *ampdu;
 	int i;
 
 	ampdu = kzalloc(sizeof(struct ampdu_info), GFP_ATOMIC);
 	if (!ampdu) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_ampdu_attach: out of mem\n",
-			  wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d: brcms_c_ampdu_attach: out of mem"
+			  "\n", wlc->pub->unit);
 		return NULL;
 	}
 	ampdu->wlc = wlc;
@@ -174,18 +176,18 @@ struct ampdu_info *wlc_ampdu_attach(struct brcms_c_info *wlc)
 		ampdu->rr_retry_limit_tid[i] = ampdu->rr_retry_limit;
 	}
 
-	ampdu_update_max_txlen(ampdu, ampdu->dur);
+	brcms_c_scb_ampdu_update_max_txlen(ampdu, ampdu->dur);
 	ampdu->mfbr = false;
 	/* try to set ampdu to the default value */
-	wlc_ampdu_set(ampdu, wlc->pub->_ampdu);
+	brcms_c_ampdu_set(ampdu, wlc->pub->_ampdu);
 
 	ampdu->tx_max_funl = FFPLD_TX_MAX_UNFL;
-	wlc_ffpld_init(ampdu);
+	brcms_c_ffpld_init(ampdu);
 
 	return ampdu;
 }
 
-void wlc_ampdu_detach(struct ampdu_info *ampdu)
+void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 {
 	int i;
 
@@ -201,7 +203,8 @@ void wlc_ampdu_detach(struct ampdu_info *ampdu)
 	kfree(ampdu);
 }
 
-static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
+static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
+					    struct scb *scb)
 {
 	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	int i;
@@ -229,12 +232,12 @@ static void scb_ampdu_update_config(struct ampdu_info *ampdu, struct scb *scb)
 				 mcs2ampdu_table[FFPLD_MAX_MCS]);
 }
 
-static void scb_ampdu_update_config_all(struct ampdu_info *ampdu)
+static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu)
 {
-	scb_ampdu_update_config(ampdu, ampdu->wlc->pub->global_scb);
+	brcms_c_scb_ampdu_update_config(ampdu, ampdu->wlc->pub->global_scb);
 }
 
-static void wlc_ffpld_init(struct ampdu_info *ampdu)
+static void brcms_c_ffpld_init(struct ampdu_info *ampdu)
 {
 	int i, j;
 	wlc_fifo_info_t *fifo;
@@ -258,7 +261,7 @@ static void wlc_ffpld_init(struct ampdu_info *ampdu)
  * Return 1 if pre-loading not active, -1 if not an underflow event,
  * 0 if pre-loading module took care of the event.
  */
-static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
+static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 {
 	struct ampdu_info *ampdu = wlc->ampdu;
 	u32 phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
@@ -339,7 +342,7 @@ static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 			fifo->ampdu_pld_size = max_pld_size;
 
 		/* update scb release size */
-		scb_ampdu_update_config_all(ampdu);
+		brcms_c_scb_ampdu_update_config_all(ampdu);
 
 		/*
 		   compute a new dma xfer rate for max_mpdu @ max mcs.
@@ -366,17 +369,17 @@ static int wlc_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 				fifo->mcs2ampdu_table[FFPLD_MAX_MCS] -= 1;
 
 			/* recompute the table */
-			wlc_ffpld_calc_mcs2ampdu_table(ampdu, fid);
+			brcms_c_ffpld_calc_mcs2ampdu_table(ampdu, fid);
 
 			/* update scb release size */
-			scb_ampdu_update_config_all(ampdu);
+			brcms_c_scb_ampdu_update_config_all(ampdu);
 		}
 	}
 	fifo->accum_txfunfl = 0;
 	return 0;
 }
 
-static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
+static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 {
 	int i;
 	u32 phy_rate, dma_rate, tmp;
@@ -409,7 +412,7 @@ static void wlc_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 }
 
 static void
-wlc_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
+brcms_c_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
 	      uint prec)
 {
 	scb_ampdu_t *scb_ampdu;
@@ -421,13 +424,13 @@ wlc_ampdu_agg(struct ampdu_info *ampdu, struct scb *scb, struct sk_buff *p,
 	/* initialize initiator on first packet; sends addba req */
 	ini = SCB_AMPDU_INI(scb_ampdu, tid);
 	if (ini->magic != INI_MAGIC) {
-		ini = wlc_ampdu_init_tid_ini(ampdu, scb_ampdu, tid, false);
+		ini = brcms_c_ampdu_init_tid_ini(ampdu, scb_ampdu, tid, false);
 	}
 	return;
 }
 
 int
-wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
+brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 	      struct sk_buff **pdu, int prec)
 {
 	struct brcms_c_info *wlc;
@@ -480,7 +483,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 		return -EBUSY;
 	}
 
-	wlc_ampdu_agg(ampdu, scb, p, tid);
+	brcms_c_ampdu_agg(ampdu, scb, p, tid);
 
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	ampdu_len = 0;
@@ -808,7 +811,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 }
 
 void
-wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
+brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		     struct sk_buff *p, tx_status_t *txs)
 {
 	scb_ampdu_t *scb_ampdu;
@@ -841,7 +844,7 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	if (likely(scb)) {
 		scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 		ini = SCB_AMPDU_INI(scb_ampdu, p->priority);
-		wlc_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
+		brcms_c_ampdu_dotxstatus_complete(ampdu, scb, p, txs, s1, s2);
 	} else {
 		/* loop through all pkts and free */
 		u8 queue = txs->frameid & TXFID_QUEUE_MASK;
@@ -860,12 +863,13 @@ wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		}
 		brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 	}
-	wlc_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
+	brcms_c_ampdu_txflowcontrol(wlc, scb_ampdu, ini);
 }
 
 static void
-rate_status(struct brcms_c_info *wlc, struct ieee80211_tx_info *tx_info,
-	    tx_status_t *txs, u8 mcs)
+brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
+			  struct ieee80211_tx_info *tx_info,
+			  tx_status_t *txs, u8 mcs)
 {
 	struct ieee80211_tx_rate *txrate = tx_info->status.rates;
 	int i;
@@ -880,7 +884,7 @@ rate_status(struct brcms_c_info *wlc, struct ieee80211_tx_info *tx_info,
 #define SHORTNAME "AMPDU status"
 
 static void
-wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
+brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 			      struct sk_buff *p, tx_status_t *txs,
 			      u32 s1, u32 s2)
 {
@@ -954,9 +958,9 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 					  wlc->default_bss->chanspec));
 			} else {
 				if (supr_status != TX_STATUS_SUPR_FRAG)
-					wiphy_err(wiphy, "%s: wlc_ampdu_dotx"
-						  "status:supr_status 0x%x\n",
-						 __func__, supr_status);
+					wiphy_err(wiphy, "%s:"
+						  "supr_status 0x%x\n",
+						  __func__, supr_status);
 			}
 			/* no need to retry for badch; will fail again */
 			if (supr_status == TX_STATUS_SUPR_BADCH ||
@@ -968,14 +972,14 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				/* if there were underflows, but pre-loading is not active,
 				   notify rate adaptation.
 				 */
-				if (wlc_ffpld_check_txfunfl(wlc, prio2fifo[tid])
-				    > 0) {
+				if (brcms_c_ffpld_check_txfunfl(wlc,
+							prio2fifo[tid]) > 0) {
 					tx_error = true;
 				}
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
-			wiphy_err(wiphy, "wl%d: wlc_ampdu_dotxstatus: tx phy "
+			wiphy_err(wiphy, "wl%d: ampdu tx phy "
 				  "error (0x%x)\n", wlc->pub->unit,
 				  txs->phyerr);
 
@@ -1017,7 +1021,8 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 				/* ampdu_ack_len: number of acked aggregated frames */
 				/* ampdu_len: number of aggregated frames */
-				rate_status(wlc, tx_info, txs, mcs);
+				brcms_c_ampdu_rate_status(wlc, tx_info, txs,
+							  mcs);
 				tx_info->flags |= IEEE80211_TX_STAT_ACK;
 				tx_info->flags |= IEEE80211_TX_STAT_AMPDU;
 				tx_info->status.ampdu_ack_len =
@@ -1073,13 +1078,13 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	brcms_c_send_q(wlc);
 
 	/* update rate state */
-	antselid = wlc_antsel_antsel2id(wlc->asi, mimoantsel);
+	antselid = brcms_c_antsel_antsel2id(wlc->asi, mimoantsel);
 
 	brcms_c_txfifo_complete(wlc, queue, ampdu->txpkt_weight);
 }
 
 /* initialize the initiator code for tid */
-static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
+static scb_ampdu_tid_ini_t *brcms_c_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 						   scb_ampdu_t *scb_ampdu,
 						   u8 tid, bool override)
 {
@@ -1099,7 +1104,7 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 	return ini;
 }
 
-static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
+static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on)
 {
 	struct brcms_c_info *wlc = ampdu->wlc;
 
@@ -1111,7 +1116,7 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 				"nmode enabled\n", wlc->pub->unit);
 			return -ENOTSUPP;
 		}
-		if (!wlc_ampdu_cap(ampdu)) {
+		if (!brcms_c_ampdu_cap(ampdu)) {
 			wiphy_err(ampdu->wlc->wiphy, "wl%d: device not "
 				"ampdu capable\n", wlc->pub->unit);
 			return -ENOTSUPP;
@@ -1122,7 +1127,7 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 	return 0;
 }
 
-static bool wlc_ampdu_cap(struct ampdu_info *ampdu)
+static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu)
 {
 	if (WLC_PHY_11N_CAP(ampdu->wlc->band))
 		return true;
@@ -1130,7 +1135,7 @@ static bool wlc_ampdu_cap(struct ampdu_info *ampdu)
 		return false;
 }
 
-static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
+static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 {
 	u32 rate, mcs;
 
@@ -1151,7 +1156,7 @@ static void ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 	}
 }
 
-void wlc_ampdu_macaddr_upd(struct brcms_c_info *wlc)
+void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc)
 {
 	char template[T_RAM_ACCESS_SZ * 2];
 
@@ -1168,7 +1173,7 @@ bool brcms_c_aggregatable(struct brcms_c_info *wlc, u8 tid)
 	return wlc->ampdu->ini_enable[tid];
 }
 
-void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
+void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu)
 {
 	struct brcms_c_info *wlc = ampdu->wlc;
 
@@ -1217,7 +1222,7 @@ static void dma_cb_fn_ampdu(void *txi, void *arg_a)
  * When a remote party is no longer available for ampdu communication, any
  * pending tx ampdu packets in the driver have to be flushed.
  */
-void wlc_ampdu_flush(struct brcms_c_info *wlc,
+void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 		     struct ieee80211_sta *sta, u16 tid)
 {
 	struct brcms_c_txq_info *qi = wlc->pkt_queue;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.h b/drivers/staging/brcm80211/brcmsmac/ampdu.h
index 6f9aa9c..5fba4ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.h
@@ -17,13 +17,14 @@
 #ifndef _BRCM_AMPDU_H_
 #define _BRCM_AMPDU_H_
 
-extern struct ampdu_info *wlc_ampdu_attach(struct brcms_c_info *wlc);
-extern void wlc_ampdu_detach(struct ampdu_info *ampdu);
-extern int wlc_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
-			 struct sk_buff **aggp, int prec);
-extern void wlc_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
+extern struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc);
+extern void brcms_c_ampdu_detach(struct ampdu_info *ampdu);
+extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
+			     struct brcms_c_txq_info *qi,
+			     struct sk_buff **aggp, int prec);
+extern void brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 				 struct sk_buff *p, tx_status_t *txs);
-extern void wlc_ampdu_macaddr_upd(struct brcms_c_info *wlc);
-extern void wlc_ampdu_shm_upd(struct ampdu_info *ampdu);
+extern void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc);
+extern void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu);
 
 #endif				/* _BRCM_AMPDU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 7e12f60..2cfda7f 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -50,10 +50,11 @@
 #define ANT_SELCFG_DEF_2x4	0x02	/* default antenna configuration */
 
 /* static functions */
-static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel);
-static u8 wlc_antsel_id2antcfg(struct antsel_info *asi, u8 id);
-static u16 wlc_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg);
-static void wlc_antsel_init_cfg(struct antsel_info *asi,
+static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
+				 wlc_antselcfg_t *antsel);
+static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id);
+static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg);
+static void brcms_c_antsel_init_cfg(struct antsel_info *asi,
 				wlc_antselcfg_t *antsel,
 				bool auto_sel);
 
@@ -81,14 +82,14 @@ const u8 mimo_2x3_div_antselid_tbl[16] = {
 	0, 0, 0, 0, 0, 0, 0, 0	/* pat to antselid */
 };
 
-struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc)
+struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 {
 	struct antsel_info *asi;
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
 	if (!asi) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_antsel_attach: out of mem\n",
-			  wlc->pub->unit);
+		wiphy_err(wlc->wiphy, "wl%d: brcms_c_antsel_attach: out of "
+			  "mem\n", wlc->pub->unit);
 		return NULL;
 	}
 
@@ -117,7 +118,7 @@ struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc)
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
-				wiphy_err(wlc->wiphy, "wlc_antsel_attach: 2o3 "
+				wiphy_err(wlc->wiphy, "antsel_attach: 2o3 "
 					  "board cfg invalid\n");
 			}
 			break;
@@ -139,27 +140,27 @@ struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc)
 	brcms_b_antsel_type_set(wlc->hw, asi->antsel_type);
 
 	/* Init (auto/manual) antenna selection */
-	wlc_antsel_init_cfg(asi, &asi->antcfg_11n, true);
-	wlc_antsel_init_cfg(asi, &asi->antcfg_cur, true);
+	brcms_c_antsel_init_cfg(asi, &asi->antcfg_11n, true);
+	brcms_c_antsel_init_cfg(asi, &asi->antcfg_cur, true);
 
 	return asi;
 }
 
-void wlc_antsel_detach(struct antsel_info *asi)
+void brcms_c_antsel_detach(struct antsel_info *asi)
 {
 	kfree(asi);
 }
 
-void wlc_antsel_init(struct antsel_info *asi)
+void brcms_c_antsel_init(struct antsel_info *asi)
 {
 	if ((asi->antsel_type == ANTSEL_2x3) ||
 	    (asi->antsel_type == ANTSEL_2x4))
-		wlc_antsel_cfgupd(asi, &asi->antcfg_11n);
+		brcms_c_antsel_cfgupd(asi, &asi->antcfg_11n);
 }
 
 /* boardlevel antenna selection: init antenna selection structure */
 static void
-wlc_antsel_init_cfg(struct antsel_info *asi, wlc_antselcfg_t *antsel,
+brcms_c_antsel_init_cfg(struct antsel_info *asi, wlc_antselcfg_t *antsel,
 		    bool auto_sel)
 {
 	if (asi->antsel_type == ANTSEL_2x3) {
@@ -190,7 +191,7 @@ wlc_antsel_init_cfg(struct antsel_info *asi, wlc_antselcfg_t *antsel,
 }
 
 void
-wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef, bool sel,
+brcms_c_antsel_antcfg_get(struct antsel_info *asi, bool usedef, bool sel,
 		      u8 antselid, u8 fbantselid, u8 *antcfg,
 		      u8 *fbantcfg)
 {
@@ -210,8 +211,8 @@ wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef, bool sel,
 	} else {
 		ant = asi->antcfg_11n.ant_config[ANT_SELCFG_TX_UNICAST];
 		if ((ant & ANT_SELCFG_AUTO) == ANT_SELCFG_AUTO) {
-			*antcfg = wlc_antsel_id2antcfg(asi, antselid);
-			*fbantcfg = wlc_antsel_id2antcfg(asi, fbantselid);
+			*antcfg = brcms_c_antsel_id2antcfg(asi, antselid);
+			*fbantcfg = brcms_c_antsel_id2antcfg(asi, fbantselid);
 		} else {
 			*antcfg =
 			    asi->antcfg_11n.ant_config[ANT_SELCFG_TX_UNICAST];
@@ -222,7 +223,7 @@ wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef, bool sel,
 }
 
 /* boardlevel antenna selection: convert mimo_antsel (ucode interface) to id */
-u8 wlc_antsel_antsel2id(struct antsel_info *asi, u16 antsel)
+u8 brcms_c_antsel_antsel2id(struct antsel_info *asi, u16 antsel)
 {
 	u8 antselid = 0;
 
@@ -241,7 +242,7 @@ u8 wlc_antsel_antsel2id(struct antsel_info *asi, u16 antsel)
 }
 
 /* boardlevel antenna selection: convert id to ant_cfg */
-static u8 wlc_antsel_id2antcfg(struct antsel_info *asi, u8 id)
+static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id)
 {
 	u8 antcfg = ANT_SELCFG_DEF_2x2;
 
@@ -260,7 +261,7 @@ static u8 wlc_antsel_id2antcfg(struct antsel_info *asi, u8 id)
 }
 
 /* boardlevel antenna selection: convert ant_cfg to mimo_antsel (ucode interface) */
-static u16 wlc_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
+static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 {
 	u8 idx = WLC_ANTIDX_11N(WLC_ANTSEL_11N(ant_cfg));
 	u16 mimo_antsel = 0;
@@ -280,7 +281,8 @@ static u16 wlc_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 }
 
 /* boardlevel antenna selection: ucode interface control */
-static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
+static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
+				 wlc_antselcfg_t *antsel)
 {
 	struct brcms_c_info *wlc = asi->wlc;
 	u8 ant_cfg;
@@ -290,7 +292,7 @@ static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 	 *    (aka default TX)
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_TX_DEF];
-	mimo_antsel = wlc_antsel_antcfg2antsel(asi, ant_cfg);
+	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
 	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_TXDFLT, mimo_antsel);
 	/* Update driver stats for currently selected default tx/rx antenna config */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_TX_DEF] = ant_cfg;
@@ -299,7 +301,7 @@ static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 	 *    (aka default RX)
 	 */
 	ant_cfg = antsel->ant_config[ANT_SELCFG_RX_DEF];
-	mimo_antsel = wlc_antsel_antcfg2antsel(asi, ant_cfg);
+	mimo_antsel = brcms_c_antsel_antcfg2antsel(asi, ant_cfg);
 	brcms_c_write_shm(wlc, M_MIMO_ANTSEL_RXDFLT, mimo_antsel);
 	/* Update driver stats for currently selected default tx/rx antenna config */
 	asi->antcfg_cur.ant_config[ANT_SELCFG_RX_DEF] = ant_cfg;
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.h b/drivers/staging/brcm80211/brcmsmac/antsel.h
index a2c98e9..97ea388 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.h
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.h
@@ -17,13 +17,13 @@
 #ifndef _BRCM_ANTSEL_H_
 #define _BRCM_ANTSEL_H_
 
-extern struct antsel_info *wlc_antsel_attach(struct brcms_c_info *wlc);
-extern void wlc_antsel_detach(struct antsel_info *asi);
-extern void wlc_antsel_init(struct antsel_info *asi);
-extern void wlc_antsel_antcfg_get(struct antsel_info *asi, bool usedef,
+extern struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc);
+extern void brcms_c_antsel_detach(struct antsel_info *asi);
+extern void brcms_c_antsel_init(struct antsel_info *asi);
+extern void brcms_c_antsel_antcfg_get(struct antsel_info *asi, bool usedef,
 				  bool sel,
 				  u8 id, u8 fbid, u8 *antcfg,
 				  u8 *fbantcfg);
-extern u8 wlc_antsel_antsel2id(struct antsel_info *asi, u16 antsel);
+extern u8 brcms_c_antsel_antsel2id(struct antsel_info *asi, u16 antsel);
 
 #endif /* _BRCM_ANTSEL_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 6101575..6b28a35 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -25,10 +25,10 @@
 #include "stf.h"
 #include "channel.h"
 
-#define	VALID_CHANNEL20_DB(wlc, val) wlc_valid_channel20_db((wlc)->cmi, val)
+#define	VALID_CHANNEL20_DB(wlc, val) brcms_c_valid_channel20_db((wlc)->cmi, val)
 #define	VALID_CHANNEL20_IN_BAND(wlc, bandunit, val) \
-	wlc_valid_channel20_in_band((wlc)->cmi, bandunit, val)
-#define	VALID_CHANNEL20(wlc, val) wlc_valid_channel20((wlc)->cmi, val)
+	brcms_c_valid_channel20_in_band((wlc)->cmi, bandunit, val)
+#define	VALID_CHANNEL20(wlc, val) brcms_c_valid_channel20((wlc)->cmi, val)
 
 typedef struct wlc_cm_band {
 	u8 locale_flags;	/* locale_info_t flags */
@@ -52,50 +52,47 @@ struct wlc_cm_info {
 	chanvec_t quiet_channels;	/* channels on which we cannot transmit */
 };
 
-static int wlc_channels_init(wlc_cm_info_t *wlc_cm,
+static int brcms_c_channels_init(wlc_cm_info_t *wlc_cm,
 			     const country_info_t *country);
-static void wlc_set_country_common(wlc_cm_info_t *wlc_cm,
+static void brcms_c_set_country_common(wlc_cm_info_t *wlc_cm,
 				   const char *country_abbrev,
 				   const char *ccode, uint regrev,
 				   const country_info_t *country);
-static int wlc_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode);
-static int wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
+static int brcms_c_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode);
+static int brcms_c_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 				   const char *country_abbrev,
 				   const char *ccode, int regrev);
-static int wlc_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
-				     char *mapped_ccode, uint *mapped_regrev);
-static const country_info_t *wlc_country_lookup_direct(const char *ccode,
+static int brcms_c_country_aggregate_map(wlc_cm_info_t *wlc_cm,
+				const char *ccode,
+				char *mapped_ccode, uint *mapped_regrev);
+static const country_info_t *brcms_c_country_lookup_direct(const char *ccode,
 						       uint regrev);
-static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
+static const country_info_t *brcms_c_countrycode_map(wlc_cm_info_t *wlc_cm,
 						 const char *ccode,
 						 char *mapped_ccode,
 						 uint *mapped_regrev);
-static void wlc_channels_commit(wlc_cm_info_t *wlc_cm);
-static void wlc_quiet_channels_reset(wlc_cm_info_t *wlc_cm);
-static bool wlc_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
-static bool wlc_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val);
-static bool wlc_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit,
-					uint val);
-static bool wlc_valid_channel20(wlc_cm_info_t *wlc_cm, uint val);
-static const country_info_t *wlc_country_lookup(struct brcms_c_info *wlc,
+static void brcms_c_channels_commit(wlc_cm_info_t *wlc_cm);
+static void brcms_c_quiet_channels_reset(wlc_cm_info_t *wlc_cm);
+static bool brcms_c_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
+static bool brcms_c_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val);
+static bool brcms_c_valid_channel20_in_band(wlc_cm_info_t *wlc_cm,
+					    uint bandunit, uint val);
+static bool brcms_c_valid_channel20(wlc_cm_info_t *wlc_cm, uint val);
+static const country_info_t *brcms_c_country_lookup(struct brcms_c_info *wlc,
 						const char *ccode);
-static void wlc_locale_get_channels(const locale_info_t *locale,
+static void brcms_c_locale_get_channels(const locale_info_t *locale,
 				    chanvec_t *valid_channels);
-static const locale_info_t *wlc_get_locale_2g(u8 locale_idx);
-static const locale_info_t *wlc_get_locale_5g(u8 locale_idx);
-static bool wlc_japan(struct brcms_c_info *wlc);
-static bool wlc_japan_ccode(const char *ccode);
-static void wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *
-								 wlc_cm,
-								 struct
-								 txpwr_limits
-								 *txpwr,
-								 u8
-								 local_constraint_qdbm);
-static void wlc_locale_add_channels(chanvec_t *target,
+static const locale_info_t *brcms_c_get_locale_2g(u8 locale_idx);
+static const locale_info_t *brcms_c_get_locale_5g(u8 locale_idx);
+static bool brcms_c_japan(struct brcms_c_info *wlc);
+static bool brcms_c_japan_ccode(const char *ccode);
+static void brcms_c_channel_min_txpower_limits_with_local_constraint(
+	wlc_cm_info_t *wlc_cm, struct txpwr_limits *txpwr,
+	u8 local_constraint_qdbm);
+static void brcms_c_locale_add_channels(chanvec_t *target,
 				    const chanvec_t *channels);
-static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx);
-static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx);
+static const locale_mimo_info_t *brcms_c_get_mimo_2g(u8 locale_idx);
+static const locale_mimo_info_t *brcms_c_get_mimo_5g(u8 locale_idx);
 
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #ifdef QDB
@@ -383,7 +380,7 @@ static const chanvec_t *g_table_locale_base[] = {
 	&locale_5g_HIGH4
 };
 
-static void wlc_locale_add_channels(chanvec_t *target,
+static void brcms_c_locale_add_channels(chanvec_t *target,
 				    const chanvec_t *channels)
 {
 	u8 i;
@@ -392,7 +389,7 @@ static void wlc_locale_add_channels(chanvec_t *target,
 	}
 }
 
-static void wlc_locale_get_channels(const locale_info_t *locale,
+static void brcms_c_locale_get_channels(const locale_info_t *locale,
 				    chanvec_t *channels)
 {
 	u8 i;
@@ -401,7 +398,7 @@ static void wlc_locale_get_channels(const locale_info_t *locale,
 
 	for (i = 0; i < ARRAY_SIZE(g_table_locale_base); i++) {
 		if (locale->valid_channels & (1 << i)) {
-			wlc_locale_add_channels(channels,
+			brcms_c_locale_add_channels(channels,
 						g_table_locale_base[i]);
 		}
 	}
@@ -579,7 +576,7 @@ struct chan20_info chan20_info[] = {
 };
 #endif				/* SUPPORT_40MHZ */
 
-static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
+static const locale_info_t *brcms_c_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
 		return NULL; /* error condition */
@@ -587,7 +584,7 @@ static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 	return g_locale_2g_table[locale_idx];
 }
 
-static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
+static const locale_info_t *brcms_c_get_locale_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
 		return NULL; /* error condition */
@@ -595,7 +592,7 @@ static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 	return g_locale_5g_table[locale_idx];
 }
 
-static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
+static const locale_mimo_info_t *brcms_c_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
 		return NULL;
@@ -603,7 +600,7 @@ static const locale_mimo_info_t *wlc_get_mimo_2g(u8 locale_idx)
 	return g_mimo_2g_table[locale_idx];
 }
 
-static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
+static const locale_mimo_info_t *brcms_c_get_mimo_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
 		return NULL;
@@ -611,7 +608,7 @@ static const locale_mimo_info_t *wlc_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc)
+wlc_cm_info_t *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
 	wlc_cm_info_t *wlc_cm;
 	char country_abbrev[WLC_CNTRY_BUF_SZ];
@@ -640,7 +637,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc)
 	/* internal country information which must match regulatory constraints in firmware */
 	memset(country_abbrev, 0, WLC_CNTRY_BUF_SZ);
 	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
-	country = wlc_country_lookup(wlc, country_abbrev);
+	country = brcms_c_country_lookup(wlc, country_abbrev);
 
 	/* save default country for exiting 11d regulatory mode */
 	strncpy(wlc->country_default, country_abbrev, WLC_CNTRY_BUF_SZ - 1);
@@ -648,17 +645,17 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc)
 	/* initialize autocountry_default to driver default */
 	strncpy(wlc->autocountry_default, "X2", WLC_CNTRY_BUF_SZ - 1);
 
-	wlc_set_countrycode(wlc_cm, country_abbrev);
+	brcms_c_set_countrycode(wlc_cm, country_abbrev);
 
 	return wlc_cm;
 }
 
-void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm)
+void brcms_c_channel_mgr_detach(wlc_cm_info_t *wlc_cm)
 {
 	kfree(wlc_cm);
 }
 
-u8 wlc_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
+u8 brcms_c_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
 {
 	return wlc_cm->bandstate[bandunit].locale_flags;
 }
@@ -666,15 +663,15 @@ u8 wlc_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
 /* set the driver's current country and regulatory information using a country code
  * as the source. Lookup built in country information found with the country code.
  */
-static int wlc_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode)
+static int brcms_c_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode)
 {
 	char country_abbrev[WLC_CNTRY_BUF_SZ];
 	strncpy(country_abbrev, ccode, WLC_CNTRY_BUF_SZ);
-	return wlc_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
+	return brcms_c_set_countrycode_rev(wlc_cm, country_abbrev, ccode, -1);
 }
 
 static int
-wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
+brcms_c_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 			const char *country_abbrev,
 			const char *ccode, int regrev)
 {
@@ -688,11 +685,11 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 	if (regrev == -1) {
 		/* map the country code to a built-in country code, regrev, and country_info */
 		country =
-		    wlc_countrycode_map(wlc_cm, ccode, mapped_ccode,
+		    brcms_c_countrycode_map(wlc_cm, ccode, mapped_ccode,
 					&mapped_regrev);
 	} else {
 		/* find the matching built-in country definition */
-		country = wlc_country_lookup_direct(ccode, regrev);
+		country = brcms_c_country_lookup_direct(ccode, regrev);
 		strncpy(mapped_ccode, ccode, WLC_CNTRY_BUF_SZ);
 		mapped_regrev = regrev;
 	}
@@ -701,7 +698,7 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 		return -EINVAL;
 
 	/* set the driver state for the country */
-	wlc_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
+	brcms_c_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
 			       mapped_regrev, country);
 
 	return 0;
@@ -711,7 +708,7 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
  * as the source. Look up built in country information found with the country code.
  */
 static void
-wlc_set_country_common(wlc_cm_info_t *wlc_cm,
+brcms_c_set_country_common(wlc_cm_info_t *wlc_cm,
 		       const char *country_abbrev,
 		       const char *ccode, uint regrev,
 		       const country_info_t *country)
@@ -733,7 +730,7 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 	wlc_cm->regrev = regrev;
 
 	/* disable/restore nmode based on country regulations */
-	li_mimo = wlc_get_mimo_2g(country->locale_mimo_2G);
+	li_mimo = brcms_c_get_mimo_2g(country->locale_mimo_2G);
 	if (li_mimo && (li_mimo->flags & WLC_NO_MIMO)) {
 		brcms_c_set_nmode(wlc, OFF);
 		wlc->stf->no_cddstbc = true;
@@ -743,17 +740,17 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 			brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
 	}
 
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 	/* set or restore gmode as required by regulatory */
-	locale = wlc_get_locale_2g(country->locale_2G);
+	locale = brcms_c_get_locale_2g(country->locale_2G);
 	if (locale && (locale->flags & WLC_NO_OFDM)) {
 		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
 	} else {
 		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
 	}
 
-	wlc_channels_init(wlc_cm, country);
+	brcms_c_channels_init(wlc_cm, country);
 
 	return;
 }
@@ -761,7 +758,7 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 /* Lookup a country info structure from a null terminated country code
  * The lookup is case sensitive.
  */
-static const country_info_t *wlc_country_lookup(struct brcms_c_info *wlc,
+static const country_info_t *brcms_c_country_lookup(struct brcms_c_info *wlc,
 					 const char *ccode)
 {
 	const country_info_t *country;
@@ -769,13 +766,13 @@ static const country_info_t *wlc_country_lookup(struct brcms_c_info *wlc,
 	uint mapped_regrev;
 
 	/* map the country code to a built-in country code, regrev, and country_info struct */
-	country =
-	    wlc_countrycode_map(wlc->cmi, ccode, mapped_ccode, &mapped_regrev);
+	country = brcms_c_countrycode_map(wlc->cmi, ccode, mapped_ccode,
+					  &mapped_regrev);
 
 	return country;
 }
 
-static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
+static const country_info_t *brcms_c_countrycode_map(wlc_cm_info_t *wlc_cm,
 						 const char *ccode,
 						 char *mapped_ccode,
 						 uint *mapped_regrev)
@@ -807,25 +804,25 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 		wiphy_err(wlc->wiphy, "srom_code == ccode %s\n", __func__);
 	} else {
 		mapped =
-		    wlc_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
+		    brcms_c_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
 					      mapped_regrev);
 	}
 
 	/* find the matching built-in country definition */
-	country = wlc_country_lookup_direct(mapped_ccode, *mapped_regrev);
+	country = brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
 
 	/* if there is not an exact rev match, default to rev zero */
 	if (country == NULL && *mapped_regrev != 0) {
 		*mapped_regrev = 0;
 		country =
-		    wlc_country_lookup_direct(mapped_ccode, *mapped_regrev);
+		    brcms_c_country_lookup_direct(mapped_ccode, *mapped_regrev);
 	}
 
 	return country;
 }
 
 static int
-wlc_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
+brcms_c_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
 			  char *mapped_ccode, uint *mapped_regrev)
 {
 	return false;
@@ -834,7 +831,7 @@ wlc_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
 /* Lookup a country info structure from a null terminated country
  * abbreviation and regrev directly with no translation.
  */
-static const country_info_t *wlc_country_lookup_direct(const char *ccode,
+static const country_info_t *brcms_c_country_lookup_direct(const char *ccode,
 						       uint regrev)
 {
 	uint size, i;
@@ -857,7 +854,7 @@ static const country_info_t *wlc_country_lookup_direct(const char *ccode,
 }
 
 static int
-wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
+brcms_c_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
@@ -871,12 +868,12 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 	     i++, band = wlc->bandstate[OTHERBANDUNIT(wlc)]) {
 
 		li = BAND_5G(band->bandtype) ?
-		    wlc_get_locale_5g(country->locale_5G) :
-		    wlc_get_locale_2g(country->locale_2G);
+		    brcms_c_get_locale_5g(country->locale_5G) :
+		    brcms_c_get_locale_2g(country->locale_2G);
 		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
 		li_mimo = BAND_5G(band->bandtype) ?
-		    wlc_get_mimo_5g(country->locale_mimo_5G) :
-		    wlc_get_mimo_2g(country->locale_mimo_2G);
+		    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
+		    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
 		/* merge the mimo non-mimo locale flags */
 		wlc_cm->bandstate[band->bandunit].locale_flags |=
@@ -892,7 +889,7 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 		 */
 		wlc_phy_chanspec_band_validch(band->pi, band->bandtype,
 					      &sup_chan);
-		wlc_locale_get_channels(li,
+		brcms_c_locale_get_channels(li,
 					&wlc_cm->bandstate[band->bandunit].
 					valid_channels);
 		for (j = 0; j < sizeof(chanvec_t); j++)
@@ -900,8 +897,8 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 			    vec[j] &= sup_chan.vec[j];
 	}
 
-	wlc_quiet_channels_reset(wlc_cm);
-	wlc_channels_commit(wlc_cm);
+	brcms_c_quiet_channels_reset(wlc_cm);
+	brcms_c_channels_commit(wlc_cm);
 
 	return 0;
 }
@@ -909,7 +906,7 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 /* Update the radio state (enable/disable) and tx power targets
  * based on a new set of channel/regulatory information
  */
-static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
+static void brcms_c_channels_commit(wlc_cm_info_t *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint chan;
@@ -944,13 +941,13 @@ static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 	 */
 	if (NBANDS(wlc) > 1 || BAND_2G(wlc->band->bandtype)) {
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
-						     wlc_japan(wlc) ? true :
+						     brcms_c_japan(wlc) ? true :
 						     false);
 	}
 
 	if (wlc->pub->up && chan != INVCHANNEL) {
-		wlc_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
-		wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm,
+		brcms_c_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
+		brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm,
 								     &txpwr,
 								     WLC_TXPWR_MAX);
 		wlc_phy_txpower_limit_set(wlc->band->pi, &txpwr, wlc->chanspec);
@@ -958,7 +955,7 @@ static void wlc_channels_commit(wlc_cm_info_t *wlc_cm)
 }
 
 /* reset the quiet channels vector to the union of the restricted and radar channel sets */
-static void wlc_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
+static void brcms_c_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
@@ -979,7 +976,7 @@ static void wlc_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
 	}
 }
 
-static bool wlc_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
+static bool brcms_c_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
 {
 	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
 		(isset
@@ -996,7 +993,7 @@ static bool wlc_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
 /* Is the channel valid for the current locale? (but don't consider channels not
  *   available due to bandlocking)
  */
-static bool wlc_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
+static bool brcms_c_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
@@ -1007,14 +1004,14 @@ static bool wlc_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
 
 /* Is the channel valid for the current locale and specified band? */
 static bool
-wlc_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit, uint val)
+brcms_c_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit, uint val)
 {
 	return ((val < MAXCHANNEL)
 		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
 }
 
 /* Is the channel valid for the current locale and current band? */
-static bool wlc_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
+static bool brcms_c_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
@@ -1024,7 +1021,7 @@ static bool wlc_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
 }
 
 static void
-wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *wlc_cm,
+brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *wlc_cm,
 						     struct txpwr_limits *txpwr,
 						     u8
 						     local_constraint_qdbm)
@@ -1111,19 +1108,19 @@ wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *wlc_cm,
 }
 
 void
-wlc_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
+brcms_c_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	struct txpwr_limits txpwr;
 
-	wlc_channel_reg_limits(wlc_cm, chanspec, &txpwr);
+	brcms_c_channel_reg_limits(wlc_cm, chanspec, &txpwr);
 
-	wlc_channel_min_txpower_limits_with_local_constraint(wlc_cm, &txpwr,
+	brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm, &txpwr,
 							     local_constraint_qdbm);
 
 	brcms_b_set_chanspec(wlc->hw, chanspec,
-			      (wlc_quiet_chanspec(wlc_cm, chanspec) != 0),
+			      (brcms_c_quiet_chanspec(wlc_cm, chanspec) != 0),
 			      &txpwr);
 }
 
@@ -1245,7 +1242,7 @@ static void wlc_phy_txpower_limits_dump(txpwr_limits_t *txpwr)
 #endif				/* POWER_DBG */
 
 void
-wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
+brcms_c_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 		       txpwr_limits_t *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1265,8 +1262,8 @@ wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 
 	memset(txpwr, 0, sizeof(txpwr_limits_t));
 
-	if (!wlc_valid_chanspec_db(wlc_cm, chanspec)) {
-		country = wlc_country_lookup(wlc, wlc->autocountry_default);
+	if (!brcms_c_valid_chanspec_db(wlc_cm, chanspec)) {
+		country = brcms_c_country_lookup(wlc, wlc->autocountry_default);
 		if (country == NULL)
 			return;
 	} else {
@@ -1276,12 +1273,12 @@ wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 	chan = CHSPEC_CHANNEL(chanspec);
 	band = wlc->bandstate[CHSPEC_WLCBANDUNIT(chanspec)];
 	li = BAND_5G(band->bandtype) ?
-	    wlc_get_locale_5g(country->locale_5G) :
-	    wlc_get_locale_2g(country->locale_2G);
+	    brcms_c_get_locale_5g(country->locale_5G) :
+	    brcms_c_get_locale_2g(country->locale_2G);
 
 	li_mimo = BAND_5G(band->bandtype) ?
-	    wlc_get_mimo_5g(country->locale_mimo_5G) :
-	    wlc_get_mimo_2g(country->locale_mimo_2G);
+	    brcms_c_get_mimo_5g(country->locale_mimo_5G) :
+	    brcms_c_get_mimo_2g(country->locale_mimo_2G);
 
 	if (li->flags & WLC_EIRP) {
 		delta = band->antgain;
@@ -1458,13 +1455,13 @@ wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 }
 
 /* Returns true if currently set country is Japan or variant */
-static bool wlc_japan(struct brcms_c_info *wlc)
+static bool brcms_c_japan(struct brcms_c_info *wlc)
 {
-	return wlc_japan_ccode(wlc->cmi->country_abbrev);
+	return brcms_c_japan_ccode(wlc->cmi->country_abbrev);
 }
 
 /* JP, J1 - J10 are Japan ccodes */
-static bool wlc_japan_ccode(const char *ccode)
+static bool brcms_c_japan_ccode(const char *ccode)
 {
 	return (ccode[0] == 'J' &&
 		(ccode[1] == 'P' || (ccode[1] >= '1' && ccode[1] <= '9')));
@@ -1475,7 +1472,8 @@ static bool wlc_japan_ccode(const char *ccode)
  * are valid 20MZH channels in this locale and they are also a legal HT combination
  */
 static bool
-wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
+brcms_c_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec,
+			   bool dualband)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	u8 channel = CHSPEC_CHANNEL(chspec);
@@ -1536,7 +1534,7 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 	return false;
 }
 
-bool wlc_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
+bool brcms_c_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
 {
-	return wlc_valid_chanspec_ext(wlc_cm, chspec, true);
+	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index 5ab1032..6fe8050 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -103,18 +103,18 @@ struct country_info {
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
 
-extern wlc_cm_info_t *wlc_channel_mgr_attach(struct brcms_c_info *wlc);
-extern void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm);
+extern wlc_cm_info_t *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc);
+extern void brcms_c_channel_mgr_detach(wlc_cm_info_t *wlc_cm);
 
-extern u8 wlc_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm,
+extern u8 brcms_c_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm,
 					   uint bandunit);
 
-extern bool wlc_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
+extern bool brcms_c_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
 
-extern void wlc_channel_reg_limits(wlc_cm_info_t *wlc_cm,
+extern void brcms_c_channel_reg_limits(wlc_cm_info_t *wlc_cm,
 				   chanspec_t chanspec,
 				   struct txpwr_limits *txpwr);
-extern void wlc_channel_set_chanspec(wlc_cm_info_t *wlc_cm,
+extern void brcms_c_channel_set_chanspec(wlc_cm_info_t *wlc_cm,
 				     chanspec_t chanspec,
 				     u8 local_constraint_qdbm);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 8001bee..0dd01d0 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -651,7 +651,7 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 
 	case IEEE80211_AMPDU_TX_STOP:
 		LOCK(wl);
-		wlc_ampdu_flush(wl->wlc, sta, tid);
+		brcms_c_ampdu_flush(wl->wlc, sta, tid);
 		UNLOCK(wl);
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index a8f36f2..1df1178 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -526,7 +526,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	wlc_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
 
 	/* Update some shared memory locations related to max AMPDU size allowed to received */
-	wlc_ampdu_shm_upd(wlc->ampdu);
+	brcms_c_ampdu_shm_upd(wlc->ampdu);
 
 	/* band-specific inits */
 	wlc_bsinit(wlc);
@@ -652,7 +652,7 @@ int brcms_c_set_mac(struct brcms_c_bsscfg *cfg)
 		brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
 	}
 
-	wlc_ampdu_macaddr_upd(wlc);
+	brcms_c_ampdu_macaddr_upd(wlc);
 
 	return err;
 }
@@ -760,14 +760,14 @@ static void wlc_set_phy_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	/* Set the chanspec and power limits for this locale after computing
 	 * any 11h local tx power constraints.
 	 */
-	wlc_channel_set_chanspec(wlc->cmi, chanspec,
+	brcms_c_channel_set_chanspec(wlc->cmi, chanspec,
 				 wlc_local_constraint_qdbm(wlc));
 
 	if (wlc->stf->ss_algosel_auto)
-		wlc_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
+		brcms_c_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
 					    chanspec);
 
-	wlc_stf_ss_update(wlc, wlc->band);
+	brcms_c_stf_ss_update(wlc, wlc->band);
 
 }
 
@@ -777,7 +777,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	bool switchband = false;
 	chanspec_t old_chanspec = wlc->chanspec;
 
-	if (!wlc_valid_chanspec_db(wlc->cmi, chanspec)) {
+	if (!brcms_c_valid_chanspec_db(wlc->cmi, chanspec)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Bad channel %d\n",
 			  wlc->pub->unit, __func__, CHSPEC_CHANNEL(chanspec));
 		return;
@@ -812,12 +812,12 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 
 	/* init antenna selection */
 	if (CHSPEC_WLC_BW(old_chanspec) != CHSPEC_WLC_BW(chanspec)) {
-		wlc_antsel_init(wlc->asi);
+		brcms_c_antsel_init(wlc->asi);
 
 		/* Fix the hardware rateset based on bw.
 		 * Mainly add MCS32 for 40Mhz, remove MCS 32 for 20Mhz
 		 */
-		wlc_rateset_bw_mcs_filter(&wlc->band->hw_rateset,
+		brcms_c_rateset_bw_mcs_filter(&wlc->band->hw_rateset,
 					  wlc->band->
 					  mimo_cap_40 ? CHSPEC_WLC_BW(chanspec)
 					  : 0);
@@ -865,7 +865,7 @@ void brcms_c_beacon_phytxctl_txant_upd(struct brcms_c_info *wlc,
 
 	/* for non-siso rates or default setting, use the available chains */
 	if (WLC_PHY_11N_CAP(wlc->band)) {
-		phytxant = wlc_stf_phytxchain_sel(wlc, bcn_rspec);
+		phytxant = brcms_c_stf_phytxchain_sel(wlc, bcn_rspec);
 	}
 
 	phyctl = brcms_c_read_shm(wlc, M_BCN_PCTLWD);
@@ -1014,12 +1014,12 @@ static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec)
 		brcms_default_rateset(wlc, &default_rateset);
 
 		/* fill in hw_rate */
-		wlc_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
+		brcms_c_rateset_filter(&default_rateset, &wlc->band->hw_rateset,
 				   false, WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 
 		/* init basic rate lookup */
-		wlc_rate_lookup_init(wlc, &default_rateset);
+		brcms_c_rate_lookup_init(wlc, &default_rateset);
 	}
 
 	/* sync up phy/radio chanspec */
@@ -1039,7 +1039,7 @@ static void WLBANDINITFN(wlc_bsinit) (struct brcms_c_info *wlc)
 	wlc_ucode_mac_upd(wlc);
 
 	/* init antenna selection */
-	wlc_antsel_init(wlc->asi);
+	brcms_c_antsel_init(wlc->asi);
 
 }
 
@@ -1317,23 +1317,23 @@ static uint wlc_attach_module(struct brcms_c_info *wlc)
 	uint unit;
 	unit = wlc->pub->unit;
 
-	wlc->asi = wlc_antsel_attach(wlc);
+	wlc->asi = brcms_c_antsel_attach(wlc);
 	if (wlc->asi == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_antsel_attach "
+		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: antsel_attach "
 			  "failed\n", unit);
 		err = 44;
 		goto fail;
 	}
 
-	wlc->ampdu = wlc_ampdu_attach(wlc);
+	wlc->ampdu = brcms_c_ampdu_attach(wlc);
 	if (wlc->ampdu == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_ampdu_attach "
+		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: brcms_c_ampdu_attach "
 			  "failed\n", unit);
 		err = 50;
 		goto fail;
 	}
 
-	if ((wlc_stf_attach(wlc) != 0)) {
+	if ((brcms_c_stf_attach(wlc) != 0)) {
 		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_stf_attach "
 			  "failed\n", unit);
 		err = 68;
@@ -1364,7 +1364,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	uint n_disabled;
 
 	/* allocate struct brcms_c_info state and its substructures */
-	wlc = (struct brcms_c_info *) wlc_attach_malloc(unit, &err, device);
+	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
 	if (wlc == NULL)
 		goto fail;
 	wlc->wiphy = wl->wiphy;
@@ -1419,7 +1419,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->tx_duty_cycle_cck =
 	    (u16) getintvar(pub->vars, "tx_duty_cycle_cck");
 
-	wlc_stf_phy_chain_calc(wlc);
+	brcms_c_stf_phy_chain_calc(wlc);
 
 	/* txchain 1: txant 0, txchain 2: txant 1 */
 	if (WLCISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
@@ -1482,14 +1482,14 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		brcms_default_rateset(wlc, &wlc->band->defrateset);
 
 		/* fill in hw_rateset (used early by WLC_SET_RATESET) */
-		wlc_rateset_filter(&wlc->band->defrateset,
+		brcms_c_rateset_filter(&wlc->band->defrateset,
 				   &wlc->band->hw_rateset, false,
 				   WLC_RATES_CCK_OFDM, WLC_RATE_MASK,
 				   (bool) N_ENAB(wlc->pub));
 	}
 
 	/* update antenna config due to wlc->stf->txant/txchain/ant_rx_ovr change */
-	wlc_stf_phy_txant_upd(wlc);
+	brcms_c_stf_phy_txant_upd(wlc);
 
 	/* attach each modules */
 	err = wlc_attach_module(wlc);
@@ -1504,9 +1504,9 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	}
 
 	/* depend on rateset, gmode */
-	wlc->cmi = wlc_channel_mgr_attach(wlc);
+	wlc->cmi = brcms_c_channel_mgr_attach(wlc);
 	if (!wlc->cmi) {
-		wiphy_err(wl->wiphy, "wl%d: %s: wlc_channel_mgr_attach failed"
+		wiphy_err(wl->wiphy, "wl%d: %s: channel_mgr_attach failed"
 			  "\n", unit, __func__);
 		err = 33;
 		goto fail;
@@ -1573,7 +1573,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		wlc->ht_cap.cap_info &= ~IEEE80211_HT_CAP_TX_STBC;
 	}
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_RX)
-		wlc_stf_stbc_rx_set(wlc, HT_CAP_RX_STBC_NO);
+		brcms_c_stf_stbc_rx_set(wlc, HT_CAP_RX_STBC_NO);
 
 	/* apply the GF override from nvram conf */
 	if (n_disabled & WLFEATURE_DISABLE_11N_GF)
@@ -1696,16 +1696,16 @@ static void wlc_timers_deinit(struct brcms_c_info *wlc)
 static void wlc_detach_module(struct brcms_c_info *wlc)
 {
 	if (wlc->asi) {
-		wlc_antsel_detach(wlc->asi);
+		brcms_c_antsel_detach(wlc->asi);
 		wlc->asi = NULL;
 	}
 
 	if (wlc->ampdu) {
-		wlc_ampdu_detach(wlc->ampdu);
+		brcms_c_ampdu_detach(wlc->ampdu);
 		wlc->ampdu = NULL;
 	}
 
-	wlc_stf_detach(wlc);
+	brcms_c_stf_detach(wlc);
 }
 
 /*
@@ -1733,7 +1733,7 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 	if (!wlc_radio_monitor_stop(wlc))
 		callbacks++;
 
-	wlc_channel_mgr_detach(wlc->cmi);
+	brcms_c_channel_mgr_detach(wlc->cmi);
 
 	wlc_timers_deinit(wlc);
 
@@ -1743,7 +1743,7 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 	while (wlc->tx_queues != NULL)
 		wlc_txq_free(wlc, wlc->tx_queues);
 
-	wlc_detach_mfree(wlc);
+	brcms_c_detach_mfree(wlc);
 	return callbacks;
 }
 
@@ -2006,7 +2006,7 @@ static void wlc_watchdog(void *arg)
 	    ((wlc->pub->now - wlc->tempsense_lasttime) >=
 	     WLC_TEMPSENSE_PERIOD)) {
 		wlc->tempsense_lasttime = wlc->pub->now;
-		wlc_tempsense_upd(wlc);
+		brcms_c_tempsense_upd(wlc);
 	}
 }
 
@@ -2112,7 +2112,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	wlc->WDarmed = true;
 
 	/* ensure antenna config is up to date */
-	wlc_stf_phy_txant_upd(wlc);
+	brcms_c_stf_phy_txant_upd(wlc);
 	/* ensure LDPC config is in sync */
 	wlc_ht_update_ldpc(wlc, wlc->stf->ldpc);
 
@@ -2247,7 +2247,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 		return -EINVAL;
 
 	/* Legacy or bust when no OFDM is supported by regulatory */
-	if ((wlc_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
+	if ((brcms_c_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
 	     WLC_NO_OFDM) && (gmode != GMODE_LEGACY_B))
 		return -EINVAL;
 
@@ -2264,13 +2264,14 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	switch (gmode) {
 	case GMODE_LEGACY_B:
 		shortslot = WLC_SHORTSLOT_OFF;
-		wlc_rateset_copy(&gphy_legacy_rates, &rs);
+		brcms_c_rateset_copy(&gphy_legacy_rates, &rs);
 
 		break;
 
 	case GMODE_LRS:
 		if (AP_ENAB(wlc->pub))
-			wlc_rateset_copy(&cck_rates, &wlc->sup_rates_override);
+			brcms_c_rateset_copy(&cck_rates,
+					     &wlc->sup_rates_override);
 		break;
 
 	case GMODE_AUTO:
@@ -2285,7 +2286,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	case GMODE_PERFORMANCE:
 		if (AP_ENAB(wlc->pub))	/* Put all rates into the Supported Rates element */
-			wlc_rateset_copy(&cck_ofdm_rates,
+			brcms_c_rateset_copy(&cck_ofdm_rates,
 					 &wlc->sup_rates_override);
 
 		shortslot = WLC_SHORTSLOT_ON;
@@ -2344,7 +2345,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 
 	/* Use the default 11g rateset */
 	if (!rs.count)
-		wlc_rateset_copy(&cck_ofdm_rates, &rs);
+		brcms_c_rateset_copy(&cck_ofdm_rates, &rs);
 
 	if (ofdm_basic) {
 		for (i = 0; i < rs.count; i++) {
@@ -2401,7 +2402,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 		wlc->pub->_n_enab = OFF;
 		wlc->default_bss->flags &= ~WLC_BSS_HT;
 		/* delete the mcs rates from the default and hw ratesets */
-		wlc_rateset_mcs_clear(&wlc->default_bss->rateset);
+		brcms_c_rateset_mcs_clear(&wlc->default_bss->rateset);
 		for (i = 0; i < NBANDS(wlc); i++) {
 			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
 			       MCSSET_LEN);
@@ -2429,7 +2430,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 			wlc->pub->_n_enab = SUPPORT_11N;
 		wlc->default_bss->flags |= WLC_BSS_HT;
 		/* add the mcs rates to the default and hw ratesets */
-		wlc_rateset_mcs_build(&wlc->default_bss->rateset,
+		brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
 				      wlc->stf->txstreams);
 		for (i = 0; i < NBANDS(wlc); i++)
 			memcpy(wlc->bandstate[i]->hw_rateset.mcs,
@@ -2457,7 +2458,7 @@ static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
 	memcpy(&new, &rs, sizeof(wlc_rateset_t));
-	if (wlc_rate_hwrs_filter_sort_validate
+	if (brcms_c_rate_hwrs_filter_sort_validate
 	    (&new, &wlc->bandstate[bandunit]->hw_rateset, true,
 	     wlc->stf->txstreams))
 		goto good;
@@ -2466,7 +2467,7 @@ static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 	if (IS_MBAND_UNLOCKED(wlc)) {
 		bandunit = OTHERBANDUNIT(wlc);
 		memcpy(&new, &rs, sizeof(wlc_rateset_t));
-		if (wlc_rate_hwrs_filter_sort_validate(&new,
+		if (brcms_c_rate_hwrs_filter_sort_validate(&new,
 						       &wlc->
 						       bandstate[bandunit]->
 						       hw_rateset, true,
@@ -2579,7 +2580,7 @@ _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 				break;
 			}
 
-			if (!wlc_valid_chanspec_db(wlc->cmi, chspec)) {
+			if (!brcms_c_valid_chanspec_db(wlc->cmi, chspec)) {
 				bcmerror = -EINVAL;
 				break;
 			}
@@ -3233,7 +3234,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	while (prec_map && (pkt[0] = brcmu_pktq_mdeq(q, prec_map, &prec))) {
 		tx_info = IEEE80211_SKB_CB(pkt[0]);
 		if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-			err = wlc_sendampdu(wlc->ampdu, qi, pkt, prec);
+			err = brcms_c_sendampdu(wlc->ampdu, qi, pkt, prec);
 		} else {
 			count = 1;
 			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
@@ -3557,7 +3558,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 	} else {		/* legacy OFDM/CCK */
 		s16 phycfg;
 		/* get the phyctl byte from rate phycfg table */
-		phycfg = wlc_rate_legacy_phyctl(RSPEC2RATE(rspec));
+		phycfg = brcms_c_rate_legacy_phyctl(RSPEC2RATE(rspec));
 		if (phycfg == -1) {
 			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
@@ -3770,8 +3771,8 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		} else {
 			if (!is_multicast_ether_addr(h->addr1)) {
 				/* set tx antenna config */
-				wlc_antsel_antcfg_get(wlc->asi, false, false, 0,
-						      0, &antcfg, &fbantcfg);
+				brcms_c_antsel_antcfg_get(wlc->asi, false,
+					false, 0, 0, &antcfg, &fbantcfg);
 			}
 		}
 	}
@@ -4103,7 +4104,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	/* add null delimiter count */
 	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec)) {
 		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
-		    wlc_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
+		   brcm_c_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
 	}
 #endif
 
@@ -4130,7 +4131,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	/* phytxant is properly bit shifted */
-	phyctl |= wlc_stf_d11hdrs_phyctl_txant(wlc, rspec[0]);
+	phyctl |= brcms_c_stf_d11hdrs_phyctl_txant(wlc, rspec[0]);
 	txh->PhyTxControlWord = cpu_to_le16(phyctl);
 
 	/* PhyTxControlWord_1 */
@@ -4348,7 +4349,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 		scb = (struct scb *)tx_info->control.sta->drv_priv;
 
 	if (tx_info->flags & IEEE80211_TX_CTL_AMPDU) {
-		wlc_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
+		brcms_c_ampdu_dotxstatus(wlc->ampdu, scb, p, txs);
 		return false;
 	}
 
@@ -4535,7 +4536,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
 
 	plcp = p->data;
 
-	rspec = wlc_compute_rspec(rxh, plcp);
+	rspec = brcms_c_compute_rspec(rxh, plcp);
 	if (IS_MCS(rspec)) {
 		rx_status->rate_idx = rspec & RSPEC_RATE_MASK;
 		rx_status->flag |= RX_FLAG_HT;
@@ -4930,7 +4931,7 @@ wlc_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 }
 
 /* derive wlc->band->basic_rate[] table from 'rateset' */
-void wlc_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
+void brcms_c_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 {
 	u8 rate;
 	u8 mandatory;
@@ -4954,8 +4955,8 @@ void wlc_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 		rate = (rateset->rates[i] & WLC_RATE_MASK);
 
 		if (rate > WLC_MAXRATE) {
-			wiphy_err(wlc->wiphy, "wlc_rate_lookup_init: invalid "
-				  "rate 0x%X in rate set\n",
+			wiphy_err(wlc->wiphy, "brcms_c_rate_lookup_init: "
+				  "invalid rate 0x%X in rate set\n",
 				  rateset->rates[i]);
 			continue;
 		}
@@ -5079,8 +5080,8 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 
 	rs_dflt = wlc_rateset_get_hwrs(wlc);
 
-	wlc_rateset_copy(rs_dflt, &rs);
-	wlc_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+	brcms_c_rateset_copy(rs_dflt, &rs);
+	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
 	/* walk the phy rate table and update SHM basic rate lookup table */
 	for (i = 0; i < rs.count; i++) {
@@ -5178,8 +5179,8 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 
 	rs_dflt = wlc_rateset_get_hwrs(wlc);
 
-	wlc_rateset_copy(rs_dflt, &rs);
-	wlc_rateset_mcs_upd(&rs, wlc->stf->txstreams);
+	brcms_c_rateset_copy(rs_dflt, &rs);
+	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
 
 	/* walk the phy rate table and update MAC core SHM basic rate table entries */
 	for (i = 0; i < rs.count; i++) {
@@ -5460,10 +5461,11 @@ void brcms_c_bsscfg_reprate_init(struct brcms_c_bsscfg *bsscfg)
 
 void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 {
-	wlc_rateset_default(rs, NULL, wlc->band->phytype, wlc->band->bandtype,
-			    false, WLC_RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
-			    CHSPEC_WLC_BW(wlc->default_bss->chanspec),
-			    wlc->stf->txstreams);
+	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
+		wlc->band->bandtype, false, WLC_RATE_MASK_FULL,
+		(bool) N_ENAB(wlc->pub),
+		CHSPEC_WLC_BW(wlc->default_bss->chanspec),
+		wlc->stf->txstreams);
 }
 
 static void wlc_bss_default_init(struct brcms_c_info *wlc)
@@ -5491,9 +5493,10 @@ static void wlc_bss_default_init(struct brcms_c_info *wlc)
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 
 	/* init bss rates to the band specific default rate set */
-	wlc_rateset_default(&bi->rateset, NULL, band->phytype, band->bandtype,
-			    false, WLC_RATE_MASK_FULL, (bool) N_ENAB(wlc->pub),
-			    CHSPEC_WLC_BW(chanspec), wlc->stf->txstreams);
+	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
+		band->bandtype, false, WLC_RATE_MASK_FULL,
+		(bool) N_ENAB(wlc->pub), CHSPEC_WLC_BW(chanspec),
+		wlc->stf->txstreams);
 
 	if (N_ENAB(wlc->pub))
 		bi->flags |= WLC_BSS_HT;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 2ec3ba9..8ceab43 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -620,11 +620,11 @@ extern struct wlc_pub *brcms_c_pub(void *wlc);
 /* common functions for every port */
 extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
 		    int bands);
-extern void wlc_rate_lookup_init(struct brcms_c_info *wlc,
-				 wlc_rateset_t *rateset);
+extern void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
+				     wlc_rateset_t *rateset);
 extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
 
-extern void wlc_ampdu_flush(struct brcms_c_info *wlc,
+extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
 			   int val);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index f19b512..dec508d 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -246,12 +246,10 @@ const wlc_rateset_t cck_rates = {
 	 0x00, 0x00, 0x00, 0x00}
 };
 
-static bool wlc_rateset_valid(wlc_rateset_t *rs, bool check_brate);
-
 /* check if rateset is valid.
  * if check_brate is true, rateset without a basic rate is considered NOT valid.
  */
-static bool wlc_rateset_valid(wlc_rateset_t *rs, bool check_brate)
+static bool brcms_c_rateset_valid(wlc_rateset_t *rs, bool check_brate)
 {
 	uint idx;
 
@@ -269,7 +267,7 @@ static bool wlc_rateset_valid(wlc_rateset_t *rs, bool check_brate)
 	return false;
 }
 
-void wlc_rateset_mcs_upd(wlc_rateset_t *rs, u8 txstreams)
+void brcms_c_rateset_mcs_upd(wlc_rateset_t *rs, u8 txstreams)
 {
 	int i;
 	for (i = txstreams; i < MAX_STREAMS_SUPPORTED; i++)
@@ -280,7 +278,7 @@ void wlc_rateset_mcs_upd(wlc_rateset_t *rs, u8 txstreams)
  * and check if resulting rateset is valid.
 */
 bool
-wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
+brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 				   const wlc_rateset_t *hw_rs,
 				   bool check_brate, u8 txstreams)
 {
@@ -315,14 +313,14 @@ wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 	for (i = 0; i < MCSSET_LEN; i++)
 		rs->mcs[i] = (rs->mcs[i] & hw_rs->mcs[i]);
 
-	if (wlc_rateset_valid(rs, check_brate))
+	if (brcms_c_rateset_valid(rs, check_brate))
 		return true;
 	else
 		return false;
 }
 
 /* calculate the rate of a rx'd frame and return it as a ratespec */
-ratespec_t wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
+ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 {
 	int phy_type;
 	ratespec_t rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
@@ -368,7 +366,7 @@ ratespec_t wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 }
 
 /* copy rateset src to dst as-is (no masking or sorting) */
-void wlc_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
+void brcms_c_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
 {
 	memcpy(dst, src, sizeof(wlc_rateset_t));
 }
@@ -383,7 +381,7 @@ void wlc_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
  * 'xmask' is the copy mask (typically 0x7f or 0xff).
  */
 void
-wlc_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
+brcms_c_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
 		   u8 rates, uint xmask, bool mcsallow)
 {
 	uint i;
@@ -407,14 +405,14 @@ wlc_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
 	if (mcsallow && rates != WLC_RATES_CCK)
 		memcpy(&dst->mcs[0], &src->mcs[0], MCSSET_LEN);
 	else
-		wlc_rateset_mcs_clear(dst);
+		brcms_c_rateset_mcs_clear(dst);
 }
 
 /* select rateset for a given phy_type and bandtype and filter it, sort it
  * and fill rs_tgt with result
  */
 void
-wlc_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
+brcms_c_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 		    uint phy_type, int bandtype, bool cck_only, uint rate_mask,
 		    bool mcsallow, u8 bw, u8 txstreams)
 {
@@ -447,16 +445,16 @@ wlc_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 	if (!rs_hw)
 		rs_hw = rs_dflt;
 
-	wlc_rateset_copy(rs_dflt, &rs_sel);
-	wlc_rateset_mcs_upd(&rs_sel, txstreams);
-	wlc_rateset_filter(&rs_sel, rs_tgt, false,
+	brcms_c_rateset_copy(rs_dflt, &rs_sel);
+	brcms_c_rateset_mcs_upd(&rs_sel, txstreams);
+	brcms_c_rateset_filter(&rs_sel, rs_tgt, false,
 			   cck_only ? WLC_RATES_CCK : WLC_RATES_CCK_OFDM,
 			   rate_mask, mcsallow);
-	wlc_rate_hwrs_filter_sort_validate(rs_tgt, rs_hw, false,
+	brcms_c_rate_hwrs_filter_sort_validate(rs_tgt, rs_hw, false,
 					   mcsallow ? txstreams : 1);
 }
 
-s16 wlc_rate_legacy_phyctl(uint rate)
+s16 brcms_c_rate_legacy_phyctl(uint rate)
 {
 	uint i;
 	for (i = 0; i < LEGACY_PHYCFG_TABLE_SIZE; i++)
@@ -466,21 +464,21 @@ s16 wlc_rate_legacy_phyctl(uint rate)
 	return -1;
 }
 
-void wlc_rateset_mcs_clear(wlc_rateset_t *rateset)
+void brcms_c_rateset_mcs_clear(wlc_rateset_t *rateset)
 {
 	uint i;
 	for (i = 0; i < MCSSET_LEN; i++)
 		rateset->mcs[i] = 0;
 }
 
-void wlc_rateset_mcs_build(wlc_rateset_t *rateset, u8 txstreams)
+void brcms_c_rateset_mcs_build(wlc_rateset_t *rateset, u8 txstreams)
 {
 	memcpy(&rateset->mcs[0], &cck_ofdm_mimo_rates.mcs[0], MCSSET_LEN);
-	wlc_rateset_mcs_upd(rateset, txstreams);
+	brcms_c_rateset_mcs_upd(rateset, txstreams);
 }
 
 /* Based on bandwidth passed, allow/disallow MCS 32 in the rateset */
-void wlc_rateset_bw_mcs_filter(wlc_rateset_t *rateset, u8 bw)
+void brcms_c_rateset_bw_mcs_filter(wlc_rateset_t *rateset, u8 bw)
 {
 	if (bw == WLC_40_MHZ)
 		setbit(rateset->mcs, 32);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 28ba4d6..8b4de8b 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -133,35 +133,37 @@ extern const u8 ofdm_rate_lookup[];
 #define OFDM_PHY2MAC_RATE(rlpt)		(ofdm_rate_lookup[rlpt & 0x7])
 #define CCK_PHY2MAC_RATE(signal)	(signal/5)
 
-/* Rates specified in wlc_rateset_filter() */
+/* Rates specified in brcms_c_rateset_filter() */
 #define WLC_RATES_CCK_OFDM	0
 #define WLC_RATES_CCK		1
 #define WLC_RATES_OFDM		2
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
-extern bool wlc_rate_hwrs_filter_sort_validate(struct wlc_rateset *rs,
+extern bool brcms_c_rate_hwrs_filter_sort_validate(struct wlc_rateset *rs,
 					       const struct wlc_rateset *hw_rs,
 					       bool check_brate,
 					       u8 txstreams);
 /* copy rateset src to dst as-is (no masking or sorting) */
-extern void wlc_rateset_copy(const struct wlc_rateset *src,
+extern void brcms_c_rateset_copy(const struct wlc_rateset *src,
 			     struct wlc_rateset *dst);
 
 /* would be nice to have these documented ... */
-extern ratespec_t wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp);
+extern ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp);
 
-extern void wlc_rateset_filter(struct wlc_rateset *src, struct wlc_rateset *dst,
-			       bool basic_only, u8 rates, uint xmask,
-			       bool mcsallow);
-extern void wlc_rateset_default(struct wlc_rateset *rs_tgt,
+extern void brcms_c_rateset_filter(struct wlc_rateset *src,
+	struct wlc_rateset *dst, bool basic_only, u8 rates, uint xmask,
+	bool mcsallow);
+
+extern void brcms_c_rateset_default(struct wlc_rateset *rs_tgt,
 				const struct wlc_rateset *rs_hw, uint phy_type,
 				int bandtype, bool cck_only, uint rate_mask,
 				bool mcsallow, u8 bw, u8 txstreams);
-extern s16 wlc_rate_legacy_phyctl(uint rate);
+extern s16 brcms_c_rate_legacy_phyctl(uint rate);
 
-extern void wlc_rateset_mcs_upd(struct wlc_rateset *rs, u8 txstreams);
-extern void wlc_rateset_mcs_clear(struct wlc_rateset *rateset);
-extern void wlc_rateset_mcs_build(struct wlc_rateset *rateset, u8 txstreams);
-extern void wlc_rateset_bw_mcs_filter(struct wlc_rateset *rateset, u8 bw);
+extern void brcms_c_rateset_mcs_upd(struct wlc_rateset *rs, u8 txstreams);
+extern void brcms_c_rateset_mcs_clear(struct wlc_rateset *rateset);
+extern void brcms_c_rateset_mcs_build(struct wlc_rateset *rateset,
+				      u8 txstreams);
+extern void brcms_c_rateset_bw_mcs_filter(struct wlc_rateset *rateset, u8 bw);
 
 #endif				/* _WLC_RATE_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 8276e76c..d83d3a3 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -31,13 +31,14 @@
 #define WLC_STF_SS_STBC_RX(wlc) (WLCISNPHY(wlc->band) && \
 	NREV_GT(wlc->band->phyrev, 3) && NREV_LE(wlc->band->phyrev, 6))
 
-static bool wlc_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val);
-static int wlc_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 val);
-static int wlc_stf_spatial_policy_set(struct brcms_c_info *wlc, int val);
-static void wlc_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val);
+static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val);
+static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 val);
+static int brcms_c_stf_spatial_policy_set(struct brcms_c_info *wlc, int val);
+static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val);
 
-static void _wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
-static u16 _wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec);
+static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
+static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
+				       ratespec_t rspec);
 
 #define NSTS_1	1
 #define NSTS_2	2
@@ -51,7 +52,7 @@ const u8 txcore_default[5] = {
 	(0x0f)			/* For Nsts = 4, enable all cores */
 };
 
-static void wlc_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
+static void brcms_c_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 {
 	/* MIMOPHYs rev3-6 cannot receive STBC with only one rx core active */
 	if (WLC_STF_SS_STBC_RX(wlc)) {
@@ -69,7 +70,7 @@ static void wlc_stf_stbc_rx_ht_update(struct brcms_c_info *wlc, int val)
 }
 
 /* every WLC_TEMPSENSE_PERIOD seconds temperature check to decide whether to turn on/off txchain */
-void wlc_tempsense_upd(struct brcms_c_info *wlc)
+void brcms_c_tempsense_upd(struct brcms_c_info *wlc)
 {
 	wlc_phy_t *pi = wlc->band->pi;
 	uint active_chains, txchain;
@@ -82,18 +83,18 @@ void wlc_tempsense_upd(struct brcms_c_info *wlc)
 	if (wlc->stf->txchain == wlc->stf->hw_txchain) {
 		if (txchain && (txchain < wlc->stf->hw_txchain)) {
 			/* turn off 1 tx chain */
-			wlc_stf_txchain_set(wlc, txchain, true);
+			brcms_c_stf_txchain_set(wlc, txchain, true);
 		}
 	} else if (wlc->stf->txchain < wlc->stf->hw_txchain) {
 		if (txchain == wlc->stf->hw_txchain) {
 			/* turn back on txchain */
-			wlc_stf_txchain_set(wlc, txchain, true);
+			brcms_c_stf_txchain_set(wlc, txchain, true);
 		}
 	}
 }
 
 void
-wlc_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
+brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 			    chanspec_t chanspec)
 {
 	tx_power_t power;
@@ -134,7 +135,7 @@ wlc_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 		setbit(ss_algo_channel, PHY_TXC1_MODE_STBC);
 }
 
-static bool wlc_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
+static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 {
 	if ((int_val != AUTO) && (int_val != OFF) && (int_val != ON)) {
 		return false;
@@ -155,7 +156,7 @@ static bool wlc_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 	return true;
 }
 
-bool wlc_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
+bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 {
 	if ((int_val != HT_CAP_RX_STBC_NO)
 	    && (int_val != HT_CAP_RX_STBC_ONE_STREAM)) {
@@ -168,11 +169,12 @@ bool wlc_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 			return false;
 	}
 
-	wlc_stf_stbc_rx_ht_update(wlc, int_val);
+	brcms_c_stf_stbc_rx_ht_update(wlc, int_val);
 	return true;
 }
 
-static int wlc_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 core_mask)
+static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts,
+				  u8 core_mask)
 {
 	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, Nsts, core_mask);
@@ -205,7 +207,7 @@ static int wlc_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts, u8 core_mask)
 	return 0;
 }
 
-static int wlc_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
+static int brcms_c_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
 {
 	int i;
 	u8 core_mask = 0;
@@ -216,12 +218,12 @@ static int wlc_stf_spatial_policy_set(struct brcms_c_info *wlc, int val)
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++) {
 		core_mask = (val == MAX_SPATIAL_EXPANSION) ?
 		    wlc->stf->txchain : txcore_default[i];
-		wlc_stf_txcore_set(wlc, (u8) i, core_mask);
+		brcms_c_stf_txcore_set(wlc, (u8) i, core_mask);
 	}
 	return 0;
 }
 
-int wlc_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
+int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 {
 	u8 txchain = (u8) int_val;
 	u8 txstreams;
@@ -271,24 +273,24 @@ int wlc_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val, bool force)
 
 	wlc->stf->txchain = txchain;
 	wlc->stf->txstreams = txstreams;
-	wlc_stf_stbc_tx_set(wlc, wlc->band->band_stf_stbc_tx);
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
+	brcms_c_stf_stbc_tx_set(wlc, wlc->band->band_stf_stbc_tx);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 	wlc->stf->txant =
 	    (wlc->stf->txstreams == 1) ? ANT_TX_FORCE_0 : ANT_TX_DEF;
-	_wlc_stf_phy_txant_upd(wlc);
+	_brcms_c_stf_phy_txant_upd(wlc);
 
 	wlc_phy_stf_chain_set(wlc->band->pi, wlc->stf->txchain,
 			      wlc->stf->rxchain);
 
 	for (i = 1; i <= MAX_STREAMS_SUPPORTED; i++)
-		wlc_stf_txcore_set(wlc, (u8) i, txcore_default[i]);
+		brcms_c_stf_txcore_set(wlc, (u8) i, txcore_default[i]);
 
 	return 0;
 }
 
 /* update wlc->stf->ss_opmode which represents the operational stf_ss mode we're using */
-int wlc_stf_ss_update(struct brcms_c_info *wlc, struct brcms_c_band *band)
+int brcms_c_stf_ss_update(struct brcms_c_info *wlc, struct brcms_c_band *band)
 {
 	int ret_code = 0;
 	u8 prev_stf_ss;
@@ -320,7 +322,7 @@ int wlc_stf_ss_update(struct brcms_c_info *wlc, struct brcms_c_band *band)
 	return ret_code;
 }
 
-int wlc_stf_attach(struct brcms_c_info *wlc)
+int brcms_c_stf_attach(struct brcms_c_info *wlc)
 {
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_SISO;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_ss_mode = PHY_TXC1_MODE_CDD;
@@ -329,10 +331,10 @@ int wlc_stf_attach(struct brcms_c_info *wlc)
 	    (wlc_phy_txpower_hw_ctrl_get(wlc->band->pi) != PHY_TPC_HW_ON))
 		wlc->bandstate[BAND_2G_INDEX]->band_stf_ss_mode =
 		    PHY_TXC1_MODE_CDD;
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
-	wlc_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
+	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 
-	wlc_stf_stbc_rx_ht_update(wlc, HT_CAP_RX_STBC_NO);
+	brcms_c_stf_stbc_rx_ht_update(wlc, HT_CAP_RX_STBC_NO);
 	wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = OFF;
 	wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = OFF;
 
@@ -343,7 +345,7 @@ int wlc_stf_attach(struct brcms_c_info *wlc)
 	return 0;
 }
 
-void wlc_stf_detach(struct brcms_c_info *wlc)
+void brcms_c_stf_detach(struct brcms_c_info *wlc)
 {
 }
 
@@ -361,7 +363,7 @@ void wlc_stf_detach(struct brcms_c_info *wlc)
  *    do tx-antenna selection for SISO transmissions
  * for NREV>=7, bit 6 and bit 7 mean antenna 0 and 1 respectively, nit6+bit7 means both cores active
 */
-static void _wlc_stf_phy_txant_upd(struct brcms_c_info *wlc)
+static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
 	s8 txant;
 
@@ -399,12 +401,12 @@ static void _wlc_stf_phy_txant_upd(struct brcms_c_info *wlc)
 	brcms_b_txant_set(wlc->hw, wlc->stf->phytxant);
 }
 
-void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc)
+void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 {
-	_wlc_stf_phy_txant_upd(wlc);
+	_brcms_c_stf_phy_txant_upd(wlc);
 }
 
-void wlc_stf_phy_chain_calc(struct brcms_c_info *wlc)
+void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 {
 	/* get available rx/tx chains */
 	wlc->stf->hw_txchain = (u8) getintvar(wlc->pub->vars, "txchain");
@@ -438,10 +440,11 @@ void wlc_stf_phy_chain_calc(struct brcms_c_info *wlc)
 
 	/* default spatial_policy */
 	wlc->stf->spatial_policy = MIN_SPATIAL_EXPANSION;
-	wlc_stf_spatial_policy_set(wlc, MIN_SPATIAL_EXPANSION);
+	brcms_c_stf_spatial_policy_set(wlc, MIN_SPATIAL_EXPANSION);
 }
 
-static u16 _wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
+static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
+				       ratespec_t rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 
@@ -453,19 +456,19 @@ static u16 _wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
 	return phytxant;
 }
 
-u16 wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
+u16 brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec)
 {
-	return _wlc_stf_phytxchain_sel(wlc, rspec);
+	return _brcms_c_stf_phytxchain_sel(wlc, rspec);
 }
 
-u16 wlc_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, ratespec_t rspec)
+u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc, ratespec_t rspec)
 {
 	u16 phytxant = wlc->stf->phytxant;
 	u16 mask = PHY_TXC_ANT_MASK;
 
 	/* for non-siso rates or default setting, use the available chains */
 	if (WLCISNPHY(wlc->band)) {
-		phytxant = _wlc_stf_phytxchain_sel(wlc, rspec);
+		phytxant = _brcms_c_stf_phytxchain_sel(wlc, rspec);
 		mask = PHY_TXC_HTANT_MASK;
 	}
 	phytxant |= phytxant & mask;
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.h b/drivers/staging/brcm80211/brcmsmac/stf.h
index a68c819..2033938 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.h
+++ b/drivers/staging/brcm80211/brcmsmac/stf.h
@@ -19,23 +19,24 @@
 
 #include "types.h"
 
-extern int wlc_stf_attach(struct brcms_c_info *wlc);
-extern void wlc_stf_detach(struct brcms_c_info *wlc);
+extern int brcms_c_stf_attach(struct brcms_c_info *wlc);
+extern void brcms_c_stf_detach(struct brcms_c_info *wlc);
 
-extern void wlc_tempsense_upd(struct brcms_c_info *wlc);
-extern void wlc_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
+extern void brcms_c_tempsense_upd(struct brcms_c_info *wlc);
+extern void brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc,
 					u16 *ss_algo_channel,
 					chanspec_t chanspec);
-extern int wlc_stf_ss_update(struct brcms_c_info *wlc,
+extern int brcms_c_stf_ss_update(struct brcms_c_info *wlc,
 			     struct brcms_c_band *band);
-extern void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
-extern int wlc_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val,
+extern void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
+extern int brcms_c_stf_txchain_set(struct brcms_c_info *wlc, s32 int_val,
 			       bool force);
-extern bool wlc_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val);
-extern void wlc_stf_phy_txant_upd(struct brcms_c_info *wlc);
-extern void wlc_stf_phy_chain_calc(struct brcms_c_info *wlc);
-extern u16 wlc_stf_phytxchain_sel(struct brcms_c_info *wlc, ratespec_t rspec);
-extern u16 wlc_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc,
+extern bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val);
+extern void brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc);
+extern void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc);
+extern u16 brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
+				      ratespec_t rspec);
+extern u16 brcms_c_stf_d11hdrs_phyctl_txant(struct brcms_c_info *wlc,
 					ratespec_t rspec);
 
 #endif				/* _BRCM_STF_H_ */
-- 
1.7.4.1


