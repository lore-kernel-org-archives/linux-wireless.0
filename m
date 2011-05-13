Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4903 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753594Ab1EMKAK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 06:00:10 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 13/32] staging: brcm80211: removed counter related
 macros that expanded to NOP
Date: Fri, 13 May 2011 11:59:33 +0200
Message-ID: <1305280792-9475-13-git-send-email-arend@broadcom.com> (sfid-20110513_120113_041069_4C169E62)
In-Reply-To: <1305280792-9475-1-git-send-email-arend@broadcom.com>
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   16 -------
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |   53 ------------------------
 drivers/staging/brcm80211/include/bcmutils.h   |    1 -
 3 files changed, 0 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 5b041a6..11aac96 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -38,12 +38,6 @@
 #include "wlc_main.h"
 #include "wlc_ampdu.h"
 
-/*
- *	Disable AMPDU statistics counters for now
- */
-#define WLCNTINCR(a)
-#define WLCNTADD(a, b)
-
 #define AMPDU_MAX_MPDU		32	/* max number of mpdus in an ampdu */
 #define AMPDU_NUM_MPDU_LEGACY	16	/* max number of mpdus in an ampdu to a legacy */
 #define AMPDU_TX_BA_MAX_WSIZE	64	/* max Tx ba window size (in pdu) */
@@ -532,7 +526,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 				wiphy_err(wiphy, "wl%d: wlc_sendampdu: "
 					  "prep_xdu retry; seq 0x%x\n",
 					  wlc->pub->unit, seq);
-				WLCNTINCR(ampdu->cnt->sduretry);
 				*pdu = p;
 				break;
 			}
@@ -540,8 +533,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			/* error in the packet; reject it */
 			wiphy_err(wiphy, "wl%d: wlc_sendampdu: prep_xdu "
 				  "rejected; seq 0x%x\n", wlc->pub->unit, seq);
-			WLCNTINCR(ampdu->cnt->sdurejected);
-
 			*pdu = NULL;
 			break;
 		}
