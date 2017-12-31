Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34601 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdLaRbg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 12:31:36 -0500
Received: by mail-lf0-f65.google.com with SMTP id h140so1449451lfg.1
        for <linux-wireless@vger.kernel.org>; Sun, 31 Dec 2017 09:31:35 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v4 01/18] ath10k: add inlined wrappers for htt tx ops
Date: Sun, 31 Dec 2017 18:29:08 +0100
Message-Id: <20171231172925.24014-2-erik.stromdahl@gmail.com> (sfid-20171231_183148_799576_BAAE35F0)
In-Reply-To: <20171231172925.24014-1-erik.stromdahl@gmail.com>
References: <20171231172925.24014-1-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These wrappers makes the HTT ops align better with the HIF ops
(where similar wrappers are used).

It also makes it easier for a target to have unsupported ops
(by letting the corresponding function pointer be NULL).

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/htt.c    |  4 +--
 drivers/net/wireless/ath/ath10k/htt.h    | 51 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/htt_tx.c | 12 ++++----
 drivers/net/wireless/ath/ath10k/mac.c    |  2 +-
 4 files changed, 60 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.c b/drivers/net/wireless/ath/ath10k/htt.c
index 625198dea18b..21a67f82f037 100644
--- a/drivers/net/wireless/ath/ath10k/htt.c
+++ b/drivers/net/wireless/ath/ath10k/htt.c
@@ -257,11 +257,11 @@ int ath10k_htt_setup(struct ath10k_htt *htt)
 		return status;
 	}
 
-	status = htt->tx_ops->htt_send_frag_desc_bank_cfg(htt);
+	status = ath10k_htt_send_frag_desc_bank_cfg(htt);
 	if (status)
 		return status;
 
-	status = htt->tx_ops->htt_send_rx_ring_cfg(htt);
+	status = ath10k_htt_send_rx_ring_cfg(htt);
 	if (status) {
 		ath10k_warn(ar, "failed to setup rx ring: %d\n",
 			    status);
diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 360c71b106d7..cdd87ef86c00 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1848,6 +1848,57 @@ struct ath10k_htt_tx_ops {
 	void (*htt_free_txbuff)(struct ath10k_htt *htt);
 };
 
+static inline int ath10k_htt_send_rx_ring_cfg(struct ath10k_htt *htt)
+{
+	if (!htt->tx_ops->htt_send_rx_ring_cfg)
+		return -EOPNOTSUPP;
+
+	return htt->tx_ops->htt_send_rx_ring_cfg(htt);
+}
+
+static inline int ath10k_htt_send_frag_desc_bank_cfg(struct ath10k_htt *htt)
+{
+	if (!htt->tx_ops->htt_send_frag_desc_bank_cfg)
+		return -EOPNOTSUPP;
+
+	return htt->tx_ops->htt_send_frag_desc_bank_cfg(htt);
+}
+
+static inline int ath10k_htt_alloc_frag_desc(struct ath10k_htt *htt)
+{
+	if (!htt->tx_ops->htt_alloc_frag_desc)
+		return -EOPNOTSUPP;
+
+	return htt->tx_ops->htt_alloc_frag_desc(htt);
+}
+
+static inline void ath10k_htt_free_frag_desc(struct ath10k_htt *htt)
+{
+	if (htt->tx_ops->htt_free_frag_desc)
+		htt->tx_ops->htt_free_frag_desc(htt);
+}
+
+static inline int ath10k_htt_tx(struct ath10k_htt *htt,
+				enum ath10k_hw_txrx_mode txmode,
+				struct sk_buff *msdu)
+{
+	return htt->tx_ops->htt_tx(htt, txmode, msdu);
+}
+
+static inline int ath10k_htt_alloc_txbuff(struct ath10k_htt *htt)
+{
+	if (!htt->tx_ops->htt_alloc_txbuff)
+		return -EOPNOTSUPP;
+
+	return htt->tx_ops->htt_alloc_txbuff(htt);
+}
+
+static inline void ath10k_htt_free_txbuff(struct ath10k_htt *htt)
+{
+	if (htt->tx_ops->htt_free_txbuff)
+		htt->tx_ops->htt_free_txbuff(htt);
+}
+
 struct ath10k_htt_rx_ops {
 	size_t (*htt_get_rx_ring_size)(struct ath10k_htt *htt);
 	void (*htt_config_paddrs_ring)(struct ath10k_htt *htt, void *vaddr);
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index d334b7be1fea..a086958c39b6 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -443,13 +443,13 @@ static int ath10k_htt_tx_alloc_buf(struct ath10k_htt *htt)
 	struct ath10k *ar = htt->ar;
 	int ret;
 
-	ret = htt->tx_ops->htt_alloc_txbuff(htt);
+	ret = ath10k_htt_alloc_txbuff(htt);
 	if (ret) {
 		ath10k_err(ar, "failed to alloc cont tx buffer: %d\n", ret);
 		return ret;
 	}
 
-	ret = htt->tx_ops->htt_alloc_frag_desc(htt);
+	ret = ath10k_htt_alloc_frag_desc(htt);
 	if (ret) {
 		ath10k_err(ar, "failed to alloc cont frag desc: %d\n", ret);
 		goto free_txbuf;
@@ -473,10 +473,10 @@ static int ath10k_htt_tx_alloc_buf(struct ath10k_htt *htt)
 	ath10k_htt_tx_free_txq(htt);
 
 free_frag_desc:
-	htt->tx_ops->htt_free_frag_desc(htt);
+	ath10k_htt_free_frag_desc(htt);
 
 free_txbuf:
-	htt->tx_ops->htt_free_txbuff(htt);
+	ath10k_htt_free_txbuff(htt);
 
 	return ret;
 }
@@ -530,9 +530,9 @@ void ath10k_htt_tx_destroy(struct ath10k_htt *htt)
 	if (!htt->tx_mem_allocated)
 		return;
 
-	htt->tx_ops->htt_free_txbuff(htt);
+	ath10k_htt_free_txbuff(htt);
 	ath10k_htt_tx_free_txq(htt);
-	htt->tx_ops->htt_free_frag_desc(htt);
+	ath10k_htt_free_frag_desc(htt);
 	ath10k_htt_tx_free_txdone_fifo(htt);
 	htt->tx_mem_allocated = false;
 }
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebb3f1b046f3..dcf6574f217c 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3597,7 +3597,7 @@ static int ath10k_mac_tx_submit(struct ath10k *ar,
 
 	switch (txpath) {
 	case ATH10K_MAC_TX_HTT:
-		ret = htt->tx_ops->htt_tx(htt, txmode, skb);
+		ret = ath10k_htt_tx(htt, txmode, skb);
 		break;
 	case ATH10K_MAC_TX_HTT_MGMT:
 		ret = ath10k_htt_mgmt_tx(htt, skb);
-- 
2.15.1
