Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12734 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab2HMNtD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 09:49:03 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/2] ath6kl: Fix potential memory leak in ath6kl_tx_complete()
Date: Mon, 13 Aug 2012 19:18:58 +0530
Message-ID: <1344865738-2416-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120813_154923_296722_DD9285E1)
In-Reply-To: <1344865738-2416-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1344865738-2416-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We bail out from ath6kl_tx_complete() if any of the sanity
checks on skb and ath6kl_cookie fails. By doing this we
potentially leak few remaining buffers in packet_queue.
Make sure to proceed processing the remaining buffers
as well. This issue is found during code review.

Reported-by: Wang yufeng <yufengw@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index aab8251..4b26ba0 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -698,21 +698,29 @@ void ath6kl_tx_complete(struct htc_target *target,
 		list_del(&packet->list);
 
 		ath6kl_cookie = (struct ath6kl_cookie *)packet->pkt_cntxt;
-		if (!ath6kl_cookie)
-			goto fatal;
+		if (!ath6kl_cookie) {
+			WARN_ON(1);
+			continue;
+		}
 
 		status = packet->status;
 		skb = ath6kl_cookie->skb;
 		eid = packet->endpoint;
 		map_no = ath6kl_cookie->map_no;
 
-		if (!skb || !skb->data)
-			goto fatal;
+		if (!skb || !skb->data) {
+			WARN_ON(1);
+			dev_kfree_skb(skb);
+			ath6kl_free_cookie(ar, ath6kl_cookie);
+			continue;
+		}
 
 		__skb_queue_tail(&skb_queue, skb);
 
-		if (!status && (packet->act_len != skb->len))
-			goto fatal;
+		if (!status && (packet->act_len != skb->len)) {
+			ath6kl_free_cookie(ar, ath6kl_cookie);
+			continue;
+		}
 
 		ar->tx_pending[eid]--;
 
@@ -794,11 +802,6 @@ void ath6kl_tx_complete(struct htc_target *target,
 		wake_up(&ar->event_wq);
 
 	return;
-
-fatal:
-	WARN_ON(1);
-	spin_unlock_bh(&ar->lock);
-	return;
 }
 
 void ath6kl_tx_data_cleanup(struct ath6kl *ar)
-- 
1.7.0.4

