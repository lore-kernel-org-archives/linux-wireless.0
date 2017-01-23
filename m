Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36258 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751762AbdAWWSY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:18:24 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:40 +0200
Message-Id: <20170123220350.25305-16-luca@coelho.fi> (sfid-20170123_231826_415110_C9E8814E)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH 15/25] iwlwifi: mvm: remove unused variable in iwl_mvm_handle_statistics()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

The temperature variable is set but not used in
iwl_mvm_handle_statistics().  Remove it to avoid the following
compiler warning when W=1 is used:

/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/rx.c: In function ‘iwl_mvm_handle_rx_statistics’:
/home/luca/iwlwifi/stack-dev/drivers/net/wireless/intel/iwlwifi/mvm/rx.c:759:6: warning: variable ‘temperature’ set but not used [-Wunused-but-set-variable]
  u32 temperature;
      ^

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 0e60e38b2acf..e16687d5afaa 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -621,12 +621,10 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 	};
 	int expected_size = iwl_mvm_has_new_rx_api(mvm) ? sizeof(*stats) :
 			    sizeof(struct iwl_notif_statistics_v10);
-	u32 temperature;
 
 	if (iwl_rx_packet_payload_len(pkt) != expected_size)
 		goto invalid;
 
-	temperature = le32_to_cpu(stats->general.radio_temperature);
 	data.mac_id = stats->rx.general.mac_id;
 	data.beacon_filter_average_energy =
 		stats->general.beacon_filter_average_energy;
-- 
2.11.0
