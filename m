Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33948 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab1AJHNo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 02:13:44 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH RESEND 06/11] ath9k:  Add counters to distinquish AMPDU enqueues.
Date: Sun,  9 Jan 2011 23:11:48 -0800
Message-Id: <1294643513-18820-7-git-send-email-greearb@candelatech.com>
In-Reply-To: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
References: <1294643513-18820-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Show counters for pkts sent directly to hardware and
those queued in software.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 577bc5a... faf84e4... M	drivers/net/wireless/ath/ath9k/debug.c
:100644 100644 cd2db3f... 980c9fa... M	drivers/net/wireless/ath/ath9k/debug.h
:100644 100644 2248e47... 3aae523... M	drivers/net/wireless/ath/ath9k/xmit.c
 drivers/net/wireless/ath/ath9k/debug.c |    3 ++-
 drivers/net/wireless/ath/ath9k/debug.h |    6 ++++--
 drivers/net/wireless/ath/ath9k/xmit.c  |    3 ++-
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 577bc5a..faf84e4 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -628,7 +628,8 @@ static ssize_t read_file_xmit(struct file *file, char __user *user_buf,
 	PR("MPDUs Queued:    ", queued);
 	PR("MPDUs Completed: ", completed);
 	PR("Aggregates:      ", a_aggr);
-	PR("AMPDUs Queued:   ", a_queued);
+	PR("AMPDUs Queued HW:", a_queued_hw);
+	PR("AMPDUs Queued SW:", a_queued_sw);
 	PR("AMPDUs Completed:", a_completed);
 	PR("AMPDUs Retried:  ", a_retries);
 	PR("AMPDUs XRetried: ", a_xretries);
diff --git a/drivers/net/wireless/ath/ath9k/debug.h b/drivers/net/wireless/ath/ath9k/debug.h
index cd2db3f..980c9fa 100644
--- a/drivers/net/wireless/ath/ath9k/debug.h
+++ b/drivers/net/wireless/ath/ath9k/debug.h
@@ -89,7 +89,8 @@ struct ath_interrupt_stats {
  * @queued: Total MPDUs (non-aggr) queued
  * @completed: Total MPDUs (non-aggr) completed
  * @a_aggr: Total no. of aggregates queued
- * @a_queued: Total AMPDUs queued
+ * @a_queued_hw: Total AMPDUs queued to hardware
+ * @a_queued_sw: Total AMPDUs queued to software queues
  * @a_completed: Total AMPDUs completed
  * @a_retries: No. of AMPDUs retried (SW)
  * @a_xretries: No. of AMPDUs dropped due to xretries
@@ -112,7 +113,8 @@ struct ath_tx_stats {
 	u32 queued;
 	u32 completed;
 	u32 a_aggr;
-	u32 a_queued;
+	u32 a_queued_hw;
+	u32 a_queued_sw;
 	u32 a_completed;
 	u32 a_retries;
 	u32 a_xretries;
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 2248e47..3aae523 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1335,7 +1335,6 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 	struct list_head bf_head;
 
 	bf->bf_state.bf_type |= BUF_AMPDU;
-	TX_STAT_INC(txctl->txq->axq_qnum, a_queued);
 
 	/*
 	 * Do not queue to h/w when any of the following conditions is true:
@@ -1351,6 +1350,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		 * Add this frame to software queue for scheduling later
 		 * for aggregation.
 		 */
+		TX_STAT_INC(txctl->txq->axq_qnum, a_queued_sw);
 		list_add_tail(&bf->list, &tid->buf_q);
 		ath_tx_queue_tid(txctl->txq, tid);
 		return;
@@ -1364,6 +1364,7 @@ static void ath_tx_send_ampdu(struct ath_softc *sc, struct ath_atx_tid *tid,
 		ath_tx_addto_baw(sc, tid, fi->seqno);
 
 	/* Queue to h/w without aggregation */
+	TX_STAT_INC(txctl->txq->axq_qnum, a_queued_hw);
 	bf->bf_lastbf = bf;
 	ath_buf_set_rate(sc, bf, fi->framelen);
 	ath_tx_txqaddbuf(sc, txctl->txq, &bf_head);
-- 
1.7.2.3

