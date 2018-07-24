Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:42741 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388390AbeGXIt4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Jul 2018 04:49:56 -0400
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Dedy Lansky <dlansky@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Maya Erez <merez@codeaurora.org>
Subject: [PATCH v2 02/19] wil6210: drop Rx packets with L2 error indication from HW
Date: Tue, 24 Jul 2018 10:44:23 +0300
Message-Id: <1532418280-5849-3-git-send-email-merez@codeaurora.org> (sfid-20180724_100226_905549_BDE2A4B7)
In-Reply-To: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
References: <1532418280-5849-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dedy Lansky <dlansky@codeaurora.org>

Due to recent change in FW, driver will be notified of corrupted Rx
packets (e.g. MIC error).
Drop such packets before they are delivered to network stack.

Signed-off-by: Dedy Lansky <dlansky@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c   | 12 ++++----
 drivers/net/wireless/ath/wil6210/txrx.c      | 22 ++++++++++++++
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 16 ++++------
 drivers/net/wireless/ath/wil6210/wil6210.h   | 44 +++++++++++++++-------------
 4 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 7d62126..99b1fc5 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -1734,13 +1734,11 @@ static int wil_sta_debugfs_show(struct seq_file *s, void *data)
 				   p->stats.rx_short_frame,
 				   p->stats.rx_large_frame,
 				   p->stats.rx_replay);
-
-			if (wil->use_enhanced_dma_hw)
-				seq_printf(s,
-					   "mic error  %lu, key error %lu, amsdu error %lu\n",
-					   p->stats.rx_mic_error,
-					   p->stats.rx_key_error,
-					   p->stats.rx_amsdu_error);
+			seq_printf(s,
+				   "mic error %lu, key error %lu, amsdu error %lu\n",
+				   p->stats.rx_mic_error,
+				   p->stats.rx_key_error,
+				   p->stats.rx_amsdu_error);
 
 			seq_puts(s, "Rx/MCS:");
 			for (mcs = 0; mcs < ARRAY_SIZE(p->stats.rx_per_mcs);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index ad40a96..9ac8674 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -678,6 +678,21 @@ static int wil_rx_crypto_check(struct wil6210_priv *wil, struct sk_buff *skb)
 	return 0;
 }
 
+static int wil_rx_error_check(struct wil6210_priv *wil, struct sk_buff *skb,
+			      struct wil_net_stats *stats)
+{
+	struct vring_rx_desc *d = wil_skb_rxdesc(skb);
+
+	if ((d->dma.status & RX_DMA_STATUS_ERROR) &&
+	    (d->dma.error & RX_DMA_ERROR_MIC)) {
+		stats->rx_mic_error++;
+		wil_dbg_txrx(wil, "MIC error, dropping packet\n");
+		return -EFAULT;
+	}
+
+	return 0;
+}
+
 static void wil_get_netif_rx_params(struct sk_buff *skb, int *cid,
 				    int *security)
 {
@@ -736,6 +751,12 @@ void wil_netif_rx_any(struct sk_buff *skb, struct net_device *ndev)
 		goto stats;
 	}
 
