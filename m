Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:35228 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750731AbeCPLvt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Mar 2018 07:51:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 16 Mar 2018 13:51:34 +0200
Message-Id: <20180316115136.1234-4-luca@coelho.fi> (sfid-20180316_125153_542979_D99D255E)
In-Reply-To: <20180316115136.1234-1-luca@coelho.fi>
References: <20180316115136.1234-1-luca@coelho.fi>
Subject: [PATCH 3/5] iwlwifi: mvm: make sure internal station has a valid id
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

If the driver failed to resume from D3, it is possible that it has
no valid aux station. In such case, fw restart will end up in sending
station related commands with an invalid station id, which will
result in an assert.

Fix this by allocating a new station id for the aux station if it
does not have a valid id even in the case of fw restart.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 0b3a780aee12..fc13f6291c06 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -1695,7 +1695,8 @@ int iwl_mvm_allocate_int_sta(struct iwl_mvm *mvm,
 			     u32 qmask, enum nl80211_iftype iftype,
 			     enum iwl_sta_type type)
 {
-	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status)) {
+	if (!test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status) ||
+	    sta->sta_id == IWL_MVM_INVALID_STA) {
 		sta->sta_id = iwl_mvm_find_free_sta_id(mvm, iftype);
 		if (WARN_ON_ONCE(sta->sta_id == IWL_MVM_INVALID_STA))
 			return -ENOSPC;
-- 
2.16.2
