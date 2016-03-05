Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbcCEOKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2016 09:10:40 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath10k: move mgmt descriptor limit handle under mgmt_tx
Date: Sat, 5 Mar 2016 19:40:17 +0530
Message-ID: <1457187017-12913-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160305_151044_197587_9649F644)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware reserves few descriptors for management frames transmission.
In 16 MBSSID scenario, these slots will be easy exhausted due to frequent
probe responses. So for 10.4 based solutions, probe responses are limited
by a threshold (24).

management tx path is separate for all except tlv based solutions. Since
tlv solutions (qca6174 & qca9377) do not support 16 AP interfaces, it is
safe to move management descriptor limitation check under mgmt_tx
function. Though CPU improvement is negligible, unlikely conditions or
never hit conditions in hot path can be avoided on data transmission.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    |  2 +-
 drivers/net/wireless/ath/ath10k/htt_rx.c |  7 +++-
 drivers/net/wireless/ath/ath10k/htt_tx.c | 62 ++++++++++++--------------------
 drivers/net/wireless/ath/ath10k/txrx.c   | 18 ++++------
 drivers/net/wireless/ath/ath10k/txrx.h   |  4 +--
 5 files changed, 38 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 13391ea..b611c2b 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1753,7 +1753,7 @@ int ath10k_htt_h2t_aggr_cfg_msg(struct ath10k_htt *htt,
 				u8 max_subfrms_amsdu);
 void ath10k_htt_hif_tx_complete(struct ath10k *ar, struct sk_buff *skb);
 
-void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt, bool limit_mgmt_desc);
+void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt);
 int ath10k_htt_tx_alloc_msdu_id(struct ath10k_htt *htt, struct sk_buff *skb);
 void ath10k_htt_tx_free_msdu_id(struct ath10k_htt *htt, u16 msdu_id);
 int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *);
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index ae9b686..7d1a0f2 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2049,7 +2049,12 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		ath10k_txrx_tx_unref(htt, &tx_done);
+		status = ath10k_txrx_tx_unref(htt, &tx_done);
+		if (!status) {
+			spin_lock_bh(&htt->tx_lock);
+			htt->num_pending_mgmt_tx--;
+			spin_unlock_bh(&htt->tx_lock);
+		}
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 95acb72..6a29b802 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -22,28 +22,22 @@
 #include "txrx.h"
 #include "debug.h"
 
-void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt, bool limit_mgmt_desc)
+void __ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
-	if (limit_mgmt_desc)
-		htt->num_pending_mgmt_tx--;
-
 	htt->num_pending_tx--;
 	if (htt->num_pending_tx == htt->max_num_pending_tx - 1)
 		ath10k_mac_tx_unlock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
 }
 
-static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt,
-				      bool limit_mgmt_desc)
+static void ath10k_htt_tx_dec_pending(struct ath10k_htt *htt)
 {
 	spin_lock_bh(&htt->tx_lock);
-	__ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
+	__ath10k_htt_tx_dec_pending(htt);
 	spin_unlock_bh(&htt->tx_lock);
 }
 
-static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
-				     bool limit_mgmt_desc, bool is_probe_resp)
+static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt)
 {
-	struct ath10k *ar = htt->ar;
 	int ret = 0;
 
 	spin_lock_bh(&htt->tx_lock);
@@ -53,15 +47,6 @@ static int ath10k_htt_tx_inc_pending(struct ath10k_htt *htt,
 		goto exit;
 	}
 
-	if (limit_mgmt_desc) {
-		if (is_probe_resp && (htt->num_pending_mgmt_tx >
-		    ar->hw_params.max_probe_resp_desc_thres)) {
-			ret = -EBUSY;
-			goto exit;
-		}
-		htt->num_pending_mgmt_tx++;
-	}
-
 	htt->num_pending_tx++;
 	if (htt->num_pending_tx == htt->max_num_pending_tx)
 		ath10k_mac_tx_lock(htt->ar, ATH10K_TX_PAUSE_Q_FULL);
@@ -576,17 +561,21 @@ int ath10k_htt_mgmt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 	int msdu_id = -1;
 	int res;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)msdu->data;
