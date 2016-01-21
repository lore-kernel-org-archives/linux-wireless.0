Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34551 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965318AbcAUNpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:51 -0500
Received: by mail-lb0-f176.google.com with SMTP id cl12so23453862lbc.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jan 2016 05:45:50 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 10/13] ath10k: implement flushing of pending frames in txqs
Date: Thu, 21 Jan 2016 14:46:43 +0100
Message-Id: <1453384006-31907-11-git-send-email-michal.kazior@tieto.com> (sfid-20160121_144556_480138_B3425BF7)
In-Reply-To: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
References: <1453384006-31907-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware supporting pull-push tx model may request
a switch between modes. When switching from
pull-push to push-only it will be necessary to
flush all pending frames. The code will do that
once other bits that actually trigger it are added.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h   |  1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c |  3 ++
 drivers/net/wireless/ath/ath10k/mac.c    | 82 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/mac.h    |  1 +
 4 files changed, 87 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index d09d6fdf1149..38ed4bbd220b 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -607,6 +607,7 @@ static inline const char *ath10k_scan_state_str(enum ath10k_scan_state state)
 
 enum ath10k_tx_pause_reason {
 	ATH10K_TX_PAUSE_Q_FULL,
+	ATH10K_TX_PAUSE_Q_FLUSH_PENDING,
 	ATH10K_TX_PAUSE_MAX,
 };
 
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index be7dc88b3316..6e3d95c95568 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2244,6 +2244,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 		}
 
 		ath10k_txrx_tx_unref(htt, &tx_done);
+		ath10k_mac_tx_push_pending(ar);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
@@ -2370,6 +2371,8 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		dev_kfree_skb_any(skb);
 	}
 
+	ath10k_mac_tx_push_pending(ar);
+
 	spin_lock_bh(&htt->rx_ring.lock);
 	while ((skb = __skb_dequeue(&htt->rx_compl_q))) {
 		resp = (struct htt_resp *)skb->data;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 205ccf3760a3..42020c22eaed 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3710,6 +3710,88 @@ static void ath10k_mac_tx_wake(struct ieee80211_hw *hw,
 	ath10k_htt_tx_txq_update(hw, txq);
 }
 
+struct ath10k_mac_tx_push_arg {
+	struct ieee80211_hw *hw;
+	bool more;
+};
+
+static void ath10k_mac_tx_push_pending_txq(struct ieee80211_hw *hw,
+					   struct ieee80211_txq *txq,
+					   struct ath10k_mac_tx_push_arg *arg)
+{
+	bool can_push;
+	bool has_more;
+	int ret;
+
+	if (!txq)
+		return;
+
+	while (txq->qdepth > 0) {
+		if (!ath10k_mac_tx_can_push(hw, txq))
+			break;
+
+		ret = ath10k_mac_tx_push_txq(hw, txq);
+		if (ret)
+			break;
+	}
+
+	can_push = ath10k_mac_tx_can_push(hw, txq);
+	has_more = txq->qdepth > 0;
+
+	if (can_push && has_more)
+		arg->more = true;
+}
+
+static void ath10k_mac_tx_push_pending_vif_iter(void *data,
+						u8 *mac,
+						struct ieee80211_vif *vif)
+{
+	struct ath10k_mac_tx_push_arg *arg = data;
+	struct ieee80211_hw *hw = arg->hw;
+
+	ath10k_mac_tx_push_pending_txq(hw, vif->txq, arg);
+}
+
+static void ath10k_mac_tx_push_pending_sta_iter(void *data,
+						struct ieee80211_sta *sta)
+{
+	struct ath10k_mac_tx_push_arg *arg = data;
+	struct ieee80211_hw *hw = arg->hw;
+	int tid;
+
+	for (tid = 0; tid < ARRAY_SIZE(sta->txq); tid++)
+		ath10k_mac_tx_push_pending_txq(hw, sta->txq[tid], arg);
+}
+
+void ath10k_mac_tx_push_pending(struct ath10k *ar)
+{
+	struct ieee80211_hw *hw = ar->hw;
+	struct ath10k_mac_tx_push_arg arg = {};
+
+	if (likely(!(ar->tx_paused & BIT(ATH10K_TX_PAUSE_Q_FLUSH_PENDING))))
+		return;
+
+	arg.hw = hw;
+	arg.more = false;
+
+	ieee80211_iterate_active_interfaces_atomic(hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath10k_mac_tx_push_pending_vif_iter,
+						   &arg);
+	if (arg.more)
+		return;
+
+	ieee80211_iterate_stations_atomic(hw,
+					  ath10k_mac_tx_push_pending_sta_iter,
+					  &arg);
+	if (arg.more)
+		return;
+
+	spin_lock_bh(&ar->htt.tx_lock);
+	ath10k_mac_tx_unlock(ar, ATH10K_TX_PAUSE_Q_FLUSH_PENDING);
+	spin_unlock_bh(&ar->htt.tx_lock);
+}
+
 /************/
 /* Scanning */
 /************/
diff --git a/drivers/net/wireless/ath/ath10k/mac.h b/drivers/net/wireless/ath/ath10k/mac.h
index 53091588090d..453f606a250e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.h
+++ b/drivers/net/wireless/ath/ath10k/mac.h
@@ -75,6 +75,7 @@ void ath10k_mac_tx_unlock(struct ath10k *ar, int reason);
 void ath10k_mac_vif_tx_lock(struct ath10k_vif *arvif, int reason);
 void ath10k_mac_vif_tx_unlock(struct ath10k_vif *arvif, int reason);
 bool ath10k_mac_tx_frm_has_freq(struct ath10k *ar);
+void ath10k_mac_tx_push_pending(struct ath10k *ar);
 
 static inline struct ath10k_vif *ath10k_vif_to_arvif(struct ieee80211_vif *vif)
 {
-- 
2.1.4

