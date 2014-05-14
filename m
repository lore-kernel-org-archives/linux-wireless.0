Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:52474 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbaENMXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 08:23:35 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so1354369eei.28
        for <linux-wireless@vger.kernel.org>; Wed, 14 May 2014 05:23:33 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/2] ath10k: fix core start sequence
Date: Wed, 14 May 2014 14:16:25 +0200
Message-Id: <1400069786-9764-2-git-send-email-michal.kazior@tieto.com> (sfid-20140514_142339_734043_DDF964D4)
In-Reply-To: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
References: <1400069786-9764-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was possible to call hif_stop() 2 times through
ath10k_htc_connect_init() timeout failpath which
could lead to double free_irq() kernel splat for
multiple MSI interrupt case.

Re-order init sequence to avoid this problem. The
HTC stop shouldn't stop HIF implicitly since it
doesn't implicitly start it. Since the re-ordering
required some functions to be split/removed/renamed
rename a few functions to make more sense while at
it.

Reported-By: Ben Greear <greearb@candelatech.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c   | 101 +++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/htc.c    |   6 --
 drivers/net/wireless/ath/ath10k/htt.c    |  42 +------------
 drivers/net/wireless/ath/ath10k/htt.h    |  18 +++---
 drivers/net/wireless/ath/ath10k/htt_rx.c |   4 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c |   8 +--
 drivers/net/wireless/ath/ath10k/wmi.c    |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.h    |   2 +-
 8 files changed, 76 insertions(+), 107 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 75b3dfb..eca826f 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -58,36 +58,6 @@ static void ath10k_send_suspend_complete(struct ath10k *ar)
 	complete(&ar->target_suspend);
 }
 
-static int ath10k_init_connect_htc(struct ath10k *ar)
-{
-	int status;
-
-	status = ath10k_wmi_connect_htc_service(ar);
-	if (status)
-		goto conn_fail;
-
-	/* Start HTC */
-	status = ath10k_htc_start(&ar->htc);
-	if (status)
-		goto conn_fail;
-
-	/* Wait for WMI event to be ready */
-	status = ath10k_wmi_wait_for_service_ready(ar);
-	if (status <= 0) {
-		ath10k_warn("wmi service ready event not received");
-		status = -ETIMEDOUT;
-		goto timeout;
-	}
-
-	ath10k_dbg(ATH10K_DBG_BOOT, "boot wmi ready\n");
-	return 0;
-
-timeout:
-	ath10k_htc_stop(&ar->htc);
-conn_fail:
-	return status;
-}
-
 static int ath10k_init_configure_target(struct ath10k *ar)
 {
 	u32 param_host;
@@ -805,10 +775,28 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err;
 	}
 
+	status = ath10k_htt_init(ar);
+	if (status) {
+		ath10k_err("failed to init htt: %d\n", status);
+		goto err_wmi_detach;
+	}
+
+	status = ath10k_htt_tx_alloc(&ar->htt);
+	if (status) {
+		ath10k_err("failed to alloc htt tx: %d\n", status);
+		goto err_wmi_detach;
+	}
+
+	status = ath10k_htt_rx_alloc(&ar->htt);
+	if (status) {
+		ath10k_err("failed to alloc htt rx: %d\n", status);
+		goto err_htt_tx_detach;
+	}
+
 	status = ath10k_hif_start(ar);
 	if (status) {
 		ath10k_err("could not start HIF: %d\n", status);
-		goto err_wmi_detach;
+		goto err_htt_rx_detach;
 	}
 
 	status = ath10k_htc_wait_target(&ar->htc);
@@ -817,15 +805,30 @@ int ath10k_core_start(struct ath10k *ar)
 		goto err_hif_stop;
 	}
 
-	status = ath10k_htt_attach(ar);
+	status = ath10k_htt_connect(&ar->htt);
 	if (status) {
-		ath10k_err("could not attach htt (%d)\n", status);
+		ath10k_err("failed to connect htt (%d)\n", status);
 		goto err_hif_stop;
 	}
 
-	status = ath10k_init_connect_htc(ar);
-	if (status)
-		goto err_htt_detach;
+	status = ath10k_wmi_connect(ar);
+	if (status) {
+		ath10k_err("could not connect wmi: %d\n", status);
+		goto err_hif_stop;
+	}
+
+	status = ath10k_htc_start(&ar->htc);
+	if (status) {
+		ath10k_err("failed to start htc: %d\n", status);
+		goto err_hif_stop;
+	}
+
+	status = ath10k_wmi_wait_for_service_ready(ar);
+	if (status <= 0) {
+		ath10k_warn("wmi service ready event not received");
+		status = -ETIMEDOUT;
+		goto err_htc_stop;
+	}
 
 	ath10k_dbg(ATH10K_DBG_BOOT, "firmware %s booted\n",
 		   ar->hw->wiphy->fw_version);
