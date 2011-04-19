Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4908 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889Ab1DSG7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 02:59:21 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] staging: brcm80211: replaced WL_AMPDU_* with BCMMSG
Date: Tue, 19 Apr 2011 08:59:03 +0200
Message-ID: <1303196344-3157-3-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
References: <1303196344-3157-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wl_dbg.h    |    3 -
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |   50 +++++++++--------------
 2 files changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wl_dbg.h b/drivers/staging/brcm80211/brcmsmac/wl_dbg.h
index 5e58f5e..d95f8a9 100644
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
index 1b92767..d306bf7 100644
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
+	BCMMSG(ampdu->wlc->dev, "enter\n");
 	for (tid = 0; tid < AMPDU_MAX_SCB_TID; tid++) {
 		ampdu_cleanup_tid_ini(ampdu, scb_ampdu, tid, false);
 	}
@@ -605,8 +595,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		ndelim = txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM];
 		seg_cnt += 1;
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: mpdu %d plcp_len %d\n",
-			    wlc->pub->unit, count, len);
+		BCMMSG(wlc->dev, "wl%d: mpdu %d plcp_len %d\n",
+			wlc->pub->unit, count, len);
 
 		/*
 		 * aggregateable mpdu. For ucode/hw agg,
@@ -636,8 +626,9 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 
 		dma_len += (u16) pkttotlen(p);
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: ampdu_len %d seg_cnt %d null delim %d\n",
-			    wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
+		BCMMSG(wlc->dev, "wl%d: ampdu_len %d"
+			" seg_cnt %d null delim %d\n",
+			wlc->pub->unit, ampdu_len, seg_cnt, ndelim);
 
 		txh->MacTxControlLow = cpu_to_le16(mcl);
 
@@ -713,8 +704,9 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		/* test whether to add more */
 		if ((MCS_RATE(mcs, true, false) >= f->dmaxferrate) &&
 		    (count == f->mcs2ampdu_table[mcs])) {
-			WL_AMPDU_ERR("wl%d: PR 37644: stopping ampdu at %d for mcs %d\n",
-				     wlc->pub->unit, count, mcs);
+			BCMMSG(wlc->dev, "wl%d: PR 37644: stopping"
+				" ampdu at %d for mcs %d\n",
+				wlc->pub->unit, count, mcs);
 			break;
 		}
 
@@ -852,8 +844,8 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 			WLC_SET_MIMO_PLCP_AMPDU(txh->FragPLCPFallback);
 		}
 
-		WL_AMPDU_TX("wl%d: wlc_sendampdu: count %d ampdu_len %d\n",
-			    wlc->pub->unit, count, ampdu_len);
+		BCMMSG(wlc->dev, "wl%d: count %d ampdu_len %d\n",
+			wlc->pub->unit, count, ampdu_len);
 
 		/* inform rate_sel if it this is a rate probe pkt */
 		frameid = le16_to_cpu(txh->TxFrameID);
@@ -1075,11 +1067,10 @@ wlc_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 		ack_recd = false;
 		if (ba_recd) {
 			bindex = MODSUB_POW2(seq, start_seq, SEQNUM_MAX);
-
-			WL_AMPDU_TX("%s: tid %d seq is %d, start_seq is %d, bindex is %d set %d, index %d\n",
-				    __func__, tid, seq, start_seq, bindex,
-				    isset(bitmap, bindex), index);
-
+			BCMMSG(wlc->dev, "tid %d seq %d,"
+				" start_seq %d, bindex %d set %d, index %d\n",
+				tid, seq, start_seq, bindex,
+				isset(bitmap, bindex), index);
 			/* if acked then clear bit and free packet */
 			if ((bindex < AMPDU_TX_BA_MAX_WSIZE)
 			    && isset(bitmap, bindex)) {
@@ -1157,8 +1148,7 @@ ampdu_cleanup_tid_ini(struct ampdu_info *ampdu, scb_ampdu_t *scb_ampdu, u8 tid,
 	if (!ini)
 		return;
 
-	WL_AMPDU_CTL("wl%d: ampdu_cleanup_tid_ini: tid %d\n",
-		     ampdu->wlc->pub->unit, tid);
+	BCMMSG(ampdu->wlc->dev, "wl%d: tid %d\n", ampdu->wlc->pub->unit, tid);
 
 	if (ini->tx_in_transit && !force)
 		return;
@@ -1200,13 +1190,13 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 
 	if (on) {
 		if (!N_ENAB(wlc->pub)) {
-			WL_AMPDU_ERR("wl%d: driver not nmode enabled\n",
-				     wlc->pub->unit);
+			dev_err(ampdu->wlc->dev, "wl%d: driver not "
+				"nmode enabled\n", wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		if (!wlc_ampdu_cap(ampdu)) {
-			WL_AMPDU_ERR("wl%d: device not ampdu capable\n",
-				     wlc->pub->unit);
+			dev_err(ampdu->wlc->dev, "wl%d: device not "
+				"ampdu capable\n", wlc->pub->unit);
 			return -ENOTSUPP;
 		}
 		wlc->pub->_ampdu = on;
-- 
1.7.1


