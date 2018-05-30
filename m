Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46902 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752834AbeE3HUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:20:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Golan Ben Ami <golan.ben.ami@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:19:56 +0300
Message-Id: <20180530072005.633-2-luca@coelho.fi> (sfid-20180530_092019_551167_DB11340E)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 01/10] iwlwifi: add csr configuration for 6300 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Golan Ben Ami <golan.ben.ami@intel.com>

Recently we have switched the csr addresses and values configuration
from a single configuration to all devices to a per-device configuration.
Doing that, the configuration for 6300 devices wasn't set.
This missing definition introduced a kernel panic once trying to access
the csr's.

Add the missing 6300 csr configuration.

While at it, add a checker that the csr values were indeed
configured, and bail out more gracefully if not.

Fixes: a8cbb46f831d ("iwlwifi: allow different csr flags for different device families")
Signed-off-by: Golan Ben Ami <golan.ben.ami@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/6000.c | 1 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
index 51cec0bb75fc..dbcec7ce7863 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/6000.c
@@ -373,6 +373,7 @@ const struct iwl_cfg iwl6000_3agn_cfg = {
 	.eeprom_params = &iwl6000_eeprom_params,
 	.ht_params = &iwl6000_ht_params,
 	.led_mode = IWL_LED_BLINK,
+	.csr = &iwl_csr_v1,
 };
 
 MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 959de2f8bb28..38234bda9017 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -836,6 +836,9 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct iwl_trans *iwl_trans;
 	int ret;
 
+	if (WARN_ONCE(!cfg->csr, "CSR addresses aren't configured\n"))
+		return -EINVAL;
+
 	iwl_trans = iwl_trans_pcie_alloc(pdev, ent, cfg);
 	if (IS_ERR(iwl_trans))
 		return PTR_ERR(iwl_trans);
-- 
2.17.0