@@ -833,23 +836,25 @@ int ath10k_core_start(struct ath10k *ar)
 	status = ath10k_wmi_cmd_init(ar);
 	if (status) {
 		ath10k_err("could not send WMI init command (%d)\n", status);
-		goto err_disconnect_htc;
+		goto err_htc_stop;
 	}
 
 	status = ath10k_wmi_wait_for_unified_ready(ar);
 	if (status <= 0) {
 		ath10k_err("wmi unified ready event not received\n");
 		status = -ETIMEDOUT;
-		goto err_disconnect_htc;
+		goto err_htc_stop;
 	}
 
-	status = ath10k_htt_attach_target(&ar->htt);
-	if (status)
-		goto err_disconnect_htc;
+	status = ath10k_htt_setup(&ar->htt);
+	if (status) {
+		ath10k_err("failed to setup htt: %d\n", status);
+		goto err_htc_stop;
+	}
 
 	status = ath10k_debug_start(ar);
 	if (status)
-		goto err_disconnect_htc;
+		goto err_htc_stop;
 
 	ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
 	INIT_LIST_HEAD(&ar->arvifs);
@@ -868,12 +873,14 @@ int ath10k_core_start(struct ath10k *ar)
 
 	return 0;
 
-err_disconnect_htc:
+err_htc_stop:
 	ath10k_htc_stop(&ar->htc);
-err_htt_detach:
-	ath10k_htt_detach(&ar->htt);
 err_hif_stop:
 	ath10k_hif_stop(ar);
+err_htt_rx_detach:
+	ath10k_htt_rx_free(&ar->htt);
+err_htt_tx_detach:
+	ath10k_htt_tx_free(&ar->htt);
 err_wmi_detach:
 	ath10k_wmi_detach(ar);
 err:
@@ -913,7 +920,9 @@ void ath10k_core_stop(struct ath10k *ar)
 
 	ath10k_debug_stop(ar);
 	ath10k_htc_stop(&ar->htc);
-	ath10k_htt_detach(&ar->htt);
+	ath10k_hif_stop(ar);
+	ath10k_htt_tx_free(&ar->htt);
+	ath10k_htt_rx_free(&ar->htt);
 	ath10k_wmi_detach(ar);
 }
 EXPORT_SYMBOL(ath10k_core_stop);
diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 5b58dbb..e493db4 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -830,17 +830,11 @@ int ath10k_htc_start(struct ath10k_htc *htc)
 	return 0;
 }
 
-/*
- * stop HTC communications, i.e. stop interrupt reception, and flush all
- * queued buffers
- */
 void ath10k_htc_stop(struct ath10k_htc *htc)
 {
 	spin_lock_bh(&htc->tx_lock);
 	htc->stopped = true;
 	spin_unlock_bh(&htc->tx_lock);
-
-	ath10k_hif_stop(htc->ar);
 }
 
 /* registered target arrival callback from the HIF layer */
diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 69697af5..19c12cc 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -22,7 +22,7 @@
 #include "core.h"
 #include "debug.h"
 
-static int ath10k_htt_htc_attach(struct ath10k_htt *htt)
+int ath10k_htt_connect(struct ath10k_htt *htt)
 {
 	struct ath10k_htc_svc_conn_req conn_req;
 	struct ath10k_htc_svc_conn_resp conn_resp;
@@ -48,39 +48,14 @@ static int ath10k_htt_htc_attach(struct ath10k_htt *htt)
 	return 0;
 }
 
-int ath10k_htt_attach(struct ath10k *ar)
+int ath10k_htt_init(struct ath10k *ar)
 {
 	struct ath10k_htt *htt = &ar->htt;
-	int ret;
 
 	htt->ar = ar;
 	htt->max_throughput_mbps = 800;
 
 	/*
-	 * Connect to HTC service.
-	 * This has to be done before calling ath10k_htt_rx_attach,
-	 * since ath10k_htt_rx_attach involves sending a rx ring configure
-	 * message to the target.
-	 */
-	ret = ath10k_htt_htc_attach(htt);
-	if (ret) {
-		ath10k_err("could not attach htt htc (%d)\n", ret);
-		goto err_htc_attach;
-	}
-
-	ret = ath10k_htt_tx_attach(htt);
-	if (ret) {
-		ath10k_err("could not attach htt tx (%d)\n", ret);
-		goto err_htc_attach;
-	}
-
-	ret = ath10k_htt_rx_attach(htt);
-	if (ret) {
-		ath10k_err("could not attach htt rx (%d)\n", ret);
-		goto err_rx_attach;
-	}
-
-	/*
 	 * Prefetch enough data to satisfy target
 	 * classification engine.
 	 * This is for LL chips. HL chips will probably
@@ -93,11 +68,6 @@ int ath10k_htt_attach(struct ath10k *ar)
 		2; /* ip4 dscp or ip6 priority */
 
 	return 0;
-
-err_rx_attach:
-	ath10k_htt_tx_detach(htt);
-err_htc_attach:
-	return ret;
 }
 
 #define HTT_TARGET_VERSION_TIMEOUT_HZ (3*HZ)
@@ -117,7 +87,7 @@ static int ath10k_htt_verify_version(struct ath10k_htt *htt)
 	return 0;
 }
 
