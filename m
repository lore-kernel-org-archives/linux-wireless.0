Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60792 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751126AbdFBL0Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:25 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:36 +0300
Message-Id: <20170602112553.2466-9-luca@coelho.fi> (sfid-20170602_132640_370479_02CEED5B)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 08/25] iwlwifi: mvm: use u8 for reserved fields
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no saying what kind of type a reserved field will
get in the future, so use u8 arrays to reserve space.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h       | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
index 6371c342b96d..809ec1ba5025 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
@@ -72,7 +72,7 @@ struct mvm_statistics_dbg {
 	__le32 burst_check;
 	__le32 burst_count;
 	__le32 wait_for_silence_timeout_cnt;
-	__le32 reserved[3];
+	u8 reserved[12];
 } __packed; /* STATISTICS_DEBUG_API_S_VER_2 */
 
 struct mvm_statistics_div {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 8e4919a27cc7..69f3065ba600 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -1612,7 +1612,7 @@ struct iwl_mcc_update_cmd {
 	u8 source_id;
 	u8 reserved;
 	__le32 key;
-	__le32 reserved2[5];
+	u8 reserved2[20];
 } __packed; /* LAR_UPDATE_MCC_CMD_API_S_VER_2 */
 
 /**
@@ -2196,7 +2196,7 @@ struct iwl_link_qual_msrmnt_notif {
 	__le32 tx_frame_dropped;
 	__le32 mac_id;
 	__le32 status;
-	__le32 reserved[3];
+	u8 reserved[12];
 } __packed; /* LQM_MEASUREMENT_COMPLETE_NTF_API_S_VER1 */
 
 /**
-- 
2.11.0
