Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42854 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbeHUJz4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:55:56 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:48 +0300
Message-Id: <20180821063657.30071-7-luca@coelho.fi> (sfid-20180821_083714_166269_A0651659)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 06/15] iwlwifi: pcie: make gen2 of apm_init non-static
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

This will allow using the same init in future generations.

Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h   | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index c03de2bc5739..8fdef4a26db4 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -1009,6 +1009,7 @@ void iwl_pcie_enable_rx_wake(struct iwl_trans *trans, bool enable);
 void iwl_pcie_rx_allocator_work(struct work_struct *data);
 
 /* common functions that are used by gen2 transport */
+int iwl_pcie_gen2_apm_init(struct iwl_trans *trans);
 void iwl_pcie_apm_config(struct iwl_trans *trans);
 int iwl_pcie_prepare_card_hw(struct iwl_trans *trans);
 void iwl_pcie_synchronize_irqs(struct iwl_trans *trans);
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
index 3e5c732a89db..9b2a248e88b0 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c
@@ -61,7 +61,7 @@
  * (e.g. after platform boot, or shutdown via iwl_pcie_apm_stop())
  * NOTE:  This does not load uCode nor start the embedded processor
  */
-static int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
+int iwl_pcie_gen2_apm_init(struct iwl_trans *trans)
 {
 	int ret = 0;
 
-- 
2.18.0
