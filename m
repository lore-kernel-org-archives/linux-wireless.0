Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:64261 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbbG3Kyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 06:54:47 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH v3 13/19] wil6210: detailed statistics for Rx reorder drop
Date: Thu, 30 Jul 2015 13:52:01 +0300
Message-Id: <1438253527-3372-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150730_125450_606111_B64E2AF7)
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rx drops may be for 2 reasons: frame is old,
or it is duplicate. On the debugfs "stations" entry,
provide counters per reorder buffer for total
frames processed, drops for these 2 reasons.
Also add debug print for dropped frames.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  6 +++++-
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  8 ++++++--
 drivers/net/wireless/ath/wil6210/wil6210.h    | 15 ++++++++-------
 3 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 2651ec4..05b550f 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1344,6 +1344,7 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 {
 	int i;
 	u16 index = ((r->head_seq_num - r->ssn) & 0xfff) % r->buf_size;
+	unsigned long long drop_dup = r->drop_dup, drop_old = r->drop_old;
 
 	seq_printf(s, "([%2d] %3d TU) 0x%03x [", r->buf_size, r->timeout,
 		   r->head_seq_num);
@@ -1353,7 +1354,10 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 		else
 			seq_printf(s, "%c", r->reorder_buf[i] ? '*' : '_');
 	}
-	seq_printf(s, "] drop %llu last 0x%03x\n", r->drop, r->ssn_last_drop);
+	seq_printf(s,
+		   "] total %llu drop %llu (dup %llu + old %llu) last 0x%03x\n",
+		   r->total, drop_dup + drop_old, drop_dup, drop_old,
+		   r->ssn_last_drop);
 }
 
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index e4ac11c..9238c1a 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -121,6 +121,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 		goto out;
 	}
 
+	r->total++;
 	hseq = r->head_seq_num;
 
 	/** Due to the race between WMI events, where BACK establishment
@@ -153,7 +154,9 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	/* frame with out of date sequence number */
 	if (seq_less(seq, r->head_seq_num)) {
 		r->ssn_last_drop = seq;
-		r->drop++;
+		r->drop_old++;
+		wil_dbg_txrx(wil, "Rx drop: old seq 0x%03x head 0x%03x\n",
+			     seq, r->head_seq_num);
 		dev_kfree_skb(skb);
 		goto out;
 	}
@@ -174,7 +177,8 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 
 	/* check if we already stored this frame */
 	if (r->reorder_buf[index]) {
-		r->drop++;
+		r->drop_dup++;
+		wil_dbg_txrx(wil, "Rx drop: dup seq 0x%03x\n", seq);
 		dev_kfree_skb(skb);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 54f1673..c722724 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -424,13 +424,12 @@ struct pci_dev;
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @buf_size: buffer size for incoming A-MPDUs
  * @timeout: reset timer value (in TUs).
+ * @ssn_last_drop: SSN of the last dropped frame
+ * @total: total number of processed incoming frames
+ * @drop_dup: duplicate frames dropped for this reorder buffer
+ * @drop_old: old frames dropped for this reorder buffer
  * @dialog_token: dialog token for aggregation session
- * @rcu_head: RCU head used for freeing this struct
- * @drop: total frames dropped for this reorder buffer
- *
- * This structure's lifetime is managed by RCU, assignments to
- * the array holding it must hold the aggregation mutex.
- *
+ * @first_time: true when this buffer used 1-st time
  */
 struct wil_tid_ampdu_rx {
 	struct sk_buff **reorder_buf;
@@ -444,7 +443,9 @@ struct wil_tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u16 ssn_last_drop;
-	unsigned long long drop;
+	unsigned long long total; /* frames processed */
+	unsigned long long drop_dup;
+	unsigned long long drop_old;
 	u8 dialog_token;
 	bool first_time; /* is it 1-st time this buffer used? */
 };
-- 
2.1.4

