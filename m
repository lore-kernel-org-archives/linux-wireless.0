Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51690 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753329AbdDNJCi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2017 05:02:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 14 Apr 2017 12:01:50 +0300
Message-Id: <20170414090210.31397-7-luca@coelho.fi> (sfid-20170414_110246_386958_EBB92E15)
In-Reply-To: <20170414090210.31397-1-luca@coelho.fi>
References: <20170414090210.31397-1-luca@coelho.fi>
Subject: [PATCH v2 06/26] iwlwifi: mvm: disable multi-queue for a000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Firmware isn't configuring multi RX queue hardware yet in
the self init mode.
Disable it for now until we have an API that enables it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 61cafb541554..4c5088643b2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1240,7 +1240,8 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	}
 
 	/* Init RSS configuration */
-	if (iwl_mvm_has_new_rx_api(mvm)) {
+	/* TODO - remove a000 disablement when we have RXQ config API */
+	if (iwl_mvm_has_new_rx_api(mvm) && !iwl_mvm_has_new_tx_api(mvm)) {
 		ret = iwl_send_rss_cfg_cmd(mvm);
 		if (ret) {
 			IWL_ERR(mvm, "Failed to configure RSS queues: %d\n",
-- 
2.11.0
