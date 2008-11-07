Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:31244 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbYKGR6T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:19 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/13] iwlwifi: get some more information about command failure
Date: Fri,  7 Nov 2008 09:58:45 -0800
Message-Id: <1226080726-24860-13-git-send-email-reinette.chatre@intel.com> (sfid-20081107_190901_683948_13671A2B)
In-Reply-To: <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-7-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-8-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-9-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-10-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-11-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-12-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch adds additional info about wrong command queue bug

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 1ae93bc..8d25781 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1262,8 +1262,13 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
 	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
-		 "wrong command queue %d, command id 0x%X\n", txq_id, pkt->hdr.cmd))
+		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
 		return;
+	}
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-- 
1.5.4.3

