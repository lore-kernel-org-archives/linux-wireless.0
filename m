Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:45365 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYJ2Era (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 00:47:30 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 21:47:30 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18695.59972.967807.657751@gargle.gargle.HOWL> (sfid-20081029_054732_478358_D011EF3B)
Date: Wed, 29 Oct 2008 10:14:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 04/16] ath9k: Remove SM Power Save as it is not supported now
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    7 -----
 drivers/net/wireless/ath9k/xmit.c |   45 +++++--------------------------------
 2 files changed, 6 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 21b572b..27ed084 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -415,12 +415,6 @@ int ath_rx_subframe(struct ath_node *an, struct sk_buff *skb,
 #define WME_AC_VO               3 /* voice */
 #define WME_NUM_AC              4
 
-enum ATH_SM_PWRSAV{
-	ATH_SM_ENABLE,
-	ATH_SM_PWRSAV_STATIC,
-	ATH_SM_PWRSAV_DYNAMIC,
-};
-
 /*
  * Data transmit queue state.  One of these exists for each
  * hardware transmit queue.  Packets sent to us from above
@@ -619,7 +613,6 @@ struct ath_node {
 	struct ath_softc *an_sc;
 	struct ath_chainmask_sel an_chainmask_sel;
 	struct ath_node_aggr an_aggr;
-	u8 an_smmode; /* SM Power save mode */
 	u16 maxampdu;
 	u8 mpdudensity;
 };
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index defd699..b3ba47d 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -575,7 +575,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct ath_desc *ds = bf->bf_desc;
 	struct ath_desc *lastds = bf->bf_lastbf->bf_desc;
 	struct ath9k_11n_rate_series series[4];
-	int i, flags, rtsctsena = 0, dynamic_mimops = 0;
+	int i, flags, rtsctsena = 0;
 	u32 ctsduration = 0;
 	u8 rix = 0, cix, ctsrate = 0;
 	u32 aggr_limit_with_rts = ah->ah_caps.rts_aggr_limit;
@@ -631,18 +631,6 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		 */
 		if (!rtsctsena)
 			flags = ATH9K_TXDESC_RTSENA;
-		/*
-		 * For dynamic MIMO PS, RTS needs to precede the first aggregate
-		 * and the second aggregate should have any protection at all.
-		 */
-		if (an && an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) {
-			if (!bf_isaggrburst(bf)) {
-				flags = ATH9K_TXDESC_RTSENA;
-				dynamic_mimops = 1;
-			} else {
-				flags = 0;
-			}
-		}
 	}
 
 	/*
@@ -707,33 +695,14 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 			(bf->bf_rcs[i].flags & ATH_RC_SGI_FLAG),
 			bf_isshpreamble(bf));
 
-		if (an && (an->an_smmode == ATH_SM_PWRSAV_STATIC) &&
-		    (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG) == 0) {
-			/*
-			 * When sending to an HT node that has enabled static
-			 * SM/MIMO power save, send at single stream rates but
-			 * use maximum allowed transmit chains per user,
-			 * hardware, regulatory, or country limits for
-			 * better range.
-			 */
+		if (bf_isht(bf))
+			series[i].ChSel =
+				ath_chainmask_sel_logic(sc, an);
+		else
 			series[i].ChSel = sc->sc_tx_chainmask;
-		} else {
-			if (bf_isht(bf))
-				series[i].ChSel =
-					ath_chainmask_sel_logic(sc, an);
-			else
-				series[i].ChSel = sc->sc_tx_chainmask;
-		}
 
 		if (rtsctsena)
 			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
-
-		/*
-		 * Set RTS for all rates if node is in dynamic powersave
-		 * mode and we are using dual stream rates.
-		 */
-		if (dynamic_mimops && (bf->bf_rcs[i].flags & ATH_RC_DS_FLAG))
-			series[i].RateFlags |= ATH9K_RATESERIES_RTS_CTS;
 	}
 
 	/*
@@ -2521,10 +2490,8 @@ void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq)
 		if (tid->paused)    /* check next tid to keep h/w busy */
 			continue;
 
-		if (!(tid->an->an_smmode == ATH_SM_PWRSAV_DYNAMIC) ||
-		    ((txq->axq_depth % 2) == 0)) {
+		if ((txq->axq_depth % 2) == 0)
 			ath_tx_sched_aggr(sc, txq, tid);
-		}
 
 		/*
 		 * add tid to round-robin queue if more frames
-- 
1.6.0.3

