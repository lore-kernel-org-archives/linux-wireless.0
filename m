Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58495 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1AJHMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:12:33 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 03/11] ath9k:  Add more information to debugfs xmit file.
Date: Sun,  9 Jan 2011 23:11:45 -0800
Message-Id: <1294643513-18820-4-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Should help debug strange tx lockup type issues.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 5075faa... 577bc5a... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 1e5078b... cd2db3f... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 180170d... 99ce6f1... M	drivers/net/wireless/ath/ath9k/mac.c
:100644 100644 332d1fe... c769037... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/debug.c |   29 +++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/debug.h |    6 ++++++
 drivers/net/wireless/ath/ath9k/mac.c   |    8 ++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  |    1 +
 4 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 5075faa..577bc5a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -599,13 +599,25 @@ do {									\
 			(unsigned int)(sc->tx.txq[WME_AC_VO].elem));	\
 } while(0)
 
+#define PRQLE(str, elem)						\
+do {									\
+	len += snprintf(buf + len, size - len,				\
+			"%s%13i%11i%10i%10i\n", str,			\
+			list_empty(&sc->tx.txq[WME_AC_BE].elem),	\
+			list_empty(&sc->tx.txq[WME_AC_BK].elem),	\
+			list_empty(&sc->tx.txq[WME_AC_VI].elem),	\
+			list_empty(&sc->tx.txq[WME_AC_VO].elem));	\
+} while (0)
+
 static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 			      size_t count, loff_t *ppos)
 {
 	struct ath_softc *sc = file->private_data;
 	char *buf;
-	unsigned int len = 0, size = 2048;
+	unsigned int len = 0, size = 4000;
+	int i;
 	ssize_t retval = 0;
+	char tmp[32];
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
@@ -628,13 +640,26 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("DELIM Underrun:  ", delim_underrun);
 	PR("TX-Pkts-All:     ", tx_pkts_all);
 	PR("TX-Bytes-All:    ", tx_bytes_all);
+	PR("hw-put-tx-buf:   ", puttxbuf);
+	PR("hw-tx-start:     ", txstart);
+	PR("hw-tx-proc-desc: ", txprocdesc);
 
 	PRX("axq-qnum:        ", axq_qnum);
 	PRX("axq-depth:       ", axq_depth);
+	PRX("axq-ampdu_depth: ", axq_ampdu_depth);
 	PRX("axq-stopped      ", stopped);
 	PRX("tx-in-progress   ", axq_tx_inprogress);
 	PRX("pending-frames   ", pending_frames);
-
+	PRX("txq_headidx:     ", txq_headidx);
+	PRX("txq_tailidx:     ", txq_headidx);
+
+	PRQLE("axq_q empty:       ", axq_q);
+	PRQLE("axq_acq empty:     ", axq_acq);
+	PRQLE("txq_fifo_pending:  ", txq_fifo_pending);
+	for (i = 0; i < ATH_TXFIFO_DEPTH; i++) {
+		snprintf(tmp, sizeof(tmp) - 1, "txq_fifo[%i] empty: ", i);
+		PRQLE(tmp, txq_fifo[i]);
+	}
 	if (len > size)
 		len = size;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index 1e5078b..cd2db3f 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -102,6 +102,9 @@ struct ath_interrupt_stats {
  * @desc_cfg_err: Descriptor configuration errors
  * @data_urn: TX data underrun errors
  * @delim_urn: TX delimiter underrun errors
+ * @puttxbuf: Number of times hardware was given txbuf to write.
+ * @txstart:  Number of times hardware was told to start tx.
+ * @txprocdesc:  Number of times tx descriptor was processed
  */
 struct ath_tx_stats {
 	u32 tx_pkts_all;
@@ -119,6 +122,9 @@ struct ath_tx_stats {
 	u32 desc_cfg_err;
 	u32 data_underrun;
 	u32 delim_underrun;
+	u32 puttxbuf;
+	u32 txstart;
+	u32 txprocdesc;
 };
 
 /**
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index 180170d..99ce6f1 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -16,6 +16,8 @@
 
 #include "hw.h"
 #include "hw-ops.h"
+#include "debug.h"
+#include "ath9k.h"
 
 static void ath9k_hw_set_txq_interrupts(struct ath_hw *ah,
 					struct ath9k_tx_queue_info *qi)
@@ -50,12 +52,18 @@ EXPORT_SYMBOL(ath9k_hw_gettxbuf);
 
 void ath9k_hw_puttxbuf(struct ath_hw *ah, u32 q, u32 txdp)
 {
+	struct ath_wiphy *aphy = ah->hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	TX_STAT_INC(q, puttxbuf);
 	REG_WRITE(ah, AR_QTXDP(q), txdp);
 }
 EXPORT_SYMBOL(ath9k_hw_puttxbuf);
 
 void ath9k_hw_txstart(struct ath_hw *ah, u32 q)
 {
+	struct ath_wiphy *aphy = ah->hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	TX_STAT_INC(q, txstart);
 	ath_dbg(ath9k_hw_common(ah), ATH_DBG_QUEUE,
 		"Enable TXE on queue: %u\n", q);
 	REG_WRITE(ah, AR_Q_TXE, 1 << q);
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 332d1fe..c769037 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2033,6 +2033,7 @@ static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)
 			spin_unlock_bh(&txq->axq_lock);
 			break;
 		}
+		TX_STAT_INC(txq->axq_qnum, txprocdesc);
 
 		/*
 		 * Remove ath_buf's of the same transmit unit from txq,
-- 
1.7.2.3

