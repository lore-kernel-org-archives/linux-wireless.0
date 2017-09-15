Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Oren Givon <oren.givon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:46:57 +0300
Message-Id: <20170915124704.9032-4-luca@coelho.fi> (sfid-20170915_144724_511913_FEFAA4D5)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 03/10] iwlwifi: fix wrong struct for a000 device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Oren Givon <oren.givon@intel.com>

The PCI ID (0x2720, 0x0070) was set with the config struct
iwla000_2ax_cfg_hr instead of iwla000_2ac_cfg_hr_cdb.

Fixes: 175b87c69253 ("iwlwifi: add the new a000_2ax series")
Signed-off-by: Oren Givon <oren.givon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 858765fed8f8..3416c6155996 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -576,7 +576,7 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2720, 0x0000, iwla000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x34F0, 0x0070, iwla000_2ax_cfg_hr)},
 	{IWL_PCI_DEVICE(0x2720, 0x0078, iwla000_2ax_cfg_hr)},
-	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ax_cfg_hr)},
+	{IWL_PCI_DEVICE(0x2720, 0x0070, iwla000_2ac_cfg_hr_cdb)},
 	{IWL_PCI_DEVICE(0x2720, 0x1080, iwla000_2ax_cfg_hr)},
 #endif /* CONFIG_IWLMVM */
 
-- 
2.14.1
