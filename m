Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34031 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbcCQJtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 05:49:02 -0400
Received: by mail-lb0-f180.google.com with SMTP id k12so64673379lbb.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 02:49:01 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/2] ath10k: fix pull-push tx threshold handling
Date: Thu, 17 Mar 2016 10:51:05 +0100
Message-Id: <1458208265-16715-3-git-send-email-michal.kazior@tieto.com> (sfid-20160317_104908_933678_F95769C4)
In-Reply-To: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
References: <1458208265-16715-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This prevents tx hangs or hiccups if pull-push
supporting firmware defines per-txq thresholds or
switches modes dynamically.

Fixes: 299468782d94 ("ath10k: implement wake_tx_queue")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 74dd010a9188..4d51b92e67e0 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3772,7 +3772,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)
 
 		/* Prevent aggressive sta/tid taking over tx queue */
 		max = 16;
-		while (max--) {
+		ret = 0;
+		while (ath10k_mac_tx_can_push(hw, txq) && max--) {
 			ret = ath10k_mac_tx_push_txq(hw, txq);
 			if (ret < 0)
 				break;
@@ -4015,14 +4016,13 @@ static void ath10k_mac_op_wake_tx_queue(struct ieee80211_hw *hw,
 	struct ath10k *ar = hw->priv;
 	struct ath10k_txq *artxq = (void *)txq->drv_priv;
 
-	if (ath10k_mac_tx_can_push(hw, txq)) {
-		spin_lock_bh(&ar->txqs_lock);
-		if (list_empty(&artxq->list))
-			list_add_tail(&artxq->list, &ar->txqs);
-		spin_unlock_bh(&ar->txqs_lock);
+	spin_lock_bh(&ar->txqs_lock);
+	if (list_empty(&artxq->list))
+		list_add_tail(&artxq->list, &ar->txqs);
+	spin_unlock_bh(&ar->txqs_lock);
 
+	if (ath10k_mac_tx_can_push(hw, txq))
 		tasklet_schedule(&ar->htt.txrx_compl_task);
-	}
 
 	ath10k_htt_tx_txq_update(hw, txq);
 }
-- 
2.1.4

