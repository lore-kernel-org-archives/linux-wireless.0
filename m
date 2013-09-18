Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46192 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab3IRMnb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Sep 2013 08:43:31 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 1/5] ath10k: use num_pending_tx instead of msdu id bitmap
Date: Wed, 18 Sep 2013 14:43:18 +0200
Message-ID: <1379508202-9660-2-git-send-email-michal.kazior@tieto.com> (sfid-20130918_144336_461601_FE044E72)
In-Reply-To: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
References: <1379508202-9660-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's more efficient to simply check num_pending_tx
value instead of traversing whole bitmap of
msdu ids.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c  |    3 +--
 drivers/net/wireless/ath/ath10k/txrx.c |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 11aa13e..5a56833 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2853,8 +2853,7 @@ static void ath10k_flush(struct ieee80211_hw *hw, u32 queues, bool drop)
 			bool empty;
 
 			spin_lock_bh(&ar->htt.tx_lock);
-			empty = bitmap_empty(ar->htt.used_msdu_ids,
-					     ar->htt.max_num_pending_tx);
+			empty = (ar->htt.num_pending_tx == 0);
 			spin_unlock_bh(&ar->htt.tx_lock);
 
 			skip = (ar->state == ATH10K_STATE_WEDGED);
diff --git a/drivers/net/wireless/ath/ath10k/txrx.c b/drivers/net/wireless/ath/ath10k/txrx.c
index 68b6fae..37b8196 100644
--- a/drivers/net/wireless/ath/ath10k/txrx.c
+++ b/drivers/net/wireless/ath/ath10k/txrx.c
@@ -96,7 +96,7 @@ exit:
 	htt->pending_tx[ATH10K_SKB_CB(txdesc)->htt.msdu_id] = NULL;
 	ath10k_htt_tx_free_msdu_id(htt, ATH10K_SKB_CB(txdesc)->htt.msdu_id);
 	__ath10k_htt_tx_dec_pending(htt);
-	if (bitmap_empty(htt->used_msdu_ids, htt->max_num_pending_tx))
+	if (htt->num_pending_tx == 0)
 		wake_up(&htt->empty_tx_wq);
 	spin_unlock_bh(&htt->tx_lock);
 
-- 
1.7.9.5

