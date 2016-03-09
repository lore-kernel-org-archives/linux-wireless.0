Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27047 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbcCIO4G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 09:56:06 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH v5] ath10k: move mgmt descriptor limit handle under mgmt_tx
Date: Wed, 9 Mar 2016 20:25:46 +0530
Message-ID: <1457535346-16159-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160309_155611_259979_B85D4961)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Frames that are transmitted via MGMT_TX are using reserved descriptor
slots in firmware. This limitation is for the htt_mgmt_tx path itself,
not for mgmt frames per se. In 16 MBSSID scenario, these reserved slots
will be easy exhausted due to frequent probe responses. So for 10.4
based solutions, probe responses are limited by a threshold (24).

management tx path is separate for all except tlv based solutions. Since
tlv solutions (qca6174 & qca9377) do not support 16 AP interfaces, it is
safe to move management descriptor limitation check under mgmt_tx
function. Though CPU improvement is negligible, unlikely conditions or
never hit conditions in hot path can be avoided on data transmission.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
v2:
  - rebased on top of Michal changes
v3:
  - handle mgmt_inc_pending for htt txmode alone
v4:
  - fix is_mgmt condition
v5:
  - updated commit log
  - fixed unconditional decrement of pending_mgmt_tx

 drivers/net/wireless/ath/ath10k/htt.h    | 10 +++----
 drivers/net/wireless/ath/ath10k/htt_rx.c |  7 ++++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 50 ++++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/mac.c    | 26 +++++++++++------
 drivers/net/wireless/ath/ath10k/txrx.c   | 18 +++++-------
 drivers/net/wireless/ath/ath10k/txrx.h   |  4 +--
 6 files changed, 68 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 02cf55d..751f6be 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1767,11 +1767,11 @@ void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 void ath10k_htt_tx_txq_recalc(struct ieee80211_hw *hw,
 			      struct ieee80211_txq *txq);
 void ath10k_htt_tx_txq_sync(struct ath10k *ar);
-void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
-			       bool is_mgmt);
-int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
-			      bool is_mgmt,
-			      bool is_presp);
+void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
+int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt);
+void ath10k_htt_tx_mgmt_dec_pending(struct ath10k_htt *htt);
+int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
+				   bool is_presp);
 
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index b805a86..a573343 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2326,7 +2326,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		ath10k_txrx_tx_unref(htt, &tx_done);
+		status = ath10k_txrx_tx_unref(htt, &tx_done);
+		if (!status) {
+			spin_lock_bh(&htt->tx_lock);
+			ath10k_htt_tx_mgmt_dec_pending(htt);
+			spin_unlock_bh(&htt->tx_lock);
+		}
 		ath10k_mac_tx_push_pending(ar);
 		break;
 	}
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index a30c34e..b2ae122 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -149,39 +149,22 @@ void ath10k_htt_tx_txq_update(struct ieee80211_hw *hw,
 	spin_unlock_bh(&ar->htt.tx_lock);
 }
 
-void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
-			       bool is_mgmt)
+void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
 	lockdep_assert_held(&htt->tx_lock);
 
-	if (is_mgmt)
-		htt->num_pending_mgmt_tx--;
-
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 }
 
-int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
-			      bool is_mgmt,
-			      bool is_presp)
+int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 {
-	struct ath10k *ar = htt->ar;
-
 	lockdep_assert_held(&htt->tx_lock);
 
 	if (htt->num_pending_tx >= htt->max_num_pending_tx)
 		return -EBUSY;
 
-	if (is_mgmt &&
-	    is_presp &&
-	    ar->hw_params.max_probe_resp_desc_thres &&
-	    ar->hw_params.max_probe_resp_desc_thres < htt->num_pending_mgmt_tx)
-		return -EBUSY;
-
-	if (is_mgmt)
-		htt->num_pending_mgmt_tx++;
-
 	htt->num_pending_tx++;
 	if (htt->num_pending_tx == htt->max_num_pending_tx)
 		ath10k_mac_tx_lock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
@@ -189,6 +172,35 @@ int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
 	return 0;
 }
 
