Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27587 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928AbbLAJ7P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 04:59:15 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avraham Stern <avraham.stern@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 05/41] iwlwifi: mvm: Configure fragmented scan for scheduled scan
Date: Tue,  1 Dec 2015 11:58:31 +0200
Message-Id: <1448963947-24302-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_110401_557234_CF059C0B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

Configure the FW to use fragmented scan when the traffic load is high
or low latency traffic is on. This is useful for scans that are
managed by the FW (e.g. scheduled scan).

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h  | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 7 ++++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 4bde2d0..419afa4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -643,6 +643,7 @@ struct iwl_mvm {
 	unsigned int scan_status;
 	void *scan_cmd;
 	struct iwl_mcast_filter_cmd *mcast_filter_cmd;
+	bool scan_fragmented;
 
 	/* max number of simultaneous scans the FW supports */
 	unsigned int max_scans;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index d6e0c1b..6b9b190 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -920,6 +920,8 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 	if (!scan_config)
 		return -ENOMEM;
 
+	mvm->scan_fragmented = iwl_mvm_low_latency(mvm);
+
 	scan_config->flags = cpu_to_le32(SCAN_CONFIG_FLAG_ACTIVATE |
 					 SCAN_CONFIG_FLAG_ALLOW_CHUB_REQS |
 					 SCAN_CONFIG_FLAG_SET_TX_CHAINS |
@@ -928,7 +930,10 @@ int iwl_mvm_config_scan(struct iwl_mvm *mvm)
 					 SCAN_CONFIG_FLAG_SET_LEGACY_RATES |
 					 SCAN_CONFIG_FLAG_SET_MAC_ADDR |
 					 SCAN_CONFIG_FLAG_SET_CHANNEL_FLAGS|
-					 SCAN_CONFIG_N_CHANNELS(num_channels));
+					 SCAN_CONFIG_N_CHANNELS(num_channels) |
+					 (mvm->scan_fragmented ?
+					  SCAN_CONFIG_FLAG_SET_FRAGMENTED :
+					  SCAN_CONFIG_FLAG_CLEAR_FRAGMENTED));
 	scan_config->tx_chains = cpu_to_le32(iwl_mvm_get_valid_tx_ant(mvm));
 	scan_config->rx_chains = cpu_to_le32(iwl_mvm_scan_rx_ant(mvm));
 	scan_config->legacy_rates = iwl_mvm_scan_config_rates(mvm);
-- 
2.5.0

