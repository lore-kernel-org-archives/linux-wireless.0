Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114Ab1JJPQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/34] iwlagn: add WARN if tx cmd complete come back late
Date: Mon, 10 Oct 2011 07:26:48 -0700
Message-Id: <1318256839-31837-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171745_132519_3AD25578)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For error condition, STATUS_HCMD_ACTIVE already got clear before receive
tx cmd complete, give warning

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index f57b868..fa2ce39 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -950,6 +950,11 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb,
 	iwl_hcmd_queue_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
+		if (!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+			IWL_WARN(trans,
+				 "HCMD_ACTIVE already clear for command %s\n",
+				 get_cmd_string(cmd->hdr.cmd));
+		}
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-- 
1.7.0.4

