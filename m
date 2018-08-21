Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42880 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727193AbeHUJz7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:59 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Matt Chen <matt.chen@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:51 +0300
Message-Id: <20180821063657.30071-10-luca@coelho.fi> (sfid-20180821_083712_594094_4FBE95DC)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 09/15] iwlwifi: pcie: avoid unnecessary work if NIC is disconnected
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matt Chen <matt.chen@intel.com>

When the NIC is disconnected from PCI bus, we are not
able to access it anymore. Check the status to avoid
some unnecessary work so can improve the performance.
It will help to make PCI bus rescan to bring back the
device much faster.

The real test is able to improve 7 seconds.

[w/o patch] It takes around 9 seconds
..
2018-04-20T01:22:39.691929-07:00 WARNING kernel:
[   66.335881] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
..
2018-04-20T01:22:48.101094-07:00 INFO kernel:
[   74.747364] iwlwifi 0000:01:00.0: loaded firmware version 29.610311.0 op_mode iwlmvm

[w/a patch] It takes about 2 seconds.
..
2018-04-20T01:18:16.454087-07:00 WARNING kernel:
[   75.966860] Timeout waiting for hardware access (CSR_GP_CNTRL 0xffffffff)
..
2018-04-20T01:18:18.602717-07:00 INFO kernel:
[   78.116132] iwlwifi 0000:01:00.0: loaded firmware version 29.610311.0 op_mode iwlmvm
..

Fixes: 49564a806fc5 ("iwlwifi: pcie: remove non-responsive device")
Signed-off-by: Matt Chen <matt.chen@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c |  4 ++++
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c    | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 631f0015102b..cf7d1acc8e7a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2266,6 +2266,10 @@ static int iwl_trans_pcie_wait_txq_empty(struct iwl_trans *trans, int txq_idx)
 	unsigned long now = jiffies;
 	u8 wr_ptr;
 
+	/* Make sure the NIC is still alive in the bus */
+	if (trans_pcie->scheduled_for_removal)
+		return -EIO;
+
 	if (!test_bit(txq_idx, trans_pcie->queue_used))
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index debff193016e..d5aba9ebd84a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -1188,6 +1188,10 @@ static int iwl_pcie_set_cmd_in_flight(struct iwl_trans *trans,
 
 	lockdep_assert_held(&trans_pcie->reg_lock);
 
+	/* Make sure the NIC is still alive in the bus */
+	if (trans_pcie->scheduled_for_removal)
+		return -EIO;
+
 	if (!(cmd->flags & CMD_SEND_IN_IDLE) &&
 	    !trans_pcie->ref_cmd_in_flight) {
 		trans_pcie->ref_cmd_in_flight = true;
@@ -1957,6 +1961,12 @@ static int iwl_pcie_send_hcmd_sync(struct iwl_trans *trans,
 
 int iwl_trans_pcie_send_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+
+	/* Make sure the NIC is still alive in the bus */
+	if (trans_pcie->scheduled_for_removal)
+		return -EIO;
+
 	if (!(cmd->flags & CMD_SEND_IN_RFKILL) &&
 	    test_bit(STATUS_RFKILL_OPMODE, &trans->status)) {
 		IWL_DEBUG_RF_KILL(trans, "Dropping CMD 0x%x: RF KILL\n",
-- 
2.18.0
