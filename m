Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37362 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781AbbHDU7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 16:59:05 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/37] iwlwifi: pcie: cancel Tx timer upon firmware crash
Date: Tue,  4 Aug 2015 23:43:04 +0300
Message-Id: <1438721007-23283-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150804_230039_116509_9959430F)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E7E11FA@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the firmware crashes, we can't expect the Tx queues to
progress. Cancel their timer.

Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/rx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/iwlwifi/pcie/rx.c b/drivers/net/wireless/iwlwifi/pcie/rx.c
index 32ec95b..5561dee 100644
--- a/drivers/net/wireless/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/rx.c
@@ -1014,6 +1014,7 @@ restart:
 static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i;
 
 	/* W/A for WiFi/WiMAX coex and WiMAX own the RF */
 	if (trans->cfg->internal_wimax_coex &&
@@ -1037,6 +1038,9 @@ static void iwl_pcie_irq_handle_error(struct iwl_trans *trans)
 	iwl_trans_fw_error(trans);
 	local_bh_enable();
 
+	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++)
+		del_timer(&trans_pcie->txq[i].stuck_timer);
+
 	clear_bit(STATUS_SYNC_HCMD_ACTIVE, &trans->status);
 	wake_up(&trans_pcie->wait_command_queue);
 }
-- 
2.1.4

