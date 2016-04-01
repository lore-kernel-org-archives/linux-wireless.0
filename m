Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:48171 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbcDAVMU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 17:12:20 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 1/5] ath10k:  Ensure txrx-compl-task is stopped when cleaning htt-tx.
Date: Fri,  1 Apr 2016 14:12:08 -0700
Message-Id: <1459545132-11295-1-git-send-email-greearb@candelatech.com> (sfid-20160401_231227_046900_FCB24092)
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

