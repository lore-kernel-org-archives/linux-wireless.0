Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35571 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752301AbcKRTYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 14:24:12 -0500
Received: by mail-qk0-f195.google.com with SMTP id n204so34262308qke.2
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 11:24:12 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 01/11] ath10k: htc: made static function public
Date: Fri, 18 Nov 2016 20:22:41 +0100
Message-Id: <1479496971-19174-2-git-send-email-erik.stromdahl@gmail.com> (sfid-20161118_202416_911151_7868CE01)
In-Reply-To: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changed ath10k_htc_notify_tx_completion and
ath10k_htc_process_trailer from static to non static.

These functions are needed by SDIO/mbox.

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htc.c |   14 ++++++++------
 drivers/net/wireless/ath/ath10k/htc.h |    6 ++++++
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 175aae3..26b1e15 100644
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
@@ -227,10 +228,10 @@ void ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
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
index 0c55cd9..858e19f 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -354,5 +354,11 @@ int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
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
1.7.9.5
