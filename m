Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sg2plsmtpa01-01.prod.sin2.secureserver.net ([182.50.145.6]:35041
	"EHLO sg2plsmtpa01-01.prod.sin2.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484Ab2KUMn6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Nov 2012 07:43:58 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/6] ath9k: Fix the 'xmit' debugfs file
Date: Wed, 21 Nov 2012 18:13:11 +0530
Message-Id: <1353501795-10378-2-git-send-email-sujith@msujith.org> (sfid-20121121_134405_713599_71BE2D46)
In-Reply-To: <1353501795-10378-1-git-send-email-sujith@msujith.org>
References: <1353501795-10378-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The 'xmit' debugfs file has become big and unwieldy, fix
multiple issues with its usage:

* Store TX counters/statistics only for the 4 Access Categories.
  Use IEEE80211_NUM_ACS instead of ATH9K_NUM_TX_QUEUES.

* Move various utility macros to debug.h, they can be reused
  elsewhere.

* Remove tx_complete_poll_work_seen.

* Remove code that accesses various internal queue-specific
  variables without any locking whatsoever. HW/SW queue details
  will be handled in a subsequent patch.

* Do not print internal values like txq_headidx and txq_headidx.
  They were mostly unused anyway, considering code like:
  PRX("txq_tailidx:     ", txq_headidx);

* Handle 'txprocdesc' for EDMA too.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   1 -
 drivers/net/wireless/ath/ath9k/debug.c | 104 ++-------------------------------
 drivers/net/wireless/ath/ath9k/debug.h |  17 +++++-
 drivers/net/wireless/ath/ath9k/link.c  |   3 -
 drivers/net/wireless/ath/ath9k/main.c  |   1 -
 drivers/net/wireless/ath/ath9k/xmit.c  |   2 +
 6 files changed, 23 insertions(+), 105 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 1bb7fca..30dc9e2 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -724,7 +724,6 @@ struct ath_softc {
 	struct ath9k_debug debug;
 	spinlock_t nodes_lock;
 	struct list_head nodes; /* basically, stations */
-	unsigned int tx_complete_poll_work_seen;
 #endif
 	struct ath_beacon_config cur_beacon_conf;
 	struct delayed_work tx_complete_work;
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 0b488f8..d9edff8 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -512,62 +512,19 @@ static const struct file_operations fops_interrupt = {
 	.llseek = default_llseek,
 };
 
-#define PR_QNUM(_n) sc->tx.txq_map[_n]->axq_qnum
-#define PR(str, elem)							\
-	do {								\
-		len += snprintf(buf + len, size - len,			\
-				"%s%13u%11u%10u%10u\n", str,		\
-		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].elem, \
-		sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].elem); \
-		if (len >= size)			  \
-			goto done;			  \
-} while(0)
-
-#define PRX(str, elem)							\
-do {									\
-	len += snprintf(buf + len, size - len,				\
-			"%s%13u%11u%10u%10u\n", str,			\
-			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_BE]->elem),	\
-			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_BK]->elem),	\
-			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_VI]->elem),	\
-			(unsigned int)(sc->tx.txq_map[IEEE80211_AC_VO]->elem));	\
-	if (len >= size)						\
-		goto done;						\
-} while(0)
-
-#define PRQLE(str, elem)						\
-do {									\
-	len += snprintf(buf + len, size - len,				\
-			"%s%13i%11i%10i%10i\n", str,			\
-			list_empty(&sc->tx.txq_map[IEEE80211_AC_BE]->elem),	\
-			list_empty(&sc->tx.txq_map[IEEE80211_AC_BK]->elem),	\
-			list_empty(&sc->tx.txq_map[IEEE80211_AC_VI]->elem),	\
-			list_empty(&sc->tx.txq_map[IEEE80211_AC_VO]->elem));	\
-	if (len >= size)						\
-		goto done;						\
-} while (0)
-
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 8000;
-	int i;
+	unsigned int len = 0, size = 2048;
 	ssize_t retval = 0;
-	char tmp[32];
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
 		return -ENOMEM;
 
