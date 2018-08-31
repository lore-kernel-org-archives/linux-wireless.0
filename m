Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45768 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:11 +0300
Message-Id: <20180831095614.14099-14-luca@coelho.fi> (sfid-20180831_115859_574147_A9C26F22)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 13/16] iwlwifi: pcie: read correct prph address for newer devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For newer devices we have higher range of periphery
addresses. Currently it is masked out, so we end up
reading another address.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 93c336ebfa40..ab0a5a663a6d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1805,18 +1805,30 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
+static u32 iwl_trans_pcie_prph_msk(struct iwl_trans *trans)
+{
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		return 0x00FFFFFF;
+	else
+		return 0x000FFFFF;
+}
+
 static u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_RADDR,
-			       ((reg & 0x000FFFFF) | (3 << 24)));
+			       ((reg & mask) | (3 << 24)));
 	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
 static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
 				      u32 val)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WADDR,
-			       ((addr & 0x000FFFFF) | (3 << 24)));
+			       ((addr & mask) | (3 << 24)));
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-- 
2.18.0
