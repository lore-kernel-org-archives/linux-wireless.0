Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:33187 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbbHaLF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 07:05:29 -0400
From: Vivek Natarajan <nataraja@qti.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: [PATCH] ath10k: Drop probe responses when too many are queued
Date: Mon, 31 Aug 2015 16:34:55 +0530
Message-ID: <1441019095-2364-1-git-send-email-nataraja@qti.qualcomm.com> (sfid-20150831_130537_450262_3984C6B9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In a noisy environment, when multiple interfaces are created,
the management tx descriptors are fully occupied by the probe
responses from all the interfaces. This prevents a new station
from a successful association.

Fix this by limiting the probe responses when the specified
threshold limit is reached.

Signed-off-by: Vivek Natarajan <nataraja@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c   |  5 +++
 drivers/net/wireless/ath/ath10k/core.h   |  5 +++
 drivers/net/wireless/ath/ath10k/htt.h    |  3 +-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 52 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/txrx.c   | 14 +++++++--
 5 files changed, 68 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 7e378c2..c8dde43 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -54,6 +54,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.has_shifted_cc_wraparound = true,
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
 		.fw = {
 			.dir = QCA988X_HW_2_0_FW_DIR,
 			.fw = QCA988X_HW_2_0_FW_FILE,
@@ -70,6 +71,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
 		.fw = {
 			.dir = QCA6174_HW_2_1_FW_DIR,
 			.fw = QCA6174_HW_2_1_FW_FILE,
@@ -86,6 +88,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
 		.fw = {
 			.dir = QCA6174_HW_3_0_FW_DIR,
 			.fw = QCA6174_HW_3_0_FW_FILE,
@@ -102,6 +105,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.uart_pin = 6,
 		.otp_exe_param = 0,
 		.channel_counters_freq_hz = 88000,
+		.max_probe_resp_desc_thres = 0,
 		.fw = {
 			/* uses same binaries as hw3.0 */
 			.dir = QCA6174_HW_3_0_FW_DIR,
@@ -120,6 +124,7 @@ static const struct ath10k_hw_params ath10k_hw_params_list[] = {
 		.otp_exe_param = 0x00000700,
 		.continuous_frag_desc = true,
 		.channel_counters_freq_hz = 150000,
+		.max_probe_resp_desc_thres = 24,
 		.fw = {
 			.dir = QCA99X0_HW_2_0_FW_DIR,
 			.fw = QCA99X0_HW_2_0_FW_FILE,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 862f6d0..713c7ff 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -611,6 +611,11 @@ struct ath10k {
 
 		u32 channel_counters_freq_hz;
 
+		/* Mgmt tx descriptors threshold for limiting probe response
+		 * frames.
+		 */
+		u32 max_probe_resp_desc_thres;
+
 		struct ath10k_hw_params_fw {
 			const char *dir;
 			const char *fw;
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 5731875..5a8e4ea 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1485,6 +1485,7 @@ struct ath10k_htt {
 	spinlock_t tx_lock;
 	int max_num_pending_tx;
 	int num_pending_tx;
+	int num_pending_mgmt_tx;
 	struct idr pending_tx;
 	wait_queue_head_t empty_tx_wq;
 	struct dma_pool *tx_pool;
@@ -1587,7 +1588,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_ampdu,
 				u8 max_subfrms_amsdu);
 
-void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
+void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt, bool limit_mgmt_desc);
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 704bb5e..1837fd8 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -22,22 +22,28 @@
 #include "txrx.h"
 #include "debug.h"
 
-void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
+void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt, bool limit_mgmt_desc)
 {
+	if (limit_mgmt_desc)
+		htt->num_pending_mgmt_tx--;
+
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 }
 
-static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
+static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
+				      bool limit_mgmt_desc)
 {
 	spin_lock_bh(&htt->tx_lock);
-	__ath10k_htt_tx_dec_pending(htt);
+	__ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
 	spin_unlock_bh(&htt->tx_lock);
 }
 
-static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
+static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
+				     bool limit_mgmt_desc, bool is_probe_resp)
 {
+	struct ath10k *ar = htt->ar;
 	int ret = 0;
 
 	spin_lock_bh(&htt->tx_lock);
@@ -47,6 +53,15 @@ static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 		goto exit;
 	}
 
+	if (limit_mgmt_desc) {
+		if (is_probe_resp && (htt->num_pending_mgmt_tx >
+		    ar->hw_params.max_probe_resp_desc_thres)) {
+			ret = -EBUSY;
+			goto exit;
+		}
+		htt->num_pending_mgmt_tx++;
+	}
+
 	htt->num_pending_tx++;
 	if (htt->num_pending_tx == htt->max_num_pending_tx)
 		ath10k_mac_tx_lock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
@@ -417,8 +432,19 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int len = 0;
 	int msdu_id = -1;
 	int res;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
+	bool limit_mgmt_desc = false;
+	bool is_probe_resp = false;
+
+	if (ar->hw_params.max_probe_resp_desc_thres) {
+		limit_mgmt_desc = true;
+
+		if (ieee80211_is_probe_resp(hdr->frame_control))
+			is_probe_resp = true;
+	}
+
+	res = ath10k_htt_tx_inc_pending(htt, limit_mgmt_desc, is_probe_resp);
 
-	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
 		goto err;
 
@@ -474,7 +500,7 @@ err_free_msdu_id:
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
-	ath10k_htt_tx_dec_pending(htt);
+	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
 err:
 	return res;
 }
@@ -496,8 +522,18 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	dma_addr_t paddr = 0;
 	u32 frags_paddr = 0;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
+	bool limit_mgmt_desc = false;
+	bool is_probe_resp = false;
+
+	if (unlikely(ieee80211_is_mgmt(hdr->frame_control)) &&
+	    ar->hw_params.max_probe_resp_desc_thres) {
+		limit_mgmt_desc = true;
+
+		if (ieee80211_is_probe_resp(hdr->frame_control))
+			is_probe_resp = true;
+	}
 
-	res = ath10k_htt_tx_inc_pending(htt);
+	res = ath10k_htt_tx_inc_pending(htt, limit_mgmt_desc, is_probe_resp);
 	if (res)
 		goto err;
 
@@ -674,7 +710,7 @@ err_free_msdu_id:
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
-	ath10k_htt_tx_dec_pending(htt);
+	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
 err:
 	return res;
 }
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index e4a9c4c..7db7d50 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -52,6 +52,9 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ieee80211_tx_info *info;
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
+	struct ieee80211_hdr *hdr;
+	__le16 fc;
+	bool limit_mgmt_desc = false;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
@@ -72,14 +75,21 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		spin_unlock_bh(&htt->tx_lock);
 		return;
 	}
+
+	hdr = (struct ieee80211_hdr *)msdu->data;
+	fc = hdr->frame_control;
+
+	if (unlikely(ieee80211_is_mgmt(fc)) &&
+	    ar->hw_params.max_probe_resp_desc_thres)
+		limit_mgmt_desc = true;
+
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
-	__ath10k_htt_tx_dec_pending(htt);
+	__ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
 	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
 	skb_cb = ATH10K_SKB_CB(msdu);
-
 	dma_unmap_single(dev, skb_cb->paddr, msdu->len, DMA_TO_DEVICE);
 
 	if (skb_cb->htt.txbuf)
-- 
1.9.1