-int ath10k_htt_attach_target(struct ath10k_htt *htt)
+int ath10k_htt_setup(struct ath10k_htt *htt)
 {
 	int status;
 
@@ -140,9 +110,3 @@ int ath10k_htt_attach_target(struct ath10k_htt *htt)
 
 	return ath10k_htt_send_rx_ring_cfg_ll(htt);
 }
-
-void ath10k_htt_detach(struct ath10k_htt *htt)
-{
-	ath10k_htt_rx_detach(htt);
-	ath10k_htt_tx_detach(htt);
-}
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 645a563..9a26346 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1328,14 +1328,16 @@ struct htt_rx_desc {
 #define HTT_LOG2_MAX_CACHE_LINE_SIZE 7	/* 2^7 = 128 */
 #define HTT_MAX_CACHE_LINE_SIZE_MASK ((1 << HTT_LOG2_MAX_CACHE_LINE_SIZE) - 1)
 
-int ath10k_htt_attach(struct ath10k *ar);
-int ath10k_htt_attach_target(struct ath10k_htt *htt);
-void ath10k_htt_detach(struct ath10k_htt *htt);
-
-int ath10k_htt_tx_attach(struct ath10k_htt *htt);
-void ath10k_htt_tx_detach(struct ath10k_htt *htt);
-int ath10k_htt_rx_attach(struct ath10k_htt *htt);
-void ath10k_htt_rx_detach(struct ath10k_htt *htt);
+int ath10k_htt_connect(struct ath10k_htt *htt);
+int ath10k_htt_init(struct ath10k *ar);
+int ath10k_htt_setup(struct ath10k_htt *htt);
+
+int ath10k_htt_tx_alloc(struct ath10k_htt *htt);
+void ath10k_htt_tx_free(struct ath10k_htt *htt);
+
+int ath10k_htt_rx_alloc(struct ath10k_htt *htt);
+void ath10k_htt_rx_free(struct ath10k_htt *htt);
+
 void ath10k_htt_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb);
 int ath10k_htt_h2t_ver_req_msg(struct ath10k_htt *htt);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index f85a3cf..8da8020 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -225,7 +225,7 @@ static void ath10k_htt_rx_ring_refill_retry(unsigned long arg)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
-void ath10k_htt_rx_detach(struct ath10k_htt *htt)
+void ath10k_htt_rx_free(struct ath10k_htt *htt)
 {
 	int sw_rd_idx = htt->rx_ring.sw_rd_idx.msdu_payld;
 
@@ -468,7 +468,7 @@ static void ath10k_htt_rx_replenish_task(unsigned long ptr)
 	ath10k_htt_rx_msdu_buff_replenish(htt);
 }
 
-int ath10k_htt_rx_attach(struct ath10k_htt *htt)
+int ath10k_htt_rx_alloc(struct ath10k_htt *htt)
 {
 	dma_addr_t paddr;
 	void *vaddr;
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 7a3e2e4..7064354 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -83,7 +83,7 @@ void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id)
 	__clear_bit(msdu_id, htt->used_msdu_ids);
 }
 
-int ath10k_htt_tx_attach(struct ath10k_htt *htt)
+int ath10k_htt_tx_alloc(struct ath10k_htt *htt)
 {
 	spin_lock_init(&htt->tx_lock);
 	init_waitqueue_head(&htt->empty_tx_wq);
@@ -120,7 +120,7 @@ int ath10k_htt_tx_attach(struct ath10k_htt *htt)
 	return 0;
 }
 
-static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
+static void ath10k_htt_tx_free_pending(struct ath10k_htt *htt)
 {
 	struct htt_tx_done tx_done = {0};
 	int msdu_id;
@@ -141,9 +141,9 @@ static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 	spin_unlock_bh(&htt->tx_lock);
 }
 
-void ath10k_htt_tx_detach(struct ath10k_htt *htt)
+void ath10k_htt_tx_free(struct ath10k_htt *htt)
 {
-	ath10k_htt_tx_cleanup_pending(htt);
+	ath10k_htt_tx_free_pending(htt);
 	kfree(htt->pending_tx);
 	kfree(htt->used_msdu_ids);
 	dma_pool_destroy(htt->tx_pool);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 72cc4f2..e35a82e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2359,7 +2359,7 @@ void ath10k_wmi_detach(struct ath10k *ar)
 	ar->wmi.num_mem_chunks = 0;
 }
 
-int ath10k_wmi_connect_htc_service(struct ath10k *ar)
+int ath10k_wmi_connect(struct ath10k *ar)
 {
 	int status;
 	struct ath10k_htc_svc_conn_req conn_req;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index ae83822..df128c7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4259,7 +4259,7 @@ void ath10k_wmi_detach(struct ath10k *ar);
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar);
 int ath10k_wmi_wait_for_unified_ready(struct ath10k *ar);
 
-int ath10k_wmi_connect_htc_service(struct ath10k *ar);
+int ath10k_wmi_connect(struct ath10k *ar);
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 				const struct wmi_channel_arg *);
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar, u32 suspend_opt);
-- 
1.8.5.3

