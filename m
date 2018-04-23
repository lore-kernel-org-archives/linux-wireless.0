Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:12141 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754456AbeDWIwZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Apr 2018 04:52:25 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 09/10] wil6210: remove unused rx_reorder members
Date: Mon, 23 Apr 2018 11:52:12 +0300
Message-Id: <1524473533-24524-10-git-send-email-merez@codeaurora.org> (sfid-20180423_105355_641940_AA0CF721)
In-Reply-To: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
References: <1524473533-24524-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Remove unused members from struct wil_tid_ampdu_rx

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c    |  3 +--
 drivers/net/wireless/ath/wil6210/rx_reorder.c |  7 +------
 drivers/net/wireless/ath/wil6210/wil6210.h    | 10 ----------
 3 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 49d9808..aff819b 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1379,8 +1379,7 @@ static void wil_print_rxtid(struct seq_file *s, struct wil_tid_ampdu_rx *r)
 	u16 index = ((r->head_seq_num - r->ssn) & 0xfff) % r->buf_size;
 	unsigned long long drop_dup = r->drop_dup, drop_old = r->drop_old;
 
-	seq_printf(s, "([%2d] %3d TU) 0x%03x [", r->buf_size, r->timeout,
-		   r->head_seq_num);
+	seq_printf(s, "([%2d]) 0x%03x [", r->buf_size, r->head_seq_num);
 	for (i = 0; i < r->buf_size; i++) {
 		if (i == index)
 			seq_printf(s, "%c", r->reorder_buf[i] ? 'O' : '|');
diff --git a/drivers/net/wireless/ath/wil6210/rx_reorder.c b/drivers/net/wireless/ath/wil6210/rx_reorder.c
index 14dcb06..76f8084 100644
--- a/drivers/net/wireless/ath/wil6210/rx_reorder.c
+++ b/drivers/net/wireless/ath/wil6210/rx_reorder.c
@@ -206,7 +206,6 @@ void wil_rx_reorder(struct wil6210_priv *wil, struct sk_buff *skb)
 
 	/* put the frame in the reordering buffer */
 	r->reorder_buf[index] = skb;
-	r->reorder_time[index] = jiffies;
 	r->stored_mpdu_num++;
 	wil_reorder_release(ndev, r);
 
@@ -252,11 +251,8 @@ struct wil_tid_ampdu_rx *wil_tid_ampdu_rx_alloc(struct wil6210_priv *wil,
 
 	r->reorder_buf =
 		kcalloc(size, sizeof(struct sk_buff *), GFP_KERNEL);
-	r->reorder_time =
-		kcalloc(size, sizeof(unsigned long), GFP_KERNEL);
-	if (!r->reorder_buf || !r->reorder_time) {
+	if (!r->reorder_buf) {
 		kfree(r->reorder_buf);
-		kfree(r->reorder_time);
 		kfree(r);
 		return NULL;
 	}
@@ -286,7 +282,6 @@ void wil_tid_ampdu_rx_free(struct wil6210_priv *wil,
 		kfree_skb(r->reorder_buf[i]);
 
 	kfree(r->reorder_buf);
-	kfree(r->reorder_time);
 	kfree(r);
 }
 
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 2f77319..fe58169 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -493,38 +493,28 @@ enum { /* for wil6210_priv.status */
  * struct tid_ampdu_rx - TID aggregation information (Rx).
  *
  * @reorder_buf: buffer to reorder incoming aggregated MPDUs
- * @reorder_time: jiffies when skb was added
- * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
- * @reorder_timer: releases expired frames from the reorder buffer.
  * @last_rx: jiffies of last rx activity
  * @head_seq_num: head sequence number in reordering buffer.
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
  * @buf_size: buffer size for incoming A-MPDUs
- * @timeout: reset timer value (in TUs).
  * @ssn_last_drop: SSN of the last dropped frame
  * @total: total number of processed incoming frames
  * @drop_dup: duplicate frames dropped for this reorder buffer
  * @drop_old: old frames dropped for this reorder buffer
- * @dialog_token: dialog token for aggregation session
  * @first_time: true when this buffer used 1-st time
  */
 struct wil_tid_ampdu_rx {
 	struct sk_buff **reorder_buf;
-	unsigned long *reorder_time;
-	struct timer_list session_timer;
-	struct timer_list reorder_timer;
 	unsigned long last_rx;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
 	u16 buf_size;
-	u16 timeout;
 	u16 ssn_last_drop;
 	unsigned long long total; /* frames processed */
 	unsigned long long drop_dup;
 	unsigned long long drop_old;
-	u8 dialog_token;
 	bool first_time; /* is it 1-st time this buffer used? */
 };
 
-- 
1.9.1