+int ath10k_htt_tx_mgmt_inc_pending(struct ath10k_htt *htt, bool is_mgmt,
+				   bool is_presp)
+{
+	struct ath10k *ar = htt->ar;
+
+	lockdep_assert_held(&htt->tx_lock);
+
+	if (!is_mgmt || !ar->hw_params.max_probe_resp_desc_thres)
+		return 0;
+
+	if (is_presp &&
+	    ar->hw_params.max_probe_resp_desc_thres < htt->num_pending_mgmt_tx)
+		return -EBUSY;
+
+	htt->num_pending_mgmt_tx++;
+
+	return 0;
+}
+
+void ath10k_htt_tx_mgmt_dec_pending(struct ath10k_htt *htt)
+{
+	lockdep_assert_held(&htt->tx_lock);
+
+	if (!htt->ar->hw_params.max_probe_resp_desc_thres)
+		return;
+
+	htt->num_pending_mgmt_tx--;
+}
+
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb)
 {
 	struct ath10k *ar = htt->ar;
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index ebff9c0..209c13d 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3699,8 +3699,6 @@ static bool ath10k_mac_tx_can_push(struct ieee80211_hw *hw,
 int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 			   struct ieee80211_txq *txq)
 {
-	const bool is_mgmt = false;
-	const bool is_presp = false;
 	struct ath10k *ar = hw->priv;
 	struct ath10k_htt *htt = &ar->htt;
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
@@ -3713,7 +3711,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	int ret;
 
 	spin_lock_bh(&ar->htt.tx_lock);
-	ret = ath10k_htt_tx_inc_pending(htt, is_mgmt, is_presp);
+	ret = ath10k_htt_tx_inc_pending(htt);
 	spin_unlock_bh(&ar->htt.tx_lock);
 
 	if (ret)
@@ -3722,7 +3720,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 	skb = ieee80211_tx_dequeue(hw, txq);
 	if (!skb) {
 		spin_lock_bh(&ar->htt.tx_lock);
-		ath10k_htt_tx_dec_pending(htt, is_mgmt);
+		ath10k_htt_tx_dec_pending(htt);
 		spin_unlock_bh(&ar->htt.tx_lock);
 
 		return -ENOENT;
@@ -3739,7 +3737,7 @@ int ath10k_mac_tx_push_txq(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "failed to push frame: %d\n", ret);
 
 		spin_lock_bh(&ar->htt.tx_lock);
-		ath10k_htt_tx_dec_pending(htt, is_mgmt);
+		ath10k_htt_tx_dec_pending(htt);
 		spin_unlock_bh(&ar->htt.tx_lock);
 
 		return ret;
@@ -3978,14 +3976,13 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 	txpath = ath10k_mac_tx_h_get_txpath(ar, skb, txmode);
 	is_htt = (txpath == ATH10K_MAC_TX_HTT ||
 		  txpath == ATH10K_MAC_TX_HTT_MGMT);
+	is_mgmt = (txpath == ATH10K_MAC_TX_HTT_MGMT);
 
 	if (is_htt) {
 		spin_lock_bh(&ar->htt.tx_lock);
-
-		is_mgmt = ieee80211_is_mgmt(hdr->frame_control);
 		is_presp = ieee80211_is_probe_resp(hdr->frame_control);
 
-		ret = ath10k_htt_tx_inc_pending(htt, is_mgmt, is_presp);
+		ret = ath10k_htt_tx_inc_pending(htt);
 		if (ret) {
 			ath10k_warn(ar, "failed to increase tx pending count: %d, dropping\n",
 				    ret);
@@ -3994,6 +3991,15 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 			return;
 		}
 
+		ret = ath10k_htt_tx_mgmt_inc_pending(htt, is_mgmt, is_presp);
+		if (ret) {
+			ath10k_warn(ar, "failed to increase tx mgmt pending count: %d, dropping\n",
+				    ret);
+			ath10k_htt_tx_dec_pending(htt);
+			spin_unlock_bh(&ar->htt.tx_lock);
+			ieee80211_free_txskb(ar->hw, skb);
+			return;
+		}
 		spin_unlock_bh(&ar->htt.tx_lock);
 	}
 
@@ -4002,7 +4008,9 @@ static void ath10k_mac_op_tx(struct ieee80211_hw *hw,
 		ath10k_warn(ar, "failed to transmit frame: %d\n", ret);
 		if (is_htt) {
 			spin_lock_bh(&ar->htt.tx_lock);
-			ath10k_htt_tx_dec_pending(htt, is_mgmt);
+			ath10k_htt_tx_dec_pending(htt);
+			if (is_mgmt)
+				ath10k_htt_tx_mgmt_dec_pending(htt);
 			spin_unlock_bh(&ar->htt.tx_lock);
 		}
 		return;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index ea4d300..48e26cd 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -49,8 +49,8 @@ out:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
-			  const struct htt_tx_done *tx_done)
+int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
+			 const struct htt_tx_done *tx_done)
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
@@ -59,7 +59,6 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	struct ath10k_skb_cb *skb_cb;
 	struct ath10k_txq *artxq;
 	struct sk_buff *msdu;
-	bool limit_mgmt_desc = false;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
@@ -69,7 +68,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
 		ath10k_warn(ar, "warning: msdu_id %d too big, ignoring\n",
 			    tx_done->msdu_id);
-		return;
+		return -EINVAL;
 	}
 
 	spin_lock_bh(&htt->tx_lock);
@@ -78,22 +77,18 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		ath10k_warn(ar, "received tx completion for invalid msdu_id: %d\n",
 			    tx_done->msdu_id);
 		spin_unlock_bh(&htt->tx_lock);
-		return;
+		return -ENOENT;
 	}
 
 	skb_cb = ATH10K_SKB_CB(msdu);
 	txq = skb_cb->txq;
 	artxq = (void *)txq->drv_priv;
 
-	if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
-	    ar->hw_params.max_probe_resp_desc_thres)
-		limit_mgmt_desc = true;
-
 	if (txq)
 		artxq->num_fw_queued--;
 
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
-	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
+	ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
@@ -108,7 +103,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-		return;
+		return 0;
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -122,6 +117,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
+	return 0;
 }
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
index a90e09f..e7ea1ae 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.h
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -19,8 +19,8 @@
 
 #include "htt.h"
 
-void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
-			  const struct htt_tx_done *tx_done);
+int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
+			 const struct htt_tx_done *tx_done);
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr);
-- 
2.7.2

