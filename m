Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4708 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758170Ab1F2XtQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:16 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 022/119] staging: brcm80211: taking max AMPDU length
 advertized by peer into account
Date: Wed, 29 Jun 2011 16:46:46 -0700
Message-ID: <1309391303-22741-23-git-send-email-frankyl@broadcom.com> (sfid-20110630_015205_614224_79671E33)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

AP advertizes max AMPDU rx length in beacon/probe response frame. Code now
uses this information to limit the length of AMPDU frames it transmits.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |   25 ++++++++-------------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    7 ++++-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    2 +-
 drivers/staging/brcm80211/brcmsmac/scb.h         |    2 +-
 4 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index e9b78bf..6271ad1 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -220,9 +220,9 @@ static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 
 	scb_ampdu->release = min_t(u8, scb_ampdu->max_pdu, AMPDU_SCB_MAX_RELEASE);
 
-	if (scb_ampdu->max_rxlen)
-		scb_ampdu->release =
-		    min_t(u8, scb_ampdu->release, scb_ampdu->max_rxlen / 1600);
+	if (scb_ampdu->max_rx_ampdu_bytes)
+		scb_ampdu->release = min_t(u8, scb_ampdu->release,
+			scb_ampdu->max_rx_ampdu_bytes / 1600);
 
 	scb_ampdu->release = min(scb_ampdu->release,
 				 ampdu->fifo_tb[TX_AC_BE_FIFO].
@@ -410,7 +410,8 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 
 void
 brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
-		  u8 ba_wsize)		/* negotiated ba window size (in pdu) */
+	u8 ba_wsize,		/* negotiated ba window size (in pdu) */
+	uint max_rx_ampdu_bytes) /* from ht_cap in beacon */
 {
 	scb_ampdu_t *scb_ampdu;
 	scb_ampdu_tid_ini_t *ini;
@@ -428,6 +429,7 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	ini->tid = tid;
 	ini->scb = scb_ampdu->scb;
 	ini->ba_wsize = ba_wsize;
+	scb_ampdu->max_rx_ampdu_bytes = max_rx_ampdu_bytes;
 }
 
 int
@@ -446,7 +448,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 	bool rr = true, fbr = false;
 	uint i, count = 0, fifo, seg_cnt = 0;
 	u16 plen, len, seq = 0, mcl, mch, index, frameid, dma_len = 0;
-	u32 ampdu_len, maxlen = 0;
+	u32 ampdu_len, max_ampdu_bytes = 0;
 	d11txh_t *txh = NULL;
 	u8 *plcp;
 	struct ieee80211_hdr *h;
@@ -611,15 +613,10 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 			is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
 			sgi = PLCP3_ISSGI(plcp3) ? 1 : 0;
 			mcs = plcp0 & ~MIMO_PLCP_40MHZ;
-			maxlen =
-			    min(scb_ampdu->max_rxlen,
+			max_ampdu_bytes =
+			    min(scb_ampdu->max_rx_ampdu_bytes,
 				ampdu->max_txlen[mcs][is40][sgi]);
 
-			/* XXX Fix me to honor real max_rxlen */
-			/* can fix this as soon as ampdu_action() in mac80211.h
-			 * gets extra u8buf_size par */
-			maxlen = 64 * 1024;
-
 			if (is40)
 				mimo_ctlchbw =
 				    CHSPEC_SB_UPPER(WLC_BAND_PI_RADIO_CHANSPEC)
@@ -681,10 +678,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 				       AMPDU_MAX_MPDU_OVERHEAD;
 				plen = max(scb_ampdu->min_len, plen);
 
-				if ((plen + ampdu_len) > maxlen) {
+				if ((plen + ampdu_len) > max_ampdu_bytes) {
 					p = NULL;
-					wiphy_err(wiphy, "%s: Bogus plen #1\n",
-						__func__);
 					continue;
 				}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 547df75..c74c186 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -659,10 +659,13 @@ brcms_ops_ampdu_action(struct ieee80211_hw *hw,
 		/*
 		 * BA window size from ADDBA response ('buf_size') defines how
 		 * many outstanding MPDUs are allowed for the BA stream by
-		 * recipient and traffic class.
+		 * recipient and traffic class. 'ampdu_factor' gives maximum
+		 * AMPDU size.
 		 */
 		LOCK(wl);
-		brcms_c_ampdu_tx_operational(wl->wlc, tid, buf_size);
+		brcms_c_ampdu_tx_operational(wl->wlc, tid, buf_size,
+			(1 << (IEEE80211_HT_MAX_AMPDU_FACTOR +
+			 sta->ht_cap.ampdu_factor)) - 1);
 		UNLOCK(wl);
 		/* Power save wakeup */
 		break;
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 14c0d20..58ae61d 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -627,7 +627,7 @@ extern void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs);
 extern void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 			    struct ieee80211_sta *sta, u16 tid);
 extern void brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
-					 u8 ba_wsize);
+					 u8 ba_wsize, uint max_rx_ampdu_bytes);
 extern int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
 			   int val);
 extern int brcms_c_get_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index c2080e9..62e005e 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -40,7 +40,7 @@ struct scb_ampdu {
 	u8 max_pdu;		/* max pdus allowed in ampdu */
 	u8 release;		/* # of mpdus released at a time */
 	u16 min_len;		/* min mpdu len to support the density */
-	u32 max_rxlen;	/* max ampdu rcv length; 8k, 16k, 32k, 64k */
+	u32 max_rx_ampdu_bytes;	/* max ampdu rcv length; 8k, 16k, 32k, 64k */
 	struct pktq txq;	/* sdu transmit queue pending aggregation */
 
 	/* This could easily be a ini[] pointer and we keep this info in wl itself instead
-- 
1.7.1


