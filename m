Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34262 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753770AbdFVVVN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:21:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:43 +0300
Message-Id: <20170622212101.16422-8-luca@coelho.fi> (sfid-20170622_232154_568908_5949DF5C)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: pcie: fix TVQM queue ID range check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The queue ID should never be 512 either, so correct the check
to be >= instead of just >.

Fixes: 310181ec34e2 ("iwlwifi: move to TVQM mode")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index 6e186501f43c..8f00019cd3b4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -1076,7 +1076,7 @@ int iwl_trans_pcie_dyn_txq_alloc(struct iwl_trans *trans,
 	rsp = (void *)hcmd.resp_pkt->data;
 	qid = le16_to_cpu(rsp->queue_number);
 
-	if (qid > ARRAY_SIZE(trans_pcie->txq)) {
+	if (qid >= ARRAY_SIZE(trans_pcie->txq)) {
 		WARN_ONCE(1, "queue index %d unsupported", qid);
 		ret = -EIO;
 		goto error_free_resp;
-- 
2.11.0
