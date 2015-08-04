Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691AbbHDU7G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:06 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 16/37] iwlwifi: pcie: don't warn on long MPDUs when supported
Date: Tue,  4 Aug 2015 23:43:06 +0300
Message-Id: <1438721007-23283-16-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_225913_832980_E9C0FC7D)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In iwlmvm firmwares, the Byte count written in the scheduler
byte count table is in DWORDs and not in bytes.
We should check that this value fits in the 12 bits and
the value can be either in bits of in DWORD or bytes
depending on the firmware. Check the value after the
translation to DWORDs is done (if needed).

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/tx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index c6572ff..90d02d5 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -219,8 +219,6 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 
 	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
 
-	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
-
 	sta_id = tx_cmd->sta_id;
 	sec_ctl = tx_cmd->sec_ctl;
 
@@ -239,6 +237,9 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 	if (trans_pcie->bc_table_dword)
 		len = DIV_ROUND_UP(len, 4);
 
+	if (WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX))
+		return;
+
 	bc_ent = cpu_to_le16(len | (sta_id << 12));
 
 	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
-- 
2.1.4

