Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39452 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754147AbeDMMnf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Apr 2018 08:43:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 13 Apr 2018 15:42:49 +0300
Message-Id: <20180413124256.21769-19-luca@coelho.fi> (sfid-20180413_144338_039043_FF01CA68)
In-Reply-To: <20180413124256.21769-1-luca@coelho.fi>
References: <20180413124256.21769-1-luca@coelho.fi>
Subject: [PATCH 18/25] iwlwifi: pcie: gen2: fix race in cmd fifo write ptr
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shaul Triebitz <shaul.triebitz@intel.com>

Avoid a race where two (or more) commands get the
same index:

1. T1 calls enqueue_hcmd and the local TFD index is assigned to
   txq->write_ptr;
2. Context switch 'before incrementing txq->write_ptr';
3. T2 calls enqueue_hcmd and the local TFD index is assigned to
   txq->write_ptr;
4. Now the index is set to the same value for both commands of T1 and
   T2.

To prevent this from happening, set the local TFD index inside the
critical section (the index is set by global txq write pointer).

Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index a235dda1f70b..48890a1c825f 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -569,15 +569,13 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 	unsigned long flags;
 	void *dup_buf = NULL;
 	dma_addr_t phys_addr;
-	int i, cmd_pos, idx = iwl_pcie_get_cmd_index(txq, txq->write_ptr);
+	int i, cmd_pos, idx;
 	u16 copy_size, cmd_size, tb0_size;
 	bool had_nocopy = false;
 	u8 group_id = iwl_cmd_groupid(cmd->id);
 	const u8 *cmddata[IWL_MAX_CMD_TBS_PER_TFD];
 	u16 cmdlen[IWL_MAX_CMD_TBS_PER_TFD];
-	struct iwl_tfh_tfd *tfd = iwl_pcie_get_tfd(trans, txq, txq->write_ptr);
-
-	memset(tfd, 0, sizeof(*tfd));
+	struct iwl_tfh_tfd *tfd;
 
 	copy_size = sizeof(struct iwl_cmd_header_wide);
 	cmd_size = sizeof(struct iwl_cmd_header_wide);
@@ -648,6 +646,10 @@ static int iwl_pcie_gen2_enqueue_hcmd(struct iwl_trans *trans,
 
 	spin_lock_bh(&txq->lock);
 
+	idx = iwl_pcie_get_cmd_index(txq, txq->write_ptr);
+	tfd = iwl_pcie_get_tfd(trans, txq, txq->write_ptr);
+	memset(tfd, 0, sizeof(*tfd));
+
 	if (iwl_queue_space(txq) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		spin_unlock_bh(&txq->lock);
 
-- 
2.16.3
