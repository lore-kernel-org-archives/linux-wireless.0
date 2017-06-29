Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36260 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753234AbdF2Sam (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:30:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:20 +0300
Message-Id: <20170629183027.15408-9-luca@coelho.fi> (sfid-20170629_203055_663434_7C3A3BB9)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 08/15] iwlwifi: pcie: reconfigure MSI-X HW on resume
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When going into suspend, the HW configuration for MSI-X will
likely be lost. As a consequence, after waking up, all IRQ
causes will be mapped to interrupt 0, and as a consequence we
don't notice the interrupt because in most cases this is an
interrupt for a queue, and getting it doesn't read the other
cause registers.

Fixes: 2e5d4a8f61dc ("iwlwifi: pcie: Add new configuration to enable MSIX")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 3ca0f374c081..f16c1bb9bf94 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -799,6 +799,9 @@ static int iwl_pci_resume(struct device *device)
 	if (!trans->op_mode)
 		return 0;
 
+	/* reconfigure the MSI-X mapping to get the correct IRQ for rfkill */
+	iwl_pcie_conf_msix_hw(trans_pcie);
+
 	/*
 	 * Enable rfkill interrupt (in order to keep track of the rfkill
 	 * status). Must be locked to avoid processing a possible rfkill
-- 
2.11.0
