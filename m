Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZASX2Q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:16 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Chatre, Reinette" <reinette.chatre@intel.com>
Subject: [PATCH 04/15] iwl3945: add debugging for wrong command queue
Date: Mon, 19 Jan 2009 15:30:24 -0800
Message-Id: <1232407835-19451-5-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002825_741889_D4B90F72)
In-Reply-To: <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chatre, Reinette <reinette.chatre@intel.com>

We encountered a problem related to this BUG and need to obtain more
debugging information. See bug report at
http://marc.info/?l=linux-wireless&m=123147215829854&w=2

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index b033650..4e581f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3060,7 +3060,14 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 	int cmd_index;
 	struct iwl_cmd *cmd;
 
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, sequence 0x%X readp=%d writep=%d\n",
+		  txq_id, sequence,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
+		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
+		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		return;
+	}
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
-- 
1.5.4.3

