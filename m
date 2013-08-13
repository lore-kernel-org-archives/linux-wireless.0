Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:65255 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab3HMF7p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:59:45 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 2/4] ath10k: fix HTC endpoint worker starvation
Date: Tue, 13 Aug 2013 07:59:36 +0200
Message-ID: <1376373578-2180-3-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075952_476784_5A03248C)
In-Reply-To: <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
References: <1375949813-10969-1-git-send-email-michal.kazior@tieto.com>
 <1376373578-2180-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HTC used a worker for each endpoint. This worked
until a slow host machine was flooded with massive
number of TX requests. HTT related worker would
remain active while WMI worker was starved. This
ended up with "could not send beacon" in AP mode.
It was even possible to see userspace being
starved.

The patch switches from using workers to using
tasklets for processing and submitting HTC frames
to HIF.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
v2:
 * fix indentation

 drivers/net/wireless/ath/ath10k/htc.c |   17 +++++++++--------
 drivers/net/wireless/ath/ath10k/htc.h |    3 ++-
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 7d445d3..958e048 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -15,6 +15,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/interrupt.h>
 #include "core.h"
 #include "hif.h"
 #include "debug.h"
@@ -210,10 +211,9 @@ static struct sk_buff *ath10k_htc_get_skb_credit_based(struct ath10k_htc *htc,
 	return skb;
 }
 
-static void ath10k_htc_send_work(struct work_struct *work)
+static void ath10k_htc_send_task(unsigned long ptr)
 {
-	struct ath10k_htc_ep *ep = container_of(work,
-					struct ath10k_htc_ep, send_work);
+	struct ath10k_htc_ep *ep = (struct ath10k_htc_ep *)ptr;
 	struct ath10k_htc *htc = ep->htc;
 	struct sk_buff *skb;
 	u8 credits = 0;
@@ -264,7 +264,7 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 	skb_push(skb, sizeof(struct ath10k_htc_hdr));
 	spin_unlock_bh(&htc->tx_lock);
 
-	queue_work(htc->ar->workqueue, &ep->send_work);
+	tasklet_schedule(&ep->send_task);
 	return 0;
 }
 
@@ -283,7 +283,7 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 	 * we recheck after the packet completes */
 	spin_lock_bh(&htc->tx_lock);
 	if (!ep->tx_credit_flow_enabled && !htc->stopped)
-		queue_work(ar->workqueue, &ep->send_work);
+		tasklet_schedule(&ep->send_task);
 	spin_unlock_bh(&htc->tx_lock);
 
 	return 0;
@@ -308,7 +308,7 @@ static void ath10k_htc_flush_endpoint_tx(struct ath10k_htc *htc,
 	}
 	spin_unlock_bh(&htc->tx_lock);
 
-	cancel_work_sync(&ep->send_work);
+	tasklet_kill(&ep->send_task);
 }
 
 /***********/
@@ -341,7 +341,7 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 		ep->tx_credits += report->credits;
 
 		if (ep->tx_credits && !skb_queue_empty(&ep->tx_queue))
-			queue_work(htc->ar->workqueue, &ep->send_work);
+			tasklet_schedule(&ep->send_task);
 	}
 	spin_unlock_bh(&htc->tx_lock);
 }
@@ -602,7 +602,8 @@ static void ath10k_htc_reset_endpoint_states(struct ath10k_htc *htc)
 		skb_queue_head_init(&ep->tx_queue);
 		ep->htc = htc;
 		ep->tx_credit_flow_enabled = true;
-		INIT_WORK(&ep->send_work, ath10k_htc_send_work);
+		tasklet_init(&ep->send_task, ath10k_htc_send_task,
+			     (unsigned long)ep);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index e1dd8c7..6afa175 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -24,6 +24,7 @@
 #include <linux/skbuff.h>
 #include <linux/semaphore.h>
 #include <linux/timer.h>
+#include <linux/interrupt.h>
 
 struct ath10k;
 
@@ -323,7 +324,7 @@ struct ath10k_htc_ep {
 	int tx_credits_per_max_message;
 	bool tx_credit_flow_enabled;
 
-	struct work_struct send_work;
+	struct tasklet_struct send_task;
 };
 
 struct ath10k_htc_svc_tx_credits {
-- 
1.7.9.5

