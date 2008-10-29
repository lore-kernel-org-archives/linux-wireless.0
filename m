Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:57634 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbYJ2Euz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:50:55 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:50:55 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.60174.383882.826913@gargle.gargle.HOWL> (sfid-20081029_060858_123843_881BE5F7)
Date: Wed, 29 Oct 2008 10:18:14 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 13/16] ath9k: Remove ath_tx_aggr_resp()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Accessing mac80211's internal state machine is wrong.
Will add resumption of a TID in a later patch.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |   11 +-----
 drivers/net/wireless/ath9k/rc.c   |   66 ++-----------------------------------
 drivers/net/wireless/ath9k/xmit.c |   13 ++-----
 3 files changed, 8 insertions(+), 82 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 49d2f89..dd33cb7 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -588,14 +588,6 @@ enum ATH_AGGR_STATUS {
 	ATH_AGGR_8K_LIMITED,
 };
 
-enum ATH_AGGR_CHECK {
-	AGGR_NOT_REQUIRED,
-	AGGR_REQUIRED,
-	AGGR_CLEANUP_PROGRESS,
-	AGGR_EXCHANGE_PROGRESS,
-	AGGR_EXCHANGE_DONE
-};
-
 struct aggr_rifs_param {
 	int param_max_frames;
 	int param_max_len;
@@ -621,8 +613,7 @@ struct ath_node {
 
 void ath_tx_resume_tid(struct ath_softc *sc,
 	struct ath_atx_tid *tid);
-enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
-	struct ath_node *an, u8 tidno);
+bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno);
 void ath_tx_aggr_teardown(struct ath_softc *sc,
 	struct ath_node *an, u8 tidno);
 void ath_rx_aggr_teardown(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index ad29270..aa6bfd7 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1879,49 +1879,6 @@ static void ath_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	tx_info->control.vif = NULL;
 }
 
-static void ath_tx_aggr_resp(struct ath_softc *sc,
-			     struct ieee80211_supported_band *sband,
-			     struct ieee80211_sta *sta,
-			     struct ath_node *an,
-			     u8 tidno)
-{
-	struct ath_atx_tid *txtid;
-	u16 buffersize = 0;
-	int state;
-	struct sta_info *si;
-
-	if (!(sc->sc_flags & SC_OP_TXAGGR))
-		return;
-
-	txtid = ATH_AN_2_TID(an, tidno);
-	if (!txtid->paused)
-		return;
-
-	/*
-	 * XXX: This is entirely busted, we aren't supposed to
-	 *	access the sta from here because it's internal
-	 *	to mac80211, and looking at the state without
-	 *	locking is wrong too.
-	 */
-	si = container_of(sta, struct sta_info, sta);
-	buffersize = IEEE80211_MIN_AMPDU_BUF <<
-		sband->ht_cap.ampdu_factor; /* FIXME */
-	state = si->ampdu_mlme.tid_state_tx[tidno];
-
-	if (state & HT_ADDBA_RECEIVED_MSK) {
-		txtid->state |= AGGR_ADDBA_COMPLETE;
-		txtid->state &= ~AGGR_ADDBA_PROGRESS;
-		txtid->baw_size = buffersize;
-
-		DPRINTF(sc, ATH_DBG_AGGR,
-			"%s: Resuming tid, buffersize: %d\n",
-			__func__,
-			buffersize);
-
-		ath_tx_resume_tid(sc, txtid);
-	}
-}
-
 static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 			 struct ieee80211_tx_rate_control *txrc)
 {
@@ -1934,11 +1891,10 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 	struct ath_rate_node *ath_rc_priv = priv_sta;
 	struct ath_node *an;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
-	int is_probe = FALSE, chk, ret;
+	int is_probe = FALSE;
 	s8 lowest_idx;
 	__le16 fc = hdr->frame_control;
 	u8 *qc, tid;
-	DECLARE_MAC_BUF(mac);
 
 	DPRINTF(sc, ATH_DBG_RATE, "%s\n", __func__);
 
@@ -1982,26 +1938,10 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		if (ieee80211_is_data_qos(fc)) {
 			qc = ieee80211_get_qos_ctl(hdr);
 			tid = qc[0] & 0xf;
-
 			an = (struct ath_node *)sta->drv_priv;
 
-			chk = ath_tx_aggr_check(sc, an, tid);
-			if (chk == AGGR_REQUIRED) {
-				ret = ieee80211_start_tx_ba_session(hw,
-					hdr->addr1, tid);
-				if (ret)
-					DPRINTF(sc, ATH_DBG_AGGR,
-						"%s: Unable to start tx "
-						"aggr for: %s\n",
-						__func__,
-						print_mac(mac, hdr->addr1));
-				else
-					DPRINTF(sc, ATH_DBG_AGGR,
-						"%s: Started tx aggr for: %s\n",
-						__func__,
-						print_mac(mac, hdr->addr1));
-			} else if (chk == AGGR_EXCHANGE_PROGRESS)
-				ath_tx_aggr_resp(sc, sband, sta, an, tid);
+			if(ath_tx_aggr_check(sc, an, tid))
+				ieee80211_start_tx_ba_session(hw, hdr->addr1, tid);
 		}
 	}
 }
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 2d9fd10..7e6f4e5 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2322,29 +2322,24 @@ u32 ath_txq_aggr_depth(struct ath_softc *sc, int qnum)
 	return sc->sc_txq[qnum].axq_aggr_depth;
 }
 
-/* Check if an ADDBA is required. A valid node must be passed. */
-enum ATH_AGGR_CHECK ath_tx_aggr_check(struct ath_softc *sc,
-				      struct ath_node *an,
-				      u8 tidno)
+bool ath_tx_aggr_check(struct ath_softc *sc, struct ath_node *an, u8 tidno)
 {
 	struct ath_atx_tid *txtid;
-	DECLARE_MAC_BUF(mac);
 
 	if (!(sc->sc_flags & SC_OP_TXAGGR))
-		return AGGR_NOT_REQUIRED;
+		return false;
 
-	/* ADDBA exchange must be completed before sending aggregates */
 	txtid = ATH_AN_2_TID(an, tidno);
 
 	if (!(txtid->state & AGGR_ADDBA_COMPLETE)) {
 		if (!(txtid->state & AGGR_ADDBA_PROGRESS) &&
 		    (txtid->addba_exchangeattempts < ADDBA_EXCHANGE_ATTEMPTS)) {
 			txtid->addba_exchangeattempts++;
-			return AGGR_REQUIRED;
+			return true;
 		}
 	}
 
-	return AGGR_NOT_REQUIRED;
+	return false;
 }
 
 /* Start TX aggregation */
-- 
1.6.0.3

