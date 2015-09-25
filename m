Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24989 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbbIYGyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2015 02:54:37 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 1/7] ath10k: export htc tx rx handlers
Date: Fri, 25 Sep 2015 12:23:30 +0530
Message-ID: <1443164016-3612-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20150925_085440_253938_0E6A56E6)
In-Reply-To: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Export HTC layer tx and rx handlers. This will be used by HIF layer
for per-CE data processing. Instead of callback mechanism, HIF will
call appropriate upper layers API directly.

Reviewed-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 8 ++++----
 drivers/net/wireless/ath/ath10k/htc.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 32d9ff1..97c24b2 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -181,8 +181,7 @@ err_pull:
 	return ret;
 }
 
-static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
-					    struct sk_buff *skb)
+int ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct ath10k_htc *htc = &ar->htc;
 	struct ath10k_skb_cb *skb_cb;
@@ -199,6 +198,7 @@ static int ath10k_htc_tx_completion_handler(struct ath10k *ar,
 
 	return 0;
 }
+EXPORT_SYMBOL(ath10k_htc_tx_completion_handler);
 
 /***********/
 /* Receive */
@@ -304,8 +304,7 @@ static int ath10k_htc_process_trailer(struct ath10k_htc *htc,
 	return status;
 }
 
-static int ath10k_htc_rx_completion_handler(struct ath10k *ar,
-					    struct sk_buff *skb)
+int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb)
 {
 	int status = 0;
 	struct ath10k_htc *htc = &ar->htc;
@@ -442,6 +441,7 @@ out:
 
 	return status;
 }
+EXPORT_SYMBOL(ath10k_htc_rx_completion_handler);
 
 static void ath10k_htc_control_rx_complete(struct ath10k *ar,
 					   struct sk_buff *skb)
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 527179c..d1fc8e7 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -355,5 +355,7 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
 struct sk_buff *ath10k_htc_alloc_skb(struct ath10k *ar, int size);
+int ath10k_htc_tx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
+int ath10k_htc_rx_completion_handler(struct ath10k *ar, struct sk_buff *skb);
 
 #endif
-- 
2.5.2

