Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47950 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726722AbeIIO0M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Sep 2018 10:26:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Rajat Jain <rajatja@google.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sun,  9 Sep 2018 12:36:44 +0300
Message-Id: <20180909093656.10194-5-luca@coelho.fi> (sfid-20180909_113709_478765_BA0D05B6)
In-Reply-To: <20180909093656.10194-1-luca@coelho.fi>
References: <20180909093656.10194-1-luca@coelho.fi>
Subject: [PATCH 04/16] iwlwifi: pcie: Fail fast if HW is inaccessible at probe
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajat Jain <rajatja@google.com>

If the HW is not responding at probe time, fail immediately complaining
about it. Without this, we see that the kernel spends > 100ms trying to
load firmware (even gives an incorrect impression that it actually
loaded a firmware) and do unnecesary processing before concluding that
the device is not accessible:

 INFO kernel: [   34.092678] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
 WARNING kernel: [   34.093560] iwlwifi 0000:01:00.0: Direct firmware load for iwl-dbg-cfg.ini failed with error -2
 INFO kernel: [   34.111523] iwlwifi 0000:01:00.0: loaded firmware version 17.318154.0 op_mode iwlmvm
 INFO kernel: [   34.173250] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band Wireless AC 7265, REV=0xFFFFFFFF
 ERR kernel: [   34.198023] iwlwifi 0000:01:00.0: iwlwifi transaction failed, dumping registers
 ERR kernel: [   34.198044] iwlwifi 0000:01:00.0: iwlwifi device config registers:

Signed-off-by: Rajat Jain <rajatja@google.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index ab0a5a663a6d..a5f51018029a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -3318,6 +3318,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	iwl_disable_interrupts(trans);
 
 	trans->hw_rev = iwl_read32(trans, CSR_HW_REV);
+	if (trans->hw_rev == 0xffffffff) {
+		dev_err(&pdev->dev, "HW_REV=0xFFFFFFFF, PCI issues?\n");
+		ret = -EIO;
+		goto out_no_pci;
+	}
+
 	/*
 	 * In the 8000 HW family the format of the 4 bytes of CSR_HW_REV have
 	 * changed, and now the revision step also includes bit 0-1 (no more
-- 
2.18.0
