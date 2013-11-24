Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44920 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab3KXUGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:54 -0500
Received: by mail-wg0-f49.google.com with SMTP id x12so2982643wgg.28
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 03/29] iwlwifi: pcie: remove useless condition test
Date: Sun, 24 Nov 2013 22:06:20 +0200
Message-Id: <1385323606-3603-3-git-send-email-egrumbach@gmail.com> (sfid-20131124_210705_387744_DCAF6101)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

After wait_event_timeout(), the condition must still be
true if it returns >0, in fact almost the last thing in
it is checking the condition again. It's therefore not
useful to check yet again in our code, clean it up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c |   32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 487a517..d81d58c 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1542,30 +1542,24 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 	}
 
 	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status)) {
-			struct iwl_txq *txq =
-				&trans_pcie->txq[trans_pcie->cmd_queue];
-			struct iwl_queue *q = &txq->q;
+		struct iwl_txq *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
+		struct iwl_queue *q = &txq->q;
 
-			IWL_ERR(trans,
-				"Error sending %s: time out after %dms.\n",
-				get_cmd_string(trans_pcie, cmd->id),
-				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
+		IWL_ERR(trans, "Error sending %s: time out after %dms.\n",
+			get_cmd_string(trans_pcie, cmd->id),
+			jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
-			IWL_ERR(trans,
-				"Current CMD queue read_ptr %d write_ptr %d\n",
-				q->read_ptr, q->write_ptr);
+		IWL_ERR(trans, "Current CMD queue read_ptr %d write_ptr %d\n",
+			q->read_ptr, q->write_ptr);
 
-			clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
-			IWL_DEBUG_INFO(trans,
-				       "Clearing HCMD_ACTIVE for command %s\n",
-				       get_cmd_string(trans_pcie, cmd->id));
-			ret = -ETIMEDOUT;
+		clear_bit(STATUS_HCMD_ACTIVE, &trans_pcie->status);
+		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
+			       get_cmd_string(trans_pcie, cmd->id));
+		ret = -ETIMEDOUT;
 
-			iwl_op_mode_nic_error(trans->op_mode);
+		iwl_op_mode_nic_error(trans->op_mode);
 
-			goto cancel;
-		}
+		goto cancel;
 	}
 
 	if (test_bit(STATUS_FW_ERROR, &trans_pcie->status)) {
-- 
1.7.9.5

