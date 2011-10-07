Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56509 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759188Ab1JGA21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 20:28:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/4] ath9k: improve PS filter clearing and retry counting for A-MPDU
Date: Fri,  7 Oct 2011 02:28:14 +0200
Message-Id: <1317947295-52172-3-git-send-email-nbd@openwrt.org> (sfid-20111007_022831_559251_EAB7F1D8)
In-Reply-To: <1317947295-52172-2-git-send-email-nbd@openwrt.org>
References: <1317947295-52172-1-git-send-email-nbd@openwrt.org>
 <1317947295-52172-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do not increment the retry counter if packets to a sleeping station
were not sent because of tx failure, instead of only checking the filter
flag.
Clear the PS filter only after an A-MPDU was reported as filtered,
otherwise the hardware might do some unnecessary extra retransmissions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/xmit.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 37d70b2..c34bd92 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -373,7 +373,6 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_frame_info *fi;
 	int nframes;
 	u8 tidno;
-	bool clear_filter;
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -463,11 +462,9 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 */
 				txfail = 1;
 			} else if (fi->retries < ATH_MAX_SW_RETRIES) {
-				if (!(ts->ts_status & ATH9K_TXERR_FILT) ||
-				    !an->sleeping)
+				if (txok || !an->sleeping)
 					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
 
-				clear_filter = true;
 				txpending = 1;
 			} else {
 				txfail = 1;
@@ -545,11 +542,13 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 			ieee80211_sta_set_buffered(sta, tid->tidno, true);
 
 		spin_lock_bh(&txq->axq_lock);
-		if (clear_filter)
-			tid->ac->clear_ps_filter = true;
 		skb_queue_splice(&bf_pending, &tid->buf_q);
-		if (!an->sleeping)
+		if (!an->sleeping) {
 			ath_tx_queue_tid(txq, tid);
+
+			if (ts->ts_status & ATH9K_TXERR_FILT)
+				tid->ac->clear_ps_filter = true;
+		}
 		spin_unlock_bh(&txq->axq_lock);
 	}
 
-- 
1.7.3.2

