Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49810 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXU3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:29:31 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k: fix tx queue index confusion in debugfs code
Date: Mon, 24 Jan 2011 21:29:25 +0100
Message-Id: <1295900965-24893-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Various places printing tx queue information used various different ways to
get a tx queue index for printing statistics. Most of these ways were wrong.

ATH_TXQ_AC_* cannot be used as an index for sc->tx.txq, because it is only
used internally for queue assignment.

One place used WME_AC_* as a queue index for sc->debug.stats.txstats, however
this array uses the ath9k_hw queue number as well.

Fix all of this by always using the ath9k_hw queue number as an index, and
always looking it up by going through sc->tx.txq_map.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   37 ++++++++++++++++---------------
 drivers/net/wireless/ath/ath9k/debug.h |    2 +-
 drivers/net/wireless/ath/ath9k/xmit.c  |    2 +-
 3 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index f517c0c..9cdc41b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -450,14 +450,15 @@ static const struct file_operations fops_wiphy = {
 	.llseek = default_llseek,
 };
 
+#define PR_QNUM(_n) sc->tx.txq_map[_n]->axq_qnum
 #define PR(str, elem)							\
 	do {								\
 		len += snprintf(buf + len, size - len,			\
 				"%s%13u%11u%10u%10u\n", str,		\
-		sc->debug.stats.txstats[WME_AC_BE].elem, \
-		sc->debug.stats.txstats[WME_AC_BK].elem, \
-		sc->debug.stats.txstats[WME_AC_VI].elem, \
-		sc->debug.stats.txstats[WME_AC_VO].elem); \
+		sc->debug.stats.txstats[PR_QNUM(WME_AC_BE)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(WME_AC_BK)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(WME_AC_VI)].elem, \
+		sc->debug.stats.txstats[PR_QNUM(WME_AC_VO)].elem); \
 		if (len >= size)			  \
 			goto done;			  \
 } while(0)
@@ -466,10 +467,10 @@ static const struct file_operations fops_wiphy = {
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13u%11u%10u%10u\n", str,			\
-			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_BE].elem),	\
-			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_BK].elem),	\
-			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_VI].elem),	\
-			(unsigned int)(sc->tx.txq[ATH_TXQ_AC_VO].elem));	\
+			(unsigned int)(sc->tx.txq_map[WME_AC_BE]->elem),	\
+			(unsigned int)(sc->tx.txq_map[WME_AC_BK]->elem),	\
+			(unsigned int)(sc->tx.txq_map[WME_AC_VI]->elem),	\
+			(unsigned int)(sc->tx.txq_map[WME_AC_VO]->elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while(0)
@@ -478,10 +479,10 @@ do {									\
 do {									\
 	len += snprintf(buf + len, size - len,				\
 			"%s%13i%11i%10i%10i\n", str,			\
-			list_empty(&sc->tx.txq[ATH_TXQ_AC_BE].elem),	\
-			list_empty(&sc->tx.txq[ATH_TXQ_AC_BK].elem),	\
-			list_empty(&sc->tx.txq[ATH_TXQ_AC_VI].elem),	\
-			list_empty(&sc->tx.txq[ATH_TXQ_AC_VO].elem));	\
+			list_empty(&sc->tx.txq_map[WME_AC_BE]->elem),	\
+			list_empty(&sc->tx.txq_map[WME_AC_BK]->elem),	\
+			list_empty(&sc->tx.txq_map[WME_AC_VI]->elem),	\
+			list_empty(&sc->tx.txq_map[WME_AC_VO]->elem));	\
 	if (len >= size)						\
 		goto done;						\
 } while (0)
@@ -528,10 +529,10 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("hw-tx-proc-desc: ", txprocdesc);
 	len += snprintf(buf + len, size - len,
 			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
-			&(sc->tx.txq[ATH_TXQ_AC_BE]),
-			&(sc->tx.txq[ATH_TXQ_AC_BK]),
-			&(sc->tx.txq[ATH_TXQ_AC_VI]),
-			&(sc->tx.txq[ATH_TXQ_AC_VO]));
+			&(sc->tx.txq_map[WME_AC_BE]),
+			&(sc->tx.txq_map[WME_AC_BK]),
+			&(sc->tx.txq_map[WME_AC_VI]),
+			&(sc->tx.txq_map[WME_AC_VO]));
 	if (len >= size)
 		goto done;
 
@@ -751,9 +752,9 @@ static ssize_t read_file_misc(struct file *file, char __user *user_buf,
 }
 
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
-		       struct ath_tx_status *ts)
+		       struct ath_tx_status *ts, struct ath_txq *txq)
 {
-	int qnum = skb_get_queue_mapping(bf->bf_mpdu);
+	int qnum = txq->axq_qnum;
 
 	TX_STAT_INC(qnum, tx_pkts_all);
 	sc->debug.stats.txstats[qnum].tx_bytes_all += bf->bf_mpdu->len;
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 980c9fa..1bdc6d4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -175,7 +175,7 @@ int ath9k_init_debug(struct ath_hw *ah);
 
 void ath_debug_stat_interrupt(struct ath_softc *sc, enum ath9k_int status);
 void ath_debug_stat_tx(struct ath_softc *sc, struct ath_buf *bf,
-		       struct ath_tx_status *ts);
+		       struct ath_tx_status *ts, struct ath_txq *txq);
 void ath_debug_stat_rx(struct ath_softc *sc, struct ath_rx_status *rs);
 
 #else
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 1afbd22..85c3d0a 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1913,7 +1913,7 @@ static void ath_tx_complete_buf(struct ath_softc *sc, struct ath_buf *bf,
 		else
 			complete(&sc->paprd_complete);
 	} else {
-		ath_debug_stat_tx(sc, bf, ts);
+		ath_debug_stat_tx(sc, bf, ts, txq);
 		ath_tx_complete(sc, skb, tx_flags,
 				bf->bf_state.bfs_ftype, txq);
 	}
-- 
1.7.3.2

