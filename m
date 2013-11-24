Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54506 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab3KXUGy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Nov 2013 15:06:54 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq4so3027047wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Nov 2013 12:06:52 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/29] iwlwifi: remove TX_CMD id from transport layer
Date: Sun, 24 Nov 2013 22:06:18 +0200
Message-Id: <1385323606-3603-1-git-send-email-egrumbach@gmail.com> (sfid-20131124_210706_214258_6D858896)
In-Reply-To: <52925BE7.4050406@gmail.com>
References: <52925BE7.4050406@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The transport layer doesn't need to know the TX_CMD id.
It can be set by the op_mode.
The transport layer still needs to know the layout of the
Tx command because of alignment issues and because of the
scratch pointer.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/tx.c  |    1 +
 drivers/net/wireless/iwlwifi/mvm/tx.c  |    1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c |    1 -
 3 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 1fef524..e12b1a6 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -368,6 +368,7 @@ int iwlagn_tx_skb(struct iwl_priv *priv,
 		goto drop_unlock_priv;
 
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
+	dev_cmd->hdr.cmd = REPLY_TX;
 	tx_cmd = (struct iwl_tx_cmd *) dev_cmd->payload;
 
 	/* Total # bytes to be transmitted */
diff --git a/drivers/net/wireless/iwlwifi/mvm/tx.c b/drivers/net/wireless/iwlwifi/mvm/tx.c
index 43d97c3..1f19458 100644
--- a/drivers/net/wireless/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/tx.c
@@ -276,6 +276,7 @@ iwl_mvm_set_tx_params(struct iwl_mvm *mvm, struct sk_buff *skb,
 		return NULL;
 
 	memset(dev_cmd, 0, sizeof(*dev_cmd));
+	dev_cmd->hdr.cmd = TX_CMD;
 	tx_cmd = (struct iwl_tx_cmd *)dev_cmd->payload;
 
 	if (info->control.hw_key)
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 059c5ac..487a517 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -1674,7 +1674,6 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	txq->entries[q->write_ptr].skb = skb;
 	txq->entries[q->write_ptr].cmd = dev_cmd;
 
-	dev_cmd->hdr.cmd = REPLY_TX;
 	dev_cmd->hdr.sequence =
 		cpu_to_le16((u16)(QUEUE_TO_SEQ(txq_id) |
 			    INDEX_TO_SEQ(q->write_ptr)));
-- 
1.7.9.5

