Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59394 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751335AbdFEUnW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 16:43:22 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Jun 2017 23:42:18 +0300
Message-Id: <20170605204218.30151-26-luca@coelho.fi> (sfid-20170605_224331_052806_B8DAA65D)
In-Reply-To: <20170605204218.30151-1-luca@coelho.fi>
References: <20170605204218.30151-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: remove unnecessary code in iwl_trans_alloc_tx_cmd
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

When we removed dev_cmd_headroom, the check for dev_cmd_ptr == NULL
became unnecessary, since we just return dev_cmd_ptr anyway.  Cleanup
the function to avoid useless code.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index e965285f84f1..a150da3c824b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -908,13 +908,7 @@ iwl_trans_dump_data(struct iwl_trans *trans,
 static inline struct iwl_device_cmd *
 iwl_trans_alloc_tx_cmd(struct iwl_trans *trans)
 {
-	struct iwl_device_cmd *dev_cmd_ptr =
-		kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
-
-	if (unlikely(dev_cmd_ptr == NULL))
-		return NULL;
-
-	return dev_cmd_ptr;
+	return kmem_cache_alloc(trans->dev_cmd_pool, GFP_ATOMIC);
 }
 
 int iwl_trans_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
-- 
2.11.0
