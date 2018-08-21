Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42916 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727167AbeHUJ4K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Aug 2018 05:56:10 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 21 Aug 2018 09:36:57 +0300
Message-Id: <20180821063657.30071-16-luca@coelho.fi> (sfid-20180821_083732_253260_891E608B)
In-Reply-To: <20180821063657.30071-1-luca@coelho.fi>
References: <20180821063657.30071-1-luca@coelho.fi>
Subject: [PATCH 15/15] iwlwifi: pcie: set interrupt coalescing also for gen2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

We offloaded all the RX configuration of init to firmware. However,
the configuration of interrupt coalescing was left hanging - it wasn't
offloaded nor was it written by host.

This write to the CSR is allowed in gen2, so the host can do it.
Without it we have various issues with RX fullness.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
index 8075466aa4c4..7d9a4e5d4926 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1107,6 +1107,9 @@ int iwl_pcie_rx_init(struct iwl_trans *trans)
 
 int iwl_pcie_gen2_rx_init(struct iwl_trans *trans)
 {
+	/* Set interrupt coalescing timer to default (2048 usecs) */
+	iwl_write8(trans, CSR_INT_COALESCING, IWL_HOST_INT_TIMEOUT_DEF);
+
 	/*
 	 * We don't configure the RFH.
 	 * Restock will be done at alive, after firmware configured the RFH.
-- 
2.18.0
