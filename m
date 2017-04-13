Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37825 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754640AbdDMI3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:29:48 -0400
Subject: [PATCH v7 04/10] ath10k: htc: refactorization
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 13 Apr 2017 11:29:37 +0300
Message-ID: <149207217697.4590.8343909021938155204.stgit@potku.adurom.net> (sfid-20170413_102952_182202_12A04094)
In-Reply-To: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
References: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Code refactorization:

Moved the code for ep 0 in ath10k_htc_rx_completion_handler
to ath10k_htc_control_rx_complete.

This eases the implementation of SDIO/mbox significantly since
the ep_rx_complete cb is invoked directly from the SDIO/mbox
hif layer.

Since the ath10k_htc_control_rx_complete already is present
(only containing a warning message) there is no reason for not
using it (instead of having a special case for ep 0 in
ath10k_htc_rx_completion_handler).

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   74 +++++++++++++++------------------
 1 file changed, 34 insertions(+), 40 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 04e355207a2d..15b805629336 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -464,42 +464,6 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 		/* zero length packet with trailer data, just drop these */
 		goto out;
 
-	if (eid == ATH10K_HTC_EP_0) {
-		struct ath10k_htc_msg *msg = (struct ath10k_htc_msg *)skb->data;
-
-		switch (__le16_to_cpu(msg->hdr.message_id)) {
-		case ATH10K_HTC_MSG_READY_ID:
-		case ATH10K_HTC_MSG_CONNECT_SERVICE_RESP_ID:
-			/* handle HTC control message */
-			if (completion_done(&htc->ctl_resp)) {
-				/*
-				 * this is a fatal error, target should not be
-				 * sending unsolicited messages on the ep 0
-				 */
-				ath10k_warn(ar, "HTC rx ctrl still processing\n");
-				complete(&htc->ctl_resp);
-				goto out;
-			}
-
-			htc->control_resp_len =
-				min_t(int, skb->len,
-				      ATH10K_HTC_MAX_CTRL_MSG_LEN);
-
-			memcpy(htc->control_resp_buffer, skb->data,
-			       htc->control_resp_len);
-
-			complete(&htc->ctl_resp);
-			break;
-		case ATH10K_HTC_MSG_SEND_SUSPEND_COMPLETE:
-			htc->htc_ops.target_send_suspend_complete(ar);
-			break;
-		default:
-			ath10k_warn(ar, "ignoring unsolicited htc ep0 event\n");
-			break;
-		}
-		goto out;
-	}
-
 	ath10k_dbg(ar, ATH10K_DBG_HTC, "htc rx completion ep %d skb %pK\n",
 		   eid, skb);
 	ep->ep_ops.ep_rx_complete(ar, skb);
@@ -514,10 +478,40 @@ EXPORT_SYMBOL(ath10k_htc_rx_completion_handler);
 static void ath10k_htc_control_rx_complete(struct ath10k *ar,
 					   struct sk_buff *skb)
 {
-	/* This is unexpected. FW is not supposed to send regular rx on this
-	 * endpoint.
-	 */
-	ath10k_warn(ar, "unexpected htc rx\n");
+	struct ath10k_htc *htc = &ar->htc;
+	struct ath10k_htc_msg *msg = (struct ath10k_htc_msg *)skb->data;
+
+	switch (__le16_to_cpu(msg->hdr.message_id)) {
+	case ATH10K_HTC_MSG_READY_ID:
+	case ATH10K_HTC_MSG_CONNECT_SERVICE_RESP_ID:
+		/* handle HTC control message */
+		if (completion_done(&htc->ctl_resp)) {
+			/* this is a fatal error, target should not be
+			 * sending unsolicited messages on the ep 0
+			 */
+			ath10k_warn(ar, "HTC rx ctrl still processing\n");
+			complete(&htc->ctl_resp);
+			goto out;
+		}
+
+		htc->control_resp_len =
+			min_t(int, skb->len,
+			      ATH10K_HTC_MAX_CTRL_MSG_LEN);
+
+		memcpy(htc->control_resp_buffer, skb->data,
+		       htc->control_resp_len);
+
+		complete(&htc->ctl_resp);
+		break;
+	case ATH10K_HTC_MSG_SEND_SUSPEND_COMPLETE:
+		htc->htc_ops.target_send_suspend_complete(ar);
+		break;
+	default:
+		ath10k_warn(ar, "ignoring unsolicited htc ep0 event\n");
+		break;
+	}
+
+out:
 	kfree_skb(skb);
 }
 
