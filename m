Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6134 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbbGEIqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Jul 2015 04:46:05 -0400
From: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
To: Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 04/13] wil6210: count drops in Rx block ack reorder
Date: Sun,  5 Jul 2015 10:24:31 +0300
Message-Id: <1436081080-27305-5-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20150705_104621_146543_A416DB39)
In-Reply-To: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1436081080-27305-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When performing Rx reordering, count skb's dropped
per reorder buffer; and print dropped packets count
on the "stations" debugfs entry

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    | 2 +-
 drivers/net/wireless/ath/wil6210/rx_reorder.c | 2 ++
 drivers/net/wireless/ath/wil6210/wil6210.h    | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 42bc6e6..9ed1a94 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1353,7 +1353,7 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 		else
 			seq_printf(s, "%c", r->reorder_buf[i] ? '*' : '_');
 	}
-	seq_printf(s, "] last drop 0x%03x\n", r->ssn_last_drop);
+	seq_printf(s, "] drop %llu last 0x%03x\n", r->drop, r->ssn_last_drop);
 }
 
 static int wil_sta_debugfs_show(struct seq_file *s, void *data)
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index ca10dcf..e4ac11c 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -153,6 +153,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 	/* frame with out of date sequence number */
 	if (seq_less(seq, r->head_seq_num)) {
 		r->ssn_last_drop = seq;
+		r->drop++;
 		dev_kfree_skb(skb);
 		goto out;
 	}
@@ -173,6 +174,7 @@ __acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
 
 	/* check if we already stored this frame */
 	if (r->reorder_buf[index]) {
+		r->drop++;
 		dev_kfree_skb(skb);
 		goto out;
 	}
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 4b7135e..284edda 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -427,6 +427,7 @@ struct pci_dev;
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
+ * @drop: total frames dropped for this reorder buffer
  *
  * This structure's lifetime is managed by RCU, assignments to
  * the array holding it must hold the aggregation mutex.
@@ -444,6 +445,7 @@ struct wil_tid_ampdu_rx {
 	u16 buf_size;
 	u16 timeout;
 	u16 ssn_last_drop;
+	unsigned long long drop;
 	u8 dialog_token;
 	bool first_time; /* is it 1-st time this buffer used? */
 };
-- 
2.1.4

