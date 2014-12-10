Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:38300 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932525AbaLJPyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2014 10:54:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: [PATCH 3/4] ath10k: Fix no-ack frame status
Date: Wed, 10 Dec 2014 21:26:12 +0530
Message-Id: <1418226973-13779-3-git-send-email-sujith@msujith.org> (sfid-20141210_165441_221407_D9A65F34)
In-Reply-To: <1418226973-13779-1-git-send-email-sujith@msujith.org>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Use the new IEEE80211_TX_STAT_NOACK_TRANSMITTED flag
to indicate successful transmission of no-ack frames.
This fixes multicast frame accounting.

Cc: ath10k@lists.infradead.org
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htt.h    | 1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 drivers/net/wireless/ath/ath10k/txrx.c   | 9 +++++++--
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 1bd5545..cb74211 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -1159,6 +1159,7 @@ struct htt_tx_done {
 	u32 msdu_id;
 	bool discard;
 	bool no_ack;
+	bool success;
 };
 
 struct htt_peer_map_event {
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 9c782a4..d4d082e 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1476,6 +1476,7 @@ static void ath10k_htt_rx_frm_tx_compl(struct ath10k *ar,
 		tx_done.no_ack = true;
 		break;
 	case HTT_DATA_TX_STATUS_OK:
+		tx_done.success = true;
 		break;
 	case HTT_DATA_TX_STATUS_DISCARD:
 	case HTT_DATA_TX_STATUS_POSTPONE:
@@ -1627,6 +1628,7 @@ void ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 
 		switch (status) {
 		case HTT_MGMT_TX_STATUS_OK:
+			tx_done.success = true;
 			break;
 		case HTT_MGMT_TX_STATUS_RETRY:
 			tx_done.no_ack = true;
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 7579de8..7464d82 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -55,8 +55,10 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	lockdep_assert_held(&htt->tx_lock);
 
-	ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion msdu_id %u discard %d no_ack %d\n",
-		   tx_done->msdu_id, !!tx_done->discard, !!tx_done->no_ack);
+	ath10k_dbg(ar, ATH10K_DBG_HTT,
+		   "htt tx completion msdu_id %u discard %d no_ack %d success %d\n",
+		   tx_done->msdu_id, !!tx_done->discard,
+		   !!tx_done->no_ack, !!tx_done->success);
 
 	if (tx_done->msdu_id >= htt->max_num_pending_tx) {
 		ath10k_warn(ar, "warning: msdu_id %d too big, ignoring\n",
@@ -91,6 +93,9 @@ void ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 	if (tx_done->no_ack)
 		info->flags &= ~IEEE80211_TX_STAT_ACK;
 
+	if (tx_done->success && (info->flags & IEEE80211_TX_CTL_NO_ACK))
+		info->flags |= IEEE80211_TX_STAT_NOACK_TRANSMITTED;
+
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
 
-- 
2.1.3

