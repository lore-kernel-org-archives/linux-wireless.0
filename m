Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60644 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751298AbdFBJfv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Jun 2017 05:35:51 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Jun 2017 12:35:14 +0300
Message-Id: <20170602093516.16369-9-luca@coelho.fi> (sfid-20170602_113610_043378_A161BF62)
In-Reply-To: <20170602093516.16369-1-luca@coelho.fi>
References: <20170602093516.16369-1-luca@coelho.fi>
Subject: [PATCH 08/10] iwlwifi: mvm: clear new beacon command template struct
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clear the struct so that all reserved fields are zero when we
send the struct down to the device.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 0f1831b41915..fd2fc46e2fe5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1040,7 +1040,7 @@ static int iwl_mvm_mac_ctxt_send_beacon(struct iwl_mvm *mvm,
 		struct iwl_mac_beacon_cmd_v6 beacon_cmd_v6;
 		struct iwl_mac_beacon_cmd_v7 beacon_cmd;
 	} u = {};
-	struct iwl_mac_beacon_cmd beacon_cmd;
+	struct iwl_mac_beacon_cmd beacon_cmd = {};
 	struct ieee80211_tx_info *info;
 	u32 beacon_skb_len;
 	u32 rate, tx_flags;
-- 
2.11.0
