Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:54848 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab3IMMRJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 08:17:09 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCHv2 4/7] ath10k: simplify HTC command submitting
Date: Fri, 13 Sep 2013 14:16:55 +0200
Message-ID: <1379074618-30534-5-git-send-email-michal.kazior@tieto.com> (sfid-20130913_141724_194386_CB087048)
In-Reply-To: <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
 <1379074618-30534-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch removes HTC endpoint tx workers in
favour of direct command submission. This makes a
lot more sense for data path.

mac80211 queues are effectively stopped/woken up
in a more timely fashion preventing build up of
frames. It's possible to push more traffic than
the device/system is able to handle and have no
hiccups or performance degradation with UDP
traffic.

WMI commands will now report errors properly and
possibly block as they actively can wait for tx
credits to become available.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * use DIV_ROUND_UP

 drivers/net/wireless/ath/ath10k/htc.c |  176 ++++++++-------------------------
 drivers/net/wireless/ath/ath10k/htc.h |    4 -
 drivers/net/wireless/ath/ath10k/wmi.c |    3 +-
 3 files changed, 43 insertions(+), 140 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 49da4e5..d0d7212 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -117,99 +117,13 @@ static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 	spin_unlock_bh(&ep->htc->tx_lock);
 }
 
-static int ath10k_htc_issue_skb(struct ath10k_htc *htc,
-				struct ath10k_htc_ep *ep,
-				struct sk_buff *skb,
-				u8 credits)
-{
-	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
-	int ret;
-
-	ath10k_dbg(ATH10K_DBG_HTC, "%s: ep %d skb %p\n", __func__,
-		   ep->eid, skb);
-
-	ath10k_htc_prepare_tx_skb(ep, skb);
-
-	ret = ath10k_skb_map(htc->ar->dev, skb);
-	if (ret)
-		goto err;
-
-	ret = ath10k_hif_send_head(htc->ar,
-				   ep->ul_pipe_id,
-				   ep->eid,
-				   skb->len,
-				   skb);
-	if (unlikely(ret))
-		goto err;
-
-	return 0;
-err:
-	ath10k_warn("HTC issue failed: %d\n", ret);
-
-	spin_lock_bh(&htc->tx_lock);
-	ep->tx_credits += credits;
-	spin_unlock_bh(&htc->tx_lock);
-
-	if (ep->ep_ops.ep_tx_credits)
-		ep->ep_ops.ep_tx_credits(htc->ar);
-
-	/* this is the simplest way to handle out-of-resources for non-credit
-	 * based endpoints. credit based endpoints can still get -ENOSR, but
-	 * this is highly unlikely as credit reservation should prevent that */
-	if (ret == -ENOSR) {
-		spin_lock_bh(&htc->tx_lock);
-		__skb_queue_head(&ep->tx_queue, skb);
-		spin_unlock_bh(&htc->tx_lock);
-
-		return ret;
-	}
-
-	skb_cb->is_aborted = true;
-	ath10k_htc_notify_tx_completion(ep, skb);
-
-	return ret;
-}
-
-static void ath10k_htc_send_work(struct work_struct *work)
-{
-	struct ath10k_htc_ep *ep = container_of(work,
-					struct ath10k_htc_ep, send_work);
-	struct ath10k_htc *htc = ep->htc;
-	struct sk_buff *skb;
-	u8 credits = 0;
-	int ret;
-
-	while (true) {
-		if (ep->ul_is_polled)
-			ath10k_htc_send_complete_check(ep, 0);
-
-		spin_lock_bh(&htc->tx_lock);
-		skb = __skb_dequeue(&ep->tx_queue);
-
-		if (ep->tx_credit_flow_enabled) {
-			credits = DIV_ROUND_UP(skb->len,
-					       htc->target_credit_size);
-			if (ep->tx_credits < credits) {
-				__skb_queue_head(&ep->tx_queue, skb);
-				skb = NULL;
-			}
-		}
-		spin_unlock_bh(&htc->tx_lock);
-
-		if (!skb)
-			break;
-
-		ret = ath10k_htc_issue_skb(htc, ep, skb, credits);
-		if (ret == -ENOSR)
-			break;
-	}
-}
-
 int ath10k_htc_send(struct ath10k_htc *htc,
 		    enum ath10k_htc_ep_id eid,
 		    struct sk_buff *skb)
 {
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
+	int credits = 0;
+	int ret;
 
 	if (htc->ar->state == ATH10K_STATE_WEDGED)
 		return -ECOMM;
@@ -219,18 +133,55 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		return -ENOENT;
 	}
 
+	/* FIXME: This looks ugly, can we fix it? */
 	spin_lock_bh(&htc->tx_lock);
 	if (htc->stopped) {
 		spin_unlock_bh(&htc->tx_lock);
 		return -ESHUTDOWN;
 	}
+	spin_unlock_bh(&htc->tx_lock);
 
-	__skb_queue_tail(&ep->tx_queue, skb);
 	skb_push(skb, sizeof(struct ath10k_htc_hdr));
-	spin_unlock_bh(&htc->tx_lock);
 
