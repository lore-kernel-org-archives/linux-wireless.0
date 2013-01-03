Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab3ACOpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 09:45:51 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/12] iwlwifi: make the BC table layout configurable
Date: Thu,  3 Jan 2013 15:46:05 +0100
Message-Id: <1357224376-27803-1-git-send-email-johannes@sipsolutions.net> (sfid-20130103_154553_909440_E66F3536)
In-Reply-To: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
References: <1357224324.9741.20.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This is needed for newer NICs.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans.h     | 3 +++
 drivers/net/wireless/iwlwifi/pcie/internal.h | 2 ++
 drivers/net/wireless/iwlwifi/pcie/trans.c    | 1 +
 drivers/net/wireless/iwlwifi/pcie/tx.c       | 5 ++++-
 4 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index b76532e..15b4700 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -321,6 +321,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  * @n_no_reclaim_cmds: # of commands in list
  * @rx_buf_size_8k: 8 kB RX buffer size needed for A-MSDUs,
  *	if unset 4k will be the RX buffer size
+ * @bc_table_dword: set to true if the BC table expects the byte count to be
+ *	in DWORD (as opposed to bytes)
  * @queue_watchdog_timeout: time (in ms) after which queues
  *	are considered stuck and will trigger device restart
  * @command_names: array of command names, must be 256 entries
@@ -335,6 +337,7 @@ struct iwl_trans_config {
 	int n_no_reclaim_cmds;
 
 	bool rx_buf_size_8k;
+	bool bc_table_dword;
 	unsigned int queue_watchdog_timeout;
 	const char **command_names;
 };
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index d91d2e8..15f7975 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -234,6 +234,7 @@ struct iwl_txq {
  * @status - transport specific status flags
  * @cmd_queue - command queue number
  * @rx_buf_size_8k: 8 kB RX buffer size
+ * @bc_table_dword: true if the BC table expects DWORD (as opposed to bytes)
  * @rx_page_order: page order for receive buffer size
  * @wd_timeout: queue watchdog timeout (jiffies)
  */
@@ -279,6 +280,7 @@ struct iwl_trans_pcie {
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 
 	bool rx_buf_size_8k;
+	bool bc_table_dword;
 	u32 rx_page_order;
 
 	const char **command_names;
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 35708b9..ab179ce 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -703,6 +703,7 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 		msecs_to_jiffies(trans_cfg->queue_watchdog_timeout);
 
 	trans_pcie->command_names = trans_cfg->command_names;
+	trans_pcie->bc_table_dword = trans_cfg->bc_table_dword;
 }
 
 void iwl_trans_pcie_free(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 6c5b867..7af8f0b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -237,7 +237,10 @@ static void iwl_pcie_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 		break;
 	}
 
-	bc_ent = cpu_to_le16((len & 0xFFF) | (sta_id << 12));
+	if (trans_pcie->bc_table_dword)
+		len = DIV_ROUND_UP(len, 4);
+
+	bc_ent = cpu_to_le16(len | (sta_id << 12));
 
 	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
-- 
1.8.0

