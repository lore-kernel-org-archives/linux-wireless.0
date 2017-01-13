Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36650 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751353AbdAMV0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:26:53 -0500
Received: by mail-lf0-f65.google.com with SMTP id h65so7028121lfi.3
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jan 2017 13:26:52 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v3 4/8] ath10k: htc: refactorization
Date: Fri, 13 Jan 2017 22:26:07 +0100
Message-Id: <1484342771-6160-5-git-send-email-erik.stromdahl@gmail.com> (sfid-20170113_222702_839285_FDE6D5B3)
In-Reply-To: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com>
References: <1484342771-6160-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
---
 drivers/net/wireless/ath/ath10k/htc.c | 73 ++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index f39eef6..eb036b3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -459,42 +459,6 @@ void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
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
@@ -509,9 +473,40 @@ EXPORT_SYMBOL(ath10k_htc_rx_completion_handler);
 static void ath10k_htc_control_rx_complete(struct ath10k *ar,
 					   struct sk_buff *skb)
 {
-	/* This is unexpected. FW is not supposed to send regular rx on this
-	 * endpoint. */
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
 
-- 
2.7.4
