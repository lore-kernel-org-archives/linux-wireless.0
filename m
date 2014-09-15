Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:41168 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbaIOFNY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:24 -0400
Received: by mail-wg0-f51.google.com with SMTP id k14so3290382wgh.22
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:23 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/28] iwlwifi: pcie: clear command data on freeing
Date: Mon, 15 Sep 2014 08:12:45 +0300
Message-Id: <1410757980-2138-13-git-send-email-egrumbach@gmail.com> (sfid-20140915_073116_248853_B352484D)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When freeing the structures used for command data, clear their
memory as they may have contained key material at some point.
Also clear the duplicated buffer when freeing it to be safe;
currently key material is never put there but that may change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 2 +-
 drivers/net/wireless/iwlwifi/pcie/tx.c | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 702f47f..7b7e2f2 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -640,7 +640,7 @@ static void iwl_pcie_rx_handle_rb(struct iwl_trans *trans,
 		err = iwl_op_mode_rx(trans->op_mode, &rxcb, cmd);
 
 		if (reclaim) {
-			kfree(txq->entries[cmd_index].free_buf);
+			kzfree(txq->entries[cmd_index].free_buf);
 			txq->entries[cmd_index].free_buf = NULL;
 		}
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 35fe38e..eb8e298 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -620,8 +620,8 @@ static void iwl_pcie_txq_free(struct iwl_trans *trans, int txq_id)
 	/* De-alloc array of command/tx buffers */
 	if (txq_id == trans_pcie->cmd_queue)
 		for (i = 0; i < txq->q.n_window; i++) {
-			kfree(txq->entries[i].cmd);
-			kfree(txq->entries[i].free_buf);
+			kzfree(txq->entries[i].cmd);
+			kzfree(txq->entries[i].free_buf);
 		}
 
 	/* De-alloc circular buffer of TFDs */
@@ -1409,7 +1409,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 
 	out_meta->flags = cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
-		kfree(txq->entries[idx].free_buf);
+		kzfree(txq->entries[idx].free_buf);
 	txq->entries[idx].free_buf = dup_buf;
 
 	trace_iwlwifi_dev_hcmd(trans->dev, cmd, cmd_size, &out_cmd->hdr);
-- 
1.9.1