-	bool limit_mgmt_desc = false;
-	bool is_probe_resp = false;
-
-	if (ar->hw_params.max_probe_resp_desc_thres) {
-		limit_mgmt_desc = true;
 
-		if (ieee80211_is_probe_resp(hdr->frame_control))
-			is_probe_resp = true;
+	if (ar->hw_params.max_probe_resp_desc_thres &&
+	    ieee80211_is_probe_resp(hdr->frame_control)) {
+		spin_lock_bh(&htt->tx_lock);
+		if ((htt->num_pending_mgmt_tx >
+		    ar->hw_params.max_probe_resp_desc_thres)) {
+			spin_unlock_bh(&htt->tx_lock);
+			res = -EBUSY;
+			goto err;
+		}
+		htt->num_pending_mgmt_tx++;
+		spin_unlock_bh(&htt->tx_lock);
 	}
 
-	res = ath10k_htt_tx_inc_pending(htt, limit_mgmt_desc, is_probe_resp);
+	res = ath10k_htt_tx_inc_pending(htt);
 
 	if (res)
 		goto err;
@@ -650,7 +639,10 @@ err_free_msdu_id:
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
-	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
+	spin_lock_bh(&htt->tx_lock);
+	htt->num_pending_mgmt_tx--;
+	spin_unlock_bh(&htt->tx_lock);
+	ath10k_htt_tx_dec_pending(htt);
 err:
 	return res;
 }
@@ -677,18 +669,8 @@ int ath10k_htt_tx(struct ath10k_htt *htt, enum ath10k_hw_txrx_mode txmode,
 	u32 frags_paddr = 0;
 	u32 txbuf_paddr;
 	struct htt_msdu_ext_desc *ext_desc = NULL;
-	bool limit_mgmt_desc = false;
-	bool is_probe_resp = false;
-
-	if (unlikely(ieee80211_is_mgmt(hdr->frame_control)) &&
-	    ar->hw_params.max_probe_resp_desc_thres) {
-		limit_mgmt_desc = true;
-
-		if (ieee80211_is_probe_resp(hdr->frame_control))
-			is_probe_resp = true;
-	}
 
-	res = ath10k_htt_tx_inc_pending(htt, limit_mgmt_desc, is_probe_resp);
+	res = ath10k_htt_tx_inc_pending(htt);
 	if (res)
 		goto err;
 
@@ -866,7 +848,7 @@ err_free_msdu_id:
 	ath10k_htt_tx_free_msdu_id(htt, msdu_id);
 	spin_unlock_bh(&htt->tx_lock);
 err_tx_dec:
-	ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
+	ath10k_htt_tx_dec_pending(htt);
 err:
 	return res;
 }
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index fbfb608..476de08 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -49,15 +49,14 @@ out:
 	spin_unlock_bh(&ar->data_lock);
 }
 
-void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
-			  const struct htt_tx_done *tx_done)
+int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
+			 const struct htt_tx_done *tx_done)
 {
 	struct ath10k *ar = htt->ar;
 	struct device *dev = ar->dev;
 	struct ieee80211_tx_info *info;
 	struct ath10k_skb_cb *skb_cb;
 	struct sk_buff *msdu;
-	bool limit_mgmt_desc = false;
 
 	ath10k_dbg(ar, ATH10K_DBG_HTT,
 		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
@@ -67,7 +66,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
 		ath10k_warn(ar, "warning: msdu_id %d too big, ignoring\n",
 			    tx_done->msdu_id);
-		return;
+		return -EINVAL;
 	}
 
 	spin_lock_bh(&htt->tx_lock);
@@ -76,17 +75,13 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 		ath10k_warn(ar, "received tx completion for invalid msdu_id: %d\n",
 			    tx_done->msdu_id);
 		spin_unlock_bh(&htt->tx_lock);
-		return;
+		return -ENOENT;
 	}
 
 	skb_cb = ATH10K_SKB_CB(msdu);
 
-	if (unlikely(skb_cb->flags & ATH10K_SKB_F_MGMT) &&
-	    ar->hw_params.max_probe_resp_desc_thres)
-		limit_mgmt_desc = true;
-
 	ath10k_htt_tx_free_msdu_id(htt, tx_done->msdu_id);
-	__ath10k_htt_tx_dec_pending(htt, limit_mgmt_desc);
+	__ath10k_htt_tx_dec_pending(htt);
 	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
@@ -101,7 +96,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	if (tx_done->discard) {
 		ieee80211_free_txskb(htt->ar->hw, msdu);
-		return;
+		return 0;
 	}
 
 	if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
@@ -115,6 +110,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
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

