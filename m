Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34027 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755400AbdDMI3H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 04:29:07 -0400
Subject: [PATCH v7 01/10] ath10k: htc: made static function public
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Date: Thu, 13 Apr 2017 11:28:57 +0300
Message-ID: <149207213738.4590.816518386579937753.stgit@potku.adurom.net> (sfid-20170413_102911_187774_EAEEE7D6)
In-Reply-To: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
References: <149207201649.4590.5821794186383265138.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erik Stromdahl <erik.stromdahl@gmail.com>

Changed ath10k_htc_notify_tx_completion and
ath10k_htc_process_trailer from static to non static.

These functions are needed by SDIO/mbox.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   14 ++++++++------
 drivers/net/wireless/ath/ath10k/htc.h |    6 ++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index b7669b2e94aa..f3dbce6ea0da 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -57,8 +57,8 @@ static inline void ath10k_htc_restore_tx_skb(struct ath10k_htc *htc,
 	skb_pull(skb, sizeof(struct ath10k_htc_hdr));
 }
 
-static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
-					    struct sk_buff *skb)
+void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
+				     struct sk_buff *skb)
 {
 	struct ath10k *ar = ep->htc->ar;
 
@@ -75,6 +75,7 @@ static void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
 
 	ep->ep_ops.ep_tx_complete(ep->htc->ar, skb);
 }
+EXPORT_SYMBOL(ath10k_htc_notify_tx_completion);
 
 static void ath10k_htc_prepare_tx_skb(struct ath10k_htc_ep *ep,
 				      struct sk_buff *skb)
@@ -230,10 +231,10 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
 	spin_unlock_bh(&htc->tx_lock);
 }
 
-static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
-				      u8 *buffer,
-				      int length,
-				      enum ath10k_htc_ep_id src_eid)
+int ath10k_htc_process_trailer(struct ath10k_htc *htc,
+			       u8 *buffer,
+			       int length,
+			       enum ath10k_htc_ep_id src_eid)
 {
 	struct ath10k *ar = htc->ar;
 	int status = 0;
@@ -294,6 +295,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 
 	return status;
 }
+EXPORT_SYMBOL(ath10k_htc_process_trailer);
 
 void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 6ababa345e2b..f728ce7124cf 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -351,5 +351,11 @@ int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size);
 void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
+void ath10k_htc_notify_tx_completion(struct ath10k_htc_ep *ep,
+				     struct sk_buff *skb);
+int ath10k_htc_process_trailer(struct ath10k_htc *htc,
+			       u8 *buffer,
+			       int length,
+			       enum ath10k_htc_ep_id src_eid);
 
 #endif
