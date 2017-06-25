Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34846 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751189AbdFYLMH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Jun 2017 07:12:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun, 25 Jun 2017 14:11:35 +0300
Message-Id: <20170625111158.1792-4-luca@coelho.fi> (sfid-20170625_131219_309744_26DD88AC)
In-Reply-To: <20170625111158.1792-1-luca@coelho.fi>
References: <20170625111158.1792-1-luca@coelho.fi>
Subject: [PATCH 03/26] iwlwifi: pcie: fix command completion name debug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When the command name is printed on command completion, the wrong
group is used, leading to the wrong name being printed. Fix this
by using the group ID without inappropriately mangling it through
iwl_cmd_groupid() - it's already a u8. Also, while at it, use it
from the same place as the command ID, everything else is just
confusing.

Fixes: ab02165ccec4 ("iwlwifi: add wide firmware command infrastructure for TX")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index be38dd3a6d93..6b19ccc0ae41 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1706,7 +1706,7 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
-	u8 group_id = iwl_cmd_groupid(pkt->hdr.group_id);
+	u8 group_id;
 	u32 cmd_id;
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
@@ -1732,6 +1732,7 @@ void iwl_pcie_hcmd_complete(struct iwl_trans *trans,
 	cmd_index = get_cmd_index(txq, index);
 	cmd = txq->entries[cmd_index].cmd;
 	meta = &txq->entries[cmd_index].meta;
+	group_id = cmd->hdr.group_id;
 	cmd_id = iwl_cmd_id(cmd->hdr.cmd, group_id, 0);
 
 	iwl_pcie_tfd_unmap(trans, meta, txq, index);
-- 
2.11.0
