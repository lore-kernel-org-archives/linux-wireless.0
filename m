Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60752 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751230AbdFBL0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 07:26:16 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 14:25:35 +0300
Message-Id: <20170602112553.2466-8-luca@coelho.fi> (sfid-20170602_132639_252723_5E4E039B)
In-Reply-To: <20170602112553.2466-1-luca@coelho.fi>
References: <20170602112553.2466-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: fix MCC endianness bug
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index c69aff91404b..8e4919a27cc7 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -1681,7 +1681,7 @@ struct iwl_mcc_update_resp {
  * @reserved1: reserved for alignment
  */
 struct iwl_mcc_chub_notif {
-	u16 mcc;
+	__le16 mcc;
 	u8 source_id;
 	u8 reserved1;
 } __packed; /* LAR_MCC_NOTIFY_S */
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 67a6c9c9af27..e7b16ecccb86 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -913,8 +913,8 @@ void iwl_mvm_rx_chub_update_mcc(struct iwl_mvm *mvm,
 	if (WARN_ON_ONCE(!iwl_mvm_is_lar_supported(mvm)))
 		return;
 
-	mcc[0] = notif->mcc >> 8;
-	mcc[1] = notif->mcc & 0xff;
+	mcc[0] = le16_to_cpu(notif->mcc) >> 8;
+	mcc[1] = le16_to_cpu(notif->mcc) & 0xff;
 	mcc[2] = '\0';
 	src = notif->source_id;
 
-- 
2.11.0
