Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:48642 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaF0JR2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2014 05:17:28 -0400
Received: by mail-wg0-f45.google.com with SMTP id l18so4775821wgh.28
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2014 02:17:27 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Denton Gentry <denton.gentry@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC/RFT 2/2] ath10k: fix Rx aggregation reordering
Date: Fri, 27 Jun 2014 11:06:55 +0200
Message-Id: <1403860015-31601-3-git-send-email-michal.kazior@tieto.com> (sfid-20140627_111732_400888_DAC0A5C2)
In-Reply-To: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
References: <1403860015-31601-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware doesn't perform Rx reordering so it is
left to the host driver to do that.

Use mac80211 to perform reordering instead of
re-inventing the wheel.

This fixes TCP throughput issues in some
environments (notably Windows stations connecting
to ath10k AP).

Reported-By: Denton Gentry <denton.gentry@gmail.com>
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 92 ++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/mac.c    | 30 +++++++++++
 drivers/net/wireless/ath/ath10k/txrx.c   |  3 +-
 drivers/net/wireless/ath/ath10k/txrx.h   |  1 +
 4 files changed, 121 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6c102b1..57d5a97 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -21,6 +21,7 @@
 #include "txrx.h"
 #include "debug.h"
 #include "trace.h"
+#include "mac.h"
 
 #include <linux/log2.h>
 
@@ -1533,10 +1534,95 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 	case HTT_T2H_MSG_TYPE_STATS_CONF:
 		trace_ath10k_htt_stats(skb->data, skb->len);
 		break;
+	case HTT_T2H_MSG_TYPE_RX_ADDBA: {
+		struct ath10k *ar = htt->ar;
+		struct htt_rx_addba *ev = &resp->rx_addba;
+		struct ath10k_peer *peer;
+		struct ath10k_vif *arvif;
+		u16 info0, tid, peer_id;
+
+		info0 = __le32_to_cpu(ev->info0);
+		tid = MS(info0, HTT_RX_BA_INFO0_TID);
+		peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
+
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx addba tid %hu peer_id %hu size %hhu\n",
+			   tid, peer_id, ev->window_size);
+
+		spin_lock_bh(&ar->data_lock);
+		peer = ath10k_peer_find_by_id(ar, peer_id);
+		if (!peer) {
+			ath10k_warn("received addba event for invalid peer_id: %hu\n",
+				    peer_id);
+			spin_unlock_bh(&ar->data_lock);
+			break;
+		}
+
+		arvif = ath10k_get_arvif(ar, peer->vdev_id);
+		if (!arvif) {
+			ath10k_warn("received addba event for invalid vdev_id: %u\n",
+				    peer->vdev_id);
+			spin_unlock_bh(&ar->data_lock);
+			break;
+		}
+
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx start rx ba session sta %pM tid %hu size %hhu\n",
+			   peer->addr, tid, ev->window_size);
+
+		ieee80211_start_rx_ba_session_offl(arvif->vif, peer->addr, 0,
+						   0, 0, tid, ev->window_size);
+		spin_unlock_bh(&ar->data_lock);
+		break;
+	}
+	case HTT_T2H_MSG_TYPE_RX_DELBA: {
+		struct ath10k *ar = htt->ar;
+		struct htt_rx_addba *ev = &resp->rx_addba;
+		struct ath10k_peer *peer;
+		struct ath10k_vif *arvif;
+		u16 info0, tid, peer_id;
+
+		info0 = __le32_to_cpu(ev->info0);
+		tid = MS(info0, HTT_RX_BA_INFO0_TID);
+		peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
+
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx delba tid %hu peer_id %hu\n",
+			   tid, peer_id);
+
+		spin_lock_bh(&ar->data_lock);
+		peer = ath10k_peer_find_by_id(ar, peer_id);
+		if (!peer) {
+			ath10k_warn("received addba event for invalid peer_id: %hu\n",
+				    peer_id);
+			spin_unlock_bh(&ar->data_lock);
+			break;
+		}
+
+		arvif = ath10k_get_arvif(ar, peer->vdev_id);
+		if (!arvif) {
+			ath10k_warn("received addba event for invalid vdev_id: %u\n",
+				    peer->vdev_id);
+			spin_unlock_bh(&ar->data_lock);
+			break;
+		}
+
+		ath10k_dbg(ATH10K_DBG_HTT,
+			   "htt rx stop rx ba session sta %pM tid %hu\n",
+			   peer->addr, tid);
+
+		ieee80211_stop_rx_ba_session_offl(arvif->vif, peer->addr, tid);
+		spin_unlock_bh(&ar->data_lock);
+
+		break;
+	}
+	case HTT_T2H_MSG_TYPE_RX_FLUSH: {
+		/* Ignore this event because mac80211 takes care of Rx
+		 * aggregation reordering.
+		 */
+		break;
+	}
 	case HTT_T2H_MSG_TYPE_TX_INSPECT_IND:
