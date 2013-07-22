Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:48547 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067Ab3GVMNr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 08:13:47 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/4] ath10k: prevent HTC from being used after stopping
Date: Mon, 22 Jul 2013 14:13:28 +0200
Message-ID: <1374495211-20353-2-git-send-email-michal.kazior@tieto.com> (sfid-20130722_141353_265940_D9FFC4FD)
In-Reply-To: <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
 <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to submit new HTC commands
after/while HTC stopped. This led to memory
corruption in some rare cases.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   27 +++++++++++++--------------
 drivers/net/wireless/ath/ath10k/htc.h |    4 ++--
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 72e072c..47b7752 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -254,10 +254,14 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		return -ENOENT;
 	}
 
-	skb_push(skb, sizeof(struct ath10k_htc_hdr));
-
 	spin_lock_bh(&htc->tx_lock);
+	if (htc->stopped) {
+		spin_unlock_bh(&htc->tx_lock);
+		return -ESHUTDOWN;
+	}
+
 	__skb_queue_tail(&ep->tx_queue, skb);
+	skb_push(skb, sizeof(struct ath10k_htc_hdr));
 	spin_unlock_bh(&htc->tx_lock);
 
 	queue_work(htc->ar->workqueue, &ep->send_work);
@@ -270,23 +274,17 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 {
 	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_htc_ep *ep = &htc->endpoint[eid];
-	bool stopping;
 
 	ath10k_htc_notify_tx_completion(ep, skb);
 	/* the skb now belongs to the completion handler */
 
+	/* note: when using TX credit flow, the re-checking of queues happens
+	 * when credits flow back from the target.  in the non-TX credit case,
+	 * we recheck after the packet completes */
 	spin_lock_bh(&htc->tx_lock);
-	stopping = htc->stopping;
-	spin_unlock_bh(&htc->tx_lock);
-
-	if (!ep->tx_credit_flow_enabled && !stopping)
-		/*
-		 * note: when using TX credit flow, the re-checking of
-		 * queues happens when credits flow back from the target.
-		 * in the non-TX credit case, we recheck after the packet
-		 * completes
-		 */
+	if (!ep->tx_credit_flow_enabled && !htc->stopped)
 		queue_work(ar->workqueue, &ep->send_work);
+	spin_unlock_bh(&htc->tx_lock);
 
 	return 0;
 }
@@ -951,7 +949,7 @@ void ath10k_htc_stop(struct ath10k_htc *htc)
 	struct ath10k_htc_ep *ep;
 
 	spin_lock_bh(&htc->tx_lock);
-	htc->stopping = true;
+	htc->stopped = true;
 	spin_unlock_bh(&htc->tx_lock);
 
 	for (i = ATH10K_HTC_EP_0; i < ATH10K_HTC_EP_COUNT; i++) {
@@ -972,6 +970,7 @@ int ath10k_htc_init(struct ath10k *ar)
 
 	spin_lock_init(&htc->tx_lock);
 
+	htc->stopped = false;
 	ath10k_htc_reset_endpoint_states(htc);
 
 	/* setup HIF layer callbacks */
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 1606c9f..e1dd8c7 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -335,7 +335,7 @@ struct ath10k_htc {
 	struct ath10k *ar;
 	struct ath10k_htc_ep endpoint[ATH10K_HTC_EP_COUNT];
 
-	/* protects endpoint and stopping fields */
+	/* protects endpoint and stopped fields */
 	spinlock_t tx_lock;
 
 	struct ath10k_htc_ops htc_ops;
@@ -349,7 +349,7 @@ struct ath10k_htc {
 	struct ath10k_htc_svc_tx_credits service_tx_alloc[ATH10K_HTC_EP_COUNT];
 	int target_credit_size;
 
-	bool stopping;
+	bool stopped;
 };
 
 int ath10k_htc_init(struct ath10k *ar);
-- 
1.7.9.5

