Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:52920 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756244AbdDRWXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Apr 2017 18:23:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Apr 2017 01:17:29 +0300
Message-Id: <20170418221729.28372-26-luca@coelho.fi> (sfid-20170419_002339_980014_2E0275B8)
In-Reply-To: <20170418221729.28372-1-luca@coelho.fi>
References: <20170418221729.28372-1-luca@coelho.fi>
Subject: [PATCH 25/25] iwlwifi: mvm: allow block ack response without data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When FW fails to get block ack, it will send the notification with
0 items in the TFD queue elements. Allow this and handle accordingly.

Fixes: c46e7724bfe9 ("iwlwifi: mvm: support new BA notification response")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 65308c4ad8b8..a3de91e5e543 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1782,6 +1782,9 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 		ba_info.status.status_driver_data[0] =
 			(void *)(uintptr_t)ba_res->reduced_txp;
 
+		if (!le16_to_cpu(ba_res->tfd_cnt))
+			goto out;
+
 		/*
 		 * TODO:
 		 * When supporting multi TID aggregations - we need to move
@@ -1799,6 +1802,7 @@ void iwl_mvm_rx_ba_notif(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb)
 				   le16_to_cpu(ba_res->tfd[0].tfd_index),
 				   &ba_info, le32_to_cpu(ba_res->tx_rate));
 
+out:
 		IWL_DEBUG_TX_REPLY(mvm,
 				   "BA_NOTIFICATION Received from sta_id = %d, flags %x, sent:%d, acked:%d\n",
 				   sta_id, le32_to_cpu(ba_res->flags),
-- 
2.11.0
