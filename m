Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:51329 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaDMTUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:37 -0400
Received: by mail-we0-f180.google.com with SMTP id p61so7197271wes.25
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:36 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/47] iwlwifi: pcie: WARN upon traffic while flushing TX queues
Date: Sun, 13 Apr 2014 22:19:33 +0300
Message-Id: <1397416802-32403-18-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_676604_B2B18B92)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This must not happen - otherwise we might keep flushing
forever.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/trans.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 0f20e73..4845d50 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1270,6 +1270,8 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 
 	/* waiting for all the tx frames complete might take a while */
 	for (cnt = 0; cnt < trans->cfg->base_params->num_of_queues; cnt++) {
+		u8 wr_ptr;
+
 		if (cnt == trans_pcie->cmd_queue)
 			continue;
 		if (!test_bit(cnt, trans_pcie->queue_used))
@@ -1278,9 +1280,19 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, u32 txq_bm)
 			continue;
 		txq = &trans_pcie->txq[cnt];
 		q = &txq->q;
-		while (q->read_ptr != q->write_ptr && !time_after(jiffies,
-		       now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS)))
+		wr_ptr = ACCESS_ONCE(q->write_ptr);
+
+		while (q->read_ptr != ACCESS_ONCE(q->write_ptr) &&
+		       !time_after(jiffies,
+				   now + msecs_to_jiffies(IWL_FLUSH_WAIT_MS))) {
+			u8 write_ptr = ACCESS_ONCE(q->write_ptr);
+
+			if (WARN_ONCE(wr_ptr != write_ptr,
+				      "WR pointer moved while flushing %d -> %d\n",
+				      wr_ptr, write_ptr))
+				return -ETIMEDOUT;
 			msleep(1);
+		}
 
 		if (q->read_ptr != q->write_ptr) {
 			IWL_ERR(trans,
-- 
1.8.3.2

