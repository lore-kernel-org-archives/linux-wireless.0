Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41520 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751012AbdHAJks (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Aug 2017 05:40:48 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  1 Aug 2017 12:40:35 +0300
Message-Id: <20170801094039.22349-5-luca@coelho.fi> (sfid-20170801_114107_130281_859CF95C)
In-Reply-To: <20170801094039.22349-1-luca@coelho.fi>
References: <20170801094039.22349-1-luca@coelho.fi>
Subject: [PATCH 4/8] iwlwifi: mvm: set A-MPDU bit upon empty BA notification from FW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

The bit was set only if there was at least one reclaimed frame in an
aggregation. It's important to set it also in the case that the whole
A-MPDU was lost, otherwise rate scaling statistics will not be
updated correctly. Thus, set it always in ba notification handler.

This fixes a throughput degradation of about 20% in certain scenarios
with multiple streams on 11ac.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index e5d3eba2e82a..5fcc9dd6be56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1821,6 +1821,8 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 	struct iwl_mvm_tid_data *tid_data;
 	struct iwl_mvm_sta *mvmsta;
 
+	ba_info.flags = IEEE80211_TX_STAT_AMPDU;
+
 	if (iwl_mvm_has_new_tx_api(mvm)) {
 		struct iwl_mvm_compressed_ba_notif *ba_res =
 			(void *)pkt->data;
-- 
2.13.2