-	len += sprintf(buf, "Num-Tx-Queues: %i  tx-queues-setup: 0x%x"
-		       " poll-work-seen: %u\n"
-		       "%30s %10s%10s%10s\n\n",
-		       ATH9K_NUM_TX_QUEUES, sc->tx.txqsetup,
-		       sc->tx_complete_poll_work_seen,
+	len += sprintf(buf, "%30s %10s%10s%10s\n\n",
 		       "BE", "BK", "VI", "VO");
 
 	PR("MPDUs Queued:    ", queued);
@@ -587,62 +544,11 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("DELIM Underrun:  ", delim_underrun);
 	PR("TX-Pkts-All:     ", tx_pkts_all);
 	PR("TX-Bytes-All:    ", tx_bytes_all);
-	PR("hw-put-tx-buf:   ", puttxbuf);
-	PR("hw-tx-start:     ", txstart);
-	PR("hw-tx-proc-desc: ", txprocdesc);
+	PR("HW-put-tx-buf:   ", puttxbuf);
+	PR("HW-tx-start:     ", txstart);
+	PR("HW-tx-proc-desc: ", txprocdesc);
 	PR("TX-Failed:       ", txfailed);
-	len += snprintf(buf + len, size - len,
-			"%s%11p%11p%10p%10p\n", "txq-memory-address:",
-			sc->tx.txq_map[IEEE80211_AC_BE],
-			sc->tx.txq_map[IEEE80211_AC_BK],
-			sc->tx.txq_map[IEEE80211_AC_VI],
-			sc->tx.txq_map[IEEE80211_AC_VO]);
-	if (len >= size)
-		goto done;
-
-	PRX("axq-qnum:        ", axq_qnum);
-	PRX("axq-depth:       ", axq_depth);
-	PRX("axq-ampdu_depth: ", axq_ampdu_depth);
-	PRX("axq-stopped      ", stopped);
-	PRX("tx-in-progress   ", axq_tx_inprogress);
-	PRX("pending-frames   ", pending_frames);
-	PRX("txq_headidx:     ", txq_headidx);
-	PRX("txq_tailidx:     ", txq_headidx);
-
-	PRQLE("axq_q empty:       ", axq_q);
-	PRQLE("axq_acq empty:     ", axq_acq);
-	for (i = 0; i < ATH_TXFIFO_DEPTH; i++) {
-		snprintf(tmp, sizeof(tmp) - 1, "txq_fifo[%i] empty: ", i);
-		PRQLE(tmp, txq_fifo[i]);
-	}
-
-	/* Print out more detailed queue-info */
-	for (i = 0; i <= IEEE80211_AC_BK; i++) {
-		struct ath_txq *txq = &(sc->tx.txq[i]);
-		struct ath_atx_ac *ac;
-		struct ath_atx_tid *tid;
-		if (len >= size)
-			goto done;
-		spin_lock_bh(&txq->axq_lock);
-		if (!list_empty(&txq->axq_acq)) {
-			ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac,
-					      list);
-			len += snprintf(buf + len, size - len,
-					"txq[%i] first-ac: %p sched: %i\n",
-					i, ac, ac->sched);
-			if (list_empty(&ac->tid_q) || (len >= size))
-				goto done_for;
-			tid = list_first_entry(&ac->tid_q, struct ath_atx_tid,
-					       list);
-			len += snprintf(buf + len, size - len,
-					" first-tid: %p sched: %i paused: %i\n",
-					tid, tid->sched, tid->paused);
-		}
-	done_for:
-		spin_unlock_bh(&txq->axq_lock);
-	}
 
-done:
 	if (len > size)
 		len = size;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 2ed9785..9fbd36c 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -178,6 +178,21 @@ struct ath_tx_stats {
 	u32 txfailed;
 };
 
+/*
+ * Various utility macros to print TX/Queue counters.
+ */
+#define PR_QNUM(_n) sc->tx.txq_map[_n]->axq_qnum
+#define TXSTATS sc->debug.stats.txstats
+#define PR(str, elem)							\
+	do {								\
+		len += snprintf(buf + len, size - len,			\
+				"%s%13u%11u%10u%10u\n", str,		\
+				TXSTATS[PR_QNUM(IEEE80211_AC_BE)].elem,	\
+				TXSTATS[PR_QNUM(IEEE80211_AC_BK)].elem,	\
+				TXSTATS[PR_QNUM(IEEE80211_AC_VI)].elem,	\
+				TXSTATS[PR_QNUM(IEEE80211_AC_VO)].elem); \
+	} while(0)
+
 #define RX_STAT_INC(c) (sc->debug.stats.rxstats.c++)
 
 /**
@@ -226,7 +241,7 @@ struct ath_rx_stats {
 
 struct ath_stats {
 	struct ath_interrupt_stats istats;
-	struct ath_tx_stats txstats[ATH9K_NUM_TX_QUEUES];
+	struct ath_tx_stats txstats[IEEE80211_NUM_ACS];
 	struct ath_rx_stats rxstats;
 	struct ath_dfs_stats dfs_stats;
 	u32 reset[__RESET_TYPE_MAX];
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 227fdb8..fc6b075 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -27,9 +27,6 @@ void ath_tx_complete_poll_work(struct work_struct *work)
 	struct ath_txq *txq;
 	int i;
 	bool needreset = false;
-#ifdef CONFIG_ATH9K_DEBUGFS
-	sc->tx_complete_poll_work_seen++;
-#endif
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
 		if (ATH_TXQ_SETUP(sc, i)) {
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4233913..7030567 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1956,7 +1956,6 @@ static int ath9k_get_et_sset_count(struct ieee80211_hw *hw,
 	return 0;
 }
 
-#define PR_QNUM(_n) (sc->tx.txq_map[_n]->axq_qnum)
 #define AWDATA(elem)							\
 	do {								\
 		data[i++] = sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].elem; \
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index ae7f289..3413094 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2319,6 +2319,8 @@ void ath_tx_edma_tasklet(struct ath_softc *sc)
 
 		ath_txq_lock(sc, txq);
 
+		TX_STAT_INC(txq->axq_qnum, txprocdesc);
+
 		if (list_empty(&txq->txq_fifo[txq->txq_tailidx])) {
 			ath_txq_unlock(sc, txq);
 			return;
-- 
1.8.0