+	/* check errors reported by HW and update statistics */
+	if (unlikely(wil->txrx_ops.rx_error_check(wil, skb, stats))) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
 	if (wdev->iftype == NL80211_IFTYPE_AP && !vif->ap_isolate) {
 		if (mcast) {
 			/* send multicast frames both to higher layers in
@@ -2212,6 +2233,7 @@ void wil_init_txrx_ops_legacy_dma(struct wil6210_priv *wil)
 	wil->txrx_ops.get_netif_rx_params =
 		wil_get_netif_rx_params;
 	wil->txrx_ops.rx_crypto_check = wil_rx_crypto_check;
+	wil->txrx_ops.rx_error_check = wil_rx_error_check;
 	wil->txrx_ops.is_rx_idle = wil_is_rx_idle;
 	wil->txrx_ops.rx_fini = wil_rx_fini;
 }
diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 1940347..b5d399f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -795,14 +795,15 @@ static int wil_check_bar(struct wil6210_priv *wil, void *msg, int cid,
 	return -EAGAIN;
 }
 
-static int wil_rx_edma_check_errors(struct wil6210_priv *wil, void *msg,
-				    struct wil_net_stats *stats,
-				    struct sk_buff *skb)
+static int wil_rx_error_check_edma(struct wil6210_priv *wil,
+				   struct sk_buff *skb,
+				   struct wil_net_stats *stats)
 {
 	int error;
 	int l2_rx_status;
 	int l3_rx_status;
 	int l4_rx_status;
+	void *msg = wil_skb_rxstatus(skb);
 
 	error = wil_rx_status_get_error(msg);
 	if (!error) {
@@ -865,7 +866,6 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 	struct wil_net_stats *stats = NULL;
 	u16 dmalen;
 	int cid;
-	int rc;
 	bool eop, headstolen;
 	int delta;
 	u8 dr_bit;
@@ -937,13 +937,6 @@ static struct sk_buff *wil_sring_reap_rx_edma(struct wil6210_priv *wil,
 		goto skipping;
 	}
 
-	/* Check and treat errors reported by HW */
-	rc = wil_rx_edma_check_errors(wil, msg, stats, skb);
-	if (rc) {
-		rxdata->skipping = true;
-		goto skipping;
-	}
-
 	if (unlikely(dmalen > sz)) {
 		wil_err(wil, "Rx size too large: %d bytes!\n", dmalen);
 		stats->rx_large_frame++;
@@ -1593,6 +1586,7 @@ void wil_init_txrx_ops_edma(struct wil6210_priv *wil)
 	wil->txrx_ops.get_reorder_params = wil_get_reorder_params_edma;
 	wil->txrx_ops.get_netif_rx_params = wil_get_netif_rx_params_edma;
 	wil->txrx_ops.rx_crypto_check = wil_rx_crypto_check_edma;
+	wil->txrx_ops.rx_error_check = wil_rx_error_check_edma;
 	wil->txrx_ops.is_rx_idle = wil_is_rx_idle_edma;
 	wil->txrx_ops.rx_fini = wil_rx_fini_edma;
 }
diff --git a/drivers/net/wireless/ath/wil6210/wil6210.h b/drivers/net/wireless/ath/wil6210/wil6210.h
index 9b1467c..002d336 100644
--- a/drivers/net/wireless/ath/wil6210/wil6210.h
+++ b/drivers/net/wireless/ath/wil6210/wil6210.h
@@ -543,6 +543,27 @@ struct wil_status_ring {
 	struct wil_ring_rx_data rx_data;
 };
 
+#define WIL_STA_TID_NUM (16)
+#define WIL_MCS_MAX (12) /* Maximum MCS supported */
+
+struct wil_net_stats {
+	unsigned long	rx_packets;
+	unsigned long	tx_packets;
+	unsigned long	rx_bytes;
+	unsigned long	tx_bytes;
+	unsigned long	tx_errors;
+	unsigned long	rx_dropped;
+	unsigned long	rx_non_data_frame;
+	unsigned long	rx_short_frame;
+	unsigned long	rx_large_frame;
+	unsigned long	rx_replay;
+	unsigned long	rx_mic_error;
+	unsigned long	rx_key_error; /* eDMA specific */
+	unsigned long	rx_amsdu_error; /* eDMA specific */
+	u16 last_mcs_rx;
+	u64 rx_per_mcs[WIL_MCS_MAX + 1];
+};
+
 /**
  * struct tx_rx_ops - different TX/RX ops for legacy and enhanced
  * DMA flow
@@ -576,6 +597,8 @@ struct wil_txrx_ops {
 	void (*get_netif_rx_params)(struct sk_buff *skb,
 				    int *cid, int *security);
 	int (*rx_crypto_check)(struct wil6210_priv *wil, struct sk_buff *skb);
+	int (*rx_error_check)(struct wil6210_priv *wil, struct sk_buff *skb,
+			      struct wil_net_stats *stats);
 	bool (*is_rx_idle)(struct wil6210_priv *wil);
 	irqreturn_t (*irq_rx)(int irq, void *cookie);
 };
@@ -676,27 +699,6 @@ enum wil_sta_status {
 	wil_sta_connected = 2,
 };
 
-#define WIL_STA_TID_NUM (16)
-#define WIL_MCS_MAX (12) /* Maximum MCS supported */
-
-struct wil_net_stats {
-	unsigned long	rx_packets;
-	unsigned long	tx_packets;
-	unsigned long	rx_bytes;
-	unsigned long	tx_bytes;
-	unsigned long	tx_errors;
-	unsigned long	rx_dropped;
-	unsigned long	rx_non_data_frame;
-	unsigned long	rx_short_frame;
-	unsigned long	rx_large_frame;
-	unsigned long	rx_replay;
-	unsigned long	rx_mic_error; /* eDMA specific */
-	unsigned long	rx_key_error; /* eDMA specific */
-	unsigned long	rx_amsdu_error; /* eDMA specific */
-	u16 last_mcs_rx;
-	u64 rx_per_mcs[WIL_MCS_MAX + 1];
-};
-
 /**
  * struct wil_sta_info - data for peer
  *
-- 
1.9.1
