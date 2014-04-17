Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38422 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756787AbaDQAn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 20:43:28 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Hold tx-lock while detaching htt.
Date: Wed, 16 Apr 2014 17:42:37 -0700
Message-Id: <1397695357-14028-1-git-send-email-greearb@candelatech.com> (sfid-20140417_024331_954425_FB51D1FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

And check for null pool in the tx path (which would
indicate we are detaching).

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 22a4542..0698d6f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -143,10 +143,19 @@ static void ath10k_htt_tx_cleanup_pending(struct ath10k_htt *htt)
 
 void ath10k_htt_tx_detach(struct ath10k_htt *htt)
 {
+	struct dma_pool *tx_pool_tmp;
+
 	ath10k_htt_tx_cleanup_pending(htt);
+
+	spin_lock_bh(&htt->tx_lock);
 	kfree(htt->pending_tx);
 	kfree(htt->used_msdu_ids);
-	dma_pool_destroy(htt->tx_pool);
+	tx_pool_tmp = htt->tx_pool;
+	htt->tx_pool = NULL;
+	spin_unlock_bh(&htt->tx_lock);
+
+	dma_pool_destroy(tx_pool_tmp);
+
 	return;
 }
 
@@ -403,6 +412,13 @@ int ath10k_htt_tx(struct ath10k_htt *htt, struct sk_buff *msdu)
 		goto err;
 
 	spin_lock_bh(&htt->tx_lock);
+
+	/* Check if we are detached... */
+	if (! htt->tx_pool) {
+		spin_unlock_bh(&htt->tx_lock);
+		goto err_tx_dec;
+	}
+
 	res = ath10k_htt_tx_alloc_msdu_id(htt);
 	if (res < 0) {
 		spin_unlock_bh(&htt->tx_lock);
-- 
1.7.11.7

