Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52684 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753326AbdDRWRm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:17:42 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:05 +0300
Message-Id: <20170418221729.28372-2-luca@coelho.fi> (sfid-20170419_001753_003144_51F5C925)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 01/25] iwlwifi: mvm: remove unnecessary label in iwl_mvm_handle_rx_statistics()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The "invalid" label was a bit ugly and unnecessary.  Remove it.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 655bd1384158..eab6e2ad62e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -660,8 +660,11 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 	else
 		expected_size = sizeof(struct iwl_notif_statistics_v10);
 
-	if (iwl_rx_packet_payload_len(pkt) != expected_size)
-		goto invalid;
+	if (iwl_rx_packet_payload_len(pkt) != expected_size) {
+		IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
+			iwl_rx_packet_payload_len(pkt));
+		return;
+	}
 
 	data.mac_id = stats->rx.general.mac_id;
 	data.beacon_filter_average_energy =
@@ -714,12 +717,6 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		sta->avg_energy = energy[i];
 	}
 	rcu_read_unlock();
-
-	return;
-
- invalid:
-	IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
-		iwl_rx_packet_payload_len(pkt));
 }
 
 void iwl_mvm_rx_statistics(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
-- 
2.11.0
