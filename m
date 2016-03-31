Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49413 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758360AbcCaU7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 16:59:49 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 1/3] ath10k:  Ensure txrx-compl-task is stopped when cleaning htt-tx.
Date: Thu, 31 Mar 2016 13:59:44 -0700
Message-Id: <1459457986-29222-1-git-send-email-greearb@candelatech.com> (sfid-20160331_230002_146347_1B40C5AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Otherwise, the txrx-compl-task may access some bad memory?

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/htt_tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_tx.c b/drivers/net/wireless/ath/ath10k/htt_tx.c
index 07b960e..58e88d3 100644
--- a/drivers/net/wireless/ath/ath10k/htt_tx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_tx.c
@@ -376,6 +376,8 @@ void ath10k_htt_tx_free(struct ath10k_htt *htt)
 {
 	int size;
 
+	tasklet_kill(&htt->txrx_compl_task);
+
 	idr_for_each(&htt->pending_tx, ath10k_htt_tx_clean_up_pending, htt->ar);
 	idr_destroy(&htt->pending_tx);
 
-- 
2.4.3

