Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62703 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3HUGEf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 02:04:35 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 3/8] iwlwifi: mvm: properly tell the fw that a STA is awake
Date: Wed, 21 Aug 2013 09:04:21 +0300
Message-Id: <1377065066-13030-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130821_080439_963755_480ACFEE)
In-Reply-To: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1377065066-13030-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 5af01772ee1d6e96849adf728ff837bd71b119c0 upstream.

The firmware API wasn't being used correctly, fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/sta.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index 736b50b..35c8ed5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1296,17 +1296,11 @@ void iwl_mvm_sta_modify_ps_wake(struct iwl_mvm *mvm,
 	struct iwl_mvm_add_sta_cmd cmd = {
 		.add_modify = STA_MODE_MODIFY,
 		.sta_id = mvmsta->sta_id,
-		.modify_mask = STA_MODIFY_SLEEPING_STA_TX_COUNT,
-		.sleep_state_flags = cpu_to_le16(STA_SLEEP_STATE_AWAKE),
+		.station_flags_msk = cpu_to_le32(STA_FLG_PS),
 		.mac_id_n_color = cpu_to_le32(mvmsta->mac_id_n_color),
 	};
 	int ret;
 
-	/*
-	 * Same modify mask for sleep_tx_count and sleep_state_flags but this
-	 * should be fine since if we set the STA as "awake", then
-	 * sleep_tx_count is not relevant.
-	 */
 	ret = iwl_mvm_send_cmd_pdu(mvm, ADD_STA, CMD_ASYNC, sizeof(cmd), &cmd);
 	if (ret)
 		IWL_ERR(mvm, "Failed to send ADD_STA command (%d)\n", ret);
-- 
1.7.10.4

