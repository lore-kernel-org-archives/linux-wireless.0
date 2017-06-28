Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35828 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751661AbdF1UN6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 16:13:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Jun 2017 23:13:09 +0300
Message-Id: <20170628201330.9432-11-luca@coelho.fi> (sfid-20170628_221414_072082_540895DE)
In-Reply-To: <20170628201330.9432-1-luca@coelho.fi>
References: <20170628201330.9432-1-luca@coelho.fi>
Subject: [PATCH 10/31] iwlwifi: pcie: only apply retention workaround on 9000-series A-step
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Due to a hardware issue, certain power saving had to be
disabled. However, this issue was fixed in B-step, so the
workaround only needs to apply to A-step.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index a5c0f69423d2..cd109740632d 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -761,6 +761,15 @@ static void iwl_pcie_rx_hw_init(struct iwl_trans *trans, struct iwl_rxq *rxq)
 
 void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable)
 {
+	if (trans->cfg->device_family != IWL_DEVICE_FAMILY_9000)
+		return;
+
+	if (CSR_HW_REV_STEP(trans->hw_rev) != SILICON_A_STEP)
+		return;
+
+	if (!trans->cfg->integrated)
+		return;
+
 	/*
 	 * Turn on the chicken-bits that cause MAC wakeup for RX-related
 	 * values.
@@ -768,12 +777,10 @@ void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable)
 	 * bug where shadow registers are not in the retention list and their
 	 * value is lost when NIC powers down
 	 */
-	if (trans->cfg->integrated) {
-		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
-			    CSR_MAC_SHADOW_REG_CTRL_RX_WAKE);
-		iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTL2,
-			    CSR_MAC_SHADOW_REG_CTL2_RX_WAKE);
-	}
+	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTRL,
+		    CSR_MAC_SHADOW_REG_CTRL_RX_WAKE);
+	iwl_set_bit(trans, CSR_MAC_SHADOW_REG_CTL2,
+		    CSR_MAC_SHADOW_REG_CTL2_RX_WAKE);
 }
 
 static void iwl_pcie_rx_mq_hw_init(struct iwl_trans *trans)
-- 
2.11.0
