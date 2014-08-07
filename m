Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:54759 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaHGJNM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 05:13:12 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so3861420wes.28
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2014 02:13:10 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 5/6] ath10k: remove htc->stopped
Date: Thu,  7 Aug 2014 11:03:31 +0200
Message-Id: <1407402212-29809-6-git-send-email-michal.kazior@tieto.com> (sfid-20140807_111325_864702_7013C9A9)
In-Reply-To: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not necessary anymore. There are no more
uncontrolled htc tx entry points.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 13 +++++--------
 drivers/net/wireless/ath/ath10k/htc.c  | 16 ----------------
 drivers/net/wireless/ath/ath10k/htc.h  |  5 +----
 3 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2790aad..8eae2aa 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -780,7 +780,7 @@ int ath10k_core_start(struct ath10k *ar)
 	if (status <= 0) {
 		ath10k_warn("wmi service ready event not received");
 		status = -ETIMEDOUT;
-		goto err_htc_stop;
+		goto err_hif_stop;
 	}
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "firmware %s booted\n",
@@ -789,25 +789,25 @@ int ath10k_core_start(struct ath10k *ar)
 	status = ath10k_wmi_cmd_init(ar);
 	if (status) {
 		ath10k_err("could not send WMI init command (%d)\n", status);
-		goto err_htc_stop;
+		goto err_hif_stop;
 	}
 
 	status = ath10k_wmi_wait_for_unified_ready(ar);
 	if (status <= 0) {
 		ath10k_err("wmi unified ready event not received\n");
 		status = -ETIMEDOUT;
-		goto err_htc_stop;
+		goto err_hif_stop;
 	}
 
 	status = ath10k_htt_setup(&ar->htt);
 	if (status) {
 		ath10k_err("failed to setup htt: %d\n", status);
-		goto err_htc_stop;
+		goto err_hif_stop;
 	}
 
 	status = ath10k_debug_start(ar);
 	if (status)
-		goto err_htc_stop;
+		goto err_hif_stop;
 
 	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
 		ar->free_vdev_map = (1 << TARGET_10X_NUM_VDEVS) - 1;
@@ -836,8 +836,6 @@ int ath10k_core_start(struct ath10k *ar)
 
 	return 0;
 
-err_htc_stop:
-	ath10k_htc_stop(&ar->htc);
 err_hif_stop:
 	ath10k_hif_stop(ar);
 err_htt_rx_detach:
@@ -882,7 +880,6 @@ void ath10k_core_stop(struct ath10k *ar)
 		ath10k_wait_for_suspend(ar, WMI_PDEV_SUSPEND_AND_DISABLE_INTR);
 
 	ath10k_debug_stop(ar);
-	ath10k_htc_stop(&ar->htc);
 	ath10k_hif_stop(ar);
 	ath10k_htt_tx_free(&ar->htt);
 	ath10k_htt_rx_free(&ar->htt);
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 5fdc40d..7e08bb3 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -138,14 +138,6 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		return -ENOENT;
 	}
 
-	/* FIXME: This looks ugly, can we fix it? */
-	spin_lock_bh(&htc->tx_lock);
-	if (htc->stopped) {
-		spin_unlock_bh(&htc->tx_lock);
-		return -ESHUTDOWN;
-	}
-	spin_unlock_bh(&htc->tx_lock);
-
 	skb_push(skb, sizeof(struct ath10k_htc_hdr));
 
 	if (ep->tx_credit_flow_enabled) {
@@ -846,13 +838,6 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 	return 0;
 }
 
-void ath10k_htc_stop(struct ath10k_htc *htc)
-{
-	spin_lock_bh(&htc->tx_lock);
-	htc->stopped = true;
-	spin_unlock_bh(&htc->tx_lock);
-}
-
 /* registered target arrival callback from the HIF layer */
 int ath10k_htc_init(struct ath10k *ar)
 {
@@ -862,7 +847,6 @@ int ath10k_htc_init(struct ath10k *ar)
 
 	spin_lock_init(&htc->tx_lock);
 
-	htc->stopped = false;
 	ath10k_htc_reset_endpoint_states(htc);
 
 	/* setup HIF layer callbacks */
diff --git a/drivers/net/wireless/ath/ath10k/htc.h b/drivers/net/wireless/ath/ath10k/htc.h
index 4716d33..b5a9daa 100644
--- a/drivers/net/wireless/ath/ath10k/htc.h
+++ b/drivers/net/wireless/ath/ath10k/htc.h
@@ -332,7 +332,7 @@ struct ath10k_htc {
 	struct ath10k *ar;
 	struct ath10k_htc_ep endpoint[ATH10K_HTC_EP_COUNT];
 
-	/* protects endpoint and stopped fields */
+	/* protects endpoints */
 	spinlock_t tx_lock;
 
 	struct ath10k_htc_ops htc_ops;
@@ -345,8 +345,6 @@ struct ath10k_htc {
 	int total_transmit_credits;
 	struct ath10k_htc_svc_tx_credits service_tx_alloc[ATH10K_HTC_EP_COUNT];
 	int target_credit_size;
-
-	bool stopped;
 };
 
 int ath10k_htc_init(struct ath10k *ar);
@@ -357,7 +355,6 @@ int ath10k_htc_connect_service(struct ath10k_htc *htc,
 			       struct ath10k_htc_svc_conn_resp *conn_resp);
 int ath10k_htc_send(struct ath10k_htc *htc, enum ath10k_htc_ep_id eid,
 		    struct sk_buff *packet);
-void ath10k_htc_stop(struct ath10k_htc *htc);
 struct sk_buff *ath10k_htc_alloc_skb(int size);
 
 #endif
-- 
1.8.5.3