-	case HTT_T2H_MSG_TYPE_RX_ADDBA:
-	case HTT_T2H_MSG_TYPE_RX_DELBA:
-	case HTT_T2H_MSG_TYPE_RX_FLUSH:
 	default:
 		ath10k_dbg(ATH10K_DBG_HTT, "htt event (%d) not handled\n",
 			   resp->hdr.msg_type);
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a210800..766fead 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4330,6 +4330,35 @@ static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	return 0;
 }
 
+int ath10k_ampdu_action(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			enum ieee80211_ampdu_mlme_action action,
+			struct ieee80211_sta *sta, u16 tid, u16 *ssn,
+			u8 buf_size)
+{
+	ath10k_dbg(ATH10K_DBG_MAC, "mac ampdu action %d\n", action);
+
+	switch (action) {
+	case IEEE80211_AMPDU_RX_START:
+	case IEEE80211_AMPDU_RX_STOP:
+		/* HTT AddBa/DelBa events trigger mac80211 Rx BA session
+		 * creation/removal. Do we need to verify this?
+		 */
+		return 0;
+	case IEEE80211_AMPDU_TX_START:
+	case IEEE80211_AMPDU_TX_STOP_CONT:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH:
+	case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
+	case IEEE80211_AMPDU_TX_OPERATIONAL:
+		/* Firmware offloads Tx aggregation entirely so deny mac80211
+		 * Tx aggregation requests.
+		 */
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 static const struct ieee80211_ops ath10k_ops = {
 	.tx				= ath10k_tx,
 	.start				= ath10k_start,
@@ -4357,6 +4386,7 @@ static const struct ieee80211_ops ath10k_ops = {
 	.set_bitrate_mask		= ath10k_set_bitrate_mask,
 	.sta_rc_update			= ath10k_sta_rc_update,
 	.get_tsf			= ath10k_get_tsf,
+	.ampdu_action			= ath10k_ampdu_action,
 #ifdef CONFIG_PM
 	.suspend			= ath10k_suspend,
 	.resume				= ath10k_resume,
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 82669a7..f4fa22d 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -119,8 +119,7 @@ struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 	return NULL;
 }
 
-static struct ath10k_peer *ath10k_peer_find_by_id(struct ath10k *ar,
-						  int peer_id)
+struct ath10k_peer *ath10k_peer_find_by_id(struct ath10k *ar, int peer_id)
 {
 	struct ath10k_peer *peer;
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.h b/drivers/net/wireless/ath/ath10k/txrx.h
index aee3e20..a90e09f 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.h
+++ b/drivers/net/wireless/ath/ath10k/txrx.h
@@ -24,6 +24,7 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 struct ath10k_peer *ath10k_peer_find(struct ath10k *ar, int vdev_id,
 				     const u8 *addr);
+struct ath10k_peer *ath10k_peer_find_by_id(struct ath10k *ar, int peer_id);
 int ath10k_wait_for_peer_created(struct ath10k *ar, int vdev_id,
 				 const u8 *addr);
 int ath10k_wait_for_peer_deleted(struct ath10k *ar, int vdev_id,
-- 
1.8.5.3

