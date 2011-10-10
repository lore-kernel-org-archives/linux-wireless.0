Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54032 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751034Ab1JJPQ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 11:16:26 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/34] iwlagn: add cmd queue pointer info when timeout
Date: Mon, 10 Oct 2011 07:26:46 -0700
Message-Id: <1318256839-31837-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111010_171631_514879_58FA04B3)
In-Reply-To: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318256839-31837-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When detect cmd queue time out, display the current read/write pointer

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index ee7059d..f57b868 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -1013,11 +1013,20 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
 		if (test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status)) {
+			struct iwl_priv *priv = priv(trans);
+			struct iwl_tx_queue *txq =
+				&trans_pcie->txq[priv->shrd->cmd_queue];
+			struct iwl_queue *q = &txq->q;
+
 			IWL_ERR(trans,
 				"Error sending %s: time out after %dms.\n",
 				get_cmd_string(cmd->id),
 				jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
 
+			IWL_ERR(trans,
+				"Current CMD queue read_ptr %d write_ptr %d\n",
+				q->read_ptr, q->write_ptr);
+
 			clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 			IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command"
 				 "%s\n", get_cmd_string(cmd->id));
-- 
1.7.0.4

