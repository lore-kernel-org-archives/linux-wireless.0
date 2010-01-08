Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:29219 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456Ab0AHSEp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 13:04:45 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/4] iwlwifi: fix bug in tx byte count table
Date: Fri,  8 Jan 2010 10:04:44 -0800
Message-Id: <1262973884-2551-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
References: <1262973884-2551-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

When setting invalid byte count in txq byte count table, read pointer
should be used instead of write pointer.

Reported-by: Guo, Chaohong <chaohong.guo@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ec6b276..c3f8ec0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -781,7 +781,7 @@ void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
 		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
@@ -800,12 +800,12 @@ void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 	if (txq_id != IWL_CMD_QUEUE_NUM)
 		sta_id = txq->cmd[read_ptr]->cmd.tx.sta_id;
 
-	bc_ent =  cpu_to_le16(1 | (sta_id << 12));
+	bc_ent = cpu_to_le16(1 | (sta_id << 12));
 	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
 		scd_bc_tbl[txq_id].
-			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] =  bc_ent;
+			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] = bc_ent;
 }
 
 static int iwl5000_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
-- 
1.5.6.3

