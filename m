Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36030 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753578AbdBUQQP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 11:16:15 -0500
Received: by mail-lf0-f66.google.com with SMTP id 90so4026443lfr.3
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 08:16:14 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 01/21] ath10k: htc: made static function public
Date: Tue, 21 Feb 2017 17:15:21 +0100
Message-Id: <1487693741-10042-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20170221_171648_232198_98392686)
In-Reply-To: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
References: <1487693741-10042-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed ath10k_htc_notify_tx_completion and
ath10k_htc_process_trailer from static to non static.

These functions are needed by SDIO/mbox.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 14 ++++++++------
 drivers/net/wireless/ath/ath10k/htc.h |  6 ++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 9f6a915..35e67c4 100644
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
@@ -227,10 +228,10 @@ ath10k_htc_process_credit_report(struct ath10k_htc *htc,
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
@@ -291,6 +292,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 
 	return status;
 }
+EXPORT_SYMBOL(ath10k_htc_process_trailer);
 
 void ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 6ababa3..f728ce7 100644
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
-- 
2.7.4
