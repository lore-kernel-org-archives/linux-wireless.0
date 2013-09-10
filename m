Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:42868 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3IJNuM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 09:50:12 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/7] ath10k: make WMI commands block by design
Date: Tue, 10 Sep 2013 15:49:59 +0200
Message-ID: <1378821003-22925-4-git-send-email-michal.kazior@tieto.com> (sfid-20130910_155029_811822_3B323D1D)
In-Reply-To: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will be necessary for further changes in
command submission scheme.

Once HTC is cleaned up WMI commands will finally
block.

This requires for SWBA to be processed in a
non-atomic context for now. Once other necessary
changes are in this will be reverted.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h  |    1 +
 drivers/net/wireless/ath/ath10k/trace.h |   11 ++++---
 drivers/net/wireless/ath/ath10k/wmi.c   |   54 +++++++++++++++++++------------
 3 files changed, 42 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 22b17d6..c953a33 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -114,6 +114,7 @@ struct ath10k_wmi {
 	struct completion unified_ready;
 	atomic_t pending_tx_count;
 	wait_queue_head_t wq;
+	wait_queue_head_t tx_credits_wq;
 
 	struct sk_buff_head wmi_event_list;
 	struct work_struct wmi_event_work;
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index bf1ceb8..fd53130 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -111,26 +111,29 @@ TRACE_EVENT(ath10k_log_dbg_dump,
 );
 
 TRACE_EVENT(ath10k_wmi_cmd,
-	TP_PROTO(int id, void *buf, size_t buf_len),
+	TP_PROTO(int id, void *buf, size_t buf_len, int ret),
 
-	TP_ARGS(id, buf, buf_len),
+	TP_ARGS(id, buf, buf_len, ret),
 
 	TP_STRUCT__entry(
 		__field(unsigned int, id)
 		__field(size_t, buf_len)
 		__dynamic_array(u8, buf, buf_len)
+		__field(int ret)
 	),
 
 	TP_fast_assign(
 		__entry->id = id;
 		__entry->buf_len = buf_len;
+		__entry->ret = ret;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
 
 	TP_printk(
-		"id %d len %zu",
+		"id %d len %zu ret %d",
 		__entry->id,
-		__entry->buf_len
+		__entry->buf_len,
+		__entry->ret
 	)
 );
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 32fd5e7..66cd892 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -90,13 +90,12 @@ static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 		wake_up(&ar->wmi.wq);
 }
 
-/* WMI command API */
-static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
-			       enum wmi_cmd_id cmd_id)
+static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
+				      enum wmi_cmd_id cmd_id)
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct wmi_cmd_hdr *cmd_hdr;
-	int status;
+	int ret;
 	u32 cmd = 0;
 
 	if (skb_push(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
@@ -107,26 +106,40 @@ static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
 	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
 
-	if (atomic_add_return(1, &ar->wmi.pending_tx_count) >
-	    WMI_MAX_PENDING_TX_COUNT) {
-		/* avoid using up memory when FW hangs */
-		dev_kfree_skb(skb);
-		atomic_dec(&ar->wmi.pending_tx_count);
-		return -EBUSY;
-	}
-
 	memset(skb_cb, 0, sizeof(*skb_cb));
+	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
+	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len, ret);
 
-	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len);
+	if (ret)
+		goto err_pull;
 
-	status = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
-	if (status) {
+	return 0;
+
+err_pull:
+	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
+	return ret;
+}
+
+static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar,
+					enum ath10k_htc_ep_id eid)
+{
+	wake_up(&ar->wmi.tx_credits_wq);
+}
+
+static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
+			       enum wmi_cmd_id cmd_id)
+{
+	int ret = -EINVAL;
+
+	wait_event_timeout(ar->wmi.tx_credits_wq, ({
+		ret = ath10k_wmi_cmd_send_nowait(ar, skb, cmd_id);
+		(ret != -EAGAIN);
+	}), 3*HZ);
+
+	if (ret)
 		dev_kfree_skb_any(skb);
-		atomic_dec(&ar->wmi.pending_tx_count);
-		return status;
-	}
 
-	return 0;
+	return ret;
 }
 
 static int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
@@ -1168,7 +1181,6 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	/* some events require to be handled ASAP
 	 * thus can't be defered to a worker thread */
 	switch (event_id) {
-	case WMI_HOST_SWBA_EVENTID:
 	case WMI_MGMT_RX_EVENTID:
 		ath10k_wmi_event_process(ar, skb);
 		return;
@@ -1186,6 +1198,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	init_completion(&ar->wmi.service_ready);
 	init_completion(&ar->wmi.unified_ready);
 	init_waitqueue_head(&ar->wmi.wq);
+	init_waitqueue_head(&ar->wmi.tx_credits_wq);
 
 	skb_queue_head_init(&ar->wmi.wmi_event_list);
 	INIT_WORK(&ar->wmi.wmi_event_work, ath10k_wmi_event_work);
@@ -1215,6 +1228,7 @@ int ath10k_wmi_connect_htc_service(struct ath10k *ar)
 	/* these fields are the same for all service endpoints */
 	conn_req.ep_ops.ep_tx_complete = ath10k_wmi_htc_tx_complete;
 	conn_req.ep_ops.ep_rx_complete = ath10k_wmi_process_rx;
+	conn_req.ep_ops.ep_tx_credits = ath10k_wmi_op_ep_tx_credits;
 
 	/* connect to control service */
 	conn_req.service_id = ATH10K_HTC_SVC_ID_WMI_CONTROL;
-- 
1.7.9.5

