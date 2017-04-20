Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:53154 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S941020AbdDTEff (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 00:35:35 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 20 Apr 2017 07:35:19 +0300
Message-Id: <20170420043519.18615-3-luca@coelho.fi> (sfid-20170420_063640_097221_496A69EE)
In-Reply-To: <20170420043519.18615-1-luca@coelho.fi>
References: <20170420043519.18615-1-luca@coelho.fi>
Subject: [PATCH 2/2] iwlwifi: pcie: free context info in case of failures
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If iwl_pcie_ctxt_info_init_fw_sec() fails, the previous allocated DMA
memory needs to be freed (it even goes out of scope immediately.)
Do that to prevent the leak.

Fixes: eda50cde58de ("iwlwifi: pcie: add context information support")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
index 854d61888f4d..1d95512361b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c
@@ -241,8 +241,11 @@ int iwl_pcie_ctxt_info_init(struct iwl_trans *trans,
 
 	/* allocate ucode sections in dram and set addresses */
 	ret = iwl_pcie_ctxt_info_init_fw_sec(trans, fw, ctxt_info);
-	if (ret)
+	if (ret) {
+		dma_free_coherent(trans->dev, sizeof(*trans_pcie->ctxt_info),
+				  ctxt_info, trans_pcie->ctxt_info_dma_addr);
 		return ret;
+	}
 
 	trans_pcie->ctxt_info = ctxt_info;
 
-- 
2.11.0
