Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZFZRxq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2009 13:53:46 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: always print buffer when error condition occurs
Date: Fri, 26 Jun 2009 11:00:55 -0700
Message-Id: <1246039255-2195-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1246039255-2195-3-git-send-email-reinette.chatre@intel.com>
References: <1246039255-2195-1-git-send-email-reinette.chatre@intel.com>
 <1246039255-2195-2-git-send-email-reinette.chatre@intel.com>
 <1246039255-2195-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

We want to see the buffer contents when the error occurs without
needing to set any debug flags.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 85ae7a6..5d1d6c3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1108,7 +1108,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		  txq_id, sequence,
 		  priv->txq[IWL_CMD_QUEUE_NUM].q.read_ptr,
 		  priv->txq[IWL_CMD_QUEUE_NUM].q.write_ptr)) {
-		iwl_print_hex_dump(priv, IWL_DL_INFO , rxb, 32);
+		iwl_print_hex_error(priv, rxb, 32);
 		return;
 	}
 
-- 
1.5.6.3