@@ -730,8 +721,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	ini->tx_in_transit += count;
 
 	if (count) {
-		WLCNTADD(ampdu->cnt->txmpdu, count);
-
 		/* patch up the last txh */
 		txh = (d11txh_t *) pkt[count - 1]->data;
 		mcl = le16_to_cpu(txh->MacTxControlLow);
@@ -814,8 +803,6 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 		/* set flag and plcp for fallback rate */
 		if (fbr) {
-			WLCNTADD(ampdu->cnt->txfbr_mpdu, count);
-			WLCNTINCR(ampdu->cnt->txfbr_ampdu);
 			mch |= TXC_AMPDU_FBR;
 			txh->MacTxControlHigh = cpu_to_le16(mch);
 			WLC_SET_MIMO_PLCP_AMPDU(plcp);
@@ -978,7 +965,6 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 		ba_recd = true;
 	} else {
-		WLCNTINCR(ampdu->cnt->noba);
 		if (supr_status) {
 			update_rate = false;
 			if (supr_status == TX_STATUS_SUPR_BADCH) {
@@ -1134,8 +1120,6 @@ static scb_ampdu_tid_ini_t *wlc_ampdu_init_tid_ini(struct ampdu_info *ampdu,
 	ini->tid = tid;
 	ini->scb = scb_ampdu->scb;
 	ini->magic = INI_MAGIC;
-	WLCNTINCR(ampdu->cnt->txaddbareq);
-
 	return ini;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 259544e..e4cf9f6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -56,13 +56,6 @@
 #include "wl_mac80211.h"
 
 /*
- *	Disable statistics counting for WME
- */
-#define WLCNTSET(a, b)
-#define WLCNTINCR(a)
-#define WLCNTADD(a, b)
-
-/*
  * WPA(2) definitions
  */
 #define RSN_CAP_4_REPLAY_CNTRS		2
@@ -1762,9 +1755,6 @@ void *wlc_attach(struct wl_info *wl, u16 vendor, u16 device, uint unit,
 	pub->_cnt->version = WL_CNT_T_VERSION;
 	pub->_cnt->length = sizeof(struct wl_cnt);
 
-	WLCNTSET(pub->_wme_cnt->version, WL_WME_CNT_VERSION);
-	WLCNTSET(pub->_wme_cnt->length, sizeof(wl_wme_cnt_t));
-
 	wlc_wme_initparams_sta(wlc, &wlc->wme_param_ie);
 
 	wlc->mimoft = FT_HT;
@@ -4508,44 +4498,13 @@ void wlc_statsupd(struct wlc_info *wlc)
 	}
 #endif				/* BCMDBG */
 
-	/* dot11 counter update */
-
-	WLCNTSET(wlc->pub->_cnt->txrts,
-		 (wlc->pub->_cnt->rxctsucast -
-		  wlc->pub->_cnt->d11cnt_txrts_off));
-	WLCNTSET(wlc->pub->_cnt->rxcrc,
-		 (wlc->pub->_cnt->rxbadfcs - wlc->pub->_cnt->d11cnt_rxcrc_off));
-	WLCNTSET(wlc->pub->_cnt->txnocts,
-		 ((wlc->pub->_cnt->txrtsfrm - wlc->pub->_cnt->rxctsucast) -
-		  wlc->pub->_cnt->d11cnt_txnocts_off));
-
 	/* merge counters from dma module */
 	for (i = 0; i < NFIFO; i++) {
 		if (wlc->hw->di[i]) {
-			WLCNTADD(wlc->pub->_cnt->txnobuf,
-				 (wlc->hw->di[i])->txnobuf);
-			WLCNTADD(wlc->pub->_cnt->rxnobuf,
-				 (wlc->hw->di[i])->rxnobuf);
-			WLCNTADD(wlc->pub->_cnt->rxgiant,
-				 (wlc->hw->di[i])->rxgiants);
 			dma_counterreset(wlc->hw->di[i]);
 		}
 	}
 
-	/*
-	 * Aggregate transmit and receive errors that probably resulted
-	 * in the loss of a frame are computed on the fly.
-	 */
-	WLCNTSET(wlc->pub->_cnt->txerror,
-		 wlc->pub->_cnt->txnobuf + wlc->pub->_cnt->txnoassoc +
-		 wlc->pub->_cnt->txuflo + wlc->pub->_cnt->txrunt +
-		 wlc->pub->_cnt->dmade + wlc->pub->_cnt->dmada +
-		 wlc->pub->_cnt->dmape);
-	WLCNTSET(wlc->pub->_cnt->rxerror,
-		 wlc->pub->_cnt->rxoflo + wlc->pub->_cnt->rxnobuf +
-		 wlc->pub->_cnt->rxfragerr + wlc->pub->_cnt->rxrunt +
-		 wlc->pub->_cnt->rxgiant + wlc->pub->_cnt->rxnoscb +
-		 wlc->pub->_cnt->rxbadsrcmac);
 	for (i = 0; i < NFIFO; i++)
 		wlc->pub->_cnt->rxerror += wlc->pub->_cnt->rxuflo[i];
 }
@@ -4778,14 +4737,6 @@ wlc_prec_enq_head(struct wlc_info *wlc, struct pktq *q, struct sk_buff *pkt,
 		/* Evict packet according to discard policy */
 		p = discard_oldest ? bcm_pktq_pdeq(q, eprec) :
 			bcm_pktq_pdeq_tail(q, eprec);
-		/* Increment wme stats */
-		if (WME_ENAB(wlc->pub)) {
-			WLCNTINCR(wlc->pub->_wme_cnt->
-				  tx_failed[WME_PRIO2AC(p->priority)].packets);
-			WLCNTADD(wlc->pub->_wme_cnt->
-				 tx_failed[WME_PRIO2AC(p->priority)].bytes,
-				 bcm_pkttotlen(p));
-		}
 		bcm_pkt_buf_free_skb(p);
 		wlc->pub->_cnt->txnobuf++;
 	}
@@ -5989,10 +5940,6 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
 	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
-		WLCNTADD(wlc->pub->_cnt->txnoack,
-			 ((txs->
-			   status & TX_STATUS_FRM_RTX_MASK) >>
-			  TX_STATUS_FRM_RTX_SHIFT));
 		wiphy_err(wlc->wiphy, "%s: INTERMEDIATE but not AMPDU\n",
 			  __func__);
 		return false;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index cd58ca6..c08e5f1 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -149,7 +149,6 @@ extern void bcm_prpkt(const char *msg, struct sk_buff *p0);
 #endif				/* BCMDBG */
 
 #define bcm_perf_enable()
-#define bcmstats(fmt)
 #define	bcmlog(fmt, a1, a2)
 #define	bcmdumplog(buf, size)	(*buf = '\0')
 #define	bcmdumplogent(buf, idx)	-1
-- 
1.7.4.1