-	queue_work(htc->ar->workqueue, &ep->send_work);
+	if (ep->tx_credit_flow_enabled) {
+		credits = DIV_ROUND_UP(skb->len, htc->target_credit_size);
+		spin_lock_bh(&htc->tx_lock);
+		if (ep->tx_credits < credits) {
+			spin_unlock_bh(&htc->tx_lock);
+			ret = -EAGAIN;
+			goto err_pull;
+		}
+		ep->tx_credits -= credits;
+		spin_unlock_bh(&htc->tx_lock);
+	}
+
+	ath10k_htc_prepare_tx_skb(ep, skb);
+
+	ret = ath10k_skb_map(htc->ar->dev, skb);
+	if (ret)
+		goto err_credits;
+
+	ret = ath10k_hif_send_head(htc->ar, ep->ul_pipe_id, ep->eid,
+				   skb->len, skb);
+	if (ret)
+		goto err_unmap;
+
 	return 0;
+
+err_unmap:
+	ath10k_skb_unmap(htc->ar->dev, skb);
+err_credits:
+	if (ep->tx_credit_flow_enabled) {
+		spin_lock_bh(&htc->tx_lock);
+		ep->tx_credits += credits;
+		spin_unlock_bh(&htc->tx_lock);
+
+		if (ep->ep_ops.ep_tx_credits)
+			ep->ep_ops.ep_tx_credits(htc->ar);
+	}
+err_pull:
+	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
+	return ret;
 }
 
 static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
@@ -243,39 +194,9 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
 
-	/* note: when using TX credit flow, the re-checking of queues happens
-	 * when credits flow back from the target.  in the non-TX credit case,
-	 * we recheck after the packet completes */
-	spin_lock_bh(&htc->tx_lock);
-	if (!ep->tx_credit_flow_enabled && !htc->stopped)
-		queue_work(ar->workqueue, &ep->send_work);
-	spin_unlock_bh(&htc->tx_lock);
-
 	return 0;
 }
 
-/* flush endpoint TX queue */
-static void ath10k_htc_flush_endpoint_tx(struct ath10k_htc *htc,
-					 struct ath10k_htc_ep *ep)
-{
-	struct sk_buff *skb;
-	struct ath10k_skb_cb *skb_cb;
-
-	spin_lock_bh(&htc->tx_lock);
-	for (;;) {
-		skb = __skb_dequeue(&ep->tx_queue);
-		if (!skb)
-			break;
-
-		skb_cb = ATH10K_SKB_CB(skb);
-		skb_cb->is_aborted = true;
-		ath10k_htc_notify_tx_completion(ep, skb);
-	}
-	spin_unlock_bh(&htc->tx_lock);
-
-	cancel_work_sync(&ep->send_work);
-}
-
 /***********/
 /* Receive */
 /***********/
@@ -310,9 +231,6 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 			ep->ep_ops.ep_tx_credits(htc->ar);
 			spin_lock_bh(&htc->tx_lock);
 		}
-
-		if (ep->tx_credits && !skb_queue_empty(&ep->tx_queue))
-			queue_work(htc->ar->workqueue, &ep->send_work);
 	}
 	spin_unlock_bh(&htc->tx_lock);
 }
@@ -570,10 +488,8 @@ static void ath10k_htc_reset_endpoint_states(struct ath10k_htc *htc)
 		ep->max_ep_message_len = 0;
 		ep->max_tx_queue_depth = 0;
 		ep->eid = i;
-		skb_queue_head_init(&ep->tx_queue);
 		ep->htc = htc;
 		ep->tx_credit_flow_enabled = true;
-		INIT_WORK(&ep->send_work, ath10k_htc_send_work);
 	}
 }
 
@@ -916,18 +832,10 @@ int ath10k_htc_start(struct ath10k_htc *htc)
  */
 void ath10k_htc_stop(struct ath10k_htc *htc)
 {
-	int i;
-	struct ath10k_htc_ep *ep;
-
 	spin_lock_bh(&htc->tx_lock);
 	htc->stopped = true;
 	spin_unlock_bh(&htc->tx_lock);
 
-	for (i = ATH10K_HTC_EP_0; i < ATH10K_HTC_EP_COUNT; i++) {
-		ep = &htc->endpoint[i];
-		ath10k_htc_flush_endpoint_tx(htc, ep);
-	}
-
 	ath10k_hif_stop(htc->ar);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 92ca29b..4716d33 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -316,15 +316,11 @@ struct ath10k_htc_ep {
 	int ul_is_polled; /* call HIF to get tx completions */
 	int dl_is_polled; /* call HIF to fetch rx (not implemented) */
 
-	struct sk_buff_head tx_queue;
-
 	u8 seq_no; /* for debugging */
 	int tx_credits;
 	int tx_credit_size;
 	int tx_credits_per_max_message;
 	bool tx_credit_flow_enabled;
-
-	struct work_struct send_work;
 };
 
 struct ath10k_htc_svc_tx_credits {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 66cd892..ff407c2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -120,8 +120,7 @@ err_pull:
 	return ret;
 }
 
-static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar,
-					enum ath10k_htc_ep_id eid)
+static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 {
 	wake_up(&ar->wmi.tx_credits_wq);
 }
-- 
1.7.9.5

