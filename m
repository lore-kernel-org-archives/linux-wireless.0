Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:36359 "EHLO
	mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbcEIMXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 08:23:24 -0400
Received: by mail-lf0-f43.google.com with SMTP id u64so198358828lff.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 May 2016 05:23:23 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: improve tx scheduling
Date: Mon,  9 May 2016 14:25:08 +0200
Message-Id: <1462796708-13880-1-git-send-email-michal.kazior@tieto.com> (sfid-20160509_142328_167431_09A26B9B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recent changes revolving around implementing
wake_tx_queue support introduced a significant
performance regressions on some (slower, uni-proc)
systems.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 3 ---
 drivers/net/wireless/ath/ath10k/mac.c    | 7 ++++---
 drivers/net/wireless/ath/ath10k/txrx.c   | 3 +++
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index cc979a4faeb0..7411b69fde42 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -2291,7 +2291,6 @@ bool ath10k_htt_t2h_msg_handler(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_htt_tx_mgmt_dec_pending(htt);
 			spin_unlock_bh(&htt->tx_lock);
 		}
-		ath10k_mac_tx_push_pending(ar);
 		break;
 	}
 	case HTT_T2H_MSG_TYPE_TX_COMPL_IND:
@@ -2442,8 +2441,6 @@ static void ath10k_htt_txrx_compl_task(unsigned long ptr)
 		dev_kfree_skb_any(skb);
 	}
 
-	ath10k_mac_tx_push_pending(ar);
-
 	num_mpdus = atomic_read(&htt->num_mpdus_ready);
 
 	while (num_mpdus) {
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6dd1d26b357f..1dd415d3c0ee 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3781,6 +3781,9 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 	int ret;
 	int max;
 
+	if (ar->htt.num_pending_tx >= (ar->htt.max_num_pending_tx / 2))
+		return;
+
 	spin_lock_bh(&ar->txqs_lock);
 	rcu_read_lock();
 
@@ -4051,9 +4054,7 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 		list_add_tail(&artxq->list, &ar->txqs);
 	spin_unlock_bh(&ar->txqs_lock);
 
-	if (ath10k_mac_tx_can_push(hw, txq))
-		tasklet_schedule(&ar->htt.txrx_compl_task);
-
+	ath10k_mac_tx_push_pending(ar);
 	ath10k_htt_tx_txq_update(hw, txq);
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 576e7c42ed65..1966c787998b 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -117,6 +117,9 @@ int ath10k_txrx_tx_unref(struct ath10k_htt *htt,
 
 	ieee80211_tx_status(htt->ar->hw, msdu);
 	/* we do not own the msdu anymore */
+
+	ath10k_mac_tx_push_pending(ar);
+
 	return 0;
 }
 
-- 
2.1.4

