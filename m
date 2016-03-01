Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33804 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbcCAKcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2016 05:32:21 -0500
Received: by mail-lf0-f41.google.com with SMTP id j78so110093669lfb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2016 02:32:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 08/11] ath10k: implement updating shared htt txq state
Date: Tue,  1 Mar 2016 11:32:53 +0100
Message-Id: <1456828376-2795-9-git-send-email-michal.kazior@tieto.com> (sfid-20160301_113228_157486_7540504D)
In-Reply-To: <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
 <1456828376-2795-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware 10.4.3 onwards can support a pull-push Tx
model where it shares a Tx queue state with the
host.

The host updates the DMA region it pointed to
during HTT setup whenever number of software
queued from (on host) changes. Based on this
information firmware issues fetch requests to the
host telling the host how many frames from a list
of given stations/tids should be submitted to the
firmware.

The code won't be called because not all
appropriate HTT events are processed yet.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |   3 +
 drivers/net/wireless/ath/ath10k/htt_tx.c | 104 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.c    |   3 +
 3 files changed, 110 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 65dcd22f31df..b1e40f44e76b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1667,6 +1667,7 @@ struct ath10k_htt {
 	} txbuf;
 
 	struct {
+		bool enabled;
 		struct htt_q_state *vaddr;
 		dma_addr_t paddr;
 		u16 num_peers;
@@ -1758,6 +1759,8 @@ int ath10k_htt_tx_fetch_resp(struct ath10k *ar,
 			     struct htt_tx_fetch_record *records,
 			     size_t num_records);
 
+void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq);
 void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
 			       bool is_mgmt);
 int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 225f0561b3fd..6643be8692b5 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -22,6 +22,110 @@
 #include "txrx.h"
 #include "debug.h"
 
+static u8 ath10k_htt_tx_txq_calc_size(size_t count)
+{
+	int exp;
+	int factor;
+
+	exp = 0;
+	factor = count >> 7;
+
+	while (factor >= 64 && exp < 4) {
+		factor >>= 3;
+		exp++;
+	}
+
+	if (exp == 4)
+		return 0xff;
+
+	if (count > 0)
+		factor = max(1, factor);
+
+	return SM(exp, HTT_TX_Q_STATE_ENTRY_EXP) |
+	       SM(factor, HTT_TX_Q_STATE_ENTRY_FACTOR);
+}
+
+static void __ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
+				       struct ieee80211_txq *txq)
+{
+	struct ath10k *ar = hw->priv;
+	struct ath10k_sta *arsta = (void *)txq->sta->drv_priv;
+	struct ath10k_vif *arvif = (void *)txq->vif->drv_priv;
+	unsigned long frame_cnt;
+	unsigned long byte_cnt;
+	int idx;
+	u32 bit;
+	u16 peer_id;
+	u8 tid;
+	u8 count;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	if (!ar->htt.tx_q_state.enabled)
+		return;
+
+	if (txq->sta)
+		peer_id = arsta->peer_id;
+	else
+		peer_id = arvif->peer_id;
+
+	tid = txq->tid;
+	bit = BIT(peer_id % 32);
+	idx = peer_id / 32;
+
+	ieee80211_txq_get_depth(txq, &frame_cnt, &byte_cnt);
+	count = ath10k_htt_tx_txq_calc_size(byte_cnt);
+
+	if (unlikely(peer_id >= ar->htt.tx_q_state.num_peers) ||
+	    unlikely(tid >= ar->htt.tx_q_state.num_tids)) {
+		ath10k_warn(ar, "refusing to update txq for peer_id %hu tid %hhu due to out of bounds\n",
+			    peer_id, tid);
+		return;
+	}
+
+	ar->htt.tx_q_state.vaddr->count[tid][peer_id] = count;
+	ar->htt.tx_q_state.vaddr->map[tid][idx] &= ~bit;
+	ar->htt.tx_q_state.vaddr->map[tid][idx] |= count ? bit : 0;
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx txq state update peer_id %hu tid %hhu count %hhu\n",
+		   peer_id, tid, count);
+}
+
+static void __ath10k_htt_tx_txq_sync(struct ath10k *ar)
+{
+	u32 seq;
+	size_t size;
+
+	lockdep_assert_held(&ar->htt.tx_lock);
+
+	if (!ar->htt.tx_q_state.enabled)
+		return;
+
+	seq = le32_to_cpu(ar->htt.tx_q_state.vaddr->seq);
+	seq++;
+	ar->htt.tx_q_state.vaddr->seq = cpu_to_le32(seq);
+
+	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx txq state update commit seq %u\n",
+		   seq);
+
+	size = sizeof(*ar->htt.tx_q_state.vaddr);
+	dma_sync_single_for_device(ar->dev,
+				   ar->htt.tx_q_state.paddr,
+				   size,
+				   DMA_TO_DEVICE);
+}
+
+void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
+			      struct ieee80211_txq *txq)
+{
+	struct ath10k *ar = hw->priv;
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	__ath10k_htt_tx_txq_recalc(hw, txq);
+	__ath10k_htt_tx_txq_sync(ar);
+	spin_unlock_bh(&ar->htt.tx_lock);
+}
+
 void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
 			       bool is_mgmt)
 {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 74a42e3465e4..900c64b65b43 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3725,6 +3725,7 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 		}
 
 		list_del_init(&artxq->list);
+		ath10k_htt_tx_txq_update(hw, txq);
 
 		if (artxq == last || (ret < 0 && ret != -ENOENT)) {
 			if (ret != -ENOENT)
@@ -3967,6 +3968,8 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 
 		tasklet_schedule(&ar->htt.txrx_compl_task);
 	}
+
+	ath10k_htt_tx_txq_update(hw, txq);
 }
 
 /* Must not be called with conf_mutex held as workers can use that also. */
-- 
2.1.4

