Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2382 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab1ECJg3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:29 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 59/61] staging: brcm80211: replaced WL_AMPDU_* with
 BCMMSG
Date: Tue, 3 May 2011 11:35:59 +0200
Message-ID: <1304415361-7813-60-git-send-email-arend@broadcom.com> (sfid-20110503_113655_695978_11808520)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Remove WL_AMPDU_* tracing macros with BCMMSG as it does not need to
be so specific.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h    |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   50 +++++++++--------------
 drivers/staging/brcm80211/brcmsmac/wlc_main.c  |    5 +-
 3 files changed, 23 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 6e7f664..8beeefe 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
+++ b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
@@ -36,7 +36,6 @@ do {						\
 
 #ifdef BCMDBG
 
-#define WL_AMPDU(fmt, args...)	WL_PRINT(WL_AMPDU_VAL, fmt, ##args)
 #define WL_FFPLD(fmt, args...)	WL_PRINT(WL_FFPLD_VAL, fmt, ##args)
 
 /* Extra message control for AMPDU debugging */
@@ -80,8 +79,6 @@ do {						\
 
 #else				/* BCMDBG */
 
-#define	WL_TRACE(fmt, args...)		no_printk(fmt, ##args)
-#define WL_AMPDU(fmt, args...)		no_printk(fmt, ##args)
 #define WL_FFPLD(fmt, args...)		no_printk(fmt, ##args)
 
 #define WL_AMPDU_UPDN(fmt, args...)	no_printk(fmt, ##args)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 49ac26c..dbdbe85 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -76,16 +76,6 @@
 	AMPDU_DELIMITER_LEN + 3\
 	+ DOT11_A4_HDR_LEN + DOT11_QOS_LEN + DOT11_IV_MAX_LEN)
 
-#ifdef BCMDBG
-u32 wl_ampdu_dbg =
-    WL_AMPDU_UPDN_VAL |
-    WL_AMPDU_ERR_VAL |
-    WL_AMPDU_TX_VAL |
-    WL_AMPDU_RX_VAL |
-    WL_AMPDU_CTL_VAL |
-    WL_AMPDU_HW_VAL | WL_AMPDU_HWTXS_VAL | WL_AMPDU_HWDBG_VAL;
-#endif
-
 /* structure to hold tx fifo information and pre-loading state
  * counters specific to tx underflows of ampdus
  * some counters might be redundant with the ones in wlc or ampdu structures.
@@ -235,7 +225,7 @@ void scb_ampdu_cleanup(struct ampdu_info *ampdu, struct scb *scb)
 	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	u8 tid;
 
-	WL_AMPDU_UPDN("scb_ampdu_cleanup: enter\n");
+	BCMMSG(ampdu->wlc->wiphy, "enter\n");
 	for (tid = 0; tid < AMPDU_MAX_SCB_TID; tid++) {
 		ampdu_cleanup_tid_ini(ampdu, scb_ampdu, tid, false);
 	}
@@ -604,8 +594,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
 		seg_cnt += 1;
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: mpdu %d plcp_len %d\n",
-			    wlc->pub->unit, count, len);
+		BCMMSG(wlc->wiphy, "wl%d: mpdu %d plcp_len %d\n",
+			wlc->pub->unit, count, len);
 
 		/*
 		 * aggregateable mpdu. For ucode/hw agg,
@@ -635,8 +625,9 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 		dma_len += (u16) pkttotlen(p);
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: ampdu_len %d seg_cnt %d null delim %d\n",
-			    wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
+		BCMMSG(wlc->wiphy, "wl%d: ampdu_len %d"
+			" seg_cnt %d null delim %d\n",
+			wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
 
 		txh->MacTxControlLow = cpu_to_le16(mcl);
 
@@ -709,8 +700,9 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		/* test whether to add more */
 		if ((MCS_RATE(mcs, true, false) >= f->dmaxferrate) &&
 		    (count == f->mcs2ampdu_table[mcs])) {
-			WL_AMPDU_ERR("wl%d: PR 37644: stopping ampdu at %d for mcs %d\n",
-				     wlc->pub->unit, count, mcs);
+			BCMMSG(wlc->wiphy, "wl%d: PR 37644: stopping"
+				" ampdu at %d for mcs %d\n",
+				wlc->pub->unit, count, mcs);
 			break;
 		}
 
@@ -846,8 +838,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			WLC_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 		}
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: count %d ampdu_len %d\n",
-			    wlc->pub->unit, count, ampdu_len);
+		BCMMSG(wlc->wiphy, "wl%d: count %d ampdu_len %d\n",
+			wlc->pub->unit, count, ampdu_len);
 
 		/* inform rate_sel if it this is a rate probe pkt */
 		frameid = le16_to_cpu(txh->TxFrameID);
@@ -1068,11 +1060,10 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		ack_recd = false;
 		if (ba_recd) {
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
-
-			WL_AMPDU_TX("%s: tid %d seq is %d, start_seq is %d, bindex is %d set %d, index %d\n",
-				    __func__, tid, seq, start_seq, bindex,
-				    isset(bitmap, bindex), index);
-
+			BCMMSG(wlc->wiphy, "tid %d seq %d,"
+				" start_seq %d, bindex %d set %d, index %d\n",
+				tid, seq, start_seq, bindex,
+				isset(bitmap, bindex), index);
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
 			    && isset(bitmap, bindex)) {
@@ -1150,8 +1141,7 @@ ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
 	if (!ini)
 		return;
 
-	WL_AMPDU_CTL("wl%d: ampdu_cleanup_tid_ini: tid %d\n",
-		     ampdu->wlc->pub->unit, tid);
+	BCMMSG(ampdu->wlc->wiphy, "wl%d: tid %d\n", ampdu->wlc->pub->unit, tid);
 
 	if (ini->tx_in_transit && !force)
 		return;
@@ -1193,13 +1183,13 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 
 	if (on) {
 		if (!N_ENAB(wlc->pub)) {
-			WL_AMPDU_ERR("wl%d: driver not nmode enabled\n",
-				     wlc->pub->unit);
+			wiphy_err(ampdu->wlc->wiphy, "wl%d: driver not "
+				"nmode enabled\n", wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		if (!wlc_ampdu_cap(ampdu)) {
-			WL_AMPDU_ERR("wl%d: device not ampdu capable\n",
-				     wlc->pub->unit);
+			wiphy_err(ampdu->wlc->wiphy, "wl%d: device not "
+				"ampdu capable\n", wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		wlc->pub->_ampdu = on;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index f0dd21e..6edaa09 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -6280,8 +6280,9 @@ wlc_dotxstatus(struct wlc_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 	if (supr_status == TX_STATUS_SUPR_BADCH)
-		WL_TRACE("%s: Pkt tx suppressed, possibly channel %d\n",
-			 __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
+		BCMMSG(wlc->wiphy,
+		       "%s: Pkt tx suppressed, possibly channel %d\n",
+		       __func__, CHSPEC_CHANNEL(wlc->default_bss->chanspec));
 
 	tx_rts = cpu_to_le16(txh->MacTxControlLow) & TXC_SENDRTS;
 	tx_frame_count =
-- 
1.7.4.1


