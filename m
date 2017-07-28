Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:40886 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752163AbdG1OYM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:12 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 28 Jul 2017 17:23:22 +0300
Message-Id: <20170728142337.19183-10-luca@coelho.fi> (sfid-20170728_162428_479036_F5874FE5)
In-Reply-To: <20170728142337.19183-1-luca@coelho.fi>
References: <20170728142337.19183-1-luca@coelho.fi>
Subject: [PATCH 09/24] iwlwifi: mvm: byte-swap constant instead of variable
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Convention has it to byte-swap the constant instead of the variable
when doing bit checks. This also generates better code when the swap
is actually needed, since the constant can be swapped at compile-time.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index 13733252c1fb..6b8e57b7234a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -851,7 +851,7 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 
 	rcu_read_lock();
 
-	if (le16_to_cpu(desc->status) & IWL_RX_MPDU_STATUS_SRC_STA_FOUND) {
+	if (desc->status & cpu_to_le16(IWL_RX_MPDU_STATUS_SRC_STA_FOUND)) {
 		u8 id = desc->sta_id_flags & IWL_RX_MPDU_SIF_STA_ID_MASK;
 
 		if (!WARN_ON_ONCE(id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))) {
-- 
2.13.2
