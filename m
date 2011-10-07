Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56513 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759377Ab1JGA21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 20:28:27 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: fix retry counting / BAR handling during queue flush
Date: Fri,  7 Oct 2011 02:28:15 +0200
Message-Id: <1317947295-52172-4-git-send-email-nbd@openwrt.org> (sfid-20111007_022834_518146_9489DFC0)
In-Reply-To: <1317947295-52172-3-git-send-email-nbd@openwrt.org>
References: <1317947295-52172-1-git-send-email-nbd@openwrt.org>
 <1317947295-52172-2-git-send-email-nbd@openwrt.org>
 <1317947295-52172-3-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When tx is suspended temporarily and the queue is flushed, do not increase
the retry count or attempt to send out BAR frames. Instead simply retry
the affected subframes normally after the reset.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/mac.h  |    3 ++-
 drivers/net/wireless/ath/ath9k/xmit.c |    7 ++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index 91c9654..5eb4ee4 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -75,9 +75,10 @@
 #define ATH9K_TXERR_XTXOP          0x08
 #define ATH9K_TXERR_TIMER_EXPIRED  0x10
 #define ATH9K_TX_ACKED		   0x20
+#define ATH9K_TX_FLUSH		   0x40
 #define ATH9K_TXERR_MASK						\
 	(ATH9K_TXERR_XRETRY | ATH9K_TXERR_FILT | ATH9K_TXERR_FIFO |	\
-	 ATH9K_TXERR_XTXOP | ATH9K_TXERR_TIMER_EXPIRED)
+	 ATH9K_TXERR_XTXOP | ATH9K_TXERR_TIMER_EXPIRED | ATH9K_TX_FLUSH)
 
 #define ATH9K_TX_BA                0x01
 #define ATH9K_TX_PWRMGMT           0x02
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index c34bd92..44cfdfb 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -373,6 +373,7 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_frame_info *fi;
 	int nframes;
 	u8 tidno;
+	bool flush = !!(ts->ts_status & ATH9K_TX_FLUSH);
 
 	skb = bf->bf_mpdu;
 	hdr = (struct ieee80211_hdr *)skb->data;
@@ -461,6 +462,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 				 * the un-acked sub-frames
 				 */
 				txfail = 1;
+			} else if (flush) {
+				txpending = 1;
 			} else if (fi->retries < ATH_MAX_SW_RETRIES) {
 				if (txok || !an->sleeping)
 					ath_tx_set_retry(sc, txq, bf->bf_mpdu);
@@ -518,7 +521,8 @@ static void ath_tx_complete_aggr(struct ath_softc *sc, struct ath_txq *txq,
 
 						ath_tx_complete_buf(sc, bf, txq,
 								    &bf_head,
-								    ts, 0, 1);
+								    ts, 0,
+								    !flush);
 						break;
 					}
 
@@ -1408,6 +1412,7 @@ static void ath_drain_txq_list(struct ath_softc *sc, struct ath_txq *txq,
 	struct ath_tx_status ts;
 
 	memset(&ts, 0, sizeof(ts));
+	ts.ts_status = ATH9K_TX_FLUSH;
 	INIT_LIST_HEAD(&bf_head);
 
 	while (!list_empty(list)) {
-- 
1.7.3.2

